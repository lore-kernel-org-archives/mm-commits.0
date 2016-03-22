From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-implement-oom-victims-queuing-v6.patch added to
 -mm tree
Date: Tue, 22 Mar 2016 15:59:18 -0700
Message-ID: <56f1ce46.R4b/AkNtuSUpCeLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbcCVW7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 18:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-implement-oom-victims-queuing-v6
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-implement-oom-victims-queuing-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-implement-oom-victims-queuing-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-implement-oom-victims-queuing-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-oom_reaper-implement-oom-victims-queuing-v6

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/oom_kill.c         |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~mm-oom_reaper-implement-oom-victims-queuing-v6 include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-implement-oom-victims-queuing-v6
+++ a/include/linux/sched.h
@@ -1850,7 +1850,7 @@ struct task_struct {
 #endif
 	int pagefault_disabled;
 #ifdef CONFIG_MMU
-	struct task_struct *oom_reaper_list;
+	struct list_head oom_reaper_list;
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
diff -puN mm/oom_kill.c~mm-oom_reaper-implement-oom-victims-queuing-v6 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-implement-oom-victims-queuing-v6
+++ a/mm/oom_kill.c
@@ -417,7 +417,7 @@ bool oom_killer_disabled __read_mostly;
  */
 static struct task_struct *oom_reaper_th;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
-static struct task_struct *oom_reaper_list;
+static LIST_HEAD(oom_reaper_list);
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
 
@@ -523,11 +523,13 @@ static int oom_reaper(void *unused)
 	while (true) {
 		struct task_struct *tsk = NULL;
 
-		wait_event_freezable(oom_reaper_wait, oom_reaper_list != NULL);
+		wait_event_freezable(oom_reaper_wait,
+				     (!list_empty(&oom_reaper_list)));
 		spin_lock(&oom_reaper_lock);
-		if (oom_reaper_list != NULL) {
-			tsk = oom_reaper_list;
-			oom_reaper_list = tsk->oom_reaper_list;
+		if (!list_empty(&oom_reaper_list)) {
+			tsk = list_first_entry(&oom_reaper_list,
+					struct task_struct, oom_reaper_list);
+			list_del(&tsk->oom_reaper_list);
 		}
 		spin_unlock(&oom_reaper_lock);
 
@@ -546,8 +548,7 @@ static void wake_oom_reaper(struct task_
 	get_task_struct(tsk);
 
 	spin_lock(&oom_reaper_lock);
-	tsk->oom_reaper_list = oom_reaper_list;
-	oom_reaper_list = tsk;
+	list_add(&tsk->oom_reaper_list, &oom_reaper_list);
 	spin_unlock(&oom_reaper_lock);
 	wake_up(&oom_reaper_wait);
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-v6.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
mm-oom_reaper-implement-oom-victims-queuing-v6.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
oom-make-oom_reaper-freezable.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

