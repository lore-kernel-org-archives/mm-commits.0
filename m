From: akpm@osdl.org
Subject: + i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch added to -mm tree
Date: Fri, 08 Dec 2006 19:48:19 -0800
Message-ID: <200612090348.kB93mJcD015467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbWLIDsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 22:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, ak@suse.de


The patch titled
     i386/io_apic: Fix a typo in an IRQ handler name
has been added to the -mm tree.  Its filename is
     i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386/io_apic: Fix a typo in an IRQ handler name
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The "fasteoi" IRQ handler is named "fasteio" incorrectly.  This is a fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/io_apic.c~i386-io_apic-fix-a-typo-in-an-irq-handler-name arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-io_apic-fix-a-typo-in-an-irq-handler-name
+++ a/arch/i386/kernel/io_apic.c
@@ -2304,7 +2304,7 @@ static inline void __init check_timer(vo
 
 	disable_8259A_irq(0);
 	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
-				      "fasteio");
+				      "fasteoi");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch

