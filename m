From: akpm@linux-foundation.org
Subject: - acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:26 -0800
Message-ID: <200802232021.m1NKLQdN013335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760712AbYBWUWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
has been removed from the -mm tree.  Its filename was
     acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x55586c): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()

acpi_processor_hotplug_notify() may safely reference __cpuinit stuff as it ids
defined inside an ACPI_HOTPLUG_CPU block.  So annotate it __ref to silence the
warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify
+++ a/drivers/acpi/processor_core.c
@@ -886,8 +886,8 @@ int acpi_processor_device_add(acpi_handl
 	return 0;
 }
 
-static void
-acpi_processor_hotplug_notify(acpi_handle handle, u32 event, void *data)
+static void __ref acpi_processor_hotplug_notify(acpi_handle handle,
+						u32 event, void *data)
 {
 	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
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
