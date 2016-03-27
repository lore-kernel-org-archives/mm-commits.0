From: akpm@linux-foundation.org
Subject: [merged] oom-make-oom_reaper_list-single-linked.patch removed
 from -mm tree
Date: Sat, 26 Mar 2016 20:30:02 -0700
Message-ID: <56f753ba.YCO8F+TtDn3hMpuP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0DaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: make oom_reaper_list single linked
has been removed from the -mm tree.  Its filename was
     oom-make-oom_reaper_list-single-linked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: oom: make oom_reaper_list single linked

Entries are only added/removed from oom_reaper_list at head so we can use
a single linked list and hence save a word in task_struct.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/oom_kill.c         |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/sched.h~oom-make-oom_reaper_list-single-linked include/linux/sched.h
--- a/include/linux/sched.h~oom-make-oom_reaper_list-single-linked
+++ a/include/linux/sched.h
@@ -1852,7 +1852,7 @@ struct task_struct {
 #endif
 	int pagefault_disabled;
 #ifdef CONFIG_MMU
-	struct list_head oom_reaper_list;
+	struct task_struct *oom_reaper_list;
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
diff -puN mm/oom_kill.c~oom-make-oom_reaper_list-single-linked mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-oom_reaper_list-single-linked
+++ a/mm/oom_kill.c
@@ -419,7 +419,7 @@ bool oom_killer_disabled __read_mostly;
  */
 static struct task_struct *oom_reaper_th;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
-static LIST_HEAD(oom_reaper_list);
+static struct task_struct *oom_reaper_list;
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
 
@@ -528,13 +528,11 @@ static int oom_reaper(void *unused)
 	while (true) {
 		struct task_struct *tsk = NULL;
 
-		wait_event_freezable(oom_reaper_wait,
-				     (!list_empty(&oom_reaper_list)));
+		wait_event_freezable(oom_reaper_wait, oom_reaper_list != NULL);
 		spin_lock(&oom_reaper_lock);
-		if (!list_empty(&oom_reaper_list)) {
-			tsk = list_first_entry(&oom_reaper_list,
-					struct task_struct, oom_reaper_list);
-			list_del(&tsk->oom_reaper_list);
+		if (oom_reaper_list != NULL) {
+			tsk = oom_reaper_list;
+			oom_reaper_list = tsk->oom_reaper_list;
 		}
 		spin_unlock(&oom_reaper_lock);
 
@@ -553,7 +551,8 @@ static void wake_oom_reaper(struct task_
 	get_task_struct(tsk);
 
 	spin_lock(&oom_reaper_lock);
-	list_add(&tsk->oom_reaper_list, &oom_reaper_list);
+	tsk->oom_reaper_list = oom_reaper_list;
+	oom_reaper_list = tsk;
 	spin_unlock(&oom_reaper_lock);
 	wake_up(&oom_reaper_wait);
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


