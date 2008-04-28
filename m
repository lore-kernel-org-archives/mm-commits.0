From: akpm@linux-foundation.org
Subject: - serial-silence-section-mismatch-warnings-in-8250_pci.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:13 -0700
Message-ID: <200804282155.m3SLtDSF018086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934403AbYD1VzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: silence section mismatch warnings in 8250_pci
has been removed from the -mm tree.  Its filename was
     serial-silence-section-mismatch-warnings-in-8250_pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kbuild.patch
git-m32r.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
git-s390.patch
git-sh.patch
scsi-fix-section-mismatch-in-aic94xx.patch
git-watchdog.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
documentation-build-source-files-in-documentation-sub-dir.patch
ipmi-remove-unused-target-and-action-in-makefile.patch
tpm-fix-section-mismatch-warning.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

