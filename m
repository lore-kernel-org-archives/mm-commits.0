From: akpm@linux-foundation.org
Subject: [merged]
 mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom.patch removed from -mm
 tree
Date: Wed, 07 May 2014 12:05:03 -0700
Message-ID: <536a83df.np+eA0S1L3ErvspQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaEGTFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, nacc@linux.vnet.ibm.com, mhocko@suse.cz, mgorman@suse.de, m.mizuma@jp.fujitsu.com, lcapitulino@redhat.com, aneesh.kumar@linux.vnet.ibm.com, riel@redhat.com

Subject: [merged] mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom.patch removed from -mm tree
To: riel@redhat.com,aneesh.kumar@linux.vnet.ibm.com,lcapitulino@redhat.com,m.mizuma@jp.fujitsu.com,mgorman@suse.de,mhocko@suse.cz,nacc@linux.vnet.ibm.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:03 -0700


The patch titled
     Subject: mm/page-writeback.c: fix divide by zero in pos_ratio_polynom
has been removed from the -mm tree.  Its filename was
     mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

It is possible for "limit - setpoint + 1" to equal zero, after getting
truncated to a 32 bit variable, and resulting in a divide by zero error.

Using the fully 64 bit divide functions avoids this problem.  It also will
cause pos_ratio_polynom() to return the correct value when (setpoint -
limit) exceeds 2^32.

Also uninline pos_ratio_polynom, at Andrew's request.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom mm/page-writeback.c
--- a/mm/page-writeback.c~mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom
+++ a/mm/page-writeback.c
@@ -593,14 +593,14 @@ unsigned long bdi_dirty_limit(struct bac
  * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
  *     => fast response on large errors; small oscillation near setpoint
  */
-static inline long long pos_ratio_polynom(unsigned long setpoint,
+static long long pos_ratio_polynom(unsigned long setpoint,
 					  unsigned long dirty,
 					  unsigned long limit)
 {
 	long long pos_ratio;
 	long x;
 
-	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
+	x = div64_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
@@ -842,7 +842,7 @@ static unsigned long bdi_position_ratio(
 	x_intercept = bdi_setpoint + span;
 
 	if (bdi_dirty < x_intercept - span / 4) {
-		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
+		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
 				    x_intercept - bdi_setpoint + 1);
 	} else
 		pos_ratio /= 4;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-constify-nmask-argument-to-mbind.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
sysrq-rcu-ify-__handle_sysrq.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch

