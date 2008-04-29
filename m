From: akpm@linux-foundation.org
Subject: - x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:29:16 -0700
Message-ID: <200804290529.m3T5TGKm003079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbYD2F3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, dilinger@debian.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-olpc-add-one-laptop-per-child-architecture-support-fix-2
has been removed from the -mm tree.  Its filename was
     x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch

This patch was dropped because it was folded into x86-olpc-add-one-laptop-per-child-architecture-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-olpc-add-one-laptop-per-child-architecture-support-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

oops, we turned on CONFIG_OLPC.

ERROR: "olpc_register_battery_callback" [drivers/power/olpc_battery.ko] undefined!
ERROR: "olpc_deregister_battery_callback" [drivers/power/olpc_battery.ko] undefined!

Cc: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |    2 --
 include/asm-x86/olpc.h       |    3 ---
 2 files changed, 5 deletions(-)

diff -puN include/asm-x86/olpc.h~x86-olpc-add-one-laptop-per-child-architecture-support-fix-2 include/asm-x86/olpc.h
--- a/include/asm-x86/olpc.h~x86-olpc-add-one-laptop-per-child-architecture-support-fix-2
+++ a/include/asm-x86/olpc.h
@@ -102,9 +102,6 @@ extern int olpc_ec_cmd(unsigned char cmd
 extern int olpc_ec_mask_set(uint8_t bits);
 extern int olpc_ec_mask_unset(uint8_t bits);
 
-extern void olpc_register_battery_callback(void (*f)(unsigned long));
-extern void olpc_deregister_battery_callback(void);
-
 /* EC commands */
 
 #define EC_FIRMWARE_REV		0x08
diff -puN drivers/power/olpc_battery.c~x86-olpc-add-one-laptop-per-child-architecture-support-fix-2 drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~x86-olpc-add-one-laptop-per-child-architecture-support-fix-2
+++ a/drivers/power/olpc_battery.c
@@ -315,7 +315,6 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto battery_failed;
 
-	olpc_register_battery_callback(&olpc_battery_trigger_uevent);
 	goto success;
 
 battery_failed:
@@ -328,7 +327,6 @@ success:
 
 static void __exit olpc_bat_exit(void)
 {
-	olpc_deregister_battery_callback();
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
 	platform_device_unregister(bat_pdev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

