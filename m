From: akpm@linux-foundation.org
Subject: [obsolete]
 kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:58:11 -0700
Message-ID: <534470f3.84HkojKBj3tjYNC/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHV6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, gilad@benyossef.com, fweisbec@gmail.com, bitbucket@online.de, cl@linux.com

Subject: [obsolete] kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch removed from -mm tree
To: cl@linux.com,bitbucket@online.de,fweisbec@gmail.com,gilad@benyossef.com,paulmck@linux.vnet.ibm.com,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,vapier@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:58:11 -0700


The patch titled
     Subject: kmod: run usermodehelpers only on cpus allowed for kthreadd V2
has been removed from the -mm tree.  Its filename was
     kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: kmod: run usermodehelpers only on cpus allowed for kthreadd V2

usermodehelper() threads can currently run on all processors.  This is an
issue for low latency cores.  Spawnig a new thread causes cpu holdoffs in
the range of hundreds of microseconds to a few milliseconds.  Not good for
cores on which processes run that need to react as fast as possible.

kthreadd threads can be restricted using taskset to a limited set of
processors.  Then the kernel thread pool will not fork processes on those
anymore thereby protecting those processors from additional latencies.

Make usermodehelper() threads obey the limitations that kthreadd is
restricted to.  Kthreadd is not the parent of usermodehelper threads so we
need to explicitly get the allowed processors for kthreadd.

Before this patch there is no way to limit the cpus that usermodehelper
can run on since the affinity is set when the thread is spawned to all
processors.

[akpm@linux-foundation.org: set_cpus_allowed() doesn't exist when CONFIG_CPUMASK_OFFSTACK=y]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    1 +
 kernel/kmod.c           |   11 +++++++++--
 kernel/kthread.c        |    9 +++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN include/linux/kthread.h~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 include/linux/kthread.h
--- a/include/linux/kthread.h~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/include/linux/kthread.h
@@ -51,6 +51,7 @@ void kthread_parkme(void);
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
 extern int tsk_fork_get_node(struct task_struct *tsk);
+void set_kthreadd_affinity(void);
 
 /*
  * Simple work processor based on kthread.
diff -puN kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 kernel/kmod.c
--- a/kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/kernel/kmod.c
@@ -40,6 +40,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <linux/kthread.h>
 
 #include <trace/events/module.h>
 
@@ -209,8 +210,14 @@ static int ____call_usermodehelper(void
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/*
+	 * Kthreadd can be restricted to a set of processors if the user wants
+	 * to protect other processors from OS latencies. If that has happened
+	 * then we do not want to disturb the other processors here either so we
+	 * start the usermode helper threads only on the processors allowed for
+	 * kthreadd.
+	 */
+	set_kthreadd_affinity();
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff -puN kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 kernel/kthread.c
--- a/kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/kernel/kthread.c
@@ -136,6 +136,15 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }
 
+/*
+ * Set the affinity of the calling task to be the same
+ * as the kthreadd affinities.
+ */
+void set_kthreadd_affinity(void)
+{
+	set_cpus_allowed_ptr(current, &kthreadd_task->cpus_allowed);
+}
+
 /**
  * probe_kthread_data - speculative version of kthread_data()
  * @task: possible kthread task in question
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

