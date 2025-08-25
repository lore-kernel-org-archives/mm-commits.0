Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C982C15AF
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 22:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162551; cv=none; b=oj8ExlVw+GuzJ7Z0mtbwmHNZqJvJGoehVh4IaHr3xm9qtglKHMwXZKoQcLHtvDcCy9eDflT+89EbQVSGwbTSm7J+kkPtFXfp6dGEUXxw98h27qlGBDyLxtbesB56gCVNBNvO0pYCU9UR2v6YEgl7JG/47RckchIuCjJVGb4zzxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162551; c=relaxed/simple;
	bh=9iXQMv381PLTWYTfkPu3VFlyRxob7aB/6lHJOmknXWM=;
	h=Date:To:From:Subject:Message-Id; b=DW12NecsaK+mZ8yXxCN6livuRnVkBYBaDbHIPuTz91A0YntJjOMRFVxgr6VrJsWXe/NIKg7o0ugQKHfyxLMMBYgm2o1NSPckSFCki+g7BBTVxLpff6pcGOemn3ZBol4phW9yQIZFnp0Um5PLRLiinUJ8QGLvpHiWuzhv7ZVbSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDN/B/az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDN/B/az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90064C4CEF4;
	Mon, 25 Aug 2025 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756162550;
	bh=9iXQMv381PLTWYTfkPu3VFlyRxob7aB/6lHJOmknXWM=;
	h=Date:To:From:Subject:From;
	b=IDN/B/azlMWKt/HqNiLHvPHh+joFN90EBQr8+hToG8keR9HkdWU39oooo0NJtqSLG
	 bvcmfI80shTeImwsD3+YOwL15r2ufEOK2NSVhcOSXVRT8oXeijaC0MslId5fvoI2Z9
	 v1dm9Sw4HKFpumh47fsXhPnxT7llrzUDJaMvbLak=
Date: Mon, 25 Aug 2025 15:55:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-drop-usage-of-folio_index.patch added to mm-new branch
Message-Id: <20250825225550.90064C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-writeback: drop usage of folio_index
has been added to the -mm mm-new branch.  Its filename is
     mm-page-writeback-drop-usage-of-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-drop-usage-of-folio_index.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/page-writeback: drop usage of folio_index
Date: Tue, 26 Aug 2025 00:37:21 +0800

folio_index is only needed for mixed usage of page cache and swap cache. 
The remaining three caller in page-writeback are for page cache tag
marking.  Swap cache space doesn't use tag (explicitly sets
mapping_set_no_writeback_tags), so use folio->index here directly.

Link: https://lkml.kernel.org/r/20250825163721.17734-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-drop-usage-of-folio_index
+++ a/mm/page-writeback.c
@@ -38,10 +38,10 @@
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
 #include <linux/mm_inline.h>
+#include <linux/shmem_fs.h>
 #include <trace/events/writeback.h>
 
 #include "internal.h"
-#include "swap.h"
 
 /*
  * Sleep at most 200ms at a time in balance_dirty_pages().
@@ -2705,12 +2705,18 @@ void __folio_mark_dirty(struct folio *fo
 {
 	unsigned long flags;
 
+	/*
+	 * Shmem writeback relies on swap, and swap writeback is LRU based,
+	 * not using the dirty mark.
+	 */
+	VM_WARN_ON_ONCE(folio_test_swapcache(folio) || shmem_mapping(mapping));
+
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
 		folio_account_dirtied(folio, mapping);
-		__xa_set_mark(&mapping->i_pages, folio_index(folio),
-				PAGECACHE_TAG_DIRTY);
+		__xa_set_mark(&mapping->i_pages, folio->index,
+			      PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
@@ -2989,7 +2995,7 @@ bool __folio_end_writeback(struct folio
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
 		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
-		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
+		__xa_clear_mark(&mapping->i_pages, folio->index,
 					PAGECACHE_TAG_WRITEBACK);
 		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
 			struct bdi_writeback *wb = inode_to_wb(inode);
@@ -3026,7 +3032,7 @@ void __folio_start_writeback(struct foli
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
-		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+		XA_STATE(xas, &mapping->i_pages, folio->index);
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch

