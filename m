From: akpm@linux-foundation.org
Subject: - cgroups-add-an-owner-to-the-mm_struct.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:54 -0700
Message-ID: <200804300542.m3U5gsUH029183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985AbYD3Fnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, oleg@tv-sign.ru, penberg@cs.helsinki.fi, rientjes@google.com, skumar@linux.vnet.ibm.com


The patch titled
     cgroups: add an owner to the mm_struct
has been removed from the -mm tree.  Its filename was
     cgroups-add-an-owner-to-the-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add an owner to the mm_struct
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Remove the mem_cgroup member from mm_struct and instead adds an owner. 

This approach was suggested by Paul Menage.  The advantage of this approach
is that, once the mm->owner is known, using the subsystem id, the cgroup
can be determined.  It also allows several control groups that are
virtually grouped by mm_struct, to exist independent of the memory
controller i.e., without adding mem_cgroup's for each controller, to
mm_struct.

A new config option CONFIG_MM_OWNER is added and the memory resource
controller selects this config option.

This patch also adds cgroup callbacks to notify subsystems when mm->owner
changes.  The mm_cgroup_changed callback is called with the task_lock() of
the new task held and is called just prior to changing the mm->owner.

I am indebted to Paul Menage for the several reviews of this patchset and
helping me make it lighter and simpler.

This patch was tested on a powerpc box, it was compiled with both the
MM_OWNER config turned on and off.

After the thread group leader exits, it's moved to init_css_state by
cgroup_exit(), thus all future charges from runnings threads would be
redirected to the init_css_set's subsystem.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: David Rientjes <rientjes@google.com>,
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                  |    1 
 include/linux/cgroup.h     |   15 ++++++
 include/linux/memcontrol.h |   16 +-----
 include/linux/mm_types.h   |    5 +-
 include/linux/sched.h      |   13 +++++
 init/Kconfig               |    7 ++
 init/main.c                |    1 
 kernel/cgroup.c            |   30 ++++++++++++
 kernel/exit.c              |   83 +++++++++++++++++++++++++++++++++++
 kernel/fork.c              |   11 +++-
 mm/memcontrol.c            |   28 ++---------
 11 files changed, 169 insertions(+), 41 deletions(-)

diff -puN fs/exec.c~cgroups-add-an-owner-to-the-mm_struct fs/exec.c
--- a/fs/exec.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/fs/exec.c
@@ -735,6 +735,7 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
+	mm_update_next_owner(mm);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
diff -puN include/linux/cgroup.h~cgroups-add-an-owner-to-the-mm_struct include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-an-owner-to-the-mm_struct
+++ a/include/linux/cgroup.h
@@ -305,6 +305,12 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	/*
+	 * This routine is called with the task_lock of mm->owner held
+	 */
+	void (*mm_owner_changed)(struct cgroup_subsys *ss,
+					struct cgroup *old,
+					struct cgroup *new);
 	int subsys_id;
 	int active;
 	int disabled;
@@ -390,4 +396,13 @@ static inline int cgroupstats_build(stru
 
 #endif /* !CONFIG_CGROUPS */
 
+#ifdef CONFIG_MM_OWNER
+extern void
+cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new);
+#else /* !CONFIG_MM_OWNER */
+static inline void
+cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
+{
+}
+#endif /* CONFIG_MM_OWNER */
 #endif /* _LINUX_CGROUP_H */
diff -puN include/linux/memcontrol.h~cgroups-add-an-owner-to-the-mm_struct include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~cgroups-add-an-owner-to-the-mm_struct
+++ a/include/linux/memcontrol.h
@@ -27,9 +27,6 @@ struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
-extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
-extern void mm_free_cgroup(struct mm_struct *mm);
-
 #define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0)
 
 extern struct page_cgroup *page_get_page_cgroup(struct page *page);
@@ -48,8 +45,10 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
+extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+
 #define mm_match_cgroup(mm, cgroup)	\
-	((cgroup) == rcu_dereference((mm)->mem_cgroup))
+	((cgroup) == mem_cgroup_from_task((mm)->owner))
 
 extern int mem_cgroup_prepare_migration(struct page *page);
 extern void mem_cgroup_end_migration(struct page *page);
@@ -73,15 +72,6 @@ extern long mem_cgroup_calc_reclaim_inac
 				struct zone *zone, int priority);
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
-static inline void mm_init_cgroup(struct mm_struct *mm,
-					struct task_struct *p)
-{
-}
-
-static inline void mm_free_cgroup(struct mm_struct *mm)
-{
-}
-
 static inline void page_reset_bad_cgroup(struct page *page)
 {
 }
