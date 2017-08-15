From: akpm@linux-foundation.org
Subject: + mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch
 added to -mm tree
Date: Tue, 15 Aug 2017 15:13:48 -0700
Message-ID: <5993721c.syrvvB2SmvJl6Eva%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbdHOWNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 18:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, andi.kleen@intel.com, cl@linux.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mike.kravetz@oracle.com, minchan@kernel.org, nyc@holomorphy.com, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: clear target sub-page last when clearing huge page
has been added to the -mm tree.  Its filename is
     mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20170815014618.15842-1-ying.huang@intel.com
Suggested-by: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Michal Hocko <mhocko@suse.com>
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
 mm/memory.c        |   39 +++++++++++++++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-clear-to-access-sub-page-last-when-clearing-huge-page include/linux/mm.h
--- a/include/linux/mm.h~mm-clear-to-access-sub-page-last-when-clearing-huge-page
+++ a/include/linux/mm.h
@@ -2507,7 +2507,7 @@ enum mf_action_page_type {
 
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
@@ -1324,7 +1324,7 @@ alloc:
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
@@ -4409,19 +4409,50 @@ static void clear_gigantic_page(struct p
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
+		cond_resched();
+		clear_user_highpage(page + base + i,
+				    addr + (base + i) * PAGE_SIZE);
 		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+		clear_user_highpage(page + base + 2 * l - 1 - i,
+				    addr + (base + 2 * l - 1 - i) * PAGE_SIZE);
 	}
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch
mm-swap-add-swap-readahead-hit-statistics.patch
mm-swap-fix-swap-readahead-marking.patch
mm-swap-vma-based-swap-readahead.patch
mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch
mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch

