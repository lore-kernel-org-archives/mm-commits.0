From: akpm@linux-foundation.org
Subject: - revert-libata-improve-post-reset-device-ready-test.patch removed from -mm tree
Date: Thu, 08 May 2008 14:58:11 -0700
Message-ID: <200805082209.m48M96pQ008317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760730AbYEHWKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 18:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, htejun@gmail.com, jgarzik@redhat.com, markus@trippelsdorf.de, mm-commits@vger.kernel.org


The patch titled
     revert "libata: improve post-reset device ready test"
has been removed from the -mm tree.  Its filename was
     revert-libata-improve-post-reset-device-ready-test.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "libata: improve post-reset device ready test"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 78ab88f04f44bed566d51dce0c7cbfeff6449a06
Author: Tejun Heo <htejun@gmail.com>
Date:   Thu May 1 23:41:41 2008 +0900

    libata: improve post-reset device ready test
    
    Some controllers (jmb and inic162x) use 0x77 and 0x7f to indicate that
    the device isn't ready yet.  It looks like they use 0xff if device
    presence is detected but connection isn't established.  0x77 or 0x7f
    after connection is established and use the value from signature FIS
    after receiving it.
    
    This patch implements ata_check_ready(), which takes TF status value
    and determines whether the port is ready or not considering the above
    and other conditions, and use it in @check_ready() functions.  This is
    safe as both 0x77 and 0x7f aren't valid ready status value even though
    they have BSY bit cleared.
    
    This fixes hot plug detection failures which can be triggered with
    certain drives if they aren't already spun up when the data connector
    is hot plugged.
    
    Tested on sil, sil24, ahci (jmb/ich), piix and inic162x combined with
    eight drives from all major vendors.
    
    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Because it causes a long delay and several error messages at boot time.

The offending commit was identified by Markus Trippelsdorf.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c       |    4 +++-
 drivers/ata/libata-sff.c |    6 +++++-
 include/linux/libata.h   |   15 ---------------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff -puN drivers/ata/ahci.c~revert-libata-improve-post-reset-device-ready-test drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~revert-libata-improve-post-reset-device-ready-test
+++ a/drivers/ata/ahci.c
@@ -1267,7 +1267,9 @@ static int ahci_check_ready(struct ata_l
 	void __iomem *port_mmio = ahci_port_base(link->ap);
 	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
 
-	return ata_check_ready(status);
+	if (!(status & ATA_BUSY))
+		return 1;
+	return 0;
 }
 
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
diff -puN drivers/ata/libata-sff.c~revert-libata-improve-post-reset-device-ready-test drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~revert-libata-improve-post-reset-device-ready-test
+++ a/drivers/ata/libata-sff.c
@@ -314,7 +314,11 @@ static int ata_sff_check_ready(struct at
 {
 	u8 status = link->ap->ops->sff_check_status(link->ap);
 
-	return ata_check_ready(status);
+	if (!(status & ATA_BUSY))
+		return 1;
+	if (status == 0xff)
+		return -ENODEV;
+	return 0;
 }
 
 /**
diff -puN include/linux/libata.h~revert-libata-improve-post-reset-device-ready-test include/linux/libata.h
--- a/include/linux/libata.h~revert-libata-improve-post-reset-device-ready-test
+++ a/include/linux/libata.h
@@ -1382,21 +1382,6 @@ static inline struct ata_port *ata_shost
 	return *(struct ata_port **)&host->hostdata[0];
 }
 
-static inline int ata_check_ready(u8 status)
-{
-	/* Some controllers report 0x77 or 0x7f during intermediate
-	 * not-ready stages.
-	 */
-	if (status == 0x77 || status == 0x7f)
-		return 0;
-
-	/* 0xff indicates either no device or device not ready */
-	if (status == 0xff)
-		return -ENODEV;
-
-	return !(status & ATA_BUSY);
-}
-
 
 /**************************************************************************
  * PMP - drivers/ata/libata-pmp.c
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
flag-parameters-anon_inode_getfd-extension-fix.patch
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

