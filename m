From: akpm@linux-foundation.org
Subject: [merged] mm-fix-xfs-oops-due-to-dirty-pages-without-buffers-on-s390.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:33 -0700
Message-ID: <20121029194933.BFC10100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:65335 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2Tte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:34 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so680464ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, heiko.carstens@de.ibm.com, hughd@google.com, mgorman@suse.de, schwidefsky@de.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix XFS oops due to dirty pages without buffers on s390
has been removed from the -mm tree.  Its filename was
     mm-fix-xfs-oops-due-to-dirty-pages-without-buffers-on-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: fix XFS oops due to dirty pages without buffers on s390

On s390 any write to a page (even from kernel itself) sets architecture
specific page dirty bit.  Thus when a page is written to via buffered
write, HW dirty bit gets set and when we later map and unmap the page,
page_remove_rmap() finds the dirty bit and calls set_page_dirty().

Dirtying of a page which shouldn't be dirty can cause all sorts of
problems to filesystems.  The bug we observed in practice is that buffers
from the page get freed, so when the page gets later marked as dirty and
writeback writes it, XFS crashes due to an assertion
BUG_ON(!PagePrivate(page)) in page_buffers() called from
xfs_count_page_state().

Similar problem can also happen when zero_user_segment() call from
xfs_vm_writepage() (or block_write_full_page() for that matter) set the
hardware dirty bit during writeback, later buffers get freed, and then
page unmapped.

Fix the issue by ignoring s390 HW dirty bit for page cache pages of
mappings with mapping_cap_account_dirty().  This is safe because for such
mappings when a page gets marked as writeable in PTE it is also marked
dirty in do_wp_page() or do_page_fault().  When the dirty bit is cleared
by clear_page_dirty_for_io(), the page gets writeprotected in
page_mkclean().  So pagecache page is writeable if and only if it is
dirty.

Thanks to Hugh Dickins for pointing out mapping has to have
mapping_cap_account_dirty() for things to work and proposing a cleaned up
variant of the patch.

The patch has survived about two hours of running fsx-linux on tmpfs while
heavily swapping and several days of running on out build machines where
the original problem was triggered.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org>		[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~mm-fix-xfs-oops-due-to-dirty-pages-without-buffers-on-s390 mm/rmap.c
--- a/mm/rmap.c~mm-fix-xfs-oops-due-to-dirty-pages-without-buffers-on-s390
+++ a/mm/rmap.c
@@ -56,6 +56,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlbflush.h>
 
@@ -926,11 +927,8 @@ int page_mkclean(struct page *page)
 
 	if (page_mapped(page)) {
 		struct address_space *mapping = page_mapping(page);
-		if (mapping) {
+		if (mapping)
 			ret = page_mkclean_file(mapping, page);
-			if (page_test_and_clear_dirty(page_to_pfn(page), 1))
-				ret = 1;
-		}
 	}
 
 	return ret;
@@ -1116,6 +1114,7 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	struct address_space *mapping = page_mapping(page);
 	bool anon = PageAnon(page);
 	bool locked;
 	unsigned long flags;
@@ -1138,8 +1137,19 @@ void page_remove_rmap(struct page *page)
 	 * this if the page is anon, so about to be freed; but perhaps
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
+	 *
+	 * And we can skip it on file pages, so long as the filesystem
+	 * participates in dirty tracking; but need to catch shm and tmpfs
+	 * and ramfs pages which have been modified since creation by read
+	 * fault.
+	 *
+	 * Note that mapping must be decided above, before decrementing
+	 * mapcount (which luckily provides a barrier): once page is unmapped,
+	 * it could be truncated and page->mapping reset to NULL at any moment.
+	 * Note also that we are relying on page_mapping(page) to set mapping
+	 * to &swapper_space when PageSwapCache(page).
 	 */
-	if ((!anon || PageSwapCache(page)) &&
+	if (mapping && !mapping_cap_account_dirty(mapping) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

