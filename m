From: akpm@linux-foundation.org
Subject: + kthread-rename-probe_kthread_data-to-kthread_probe_data.patch
 added to -mm tree
Date: Tue, 09 Aug 2016 15:10:54 -0700
Message-ID: <57aa54ee.5+zinOKKKBDRO+OY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbcHIWK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, akpm@linux-foundation.org, bp@suse.de, jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz, mingo@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: rename probe_kthread_data() to kthread_probe_data()
has been added to the -mm tree.  Its filename is
     kthread-rename-probe_kthread_data-to-kthread_probe_data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-rename-probe_kthread_data-to-kthread_probe_data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-rename-probe_kthread_data-to-kthread_probe_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: rename probe_kthread_data() to kthread_probe_data()

Patch series "kthread: Kthread worker API improvements"

The intention of this patchset is to make it easier to manipulate and
maintain kthreads.  Especially, I want to replace all the custom main
cycles with a generic one.  Also I want to make the kthreads sleep in a
consistent state in a common place when there is no work.


This patch (of 11):

A good practice is to prefix the names of functions by the name of the
subsystem.

This patch fixes the name of probe_kthread_data().  The other wrong
functions names are part of the kthread worker API and will be fixed
separately.

Link: http://lkml.kernel.org/r/1470754545-17632-2-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 kernel/kthread.c        |    4 ++--
 kernel/workqueue.c      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kthread.h~kthread-rename-probe_kthread_data-to-kthread_probe_data include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-rename-probe_kthread_data-to-kthread_probe_data
+++ a/include/linux/kthread.h
@@ -44,7 +44,7 @@ bool kthread_should_stop(void);
 bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
-void *probe_kthread_data(struct task_struct *k);
+void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
diff -puN kernel/kthread.c~kthread-rename-probe_kthread_data-to-kthread_probe_data kernel/kthread.c
--- a/kernel/kthread.c~kthread-rename-probe_kthread_data-to-kthread_probe_data
+++ a/kernel/kthread.c
@@ -138,7 +138,7 @@ void *kthread_data(struct task_struct *t
 }
 
 /**
- * probe_kthread_data - speculative version of kthread_data()
+ * kthread_probe_data - speculative version of kthread_data()
  * @task: possible kthread task in question
  *
  * @task could be a kthread task.  Return the data value specified when it
@@ -146,7 +146,7 @@ void *kthread_data(struct task_struct *t
  * inaccessible for any reason, %NULL is returned.  This function requires
  * that @task itself is safe to dereference.
  */
-void *probe_kthread_data(struct task_struct *task)
+void *kthread_probe_data(struct task_struct *task)
 {
 	struct kthread *kthread = to_kthread(task);
 	void *data = NULL;
diff -puN kernel/workqueue.c~kthread-rename-probe_kthread_data-to-kthread_probe_data kernel/workqueue.c
--- a/kernel/workqueue.c~kthread-rename-probe_kthread_data-to-kthread_probe_data
+++ a/kernel/workqueue.c
@@ -4249,7 +4249,7 @@ void print_worker_info(const char *log_l
 	 * This function is called without any synchronization and @task
 	 * could be in any state.  Be careful with dereferences.
 	 */
-	worker = probe_kthread_data(task);
+	worker = kthread_probe_data(task);
 
 	/*
 	 * Carefully copy the associated workqueue's workfn and name.  Keep
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread-rename-probe_kthread_data-to-kthread_probe_data.patch
kthread-kthread-worker-api-cleanup.patch
kthread-smpboot-do-not-park-in-kthread_create_on_cpu.patch
kthread-allow-to-call-__kthread_create_on_node-with-va_list-args.patch
kthread-add-kthread_create_worker.patch
kthread-add-kthread_destroy_worker.patch
kthread-detect-when-a-kthread-work-is-used-by-more-workers.patch
kthread-initial-support-for-delayed-kthread-work.patch
kthread-allow-to-cancel-kthread-work.patch
kthread-allow-to-modify-delayed-kthread-work.patch
kthread-better-support-freezable-kthread-workers.patch

