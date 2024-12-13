Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567EC5336E
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062466; cv=none; b=hcqBr9a+i08f2a66pzTOQsWMIhmGnnV01zvRaatiFVpsuWpOiU3EyzzpMGsCK7vrWx+DNAh6c1PN2BPEUQ9EeizDkMBOlGv0Pvna2743GWi8BLClpuBpGy/qV3dDrFDnlssU8ck8vQUZ4n3X8gVsdS/1caJAISbyphHCPMLiA5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062466; c=relaxed/simple;
	bh=9Lys59yA2G0iukBX9hDyyGoQNcjMXvHHUfUJXtPi6zU=;
	h=Date:To:From:Subject:Message-Id; b=NwAhMGJAidYQs2BbHgh5PN1Msn8eYVntJnVI5RyNzvyHhsjP+PFexDjhnKrzNjw6MrJaJr7dFrfU+6bvey7SGugOSnsSVrAKFVG6fJBi5mw95vTBJfoRkQICJCfUtAMELAWvWvodXwjK9NHNOqOB3f7JEnccMf3vJbzuwE/keAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAZm3TaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAZm3TaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB838C4CED2;
	Fri, 13 Dec 2024 04:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062465;
	bh=9Lys59yA2G0iukBX9hDyyGoQNcjMXvHHUfUJXtPi6zU=;
	h=Date:To:From:Subject:From;
	b=BAZm3TaJEXrIx9Cdd/TlFBzLBVKkADaS+teREAnZdqbHEbtNs64EbTWbV9Hcuj8Kj
	 r0qJUniClDs4bhKzO89MkBEwsKFobg9jq+KiHu3nMnYS+XKFPm4hcA42Uu2qgTTc+K
	 wWVD6rfbR9+0U+qnibHbaFgyIbKIUDd+Waltk91I=
Date: Thu, 12 Dec 2024 20:01:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-move-forward-index-correctly-in-xas_pause.patch added to mm-nonmm-unstable branch
Message-Id: <20241213040105.CB838C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Xarray: move forward index correctly in xas_pause()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-move-forward-index-correctly-in-xas_pause.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-move-forward-index-correctly-in-xas_pause.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Matthew Wilcox <willy@infradead.org>
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

xarray-do-not-return-sibling-entries-from-xas_find_marked.patch
xarray-move-forward-index-correctly-in-xas_pause.patch
xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch
xarray-remove-repeat-check-in-xas_squash_marks.patch
xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

