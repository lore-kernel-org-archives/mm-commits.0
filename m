From: akpm@linux-foundation.org
Subject: + add-irqf_irqpoll-flag-on-x86_64.patch added to -mm tree
Date: Tue, 27 Mar 2007 14:02:14 -0700
Message-ID: <200703272102.l2RL2EX9027678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42924 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212AbXC0VCi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 17:02:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Add IRQF_IRQPOLL flag on x86_64
has been added to the -mm tree.  Its filename is
     add-irqf_irqpoll-flag-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on x86_64
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL for the timer interrupt on x86_64.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/time.c~add-irqf_irqpoll-flag-on-x86_64 arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~add-irqf_irqpoll-flag-on-x86_64
+++ a/arch/x86_64/kernel/time.c
@@ -317,7 +317,10 @@ void __init stop_timer_interrupt(void)
 }
 
 static struct irqaction irq0 = {
-	timer_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "timer", NULL, NULL
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.mask		= CPU_MASK_NONE,
+	.name 		= "timer"
 };
 
 void __init time_init(void)
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
