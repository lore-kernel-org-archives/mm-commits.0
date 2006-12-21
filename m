From: akpm@osdl.org
Subject: - proper-prototype-for-drivers-base-initcdriver_init.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:42 -0800
Message-ID: <200612210036.kBL0agr4011219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53596 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161092AbWLUAj6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:39:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, greg@kroah.com, hmh@hmh.eng.br, mm-commits@vger.kernel.org


The patch titled
     proper prototype for drivers/base/init.c:driver_init()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-drivers-base-initcdriver_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proper prototype for drivers/base/init.c:driver_init()
From: Adrian Bunk <bunk@stusta.de>

Add a prototype for driver_init() in include/linux/device.h.

Also remove a static function of the same name in drivers/acpi/ibm_acpi.c to
ibm_acpi_driver_init() to fix the namespace collision.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/ibm_acpi.c |    4 ++--
 include/linux/device.h  |    2 ++
 init/main.c             |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/ibm_acpi.c~proper-prototype-for-drivers-base-initcdriver_init drivers/acpi/ibm_acpi.c
--- a/drivers/acpi/ibm_acpi.c~proper-prototype-for-drivers-base-initcdriver_init
+++ a/drivers/acpi/ibm_acpi.c
@@ -493,7 +493,7 @@ static char *next_cmd(char **cmds)
 	return start;
 }
 
-static int driver_init(void)
+static int ibm_acpi_driver_init(void)
 {
 	printk(IBM_INFO "%s v%s\n", IBM_DESC, IBM_VERSION);
 	printk(IBM_INFO "%s\n", IBM_URL);
@@ -2297,7 +2297,7 @@ static void fan_watchdog_fire(struct wor
 static struct ibm_struct ibms[] = {
 	{
 	 .name = "driver",
-	 .init = driver_init,
+	 .init = ibm_acpi_driver_init,
 	 .read = driver_read,
 	 },
 	{
diff -puN include/linux/device.h~proper-prototype-for-drivers-base-initcdriver_init include/linux/device.h
--- a/include/linux/device.h~proper-prototype-for-drivers-base-initcdriver_init
+++ a/include/linux/device.h
@@ -433,6 +433,8 @@ static inline int device_is_registered(s
 	return dev->is_registered;
 }
 
+void driver_init(void);
+
 /*
  * High level routines for use by the bus drivers
  */
diff -puN init/main.c~proper-prototype-for-drivers-base-initcdriver_init init/main.c
--- a/init/main.c~proper-prototype-for-drivers-base-initcdriver_init
+++ a/init/main.c
@@ -53,6 +53,7 @@
 #include <linux/utsrelease.h>
 #include <linux/pid_namespace.h>
 #include <linux/compile.h>
+#include <linux/device.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -94,7 +95,6 @@ extern void pidmap_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
-extern void driver_init(void);
 extern void prepare_namespace(void);
 #ifdef	CONFIG_ACPI
 extern void acpi_early_init(void);
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
usbvision-possible-cleanups.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

