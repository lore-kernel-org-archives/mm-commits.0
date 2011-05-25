From: akpm@linux-foundation.org
Subject: [folded] nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 24 May 2011 17:00:31 -0700
Message-ID: <201105250000.p4P00VPY024176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932838Ab1EYAAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lliubbo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nommu-add-page-alignment-to-mmap-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch

This patch was dropped because it was folded into nommu-add-page-alignment-to-mmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu-add-page-alignment-to-mmap-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#110: FILE: mm/nommu.c:1644:
+	if ((len = PAGE_ALIGN(len)) == 0)

total: 1 errors, 0 warnings, 89 lines checked

./patches/nommu-add-page-alignment-to-mmap.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/nommu.c~nommu-add-page-alignment-to-mmap-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~nommu-add-page-alignment-to-mmap-checkpatch-fixes
+++ a/mm/nommu.c
@@ -1641,7 +1641,8 @@ int do_munmap(struct mm_struct *mm, unsi
 
 	kenter(",%lx,%zx", start, len);
 
-	if ((len = PAGE_ALIGN(len)) == 0)
+	len = PAGE_ALIGN(len);
+	if (len == 0)
 		return -EINVAL;
 
 	end = start + len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
nommu-add-page-alignment-to-mmap.patch
alpha-hook-up-gpiolib-support-fix.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq-fix.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

