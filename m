Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B6814A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006494; cv=none; b=C3CqqdhXkdrwcqAW7ZOrtpPG71tOeyEYR2eICbkCA9xcsSAi1Kk3yIOUY7Ko8JvKVv8T+7PAX3SWrX+pPPTTlxgVqyYIdx3fOowQ6u0fhmTnWMll7lbHOGc0GXcJsqNEBRoGTq2MpHh3XJOon34ujuzV7wMT6zvbDKTxr0I9+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006494; c=relaxed/simple;
	bh=duLbGGqa5eOQqAPjJT83roA0CXg1yhiUXCJ00D/Dyv4=;
	h=Date:To:From:Subject:Message-Id; b=jqwJw8nmoEpmhKoDCgDyXGCXonXCbBhKzIVPsuPum1C1LcZzt/21CdBXS/kJgn53OFLBQWDxpHOZCdalZ9Cg7Z1Oq49WynSp3EOmYfu9EFHO6JwNpYs+tgvXFKFfNByh7Fok0hmmC1iQioToSNHSY6+02QmpxBknjoVN2pGJGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=svRvzx19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="svRvzx19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D44C4CEDD;
	Thu, 16 Jan 2025 05:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006494;
	bh=duLbGGqa5eOQqAPjJT83roA0CXg1yhiUXCJ00D/Dyv4=;
	h=Date:To:From:Subject:From;
	b=svRvzx19ZjyF6FZ0CdnPDCSIF6xWvn5AWvzMZq+4PXcoqt9V6mXjaOcGay7j0QVjA
	 rtGSl4Tzi18y425UNBduz0GinhA04NYxjAxGeFYtXhRP8JFec/XKRfEgSknLDQv4/7
	 TpnIZre8LNaa5KsWPN6gZMF2JoOjopsqC9Uox8H8=
Date: Wed, 15 Jan 2025 21:48:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-move-forward-index-correctly-in-xas_pause.patch removed from -mm tree
Message-Id: <20250116054814.77D44C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Xarray: move forward index correctly in xas_pause()
has been removed from the -mm tree.  Its filename was
     xarray-move-forward-index-correctly-in-xas_pause.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: move forward index correctly in xas_pause()
Date: Fri, 13 Dec 2024 20:25:20 +0800

After xas_load(), xas->index could point to mid of found multi-index entry
and xas->index's bits under node->shift maybe non-zero.  The afterward
xas_pause() will move forward xas->index with xa->node->shift with bits
under node->shift un-masked and thus skip some index unexpectedly.

Consider following case:
Assume XA_CHUNK_SHIFT is 4.
xa_store_range(xa, 16, 31, ...)
xa_store(xa, 32, ...)
XA_STATE(xas, xa, 17);
xas_for_each(&xas,...)
xas_load(&xas)
/* xas->index = 17, xas->xa_offset = 1, xas->xa_node->xa_shift = 4 */
xas_pause()
/* xas->index = 33, xas->xa_offset = 2, xas->xa_node->xa_shift = 4 */
As we can see, index of 32 is skipped unexpectedly.

Fix this by mask bit under node->xa_shift when move forward index in
xas_pause().

For now, this will not cause serious problems.  Only minor problem like
cachestat return less number of page status could happen.

Link: https://lkml.kernel.org/r/20241213122523.12764-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   35 +++++++++++++++++++++++++++++++++++
 lib/xarray.c      |    1 +
 2 files changed, 36 insertions(+)

--- a/lib/test_xarray.c~xarray-move-forward-index-correctly-in-xas_pause
+++ a/lib/test_xarray.c
@@ -1511,6 +1511,41 @@ static noinline void check_pause(struct
 	XA_BUG_ON(xa, count != order_limit);
 
 	xa_destroy(xa);
+
+	index = 0;
+	for (order = XA_CHUNK_SHIFT; order > 0; order--) {
+		XA_BUG_ON(xa, xa_store_order(xa, index, order,
+					xa_mk_index(index), GFP_KERNEL));
+		index += 1UL << order;
+	}
+
+	index = 0;
+	count = 0;
+	xas_set(&xas, 0);
+	rcu_read_lock();
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		XA_BUG_ON(xa, entry != xa_mk_index(index));
+		index += 1UL << (XA_CHUNK_SHIFT - count);
+		count++;
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, count != XA_CHUNK_SHIFT);
+
+	index = 0;
+	count = 0;
+	xas_set(&xas, XA_CHUNK_SIZE / 2 + 1);
+	rcu_read_lock();
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		XA_BUG_ON(xa, entry != xa_mk_index(index));
+		index += 1UL << (XA_CHUNK_SHIFT - count);
+		count++;
+		xas_pause(&xas);
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, count != XA_CHUNK_SHIFT);
+
+	xa_destroy(xa);
+
 }
 
 static noinline void check_move_tiny(struct kunit *test)
--- a/lib/xarray.c~xarray-move-forward-index-correctly-in-xas_pause
+++ a/lib/xarray.c
@@ -1152,6 +1152,7 @@ void xas_pause(struct xa_state *xas)
 			if (!xa_is_sibling(xa_entry(xas->xa, node, offset)))
 				break;
 		}
+		xas->xa_index &= ~0UL << node->shift;
 		xas->xa_index += (offset - xas->xa_offset) << node->shift;
 		if (xas->xa_index == 0)
 			xas->xa_node = XAS_BOUNDS;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


