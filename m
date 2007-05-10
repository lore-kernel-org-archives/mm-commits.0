From: akpm@linux-foundation.org
Subject: + stop_machine-now-uses-hard_irq_disable.patch added to -mm tree
Date: Wed, 09 May 2007 22:43:11 -0700
Message-ID: <200705100543.l4A5hBK5013252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbXEJFnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au


The patch titled
     stop_machine() now uses hard_irq_disable
has been added to the -mm tree.  Its filename is
     stop_machine-now-uses-hard_irq_disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: stop_machine() now uses hard_irq_disable
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Add a call to hard_irq_disable() to stop_machine so that we make sure IRQs are
really disabled and not only lazy-disabled on archs like powerpc as some users
of stop_machine() may rely on that.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable
+++ a/kernel/stop_machine.c
@@ -45,6 +45,7 @@ static int stopmachine(void *cpu)
 		if (stopmachine_state == STOPMACHINE_DISABLE_IRQ 
 		    && !irqs_disabled) {
 			local_irq_disable();
+			hard_irq_disable();
 			irqs_disabled = 1;
 			/* Ack: irqs disabled. */
 			smp_mb(); /* Must read state first. */
@@ -124,6 +125,7 @@ static int stop_machine(void)
 
 	/* Make them disable irqs. */
 	local_irq_disable();
+	hard_irq_disable();
 	stopmachine_set_state(STOPMACHINE_DISABLE_IRQ);
 
 	return 0;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
introduce-freezer-flags-rev-2.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-fix.patch
