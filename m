From: akpm@linux-foundation.org
Subject: + scsi-fix-section-mismatch-in-aic94xx.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:04:20 -0800
Message-ID: <200802181005.m1IA5IcJ019188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYBRKFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:05:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, James.Bottomley@SteelEye.com, gilbert_wu@adaptec.com


The patch titled
     scsi: fix section mismatch in aic94xx
has been added to the -mm tree.  Its filename is
     scsi-fix-section-mismatch-in-aic94xx.patch

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
Subject: scsi: fix section mismatch in aic94xx
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()

asd_pcidev_data is only used by __devinit asd_pci_probe.  So mark is const and
annotate it __devinitconst to fix the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilbert Wu <gilbert_wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -531,10 +531,10 @@ static void asd_remove_dev_attrs(struct 
 /* The first entry, 0, is used for dynamic ids, the rest for devices
  * we know about.
  */
-static struct asd_pcidev_struct {
+static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] = {
+} asd_pcidev_data[] __devinitconst = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
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
