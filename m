From: akpm@linux-foundation.org
Subject: + panic-fix-a-possible-deadlock-in-panic.patch added to -mm tree
Date: Fri, 29 Jun 2012 13:29:39 -0700
Message-ID: <20120629202939.A355EA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61469 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2F2U3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:29:41 -0400
Received: by ggeh3 with SMTP id h3so412055gge.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:29:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markivx@codeaurora.org, holzheu@linux.vnet.ibm.com, sboyd@codeaurora.org


The patch titled
     Subject: panic: fix a possible deadlock in panic()
has been added to the -mm tree.  Its filename is
     panic-fix-a-possible-deadlock-in-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vikram Mulukutla <markivx@codeaurora.org>
Subject: panic: fix a possible deadlock in panic()

panic_lock is meant to ensure that panic processing takes place only on
one cpu; if any of the other cpus encounter a panic, they will spin
waiting to be shut down.

However, this causes a regression in this scenario:

1. Cpu 0 encounters a panic and acquires the panic_lock
   and proceeds with the panic processing.
2. There is an interrupt on cpu 0 that also encounters
   an error condition and invokes panic.
3. This second invocation fails to acquire the panic_lock
   and enters the infinite while loop in panic_smp_self_stop.

Thus all panic processing is stopped, and the cpu is stuck for eternity in
the while(1) inside panic_smp_self_stop.

To address this, disable local interrupts with local_irq_disable before
acquiring the panic_lock.  This will prevent interrupt handlers from
executing during the panic processing, thus avoiding this particular
problem.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/panic.c~panic-fix-a-possible-deadlock-in-panic kernel/panic.c
--- a/kernel/panic.c~panic-fix-a-possible-deadlock-in-panic
+++ a/kernel/panic.c
@@ -75,6 +75,14 @@ void panic(const char *fmt, ...)
 	int state = 0;
 
 	/*
+	 * Disable local interrupts. This will prevent panic_smp_self_stop
+	 * from deadlocking the first cpu that invokes the panic, since
+	 * there is nothing to prevent an interrupt handler (that runs
+	 * after the panic_lock is acquired) from invoking panic again.
+	 */
+	local_irq_disable();
+
+	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
_
Subject: Subject: panic: fix a possible deadlock in panic()

Patches currently in -mm which might be from markivx@codeaurora.org are

panic-fix-a-possible-deadlock-in-panic.patch

