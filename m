From: akpm@linux-foundation.org
Subject: + ioc3-ioc4-various-section-fixes.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:58:21 -0800
Message-ID: <200912032258.nB3MwMaI005262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbZLCW6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, alan@lxorguk.ukuu.org.uk, pfg@sgi.com


The patch titled
     ioc3/ioc4: various section fixes
has been added to the -mm tree.  Its filename is
     ioc3-ioc4-various-section-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioc3/ioc4: various section fixes
From: Jean Delvare <khali@linux-fr.org>

Several IOC3 and IOC4 drivers misuse the __devinit and __devexit section
markers.  Use __init and __exit instead as appropriate, then add __devinit
and __devexit where they really belong for PCI drivers.

Also make ioc4_serial_init static.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Pat Gefre <pfg@sgi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c          |   16 ++++++++--------
 drivers/serial/ioc3_serial.c |    4 ++--
 drivers/serial/ioc4_serial.c |    4 ++--
 drivers/sn/ioc3.c            |   15 ++++++++-------
 4 files changed, 20 insertions(+), 19 deletions(-)

diff -puN drivers/misc/ioc4.c~ioc3-ioc4-various-section-fixes drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~ioc3-ioc4-various-section-fixes
+++ a/drivers/misc/ioc4.c
@@ -138,7 +138,7 @@ ioc4_unregister_submodule(struct ioc4_su
  * even though the following code utilizes external interrupt registers
  * to perform the speed calculation.
  */
-static void
+static void __devinit
 ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 {
 	union ioc4_int_out int_out;
@@ -230,7 +230,7 @@ ioc4_clock_calibrate(struct ioc4_driver_
  * on the same PCI bus at slot number 3 to differentiate IO9 from IO10.
  * If neither is present, it's a PCI-RT.
  */
-static unsigned int
+static unsigned int __devinit
 ioc4_variant(struct ioc4_driver_data *idd)
 {
 	struct pci_dev *pdev = NULL;
@@ -269,7 +269,7 @@ ioc4_variant(struct ioc4_driver_data *id
 	return IOC4_VARIANT_PCI_RT;
 }
 
-static void
+static void __devinit
 ioc4_load_modules(struct work_struct *work)
 {
 	/* arg just has to be freed */
@@ -280,7 +280,7 @@ ioc4_load_modules(struct work_struct *wo
 }
 
 /* Adds a new instance of an IOC4 card */
-static int
+static int __devinit
 ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct ioc4_driver_data *idd;
@@ -425,7 +425,7 @@ out:
 }
 
 /* Removes a particular instance of an IOC4 card. */
-static void
+static void __devexit
 ioc4_remove(struct pci_dev *pdev)
 {
 	struct ioc4_submodule *is;
@@ -476,7 +476,7 @@ static struct pci_driver ioc4_driver = {
 	.name = "IOC4",
 	.id_table = ioc4_id_table,
 	.probe = ioc4_probe,
-	.remove = ioc4_remove,
+	.remove = __devexit_p(ioc4_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, ioc4_id_table);
@@ -486,14 +486,14 @@ MODULE_DEVICE_TABLE(pci, ioc4_id_table);
  *********************/
 
 /* Module load */
-static int __devinit
+static int __init
 ioc4_init(void)
 {
 	return pci_register_driver(&ioc4_driver);
 }
 
 /* Module unload */
-static void __devexit
+static void __exit
 ioc4_exit(void)
 {
 	/* Ensure ioc4_load_modules() has completed before exiting */
diff -puN drivers/serial/ioc3_serial.c~ioc3-ioc4-various-section-fixes drivers/serial/ioc3_serial.c
--- a/drivers/serial/ioc3_serial.c~ioc3-ioc4-various-section-fixes
+++ a/drivers/serial/ioc3_serial.c
@@ -2162,7 +2162,7 @@ static struct ioc3_submodule ioc3uart_op
 /**
  * ioc3_detect - module init called,
  */
-static int __devinit ioc3uart_init(void)
+static int __init ioc3uart_init(void)
 {
 	int ret;
 
@@ -2179,7 +2179,7 @@ static int __devinit ioc3uart_init(void)
 	return ret;
 }
 
-static void __devexit ioc3uart_exit(void)
+static void __exit ioc3uart_exit(void)
 {
 	ioc3_unregister_submodule(&ioc3uart_ops);
 	uart_unregister_driver(&ioc3_uart);
diff -puN drivers/serial/ioc4_serial.c~ioc3-ioc4-various-section-fixes drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~ioc3-ioc4-various-section-fixes
+++ a/drivers/serial/ioc4_serial.c
@@ -2904,7 +2904,7 @@ static struct ioc4_submodule ioc4_serial
 /**
  * ioc4_serial_init - module init
  */
-int ioc4_serial_init(void)
+static int __init ioc4_serial_init(void)
 {
 	int ret;
 
@@ -2926,7 +2926,7 @@ int ioc4_serial_init(void)
 	return ioc4_register_submodule(&ioc4_serial_submodule);
 }
 
-static void __devexit ioc4_serial_exit(void)
+static void __exit ioc4_serial_exit(void)
 {
 	ioc4_unregister_submodule(&ioc4_serial_submodule);
 	uart_unregister_driver(&ioc4_uart_rs232);
diff -puN drivers/sn/ioc3.c~ioc3-ioc4-various-section-fixes drivers/sn/ioc3.c
--- a/drivers/sn/ioc3.c~ioc3-ioc4-various-section-fixes
+++ a/drivers/sn/ioc3.c
@@ -574,11 +574,11 @@ void ioc3_unregister_submodule(struct io
  * Device management *
  *********************/
 
-static char *
+static char * __devinitdata
 ioc3_class_names[]={"unknown", "IP27 BaseIO", "IP30 system", "MENET 1/2/3",
 			"MENET 4", "CADduo", "Altix Serial"};
 
-static int ioc3_class(struct ioc3_driver_data *idd)
+static int __devinit ioc3_class(struct ioc3_driver_data *idd)
 {
 	int res = IOC3_CLASS_NONE;
 	/* NIC-based logic */
@@ -601,7 +601,8 @@ static int ioc3_class(struct ioc3_driver
 	return res;
 }
 /* Adds a new instance of an IOC3 card */
-static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+static int __devinit
+ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct ioc3_driver_data *idd;
 	uint32_t pcmd;
@@ -753,7 +754,7 @@ out:
 }
 
 /* Removes a particular instance of an IOC3 card. */
-static void ioc3_remove(struct pci_dev *pdev)
+static void __devexit ioc3_remove(struct pci_dev *pdev)
 {
 	int id;
 	struct ioc3_driver_data *idd;
@@ -805,7 +806,7 @@ static struct pci_driver ioc3_driver = {
 	.name = "IOC3",
 	.id_table = ioc3_id_table,
 	.probe = ioc3_probe,
-	.remove = ioc3_remove,
+	.remove = __devexit_p(ioc3_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, ioc3_id_table);
@@ -815,7 +816,7 @@ MODULE_DEVICE_TABLE(pci, ioc3_id_table);
  *********************/
 
 /* Module load */
-static int __devinit ioc3_init(void)
+static int __init ioc3_init(void)
 {
 	if (ia64_platform_is("sn2"))
 		return pci_register_driver(&ioc3_driver);
@@ -823,7 +824,7 @@ static int __devinit ioc3_init(void)
 }
 
 /* Module unload */
-static void __devexit ioc3_exit(void)
+static void __exit ioc3_exit(void)
 {
 	pci_unregister_driver(&ioc3_driver);
 }
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
ioc3-ioc4-various-section-fixes.patch
ioc3-ioc4-fix-error-path-on-driver-registration.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
hwmon-w83627ehf-updates.patch
k10temp-temperature-sensor-driver-for-amd-family-10h-11h-cpus.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
resource-constify-arg-to-resource_size-and-resource_type.patch

