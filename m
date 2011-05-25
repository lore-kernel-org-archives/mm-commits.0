From: akpm@linux-foundation.org
Subject: [folded] cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 24 May 2011 17:02:53 -0700
Message-ID: <201105250002.p4P02rrI024231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932838Ab1EYADb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jesper.nilsson@axis.com, kosaki.motohiro@jp.fujitsu.com, starvik@axis.com, tfransosi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch

This patch was dropped because it was folded into cris-convert-old-cpumask-api-into-new-one.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements (8, 12)
#39: FILE: arch/cris/arch-v32/kernel/smp.c:83:
 	for (i = 0; i < max_cpus; i++)
+	    cpumask_set_cpu(i, &phys_cpu_present_map);

total: 0 errors, 1 warnings, 113 lines checked

./patches/cris-convert-old-cpumask-api-into-new-one.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Thiago Farina <tfransosi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/kernel/smp.c~cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c~cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes
+++ a/arch/cris/arch-v32/kernel/smp.c
@@ -81,7 +81,7 @@ void __init smp_prepare_cpus(unsigned in
 
 	/* Mark all possible CPUs as present */
 	for (i = 0; i < max_cpus; i++)
-	    cpumask_set_cpu(i, &phys_cpu_present_map);
+		cpumask_set_cpu(i, &phys_cpu_present_map);
 }
 
 void __devinit smp_prepare_boot_cpu(void)
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
alpha-hook-up-gpiolib-support.patch
cris-convert-old-cpumask-api-into-new-one.patch
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

