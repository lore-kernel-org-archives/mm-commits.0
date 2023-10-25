Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D683C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjJYXtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjJYXsa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D2A196
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3D4C433C9;
        Wed, 25 Oct 2023 23:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277707;
        bh=7eFI6u6mb3ehF9cQY43wH2TteQIPEjCJgrsTt8DO6QQ=;
        h=Date:To:From:Subject:From;
        b=RGTihsaAD4sN86sfX/JwdfpUyYv+n0Jl4cscWB0W5Vz+DXQ+HgZnJ6UMMirAMIjeZ
         MM9Afs25NBX3RgVyd7zWh6quYVXL/4q4EvJlqLfLk/287d0sfxy1QAgBDUWjyGZ70F
         l4jd6tKg5uymQ6KDGdwpB3ZGLnnLKvWzf5vJzKBc=
Date:   Wed, 25 Oct 2023 16:48:26 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmem-add-direct-objcg-pointer-to-task_struct.patch removed from -mm tree
Message-Id: <20231025234827.7E3D4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmem: add direct objcg pointer to task_struct
has been removed from the -mm tree.  Its filename was
     mm-kmem-add-direct-objcg-pointer-to-task_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: add direct objcg pointer to task_struct
Date: Thu, 19 Oct 2023 15:53:42 -0700

To charge a freshly allocated kernel object to a memory cgroup, the kernel
needs to obtain an objcg pointer.  Currently it does it indirectly by
obtaining the memcg pointer first and then calling to
__get_obj_cgroup_from_memcg().

Usually tasks spend their entire life belonging to the same object cgroup.
So it makes sense to save the objcg pointer on task_struct directly, so
it can be obtained faster.  It requires some work on fork, exit and cgroup
migrate paths, but these paths are way colder.

To avoid any costly synchronization the following rules are applied:
1) A task sets it's objcg pointer itself.

2) If a task is being migrated to another cgroup, the least
   significant bit of the objcg pointer is set atomically.

3) On the allocation path the objcg pointer is obtained locklessly
   using the READ_ONCE() macro and the least significant bit is
   checked. If it's set, the following procedure is used to update
   it locklessly:
       - task->objcg is zeroed using cmpxcg
       - new objcg pointer is obtained
       - task->objcg is updated using try_cmpxchg
       - operation is repeated if try_cmpxcg fails
   It guarantees that no updates will be lost if task migration
   is racing against objcg pointer update. It also allows to keep
   both read and write paths fully lockless.

Because the task is keeping a reference to the objcg, it can't go away
while the task is alive.

This commit doesn't change the way the remote memcg charging works.

Link: https://lkml.kernel.org/r/20231019225346.1822282-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 +
 mm/memcontrol.c       |  139 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 134 insertions(+), 9 deletions(-)

--- a/include/linux/sched.h~mm-kmem-add-direct-objcg-pointer-to-task_struct
+++ a/include/linux/sched.h
@@ -1443,6 +1443,10 @@ struct task_struct {
 	struct mem_cgroup		*active_memcg;
 #endif
 
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup		*objcg;
+#endif
+
 #ifdef CONFIG_BLK_CGROUP
 	struct gendisk			*throttle_disk;
 #endif
--- a/mm/memcontrol.c~mm-kmem-add-direct-objcg-pointer-to-task_struct
+++ a/mm/memcontrol.c
@@ -249,6 +249,9 @@ struct mem_cgroup *vmpressure_to_memcg(s
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
+#define CURRENT_OBJCG_UPDATE_BIT 0
+#define CURRENT_OBJCG_UPDATE_FLAG (1UL << CURRENT_OBJCG_UPDATE_BIT)
+
 #ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
 
@@ -3083,6 +3086,58 @@ static struct obj_cgroup *__get_obj_cgro
 	return objcg;
 }
 
+static struct obj_cgroup *current_objcg_update(void)
+{
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *old, *objcg = NULL;
+
+	do {
+		/* Atomically drop the update bit. */
+		old = xchg(&current->objcg, NULL);
+		if (old) {
+			old = (struct obj_cgroup *)
+				((unsigned long)old & ~CURRENT_OBJCG_UPDATE_FLAG);
+			if (old)
+				obj_cgroup_put(old);
+
+			old = NULL;
+		}
+
+		/* If new objcg is NULL, no reason for the second atomic update. */
+		if (!current->mm || (current->flags & PF_KTHREAD))
+			return NULL;
+
+		/*
+		 * Release the objcg pointer from the previous iteration,
+		 * if try_cmpxcg() below fails.
+		 */
+		if (unlikely(objcg)) {
+			obj_cgroup_put(objcg);
+			objcg = NULL;
+		}
+
+		/*
+		 * Obtain the new objcg pointer. The current task can be
+		 * asynchronously moved to another memcg and the previous
+		 * memcg can be offlined. So let's get the memcg pointer
+		 * and try get a reference to objcg under a rcu read lock.
+		 */
+
+		rcu_read_lock();
+		memcg = mem_cgroup_from_task(current);
+		objcg = __get_obj_cgroup_from_memcg(memcg);
+		rcu_read_unlock();
+
+		/*
+		 * Try set up a new objcg pointer atomically. If it
+		 * fails, it means the update flag was set concurrently, so
+		 * the whole procedure should be repeated.
+		 */
+	} while (!try_cmpxchg(&current->objcg, &old, objcg));
+
+	return objcg;
+}
+
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
 	struct mem_cgroup *memcg;
@@ -3090,19 +3145,26 @@ __always_inline struct obj_cgroup *get_o
 
 	if (in_task()) {
 		memcg = current->active_memcg;
+		if (unlikely(memcg))
+			goto from_memcg;
 
-		/* Memcg to charge can't be determined. */
-		if (likely(!memcg) && (!current->mm || (current->flags & PF_KTHREAD)))
-			return NULL;
+		objcg = READ_ONCE(current->objcg);
+		if (unlikely((unsigned long)objcg & CURRENT_OBJCG_UPDATE_FLAG))
+			objcg = current_objcg_update();
+
+		if (objcg) {
+			obj_cgroup_get(objcg);
+			return objcg;
+		}
 	} else {
 		memcg = this_cpu_read(int_active_memcg);
-		if (likely(!memcg))
-			return NULL;
+		if (unlikely(memcg))
+			goto from_memcg;
 	}
+	return NULL;
 
+from_memcg:
 	rcu_read_lock();
-	if (!memcg)
-		memcg = mem_cgroup_from_task(current);
 	objcg = __get_obj_cgroup_from_memcg(memcg);
 	rcu_read_unlock();
 	return objcg;
@@ -6440,6 +6502,7 @@ static void mem_cgroup_move_task(void)
 		mem_cgroup_clear_mc();
 	}
 }
