From: akpm@linux-foundation.org
Subject: - x86-make-io-apic-not-connected-pin-print-complete.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:41 -0700
Message-ID: <200710180707.l9I77fbS031721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759475AbXJRHIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86: make io-apic not connected pin print complete
has been removed from the -mm tree.  Its filename was
     x86-make-io-apic-not-connected-pin-print-complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
--- a/arch/x86/kernel/io_apic_32.c~x86-make-io-apic-not-connected-pin-print-complete
+++ a/arch/x86/kernel/io_apic_32.c
@@ -1293,6 +1293,11 @@ static void __init setup_IO_APIC_irqs(vo
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
--- a/arch/x86/kernel/io_apic_64.c~x86-make-io-apic-not-connected-pin-print-complete
+++ a/arch/x86/kernel/io_apic_64.c
@@ -875,6 +875,10 @@ static void __init setup_IO_APIC_irqs(vo
 				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mpc_apicid, pin);
 			continue;
 		}
+		if (!first_notcon) {
+			apic_printk(APIC_VERBOSE, " not connected.\n");
+			first_notcon = 1;
+		}
 
 		irq = pin_2_irq(idx, apic, pin);
 		add_pin_to_irq(irq, apic, pin);
@@ -885,7 +889,7 @@ static void __init setup_IO_APIC_irqs(vo
 	}
 
 	if (!first_notcon)
-		apic_printk(APIC_VERBOSE," not connected.\n");
+		apic_printk(APIC_VERBOSE, " not connected.\n");
 }
 
 /*
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
kernel-printkc-concerns-about-the-console-handover.patch
