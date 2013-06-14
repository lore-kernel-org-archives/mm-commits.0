From: akpm@linux-foundation.org
Subject: +
 smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu.patch added to -mm tree
Date: Fri, 14 Jun 2013 15:11:47 -0700
Message-ID: <51bb9523.jMaYLZXYJLJNpnDC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3FNWLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jun 2013 18:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, ralf@linux-mips.org, david.daney@cavium.com

Subject: + smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu.patch added to -mm tree
To: david.daney@cavium.com,ralf@linux-mips.org,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Fri, 14 Jun 2013 15:11:47 -0700


The patch titled
     Subject: smp.h: use local_irq_{save,restore}() in !SMP version of on_each_cpu().
has been added to the -mm tree.  Its filename is
     smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu.patch

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
Subject: smp.h: use local_irq_{save,restore}() in !SMP version of on_each_cpu().

Thanks to commit f91eb62f71b ("init: scream bloody murder if interrupts
are enabled too early"), "bloody murder" is now being screamed.

With a MIPS OCTEON config, we use on_each_cpu() in our
irq_chip.irq_bus_sync_unlock() function.  This gets called in early as a
result of the time_init() call.  Because the !SMP version of on_each_cpu()
unconditionally enables irqs, we get:

WARNING: at init/main.c:560 start_kernel+0x250/0x410()
Interrupts were enabled early
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0-rc5-Cavium-Octeon+ #801
Stack : 0000000000000046 ffffffff808e0000 0000000000000006 0000000000000004
	  0000000000000001 0000000000000000 0000000000000046 0000000000000000
	  ffffffff80a90000 ffffffff8015c020 0000000000000000 ffffffff8015c020
	  ffffffff80a79f70 ffffffff80a80000 ffffffff8072b9c0 ffffffff808a7d77
	  ffffffff80a79f70 ffffffff808a8168 0000000000000000 00000004178a9948
	  0000000417801230 ffffffff805f7610 0000000010000078 ffffffff805fa01c
	  ffffffff8089bd18 ffffffff801595fc ffffffff8089bd28 ffffffff8015d384
	  ffffffff808a7e80 ffffffff8089bc30 0000000000000000 ffffffff80159710
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 ffffffff80139520 0000000000000000 0000000000000009
	  ...
Call Trace:
[<ffffffff80139520>] show_stack+0x68/0x80
[<ffffffff80159710>] warn_slowpath_common+0x78/0xb0
[<ffffffff801597e8>] warn_slowpath_fmt+0x38/0x48
[<ffffffff8092b768>] start_kernel+0x250/0x410

Suggested fix: Do what we already do in the SMP version of on_each_cpu(),
and use local_irq_save/local_irq_restore.  Because we need a flags
variable, make it a static inline to avoid name space issues.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN include/linux/smp.h~smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu include/linux/smp.h
--- a/include/linux/smp.h~smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu
+++ a/include/linux/smp.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -139,13 +140,17 @@ static inline int up_smp_call_function(s
 }
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-#define on_each_cpu(func,info,wait)		\
-	({					\
-		local_irq_disable();		\
-		func(info);			\
-		local_irq_enable();		\
-		0;				\
-	})
+
+static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
smph-use-local_irq_saverestore-in-smp-version-of-on_each_cpu.patch
mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

