From: akpm@linux-foundation.org
Subject: [merged]
 mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch removed from
 -mm tree
Date: Thu, 07 Sep 2017 11:42:10 -0700
Message-ID: <20170907184210.enYkcL8Di%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdIGSmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andi.kleen@intel.com, cl@linux.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mike.kravetz@oracle.com, minchan@kernel.org, mm-commits@vger.kernel.org, nyc@holomorphy.com, shli@fb.com, ying.huang@intel.com


The patch titled
     Subject: mm: hugetlb: clear target sub-page last when clearing huge page
has been removed from the -mm tree.  Its filename was
     mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: hugetlb: clear target sub-page last when clearing huge page

Huge page helps to reduce TLB miss rate, but it has higher cache
footprint, sometimes this may cause some issue.  For example, when
clearing huge page on x86_64 platform, the cache footprint is 2M.  But on
a Xeon E5 v3 2699 CPU, there are 18 cores, 36 threads, and only 45M LLC
(last level cache).  That is, in average, there are 2.5M LLC for each core
and 1.25M LLC for each thread.  If the cache pressure is heavy when
clearing the huge page, and we clear the huge page from the begin to the
end, it is possible that the begin of huge page is evicted from the cache
after we finishing clearing the end of the huge page.  And it is possible
for the application to access the begin of the huge page after clearing
the huge page.

To help the above situation, in this patch, when we clear a huge page, the
order to clear sub-pages is changed.  In quite some situation, we can get
the address that the application will access after we clear the huge page,
for example, in a page fault handler.  Instead of clearing the huge page
from begin to end, we will clear the sub-pages farthest from the the
sub-page to access firstly, and clear the sub-page to access last.  This
will make the sub-page to access most cache-hot and sub-pages around it
more cache-hot too.  If we cannot know the address the application will
access, the begin of the huge page is assumed to be the the address the
application will access.

With this patch, the throughput increases ~28.3% in vm-scalability
anon-w-seq test case with 72 processes on a 2 socket Xeon E5 v3 2699
system (36 cores, 72 threads).  The test case creates 72 processes, each
process mmap a big anonymous memory area and writes to it from the begin
to the end.  For each process, other processes could be seen as other
workload which generates heavy cache pressure.  At the same time, the
cache miss rate reduced from ~33.4% to ~31.7%, the IPC (instruction per
cycle) increased from 0.56 to 0.74, and the time spent in user space is
reduced ~7.9%

Christopher Lameter suggests to clear bytes inside a sub-page from end to
begin too.  But tests show no visible performance difference in the tests.
May because the size of page is small compared with the cache size.

Thanks Andi Kleen to propose to use address to access to determine the
order of sub-pages to clear.

The hugetlbfs access address could be improved, will do that in another
patch.

[ying.huang@intel.com: improve readability of clear_huge_page()]
  Link: http://lkml.kernel.org/r/20170830051842.1397-1-ying.huang@intel.com
Link: http://lkml.kernel.org/r/20170815014618.15842-1-ying.huang@intel.com
Suggested-by: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/huge_memory.c   |    4 ++--
 mm/memory.c        |   42 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 41 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-clear-to-access-sub-page-last-when-clearing-huge-page include/linux/mm.h
--- a/include/linux/mm.h~mm-clear-to-access-sub-page-last-when-clearing-huge-page
+++ a/include/linux/mm.h
@@ -2508,7 +2508,7 @@ enum mf_action_page_type {
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
-			    unsigned long addr,
+			    unsigned long addr_hint,
 			    unsigned int pages_per_huge_page);
 extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned long addr, struct vm_area_struct *vma,
diff -puN mm/huge_memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page
+++ a/mm/huge_memory.c
@@ -567,7 +567,7 @@ static int __do_huge_pmd_anonymous_page(
 		goto release;
 	}
 
-	clear_huge_page(page, haddr, HPAGE_PMD_NR);
+	clear_huge_page(page, vmf->address, HPAGE_PMD_NR);
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
 	 * clear_huge_page writes become visible before the set_pmd_at()
@@ -1305,7 +1305,7 @@ alloc:
 	count_vm_event(THP_FAULT_ALLOC);
 
 	if (!page)
-		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
+		clear_huge_page(new_page, vmf->address, HPAGE_PMD_NR);
 	else
 		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
diff -puN mm/memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page mm/memory.c
--- a/mm/memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page
+++ a/mm/memory.c
@@ -4417,19 +4417,53 @@ static void clear_gigantic_page(struct p
 	}
 }
 void clear_huge_page(struct page *page,
-		     unsigned long addr, unsigned int pages_per_huge_page)
+		     unsigned long addr_hint, unsigned int pages_per_huge_page)
 {
-	int i;
+	int i, n, base, l;
+	unsigned long addr = addr_hint &
+		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 
 	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
 		clear_gigantic_page(page, addr, pages_per_huge_page);
 		return;
 	}
 
+	/* Clear sub-page to access last to keep its cache lines hot */
 	might_sleep();
-	for (i = 0; i < pages_per_huge_page; i++) {
+	n = (addr_hint - addr) / PAGE_SIZE;
+	if (2 * n <= pages_per_huge_page) {
+		/* If sub-page to access in first half of huge page */
+		base = 0;
+		l = n;
+		/* Clear sub-pages at the end of huge page */
+		for (i = pages_per_huge_page - 1; i >= 2 * n; i--) {
+			cond_resched();
+			clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		}
+	} else {
+		/* If sub-page to access in second half of huge page */
+		base = pages_per_huge_page - 2 * (pages_per_huge_page - n);
+		l = pages_per_huge_page - n;
+		/* Clear sub-pages at the begin of huge page */
+		for (i = 0; i < base; i++) {
+			cond_resched();
+			clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		}
+	}
+	/*
+	 * Clear remaining sub-pages in left-right-left-right pattern
+	 * towards the sub-page to access
+	 */
+	for (i = 0; i < l; i++) {
+		int left_idx = base + i;
+		int right_idx = base + 2 * l - 1 - i;
+
+		cond_resched();
+		clear_user_highpage(page + left_idx,
+				    addr + left_idx * PAGE_SIZE);
 		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		clear_user_highpage(page + right_idx,
+				    addr + right_idx * PAGE_SIZE);
 	}
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are


