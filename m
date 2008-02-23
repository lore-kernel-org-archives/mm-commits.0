From: akpm@linux-foundation.org
Subject: - acpi-fix-section-mismatch-in-acpi_pci_root_add.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:24 -0800
Message-ID: <200802232021.m1NKLO6e013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760371AbYBWUWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix section mismatch in acpi_pci_root_add
has been removed from the -mm tree.  Its filename was
     acpi-fix-section-mismatch-in-acpi_pci_root_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix section mismatch in acpi_pci_root_add
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x550e85): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()

acpi_pci_root_add uses a __devinit annotated function and
it looks like annotating it __devinit too is the correct fix.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/pci_root.c~acpi-fix-section-mismatch-in-acpi_pci_root_add drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-fix-section-mismatch-in-acpi_pci_root_add
+++ a/drivers/acpi/pci_root.c
@@ -184,7 +184,7 @@ static void acpi_pci_bridge_scan(struct 
 		}
 }
 
-static int acpi_pci_root_add(struct acpi_device *device)
+static int __devinit acpi_pci_root_add(struct acpi_device *device)
 {
 	int result = 0;
 	struct acpi_pci_root *root = NULL;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
samples-build-fix.patch
git-acpi.patch
git-alsa.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
scsi-fix-section-mismatch-in-aic94xx.patch
solve-section-mismatch-for-free_area_init_core.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
