From: akpm@linux-foundation.org
Subject: - arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:40 -0800
Message-ID: <200811251957.mAPJvftu029205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYKYT56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:57:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/setup.c: omit dmi_low_memory_corruption() when it is unneeded
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/setup.c: omit dmi_low_memory_corruption() when it is unneeded
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

arch/x86/kernel/setup.c:736: warning: 'dmi_low_memory_corruption' defined but not used

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/setup.c~arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded
+++ a/arch/x86/kernel/setup.c
@@ -588,6 +588,7 @@ static struct x86_quirks default_x86_qui
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -602,7 +603,6 @@ static int __init dmi_low_memory_corrupt
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-#ifdef CONFIG_X86_RESERVE_LOW_64K
 	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
@@ -617,10 +617,19 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
 		},
 	},
-#endif
 	{}
 };
 
+static inline void handle_bad_bios_dmi_table(void)
+{
+	dmi_check_system(bad_bios_dmi_table);
+}
+#else
+static inline void handle_bad_bios_dmi_table(void)
+{
+}
+#endif
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -757,7 +766,7 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
-	dmi_check_system(bad_bios_dmi_table);
+	handle_bad_bios_dmi_table();
 
 	/*
 	 * VMware detection requires dmi to be available, so this
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-introduce-resource-usage-limits.patch
epoll-introduce-resource-usage-limits-update-refix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
kernel-profilec-fix-section-mismatch-warning-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

