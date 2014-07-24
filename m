From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:29 -0700
Message-ID: <53d170e1.An+SI1ec+Yz3E2O3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:36176 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690AbaGXUra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:30 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so916615pab.1
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, guillaume@morinfr.org, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix copy_hugetlb_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: fix copy_hugetlb_page_range()

commit 4a705fef98 ("hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry") changed the order of
huge_ptep_set_wrprotect() and huge_ptep_get(), which leads to break some
workload like hugepage-backed heap allocation via libhugetlbfs.  This
patch fixes it.

The test program for the problem is shown below:

  $ cat heap.c
  #include <unistd.h>
  #include <stdlib.h>
  #include <string.h>

  #define HPS 0x200000

  int main() {
  	int i;
  	char *p = malloc(HPS);
  	memset(p, '1', HPS);
  	for (i = 0; i < 5; i++) {
  		if (!fork()) {
  			memset(p, '2', HPS);
  			p = malloc(HPS);
  			memset(p, '3', HPS);
  			free(p);
  			return 0;
  		}
  	}
  	sleep(1);
  	free(p);
  	return 0;
  }

  $ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./heap

Fixes 4a705fef98 ("hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry"), so is applicable to -stable kernels which
include it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Suggested-by: Guillaume Morin <guillaume@morinfr.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes
+++ a/mm/hugetlb.c
@@ -2604,6 +2604,7 @@ int copy_hugetlb_page_range(struct mm_st
 		} else {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

