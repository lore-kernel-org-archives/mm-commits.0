From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-warning-when-config_debug_vm=n-fix.patch removed from -mm tree
Date: Mon, 13 Apr 2009 14:35:47 -0700
Message-ID: <200904132135.n3DLZmJg022526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbZDMVhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 17:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-remove-warning-when-config_debug_vm=n-fix
has been removed from the -mm tree.  Its filename was
     memcg-remove-warning-when-config_debug_vm=n-fix.patch

This patch was dropped because it was folded into memcg-remove-warning-when-config_debug_vm=n.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-warning-when-config_debug_vm=n-fix
From: Andrew Morton <akpm@linux-foundation.org>

simplify as suggested by Balbir.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-warning-when-config_debug_vm=n-fix
+++ a/mm/memcontrol.c
@@ -314,14 +314,13 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
-#ifdef CONFIG_DEBUG_VM
 static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
 {
 	if (!mem)
 		return true;
 	return css_is_removed(&mem->css);
 }
-#endif
+
 
 /*
  * Call callback function against all cgroup under hierarchy tree.
@@ -933,7 +932,7 @@ static int __mem_cgroup_try_charge(struc
 	if (unlikely(!mem))
 		return 0;
 
-	VM_BUG_ON(mem_cgroup_is_obsolete(mem));
+	VM_BUG_ON(!mem || mem_cgroup_is_obsolete(mem));
 
 	while (1) {
 		int ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hfs-fix-memory-leak-when-unmounting.patch
memcg-remove-warning-when-config_debug_vm=n.patch
memcg-remove-warning-when-config_debug_vm=n-fix.patch
shmem-respect-max_lfs_filesize-fix.patch
shmem-respect-max_lfs_filesize-fix-fix.patch
shmem-respect-max_lfs_filesize-fix-2.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-dont-open-code-smp_call_function_many.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

