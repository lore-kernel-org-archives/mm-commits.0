From: akpm@linux-foundation.org
Subject: + taskstats-split-fill_pid-function.patch added to -mm tree
Date: Tue, 28 Sep 2010 13:55:43 -0700
Message-ID: <201009282055.o8SKthLL017326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab0I1U4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 16:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com


The patch titled
     taskstats: split fill_pid function
has been added to the -mm tree.  Its filename is
     taskstats-split-fill_pid-function.patch

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
Subject: taskstats: split fill_pid function
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Separate the finding of a task_struct by pid or tgid from filling the
taskstats data. This makes the code more readable.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   50 ++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff -puN kernel/taskstats.c~taskstats-split-fill_pid-function kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-split-fill_pid-function
+++ a/kernel/taskstats.c
@@ -175,22 +175,8 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
-static int fill_pid(pid_t pid, struct task_struct *tsk,
-		struct taskstats *stats)
+static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
 {
-	int rc = 0;
-
-	if (!tsk) {
-		rcu_read_lock();
-		tsk = find_task_by_vpid(pid);
-		if (tsk)
-			get_task_struct(tsk);
-		rcu_read_unlock();
-		if (!tsk)
-			return -ESRCH;
-	} else
-		get_task_struct(tsk);
-
 	memset(stats, 0, sizeof(*stats));
 	/*
 	 * Each accounting subsystem adds calls to its functions to
@@ -209,17 +195,27 @@ static int fill_pid(pid_t pid, struct ta
 
 	/* fill in extended acct fields */
 	xacct_add_tsk(stats, tsk);
+}
 
-	/* Define err: label here if needed */
-	put_task_struct(tsk);
-	return rc;
+static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
+{
+	struct task_struct *tsk;
 
+	rcu_read_lock();
+	tsk = find_task_by_vpid(pid);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	if (!tsk)
+		return -ESRCH;
+	fill_stats(tsk, stats);
+	put_task_struct(tsk);
+	return 0;
 }
 
-static int fill_tgid(pid_t tgid, struct task_struct *first,
-		struct taskstats *stats)
+static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
 {
-	struct task_struct *tsk;
+	struct task_struct *tsk, *first;
 	unsigned long flags;
 	int rc = -ESRCH;
 
@@ -228,8 +224,7 @@ static int fill_tgid(pid_t tgid, struct 
 	 * leaders who are already counted with the dead tasks
 	 */
 	rcu_read_lock();
-	if (!first)
-		first = find_task_by_vpid(tgid);
+	first = find_task_by_vpid(tgid);
 
 	if (!first || !lock_task_sighand(first, &flags))
 		goto out;
@@ -268,7 +263,6 @@ out:
 	return rc;
 }
 
-
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
@@ -477,7 +471,7 @@ static int cmd_attr_pid(struct genl_info
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(pid, NULL, stats);
+	rc = fill_stats_for_pid(pid, stats);
 	if (rc < 0)
 		goto err;
 	return send_reply(rep_skb, info);
@@ -507,7 +501,7 @@ static int cmd_attr_tgid(struct genl_inf
 	if (!stats)
 		goto err;
 
-	rc = fill_tgid(tgid, NULL, stats);
+	rc = fill_stats_for_tgid(tgid, stats);
 	if (rc < 0)
 		goto err;
 	return send_reply(rep_skb, info);
@@ -593,9 +587,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(-1, tsk, stats);
-	if (rc < 0)
-		goto err;
+	fill_stats(tsk, stats);
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

initramfs-fix-initramfs-size-calculation.patch
taskstats-separate-taskstats-commands.patch
taskstats-split-fill_pid-function.patch

