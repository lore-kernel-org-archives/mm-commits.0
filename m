From: akpm@linux-foundation.org
Subject: - git-block-hack-hack-hack.patch removed from -mm tree
Date: Thu, 08 May 2008 14:53:24 -0700
Message-ID: <200805082204.m48M4J5Y008147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762985AbYEHWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 18:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block-hack-hack-hack
has been removed from the -mm tree.  Its filename was
     git-block-hack-hack-hack.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-block-hack-hack-hack
From: Andrew Morton <akpm@linux-foundation.org>

cat Documentation/SubmitChecklist

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/smp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN arch/x86/xen/smp.c~git-block-hack-hack-hack arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~git-block-hack-hack-hack
+++ a/arch/x86/xen/smp.c
@@ -111,12 +111,16 @@ static int xen_smp_intr_init(unsigned in
 	per_cpu(debug_irq, cpu) = rc;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
+#if 0
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
 				    cpu,
 				    xen_call_function_single_interrupt,
 				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
+#else
+	BUG();
+#endif
 	if (rc < 0)
 		goto fail;
 	per_cpu(callfuncsingle_irq, cpu) = rc;
@@ -354,8 +358,11 @@ void xen_smp_send_call_function_ipi(cpum
 {
 	int cpu;
 
+#if 0
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
-
+#else
+	BUG();
+#endif
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu_mask(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
@@ -367,7 +374,11 @@ void xen_smp_send_call_function_ipi(cpum
 
 void xen_smp_send_call_function_single_ipi(int cpu)
 {
+#if 0
 	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+#else
+	BUG();
+#endif
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
revert-git-block.patch
git-block-hack-hack-hack.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
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

