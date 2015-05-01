From: akpm@linux-foundation.org
Subject: + smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch added to -mm tree
Date: Fri, 01 May 2015 15:01:23 -0700
Message-ID: <5543f7b3.1pkyp4QOcNfBnhRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbEAWBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 18:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, fweisbec@gmail.com, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: dynamically allocate the cpumask
has been added to the -mm tree.  Its filename is
     smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch

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
Subject: smpboot: dynamically allocate the cpumask

Frederic Weisbecker observed that we'd be better off to dynamically
allocate the cpumask associated with smpboot threads to save memory.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smpboot.h |    2 +-
 kernel/smpboot.c        |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/smpboot.h~smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix include/linux/smpboot.h
--- a/include/linux/smpboot.h~smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix
+++ a/include/linux/smpboot.h
@@ -43,7 +43,7 @@ struct smp_hotplug_thread {
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
 	void				(*pre_unpark)(unsigned int cpu);
-	struct cpumask			cpumask;
+	cpumask_var_t			cpumask;
 	bool				selfparking;
 	const char			*thread_comm;
 };
diff -puN kernel/smpboot.c~smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix
+++ a/kernel/smpboot.c
@@ -232,7 +232,7 @@ void smpboot_unpark_threads(unsigned int
 
 	mutex_lock(&smpboot_threads_lock);
 	list_for_each_entry(cur, &hotplug_threads, list)
-		if (cpumask_test_cpu(cpu, &cur->cpumask))
+		if (cpumask_test_cpu(cpu, cur->cpumask))
 			smpboot_unpark_thread(cur, cpu);
 	mutex_unlock(&smpboot_threads_lock);
 }
@@ -260,7 +260,7 @@ static void smpboot_destroy_threads(stru
 	unsigned int cpu;
 
 	/* Unpark any threads that were voluntarily parked. */
-	for_each_cpu_not(cpu, &ht->cpumask) {
+	for_each_cpu_not(cpu, ht->cpumask) {
 		if (cpu_online(cpu)) {
 			struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 			if (tsk)
@@ -291,7 +291,10 @@ int smpboot_register_percpu_thread(struc
 	unsigned int cpu;
 	int ret = 0;
 
-	cpumask_copy(&plug_thread->cpumask, cpu_possible_mask);
+	if (!alloc_cpumask_var(&plug_thread->cpumask, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_copy(plug_thread->cpumask, cpu_possible_mask);
+
 	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
@@ -324,6 +327,7 @@ void smpboot_unregister_percpu_thread(st
 	smpboot_destroy_threads(plug_thread);
 	mutex_unlock(&smpboot_threads_lock);
 	put_online_cpus();
+	free_cpumask_var(plug_thread->cpumask);
 }
 EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
 
@@ -338,7 +342,7 @@ EXPORT_SYMBOL_GPL(smpboot_unregister_per
 int smpboot_update_cpumask_percpu_thread(struct smp_hotplug_thread *plug_thread,
 					 const struct cpumask *new)
 {
-	struct cpumask *old = &plug_thread->cpumask;
+	struct cpumask *old = plug_thread->cpumask;
 	cpumask_var_t tmp;
 	unsigned int cpu;
 
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
linux-next.patch

