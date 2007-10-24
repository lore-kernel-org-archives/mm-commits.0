From: akpm@linux-foundation.org
Subject: + x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:52:27 -0700
Message-ID: <200710242252.l9OMqR6O016629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbXJXWws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM


The patch titled
     x86_64: set cpu_index to NR_CPUS instead of 0
has been added to the -mm tree.  Its filename is
     x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: set cpu_index to NR_CPUS instead of 0
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Same BIOS will support two/four dualcore/quadcore system, and will get

ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)

SMP: Allowing 16 CPUs, 12 hotplug CPUs

the /proc/cpuinfo will show as bunch of NULL cpus with cpu_index=0

so assign impossible cpu_index value at first instead of 0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot_64.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN arch/x86/kernel/smpboot_64.c~x86_64-set-cpu_index-to-nr_cpus-instead-of-0 arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86_64-set-cpu_index-to-nr_cpus-instead-of-0
+++ a/arch/x86/kernel/smpboot_64.c
@@ -862,6 +862,18 @@ void __init smp_set_apicids(void)
 	x86_cpu_to_apicid_ptr = NULL;
 }
 
+static void __init smp_cpu_index_default(void)
+{
+	int i;
+	struct cpuinfo_x86 *c;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		c = &cpu_data(i);
+		/* mark all to hotplug */
+		c->cpu_index = NR_CPUS;
+	}
+}
+
 /*
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
@@ -869,6 +881,7 @@ void __init smp_set_apicids(void)
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
+	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
 	current_thread_info()->cpu = 0;  /* needed? */
 	smp_set_apicids();
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
kernel-printkc-concerns-about-the-console-handover.patch
