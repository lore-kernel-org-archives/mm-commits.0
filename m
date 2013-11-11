From: akpm@linux-foundation.org
Subject: +
 mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch added to -mm tree
Date: Mon, 11 Nov 2013 15:20:54 -0800
Message-ID: <52816656.GEwQysPyWifA3rH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3KKXUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: + mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch added to -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:20:54 -0800


The patch titled
     Subject: mm: numa: return the number of base pages altered by protection changes
has been added to the -mm tree.  Its filename is
     mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/mprotect.c                 |    6 +++++-
 mm/vmstat.c                   |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

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
@@ -138,6 +138,7 @@ static inline unsigned long change_pmd_r
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long pages = 0;
+	unsigned long nr_huge_updates = 0;
 	bool all_same_node;
 
 	pmd = pmd_offset(pud, addr);
@@ -148,7 +149,8 @@ static inline unsigned long change_pmd_r
 				split_huge_page_pmd(vma, addr, pmd);
 			else if (change_huge_pmd(vma, pmd, addr, newprot,
 						 prot_numa)) {
-				pages++;
+				pages += HPAGE_PMD_NR;
+				nr_huge_updates++;
 				continue;
 			}
 			/* fall through */
@@ -168,6 +170,8 @@ static inline unsigned long change_pmd_r
 			change_pmd_protnuma(vma->vm_mm, addr, pmd);
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

mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-do-not-walk-all-of-system-memory-during-show_mem.patch
mm-fix-page_group_by_mobility_disabled-breakage.patch
mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag.patch
mm-__rmqueue_fallback-should-respect-pageblock-type.patch
mm-numa-return-the-number-of-base-pages-altered-by-protection-changes.patch
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

