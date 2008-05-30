From: akpm@linux-foundation.org
Subject: - git-watchdog-git-rejects.patch removed from -mm tree
Date: Fri, 30 May 2008 15:19:31 -0700
Message-ID: <200805302219.m4UMJV4W014138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbYE3WTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:19:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4UMJVYc025585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 30 May 2008 15:19:32 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-watchdog-git-rejects
has been removed from the -mm tree.  Its filename was
     git-watchdog-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-watchdog-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/iTCO_wdt.c    |    5 -----
 drivers/watchdog/it8712f_wdt.c |   11 -----------
 2 files changed, 16 deletions(-)

diff -puN drivers/watchdog/it8712f_wdt.c~git-watchdog-git-rejects drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c~git-watchdog-git-rejects
+++ a/drivers/watchdog/it8712f_wdt.c
@@ -170,14 +170,9 @@ it8712f_wdt_update_margin(void)
 	superio_outb(config, WDT_CONFIG);
 
 	if (revision >= 0x08)
-<<<<<<< HEAD:drivers/watchdog/it8712f_wdt.c
-		superio_outb(units >> 8, WDT_TIMEOUT + 1);
-	superio_outb(units, WDT_TIMEOUT);
-=======
 		superio_outw(units, WDT_TIMEOUT);
 	else
 		superio_outb(units, WDT_TIMEOUT);
->>>>>>> FETCH_HEAD:drivers/watchdog/it8712f_wdt.c
 }
 
 static int
@@ -298,15 +293,9 @@ it8712f_wdt_ioctl(struct inode *inode, s
 		if (get_user(value, p))
 			return -EFAULT;
 		if (value < 1)
-<<<<<<< HEAD:drivers/watchdog/it8712f_wdt.c
 			return -EINVAL;
 		if (value > (max_units * 60))
 			return -EINVAL;
-=======
-			return -EINVAL;
-		if (value > (max_units * 60))
-			return -EINVAL;
->>>>>>> FETCH_HEAD:drivers/watchdog/it8712f_wdt.c
 		margin = value;
 		superio_enter();
 		superio_select(LDN_GPIO);
diff -puN drivers/watchdog/iTCO_wdt.c~git-watchdog-git-rejects drivers/watchdog/iTCO_wdt.c
--- a/drivers/watchdog/iTCO_wdt.c~git-watchdog-git-rejects
+++ a/drivers/watchdog/iTCO_wdt.c
@@ -56,13 +56,8 @@
 
 /* Module and version information */
 #define DRV_NAME        "iTCO_wdt"
-<<<<<<< HEAD:drivers/watchdog/iTCO_wdt.c
-#define DRV_VERSION     "1.03"
-#define DRV_RELDATE     "30-Apr-2008"
-=======
 #define DRV_VERSION     "1.10"
 #define DRV_RELDATE     "17-Aug-2007"
->>>>>>> FETCH_HEAD:drivers/watchdog/iTCO_wdt.c
 #define PFX		DRV_NAME ": "
 
 /* Includes */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
next-fix-rejects.patch
linux-next-fixup.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
lguest-use-cpu-capability-accessors.patch
arch-x86-mm-patc-nopat-should-be-__init.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
svcrdma-fix-compile-warning-on-32-bit-platforms-checkpatch-fixes.patch
sched-delete-dead-stuff.patch
sched-delete-dead-stuff-2.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
git-watchdog-git-rejects.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2-checkpatch-fixes-cleanup-fix.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
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