diff -puN include/linux/mm_types.h~cgroups-add-an-owner-to-the-mm_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~cgroups-add-an-owner-to-the-mm_struct
+++ a/include/linux/mm_types.h
@@ -222,8 +222,9 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct kioctx		*ioctx_list;
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-	struct mem_cgroup *mem_cgroup;
+#ifdef CONFIG_MM_OWNER
+	struct task_struct *owner;	/* The thread group leader that */
+					/* owns the mm_struct.		*/
 #endif
 };
 
diff -puN include/linux/sched.h~cgroups-add-an-owner-to-the-mm_struct include/linux/sched.h
--- a/include/linux/sched.h~cgroups-add-an-owner-to-the-mm_struct
+++ a/include/linux/sched.h
@@ -2148,6 +2148,19 @@ static inline void migration_init(void)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_MM_OWNER
+extern void mm_update_next_owner(struct mm_struct *mm);
+extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
+#else
+static inline void mm_update_next_owner(struct mm_struct *mm)
+{
+}
+
+static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
+{
+}
+#endif /* CONFIG_MM_OWNER */
+
 #endif /* __KERNEL__ */
 
 #endif
diff -puN init/Kconfig~cgroups-add-an-owner-to-the-mm_struct init/Kconfig
--- a/init/Kconfig~cgroups-add-an-owner-to-the-mm_struct
+++ a/init/Kconfig
@@ -378,9 +378,13 @@ config RESOURCE_COUNTERS
           infrastructure that works with cgroups
 	depends on CGROUPS
 
+config MM_OWNER
+	bool
+
 config CGROUP_MEM_RES_CTLR
 	bool "Memory Resource Controller for Control Groups"
 	depends on CGROUPS && RESOURCE_COUNTERS
+	select MM_OWNER
 	help
 	  Provides a memory resource controller that manages both page cache and
 	  RSS memory.
@@ -393,6 +397,9 @@ config CGROUP_MEM_RES_CTLR
 	  Only enable when you're ok with these trade offs and really
 	  sure you need the memory resource controller.
 
+	  This config option also selects MM_OWNER config option, which
+	  could in turn add some fork/exit overhead.
+
 config SYSFS_DEPRECATED
 	bool
 
