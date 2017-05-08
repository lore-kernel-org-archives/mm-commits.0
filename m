From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 08 May 2017 12:14:17 -0700
Message-ID: <20170508191417.8EpInvbJf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbdEHTOT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 15:14:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/media/v4l-drivers/philips.rst     |    5 -----
 drivers/char/tpm/tpm-chip.c                     |   12 ------------
 drivers/firmware/google/memconsole-x86-legacy.c |    3 ---
 drivers/misc/Kconfig                            |    3 ---
 drivers/misc/Makefile                           |    3 ---
 drivers/scsi/osd/osd_uld.c                      |    5 -----
 drivers/staging/Makefile                        |    4 ----
 7 files changed, 35 deletions(-)

diff -puN Documentation/media/v4l-drivers/philips.rst~linux-next-git-rejects Documentation/media/v4l-drivers/philips.rst
--- a/Documentation/media/v4l-drivers/philips.rst~linux-next-git-rejects
+++ a/Documentation/media/v4l-drivers/philips.rst
@@ -145,13 +145,8 @@ dev_hint
 
    A camera is specified by its type (the number from the camera model,
    like PCA645, PCVC750VC, etc) and optionally the serial number (visible
-<<<<<<< HEAD
-   in /sys/kernel/debug/usb/devices). A hint consists of a string with the
-   following format::
-=======
    in /sys/kernel/debug/usb/devices). A hint consists of a string with the following
    format::
->>>>>>> linux-next/akpm-base
 
       [type[.serialnumber]:]node
 
diff -puN drivers/char/tpm/tpm-chip.c~linux-next-git-rejects drivers/char/tpm/tpm-chip.c
--- a/drivers/char/tpm/tpm-chip.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm-chip.c
@@ -282,17 +282,6 @@ static int tpm_add_char_device(struct tp
 		return rc;
 	}
 
-<<<<<<< HEAD
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = cdev_device_add(&chip->cdevs, &chip->devs);
-		if (rc) {
-			dev_err(&chip->devs,
-				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
-				dev_name(&chip->devs), MAJOR(chip->devs.devt),
-				MINOR(chip->devs.devt), rc);
-			return rc;
-		}
-=======
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		rc = cdev_device_add(&chip->cdevs, &chip->devs);
 	if (rc) {
@@ -301,7 +290,6 @@ static int tpm_add_char_device(struct tp
 			dev_name(&chip->devs), MAJOR(chip->devs.devt),
 			MINOR(chip->devs.devt), rc);
 		return rc;
->>>>>>> linux-next/akpm-base
 	}
 
 	/* Make the chip available. */
diff -puN drivers/firmware/google/memconsole-x86-legacy.c~linux-next-git-rejects drivers/firmware/google/memconsole-x86-legacy.c
--- a/drivers/firmware/google/memconsole-x86-legacy.c~linux-next-git-rejects
+++ a/drivers/firmware/google/memconsole-x86-legacy.c
@@ -20,10 +20,7 @@
 #include <linux/dmi.h>
 #include <linux/mm.h>
 #include <asm/bios_ebda.h>
-<<<<<<< HEAD
-=======
 #include <asm/e820/api.h>
->>>>>>> linux-next/akpm-base
 #include <linux/acpi.h>
 
 #include "memconsole.h"
diff -puN drivers/misc/Kconfig~linux-next-git-rejects drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~linux-next-git-rejects
+++ a/drivers/misc/Kconfig
@@ -489,8 +489,6 @@ config ASPEED_LPC_CTRL
 	  Control Aspeed ast2400/2500 HOST LPC to BMC mappings through
 	  ioctl()s, the driver also provides a read/write interface to a BMC ram
 	  region where the host LPC read/write region can be buffered.
-<<<<<<< HEAD
-=======
 
 config PCI_ENDPOINT_TEST
 	depends on PCI
@@ -498,7 +496,6 @@ config PCI_ENDPOINT_TEST
 	---help---
            Enable this configuration option to enable the host side test driver
            for PCI Endpoint.
->>>>>>> linux-next/akpm-base
 
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
diff -puN drivers/misc/Makefile~linux-next-git-rejects drivers/misc/Makefile
--- a/drivers/misc/Makefile~linux-next-git-rejects
+++ a/drivers/misc/Makefile
@@ -53,10 +53,7 @@ obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
 obj-$(CONFIG_ASPEED_LPC_CTRL)	+= aspeed-lpc-ctrl.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_PCI_ENDPOINT_TEST)	+= pci_endpoint_test.o
->>>>>>> linux-next/akpm-base
 
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_core.o
 lkdtm-$(CONFIG_LKDTM)		+= lkdtm_bugs.o
diff -puN drivers/scsi/osd/osd_uld.c~linux-next-git-rejects drivers/scsi/osd/osd_uld.c
--- a/drivers/scsi/osd/osd_uld.c~linux-next-git-rejects
+++ a/drivers/scsi/osd/osd_uld.c
@@ -454,12 +454,7 @@ static int osd_probe(struct device *dev)
 	/* hold one more reference to the scsi_device that will get released
 	 * in __release, in case a logout is happening while fs is mounted
 	 */
-<<<<<<< HEAD
-	if (scsi_device_get(scsi_device))
-		goto err_retract_minor;
-=======
 	scsi_device_get(scsi_device);
->>>>>>> linux-next/akpm-base
 	osd_dev_init(&oud->od, scsi_device);
 
 	/* allocate a disk and set it up */
diff -puN drivers/staging/Makefile~linux-next-git-rejects drivers/staging/Makefile
--- a/drivers/staging/Makefile~linux-next-git-rejects
+++ a/drivers/staging/Makefile
@@ -43,8 +43,4 @@ obj-$(CONFIG_MOST)		+= most/
 obj-$(CONFIG_KS7010)		+= ks7010/
 obj-$(CONFIG_GREYBUS)		+= greybus/
 obj-$(CONFIG_BCM2835_VCHIQ)	+= vc04_services/
-<<<<<<< HEAD
-obj-$(CONFIG_SND_BCM2835)	+= bcm2835-audio/
-=======
 obj-$(CONFIG_CRYPTO_DEV_CCREE)	+= ccree/
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

