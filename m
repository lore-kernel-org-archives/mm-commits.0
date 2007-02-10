From: akpm@linux-foundation.org
Subject: - mm-remove-find_trylock_page.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:27:13 -0800
Message-ID: <200702100527.l1A5RDGl004665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXBJF1W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:27:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: remove find_trylock_page
has been removed from the -mm tree.  Its filename was
     mm-remove-find_trylock_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: remove find_trylock_page
From: Nick Piggin <npiggin@suse.de>

Remove find_trylock_page for 2.6.21.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 -----------
 include/linux/pagemap.h                    |    2 -
 mm/filemap.c                               |   20 -------------------
 3 files changed, 34 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~mm-remove-find_trylock_page Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mm-remove-find_trylock_page
+++ a/Documentation/feature-removal-schedule.txt
@@ -170,18 +170,6 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
 
 ---------------------------
 
-What:	find_trylock_page
-When:	January 2007
-Why:	The interface no longer has any callers left in the kernel. It
-	is an odd interface (compared with other find_*_page functions), in
-	that it does not take a refcount to the page, only the page lock.
-	It should be replaced with find_get_page or find_lock_page if possible.
-	This feature removal can be reevaluated if users of the interface
-	cannot cleanly use something else.
-Who:	Nick Piggin <npiggin@suse.de>
-
----------------------------
-
 What:	Interrupt only SA_* flags
 When:	Januar 2007
 Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
diff -puN include/linux/pagemap.h~mm-remove-find_trylock_page include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-remove-find_trylock_page
+++ a/include/linux/pagemap.h
@@ -76,8 +76,6 @@ extern struct page * find_get_page(struc
 				unsigned long index);
 extern struct page * find_lock_page(struct address_space *mapping,
 				unsigned long index);
-extern __deprecated_for_modules struct page * find_trylock_page(
-			struct address_space *mapping, unsigned long index);
 extern struct page * find_or_create_page(struct address_space *mapping,
 				unsigned long index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
diff -puN mm/filemap.c~mm-remove-find_trylock_page mm/filemap.c
--- a/mm/filemap.c~mm-remove-find_trylock_page
+++ a/mm/filemap.c
@@ -554,26 +554,6 @@ struct page * find_get_page(struct addre
 EXPORT_SYMBOL(find_get_page);
 
 /**
- * find_trylock_page - find and lock a page
- * @mapping: the address_space to search
- * @offset: the page index
- *
- * Same as find_get_page(), but trylock it instead of incrementing the count.
- */
-struct page *find_trylock_page(struct address_space *mapping, unsigned long offset)
-{
-	struct page *page;
-
-	read_lock_irq(&mapping->tree_lock);
-	page = radix_tree_lookup(&mapping->page_tree, offset);
-	if (page && TestSetPageLocked(page))
-		page = NULL;
-	read_unlock_irq(&mapping->tree_lock);
-	return page;
-}
-EXPORT_SYMBOL(find_trylock_page);
-
-/**
  * find_lock_page - locate, pin and lock a pagecache page
  * @mapping: the address_space to search
  * @offset: the page index
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
add-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
mm-mincore-anon.patch
buffer-memorder-fix.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
inotify-read-return-val-fix.patch
sched-avoid-div-in-rebalance_tick.patch
