From: akpm@linux-foundation.org
Subject: + x86-make-io-apic-not-connected-pin-print-complete.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:26:18 -0700
Message-ID: <200708152026.l7FKQI7u013432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbXHOU1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, yinghai.lu@Sun.COM


The patch titled
     x86: make io-apic not connected pin print complete
has been added to the -mm tree.  Its filename is
     x86-make-io-apic-not-connected-pin-print-complete.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: make io-apic not connected pin print complete
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Normally we will have two segment not connected pin pin0, and pin after
15...

So we need to print out "not connected\n" for previous segment, before
printing out connected pins info...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c   |    5 +++++
 arch/x86_64/kernel/io_apic.c |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/io_apic.c~x86-make-io-apic-not-connected-pin-print-complete arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~x86-make-io-apic-not-connected-pin-print-complete
+++ a/arch/i386/kernel/io_apic.c
@@ -1304,6 +1304,11 @@ static void __init setup_IO_APIC_irqs(vo
 			continue;
 		}
 
+		if (!first_notcon) {
+			apic_printk(APIC_VERBOSE, " not connected.\n");
+			first_notcon = 1;
+		}
+
 		entry.trigger = irq_trigger(idx);
 		entry.polarity = irq_polarity(idx);
 
diff -puN arch/x86_64/kernel/io_apic.c~x86-make-io-apic-not-connected-pin-print-complete arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86-make-io-apic-not-connected-pin-print-complete
+++ a/arch/x86_64/kernel/io_apic.c
@@ -877,6 +877,10 @@ static void __init setup_IO_APIC_irqs(vo
 				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mpc_apicid, pin);
 			continue;
 		}
+		if (!first_notcon) {
+			apic_printk(APIC_VERBOSE, " not connected.\n");
+			first_notcon = 1;
+		}
 
 		irq = pin_2_irq(idx, apic, pin);
 		add_pin_to_irq(irq, apic, pin);
@@ -887,7 +891,7 @@ static void __init setup_IO_APIC_irqs(vo
 	}
 
 	if (!first_notcon)
-		apic_printk(APIC_VERBOSE," not connected.\n");
+		apic_printk(APIC_VERBOSE, " not connected.\n");
 }
 
 /*
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
