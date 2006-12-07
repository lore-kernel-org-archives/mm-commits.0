From: akpm@osdl.org
Subject: - taskstats-factor-out-reply-assembling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:25 -0800
Message-ID: <200612072303.kB7N3PP2029959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51923 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163824AbWLGXDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, jlan@sgi.com, nagar@watson.ibm.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     taskstats: factor out reply assembling
has been removed from the -mm tree.  Its filename was
     taskstats-factor-out-reply-assembling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: factor out reply assembling
From: Oleg Nesterov <oleg@tv-sign.ru>

Introduce mk_reply() helper which does all nla_put()s on reply.

Saves 453 bytes and a preparation for the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@sgi.com>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/taskstats.c |   55 +++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff -puN kernel/taskstats.c~taskstats-factor-out-reply-assembling kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-factor-out-reply-assembling
+++ a/kernel/taskstats.c
@@ -343,6 +343,25 @@ static int parse(struct nlattr *na, cpum
 	return ret;
 }
 
+static int mk_reply(struct sk_buff *skb, int type, u32 pid, struct taskstats *stats)
+{
+	struct nlattr *na;
+	int aggr;
+
+	aggr = TASKSTATS_TYPE_AGGR_TGID;
+	if (type == TASKSTATS_TYPE_PID)
+		aggr = TASKSTATS_TYPE_AGGR_PID;
+
+	na = nla_nest_start(skb, aggr);
+	NLA_PUT_U32(skb, type, pid);
+	NLA_PUT_TYPE(skb, struct taskstats, TASKSTATS_TYPE_STATS, *stats);
+	nla_nest_end(skb, na);
+
+	return 0;
+nla_put_failure:
+	return -1;
+}
+
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	int rc = 0;
@@ -350,7 +369,6 @@ static int taskstats_user_cmd(struct sk_
 	struct taskstats stats;
 	void *reply;
 	size_t size;
-	struct nlattr *na;
 	cpumask_t mask;
 
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], &mask);
@@ -382,27 +400,21 @@ static int taskstats_user_cmd(struct sk_
 		if (rc < 0)
 			goto err;
 
-		na = nla_nest_start(rep_skb, TASKSTATS_TYPE_AGGR_PID);
-		NLA_PUT_U32(rep_skb, TASKSTATS_TYPE_PID, pid);
-		NLA_PUT_TYPE(rep_skb, struct taskstats, TASKSTATS_TYPE_STATS,
-				stats);
+		if (mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid, &stats))
+			goto nla_put_failure;
 	} else if (info->attrs[TASKSTATS_CMD_ATTR_TGID]) {
 		u32 tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
 		rc = fill_tgid(tgid, NULL, &stats);
 		if (rc < 0)
 			goto err;
 
-		na = nla_nest_start(rep_skb, TASKSTATS_TYPE_AGGR_TGID);
-		NLA_PUT_U32(rep_skb, TASKSTATS_TYPE_TGID, tgid);
-		NLA_PUT_TYPE(rep_skb, struct taskstats, TASKSTATS_TYPE_STATS,
-				stats);
+		if (mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid, &stats))
+			goto nla_put_failure;
 	} else {
 		rc = -EINVAL;
 		goto err;
 	}
 
-	nla_nest_end(rep_skb, na);
-
 	return send_reply(rep_skb, info->snd_pid);
 
 nla_put_failure:
@@ -446,7 +458,6 @@ void taskstats_exit(struct task_struct *
 	void *reply;
 	size_t size;
 	int is_thread_group;
-	struct nlattr *na;
 
 	if (!family_registered)
 		return;
@@ -481,27 +492,17 @@ void taskstats_exit(struct task_struct *
 	if (rc < 0)
 		goto err_skb;
 
-	na = nla_nest_start(rep_skb, TASKSTATS_TYPE_AGGR_PID);
-	NLA_PUT_U32(rep_skb, TASKSTATS_TYPE_PID, (u32)tsk->pid);
-	NLA_PUT_TYPE(rep_skb, struct taskstats, TASKSTATS_TYPE_STATS,
-			*tidstats);
-	nla_nest_end(rep_skb, na);
-
-	if (!is_thread_group)
-		goto send;
+	if (mk_reply(rep_skb, TASKSTATS_TYPE_PID, tsk->pid, tidstats))
+		goto nla_put_failure;
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
 	 */
-	if (!group_dead)
+	if (!is_thread_group || !group_dead)
 		goto send;
 
-	na = nla_nest_start(rep_skb, TASKSTATS_TYPE_AGGR_TGID);
-	NLA_PUT_U32(rep_skb, TASKSTATS_TYPE_TGID, (u32)tsk->tgid);
-	/* No locking needed for tsk->signal->stats since group is dead */
-	NLA_PUT_TYPE(rep_skb, struct taskstats, TASKSTATS_TYPE_STATS,
-			*tsk->signal->stats);
-	nla_nest_end(rep_skb, na);
+	if (mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid, tsk->signal->stats))
+		goto nla_put_failure;
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
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

