From: akpm@osdl.org
Subject: + acpi-disable-irq-balance-even-in-apic-mode.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:39:00 -0800
Message-ID: <200612122039.kBCKd1lD015064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbWLLUjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, len.brown@intel.com, stian_web@jordet.nu


The patch titled
     acpi: disable irq balance even in APIC mode
has been added to the -mm tree.  Its filename is
     acpi-disable-irq-balance-even-in-apic-mode.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: disable irq balance even in APIC mode
From: Shaohua Li <shaohua.li@intel.com>

The two patches try to fix bug 2874, and Stian confirmed.  Basically in
Stian's system, _PRT table lets some devices use link device for irq
routing even in IOAPIC mode.  And in IOAPIC mode, if link device is
enabled, all devices linked to the link device in PIC mode will not connect
to IOAPIC pins, instead they will use PIC mode irq routing.  I'm not sure
if the patches will break other systems, so they should be test for a long
time.  http://bugzilla.kernel.org/show_bug.cgi?id=2874

acpi_irq_balance is for PCI link device (pci interrupt router), it hasn't
any relationship with APIC/IOAPIC.  Default enabling it in APIC mode
doesn't make sense to me.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Cc: Stian Jordet <stian_web@jordet.nu>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/boot.c |    1 -
 drivers/acpi/pci_link.c      |    2 +-
 include/asm-i386/acpi.h      |    1 -
 include/asm-x86_64/acpi.h    |    1 -
 4 files changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~acpi-disable-irq-balance-even-in-apic-mode arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~acpi-disable-irq-balance-even-in-apic-mode
+++ a/arch/i386/kernel/acpi/boot.c
@@ -927,7 +927,6 @@ static void __init acpi_process_madt(voi
 			error = acpi_parse_madt_ioapic_entries();
 			if (!error) {
 				acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
-				acpi_irq_balance_set(NULL);
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
diff -puN drivers/acpi/pci_link.c~acpi-disable-irq-balance-even-in-apic-mode drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-disable-irq-balance-even-in-apic-mode
+++ a/drivers/acpi/pci_link.c
@@ -897,7 +897,7 @@ static int __init acpi_irq_nobalance_set
 
 __setup("acpi_irq_nobalance", acpi_irq_nobalance_set);
 
-int __init acpi_irq_balance_set(char *str)
+static int __init acpi_irq_balance_set(char *str)
 {
 	acpi_irq_balance = 1;
 	return 1;
diff -puN include/asm-i386/acpi.h~acpi-disable-irq-balance-even-in-apic-mode include/asm-i386/acpi.h
--- a/include/asm-i386/acpi.h~acpi-disable-irq-balance-even-in-apic-mode
+++ a/include/asm-i386/acpi.h
@@ -119,7 +119,6 @@ static inline void acpi_disable_pci(void
 	acpi_pci_disabled = 1; 
 	acpi_noirq_set();
 }
-extern int acpi_irq_balance_set(char *str);
 
 #else	/* !CONFIG_ACPI */
 
diff -puN include/asm-x86_64/acpi.h~acpi-disable-irq-balance-even-in-apic-mode include/asm-x86_64/acpi.h
--- a/include/asm-x86_64/acpi.h~acpi-disable-irq-balance-even-in-apic-mode
+++ a/include/asm-x86_64/acpi.h
@@ -105,7 +105,6 @@ static inline void acpi_disable_pci(void
 	acpi_pci_disabled = 1; 
 	acpi_noirq_set();
 }
-extern int acpi_irq_balance_set(char *str);
 
 #else	/* !CONFIG_ACPI */
 
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

