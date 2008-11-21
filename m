From: akpm@linux-foundation.org
Subject: + mm-remove-aop_writepage_activate.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:11:48 -0800
Message-ID: <200811212011.mALKBmYh017580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYKUUMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:12:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: remove AOP_WRITEPAGE_ACTIVATE
has been added to the -mm tree.  Its filename is
     mm-remove-aop_writepage_activate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove AOP_WRITEPAGE_ACTIVATE
From: Hugh Dickins <hugh@veritas.com>

AOP_WRITEPAGE_ACTIVATE is a special return value from a_ops->writepage(),
for the filesystem to tell reclaim that it didn't write the page, and
there's little chance of being able to write it soon, so please defer its
reclaim as long as possible by recycling to head of active list.

(The Unevictable LRU has replaced this functionality to some extent; but
not entirely, and CONFIG_UNEVICTABLE_LRU may anyway not be set.)

It has only one user in tree, shmem_writepage(), and it only makes sense
in reclaim; but it has the confusing peculiarity of returning with the
page still locked, unlike both success and error cases.

It would be more intuitive if shmem_writepage() were to return the page
unlocked with PageActive set, and vmscan observe that to activate the
page: then nowhere else need worry about this peculiar return value.

(We already have the case of an unlocked page marked PageActive but not
yet PageLRU, that's not new.)

One anomaly - NR_VMSCAN_WRITE stats were not updated when AOP_WRITEPAGE
_ACTIVATE, but were updated when the filesystem just redirtied the page
and feigned success: NR_VMSCAN_WRITE stats now updated in neither case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    6 +-----
 Documentation/filesystems/vfs.txt |   13 ++++++++++---
 fs/buffer.c                       |   12 +++++-------
 include/linux/fs.h                |   10 ----------
 mm/migrate.c                      |    5 ++---
 mm/page-writeback.c               |   27 +++++++++++----------------
 mm/shmem.c                        |    2 +-
 mm/vmscan.c                       |   24 +++++++++++-------------
 8 files changed, 41 insertions(+), 58 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-remove-aop_writepage_activate Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-remove-aop_writepage_activate
+++ a/Documentation/filesystems/Locking
@@ -225,11 +225,7 @@ If the filesystem is called for sync the
 in-progress I/O and then start new I/O.
 
 The filesystem should unlock the page synchronously, before returning to the
-caller, unless ->writepage() returns special WRITEPAGE_ACTIVATE
-value. WRITEPAGE_ACTIVATE means that page cannot really be written out
-currently, and VM should stop calling ->writepage() on this page for some
-time. VM does this by moving page to the head of the active list, hence the
-name.
+caller.
 
 Unless the filesystem is going to redirty_page_for_writepage(), unlock the page
 and return zero, writepage *must* run set_page_writeback() against the page,
diff -puN Documentation/filesystems/vfs.txt~mm-remove-aop_writepage_activate Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mm-remove-aop_writepage_activate
+++ a/Documentation/filesystems/vfs.txt
@@ -551,9 +551,16 @@ struct address_space_operations {
       If wbc->sync_mode is WB_SYNC_NONE, ->writepage doesn't have to
       try too hard if there are problems, and may choose to write out
       other pages from the mapping if that is easier (e.g. due to
-      internal dependencies).  If it chooses not to start writeout, it
-      should return AOP_WRITEPAGE_ACTIVATE so that the VM will not keep
-      calling ->writepage on that page.
+      internal dependencies); then redirty_page_for_writepage() on the
+      given page, before unlocking it and returning 0 for success.
+
+      If wbc->for_reclaim, but the filesystem will be unable to write
+      out the page for the foreseeable future (perhaps it cannot even
+      implement writepage in reclaim), it may redirty_page_for_writepage()
+      then SetPageActive(), before unlocking the page and returning 0: to
+      delay page reclaim from reconsidering this page for a little longer.
+      But this is unusual: SetPageActive() should never be used unless
+      wbc->for_reclaim, and only shmem_writepage() actually does this.
 
       See the file "Locking" for more details.
 
diff -puN fs/buffer.c~mm-remove-aop_writepage_activate fs/buffer.c
--- a/fs/buffer.c~mm-remove-aop_writepage_activate
+++ a/fs/buffer.c
@@ -3324,7 +3324,6 @@ EXPORT_SYMBOL(bh_submit_read);
 static void trigger_write(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	int rc;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 		.nr_to_write = 1,
@@ -3345,13 +3344,12 @@ static void trigger_write(struct page *p
 		/* Someone else already triggered a write */
 		goto unlock;
 
-	rc = mapping->a_ops->writepage(page, &wbc);
-	if (rc < 0)
-		/* I/O Error writing */
-		return;
+	mapping->a_ops->writepage(page, &wbc);
+	/* Ignore any error in writing */
+	return;
 
-	if (rc == AOP_WRITEPAGE_ACTIVATE)
-unlock:		unlock_page(page);
+unlock:
+	unlock_page(page);
 }
 
 /*
diff -puN include/linux/fs.h~mm-remove-aop_writepage_activate include/linux/fs.h
--- a/include/linux/fs.h~mm-remove-aop_writepage_activate
+++ a/include/linux/fs.h
@@ -385,15 +385,6 @@ struct iattr {
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
  *
- * @AOP_WRITEPAGE_ACTIVATE: Informs the caller that page writeback has
- * 			    completed, that the page is still locked, and
- * 			    should be considered active.  The VM uses this hint
- * 			    to return the page to the active list -- it won't
- * 			    be a candidate for writeback again in the near
- * 			    future.  Other callers must be careful to unlock
- * 			    the page if they get this return.  Returned by
- * 			    writepage(); 
- *
  * @AOP_TRUNCATED_PAGE: The AOP method that was handed a locked page has
  *  			unlocked it and the page might have been truncated.
  *  			The caller should back up to acquiring a new page and
@@ -409,7 +400,6 @@ struct iattr {
  */
 
 enum positive_aop_returns {
-	AOP_WRITEPAGE_ACTIVATE	= 0x80000,
 	AOP_TRUNCATED_PAGE	= 0x80001,
 };
 
diff -puN mm/migrate.c~mm-remove-aop_writepage_activate mm/migrate.c
--- a/mm/migrate.c~mm-remove-aop_writepage_activate
+++ a/mm/migrate.c
@@ -523,9 +523,8 @@ static int writeout(struct address_space
 
 	rc = mapping->a_ops->writepage(page, &wbc);
 
-	if (rc != AOP_WRITEPAGE_ACTIVATE)
-		/* unlocked. Relock */
-		lock_page(page);
+	/* Unlocked: relock */
+	lock_page(page);
 
 	return (rc < 0) ? -EIO : -EAGAIN;
 }
diff -puN mm/page-writeback.c~mm-remove-aop_writepage_activate mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-aop_writepage_activate
+++ a/mm/page-writeback.c
@@ -963,22 +963,17 @@ continue_unlock:
 
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
-				if (ret == AOP_WRITEPAGE_ACTIVATE) {
-					unlock_page(page);
-					ret = 0;
-				} else {
-					/*
-					 * done_index is set past this page,
-					 * so media errors will not choke
-					 * background writeout for the entire
-					 * file. This has consequences for
-					 * range_cyclic semantics (ie. it may
-					 * not be suitable for data integrity
-					 * writeout).
-					 */
-					done = 1;
-					break;
-				}
+				/*
+				 * done_index is set past this page,
+				 * so media errors will not choke
+				 * background writeout for the entire
+				 * file. This has consequences for
+				 * range_cyclic semantics (ie. it may
+				 * not be suitable for data integrity
+				 * writeout).
+				 */
+				done = 1;
+				break;
  			}
 
 			if (wbc->sync_mode == WB_SYNC_NONE) {
diff -puN mm/shmem.c~mm-remove-aop_writepage_activate mm/shmem.c
--- a/mm/shmem.c~mm-remove-aop_writepage_activate
+++ a/mm/shmem.c
@@ -1074,7 +1074,7 @@ unlock:
 redirty:
 	set_page_dirty(page);
 	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
+		SetPageActive(page);
 	unlock_page(page);
 	return 0;
 }
diff -puN mm/vmscan.c~mm-remove-aop_writepage_activate mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-aop_writepage_activate
+++ a/mm/vmscan.c
@@ -349,8 +349,6 @@ typedef enum {
 	/* failed to write page out, page is locked */
 	PAGE_KEEP,
 	/* move page to the active list, page is locked */
-	PAGE_ACTIVATE,
-	/* page has been sent to the disk successfully, page is unlocked */
 	PAGE_SUCCESS,
 	/* page is clean and locked */
 	PAGE_CLEAN,
@@ -396,8 +394,10 @@ static pageout_t pageout(struct page *pa
 		}
 		return PAGE_KEEP;
 	}
-	if (mapping->a_ops->writepage == NULL)
-		return PAGE_ACTIVATE;
+	if (mapping->a_ops->writepage == NULL) {
+		SetPageActive(page);
+		return PAGE_KEEP;
+	}
 	if (!may_write_to_queue(mapping->backing_dev_info))
 		return PAGE_KEEP;
 
@@ -416,10 +416,6 @@ static pageout_t pageout(struct page *pa
 		res = mapping->a_ops->writepage(page, &wbc);
 		if (res < 0)
 			handle_write_error(mapping, page, res);
-		if (res == AOP_WRITEPAGE_ACTIVATE) {
-			ClearPageReclaim(page);
-			return PAGE_ACTIVATE;
-		}
 
 		/*
 		 * Wait on writeback if requested to. This happens when
@@ -430,10 +426,13 @@ static pageout_t pageout(struct page *pa
 			wait_on_page_writeback(page);
 
 		if (!PageWriteback(page)) {
-			/* synchronous write or broken a_ops? */
+			/* synchronous write, or writepage passed over it */
 			ClearPageReclaim(page);
 		}
-		inc_zone_page_state(page, NR_VMSCAN_WRITE);
+		if (!PageDirty(page)) {
+			/* writepage did not pass over this write */
+			inc_zone_page_state(page, NR_VMSCAN_WRITE);
+		}
 		return PAGE_SUCCESS;
 	}
 
@@ -720,8 +719,6 @@ static unsigned long shrink_page_list(st
 			switch (pageout(page, mapping, sync_writeback)) {
 			case PAGE_KEEP:
 				goto keep_locked;
-			case PAGE_ACTIVATE:
-				goto activate_locked;
 			case PAGE_SUCCESS:
 				if (PageWriteback(page) || PageDirty(page))
 					goto keep;
@@ -811,10 +808,11 @@ activate_locked:
 			remove_exclusive_swap_page_ref(page);
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
-		pgactivate++;
 keep_locked:
 		unlock_page(page);
 keep:
+		if (PageActive(page))
+			pgactivate++;
 		list_add(&page->lru, &ret_pages);
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

