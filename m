From: akpm@linux-foundation.org
Subject: + tick-schedc-build-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:32:29 -0800
Message-ID: <200702272032.l1RKWWEt027446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbXB0Uci (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, tglx@linutronix.de


The patch titled
     tick-sched.c build fix
has been added to the -mm tree.  Its filename is
     tick-schedc-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tick-sched.c build fix
From: David Miller <davem@davemloft.net>

While getting dynticks/hrtimers up on sparc64 I ran into the following
build problem.  If you use get_irq_regs() you need to include
asm/irq_regs.h

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/time/tick-sched.c~tick-schedc-build-fix kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-schedc-build-fix
+++ a/kernel/time/tick-sched.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/tick.h>
 
+#include <asm/irq_regs.h>
+
 #include "tick-internal.h"
 
 /*
_

Patches currently in -mm which might be from davem@davemloft.net are

tick-schedc-build-fix.patch
generic-one-shot-bug.patch
git-net.patch
resend-iphase-64bit-cleanup.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
