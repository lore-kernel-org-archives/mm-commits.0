From: akpm@linux-foundation.org
Subject: [merged] mm-numa-do-not-automatically-migrate-ksm-pages.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:44 -0800
Message-ID: <52e026b4.pkDkEWHomjkKDrWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVUOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-do-not-automatically-migrate-ksm-pages.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:44 -0800


The patch titled
     Subject: mm: numa: do not automatically migrate KSM pages
has been removed from the -mm tree.  Its filename was
     mm-numa-do-not-automatically-migrate-ksm-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: do not automatically migrate KSM pages

KSM pages can be shared between tasks that are not necessarily related to
each other from a NUMA perspective.  This patch causes those pages to be
ignored by automatic NUMA balancing so they do not migrate and do not
cause unrelated tasks to be grouped together.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mprotect.c~mm-numa-do-not-automatically-migrate-ksm-pages mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-do-not-automatically-migrate-ksm-pages
+++ a/mm/mprotect.c
@@ -23,6 +23,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/perf_event.h>
+#include <linux/ksm.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -63,7 +64,7 @@ static unsigned long change_pte_range(st
 
 				ptent = *pte;
 				page = vm_normal_page(vma, addr, oldpte);
-				if (page) {
+				if (page && !PageKsm(page)) {
 					if (!pte_numa(oldpte)) {
 						ptent = pte_mknuma(ptent);
 						set_pte_at(mm, addr, pte, ptent);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-improve-documentation-of-page_order-v2.patch
mm-improve-documentation-of-page_order-v2-fix.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

