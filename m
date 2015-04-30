From: akpm@linux-foundation.org
Subject: + smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
 added to -mm tree
Date: Thu, 30 Apr 2015 14:19:17 -0700
Message-ID: <55429c55.bNk4yeej+gL8KhpK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbD3VTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Apr 2015 17:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: allow excluding cpus from the smpboot threads
has been added to the -mm tree.  Its filename is
     smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: smpboot: allow excluding cpus from the smpboot threads

This patch series allows the watchdog to run by default only on the
housekeeping cores when nohz_full is in effect; this seems to be a good
compromise short of turning it off completely (since the nohz_full cores
can't tolerate a watchdog).

To provide customizability, we add /proc/sys/kernel/watchdog_cpumask so
that the set of cores running the watchdog can be tuned to different
values after bootup.

To implement this customizability, we add a new
smpboot_update_cpumask_percpu_thread() API to the smpboot_thread subsystem
that lets us park or unpark "unwanted" threads.

And now that threads can be parked for long periods of time, we tweak the
/proc/<pid>/stat and /proc/<pid>/status code so parked threads aren't
reported as running, which is otherwise confusing.



This patch (of 3):

This change allows some cores to be excluded from running the
smp_hotplug_thread tasks.  The following commit to update
kernel/watchdog.c to use this functionality is the motivating example, and
more information on the motivation is provided there.

A new smp_hotplug_thread field is introduced, "cpumask", which is cpumask
field managed by the smpboot subsystem that indicates whether or not the
given smp_hotplug_thread should run on that core; the cpumask is checked
when deciding whether to unpark the thread.

To limit the cpumask to less than cpu_possible, you must call
smpboot_update_cpumask_percpu_thread() after registering.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smpboot.h |    5 +++
 kernel/smpboot.c        |   55 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff -puN include/linux/smpboot.h~smpboot-allow-excluding-cpus-from-the-smpboot-threads include/linux/smpboot.h
--- a/include/linux/smpboot.h~smpboot-allow-excluding-cpus-from-the-smpboot-threads
+++ a/include/linux/smpboot.h
@@ -27,6 +27,8 @@ struct smpboot_thread_data;
  * @pre_unpark:		Optional unpark function, called before the thread is
  *			unparked (cpu online). This is not guaranteed to be
  *			called on the target cpu of the thread. Careful!
+ * @cpumask:		Internal state.  To update which threads are unparked,
+ *			call smpboot_update_cpumask_percpu_thread().
  * @selfparking:	Thread is not parked by the park function.
  * @thread_comm:	The base name of the thread
  */
@@ -41,11 +43,14 @@ struct smp_hotplug_thread {
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
 	void				(*pre_unpark)(unsigned int cpu);
+	struct cpumask			cpumask;
 	bool				selfparking;
 	const char			*thread_comm;
 };
 
 int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
 void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
+int smpboot_update_cpumask_percpu_thread(struct smp_hotplug_thread *plug_thread,
+					 const struct cpumask *);
 
 #endif
diff -puN kernel/smpboot.c~smpboot-allow-excluding-cpus-from-the-smpboot-threads kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-allow-excluding-cpus-from-the-smpboot-threads
+++ a/kernel/smpboot.c
@@ -232,7 +232,8 @@ void smpboot_unpark_threads(unsigned int
 
 	mutex_lock(&smpboot_threads_lock);
 	list_for_each_entry(cur, &hotplug_threads, list)
-		smpboot_unpark_thread(cur, cpu);
+		if (cpumask_test_cpu(cpu, &cur->cpumask))
+			smpboot_unpark_thread(cur, cpu);
 	mutex_unlock(&smpboot_threads_lock);
 }
 
@@ -258,6 +259,15 @@ static void smpboot_destroy_threads(stru
 {
 	unsigned int cpu;
 
+	/* Unpark any threads that were voluntarily parked. */
+	for_each_cpu_not(cpu, &ht->cpumask) {
+		if (cpu_online(cpu)) {
+			struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+			if (tsk)
+				kthread_unpark(tsk);
+		}
+	}
+
 	/* We need to destroy also the parked threads of offline cpus */
 	for_each_possible_cpu(cpu) {
 		struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
@@ -281,6 +291,7 @@ int smpboot_register_percpu_thread(struc
 	unsigned int cpu;
 	int ret = 0;
 
+	cpumask_copy(&plug_thread->cpumask, cpu_possible_mask);
 	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
@@ -316,6 +327,48 @@ void smpboot_unregister_percpu_thread(st
 }
 EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
 
+/**
+ * smpboot_update_cpumask_percpu_thread - Adjust which per_cpu hotplug threads stay parked
+ * @plug_thread:	Hotplug thread descriptor
+ * @new:		Revised mask to use
+ *
+ * The cpumask field in the smp_hotplug_thread must not be updated directly
+ * by the client, but only by calling this function.
+ */
+int smpboot_update_cpumask_percpu_thread(struct smp_hotplug_thread *plug_thread,
+					 const struct cpumask *new)
+{
+	struct cpumask *old = &plug_thread->cpumask;
+	cpumask_var_t tmp;
+	unsigned int cpu;
+
+	if (!alloc_cpumask_var(&tmp, GFP_KERNEL))
+		return -ENOMEM;
+
+	get_online_cpus();
+	mutex_lock(&smpboot_threads_lock);
+
+	/* Park threads that were exclusively enabled on the old mask. */
+	cpumask_andnot(tmp, old, new);
+	for_each_cpu_and(cpu, tmp, cpu_online_mask)
+		smpboot_park_thread(plug_thread, cpu);
+
+	/* Unpark threads that are exclusively enabled on the new mask. */
+	cpumask_andnot(tmp, new, old);
+	for_each_cpu_and(cpu, tmp, cpu_online_mask)
+		smpboot_unpark_thread(plug_thread, cpu);
+
+	cpumask_copy(old, new);
+
+	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
+
+	free_cpumask_var(tmp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smpboot_update_cpumask_percpu_thread);
+
 static DEFINE_PER_CPU(atomic_t, cpu_hotplug_state) = ATOMIC_INIT(CPU_POST_DEAD);
 
 /*
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
linux-next.patch

