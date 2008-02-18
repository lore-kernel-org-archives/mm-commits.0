From: akpm@linux-foundation.org
Subject: + acer-wmi-fix-section-mismatch-warnings.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:55:49 -0800
Message-ID: <200802180956.m1I9uluO018697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYBRJ5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:57:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, carlos@strangeworlds.co.uk, len.brown@intel.com, rpurdie@rpsys.net


The patch titled
     acer-wmi: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     acer-wmi-fix-section-mismatch-warnings.patch

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
Subject: acer-wmi: fix section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.text+0x672615): Section mismatch in reference from the function acer_platform_remove() to the function .exit.text:acer_backlight_exit()
WARNING: vmlinux.o(.devinit.text+0x1e859): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_led_init()
WARNING: vmlinux.o(.devinit.text+0x1e878): Section mismatch in reference from the function acer_platform_probe() to the function .init.text:acer_backlight_init()

Remove __exit annotation from acer_backlight_exit(). We cannot reference
a __exit annotated function from non __exit functions.

acer_led_init() and acer_backlight_init() where both annotated __init but used
from a __devinit function.  This would result in an oops should gcc drop their
inlining and the module are hot plugged.

Fix by annotating acer_led_init() and acer_backlight_init() __devinit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/acer-wmi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/acer-wmi.c~acer-wmi-fix-section-mismatch-warnings drivers/misc/acer-wmi.c
--- a/drivers/misc/acer-wmi.c~acer-wmi-fix-section-mismatch-warnings
+++ a/drivers/misc/acer-wmi.c
@@ -756,7 +756,7 @@ static struct led_classdev mail_led = {
 	.brightness_set = mail_led_set,
 };
 
-static int __init acer_led_init(struct device *dev)
+static int __devinit acer_led_init(struct device *dev)
 {
 	return led_classdev_register(dev, &mail_led);
 }
@@ -789,7 +789,7 @@ static struct backlight_ops acer_bl_ops 
 	.update_status = update_bl_status,
 };
 
-static int __init acer_backlight_init(struct device *dev)
+static int __devinit acer_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
 
@@ -808,7 +808,7 @@ static int __init acer_backlight_init(st
 	return 0;
 }
 
-static void __exit acer_backlight_exit(void)
+static void acer_backlight_exit(void)
 {
 	backlight_device_unregister(acer_backlight_device);
 }
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
