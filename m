From: akpm@linux-foundation.org
Subject: + add-irqf_irqpoll-flag-on-parisc.patch added to -mm tree
Date: Tue, 27 Mar 2007 14:02:22 -0700
Message-ID: <200703272102.l2RL2M1W027690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934222AbXC0VDH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 17:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, grundler@google.com, kyle@mcmartin.ca, willy@debian.org


The patch titled
     Add IRQF_IRQPOLL flag on parisc
has been added to the -mm tree.  Its filename is
     add-irqf_irqpoll-flag-on-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on parisc
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL to the timer interrupt on parisc.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/irq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/irq.c~add-irqf_irqpoll-flag-on-parisc arch/parisc/kernel/irq.c
--- a/arch/parisc/kernel/irq.c~add-irqf_irqpoll-flag-on-parisc
+++ a/arch/parisc/kernel/irq.c
@@ -388,7 +388,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP
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
