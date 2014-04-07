From: akpm@linux-foundation.org
Subject: [folded-merged] mm-implement-map_pages-for-page-cache-fix.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 15:03:34 -0700
Message-ID: <534320b6.z6gdzVeByjf1P2HH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaDGWDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, quning@google.com, hughd@google.com, kirill.shutemov@linux.intel.com

Subject: [folded-merged] mm-implement-map_pages-for-page-cache-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,hughd@google.com,quning@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:03:34 -0700


The patch titled
     Subject: mm: filemap_map_pages() avoid dereference NULL/exception slots
has been removed from the -mm tree.  Its filename was
     mm-implement-map_pages-for-page-cache-fix.patch

This patch was dropped because it was folded into mm-implement-map_pages-for-page-cache.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: filemap_map_pages() avoid dereference NULL/exception slots

radix_tree_deref_slot() can return NULL: add missed check.

Do no dereference 'page': we can get there as result of
radix_tree_exception(page) check.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Ning Qu <quning@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-implement-map_pages-for-page-cache-fix mm/filemap.c
--- a/mm/filemap.c~mm-implement-map_pages-for-page-cache-fix
+++ a/mm/filemap.c
@@ -2083,6 +2083,8 @@ void filemap_map_pages(struct vm_area_st
 			break;
 repeat:
 		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			goto next;
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page))
 				break;
@@ -2128,7 +2130,7 @@ unlock:
 skip:
 		page_cache_release(page);
 next:
-		if (page->index == vmf->max_pgoff)
+		if (iter.index == vmf->max_pgoff)
 			break;
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch

