From: akpm@linux-foundation.org
Subject: - stop_machine-now-uses-hard_irq_disable.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:55 -0700
Message-ID: <200705120533.l4C5XtnL002150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157AbXELFeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     stop_machine() now uses hard_irq_disable
has been removed from the -mm tree.  Its filename was
     stop_machine-now-uses-hard_irq_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: stop_machine() now uses hard_irq_disable
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Add a call to hard_irq_disable() to stop_machine so that we make sure IRQs are
really disabled and not only lazy-disabled on archs like powerpc as some users
of stop_machine() may rely on that.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable
+++ a/kernel/stop_machine.c
@@ -8,6 +8,8 @@
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
+#include <linux/interrupt.h>
+
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
@@ -45,6 +47,7 @@ static int stopmachine(void *cpu)
 		if (stopmachine_state == STOPMACHINE_DISABLE_IRQ 
 		    && !irqs_disabled) {
 			local_irq_disable();
+			hard_irq_disable();
 			irqs_disabled = 1;
 			/* Ack: irqs disabled. */
 			smp_mb(); /* Must read state first. */
@@ -124,6 +127,7 @@ static int stop_machine(void)
 
 	/* Make them disable irqs. */
 	local_irq_disable();
+	hard_irq_disable();
 	stopmachine_set_state(STOPMACHINE_DISABLE_IRQ);
 
 	return 0;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
