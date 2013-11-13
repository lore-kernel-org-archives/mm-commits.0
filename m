From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:42 -0800
Message-ID: <5283e38e.jux3cXjzrx0/NHFF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3KMUjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:42 -0800


The patch titled
     Subject: mm: numa: return the number of base pages altered by protection changes
has been removed from the -mm tree.  Its filename was
     mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: return the number of base pages altered by protection changes

Commit 0255d491 ("mm: Account for a THP NUMA hinting update as one PTE
update") was added to account for the number of PTE updates when marking
pages prot_numa.  task_numa_work was using the old return value to track
how much address space had been updated.  Altering the return value causes
the scanner to do more work than it is configured or documented to in a
single unit of work.

This patch reverts 0255d491 and accounts for the number of THP updates
separately in vmstat.  It is up to the administrator to interpret the pair
of values correctly.  This is a straight-forward operation and likely to
only be of interest when actively debugging NUMA balancing problems.

The impact of this patch is that the NUMA PTE scanner will scan slower
when THP is enabled and workloads may converge slower as a result.  On the
flip size system CPU usage should be lower than recent tests reported. 
This is an illustrative example of a short single JVM specjbb test

specjbb
                       3.12.0                3.12.0
                      vanilla      acctupdates
TPut 1      26143.00 (  0.00%)     25747.00 ( -1.51%)
TPut 7     185257.00 (  0.00%)    183202.00 ( -1.11%)
TPut 13    329760.00 (  0.00%)    346577.00 (  5.10%)
TPut 19    442502.00 (  0.00%)    460146.00 (  3.99%)
TPut 25    540634.00 (  0.00%)    549053.00 (  1.56%)
TPut 31    512098.00 (  0.00%)    519611.00 (  1.47%)
TPut 37    461276.00 (  0.00%)    474973.00 (  2.97%)
TPut 43    403089.00 (  0.00%)    414172.00 (  2.75%)

              3.12.0      3.12.0
             vanillaacctupdates
User         5169.64     5184.14
System        100.45       80.02
Elapsed       252.75      251.85

Performance is similar but note the reduction in system CPU time.  While
this showed a performance gain, it will not be universal but at least
it'll be behaving as documented.  The vmstats are obviously different but
here is an obvious interpretation of them from mmtests.

                                3.12.0      3.12.0
                               vanillaacctupdates
NUMA page range updates        1408326    11043064
NUMA huge PMD updates                0       21040
NUMA PTE updates               1408326      291624

"NUMA page range updates" == nr_pte_updates and is the value returned to
the NUMA pte scanner.  NUMA huge PMD updates were the number of THP
updates which in combination can be used to calculate how many ptes were
updated from userspace.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/mprotect.c                 |   10 +++++++---
 mm/vmstat.c                   |    1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes
+++ a/include/linux/vm_event_item.h
@@ -39,6 +39,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
+		NUMA_HUGE_PTE_UPDATES,
 		NUMA_HINT_FAULTS,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
diff -puN mm/mprotect.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes
+++ a/mm/mprotect.c
@@ -112,6 +112,7 @@ static inline unsigned long change_pmd_r
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long pages = 0;
+	unsigned long nr_huge_updates = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -126,9 +127,10 @@ static inline unsigned long change_pmd_r
 						newprot, prot_numa);
 
 				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR)
-						pages++;
-
+					if (nr_ptes == HPAGE_PMD_NR) {
+						pages += HPAGE_PMD_NR;
+						nr_huge_updates++;
+					}
 					continue;
 				}
 			}
@@ -141,6 +143,8 @@ static inline unsigned long change_pmd_r
 		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
+	if (nr_huge_updates)
+		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
 }
 
diff -puN mm/vmstat.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes mm/vmstat.c
--- a/mm/vmstat.c~mm-numa-return-the-number-of-base-pages-altered-by-protection-changes
+++ a/mm/vmstat.c
@@ -812,6 +812,7 @@ const char * const vmstat_text[] = {
 
 #ifdef CONFIG_NUMA_BALANCING
 	"numa_pte_updates",
+	"numa_huge_pte_updates",
 	"numa_hint_faults",
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

