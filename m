From: akpm@osdl.org
Subject: - acpi-make-code-static.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:35 -0800
Message-ID: <200612210036.kBL0aZR2011210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53592 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161122AbWLUAjt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: make code static
has been removed from the -mm tree.  Its filename was
     acpi-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: make code static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/bus.c          |    2 +-
 drivers/acpi/dock.c         |    4 ++--
 drivers/acpi/pci_bind.c     |    4 ++--
 include/acpi/acpi_bus.h     |    2 --
 include/acpi/acpi_drivers.h |    2 --
 5 files changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/bus.c~acpi-make-code-static drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~acpi-make-code-static
+++ a/drivers/acpi/bus.c
@@ -728,7 +728,7 @@ static int __init acpi_bus_init(void)
 	return -ENODEV;
 }
 
-decl_subsys(acpi, NULL, NULL);
+static decl_subsys(acpi, NULL, NULL);
 
 static int __init acpi_init(void)
 {
diff -puN drivers/acpi/dock.c~acpi-make-code-static drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-make-code-static
+++ a/drivers/acpi/dock.c
@@ -641,7 +641,7 @@ static ssize_t show_docked(struct device
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
 
 }
-DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
+static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
 /*
  * write_undock - write method for "undock" file in sysfs
@@ -657,7 +657,7 @@ static ssize_t write_undock(struct devic
 	ret = handle_eject_request(dock_station, ACPI_NOTIFY_EJECT_REQUEST);
 	return ret ? ret: count;
 }
-DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
+static DEVICE_ATTR(undock, S_IWUSR, NULL, write_undock);
 
 /**
  * dock_add - add a new dock station
diff -puN drivers/acpi/pci_bind.c~acpi-make-code-static drivers/acpi/pci_bind.c
--- a/drivers/acpi/pci_bind.c~acpi-make-code-static
+++ a/drivers/acpi/pci_bind.c
@@ -106,7 +106,7 @@ acpi_status acpi_get_pci_id(acpi_handle 
 
 EXPORT_SYMBOL(acpi_get_pci_id);
 
-int acpi_pci_bind(struct acpi_device *device)
+static int acpi_pci_bind(struct acpi_device *device)
 {
 	int result = 0;
 	acpi_status status = AE_OK;
@@ -267,7 +267,7 @@ int acpi_pci_bind(struct acpi_device *de
 	return result;
 }
 
-int acpi_pci_unbind(struct acpi_device *device)
+static int acpi_pci_unbind(struct acpi_device *device)
 {
 	int result = 0;
 	acpi_status status = AE_OK;
diff -puN include/acpi/acpi_bus.h~acpi-make-code-static include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-make-code-static
+++ a/include/acpi/acpi_bus.h
@@ -315,8 +315,6 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-extern struct subsystem acpi_subsys;
-
 /*
  * External Functions
  */
diff -puN include/acpi/acpi_drivers.h~acpi-make-code-static include/acpi/acpi_drivers.h
--- a/include/acpi/acpi_drivers.h~acpi-make-code-static
+++ a/include/acpi/acpi_drivers.h
@@ -66,8 +66,6 @@ void acpi_pci_irq_del_prt(int segment, i
 struct pci_bus;
 
 acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
-int acpi_pci_bind(struct acpi_device *device);
-int acpi_pci_unbind(struct acpi_device *device);
 int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
 		       struct pci_bus *bus);
 
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

