From: akpm@linux-foundation.org
Subject: - kexec-update-io-apic-dest-field-to-8-bit-for.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:53:09 -0800
Message-ID: <200702082153.l18Lr9cP027687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471AbXBHVxX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benjamin.romer@unisys.com, ak@suse.de, ebiederm@xmission.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kexec: update IO-APIC dest field to 8-bit for xAPIC
has been removed from the -mm tree.  Its filename was
     kexec-update-io-apic-dest-field-to-8-bit-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kexec: update IO-APIC dest field to 8-bit for xAPIC
From: Benjamin Romer <benjamin.romer@unisys.com>

On the Unisys ES7000/ONE system, we encountered a problem where performing
a kexec reboot or dump on any cell other than cell 0 causes the system
timer to stop working, resulting in a hang during timer calibration in the
new kernel.

We traced the problem to one line of code in disable_IO_APIC(), which needs
to restore the timer's IO-APIC configuration before rebooting.  The code is
currently using the 4-bit physical destination field, rather than using the
8-bit logical destination field, and it cuts off the upper 4 bits of the
timer's APIC ID.  If we change this to use the logical destination field,
the timer works and we can kexec on the upper cells.  This was tested on
two different cells (0 and 2) in an ES7000/ONE system.

For reference, the relevant Intel xAPIC spec is kept at
ftp://download.intel.com/design/chipsets/e8501/datashts/30962001.pdf,
specifically on page 334.

Signed-off-by: Benjamin M Romer <benjamin.romer@unisys.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   24 +++++++++++-------------
 include/asm-x86_64/io_apic.h |   14 ++------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~kexec-update-io-apic-dest-field-to-8-bit-for arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~kexec-update-io-apic-dest-field-to-8-bit-for
+++ a/arch/x86_64/kernel/io_apic.c
@@ -836,7 +836,7 @@ static void __init setup_IO_APIC_irq(int
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;				/* enable IRQ */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 
 	entry.trigger = irq_trigger(idx);
 	entry.polarity = irq_polarity(idx);
@@ -844,7 +844,7 @@ static void __init setup_IO_APIC_irq(int
 	if (irq_trigger(idx)) {
 		entry.trigger = 1;
 		entry.mask = 1;
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+		entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	}
 
 	if (!apic && !IO_APIC_IRQ(irq))
@@ -856,7 +856,7 @@ static void __init setup_IO_APIC_irq(int
 		if (vector < 0)
 			return;
 
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+		entry.dest = cpu_mask_to_apicid(mask);
 		entry.vector = vector;
 
 		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
@@ -925,7 +925,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;					/* unmask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1025,18 +1025,17 @@ void __apicdebuginit print_IO_APIC(void)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	printk(KERN_DEBUG " NR Log Phy Mask Trig IRR Pol"
-			  " Stat Dest Deli Vect:   \n");
+	printk(KERN_DEBUG " NR Dst Mask Trig IRR Pol"
+			  " Stat Dmod Deli Vect:   \n");
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
 		struct IO_APIC_route_entry entry;
 
 		entry = ioapic_read_entry(apic, i);
 
-		printk(KERN_DEBUG " %02x %03X %02X  ",
+		printk(KERN_DEBUG " %02x %03X ",
 			i,
-			entry.dest.logical.logical_dest,
-			entry.dest.physical.physical_dest
+			entry.dest
 		);
 
 		printk("%1d    %1d    %1d   %1d   %1d    %1d    %1d    %02X\n",
@@ -1298,8 +1297,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-               entry.dest.logical.logical_dest =
-					GET_APIC_ID(apic_read(APIC_ID));
+		entry.dest          = GET_APIC_ID(apic_read(APIC_ID));
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1599,7 +1597,7 @@ static inline void unlock_ExtINT_logic(v
 
 	entry1.dest_mode = 0;			/* physical delivery */
 	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
+	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = 0;
@@ -2171,7 +2169,7 @@ int io_apic_set_pci_routing (int ioapic,
 
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+	entry.dest = cpu_mask_to_apicid(mask);
 	entry.trigger = triggering;
 	entry.polarity = polarity;
 	entry.mask = 1;					 /* Disabled (masked) */
diff -puN include/asm-x86_64/io_apic.h~kexec-update-io-apic-dest-field-to-8-bit-for include/asm-x86_64/io_apic.h
--- a/include/asm-x86_64/io_apic.h~kexec-update-io-apic-dest-field-to-8-bit-for
+++ a/include/asm-x86_64/io_apic.h
@@ -85,18 +85,8 @@ struct IO_APIC_route_entry {
 		mask		:  1,	/* 0: enabled, 1: disabled */
 		__reserved_2	: 15;
 
-	union {		struct { __u32
-					__reserved_1	: 24,
-					physical_dest	:  4,
-					__reserved_2	:  4;
-			} physical;
-
-			struct { __u32
-					__reserved_1	: 24,
-					logical_dest	:  8;
-			} logical;
-	} dest;
-
+	__u32	__reserved_3	: 24,
+		dest		:  8;
 } __attribute__ ((packed));
 
 /*
_

Patches currently in -mm which might be from benjamin.romer@unisys.com are
