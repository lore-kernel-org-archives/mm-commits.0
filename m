From: akpm@linux-foundation.org
Subject: + kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:27:24 -0800
Message-ID: <200702052127.l15LRO5v031611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933476AbXBEV27 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     kernel/time/clocksource.c needs struct task_struct on m68k
has been added to the -mm tree.  Its filename is
     kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
