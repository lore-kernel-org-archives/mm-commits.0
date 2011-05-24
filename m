From: akpm@linux-foundation.org
Subject: [folded] mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 16:55:24 -0700
Message-ID: <201105242355.p4ONtOw0023873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863Ab1EXXzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch

This patch was dropped because it was folded into mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/tboot.c:113: error: unknown field 'cpu_vm_mask' specified in initializer
arch/x86/kernel/tboot.c:113: error: incompatible types when initializing type 'long unsigned int' using type 'cpumask_t'

Correct?

Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tboot.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/tboot.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix
+++ a/arch/x86/kernel/tboot.c
@@ -110,7 +110,6 @@ static struct mm_struct tboot_mm = {
 	.mmap_sem       = __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask    = CPU_MASK_ALL,
 };
 
 static inline void switch_to_tboot_pt(void)
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
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4-fix-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
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

