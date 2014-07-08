From: akpm@linux-foundation.org
Subject: + fork-make-mm_init_owner-static.patch added to -mm tree
Date: Tue, 08 Jul 2014 14:42:26 -0700
Message-ID: <53bc65c2.WLBrtqRNHNPfkeMi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:36782 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGHVm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 17:42:27 -0400
Received: by mail-pa0-f73.google.com with SMTP id kq14so1427321pab.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 14:42:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: make mm_init_owner static
has been added to the -mm tree.  Its filename is
     fork-make-mm_init_owner-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-make-mm_init_owner-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-make-mm_init_owner-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2957,15 +2957,10 @@ static inline void inc_syscw(struct task
 
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
@@ -526,6 +526,13 @@ static void mm_init_aio(struct mm_struct
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
@@ -1098,13 +1105,6 @@ static void rt_mutex_init_task(struct ta
 #endif
 }
 
-#ifdef CONFIG_MEMCG
-void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-	mm->owner = p;
-}
-#endif /* CONFIG_MEMCG */
-
 /*
  * Initialize POSIX timer handling for a single task.
  */
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

