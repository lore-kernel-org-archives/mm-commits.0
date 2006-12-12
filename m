From: akpm@osdl.org
Subject: + acpi-dont-enable-link-device-in-ioapic-mode.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:39:04 -0800
Message-ID: <200612122039.kBCKd41N015068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39095 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbWLLUjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, len.brown@intel.com, stian_web@jordet.nu


The patch titled
     acpi: don't enable link device in IOAPIC mode
has been added to the -mm tree.  Its filename is
     acpi-dont-enable-link-device-in-ioapic-mode.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: don't enable link device in IOAPIC mode
From: Shaohua Li <shaohua.li@intel.com>

In Stian's system, if link device is enabled in IOAPIC mode, pci device
will connect to link device and link device connect to IOAPIC pin.  That is
the device's interrupt is decided by link's irq.  If link device is
disabled, pci device is connected to IOAPIC pin.

There are two devices who share one link device in pic mode, but in IOAPIC
mode, _PRT table reported one device connected to IOAPIC pin and the other
connected to the link device.  If the link device is enabled, the device
connected to IOAPIC pin directly will break as _PRT reported interrupt for
the device doesn't reflect the case link device is enabled

If we leave the link device disabled, the device which connected to the
link device doesn't break.  It appears the link device is just used to get
an interrupt number instead of for real interrupt routing.  So in this
patch, if current irq model is IOAPIC, we will leave link device disabled
and just use its active irq number.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Cc: Stian Jordet <stian_web@jordet.nu>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/pci_link.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/acpi/pci_link.c~acpi-dont-enable-link-device-in-ioapic-mode drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-dont-enable-link-device-in-ioapic-mode
+++ a/drivers/acpi/pci_link.c
@@ -526,6 +526,10 @@ static int acpi_pci_link_allocate(struct
 	int i;
 
 
+	if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC && link->irq.active) {
+		link->irq.initialized = 1;
+		return 0;
+	}
 	if (link->irq.initialized) {
 		if (link->refcnt == 0)
 			/* This means the link is disabled but initialized */
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
git-acpi.patch
acpi-disable-irq-balance-even-in-apic-mode.patch
acpi-dont-enable-link-device-in-ioapic-mode.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch

