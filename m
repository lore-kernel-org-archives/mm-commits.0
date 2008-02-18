From: akpm@linux-foundation.org
Subject: + serial-silence-section-mismatch-warnings-in-8250_pci.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:02:32 -0800
Message-ID: <200802181003.m1IA3U0d019129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYBRKE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, rmk+kernel@arm.linux.org.uk


The patch titled
     serial: silence section mismatch warnings in 8250_pci
has been added to the -mm tree.  Its filename is
     serial-silence-section-mismatch-warnings-in-8250_pci.patch

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
Subject: serial: silence section mismatch warnings in 8250_pci
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: drivers/serial/built-in.o(.data+0x5b8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_ite887x_exit()
WARNING: drivers/serial/built-in.o(.data+0x5e0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x608): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x658): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x680): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x6a8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:pci_plx9050_exit()
WARNING: drivers/serial/built-in.o(.data+0x6d0): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x6f8): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x720): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()
WARNING: drivers/serial/built-in.o(.data+0x748): Section mismatch in reference from the variable pci_serial_quirks to the function .devexit.text:sbs_exit()

pci_serial_quirks contains a number of function pointers where the referenced
function is annotated __devexit.  This is OK so we annotate pci_serial_quirks
with __refdata to ignore the __devexit references

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~serial-silence-section-mismatch-warnings-in-8250_pci drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-silence-section-mismatch-warnings-in-8250_pci
+++ a/drivers/serial/8250_pci.c
@@ -775,7 +775,7 @@ pci_default_setup(struct serial_private 
  * This list is ordered alphabetically by vendor then device.
  * Specific entries must come before more generic entries.
  */
-static struct pci_serial_quirk pci_serial_quirks[] = {
+static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	/*
 	* ADDI-DATA GmbH communication cards <info@addi-data.com>
 	*/
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