diff -puN init/main.c~cgroups-add-an-owner-to-the-mm_struct init/main.c
--- a/init/main.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/init/main.c
@@ -559,6 +559,7 @@ asmlinkage void __init start_kernel(void
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 	setup_arch(&command_line);
+	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
 	unwind_setup();
 	setup_per_cpu_areas();
diff -puN kernel/cgroup.c~cgroups-add-an-owner-to-the-mm_struct kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/kernel/cgroup.c
@@ -119,6 +119,7 @@ static int root_count;
  * be called.
  */
 static int need_forkexit_callback;
+static int need_mm_owner_callback __read_mostly;
 
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
@@ -2498,6 +2499,7 @@ static void __init cgroup_init_subsys(st
 	init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
 
 	need_forkexit_callback |= ss->fork || ss->exit;
+	need_mm_owner_callback |= !!ss->mm_owner_changed;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -2748,6 +2750,34 @@ void cgroup_fork_callbacks(struct task_s
 	}
 }
 
+#ifdef CONFIG_MM_OWNER
+/**
+ * cgroup_mm_owner_callbacks - run callbacks when the mm->owner changes
+ * @p: the new owner
+ *
+ * Called on every change to mm->owner. mm_init_owner() does not
+ * invoke this routine, since it assigns the mm->owner the first time
+ * and does not change it.
+ */
+void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
+{
+	struct cgroup *oldcgrp, *newcgrp;
+
+	if (need_mm_owner_callback) {
+		int i;
+		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			oldcgrp = task_cgroup(old, ss->subsys_id);
+			newcgrp = task_cgroup(new, ss->subsys_id);
+			if (oldcgrp == newcgrp)
+				continue;
+			if (ss->mm_owner_changed)
+				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
+		}
+	}
+}
+#endif /* CONFIG_MM_OWNER */
+
 /**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
diff -puN kernel/exit.c~cgroups-add-an-owner-to-the-mm_struct kernel/exit.c
--- a/kernel/exit.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/kernel/exit.c
@@ -557,6 +557,88 @@ void exit_fs(struct task_struct *tsk)
 
 EXPORT_SYMBOL_GPL(exit_fs);
 
+#ifdef CONFIG_MM_OWNER
+/*
+ * Task p is exiting and it owned mm, lets find a new owner for it
+ */
+static inline int
+mm_need_new_owner(struct mm_struct *mm, struct task_struct *p)
+{
+	/*
+	 * If there are other users of the mm and the owner (us) is exiting
+	 * we need to find a new owner to take on the responsibility.
+	 */
+	if (!mm)
+		return 0;
+	if (atomic_read(&mm->mm_users) <= 1)
+		return 0;
+	if (mm->owner != p)
+		return 0;
+	return 1;
+}
+
+void mm_update_next_owner(struct mm_struct *mm)
+{
+	struct task_struct *c, *g, *p = current;
+
+retry:
+	if (!mm_need_new_owner(mm, p))
+		return;
+
+	read_lock(&tasklist_lock);
+	/*
+	 * Search in the children
+	 */
+	list_for_each_entry(c, &p->children, sibling) {
+		if (c->mm == mm)
+			goto assign_new_owner;
+	}
+
+	/*
+	 * Search in the siblings
+	 */
+	list_for_each_entry(c, &p->parent->children, sibling) {
+		if (c->mm == mm)
+			goto assign_new_owner;
+	}
+
+	/*
+	 * Search through everything else. We should not get
+	 * here often
+	 */
+	do_each_thread(g, c) {
+		if (c->mm == mm)
+			goto assign_new_owner;
+	} while_each_thread(g, c);
+
+	read_unlock(&tasklist_lock);
+	return;
+
+assign_new_owner:
+	BUG_ON(c == p);
+	get_task_struct(c);
+	/*
+	 * The task_lock protects c->mm from changing.
+	 * We always want mm->owner->mm == mm
+	 */
+	task_lock(c);
+	/*
+	 * Delay read_unlock() till we have the task_lock()
+	 * to ensure that c does not slip away underneath us
+	 */
+	read_unlock(&tasklist_lock);
+	if (c->mm != mm) {
+		task_unlock(c);
+		put_task_struct(c);
+		goto retry;
+	}
+	cgroup_mm_owner_callbacks(mm->owner, c);
+	mm->owner = c;
+	task_unlock(c);
+	put_task_struct(c);
+}
+#endif /* CONFIG_MM_OWNER */
+
 /*
  * Turn us into a lazy TLB process if we
  * aren't already..
@@ -596,6 +678,7 @@ static void exit_mm(struct task_struct *
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
 	task_unlock(tsk);
+	mm_update_next_owner(mm);
 	mmput(mm);
 }
 
diff -puN kernel/fork.c~cgroups-add-an-owner-to-the-mm_struct kernel/fork.c
--- a/kernel/fork.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/kernel/fork.c
@@ -381,14 +381,13 @@ static struct mm_struct * mm_init(struct
 	mm->ioctx_list = NULL;
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
-	mm_init_cgroup(mm, p);
+	mm_init_owner(mm, p);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
 		return mm;
 	}
 
-	mm_free_cgroup(mm);
 	free_mm(mm);
 	return NULL;
 }
@@ -438,7 +437,6 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
-		mm_free_cgroup(mm);
 		mmdrop(mm);
 	}
 }
@@ -982,6 +980,13 @@ static void rt_mutex_init_task(struct ta
 #endif
 }
 
+#ifdef CONFIG_MM_OWNER
+void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
+{
+	mm->owner = p;
+}
+#endif /* CONFIG_MM_OWNER */
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
diff -puN mm/memcontrol.c~cgroups-add-an-owner-to-the-mm_struct mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-add-an-owner-to-the-mm_struct
+++ a/mm/memcontrol.c
@@ -236,26 +236,12 @@ static struct mem_cgroup *mem_cgroup_fro
 				css);
 }
 
-static struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
+struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
 }
 
-void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p)
-{
-	struct mem_cgroup *mem;
-
-	mem = mem_cgroup_from_task(p);
-	css_get(&mem->css);
-	mm->mem_cgroup = mem;
-}
-
-void mm_free_cgroup(struct mm_struct *mm)
-{
-	css_put(&mm->mem_cgroup->css);
-}
-
 static inline int page_cgroup_locked(struct page *page)
 {
 	return bit_spin_is_locked(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
@@ -476,6 +462,7 @@ unsigned long mem_cgroup_isolate_pages(u
 	int zid = zone_idx(z);
 	struct mem_cgroup_per_zone *mz;
 
+	BUG_ON(!mem_cont);
 	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
 	if (active)
 		src = &mz->active_list;
@@ -574,7 +561,7 @@ retry:
 		mm = &init_mm;
 
 	rcu_read_lock();
-	mem = rcu_dereference(mm->mem_cgroup);
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	/*
 	 * For every charge from the cgroup, increment reference count
 	 */
@@ -985,10 +972,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	struct mem_cgroup *mem;
 	int node;
 
-	if (unlikely((cont->parent) == NULL)) {
+	if (unlikely((cont->parent) == NULL))
 		mem = &init_mem_cgroup;
-		init_mm.mem_cgroup = mem;
-	} else
+	else
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
 	if (mem == NULL)
@@ -1067,10 +1053,6 @@ static void mem_cgroup_move_task(struct 
 	if (!thread_group_leader(p))
 		goto out;
 
-	css_get(&mem->css);
-	rcu_assign_pointer(mm->mem_cgroup, mem);
-	css_put(&old_mem->css);
