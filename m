Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57314A1E
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 02:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737338461; cv=none; b=MOVWzX4JLLRALmF3sBK6dlt4y2TX0FDbPhMH27ZexPtFZdAbQz1KQ857772WZB8IL/MsezIY03WAwAxT5zTV++D2YgR+V7FIxx9PfU3d8odrtCtZPGUhrq9OVUatTxCchpbYotCDjI1lMEeGiVoYDqnT44EHYABSiqf1UpBM278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737338461; c=relaxed/simple;
	bh=5L8Xe+hinsfFyYxE2S1Cx536cf1QzsX2TqSv9PHLpEo=;
	h=Date:To:From:Subject:Message-Id; b=CNckLASuzJ4yCWnst90NFaquBX85eISuRZbaYBAD/E5jyammLDgXXa+CCd4SJ/7LTL+qNucQ8DPgpG/1Vwy0qE8Y+xhZ8LCf2p9XddpTswpoAvSdNGcGOxy5OzMxuBR+8dtSsrfZqNpRNAxcAUYGPWCZ/BH0A97ld7NkA0HV+zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkKBIrv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkKBIrv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D896C4CED6;
	Mon, 20 Jan 2025 02:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737338461;
	bh=5L8Xe+hinsfFyYxE2S1Cx536cf1QzsX2TqSv9PHLpEo=;
	h=Date:To:From:Subject:From;
	b=pkKBIrv7AGpaXp5JCL5CNCcV5HviyebK4Lm+6/ECMGOwSd+CFVGS6eSawLmbMEqak
	 bxjY/kabPl/0nIUylEDQ8QJnt1Z+RNTEC3TYYng1+VGIfNZZrgqgsJdu33C328ccWl
	 VAfhgagTFxKxLF5/iQ7QwulhChL+8ktYbXxdIkpA=
Date: Sun, 19 Jan 2025 18:01:00 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch removed from -mm tree
Message-Id: <20250120020101.1D896C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use str_yes_no() and str_no_yes() helper functions
has been removed from the -mm tree.  Its filename was
     ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: use str_yes_no() and str_no_yes() helper functions
Date: Fri, 17 Jan 2025 10:13:29 +0100

Remove hard-coded strings by using the str_yes_no() and str_no_yes()
helper functions.

Link: https://lkml.kernel.org/r/20250117091335.1189-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c    |    9 +++++----
 fs/ocfs2/dlm/dlmmaster.c   |   12 ++++++------
 fs/ocfs2/dlm/dlmrecovery.c |    7 +++----
 fs/ocfs2/dlmglue.c         |    3 ++-
 4 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-use-str_yes_no-and-str_no_yes-helper-functions
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/export.h>
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -90,12 +91,12 @@ void __dlm_print_one_lock_resource(struc
 	       buf, res->owner, res->state);
 	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
 	       res->last_used, kref_read(&res->refs),
-	       list_empty(&res->purge) ? "no" : "yes");
+	       str_no_yes(list_empty(&res->purge)));
 	printk("  on dirty list: %s, on reco list: %s, "
 	       "migrating pending: %s\n",
-	       list_empty(&res->dirty) ? "no" : "yes",
-	       list_empty(&res->recovering) ? "no" : "yes",
-	       res->migration_pending ? "yes" : "no");
+	       str_no_yes(list_empty(&res->dirty)),
+	       str_no_yes(list_empty(&res->recovering)),
+	       str_yes_no(res->migration_pending));
 	printk("  inflight locks: %d, asts reserved: %d\n",
 	       res->inflight_locks, atomic_read(&res->asts_reserved));
 	dlm_print_lockres_refmap(res);
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-use-str_yes_no-and-str_no_yes-helper-functions
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -21,7 +21,7 @@
 #include <linux/inet.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
-
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -2859,7 +2859,7 @@ static int dlm_mark_lockres_migrating(st
 	dlm_lockres_release_ast(dlm, res);
 
 	mlog(0, "about to wait on migration_wq, dirty=%s\n",
-	       res->state & DLM_LOCK_RES_DIRTY ? "yes" : "no");
+	       str_yes_no(res->state & DLM_LOCK_RES_DIRTY));
 	/* if the extra ref we just put was the final one, this
 	 * will pass thru immediately.  otherwise, we need to wait
 	 * for the last ast to finish. */
@@ -2869,12 +2869,12 @@ again:
 		   msecs_to_jiffies(1000));
 	if (ret < 0) {
 		mlog(0, "woken again: migrating? %s, dead? %s\n",
-		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
-		       test_bit(target, dlm->domain_map) ? "no":"yes");
+		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
+		       str_no_yes(test_bit(target, dlm->domain_map)));
 	} else {
 		mlog(0, "all is well: migrating? %s, dead? %s\n",
-		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
-		       test_bit(target, dlm->domain_map) ? "no":"yes");
+		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
+		       str_no_yes(test_bit(target, dlm->domain_map)));
 	}
 	if (!dlm_migration_can_proceed(dlm, res, target)) {
 		mlog(0, "trying again...\n");
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-use-str_yes_no-and-str_no_yes-helper-functions
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -22,7 +22,7 @@
 #include <linux/timer.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
-
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -581,8 +581,7 @@ static int dlm_remaster_locks(struct dlm
 							   msecs_to_jiffies(1000));
 					mlog(0, "waited 1 sec for %u, "
 					     "dead? %s\n", ndata->node_num,
-					     dlm_is_node_dead(dlm, ndata->node_num) ?
-					     "yes" : "no");
+					     str_yes_no(dlm_is_node_dead(dlm, ndata->node_num)));
 				} else {
 					/* -ENOMEM on the other node */
 					mlog(0, "%s: node %u returned "
@@ -677,7 +676,7 @@ static int dlm_remaster_locks(struct dlm
 		spin_unlock(&dlm_reco_state_lock);
 
 		mlog(0, "pass #%d, all_nodes_done?: %s\n", ++pass,
-		     all_nodes_done?"yes":"no");
+		     str_yes_no(all_nodes_done));
 		if (all_nodes_done) {
 			int ret;
 
--- a/fs/ocfs2/dlmglue.c~ocfs2-use-str_yes_no-and-str_no_yes-helper-functions
+++ a/fs/ocfs2/dlmglue.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
+#include <linux/string_choices.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
@@ -4337,7 +4338,7 @@ unqueue:
 		ocfs2_schedule_blocked_lock(osb, lockres);
 
 	mlog(ML_BASTS, "lockres %s, requeue = %s.\n", lockres->l_name,
-	     ctl.requeue ? "yes" : "no");
+	     str_yes_no(ctl.requeue));
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	if (ctl.unblock_action != UNBLOCK_CONTINUE
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


