Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EFF9FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741344; cv=none; b=O/2/lMzEwv0oHrRa4Vga/fldc8i5kSIzjo2LvwYEL0lBfNAM5ymGDX4Zr4e6qt8W7RyevWl98sMsa+1CFE1oHt+QIWKsGOsJ0SBREGtHV/eoVIeHhyf18OieflTeNe0DEPceL8Jo+QKvx2hN4AIzNzwjZwQCHPNvtujWF1JLwKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741344; c=relaxed/simple;
	bh=eDIEWOGzpH2Qbm/wdf7M8XnMyW7mf/cUOvRInuHwF2A=;
	h=Date:To:From:Subject:Message-Id; b=VWlVNdjbUhe/zri57F4FNNmic6xydP/ZfdnBo1bk2w3KXLTyqubCEY54NvNSvGecw3Uf4/wqpvAe4ExDzJU1knzz3k3PZRqT8c7YPGIAh5Et4E6oTKc2mkb9WFyveYW0pdDnxdQaRsm6mPDPFHMrJeImL96NbrBhonz85dKyI9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S42swR2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S42swR2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4275DC4CED6;
	Mon, 13 Jan 2025 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741344;
	bh=eDIEWOGzpH2Qbm/wdf7M8XnMyW7mf/cUOvRInuHwF2A=;
	h=Date:To:From:Subject:From;
	b=S42swR2X2/vr6x0zuclmt9wCqHtI+yl/3pPl/LHu/C9rkBO5sXNSIsczS6M6BsBH4
	 yDwxNCRhNQm+vscrN8yGu5dC9Mc/paaonEaqN5N8B8OY6ENppZrdHEoL5W9buJTVfb
	 +kCgpUDHi5bF9lwzaFZGv+J973ePqr6FPxAUPV5Y=
Date: Sun, 12 Jan 2025 20:09:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-move-forward-index-correctly-in-xas_pause.patch added to mm-nonmm-unstable branch
Message-Id: <20250113040904.4275DC4CED6@smtp.kernel.org>
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

xarray-do-not-return-sibling-entries-from-xas_find_marked.patch
xarray-move-forward-index-correctly-in-xas_pause.patch
xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch
xarray-remove-repeat-check-in-xas_squash_marks.patch
xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

