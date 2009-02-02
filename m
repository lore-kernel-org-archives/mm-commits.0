From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:25:27 -0800
Message-ID: <200902021925.n12JPRo8030583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbZBBT0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:26:01 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n12JPSsf008025
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 2 Feb 2009 11:25:29 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/uio-howto.tmpl    |   11 -----------
 MAINTAINERS                             |    3 ---
 arch/arm/configs/magician_defconfig     |    3 ---
 arch/powerpc/configs/44x/warp_defconfig |    4 ----
 drivers/firewire/fw-sbp2.c              |    4 ----
 drivers/usb/gadget/imx_udc.c            |    4 ----
 fs/Kconfig                              |   16 ----------------
 include/linux/debugfs.h                 |    6 ------
 kernel/irq/handle.c                     |    6 ------
 9 files changed, 57 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2102,10 +2102,7 @@ M:	khali@linux-fr.org
 P:	Ben Dooks (embedded platforms)
 M:	ben-linux@fluff.org
 L:	linux-i2c@vger.kernel.org
-<<<<<<< HEAD:MAINTAINERS
 W:	http://i2c.wiki.kernel.org/
-=======
->>>>>>> FETCH_HEAD:MAINTAINERS
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
 S:	Maintained
 
diff -puN arch/arm/configs/magician_defconfig~linux-next-git-rejects arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/magician_defconfig
@@ -748,10 +748,7 @@ CONFIG_I2C_PXA=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-<<<<<<< HEAD:arch/arm/configs/magician_defconfig
-=======
 # CONFIG_AT24 is not set
->>>>>>> FETCH_HEAD:arch/arm/configs/magician_defconfig
 # CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
diff -puN fs/Kconfig~linux-next-git-rejects fs/Kconfig
--- a/fs/Kconfig~linux-next-git-rejects
+++ a/fs/Kconfig
@@ -250,10 +250,6 @@ menuconfig NETWORK_FILESYSTEMS
 
 if NETWORK_FILESYSTEMS
 
-<<<<<<< HEAD:fs/Kconfig
-source "fs/nfs/Kconfig"
-source "fs/nfsd/Kconfig"
-=======
 config NFS_FS
 	tristate "NFS client support"
 	depends on INET
@@ -430,7 +426,6 @@ config NFSD_V4
 	  available from http://linux-nfs.org/.
 
 	  If unsure, say N.
->>>>>>> FETCH_HEAD:fs/Kconfig
 
 config LOCKD
 	tristate
@@ -452,10 +447,6 @@ config NFS_COMMON
 	depends on NFSD || NFS_FS
 	default y
 
-<<<<<<< HEAD:fs/Kconfig
-source "net/sunrpc/Kconfig"
-source "fs/smbfs/Kconfig"
-=======
 config SUNRPC
 	tristate
 
@@ -591,14 +582,8 @@ config SMB_NLS_REMOTE
 
 	  smbmount from samba 2.2.0 or later supports this.
 
->>>>>>> FETCH_HEAD:fs/Kconfig
 source "fs/cifs/Kconfig"
 source "fs/ncpfs/Kconfig"
-<<<<<<< HEAD:fs/Kconfig
-source "fs/coda/Kconfig"
-source "fs/afs/Kconfig"
-source "fs/9p/Kconfig"
-=======
 
 config CODA_FS
 	tristate "Coda file system support (advanced network fs)"
@@ -662,7 +647,6 @@ config 9P_FS
 	  See <http://v9fs.sf.net> for more information.
 
 	  If unsure, say N.
->>>>>>> FETCH_HEAD:fs/Kconfig
 
 endif # NETWORK_FILESYSTEMS
 
diff -puN include/linux/debugfs.h~linux-next-git-rejects include/linux/debugfs.h
--- a/include/linux/debugfs.h~linux-next-git-rejects
+++ a/include/linux/debugfs.h
@@ -162,16 +162,10 @@ static inline struct dentry *debugfs_cre
 	return ERR_PTR(-ENODEV);
 }
 
-<<<<<<< HEAD:include/linux/debugfs.h
-static inline struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
-				     struct dentry *parent,
-				     size_t *value)
-=======
 static inline struct dentry *debugfs_create_size_t(const char *name,
 						   mode_t mode,
 						   struct dentry *parent,
 						   size_t *value)
->>>>>>> FETCH_HEAD:include/linux/debugfs.h
 {
 	return ERR_PTR(-ENODEV);
 }
