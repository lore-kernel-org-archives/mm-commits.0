From: akpm@linux-foundation.org
Subject: + tpm-fix-section-mismatch-warning.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:10:44 -0800
Message-ID: <200802181011.m1IABgnT019475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758AbYBRKWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     tpm: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     tpm-fix-section-mismatch-warning.patch

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
Subject: tpm: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.init.text+0x32804): Section mismatch in reference from the function init_nsc() to the function .devexit.text:tpm_nsc_remove()

The function tpm_nsc_remove() are used outside __exit, so remove the __exit
annotation to make sure the function is always avilable.

Note: Trying to compare this module with other users of platform_device gve me
the impression that this driver needs some work to match other users.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_nsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm_nsc.c~tpm-fix-section-mismatch-warning drivers/char/tpm/tpm_nsc.c
--- a/drivers/char/tpm/tpm_nsc.c~tpm-fix-section-mismatch-warning
+++ a/drivers/char/tpm/tpm_nsc.c
@@ -264,7 +264,7 @@ static const struct tpm_vendor_specific 
 
 static struct platform_device *pdev = NULL;
 
-static void __devexit tpm_nsc_remove(struct device *dev)
+static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if ( chip ) {
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
