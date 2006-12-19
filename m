From: akpm@osdl.org
Subject: + i386-more-ioapic-checks.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:28:06 -0800
Message-ID: <200612190028.kBJ0S6Ed017744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbWLSA2g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 76306.1226@compuserve.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     i386: more ioapic checks
has been added to the -mm tree.  Its filename is
     i386-more-ioapic-checks.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: more ioapic checks
From: Chuck Ebbert <76306.1226@compuserve.com>

Coverity reports apic numbers are being passed to functions without
checking to see if they are legal.

(This is Kernel Bugzilla #6188.)

Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~i386-more-ioapic-checks arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-more-ioapic-checks
+++ a/arch/i386/kernel/io_apic.c
@@ -2265,13 +2265,17 @@ static inline void __init check_timer(vo
 				clear_IO_APIC_pin(0, pin1);
 			return;
 		}
-		clear_IO_APIC_pin(apic1, pin1);
+		if (apic1 == -1)
+			WARN_ON_ONCE(1);
+		else
+			clear_IO_APIC_pin(apic1, pin1);
+
 		printk(KERN_ERR "..MP-BIOS bug: 8254 timer not connected to "
 				"IO-APIC\n");
 	}
 
 	printk(KERN_INFO "...trying to set up timer (IRQ0) through the 8259A ... ");
-	if (pin2 != -1) {
+	if (pin2 != -1 && apic2 != -1) {
 		printk("\n..... (found pin %d) ...", pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
_

Patches currently in -mm which might be from 76306.1226@compuserve.com are

i386-more-ioapic-checks.patch

