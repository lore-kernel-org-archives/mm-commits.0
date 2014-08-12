From: akpm@linux-foundation.org
Subject: [merged] fork-make-mm_init_owner-static.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:40:24 -0700
Message-ID: <53ea6da8.qnC/4g2jIrHGB/vC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63372 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:25 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1305667vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: make mm_init_owner static
has been removed from the -mm tree.  Its filename was
     fork-make-mm_init_owner-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: kernel/fork.c: make mm_init_owner static

It's only used in fork.c:mm_init().

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 -----
 kernel/fork.c         |   14 +++++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~fork-make-mm_init_owner-static include/linux/sched.h
--- a/include/linux/sched.h~fork-make-mm_init_owner-static
+++ a/include/linux/sched.h
@@ -2961,15 +2961,10 @@ static inline void inc_syscw(struct task
 
 #ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
-extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
 #else
 static inline void mm_update_next_owner(struct mm_struct *mm)
 {
 }
-
-static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-}
 #endif /* CONFIG_MEMCG */
 
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
diff -puN kernel/fork.c~fork-make-mm_init_owner-static kernel/fork.c
--- a/kernel/fork.c~fork-make-mm_init_owner-static
+++ a/kernel/fork.c
@@ -535,6 +535,13 @@ static void mm_init_aio(struct mm_struct
 #endif
 }
 
+static void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
+{
+#ifdef CONFIG_MEMCG
+	mm->owner = p;
+#endif
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	mm->mmap = NULL;
@@ -1139,13 +1146,6 @@ static void rt_mutex_init_task(struct ta
 #endif
 }
 
-#ifdef CONFIG_MEMCG
-void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-	mm->owner = p;
-}
-#endif /* CONFIG_MEMCG */