+
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 {
@@ -6453,8 +6516,39 @@ static void mem_cgroup_move_task(void)
 }
 #endif
 
+#ifdef CONFIG_MEMCG_KMEM
+static void mem_cgroup_fork(struct task_struct *task)
+{
+	/*
+	 * Set the update flag to cause task->objcg to be initialized lazily
+	 * on the first allocation. It can be done without any synchronization
+	 * because it's always performed on the current task, so does
+	 * current_objcg_update().
+	 */
+	task->objcg = (struct obj_cgroup *)CURRENT_OBJCG_UPDATE_FLAG;
+}
+
+static void mem_cgroup_exit(struct task_struct *task)
+{
+	struct obj_cgroup *objcg = task->objcg;
+
+	objcg = (struct obj_cgroup *)
+		((unsigned long)objcg & ~CURRENT_OBJCG_UPDATE_FLAG);
+	if (objcg)
+		obj_cgroup_put(objcg);
+
+	/*
+	 * Some kernel allocations can happen after this point,
+	 * but let's ignore them. It can be done without any synchronization
+	 * because it's always performed on the current task, so does
+	 * current_objcg_update().
+	 */
+	task->objcg = NULL;
+}
+#endif
+
 #ifdef CONFIG_LRU_GEN
-static void mem_cgroup_attach(struct cgroup_taskset *tset)
+static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 	struct cgroup_subsys_state *css;
@@ -6472,10 +6566,31 @@ static void mem_cgroup_attach(struct cgr
 	task_unlock(task);
 }
 #else
+static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset) {}
+#endif /* CONFIG_LRU_GEN */
+
+#ifdef CONFIG_MEMCG_KMEM
+static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
+{
+	struct task_struct *task;
+	struct cgroup_subsys_state *css;
+
+	cgroup_taskset_for_each(task, css, tset) {
+		/* atomically set the update bit */
+		set_bit(CURRENT_OBJCG_UPDATE_BIT, (unsigned long *)&task->objcg);
+	}
+}
+#else
+static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset) {}
+#endif /* CONFIG_MEMCG_KMEM */
+
+#if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
 static void mem_cgroup_attach(struct cgroup_taskset *tset)
 {
+	mem_cgroup_lru_gen_attach(tset);
+	mem_cgroup_kmem_attach(tset);
 }
-#endif /* CONFIG_LRU_GEN */
+#endif
 
 static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
 {
@@ -6885,9 +7000,15 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_reset = mem_cgroup_css_reset,
 	.css_rstat_flush = mem_cgroup_css_rstat_flush,
 	.can_attach = mem_cgroup_can_attach,
+#if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
 	.attach = mem_cgroup_attach,
+#endif
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.post_attach = mem_cgroup_move_task,
+#ifdef CONFIG_MEMCG_KMEM
+	.fork = mem_cgroup_fork,
+	.exit = mem_cgroup_exit,
+#endif
 	.dfl_cftypes = memory_files,
 	.legacy_cftypes = mem_cgroup_legacy_files,
 	.early_init = 0,
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


