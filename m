From: akpm@linux-foundation.org
Subject: +
 kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch added
 to -mm tree
Date: Thu, 07 Nov 2013 14:37:24 -0800
Message-ID: <527c1624.9towvmuoeidUK1pL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3KGWhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, gilad@benyossef.com, fweisbec@gmail.com, bitbucket@online.de, cl@linux.com

Subject: + kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch added to -mm tree
To: cl@linux.com,bitbucket@online.de,fweisbec@gmail.com,gilad@benyossef.com,paulmck@linux.vnet.ibm.com,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,vapier@gentoo.org
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:37:24 -0800


The patch titled
     Subject: kmod: run usermodehelpers only on cpus allowed for kthreadd V2
has been added to the -mm tree.  Its filename is
     kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 kernel/kmod.c           |   10 ++++++++--
 kernel/kthread.c        |    9 +++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

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
 
@@ -209,8 +210,13 @@ static int ____call_usermodehelper(void
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/*
+	 * Kthreadd can be restricted to a set of processors if the user wants to
+	 * protect other processors from OS latencies. If that has happened then
+	 * we do not want to disturb the other processors here either so we start
+	 * the usermode helper threads only on the processors allowed for kthreadd.
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
+	set_cpus_allowed(current, kthreadd_task->cpus_allowed);
+}
+
 /**
  * probe_kthread_data - speculative version of kthread_data()
  * @task: possible kthread task in question
_

Patches currently in -mm which might be from cl@linux.com are

mm-set-n_cpu-to-node_states-during-boot.patch
mm-clear-n_cpu-from-node_states-at-cpu-offline.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch

