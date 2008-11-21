From: akpm@linux-foundation.org
Subject: + mm-remove-cgroup_mm_owner_callbacks.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:11:44 -0800
Message-ID: <200811212011.mALKBjgT017553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYKUUMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:12:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@in.ibm.com, menage@google.com


The patch titled
     mm: remove cgroup_mm_owner_callbacks
has been added to the -mm tree.  Its filename is
     mm-remove-cgroup_mm_owner_callbacks.patch

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
Subject: mm: remove cgroup_mm_owner_callbacks
From: Hugh Dickins <hugh@veritas.com>

cgroup_mm_owner_callbacks() was brought in to support the memrlimit
controller, but sneaked into mainline ahead of it.  That controller has
now been shelved, and the mm_owner_changed() args were inadequate for it
anyway (they needed an mm pointer instead of a task pointer).

Remove the dead code, and restore mm_update_next_owner() locking to how it
was before: taking mmap_sem there does nothing for memcontrol.c, now the
only user of mm->owner.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   14 +-------------
 kernel/cgroup.c        |   33 ---------------------------------
 kernel/exit.c          |   16 ++++++----------
 3 files changed, 7 insertions(+), 56 deletions(-)

diff -puN include/linux/cgroup.h~mm-remove-cgroup_mm_owner_callbacks include/linux/cgroup.h
--- a/include/linux/cgroup.h~mm-remove-cgroup_mm_owner_callbacks
+++ a/include/linux/cgroup.h
@@ -329,13 +329,7 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
-	/*
-	 * This routine is called with the task_lock of mm->owner held
-	 */
-	void (*mm_owner_changed)(struct cgroup_subsys *ss,
-					struct cgroup *old,
-					struct cgroup *new,
-					struct task_struct *p);
+
 	int subsys_id;
 	int active;
 	int disabled;
@@ -400,9 +394,6 @@ void cgroup_iter_end(struct cgroup *cgrp
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
-void cgroup_mm_owner_callbacks(struct task_struct *old,
-			       struct task_struct *new);
-
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
@@ -420,9 +411,6 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
-static inline void cgroup_mm_owner_callbacks(struct task_struct *old,
-					     struct task_struct *new) {}
-
 #endif /* !CONFIG_CGROUPS */
 
 #endif /* _LINUX_CGROUP_H */
diff -puN kernel/cgroup.c~mm-remove-cgroup_mm_owner_callbacks kernel/cgroup.c
--- a/kernel/cgroup.c~mm-remove-cgroup_mm_owner_callbacks
+++ a/kernel/cgroup.c
@@ -116,7 +116,6 @@ static int root_count;
  * be called.
  */
 static int need_forkexit_callback __read_mostly;
-static int need_mm_owner_callback __read_mostly;
 
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
@@ -2539,7 +2538,6 @@ static void __init cgroup_init_subsys(st
 	init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
 
 	need_forkexit_callback |= ss->fork || ss->exit;
-	need_mm_owner_callback |= !!ss->mm_owner_changed;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -2789,37 +2787,6 @@ void cgroup_fork_callbacks(struct task_s
 	}
 }
 
-#ifdef CONFIG_MM_OWNER
-/**
- * cgroup_mm_owner_callbacks - run callbacks when the mm->owner changes
- * @p: the new owner
- *
- * Called on every change to mm->owner. mm_init_owner() does not
- * invoke this routine, since it assigns the mm->owner the first time
- * and does not change it.
- *
- * The callbacks are invoked with mmap_sem held in read mode.
- */
-void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
-{
-	struct cgroup *oldcgrp, *newcgrp = NULL;
-
-	if (need_mm_owner_callback) {
-		int i;
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss = subsys[i];
-			oldcgrp = task_cgroup(old, ss->subsys_id);
-			if (new)
-				newcgrp = task_cgroup(new, ss->subsys_id);
-			if (oldcgrp == newcgrp)
-				continue;
-			if (ss->mm_owner_changed)
-				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
-		}
-	}
-}
-#endif /* CONFIG_MM_OWNER */
-
 /**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
diff -puN kernel/exit.c~mm-remove-cgroup_mm_owner_callbacks kernel/exit.c
--- a/kernel/exit.c~mm-remove-cgroup_mm_owner_callbacks
+++ a/kernel/exit.c
@@ -638,35 +638,31 @@ retry:
 	/*
 	 * We found no owner yet mm_users > 1: this implies that we are
 	 * most likely racing with swapoff (try_to_unuse()) or /proc or
-	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL,
-	 * so that subsystems can understand the callback and take action.
+	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL.
 	 */
-	down_write(&mm->mmap_sem);
-	cgroup_mm_owner_callbacks(mm->owner, NULL);
 	mm->owner = NULL;
-	up_write(&mm->mmap_sem);
 	return;
 
 assign_new_owner:
 	BUG_ON(c == p);
 	get_task_struct(c);
-	read_unlock(&tasklist_lock);
-	down_write(&mm->mmap_sem);
 	/*
 	 * The task_lock protects c->mm from changing.
 	 * We always want mm->owner->mm == mm
 	 */
 	task_lock(c);
+	/*
+	 * Delay read_unlock() till we have the task_lock()
+	 * to ensure that c does not slip away underneath us
+	 */
+	read_unlock(&tasklist_lock);
 	if (c->mm != mm) {
 		task_unlock(c);
-		up_write(&mm->mmap_sem);
 		put_task_struct(c);
 		goto retry;
 	}
-	cgroup_mm_owner_callbacks(mm->owner, c);
 	mm->owner = c;
 	task_unlock(c);
-	up_write(&mm->mmap_sem);
 	put_task_struct(c);
 }
 #endif /* CONFIG_MM_OWNER */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

