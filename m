From: akpm@osdl.org
Subject: - taskstats-cleanup-do_exit-path.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:19 -0800
Message-ID: <200612072303.kB7N3JiZ029953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163564AbWLGXDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, jlan@engr.sgi.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: cleanup do_exit() path
has been removed from the -mm tree.  Its filename was
     taskstats-cleanup-do_exit-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: cleanup do_exit() path
From: Oleg Nesterov <oleg@tv-sign.ru>

do_exit:
	taskstats_exit_alloc()
	...
	taskstats_exit_send()
	taskstats_exit_free()

I think this is not good, let it be a single function exported to the core
kernel, taskstats_exit(), which does alloc + send + free itself.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/taskstats_kern.h |   17 +-----------
 kernel/exit.c                  |    8 +-----
 kernel/taskstats.c             |   41 +++++++++++--------------------
 3 files changed, 19 insertions(+), 47 deletions(-)

diff -puN include/linux/taskstats_kern.h~taskstats-cleanup-do_exit-path include/linux/taskstats_kern.h
--- a/include/linux/taskstats_kern.h~taskstats-cleanup-do_exit-path
+++ a/include/linux/taskstats_kern.h
@@ -15,12 +15,6 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
-static inline void taskstats_exit_free(struct taskstats *tidstats)
-{
-	if (tidstats)
-		kmem_cache_free(taskstats_cache, tidstats);
-}
-
 static inline void taskstats_tgid_init(struct signal_struct *sig)
 {
 	sig->stats = NULL;
@@ -54,17 +48,10 @@ static inline void taskstats_tgid_free(s
 		kmem_cache_free(taskstats_cache, sig->stats);
 }
 
-extern void taskstats_exit_alloc(struct taskstats **, unsigned int *);
-extern void taskstats_exit_send(struct task_struct *, struct taskstats *, int, unsigned int);
+extern void taskstats_exit(struct task_struct *, int group_dead);
 extern void taskstats_init_early(void);
 #else
-static inline void taskstats_exit_alloc(struct taskstats **ptidstats, unsigned int *mycpu)
-{}
-static inline void taskstats_exit_free(struct taskstats *ptidstats)
-{}
-static inline void taskstats_exit_send(struct task_struct *tsk,
-				       struct taskstats *tidstats,
-				       int group_dead, unsigned int cpu)
+static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
 static inline void taskstats_tgid_init(struct signal_struct *sig)
 {}
diff -puN kernel/exit.c~taskstats-cleanup-do_exit-path kernel/exit.c
--- a/kernel/exit.c~taskstats-cleanup-do_exit-path
+++ a/kernel/exit.c
@@ -850,9 +850,7 @@ static void exit_notify(struct task_stru
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
-	struct taskstats *tidstats;
 	int group_dead;
-	unsigned int mycpu;
 
 	profile_task_exit(tsk);
 
@@ -890,8 +888,6 @@ fastcall NORET_TYPE void do_exit(long co
 				current->comm, current->pid,
 				preempt_count());
 
-	taskstats_exit_alloc(&tidstats, &mycpu);
-
 	acct_update_integrals(tsk);
 	if (tsk->mm) {
 		update_hiwater_rss(tsk->mm);
@@ -911,8 +907,8 @@ fastcall NORET_TYPE void do_exit(long co
 #endif
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
-	taskstats_exit_send(tsk, tidstats, group_dead, mycpu);
-	taskstats_exit_free(tidstats);
+
+	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
 
diff -puN kernel/taskstats.c~taskstats-cleanup-do_exit-path kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-cleanup-do_exit-path
+++ a/kernel/taskstats.c
@@ -119,10 +119,10 @@ static int send_reply(struct sk_buff *sk
 /*
  * Send taskstats data in @skb to listeners registered for @cpu's exit data
  */
-static void send_cpu_listeners(struct sk_buff *skb, unsigned int cpu)
+static void send_cpu_listeners(struct sk_buff *skb,
+					struct listener_list *listeners)
 {
 	struct genlmsghdr *genlhdr = nlmsg_data((struct nlmsghdr *)skb->data);
-	struct listener_list *listeners;
 	struct listener *s, *tmp;
 	struct sk_buff *skb_next, *skb_cur = skb;
 	void *reply = genlmsg_data(genlhdr);
@@ -135,7 +135,6 @@ static void send_cpu_listeners(struct sk
 	}
 
 	rc = 0;
-	listeners = &per_cpu(listener_array, cpu);
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
 		skb_next = NULL;
@@ -413,28 +412,12 @@ err:
 	return rc;
 }
 
-void taskstats_exit_alloc(struct taskstats **ptidstats, unsigned int *mycpu)
-{
-	struct listener_list *listeners;
-	/*
-	 * This is the cpu on which the task is exiting currently and will
-	 * be the one for which the exit event is sent, even if the cpu
-	 * on which this function is running changes later.
-	 */
-	*mycpu = raw_smp_processor_id();
-
-	listeners = &per_cpu(listener_array, *mycpu);
-
-	*ptidstats = NULL;
-	if (!list_empty(&listeners->list))
-		*ptidstats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
-}
-
 /* Send pid data out on exit */
-void taskstats_exit_send(struct task_struct *tsk, struct taskstats *tidstats,
-			int group_dead, unsigned int mycpu)
+void taskstats_exit(struct task_struct *tsk, int group_dead)
 {
 	int rc;
+	struct listener_list *listeners;
+	struct taskstats *tidstats;
 	struct sk_buff *rep_skb;
 	void *reply;
 	size_t size;
@@ -458,12 +441,17 @@ void taskstats_exit_send(struct task_str
 		fill_tgid_exit(tsk);
 	}
 
+	listeners = &__raw_get_cpu_var(listener_array);
+	if (list_empty(&listeners->list))
+		return;
+
+	tidstats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 	if (!tidstats)
 		return;
 
 	rc = prepare_reply(NULL, TASKSTATS_CMD_NEW, &rep_skb, &reply, size);
 	if (rc < 0)
-		goto ret;
+		goto free_stats;
 
 	rc = fill_pid(tsk->pid, tsk, tidstats);
 	if (rc < 0)
@@ -492,15 +480,16 @@ void taskstats_exit_send(struct task_str
 	nla_nest_end(rep_skb, na);
 
 send:
-	send_cpu_listeners(rep_skb, mycpu);
+	send_cpu_listeners(rep_skb, listeners);
+free_stats:
+	kmem_cache_free(taskstats_cache, tidstats);
 	return;
 
 nla_put_failure:
 	genlmsg_cancel(rep_skb, reply);
 err_skb:
 	nlmsg_free(rep_skb);
-ret:
-	return;
+	goto free_stats;
 }
 
 static struct genl_ops taskstats_ops = {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
pidhash-temporary-debug-checks.patch

