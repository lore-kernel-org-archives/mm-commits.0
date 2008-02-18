From: akpm@linux-foundation.org
Subject: + pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:02:18 -0800
Message-ID: <200802181003.m1IA3G9C019102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826AbYBRKDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, linux@dominikbrodowski.net


The patch titled
     pcmcia: silence section mismatch warnings from pci_driver variables
has been added to the -mm tree.  Its filename is
     pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch

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
Subject: pcmcia: silence section mismatch warnings from pci_driver variables
From: Sam Ravnborg <sam@ravnborg.org>

Silence following warnings:
WARNING: drivers/pcmcia/built-in.o(.data+0x14e0): Section mismatch in reference from the variable pd6729_pci_drv to the function .devinit.text:pd6729_pci_probe()
WARNING: drivers/pcmcia/built-in.o(.data+0x14e8): Section mismatch in reference from the variable pd6729_pci_drv to the function .devexit.text:pd6729_pci_remove()
WARNING: drivers/pcmcia/built-in.o(.data+0x16c0): Section mismatch in reference from the variable i82092aa_pci_drv to the function .devinit.text:i82092aa_pci_probe()
WARNING: drivers/pcmcia/built-in.o(.data+0x16c8): Section mismatch in reference from the variable i82092aa_pci_drv to the function .devexit.text:i82092aa_pci_remove()

Rename the variables from *_drv to *_driver so modpost ignore the OK
references to __devinit/__devexit functions.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/i82092.c |    6 +++---
 drivers/pcmcia/pd6729.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/pcmcia/i82092.c~pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables drivers/pcmcia/i82092.c
--- a/drivers/pcmcia/i82092.c~pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables
+++ a/drivers/pcmcia/i82092.c
@@ -53,7 +53,7 @@ static int i82092aa_socket_resume (struc
 }
 #endif
 
-static struct pci_driver i82092aa_pci_drv = {
+static struct pci_driver i82092aa_pci_driver = {
 	.name           = "i82092aa",
 	.id_table       = i82092aa_pci_ids,
 	.probe          = i82092aa_pci_probe,
@@ -714,13 +714,13 @@ static int i82092aa_set_mem_map(struct p
 
 static int i82092aa_module_init(void)
 {
-	return pci_register_driver(&i82092aa_pci_drv);
+	return pci_register_driver(&i82092aa_pci_driver);
 }
 
 static void i82092aa_module_exit(void)
 {
 	enter("i82092aa_module_exit");
-	pci_unregister_driver(&i82092aa_pci_drv);
+	pci_unregister_driver(&i82092aa_pci_driver);
 	if (sockets[0].io_base>0)
 			 release_region(sockets[0].io_base, 2);
 	leave("i82092aa_module_exit");
diff -puN drivers/pcmcia/pd6729.c~pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables drivers/pcmcia/pd6729.c
--- a/drivers/pcmcia/pd6729.c~pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables
+++ a/drivers/pcmcia/pd6729.c
@@ -778,7 +778,7 @@ static struct pci_device_id pd6729_pci_i
 };
 MODULE_DEVICE_TABLE(pci, pd6729_pci_ids);
 
-static struct pci_driver pd6729_pci_drv = {
+static struct pci_driver pd6729_pci_driver = {
 	.name		= "pd6729",
 	.id_table	= pd6729_pci_ids,
 	.probe		= pd6729_pci_probe,
@@ -791,12 +791,12 @@ static struct pci_driver pd6729_pci_drv 
 
 static int pd6729_module_init(void)
 {
-	return pci_register_driver(&pd6729_pci_drv);
+	return pci_register_driver(&pd6729_pci_driver);
 }
 
 static void pd6729_module_exit(void)
 {
-	pci_unregister_driver(&pd6729_pci_drv);
+	pci_unregister_driver(&pd6729_pci_driver);
 }
 
 module_init(pd6729_module_init);
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
