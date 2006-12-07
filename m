From: akpm@osdl.org
Subject: - taskstats-cleanup-reply-assembling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:31 -0800
Message-ID: <200612072303.kB7N3VrK029967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163628AbWLGXEf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, jlan@sgi.com, nagar@watson.ibm.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     taskstats: cleanup reply assembling
has been removed from the -mm tree.  Its filename was
     taskstats-cleanup-reply-assembling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: cleanup reply assembling
From: Oleg Nesterov <oleg@tv-sign.ru>

Thomas Graf wrote:
>
> nla_nest_start() may return NULL, either rely on prepare_reply() to be
> correct and BUG() on failure or do proper error handling for all
> functions.

nla_put() in taskstat.c can fail only if the 'size' argument of alloc_skb()
was not right. This is a kernel bug, we should not hide it. So add 'BUG()'
on error path and check for 'na == NULL'.

> genlmsg_cancel() is only required in error paths for dumping
> procedures.

So we can remove 'genlmsg_cancel()' calls and 'void *reply' (saves 227 bytes).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/taskstats.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff -puN kernel/taskstats.c~taskstats-cleanup-reply-assembling kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-cleanup-reply-assembling
+++ a/kernel/taskstats.c
@@ -69,7 +69,7 @@ enum actions {
 };
 
 static int prepare_reply(struct genl_info *info, u8 cmd, struct sk_buff **skbp,
-			void **replyp, size_t size)
+				size_t size)
 {
 	struct sk_buff *skb;
 	void *reply;
@@ -94,7 +94,6 @@ static int prepare_reply(struct genl_inf
 	}
 
 	*skbp = skb;
-	*replyp = reply;
 	return 0;
 }
 
@@ -351,11 +350,13 @@ static struct taskstats *mk_reply(struct
 	struct nlattr *na, *ret;
 	int aggr;
 
-	aggr = TASKSTATS_TYPE_AGGR_TGID;
-	if (type == TASKSTATS_TYPE_PID)
-		aggr = TASKSTATS_TYPE_AGGR_PID;
+	aggr = (type == TASKSTATS_TYPE_PID)
+			? TASKSTATS_TYPE_AGGR_PID
+			: TASKSTATS_TYPE_AGGR_TGID;
 
 	na = nla_nest_start(skb, aggr);
+	if (!na)
+		goto err;
 	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
 		goto err;
 	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
@@ -373,7 +374,6 @@ static int taskstats_user_cmd(struct sk_
 	int rc = 0;
 	struct sk_buff *rep_skb;
 	struct taskstats *stats;
-	void *reply;
 	size_t size;
 	cpumask_t mask;
 
@@ -395,7 +395,7 @@ static int taskstats_user_cmd(struct sk_
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
-	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, &reply, size);
+	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
 	if (rc < 0)
 		return rc;
 
@@ -404,27 +404,24 @@ static int taskstats_user_cmd(struct sk_
 		u32 pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
 		stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
 		if (!stats)
-			goto nla_err;
+			goto err;
 
 		rc = fill_pid(pid, NULL, stats);
 		if (rc < 0)
-			goto nla_err;
+			goto err;
 	} else if (info->attrs[TASKSTATS_CMD_ATTR_TGID]) {
 		u32 tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
 		stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
 		if (!stats)
-			goto nla_err;
+			goto err;
 
 		rc = fill_tgid(tgid, NULL, stats);
 		if (rc < 0)
-			goto nla_err;
+			goto err;
 	} else
 		goto err;
 
 	return send_reply(rep_skb, info->snd_pid);
-
-nla_err:
-	genlmsg_cancel(rep_skb, reply);
 err:
 	nlmsg_free(rep_skb);
 	return rc;
@@ -461,7 +458,6 @@ void taskstats_exit(struct task_struct *
 	struct listener_list *listeners;
 	struct taskstats *stats;
 	struct sk_buff *rep_skb;
-	void *reply;
 	size_t size;
 	int is_thread_group;
 
@@ -486,17 +482,17 @@ void taskstats_exit(struct task_struct *
 	if (list_empty(&listeners->list))
 		return;
 
-	rc = prepare_reply(NULL, TASKSTATS_CMD_NEW, &rep_skb, &reply, size);
+	rc = prepare_reply(NULL, TASKSTATS_CMD_NEW, &rep_skb, size);
 	if (rc < 0)
 		return;
 
 	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, tsk->pid);
 	if (!stats)
-		goto nla_err;
+		goto err;
 
 	rc = fill_pid(tsk->pid, tsk, stats);
 	if (rc < 0)
-		goto nla_err;
+		goto err;
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
@@ -506,16 +502,14 @@ void taskstats_exit(struct task_struct *
 
 	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);
 	if (!stats)
-		goto nla_err;
+		goto err;
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
 	return;
-
-nla_err:
-	genlmsg_cancel(rep_skb, reply);
+err:
 	nlmsg_free(rep_skb);
 }
 
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

