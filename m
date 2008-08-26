From: akpm@linux-foundation.org
Subject: - arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch removed from -mm tree
Date: Tue, 26 Aug 2008 10:54:16 -0700
Message-ID: <200808261754.m7QHsG5F019259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109AbYHZRzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 13:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, randy.dunlap@oracle.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/io_apic_64.c: fix printk warnings
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/io_apic_64.c: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/io_apic_64.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_64.c:1284: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
arch/x86/kernel/io_apic_64.c:1285: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/io_apic_64.c~arch-x86-kernel-io_apic_64c-fix-printk-warnings arch/x86/kernel/io_apic_64.c
--- a/arch/x86/kernel/io_apic_64.c~arch-x86-kernel-io_apic_64c-fix-printk-warnings
+++ a/arch/x86/kernel/io_apic_64.c
@@ -1281,8 +1281,8 @@ __apicdebuginit(void) print_local_APIC(v
 	printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08lx\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08lx\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
git-alsa-tiwai.patch
git-powerpc-merge.patch
git-powerpc.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
git-drm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch
git-mtd.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

