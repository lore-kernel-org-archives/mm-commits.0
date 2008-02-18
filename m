From: akpm@linux-foundation.org
Subject: + pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:02:13 -0800
Message-ID: <200802181003.m1IA3BEd019092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbYBRKDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, linux@dominikbrodowski.net


The patch titled
     pcmcia: silence section mismatch warnings from class_interface variables
has been added to the -mm tree.  Its filename is
     pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch

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
Subject: pcmcia: silence section mismatch warnings from class_interface variables
From: Sam Ravnborg <sam@ravnborg.org>

Silence the following warnings:
WARNING: drivers/pcmcia/built-in.o(.data+0x348): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_add_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0x350): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_remove_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0x6e8): Section mismatch in reference from the variable pcmcia_bus_interface to the function .devinit.text:pcmcia_bus_add_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0xa88): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devinit.text:pccard_sysfs_add_rsrc()
WARNING: drivers/pcmcia/built-in.o(.data+0xa90): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devexit.text:pccard_sysfs_remove_rsrc()

The variables of type class_interface contains references
to __devinit and __devexit functions which is OK.
Silence warnings by annotating the variables with __refdata.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c             |    2 +-
 drivers/pcmcia/rsrc_nonstatic.c |    2 +-
 drivers/pcmcia/socket_sysfs.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pcmcia/ds.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables
+++ a/drivers/pcmcia/ds.c
@@ -1520,7 +1520,7 @@ static void pcmcia_bus_remove_socket(str
 
 
 /* the pcmcia_bus_interface is used to handle pcmcia socket devices */
-static struct class_interface pcmcia_bus_interface = {
+static struct class_interface pcmcia_bus_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pcmcia_bus_add_socket,
 	.remove_dev = &pcmcia_bus_remove_socket,
diff -puN drivers/pcmcia/rsrc_nonstatic.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables drivers/pcmcia/rsrc_nonstatic.c
--- a/drivers/pcmcia/rsrc_nonstatic.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables
+++ a/drivers/pcmcia/rsrc_nonstatic.c
@@ -1045,7 +1045,7 @@ static void __devexit pccard_sysfs_remov
 		device_remove_file(dev, *attr);
 }
 
-static struct class_interface pccard_rsrc_interface = {
+static struct class_interface pccard_rsrc_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_rsrc,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_rsrc),
diff -puN drivers/pcmcia/socket_sysfs.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables drivers/pcmcia/socket_sysfs.c
--- a/drivers/pcmcia/socket_sysfs.c~pcmcia-silence-section-mismatch-warnings-from-class_interface-variables
+++ a/drivers/pcmcia/socket_sysfs.c
@@ -403,7 +403,7 @@ static void __devexit pccard_sysfs_remov
 		device_remove_file(dev, *attr);
 }
 
-struct class_interface pccard_sysfs_interface = {
+struct class_interface pccard_sysfs_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_socket,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_socket),
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
