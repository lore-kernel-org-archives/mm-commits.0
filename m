From: akpm@linux-foundation.org
Subject: - x86_64-clear-io_apic-before-enabing-apic-error-vector.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:52 -0700
Message-ID: <200708141914.l7EJEqsm016658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbXHNTVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@sun.com, ak@suse.de, ebiederm@xmission.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: clear IO_APIC before enabing apic error vector
has been removed from the -mm tree.  Its filename was
     x86_64-clear-io_apic-before-enabing-apic-error-vector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: clear IO_APIC before enabing apic error vector
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Some apic id lifting system: 4 socket quad core, 8 socket quad core will do
apic id lifting for BSP.

but io-apic regs for ExtINT still use 0 as dest.

so when we enable apic error vector in BSP, we will get one APIC error.

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ESR value after enabling vector: 00000000, after 0000000c
APIC error on CPU0: 0c(08)
ENABLING IO-APIC IRQs
Synchronizing Arb IDs.

So move enable_IO_APIC from setup_IO_APIC into setup_local_APIC and call it
before enabling apic error vector.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c    |    8 ++++++++
 arch/x86_64/kernel/io_apic.c |    7 +++++--
 include/asm-x86_64/hw_irq.h  |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-clear-io_apic-before-enabing-apic-error-vector arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-clear-io_apic-before-enabing-apic-error-vector
+++ a/arch/x86_64/kernel/apic.c
@@ -418,6 +418,14 @@ void __cpuinit setup_local_APIC (void)
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
 	apic_write(APIC_LVT1, value);
 
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (!smp_processor_id())
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+
 	{
 		unsigned oldvalue;
 		maxlvt = get_maxlvt();
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-clear-io_apic-before-enabing-apic-error-vector arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-clear-io_apic-before-enabing-apic-error-vector
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1165,7 +1165,7 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -1774,7 +1774,10 @@ __setup("no_timer_check", notimercheck);
 
 void __init setup_IO_APIC(void)
 {
-	enable_IO_APIC();
+
+	/*
+	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 */
 
 	if (acpi_ioapic)
 		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
diff -puN include/asm-x86_64/hw_irq.h~x86_64-clear-io_apic-before-enabing-apic-error-vector include/asm-x86_64/hw_irq.h
--- a/include/asm-x86_64/hw_irq.h~x86_64-clear-io_apic-before-enabing-apic-error-vector
+++ a/include/asm-x86_64/hw_irq.h
@@ -135,6 +135,7 @@ extern void init_8259A(int aeoi);
 extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
 extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
