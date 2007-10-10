From: akpm@linux-foundation.org
Subject: - mm-set_page_dirty_balance-vs-page_mkwrite.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:16 -0700
Message-ID: <200710102110.l9ALAG3i025913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238AbXJJVK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: set_page_dirty_balance() vs ->page_mkwrite()
has been removed from the -mm tree.  Its filename was
     mm-set_page_dirty_balance-vs-page_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: set_page_dirty_balance() vs ->page_mkwrite()
From: Peter Zijlstra <peterz@infradead.org>

All the current page_mkwrite() implementations also set the page dirty. 
Which results in the set_page_dirty_balance() call to _not_ call balance,
because the page is already found dirty.

This allows us to dirty a _lot_ of pages without ever hitting
balance_dirty_pages().  Not good (tm).

Force a balance call if ->page_mkwrite() was successful.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/writeback.h~mm-set_page_dirty_balance-vs-page_mkwrite include/linux/writeback.h
--- a/include/linux/writeback.h~mm-set_page_dirty_balance-vs-page_mkwrite
+++ a/include/linux/writeback.h
@@ -127,7 +127,7 @@ int sync_page_range(struct inode *inode,
 			loff_t pos, loff_t count);
 int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
 			   loff_t pos, loff_t count);
-void set_page_dirty_balance(struct page *page);
+void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
 
 /* pdflush.c */
diff -puN mm/memory.c~mm-set_page_dirty_balance-vs-page_mkwrite mm/memory.c
--- a/mm/memory.c~mm-set_page_dirty_balance-vs-page_mkwrite
+++ a/mm/memory.c
@@ -1639,6 +1639,7 @@ static int do_wp_page(struct mm_struct *
 	struct page *old_page, *new_page;
 	pte_t entry;
 	int reuse = 0, ret = 0;
+	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
@@ -1687,6 +1688,8 @@ static int do_wp_page(struct mm_struct *
 			page_cache_release(old_page);
 			if (!pte_same(*page_table, orig_pte))
 				goto unlock;
+
+			page_mkwrite = 1;
 		}
 		dirty_page = old_page;
 		get_page(dirty_page);
@@ -1774,7 +1777,7 @@ unlock:
 		 * do_no_page is protected similarly.
 		 */
 		wait_on_page_locked(dirty_page);
-		set_page_dirty_balance(dirty_page);
+		set_page_dirty_balance(dirty_page, page_mkwrite);
 		put_page(dirty_page);
 	}
 	return ret;
@@ -2322,6 +2325,7 @@ static int __do_fault(struct mm_struct *
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
 	int ret;
+	int page_mkwrite = 0;
 
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
@@ -2398,6 +2402,7 @@ static int __do_fault(struct mm_struct *
 					anon = 1; /* no anon but release vmf.page */
 					goto out;
 				}
+				page_mkwrite = 1;
 			}
 		}
 
@@ -2453,7 +2458,7 @@ out_unlocked:
 	if (anon)
 		page_cache_release(vmf.page);
 	else if (dirty_page) {
-		set_page_dirty_balance(dirty_page);
+		set_page_dirty_balance(dirty_page, page_mkwrite);
 		put_page(dirty_page);
 	}
 
diff -puN mm/page-writeback.c~mm-set_page_dirty_balance-vs-page_mkwrite mm/page-writeback.c
--- a/mm/page-writeback.c~mm-set_page_dirty_balance-vs-page_mkwrite
+++ a/mm/page-writeback.c
@@ -274,9 +274,9 @@ static void balance_dirty_pages(struct a
 		pdflush_operation(background_writeout, 0);
 }
 
-void set_page_dirty_balance(struct page *page)
+void set_page_dirty_balance(struct page *page, int page_mkwrite)
 {
-	if (set_page_dirty(page)) {
+	if (set_page_dirty(page) || page_mkwrite) {
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping)
_

Patches currently in -mm which might be from peterz@infradead.org are

readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
