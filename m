From: akpm@linux-foundation.org
Subject: [patch 07/10] mm: oom_reaper: remove some bloat
Date: Thu, 26 May 2016 15:16:22 -0700
Message-ID: <574775b6.FlLs6nJwBTj6H/Gr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, minchan@kernel.org, penguin-kernel@i-love.sakura.ne.jp

From: Michal Hocko <mhocko@suse.com>
Subject: mm: oom_reaper: remove some bloat

mmput_async is currently used only from the oom_reaper which is defined
only for CONFIG_MMU.  We can save work_struct in mm_struct for
!CONFIG_MMU.

[akpm@linux-foundation.org: fix typo, per Minchan]
Link: http://lkml.kernel.org/r/20160520061658.GB19172@dhcp22.suse.cz
Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    4 +++-
 kernel/fork.c            |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/include/linux/mm_types.h
@@ -514,7 +514,9 @@ struct mm_struct {
 #ifdef CONFIG_HUGETLB_PAGE
 	atomic_long_t hugetlb_usage;
 #endif
+#ifdef CONFIG_MMU
 	struct work_struct async_put_work;
+#endif
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/include/linux/sched.h
@@ -2745,10 +2745,12 @@ static inline bool mmget_not_zero(struct
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
-/* same as above but performs the slow path from the async kontext. Can
+#ifdef CONFIG_MMU
+/* same as above but performs the slow path from the async context. Can
  * be called from the atomic context as well
  */
 extern void mmput_async(struct mm_struct *);
+#endif
 
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
diff -puN kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix kernel/fork.c
--- a/kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/kernel/fork.c
@@ -736,6 +736,7 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
+#ifdef CONFIG_MMU
 static void mmput_async_fn(struct work_struct *work)
 {
 	struct mm_struct *mm = container_of(work, struct mm_struct, async_put_work);
@@ -749,6 +750,7 @@ void mmput_async(struct mm_struct *mm)
 		schedule_work(&mm->async_put_work);
 	}
 }
+#endif
 
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
_
