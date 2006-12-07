From: akpm@osdl.org
Subject: - taskstats-use-nla_reserve-for-reply-assembling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:28 -0800
Message-ID: <200612072303.kB7N3SmG029962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163805AbWLGXHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, jlan@sgi.com, nagar@watson.ibm.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     taskstats: use nla_reserve() for reply assembling
has been removed from the -mm tree.  Its filename was
     taskstats-use-nla_reserve-for-reply-assembling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: use nla_reserve() for reply assembling
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently taskstats_user_cmd()/taskstats_exit() do:

	1) allocate stats
	2) fill stats
	3) make a temporary copy on stack (236 bytes)
	4) copy that copy to skb
	5) free stats

With the help of nla_reserve() we can operate on skb->data directly,
thus avoiding all these steps except 2).

So, before this patch:

	// copy *stats to skb->data
	int mk_reply(skb, ..., struct taskstats *stats);

	fill_pid(stats);
	mk_reply(skb, ..., stats);

After:
	// return a pointer to skb->data
	struct taskstats *mk_reply(skb, ...);

	stat = mk_reply(skb, ...);
	fill_pid(stats);

Shrinks taskatsks.o by 162 bytes.

A stupid benchmark (send one million TASKSTATS_CMD_ATTR_PID) shows the

		real user sys
	before:
		4.02 0.06 3.96
		4.02 0.04 3.98
		4.02 0.04 3.97
	after:
		3.86 0.08 3.78
		3.88 0.10 3.77
		3.89 0.09 3.80

but this looks suspiciously good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/taskstats.c |   86 ++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 42 deletions(-)

diff -puN kernel/taskstats.c~taskstats-use-nla_reserve-for-reply-assembling kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-use-nla_reserve-for-reply-assembling
+++ a/kernel/taskstats.c
@@ -185,6 +185,7 @@ static int fill_pid(pid_t pid, struct ta
 	} else
 		get_task_struct(tsk);
 
+	memset(stats, 0, sizeof(*stats));
 	/*
 	 * Each accounting subsystem adds calls to its functions to
 	 * fill in relevant parts of struct taskstsats as follows
@@ -227,6 +228,8 @@ static int fill_tgid(pid_t tgid, struct 
 
 	if (first->signal->stats)
 		memcpy(stats, first->signal->stats, sizeof(*stats));
+	else
+		memset(stats, 0, sizeof(*stats));
 
 	tsk = first;
 	do {
@@ -343,9 +346,9 @@ static int parse(struct nlattr *na, cpum
 	return ret;
 }
 
-static int mk_reply(struct sk_buff *skb, int type, u32 pid, struct taskstats *stats)
+static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
 {
-	struct nlattr *na;
+	struct nlattr *na, *ret;
 	int aggr;
 
 	aggr = TASKSTATS_TYPE_AGGR_TGID;
@@ -353,20 +356,23 @@ static int mk_reply(struct sk_buff *skb,
 		aggr = TASKSTATS_TYPE_AGGR_PID;
 
 	na = nla_nest_start(skb, aggr);
-	NLA_PUT_U32(skb, type, pid);
-	NLA_PUT_TYPE(skb, struct taskstats, TASKSTATS_TYPE_STATS, *stats);
+	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
+		goto err;
+	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
+	if (!ret)
+		goto err;
 	nla_nest_end(skb, na);
 
-	return 0;
-nla_put_failure:
-	return -1;
+	return nla_data(ret);
+err:
+	return NULL;
 }
 
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	int rc = 0;
 	struct sk_buff *rep_skb;
-	struct taskstats stats;
+	struct taskstats *stats;
 	void *reply;
 	size_t size;
 	cpumask_t mask;
@@ -389,36 +395,36 @@ static int taskstats_user_cmd(struct sk_
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
-	memset(&stats, 0, sizeof(stats));
 	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, &reply, size);
 	if (rc < 0)
 		return rc;
 
+	rc = -EINVAL;
 	if (info->attrs[TASKSTATS_CMD_ATTR_PID]) {
 		u32 pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
-		rc = fill_pid(pid, NULL, &stats);
-		if (rc < 0)
-			goto err;
+		stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
+		if (!stats)
+			goto nla_err;
 
-		if (mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid, &stats))
-			goto nla_put_failure;
+		rc = fill_pid(pid, NULL, stats);
+		if (rc < 0)
+			goto nla_err;
 	} else if (info->attrs[TASKSTATS_CMD_ATTR_TGID]) {
 		u32 tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
-		rc = fill_tgid(tgid, NULL, &stats);
-		if (rc < 0)
-			goto err;
+		stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
+		if (!stats)
+			goto nla_err;
 
-		if (mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid, &stats))
-			goto nla_put_failure;
-	} else {
-		rc = -EINVAL;
+		rc = fill_tgid(tgid, NULL, stats);
+		if (rc < 0)
+			goto nla_err;
+	} else
 		goto err;
-	}
 
 	return send_reply(rep_skb, info->snd_pid);
 
-nla_put_failure:
-	rc = genlmsg_cancel(rep_skb, reply);
+nla_err:
+	genlmsg_cancel(rep_skb, reply);
 err:
 	nlmsg_free(rep_skb);
 	return rc;
@@ -453,7 +459,7 @@ void taskstats_exit(struct task_struct *
 {
 	int rc;
 	struct listener_list *listeners;
-	struct taskstats *tidstats;
+	struct taskstats *stats;
 	struct sk_buff *rep_skb;
 	void *reply;
 	size_t size;
@@ -480,20 +486,17 @@ void taskstats_exit(struct task_struct *
 	if (list_empty(&listeners->list))
 		return;
 
-	tidstats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
-	if (!tidstats)
-		return;
-
 	rc = prepare_reply(NULL, TASKSTATS_CMD_NEW, &rep_skb, &reply, size);
 	if (rc < 0)
-		goto free_stats;
+		return;
 
-	rc = fill_pid(tsk->pid, tsk, tidstats);
-	if (rc < 0)
-		goto err_skb;
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, tsk->pid);
+	if (!stats)
+		goto nla_err;
 
-	if (mk_reply(rep_skb, TASKSTATS_TYPE_PID, tsk->pid, tidstats))
-		goto nla_put_failure;
+	rc = fill_pid(tsk->pid, tsk, stats);
+	if (rc < 0)
+		goto nla_err;
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
@@ -501,20 +504,19 @@ void taskstats_exit(struct task_struct *
 	if (!is_thread_group || !group_dead)
 		goto send;
 
-	if (mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid, tsk->signal->stats))
-		goto nla_put_failure;
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);
+	if (!stats)
+		goto nla_err;
+
+	memcpy(stats, tsk->signal->stats, sizeof(*stats));
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
-free_stats:
-	kmem_cache_free(taskstats_cache, tidstats);
 	return;
 
-nla_put_failure:
+nla_err:
 	genlmsg_cancel(rep_skb, reply);
-err_skb:
 	nlmsg_free(rep_skb);
-	goto free_stats;
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

