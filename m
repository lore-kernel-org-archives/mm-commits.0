From: akpm@linux-foundation.org
Subject: - tick-schedc-build-fix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:51:23 -0800
Message-ID: <200702282351.l1SNpNYV030919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbXB1Xvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     tick-sched.c build fix
has been removed from the -mm tree.  Its filename was
     tick-schedc-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

bug-in-mm_rb-debugging.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
git-net.patch
resend-iphase-64bit-cleanup.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
