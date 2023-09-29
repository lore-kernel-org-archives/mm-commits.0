Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEFCE728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbjI2Smz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjI2Smx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:42:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00967199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:42:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F34FC433C8;
        Fri, 29 Sep 2023 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696012969;
        bh=if+FoIoUWn8w8Z8qi4n9JWNB4tZjITPSie6HyUK/2ps=;
        h=Date:To:From:Subject:From;
        b=TDoeBm8fDhv0Olg07prpNjoxQJg9gTjTqC6qeqxl6AH+YDyVo4raY54X3XDYiZbGx
         HIm0q1xPQJi3HRa3wekRZIJmfX6phVaNu0OKdms4F+ePmD2HZvcAWNP0TlLhjIG9WQ
         Eri/ae6JKPJ4VOxHwo9VaEVFl9CKlw6Fz/IAu520=
Date:   Fri, 29 Sep 2023 11:42:48 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-direct-objcg-pointer-to-task_struct.patch added to mm-unstable branch
Message-Id: <20230929184249.8F34FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: add direct objcg pointer to task_struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-add-direct-objcg-pointer-to-task_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-direct-objcg-pointer-to-task_struct.patch

This patch will later appear in the mm-unstable branch at
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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: add direct objcg pointer to task_struct
Date: Fri, 29 Sep 2023 11:00:52 -0700

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

Link: https://lkml.kernel.org/r/20230929180056.1122002-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++
 include/linux/sched.h      |    4 +
 mm/memcontrol.c            |  111 ++++++++++++++++++++++++++++++++---
 3 files changed, 116 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-add-direct-objcg-pointer-to-task_struct
+++ a/include/linux/memcontrol.h
@@ -544,6 +544,16 @@ static inline bool folio_memcg_kmem(stru
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
+static inline bool current_objcg_needs_update(struct obj_cgroup *objcg)
+{
+	return (struct obj_cgroup *)((unsigned long)objcg & 0x1);
+}
+
+static inline struct obj_cgroup *
+current_objcg_without_update_flag(struct obj_cgroup *objcg)
+{
+	return (struct obj_cgroup *)((unsigned long)objcg & ~0x1);
+}
 
 #else
 static inline bool folio_memcg_kmem(struct folio *folio)
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
@@ -3041,6 +3041,47 @@ static struct obj_cgroup *__get_obj_cgro
 	return objcg;
 }
 
+static struct obj_cgroup *current_objcg_update(struct obj_cgroup *old)
+{
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg = NULL, *tmp = old;
+
+	old = current_objcg_without_update_flag(old);
+	if (old)
+		obj_cgroup_put(old);
+
+	rcu_read_lock();
+	do {
+		/* Atomically drop the update bit, */
+		WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, 0) != tmp);
+
+		/* ...obtain the new objcg pointer */
+		memcg = mem_cgroup_from_task(current);
+		for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+			objcg = rcu_dereference(memcg->objcg);
+			if (objcg && obj_cgroup_tryget(objcg))
+				break;
+			objcg = NULL;
+		}
+
+		/*
+		 * ...and try atomically set up a new objcg pointer. If it
+		 * fails, it means the update flag was set concurrently, so
+		 * the whole procedure should be repeated.
+		 */
+		tmp = 0;
+	} while (!try_cmpxchg(&current->objcg, &tmp, objcg));
+	rcu_read_unlock();
+
+	return objcg;
+}
+
+static inline void current_objcg_set_needs_update(struct task_struct *task)
+{
+	/* atomically set the update bit */
+	set_bit(0, (unsigned long *)&current->objcg);
+}
+
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
 	struct mem_cgroup *memcg;
@@ -3048,19 +3089,26 @@ __always_inline struct obj_cgroup *get_o
 
 	if (in_task()) {
 		memcg = current->active_memcg;
+		if (unlikely(memcg))
+			goto from_memcg;
 
-		/* Memcg to charge can't be determined. */
-		if (likely(!memcg) && (!current->mm || (current->flags & PF_KTHREAD)))
-			return NULL;
+		objcg = READ_ONCE(current->objcg);
+		if (unlikely(current_objcg_needs_update(objcg)))
+			objcg = current_objcg_update(objcg);
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
@@ -6400,6 +6448,7 @@ static void mem_cgroup_move_task(void)
 		mem_cgroup_clear_mc();
 	}
 }
+
 #else	/* !CONFIG_MMU */
 static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 {
@@ -6413,8 +6462,27 @@ static void mem_cgroup_move_task(void)
 }
 #endif
 
+#ifdef CONFIG_MEMCG_KMEM
+static void mem_cgroup_fork(struct task_struct *task)
+{
+	/*
+	 * Set the update flag to cause task->objcg to be initialized lazily
+	 * on the first allocation.
+	 */
+	task->objcg = (struct obj_cgroup *)0x1;
+}
+
+static void mem_cgroup_exit(struct task_struct *task)
+{
+	struct obj_cgroup *objcg = current_objcg_without_update_flag(task->objcg);
+
+	if (objcg)
+		obj_cgroup_put(objcg);
+}
+#endif
+
 #ifdef CONFIG_LRU_GEN
-static void mem_cgroup_attach(struct cgroup_taskset *tset)
+static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 	struct cgroup_subsys_state *css;
@@ -6432,10 +6500,29 @@ static void mem_cgroup_attach(struct cgr
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
+	cgroup_taskset_for_each(task, css, tset)
+		current_objcg_set_needs_update(task);
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
@@ -6845,9 +6932,15 @@ struct cgroup_subsys memory_cgrp_subsys
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

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

