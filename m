From: akpm@linux-foundation.org
Subject: [merged] panic-fix-a-possible-deadlock-in-panic.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:02 -0700
Message-ID: <20120731184902.B6ACB100080@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2GaStD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:03 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markivx@codeaurora.org, holzheu@linux.vnet.ibm.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: fix a possible deadlock in panic()
has been removed from the -mm tree.  Its filename was
     panic-fix-a-possible-deadlock-in-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from markivx@codeaurora.org are

origin.patch

