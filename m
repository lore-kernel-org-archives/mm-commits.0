From: akpm@linux-foundation.org
Subject: + rtc-silence-section-mismatch-warning-in-rtc-test.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:15:15 -0800
Message-ID: <200802181016.m1IAGDUd019707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbYBRKRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: silence section mismatch warning in rtc-test
has been added to the -mm tree.  Its filename is
     rtc-silence-section-mismatch-warning-in-rtc-test.patch

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
Subject: rtc: silence section mismatch warning in rtc-test
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.data+0x253e28): Section mismatch in reference from the variable test_drv to the function .devexit.text:test_remove()

Fix by renaming the platfrom_driver variable from *_drv to *_driver
so modpost ignore the reference to an __devexit section.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-test.c~rtc-silence-section-mismatch-warning-in-rtc-test drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-silence-section-mismatch-warning-in-rtc-test
+++ a/drivers/rtc/rtc-test.c
@@ -147,7 +147,7 @@ static int __devexit test_remove(struct 
 	return 0;
 }
 
-static struct platform_driver test_drv = {
+static struct platform_driver test_driver = {
 	.probe	= test_probe,
 	.remove = __devexit_p(test_remove),
 	.driver = {
@@ -160,7 +160,7 @@ static int __init test_init(void)
 {
 	int err;
 
-	if ((err = platform_driver_register(&test_drv)))
+	if ((err = platform_driver_register(&test_driver)))
 		return err;
 
 	if ((test0 = platform_device_alloc("rtc-test", 0)) == NULL) {
@@ -191,7 +191,7 @@ exit_free_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 	return err;
 }
 
@@ -199,7 +199,7 @@ static void __exit test_exit(void)
 {
 	platform_device_unregister(test0);
 	platform_device_unregister(test1);
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 }
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
_

Patches currently in -mm which might be from sam@ravnborg.org are

samples-build-fix.patch
git-acpi.patch
acpi-fix-section-mismatch-in-acpi_pci_root_add.patch
acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify.patch
acer-wmi-fix-section-mismatch-warnings.patch
alsa-caiaq-fix-section-mismatch-warning.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
git-kbuild.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
scsi-fix-section-mismatch-in-aic94xx.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
