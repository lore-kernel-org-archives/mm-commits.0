From: akpm@linux-foundation.org
Subject: + stop_machine-build-unconditionally-if-smp.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:04 -0700
Message-ID: <201108161638.p7GGcCwx003000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552Ab1HPQji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin@rab.in, tj@kernel.org


The patch titled
     stop_machine: build unconditionally if SMP
has been added to the -mm tree.  Its filename is
     stop_machine-build-unconditionally-if-smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine: build unconditionally if SMP
From: Rabin Vincent <rabin@rab.in>

stop_machine() is built for "(SMP && MODULE_UNLOAD) || HOTPLUG_CPU", but
is also used by the timekeeping code, the mm code, ftrace, and couple of
things in arch/*.  Just build it if we're using SMP, like it's already
the case on x86.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig             |    1 -
 include/linux/stop_machine.h |    6 +++---
 init/Kconfig                 |    7 -------
 kernel/stop_machine.c        |    4 ----
 4 files changed, 3 insertions(+), 15 deletions(-)

diff -puN arch/x86/Kconfig~stop_machine-build-unconditionally-if-smp arch/x86/Kconfig
--- a/arch/x86/Kconfig~stop_machine-build-unconditionally-if-smp
+++ a/arch/x86/Kconfig
@@ -2146,7 +2146,6 @@ config HAVE_ATOMIC_IOMAP
 
 config HAVE_TEXT_POKE_SMP
 	bool
-	select STOP_MACHINE if SMP
 
 source "net/Kconfig"
 
diff -puN include/linux/stop_machine.h~stop_machine-build-unconditionally-if-smp include/linux/stop_machine.h
--- a/include/linux/stop_machine.h~stop_machine-build-unconditionally-if-smp
+++ a/include/linux/stop_machine.h
@@ -97,7 +97,7 @@ static inline int try_stop_cpus(const st
  * grabbing every spinlock (and more).  So the "read" side to such a
  * lock is anything which disables preemption.
  */
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 
 /**
  * stop_machine: freeze the machine on all CPUs and run this function
@@ -128,7 +128,7 @@ int __stop_machine(int (*fn)(void *), vo
 int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 				   const struct cpumask *cpus);
 
-#else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#else	 /* CONFIG_SMP */
 
 static inline int __stop_machine(int (*fn)(void *), void *data,
 				 const struct cpumask *cpus)
@@ -153,5 +153,5 @@ static inline int stop_machine_from_inac
 	return __stop_machine(fn, data, cpus);
 }
 
-#endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#endif	/* CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff -puN init/Kconfig~stop_machine-build-unconditionally-if-smp init/Kconfig
--- a/init/Kconfig~stop_machine-build-unconditionally-if-smp
+++ a/init/Kconfig
@@ -1382,13 +1382,6 @@ config INIT_ALL_POSSIBLE
 	  it was better to provide this option than to break all the archs
 	  and have several arch maintainers pursuing me down dark alleys.
 
-config STOP_MACHINE
-	bool
-	default y
-	depends on (SMP && MODULE_UNLOAD) || HOTPLUG_CPU
-	help
-	  Need stop_machine() primitive.
-
 source "block/Kconfig"
 
 config PREEMPT_NOTIFIERS
diff -puN kernel/stop_machine.c~stop_machine-build-unconditionally-if-smp kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-build-unconditionally-if-smp
+++ a/kernel/stop_machine.c
@@ -390,8 +390,6 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);
 
-#ifdef CONFIG_STOP_MACHINE
-
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
 	/* Dummy starting state for thread. */
@@ -554,5 +552,3 @@ int stop_machine_from_inactive_cpu(int (
 	mutex_unlock(&stop_cpus_mutex);
 	return ret ?: done.ret;
 }
