From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to
 -mm tree
Date: Tue, 3 Feb 2009 11:25:29 -0800
Message-ID: <20090203112529.26e6bf76.akpm@linux-foundation.org>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZBCT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 14:28:14 -0500
In-Reply-To: <c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org, rusty@rustcorp.com.au

On Tue, 3 Feb 2009 17:58:13 +0100
Fr__d__ric Weisbecker <fweisbec@gmail.com> wrote:

> 2009/2/3 Ingo Molnar <mingo@elte.hu>:
> >
> > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> >
> >> ------------------------------------------------------
> >> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> >> From: Andrew Morton <akpm@linux-foundation.org>
> >>
> >> The various implemetnations and proposed implemetnations of work_on_cpu()
> >> are vulnerable to various deadlocks because they all used queues of some
> >> form.
> >>
> >> Unrelated pieces of kernel code thus gained dependencies wherein if one
> >> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
> >> also takes, the kernel could rarely deadlock.
> >>
> >> Fix this by creating a short-lived kernel thread for each work_on_cpu()
> >> invokation.
> >>
> >> This is not terribly fast, but the only current caller of work_on_cpu() is
> >> pci_call_probe().
> >
> > hm, it's quite ugly as well

No it isn't.

It's no less ugly than the current code.

It's less buggy than the current code.

>, and wasteful with resources.

The current code consumes about 10kbytes per cpu and one kernel thread
per cpu.  This code fixes that.

(ie: since when did you guys care about consuming resources?)

> Sorry I don't see the patch but only the changelog.
> So perhaps my answer will be a bit out of sync.
> 
> But if pci_call_probe() is the only caller, so it is supposed to be
> called only on boot.
> Perhaps the work_on_cpu thread can be killed after boot up and then
> become a thread created
> on the fly after that if needed....
> 
> Or perhaps it's too much complex.....

Series of four patches:

- switch cstate.c frmo work_on_cpu to smp_call_function_single()

- ditto acpi-cpufreq.c

- ditto mce_amd_64.c

The final work_on_cpu() caller is pci_call_probe().  I'd like to find a
way of removing that callsite as well, so we can finally remove this
turkey but for now, just fix the bugs in it:



From: Andrew Morton <akpm@linux-foundation.org>

The various implementations and proposed implementations of work_on_cpu()
are vulnerable to various deadlocks because they all use queues of some
form.

Unrelated pieces of kernel code thus gained dependencies wherein if one
work_on_cpu() caller holds a lock which some other work_on_cpu() callback
also takes, the kernel could rarely deadlock.

Also, the present work_on_cpu() implementation creates yet another kernel
thread per CPU.

Fix this by creating a short-lived kernel thread for each work_on_cpu()
invokation.

This is not terribly fast, but the only current caller of work_on_cpu() is
pci_call_probe().

It would be nice to find some other way of doing the node-local
allocations in the PCI probe code so that we can zap work_on_cpu()
altogether.  The code there is rather nasty.  I can't think of anything
simple at this time...

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand kernel/workqueue.c
--- a/kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand
+++ a/kernel/workqueue.c
@@ -971,20 +971,20 @@ undo:
 }
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *work_on_cpu_wq __read_mostly;
 
 struct work_for_cpu {
-	struct work_struct work;
+	struct completion completion;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static void do_work_for_cpu(struct work_struct *w)
+static int do_work_for_cpu(void *_wfc)
 {
-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
-
+	struct work_for_cpu *wfc = _wfc;
 	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->completion);
+	return 0;
 }
 
 /**
@@ -995,17 +995,23 @@ static void do_work_for_cpu(struct work_
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ * The caller must not hold any locks which would prevent @fn from completing.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
+	struct task_struct *sub_thread;
+	struct work_for_cpu wfc = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
+		.fn = fn,
+		.arg = arg,
+	};
+
+	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
+	if (IS_ERR(sub_thread))
+		return PTR_ERR(sub_thread);
+	kthread_bind(sub_thread, cpu);
+	wake_up_process(sub_thread);
+	wait_for_completion(&wfc.completion);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
@@ -1021,8 +1027,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-#ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
-	BUG_ON(!work_on_cpu_wq);
-#endif
 }
_

