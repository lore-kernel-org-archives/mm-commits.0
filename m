From: akpm@linux-foundation.org
Subject: [merged]
 smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:02 -0700
Message-ID: <55ef22d6.UJTBl382x1FyEbyu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: allow passing the cpumask on per-cpu thread registration
has been removed from the -mm tree.  Its filename was
     smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: smpboot: allow passing the cpumask on per-cpu thread registration

It makes the registration cheaper and simpler for the smpboot per-cpu
kthread users that don't need to always update the cpumask after threads
creation.

[sfr@canb.auug.org.au: fix for allow passing the cpumask on per-cpu thread registration]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smpboot.h |   11 ++++++++++-
 kernel/smpboot.c        |   14 +++++++++-----
 kernel/watchdog.c       |    9 +++------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff -puN include/linux/smpboot.h~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration include/linux/smpboot.h
--- a/include/linux/smpboot.h~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration
+++ a/include/linux/smpboot.h
@@ -48,7 +48,16 @@ struct smp_hotplug_thread {
 	const char			*thread_comm;
 };
 
-int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
+int smpboot_register_percpu_thread_cpumask(struct smp_hotplug_thread *plug_thread,
+					   const struct cpumask *cpumask);
+
+static inline int
+smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
+{
+	return smpboot_register_percpu_thread_cpumask(plug_thread,
+						      cpu_possible_mask);
+}
+
 void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
 int smpboot_update_cpumask_percpu_thread(struct smp_hotplug_thread *plug_thread,
 					 const struct cpumask *);
diff -puN kernel/smpboot.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration
+++ a/kernel/smpboot.c
@@ -273,19 +273,22 @@ static void smpboot_destroy_threads(stru
 }
 
 /**
- * smpboot_register_percpu_thread - Register a per_cpu thread related to hotplug
+ * smpboot_register_percpu_thread_cpumask - Register a per_cpu thread related
+ * 					    to hotplug
  * @plug_thread:	Hotplug thread descriptor
+ * @cpumask:		The cpumask where threads run
  *
  * Creates and starts the threads on all online cpus.
  */
-int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
+int smpboot_register_percpu_thread_cpumask(struct smp_hotplug_thread *plug_thread,
+					   const struct cpumask *cpumask)
 {
 	unsigned int cpu;
 	int ret = 0;
 
 	if (!alloc_cpumask_var(&plug_thread->cpumask, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_copy(plug_thread->cpumask, cpu_possible_mask);
+	cpumask_copy(plug_thread->cpumask, cpumask);
 
 	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
@@ -296,7 +299,8 @@ int smpboot_register_percpu_thread(struc
 			free_cpumask_var(plug_thread->cpumask);
 			goto out;
 		}
-		smpboot_unpark_thread(plug_thread, cpu);
+		if (cpumask_test_cpu(cpu, cpumask))
+			smpboot_unpark_thread(plug_thread, cpu);
 	}
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
@@ -304,7 +308,7 @@ out:
 	put_online_cpus();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
+EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread_cpumask);
 
 /**
  * smpboot_unregister_percpu_thread - Unregister a per_cpu thread related to hotplug
diff -puN kernel/watchdog.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration kernel/watchdog.c
--- a/kernel/watchdog.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration
+++ a/kernel/watchdog.c
@@ -713,15 +713,12 @@ static int watchdog_enable_all_cpus(void
 	int err = 0;
 
 	if (!watchdog_running) {
-		err = smpboot_register_percpu_thread(&watchdog_threads);
+		err = smpboot_register_percpu_thread_cpumask(&watchdog_threads,
+							     &watchdog_cpumask);
 		if (err)
 			pr_err("Failed to create watchdog threads, disabled\n");
-		else {
-			if (smpboot_update_cpumask_percpu_thread(
-				    &watchdog_threads, &watchdog_cpumask))
-				pr_err("Failed to set cpumask for watchdog threads\n");
+		else
 			watchdog_running = 1;
-		}
 	} else {
 		/*
 		 * Enable/disable the lockup detectors or
_

Patches currently in -mm which might be from fweisbec@gmail.com are

kmod-bunch-of-internal-functions-renames.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-use-system_unbound_wq-instead-of-khelper.patch
kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

