From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:11:17 -0800
Message-ID: <5488d315.umbNZNqmbwp/uXKt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319AbaLJXLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:11:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mingo@kernel.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix.patch

This patch was dropped because it was folded into mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix

tweak comment

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix mm/cma.c
--- a/mm/cma.c~mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix
+++ a/mm/cma.c
@@ -220,12 +220,11 @@ int __init cma_declare_contiguous(phys_a
 
 #ifdef CONFIG_X86
 	/*
-	 * high_memory isn't direct mapped memory so retrieving it's
-	 * physical address isn't appropriate. But, it would be useful
-	 * to check physical address of highmem boundary so it's
-	 * justfiable to get physical address from it. In x86, there is
-	 * a validation check for this case, so following workaround is
-	 * needed to avoid it.
+	 * high_memory isn't direct mapped memory so retrieving its physical
+	 * address isn't appropriate.  But it would be useful to check the
+	 * physical address of the highmem boundary so it's justfiable to get
+	 * the physical address from it.  On x86 there is a validation check for
+	 * this case, so the following workaround is needed to avoid it.
 	 */
 	highmem_start = __pa_nodebug(high_memory);
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

