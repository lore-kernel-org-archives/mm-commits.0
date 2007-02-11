From: akpm@linux-foundation.org
Subject: - kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:51 -0800
Message-ID: <200702112247.l1BMlprO015579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbXBKWte (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kernel/time/clocksource.c needs struct task_struct on m68k
has been removed from the -mm tree.  Its filename was
     kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/time/clocksource.c needs struct task_struct on m68k
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

kernel/time/clocksource.c needs struct task_struct on m68k.

Because it uses spin_unlock_irq(), which, on m68k, uses hardirq_count(), which
uses preempt_count(), which needs to dereference struct task_struct, we
have to include sched.h. Because it would cause a loop inclusion, we
cannot include sched.h in any other of asm-m68k/system.h,
linux/thread_info.h, linux/hardirq.h, which leaves this ugly include in
a C file as the only simple solution.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/time/clocksource.c~kernel-time-clocksourcec-needs-struct-task_struct-on-m68k kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~kernel-time-clocksourcec-needs-struct-task_struct-on-m68k
+++ a/kernel/time/clocksource.c
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-mips.patch