diff -puN arch/powerpc/configs/44x/warp_defconfig~linux-next-git-rejects arch/powerpc/configs/44x/warp_defconfig
--- a/arch/powerpc/configs/44x/warp_defconfig~linux-next-git-rejects
+++ a/arch/powerpc/configs/44x/warp_defconfig
@@ -685,11 +685,7 @@ CONFIG_I2C_IBM_IIC=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-<<<<<<< HEAD:arch/powerpc/configs/44x/warp_defconfig
-CONFIG_EEPROM_AT24=y
-=======
 # CONFIG_EEPROM_AT24 is not set
->>>>>>> FETCH_HEAD:arch/powerpc/configs/44x/warp_defconfig
 CONFIG_EEPROM_LEGACY=y
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
diff -puN drivers/usb/gadget/imx_udc.c~linux-next-git-rejects drivers/usb/gadget/imx_udc.c
--- a/drivers/usb/gadget/imx_udc.c~linux-next-git-rejects
+++ a/drivers/usb/gadget/imx_udc.c
@@ -303,12 +303,8 @@ void imx_ep_stall(struct imx_ep_struct *
 			imx_usb->base + USB_EP_STAT(EP_NO(imx_ep)));
 
 		for (i = 0; i < 100; i ++) {
-<<<<<<< HEAD:drivers/usb/gadget/imx_udc.c
-			temp = __raw_readl(imx_usb->base + USB_EP_STAT(EP_NO(imx_ep)));
-=======
 			temp = __raw_readl(imx_usb->base
 						+ USB_EP_STAT(EP_NO(imx_ep)));
->>>>>>> FETCH_HEAD:drivers/usb/gadget/imx_udc.c
 			if (!(temp & EPSTAT_STALL))
 	 			break;
 	 		udelay(20);
diff -puN kernel/irq/handle.c~linux-next-git-rejects kernel/irq/handle.c
--- a/kernel/irq/handle.c~linux-next-git-rejects
+++ a/kernel/irq/handle.c
@@ -145,13 +145,10 @@ int __init early_irq_init(void)
 	int legacy_count;
 	int i;
 
-<<<<<<< HEAD:kernel/irq/handle.c
 	init_irq_default_affinity();
-=======
 	 /* initialize nr_irqs based on nr_cpu_ids */
 	arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
->>>>>>> FETCH_HEAD:kernel/irq/handle.c
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
@@ -246,11 +243,8 @@ int __init early_irq_init(void)
 	int count;
 	int i;
 
-<<<<<<< HEAD:kernel/irq/handle.c
 	init_irq_default_affinity();
-=======
 	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
->>>>>>> FETCH_HEAD:kernel/irq/handle.c
 
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
diff -puN drivers/ata/ahci.c~linux-next-git-rejects drivers/ata/ahci.c
diff -puN Documentation/DocBook/uio-howto.tmpl~linux-next-git-rejects Documentation/DocBook/uio-howto.tmpl
--- a/Documentation/DocBook/uio-howto.tmpl~linux-next-git-rejects
+++ a/Documentation/DocBook/uio-howto.tmpl
@@ -41,17 +41,6 @@ GPL version 2.
 </abstract>
 
 <revhistory>
-	<revision>
-<<<<<<< HEAD:Documentation/DocBook/uio-howto.tmpl
-=======
-	<revnumber>0.8</revnumber>
-	<date>2008-12-24</date>
-	<authorinitials>hjk</authorinitials>
-	<revremark>Added name attributes in mem and portio sysfs directories.
-		</revremark>
-	</revision>
-	<revision>
->>>>>>> FETCH_HEAD:Documentation/DocBook/uio-howto.tmpl
 	<revnumber>0.7</revnumber>
 	<date>2008-12-23</date>
 	<authorinitials>hjk</authorinitials>
diff -puN drivers/firewire/fw-sbp2.c~linux-next-git-rejects drivers/firewire/fw-sbp2.c
--- a/drivers/firewire/fw-sbp2.c~linux-next-git-rejects
+++ a/drivers/firewire/fw-sbp2.c
@@ -1280,7 +1280,6 @@ static struct fw_driver sbp2_driver = {
 	.id_table = sbp2_id_table,
 };
 
-<<<<<<< HEAD:drivers/firewire/fw-sbp2.c
 static void sbp2_unmap_scatterlist(struct device *card_device,
 				   struct sbp2_command_orb *orb)
 {
@@ -1296,9 +1295,6 @@ static void sbp2_unmap_scatterlist(struc
 
 static unsigned int
 sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
-=======
-static unsigned int sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
->>>>>>> FETCH_HEAD:drivers/firewire/fw-sbp2.c
 {
 	int sam_status;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

