From: akpm@linux-foundation.org
Subject: + taskstats-separate-taskstats-commands.patch added to -mm tree
Date: Tue, 28 Sep 2010 13:55:37 -0700
Message-ID: <201009282055.o8SKtdVk017320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab0I1U4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 16:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com


The patch titled
     taskstats: separate taskstats commands
has been added to the -mm tree.  Its filename is
     taskstats-separate-taskstats-commands.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: taskstats: separate taskstats commands
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Move each taskstats command into a single function.  This makes the code
more readable and makes it easier to add new commands.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |  118 ++++++++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 40 deletions(-)

diff -puN kernel/taskstats.c~taskstats-separate-taskstats-commands kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-separate-taskstats-commands
+++ a/kernel/taskstats.c
@@ -424,39 +424,76 @@ err:
 	return rc;
 }
 
-static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
+static int cmd_attr_register_cpumask(struct genl_info *info)
 {
-	int rc;
-	struct sk_buff *rep_skb;
-	struct taskstats *stats;
-	size_t size;
 	cpumask_var_t mask;
+	int rc;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
-
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
-		goto free_return_rc;
-	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, REGISTER);
-		goto free_return_rc;
-	}
+		goto out;
+	rc = add_del_listener(info->snd_pid, mask, REGISTER);
+out:
+	free_cpumask_var(mask);
+	return rc;
+}
+
+static int cmd_attr_deregister_cpumask(struct genl_info *info)
+{
+	cpumask_var_t mask;
+	int rc;
 
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
 	if (rc < 0)
-		goto free_return_rc;
-	if (rc == 0) {
-		rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
-free_return_rc:
-		free_cpumask_var(mask);
-		return rc;
-	}
+		goto out;
+	rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
+out:
 	free_cpumask_var(mask);
+	return rc;
+}
+
+static int cmd_attr_pid(struct genl_info *info)
+{
+	struct taskstats *stats;
+	struct sk_buff *rep_skb;
+	size_t size;
+	u32 pid;
+	int rc;
+
+	size = nla_total_size(sizeof(u32)) +
+		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+
+	rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
+	if (rc < 0)
+		return rc;
+
+	rc = -EINVAL;
+	pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
+	if (!stats)
+		goto err;
+
+	rc = fill_pid(pid, NULL, stats);
+	if (rc < 0)
+		goto err;
+	return send_reply(rep_skb, info);
+err:
+	nlmsg_free(rep_skb);
+	return rc;
+}
+
+static int cmd_attr_tgid(struct genl_info *info)
+{
+	struct taskstats *stats;
+	struct sk_buff *rep_skb;
+	size_t size;
+	u32 tgid;
+	int rc;
 
-	/*
-	 * Size includes space for nested attributes
-	 */
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
@@ -465,33 +502,34 @@ free_return_rc:
 		return rc;
 
 	rc = -EINVAL;
-	if (info->attrs[TASKSTATS_CMD_ATTR_PID]) {
-		u32 pid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_PID]);
-		stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, pid);
-		if (!stats)
-			goto err;
-
-		rc = fill_pid(pid, NULL, stats);
-		if (rc < 0)
-			goto err;
-	} else if (info->attrs[TASKSTATS_CMD_ATTR_TGID]) {
-		u32 tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
-		stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
-		if (!stats)
-			goto err;
-
-		rc = fill_tgid(tgid, NULL, stats);
-		if (rc < 0)
-			goto err;
-	} else
+	tgid = nla_get_u32(info->attrs[TASKSTATS_CMD_ATTR_TGID]);
+	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tgid);
+	if (!stats)
 		goto err;
 
+	rc = fill_tgid(tgid, NULL, stats);
+	if (rc < 0)
+		goto err;
 	return send_reply(rep_skb, info);
 err:
 	nlmsg_free(rep_skb);
 	return rc;
 }
 
+static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	if (info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK])
+		return cmd_attr_register_cpumask(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK])
+		return cmd_attr_deregister_cpumask(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_PID])
+		return cmd_attr_pid(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_TGID])
+		return cmd_attr_tgid(info);
+	else
+		return -EINVAL;
+}
+
 static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

initramfs-fix-initramfs-size-calculation.patch
taskstats-separate-taskstats-commands.patch
taskstats-split-fill_pid-function.patch

