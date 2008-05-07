From: akpm@linux-foundation.org
Subject: + drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch added to -mm tree
Date: Tue, 06 May 2008 19:58:14 -0700
Message-ID: <200805070309.m47397MZ008457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYEGDJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 23:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, miquels@cistron.nl


The patch titled
     drivers/scsi/dpt_i2o.c: fix build on alpha
has been added to the -mm tree.  Its filename is
     drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/dpt_i2o.c: fix build on alpha
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/scsi/dpt_i2o.c:1997: error: implicit declaration of function 'adpt_alpha_info'
drivers/scsi/dpt_i2o.c: At top level:
drivers/scsi/dpt_i2o.c:2032: warning: conflicting types for 'adpt_alpha_info'
drivers/scsi/dpt_i2o.c:2032: error: static declaration of 'adpt_alpha_info' follows non-static declaration
drivers/scsi/dpt_i2o.c:1997: error: previous implicit declaration of 'adpt_alpha_info' was here

Due to a copy-n-paste error in drivers/scsi/dpti.h.

Fix that up and remove some of the many daft static-declarations-in-a-header
which this driver enjoys.

Cc: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |   78 ++++++++++++++++++---------------------
 drivers/scsi/dpti.h    |   13 ------
 2 files changed, 36 insertions(+), 55 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-fix-build-on-alpha drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-fix-build-on-alpha
+++ a/drivers/scsi/dpt_i2o.c
@@ -1967,45 +1967,6 @@ cleanup:
 	return rcode;
 }
 
-
-/*
- * This routine returns information about the system.  This does not effect
- * any logic and if the info is wrong - it doesn't matter.
- */
-
-/* Get all the info we can not get from kernel services */
-static int adpt_system_info(void __user *buffer)
-{
-	sysInfo_S si;
-
-	memset(&si, 0, sizeof(si));
-
-	si.osType = OS_LINUX;
-	si.osMajorVersion = 0;
-	si.osMinorVersion = 0;
-	si.osRevision = 0;
-	si.busType = SI_PCI_BUS;
-	si.processorFamily = DPTI_sig.dsProcessorFamily;
-
-#if defined __i386__ 
-	adpt_i386_info(&si);
-#elif defined (__ia64__)
-	adpt_ia64_info(&si);
-#elif defined(__sparc__)
-	adpt_sparc_info(&si);
-#elif defined (__alpha__)
-	adpt_alpha_info(&si);
-#else
-	si.processorType = 0xff ;
-#endif
-	if(copy_to_user(buffer, &si, sizeof(si))){
-		printk(KERN_WARNING"dpti: Could not copy buffer TO user\n");
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
 #if defined __ia64__ 
 static void adpt_ia64_info(sysInfo_S* si)
 {
@@ -2016,7 +1977,6 @@ static void adpt_ia64_info(sysInfo_S* si
 }
 #endif
 
-
 #if defined __sparc__ 
 static void adpt_sparc_info(sysInfo_S* si)
 {
@@ -2026,7 +1986,6 @@ static void adpt_sparc_info(sysInfo_S* s
 	si->processorType = PROC_ULTRASPARC;
 }
 #endif
-
 #if defined __alpha__ 
 static void adpt_alpha_info(sysInfo_S* si)
 {
@@ -2038,7 +1997,6 @@ static void adpt_alpha_info(sysInfo_S* s
 #endif
 
 #if defined __i386__
-
 static void adpt_i386_info(sysInfo_S* si)
 {
 	// This is all the info we need for now
@@ -2059,9 +2017,45 @@ static void adpt_i386_info(sysInfo_S* si
 		break;
 	}
 }
+#endif
+
+/*
+ * This routine returns information about the system.  This does not effect
+ * any logic and if the info is wrong - it doesn't matter.
+ */
+
+/* Get all the info we can not get from kernel services */
+static int adpt_system_info(void __user *buffer)
+{
+	sysInfo_S si;
+
+	memset(&si, 0, sizeof(si));
+
+	si.osType = OS_LINUX;
+	si.osMajorVersion = 0;
+	si.osMinorVersion = 0;
+	si.osRevision = 0;
+	si.busType = SI_PCI_BUS;
+	si.processorFamily = DPTI_sig.dsProcessorFamily;
 
+#if defined __i386__
+	adpt_i386_info(&si);
+#elif defined (__ia64__)
+	adpt_ia64_info(&si);
+#elif defined(__sparc__)
+	adpt_sparc_info(&si);
+#elif defined (__alpha__)
+	adpt_alpha_info(&si);
+#else
+	si.processorType = 0xff ;
 #endif
+	if(copy_to_user(buffer, &si, sizeof(si))){
+		printk(KERN_WARNING"dpti: Could not copy buffer TO user\n");
+		return -EFAULT;
+	}
 
+	return 0;
+}
 
 static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 	      ulong arg)
diff -puN drivers/scsi/dpti.h~drivers-scsi-dpt_i2oc-fix-build-on-alpha drivers/scsi/dpti.h
--- a/drivers/scsi/dpti.h~drivers-scsi-dpt_i2oc-fix-build-on-alpha
+++ a/drivers/scsi/dpti.h
@@ -316,19 +316,6 @@ static int adpt_close(struct inode *inod
 static void adpt_delay(int millisec);
 #endif
 
-#if defined __ia64__ 
-static void adpt_ia64_info(sysInfo_S* si);
-#endif
-#if defined __sparc__ 
-static void adpt_sparc_info(sysInfo_S* si);
-#endif
-#if defined __alpha__ 
-static void adpt_sparc_info(sysInfo_S* si);
-#endif
-#if defined __i386__
-static void adpt_i386_info(sysInfo_S* si);
-#endif
-
 #define PRINT_BUFFER_SIZE     512
 
 #define HBA_FLAGS_DBG_FLAGS_MASK         0xffff0000	// Mask for debug flags
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
git-kgdb.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-kvm.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
git-net-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
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

