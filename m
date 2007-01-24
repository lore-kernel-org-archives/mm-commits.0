From: akpm@osdl.org
Subject: + kexec-update-io-apic-dest-field-to-8-bit-for.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:37:39 -0800
Message-ID: <200701240837.l0O8bdhl012864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965224AbXAXIhv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benjamin.romer@unisys.com, ak@suse.de, ebiederm@xmission.com, vgoyal@in.ibm.com


The patch titled
     kexec: update IO-APIC dest field to 8-bit for xAPIC
has been added to the -mm tree.  Its filename is
     kexec-update-io-apic-dest-field-to-8-bit-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |   24 +++++++++++-------------
 include/asm-x86_64/io_apic.h |   14 ++------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~kexec-update-io-apic-dest-field-to-8-bit-for arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~kexec-update-io-apic-dest-field-to-8-bit-for
+++ a/arch/x86_64/kernel/io_apic.c
@@ -831,7 +831,7 @@ static void __init setup_IO_APIC_irq(int
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;				/* enable IRQ */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 
 	entry.trigger = irq_trigger(idx);
 	entry.polarity = irq_polarity(idx);
@@ -839,7 +839,7 @@ static void __init setup_IO_APIC_irq(int
 	if (irq_trigger(idx)) {
 		entry.trigger = 1;
 		entry.mask = 1;
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+		entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	}
 
 	if (!apic && !IO_APIC_IRQ(irq))
@@ -851,7 +851,7 @@ static void __init setup_IO_APIC_irq(int
 		if (vector < 0)
 			return;
 
-		entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+		entry.dest = cpu_mask_to_apicid(mask);
 		entry.vector = vector;
 
 		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
@@ -920,7 +920,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 0;					/* unmask IRQ now */
-	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1020,18 +1020,17 @@ void __apicdebuginit print_IO_APIC(void)
 
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
@@ -1293,8 +1292,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-               entry.dest.logical.logical_dest =
-					GET_APIC_ID(apic_read(APIC_ID));
+		entry.dest          = GET_APIC_ID(apic_read(APIC_ID));
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1556,7 +1554,7 @@ static inline void unlock_ExtINT_logic(v
 
 	entry1.dest_mode = 0;			/* physical delivery */
 	entry1.mask = 0;			/* unmask IRQ now */
-	entry1.dest.physical.physical_dest = hard_smp_processor_id();
+	entry1.dest = hard_smp_processor_id();
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = 0;
@@ -2121,7 +2119,7 @@ int io_apic_set_pci_routing (int ioapic,
 
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

kexec-update-io-apic-dest-field-to-8-bit-for.patch
