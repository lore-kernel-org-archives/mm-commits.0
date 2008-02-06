From: akpm@linux-foundation.org
Subject: + mips-mark-all-but-i8259-interrupts-as-no-probe.patch added to -mm tree
Date: Wed, 06 Feb 2008 09:59:31 -0800
Message-ID: <200802061759.m16HxCrh023156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYBFSAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 13:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, rob@landley.net


The patch titled
     MIPS: Mark all but i8259 interrupts as no-probe.
has been added to the -mm tree.  Its filename is
     mips-mark-all-but-i8259-interrupts-as-no-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MIPS: Mark all but i8259 interrupts as no-probe.
From: Ralf Baechle <ralf@linux-mips.org>

Use set_irq_noprobe() to mark all MIPS interrupts as non-probe.  Override that
default for i8259 interrupts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-and-tested-by: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/i8259.c |    4 +++-
 arch/mips/kernel/irq.c   |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/mips/kernel/i8259.c~mips-mark-all-but-i8259-interrupts-as-no-probe arch/mips/kernel/i8259.c
--- a/arch/mips/kernel/i8259.c~mips-mark-all-but-i8259-interrupts-as-no-probe
+++ a/arch/mips/kernel/i8259.c
@@ -338,8 +338,10 @@ void __init init_i8259_irqs(void)
 
 	init_8259A(0);
 
-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++)
+	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
 		set_irq_chip_and_handler(i, &i8259A_chip, handle_level_irq);
+		set_irq_probe(i);
+	}
 
 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
diff -puN arch/mips/kernel/irq.c~mips-mark-all-but-i8259-interrupts-as-no-probe arch/mips/kernel/irq.c
--- a/arch/mips/kernel/irq.c~mips-mark-all-but-i8259-interrupts-as-no-probe
+++ a/arch/mips/kernel/irq.c
@@ -145,6 +145,11 @@ __setup("nokgdb", nokgdb);
 
 void __init init_IRQ(void)
 {
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		set_irq_noprobe(i);
+
 	arch_init_irq();
 
 #ifdef CONFIG_KGDB
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
remove-inclusions-of-linux-autoconfh.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
calibrate_delay-must-be-__cpuinit.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-watchdog.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
avoid-overflows-in-kernel-timec.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
