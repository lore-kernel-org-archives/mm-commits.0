From: akpm@linux-foundation.org
Subject: + upc-use-local_irq_saverestore-in-smp_call_function_single.patch added to -mm tree
Date: Mon, 05 Aug 2013 15:47:28 -0700
Message-ID: <52002b80.34Wb2oWoPJxee4A8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3HEWr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david.daney@cavium.com

Subject: + upc-use-local_irq_saverestore-in-smp_call_function_single.patch added to -mm tree
To: david.daney@cavium.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:47:28 -0700


The patch titled
     Subject: up.c: use local_irq_{save,restore}() in smp_call_function_single.
has been added to the -mm tree.  Its filename is
     upc-use-local_irq_saverestore-in-smp_call_function_single.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/upc-use-local_irq_saverestore-in-smp_call_function_single.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/upc-use-local_irq_saverestore-in-smp_call_function_single.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: up.c: use local_irq_{save,restore}() in smp_call_function_single.

The SMP version of this function doesn't unconditionally enable irqs, so
neither should this !SMP version.  There are no know problems caused by
this, but we make the change for consistency's sake.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/up.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/up.c~upc-use-local_irq_saverestore-in-smp_call_function_single kernel/up.c
--- a/kernel/up.c~upc-use-local_irq_saverestore-in-smp_call_function_single
+++ a/kernel/up.c
@@ -10,11 +10,13 @@
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 				int wait)
 {
+	unsigned long flags;
+
 	WARN_ON(cpu != 0);
 
-	local_irq_disable();
-	(func)(info);
-	local_irq_enable();
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from david.daney@cavium.com are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
smp-quit-unconditionally-enabling-irq-in-on_each_cpu_mask-and-on_each_cpu_cond.patch
upc-use-local_irq_saverestore-in-smp_call_function_single.patch
smph-move-smp-version-of-on_each_cpu-out-of-line.patch
linux-next.patch

