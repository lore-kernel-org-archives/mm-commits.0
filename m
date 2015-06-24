From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch removed
 from -mm tree
Date: Wed, 24 Jun 2015 16:47:34 -0700
Message-ID: <558b4196.QUOXtYqH4pL/gyQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbFXXre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch

This patch was dropped because it was folded into hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix

tweak comments

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix mm/filemap.c
--- a/mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix
+++ a/mm/filemap.c
@@ -196,7 +196,7 @@ void __delete_from_page_cache(struct pag
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
 
-	/* hugetlb pages do not participate into page cache accounting. */
+	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(page))
 		__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
@@ -487,8 +487,7 @@ int replace_page_cache_page(struct page
 		mapping->nrpages++;
 
 		/*
-		 * hugetlb pages do not participate into page cache
-		 * accounting.
+		 * hugetlb pages do not participate in page cache accounting.
 		 */
 		if (!PageHuge(new))
 			__inc_zone_page_state(new, NR_FILE_PAGES);
@@ -584,7 +583,7 @@ static int __add_to_page_cache_locked(st
 	if (unlikely(error))
 		goto err_insert;
 
-	/* hugetlb pages do not participate into page cache accounting. */
+	/* hugetlb pages do not participate in page cache accounting. */
 	if (!huge)
 		__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

