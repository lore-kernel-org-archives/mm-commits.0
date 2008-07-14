From: akpm@linux-foundation.org
Subject: - todays-linux-next-fails-to-boot.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:18 -0700
Message-ID: <200807141935.m6EJZIMn023892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbYGNTfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     today's linux-next fails to boot
has been removed from the -mm tree.  Its filename was
     todays-linux-next-fails-to-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: today's linux-next fails to boot
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Hi Ingo,

On Friday, 11 of July 2008, Rafael J. Wysocki wrote:
> On Friday, 11 of July 2008, Ingo Molnar wrote:
> >
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
[--snip--]
>
> Well, it turns out that linux-next from today doesn't boot on my box too
> (64-bit) and I don't see anything obviously suspicious.  Bisection time.

I have identified the source of the breakage on my box, but I don't really
think it's the same problem that Edwin is observing.

Namely, it turns out that some code in arch/x86/kernel/acpi/boot.c, as in
today's linux-next, doesn't really make sense, because we have two conflicting
DMA-based quirks in there for the same set of boxes (HP nx6325 and nx6125) and
one of them actually breaks my box.

I have reported that already, but it probably got lost somewhere.

Below is a patch that fixes things for me, on top of today's linux-next.
Please apply.

Thanks,
Rafael

---
Remove some code that breaks my HP nx6325 from arch/x86/kernel/acpi/boot.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c |   47 ----------------------------------
 1 file changed, 47 deletions(-)

diff -puN arch/x86/kernel/acpi/boot.c~todays-linux-next-fails-to-boot arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~todays-linux-next-fails-to-boot
+++ a/arch/x86/kernel/acpi/boot.c
@@ -84,8 +84,6 @@ int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
-static int disable_irq0_through_ioapic __initdata;
-
 u8 acpi_sci_flags __initdata;
 int acpi_sci_override_gsi __initdata;
 int acpi_skip_timer_override __initdata;
@@ -982,10 +980,6 @@ void __init mp_override_legacy_irq(u8 bu
 	int pin;
 	struct mp_config_intsrc mp_irq;
 
-	/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-	if (bus_irq == 0 && disable_irq0_through_ioapic)
-		return;
-
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
@@ -1052,10 +1046,6 @@ void __init mp_config_acpi_legacy_irqs(v
 	for (i = 0; i < 16; i++) {
 		int idx;
 
-		/* Skip the 8254 timer interrupt (IRQ 0) if requested.  */
-		if (i == 0 && disable_irq0_through_ioapic)
-			continue;
-
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
@@ -1413,17 +1403,6 @@ static int __init force_acpi_ht(const st
 }
 
 /*
- * Don't register any I/O APIC entries for the 8254 timer IRQ.
- */
-static int __init
-dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
-{
-	pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
-	disable_irq0_through_ioapic = 1;
-	return 0;
-}
-
-/*
  * Force ignoring BIOS IRQ0 pin2 override
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
@@ -1608,32 +1587,6 @@ static struct dmi_system_id __initdata a
 	 * is enabled.  This input is incorrectly designated the
 	 * ISA IRQ 0 via an interrupt source override even though
 	 * it is wired to the output of the master 8259A and INTIN0
-	 * is not connected at all.  Abandon any attempts to route
-	 * IRQ 0 through the I/O APIC therefore.
-	 */
-	{
-	 .callback = dmi_disable_irq0_through_ioapic,
-	 .ident = "HP NX6125 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6125"),
-		     },
-	 },
-	{
-	 .callback = dmi_disable_irq0_through_ioapic,
-	 .ident = "HP NX6325 laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
-		     },
-	 },
-	/*
-	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
-	 * which includes some code which overrides all temperature
-	 * trip points to 16C if the INTIN2 input of the I/O APIC
-	 * is enabled.  This input is incorrectly designated the
-	 * ISA IRQ 0 via an interrupt source override even though
-	 * it is wired to the output of the master 8259A and INTIN0
 	 * is not connected at all.  Force ignoring BIOS IRQ0 pin2
 	 * override in that cases.
 	 */
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
remove-include-linux-pm_legacyh.patch
pm-remove-definition-of-struct-pm_dev.patch
pm-remove-remaining-obsolete-definitions-from-pmh.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
pm-drop-unnecessary-includes-from-pmh.patch
pm-add-new-pm_event-codes-for-runtime-power-transitions.patch
pm-hibernation-simplify-memory-bitmap.patch
pm-serio-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
pm-acpi-hibernation-utilize-hardware-signature.patch
pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch
pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch

