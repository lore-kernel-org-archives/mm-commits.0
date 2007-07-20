From: akpm@linux-foundation.org
Subject: + debug-handling-of-early-spurious-interrupts.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:43:28 -0700
Message-ID: <200707202143.l6KLhSAL018000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937115AbXGTVoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, ebiederm@xmission.com, mingo@elte.hu, vgoyal@in.ibm.com


The patch titled
     Debug handling of early spurious interrupts
has been added to the -mm tree.  Its filename is
     debug-handling-of-early-spurious-interrupts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Debug handling of early spurious interrupts
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

With the advent of kdump it is possible that device drivers receive
interrupts generated in the context of a previous kernel.  Ideally
quiescing the underlying devices should suffice but not all drivers do
this, either because it is not possible or because they did not contemplate
this case.  Thus drivers ought to be able to handle interrupts coming in as
soon as the interrupt handler is registered.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff -puN kernel/irq/manage.c~debug-handling-of-early-spurious-interrupts kernel/irq/manage.c
--- a/kernel/irq/manage.c~debug-handling-of-early-spurious-interrupts
+++ a/kernel/irq/manage.c
@@ -533,21 +533,32 @@ int request_irq(unsigned int irq, irq_ha
 
 	select_smp_affinity(irq);
 
-	if (irqflags & IRQF_SHARED) {
-		/*
-		 * It's a shared IRQ -- the driver ought to be prepared for it
-		 * to happen immediately, so let's make sure....
-		 * We do this before actually registering it, to make sure that
-		 * a 'real' IRQ doesn't run in parallel with our fake
-		 */
-		if (irqflags & IRQF_DISABLED) {
-			unsigned long flags;
+	/*
+	 * With the advent of kdump it possible that device drivers receive
+	 * interrupts generated in the context of a previous kernel. Ideally
+	 * quiescing the underlying devices should suffice but not all drivers
+	 * do this, either because it is not possible or because they did not
+	 * contemplate this case. Thus drivers ought to be able to handle
+	 * interrupts coming in as soon as the interrupt handler is registered.
+	 *
+	 * Besides, if it is a shared IRQ the driver ought to be prepared for
+	 * it to happen immediately too.
+	 *
+	 * We do this before actually registering it, to make sure that
+	 * a 'real' IRQ doesn't run in parallel with our fake.
+	 */
+	if (irqflags & IRQF_DISABLED) {
+		unsigned long flags;
 
-			local_irq_save(flags);
-			handler(irq, dev_id);
-			local_irq_restore(flags);
-		} else
-			handler(irq, dev_id);
+		local_irq_save(flags);
+		retval = handler(irq, dev_id);
+		local_irq_restore(flags);
+	} else
+		retval = handler(irq, dev_id);
+	if (retval == IRQ_HANDLED) {
+		printk(KERN_WARNING
+		       "%s (IRQ %d) handled a spurious interrupt\n",
+		       devname, irq);
 	}
 
 	retval = setup_irq(irq, action);
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
