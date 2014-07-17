From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch added to -mm tree
Date: Thu, 17 Jul 2014 16:10:34 -0700
Message-ID: <53c857ea.DbaAtiqIkfUQqPou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48479 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535AbaGQXKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 19:10:35 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so441685qap.4
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 16:10:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, guillaume@morinfr.org, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix copy_hugetlb_page_range()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rmap-fix-pgoff-calculation-to-handle-hugepage-correctly.patch
mm-hugetlb-fix-copy_hugetlb_page_range-re-new-copy_hugetlb_page_range-causing-crashes.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

