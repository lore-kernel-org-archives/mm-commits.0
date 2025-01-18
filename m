Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A0977102
	for <mm-commits@vger.kernel.org>; Sat, 18 Jan 2025 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737173271; cv=none; b=gGMRs9b8pLu63TEvcyD98maRcH1xyHp8Cidjw5W+ErZT4jrDgZbhSLCnMpZn2ud7TFd49HKRmZImbvwXU1EybpEJFT0ICmhlMMaBeVHqdLMervg9mRtnkCVfRBoYLBInQL5hkD91FHB+H7Clr6WSbv+H0yUNxb8PoaOZuZ8lRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737173271; c=relaxed/simple;
	bh=+OYfgqmtMNcSPYQ029OPmNvDbbVQdHmMIAwObTDtikE=;
	h=Date:To:From:Subject:Message-Id; b=M/D3nVIghZMa9YyjNuA9tlmANyaPs63+0xODx6cdmKqdQ+uZ5KFXXj++qOmbIA3lhg3vJy88aKhudJ9gpSeiZ31IX7PZYV8YWMBAuA3PeT4Oj/bKRx738jEvU20/g52AYXJ7KxBK591DaAFPc2i0MIVFfJNKftm3xD1iy1jO+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mPrZxhsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mPrZxhsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E36FC4CED1;
	Sat, 18 Jan 2025 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737173271;
	bh=+OYfgqmtMNcSPYQ029OPmNvDbbVQdHmMIAwObTDtikE=;
	h=Date:To:From:Subject:From;
	b=mPrZxhsRuKHKZKdlbDz0tLbx2LIWYdK66GpoMcEK5N6RRGj/zSB743FZZ21kxOWxT
	 SDg1noNUuNLH6Da0OUfQ8hmFN5/OyO9+mT5RK0UquXATPN0S/l8vOYAQnSBGrF5Uh0
	 BEsC9fZNU345evzSmw+v+Lu46fGbIZY360+CuA/I=
Date: Fri, 17 Jan 2025 20:07:50 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20250118040751.0E36FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: Use str_yes_no() and str_no_yes() helper functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: Use str_yes_no() and str_no_yes() helper functions
Date: Fri, 17 Jan 2025 10:13:29 +0100

Remove hard-coded strings by using the str_yes_no() and str_no_yes()
helper functions.

Link: https://lkml.kernel.org/r/20250117091335.1189-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch
mm-kfence-use-str_write_read-helper-in-get_access_type.patch
mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch
kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch
ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

