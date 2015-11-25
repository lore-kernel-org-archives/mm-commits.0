From: akpm@linux-foundation.org
Subject: + kernel-remove-stop_machine-kconfig-dependency.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 16:07:11 -0800
Message-ID: <5654fbaf.a96dLYdw6ZtYucJw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbbKYAHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 19:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, bobby.prani@gmail.com, cebbert.lkml@gmail.com, hannes@cmpxchg.org, hpa@linux.intel.com, iulia.manda21@gmail.com, luto@amacapital.net, mhocko@suse.cz, mingo@kernel.org, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rusty@rustcorp.com.au, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: remove stop_machine() Kconfig dependency
has been added to the -mm tree.  Its filename is
     kernel-remove-stop_machine-kconfig-dependency.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-remove-stop_machine-kconfig-dependency.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-remove-stop_machine-kconfig-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: kernel: remove stop_machine() Kconfig dependency

Currently the full stop_machine() routine is only enabled on SMP if module
unloading is enabled, or if the CPUs are hotpluggable.  This leads to
configurations where stop_machine() is broken as it will then only run the
callback on the local CPU with irqs disabled, and not stop the other CPUs
or run the callback on them.

For example, this breaks MTRR setup on x86 in certain configs since
ea8596bb2d8d379 ("kprobes/x86: Remove unused text_poke_smp() and
text_poke_smp_batch() functions") as the MTRR is only established on the
boot CPU.

This patch removes the Kconfig option for STOP_MACHINE and uses the SMP
and HOTPLUG_CPU config options to compile the correct stop_machine() for
the architecture, removing the false dependency on MODULE_UNLOAD in the
process.

Link: https://lkml.org/lkml/2014/10/8/124
References: https://bugs.freedesktop.org/show_bug.cgi?id=84794
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Iulia Manda <iulia.manda21@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stop_machine.h |    6 +++---
 init/Kconfig                 |    7 -------
 kernel/stop_machine.c        |    4 ++--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff -puN include/linux/stop_machine.h~kernel-remove-stop_machine-kconfig-dependency include/linux/stop_machine.h
--- a/include/linux/stop_machine.h~kernel-remove-stop_machine-kconfig-dependency
+++ a/include/linux/stop_machine.h
@@ -99,7 +99,7 @@ static inline int try_stop_cpus(const st
  * grabbing every spinlock (and more).  So the "read" side to such a
  * lock is anything which disables preemption.
  */
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+#if defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
 
 /**
  * stop_machine: freeze the machine on all CPUs and run this function
@@ -118,7 +118,7 @@ int stop_machine(cpu_stop_fn_t fn, void
 
 int stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
 				   const struct cpumask *cpus);
-#else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#else	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
 
 static inline int stop_machine(cpu_stop_fn_t fn, void *data,
 				 const struct cpumask *cpus)
@@ -137,5 +137,5 @@ static inline int stop_machine_from_inac
 	return stop_machine(fn, data, cpus);
 }
 
-#endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#endif	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
 #endif	/* _LINUX_STOP_MACHINE */
diff -puN init/Kconfig~kernel-remove-stop_machine-kconfig-dependency init/Kconfig
--- a/init/Kconfig~kernel-remove-stop_machine-kconfig-dependency
+++ a/init/Kconfig
@@ -2030,13 +2030,6 @@ config INIT_ALL_POSSIBLE
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
diff -puN kernel/stop_machine.c~kernel-remove-stop_machine-kconfig-dependency kernel/stop_machine.c
--- a/kernel/stop_machine.c~kernel-remove-stop_machine-kconfig-dependency
+++ a/kernel/stop_machine.c
@@ -531,7 +531,7 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);
 
-#ifdef CONFIG_STOP_MACHINE
+#if defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
 
 static int __stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 {
@@ -631,4 +631,4 @@ int stop_machine_from_inactive_cpu(cpu_s
 	return ret ?: done.ret;
 }
 
-#endif	/* CONFIG_STOP_MACHINE */
+#endif	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are

kernel-remove-stop_machine-kconfig-dependency.patch

