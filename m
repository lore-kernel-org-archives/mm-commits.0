From: akpm@linux-foundation.org
Subject: + alpha-werror-fixes-for-sys_titanc.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:49:43 -0700
Message-ID: <200708092149.l79LnhDX021333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbXHIVuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jay.estabrook@hp.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: -Werror fixes for sys_titan.c
has been added to the -mm tree.  Its filename is
     alpha-werror-fixes-for-sys_titanc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: -Werror fixes for sys_titan.c
From: Jay Estabrook <jay.estabrook@hp.com>

Files:

arch/alpha/kernel/sys_titan.c

This code corrects the usage of the request_irq() routine.

Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_titan.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff -puN arch/alpha/kernel/sys_titan.c~alpha-werror-fixes-for-sys_titanc arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c~alpha-werror-fixes-for-sys_titanc
+++ a/arch/alpha/kernel/sys_titan.c
@@ -271,6 +271,19 @@ titan_dispatch_irqs(u64 mask)
  * Titan Family
  */
 static void __init
+titan_request_irq(unsigned int irq, irq_handler_t handler,
+		  unsigned long irqflags, const char *devname,
+		  void *dev_id)
+{
+	int err;
+	err = request_irq(irq, handler, irqflags, devname, dev_id);
+	if (err) {
+		printk("titan_request_irq for IRQ %d returned %d; ignoring\n",
+		       irq, err);
+	}
+}
+
+static void __init
 titan_late_init(void)
 {
 	/*
@@ -278,15 +291,15 @@ titan_late_init(void)
 	 * all reported to the kernel as machine checks, so the handler
 	 * is a nop so it can be called to count the individual events.
 	 */
-	request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
 		    "CChip Error", NULL);
-	request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 0 H_Error", NULL);
-	request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 1 H_Error", NULL);
-	request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 0 C_Error", NULL);
-	request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
 		    "PChip 1 C_Error", NULL);
 
 	/* 
@@ -345,9 +358,9 @@ privateer_init_pci(void)
 	 * Hook a couple of extra err interrupts that the
 	 * common titan code won't.
 	 */
-	request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
 		    "NMI", NULL);
-	request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
 		    "Temperature Warning", NULL);
 
 	/*
_

Patches currently in -mm which might be from jay.estabrook@hp.com are

alpha-werror-fixes-for-sys_titanc.patch
