Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33CDDF58
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141606; cv=none; b=oFkDbiXyQ+1Zp2t5zhcHS4Q76PVvXBnCA3fi83XoJBC6HuLABT6NdAVxELckMEbVVgdOmFGJ+Hp0Q2QCIctYx/vbCq8MZQwbnKXhHBdMjWPqLoCff1sF6bHzW63evoCK4bp6BCEBtIJFJIMgnrRPa/jsMYagrC7HiHF0JAhDmhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141606; c=relaxed/simple;
	bh=Zy50WZp6WlgTb0xM+72QU1elVuwTnXtk0oRGUR3Nm/A=;
	h=Date:To:From:Subject:Message-Id; b=r6sNWRVH//Q7cOVXbytSIYv5M2g96R43jZL5eKpjjAQBn3PJemhn6gqp9OzmkbCUmcazQ4/E+rGeZctol3X8E7uMkC0cS3b0BiqEdjoxNQDGUlYIm63iTiZoI75h8mKGuTVOztQ1oUvEHScEdXef//0X2QvJDD2horQg80WpN6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HfcXjgwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HfcXjgwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E93C3277B;
	Fri,  5 Jul 2024 01:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141606;
	bh=Zy50WZp6WlgTb0xM+72QU1elVuwTnXtk0oRGUR3Nm/A=;
	h=Date:To:From:Subject:From;
	b=HfcXjgwu1Bindo64APvn0XzmsfnLFLeeeyBYs2zf44qPoIhpx8AV3XbM+b3qBf1oH
	 mtpWuwigqpE9qihrhQi88AVDFbrfN+1RjRtZvz4nkYxQ60Aa+DrkT+HBZ7nGIU+Hyp
	 PMKS1nu72VW/JibkzG23IMxMq4X5Y1CXisZBzJQE=
Date: Thu, 04 Jul 2024 18:06:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch removed from -mm tree
Message-Id: <20240705010646.94E93C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: move cgroup v1 oom handling code into memcontrol-v1.c
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: move cgroup v1 oom handling code into memcontrol-v1.c
Date: Mon, 24 Jun 2024 17:59:00 -0700

Cgroup v1 supports a complicated OOM handling in userspace mechanism,
which is not supported by cgroup v2.  Let's move the corresponding code
into memcontrol-v1.c.

Aside from mechanical code movement this patch introduces two new
functions: memcg1_oom_prepare() and memcg1_oom_finish().  Those are
implementing cgroup v1-specific parts of the common memcg OOM handling
path.

Link: https://lkml.kernel.org/r/20240625005906.106920-9-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |  229 ++++++++++++++++++++++++++++++++++++++++++-
 mm/memcontrol-v1.h |    3 
 mm/memcontrol.c    |  216 ----------------------------------------
 3 files changed, 231 insertions(+), 217 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c
+++ a/mm/memcontrol.c
@@ -1615,130 +1615,6 @@ unlock:
 	return ret;
 }
 
-#ifdef CONFIG_LOCKDEP
-static struct lockdep_map memcg_oom_lock_dep_map = {
-	.name = "memcg_oom_lock",
-};
-#endif
-
-DEFINE_SPINLOCK(memcg_oom_lock);
-
-/*
- * Check OOM-Killer is already running under our hierarchy.
- * If someone is running, return false.
- */
-static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *iter, *failed = NULL;
-
-	spin_lock(&memcg_oom_lock);
-
-	for_each_mem_cgroup_tree(iter, memcg) {
-		if (iter->oom_lock) {
-			/*
-			 * this subtree of our hierarchy is already locked
-			 * so we cannot give a lock.
-			 */
-			failed = iter;
-			mem_cgroup_iter_break(memcg, iter);
-			break;
-		} else
-			iter->oom_lock = true;
-	}
-
-	if (failed) {
-		/*
-		 * OK, we failed to lock the whole subtree so we have
-		 * to clean up what we set up to the failing subtree
-		 */
-		for_each_mem_cgroup_tree(iter, memcg) {
-			if (iter == failed) {
-				mem_cgroup_iter_break(memcg, iter);
-				break;
-			}
-			iter->oom_lock = false;
-		}
-	} else
-		mutex_acquire(&memcg_oom_lock_dep_map, 0, 1, _RET_IP_);
-
-	spin_unlock(&memcg_oom_lock);
-
-	return !failed;
-}
-
-static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *iter;
-
-	spin_lock(&memcg_oom_lock);
-	mutex_release(&memcg_oom_lock_dep_map, _RET_IP_);
-	for_each_mem_cgroup_tree(iter, memcg)
-		iter->oom_lock = false;
-	spin_unlock(&memcg_oom_lock);
-}
-
-static void mem_cgroup_mark_under_oom(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *iter;
-
-	spin_lock(&memcg_oom_lock);
-	for_each_mem_cgroup_tree(iter, memcg)
-		iter->under_oom++;
-	spin_unlock(&memcg_oom_lock);
-}
-
-static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *iter;
-
-	/*
-	 * Be careful about under_oom underflows because a child memcg
-	 * could have been added after mem_cgroup_mark_under_oom.
-	 */
-	spin_lock(&memcg_oom_lock);
-	for_each_mem_cgroup_tree(iter, memcg)
-		if (iter->under_oom > 0)
-			iter->under_oom--;
-	spin_unlock(&memcg_oom_lock);
-}
-
-static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
-
-struct oom_wait_info {
-	struct mem_cgroup *memcg;
-	wait_queue_entry_t	wait;
-};
-
-static int memcg_oom_wake_function(wait_queue_entry_t *wait,
-	unsigned mode, int sync, void *arg)
-{
-	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg;
-	struct mem_cgroup *oom_wait_memcg;
-	struct oom_wait_info *oom_wait_info;
-
-	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
-	oom_wait_memcg = oom_wait_info->memcg;
-
-	if (!mem_cgroup_is_descendant(wake_memcg, oom_wait_memcg) &&
-	    !mem_cgroup_is_descendant(oom_wait_memcg, wake_memcg))
-		return 0;
-	return autoremove_wake_function(wait, mode, sync, arg);
-}
-
-void memcg_oom_recover(struct mem_cgroup *memcg)
-{
-	/*
-	 * For the following lockless ->under_oom test, the only required
-	 * guarantee is that it must see the state asserted by an OOM when
-	 * this function is called as a result of userland actions
-	 * triggered by the notification of the OOM.  This is trivially
-	 * achieved by invoking mem_cgroup_mark_under_oom() before
-	 * triggering notification.
-	 */
-	if (memcg && memcg->under_oom)
-		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
-}
-
 /*
  * Returns true if successfully killed one or more processes. Though in some
  * corner cases it can return true even without killing any process.
@@ -1752,105 +1628,17 @@ static bool mem_cgroup_oom(struct mem_cg
 
 	memcg_memory_event(memcg, MEMCG_OOM);
 
-	/*
-	 * We are in the middle of the charge context here, so we
-	 * don't want to block when potentially sitting on a callstack
-	 * that holds all kinds of filesystem and mm locks.
-	 *
-	 * cgroup1 allows disabling the OOM killer and waiting for outside
-	 * handling until the charge can succeed; remember the context and put
-	 * the task to sleep at the end of the page fault when all locks are
-	 * released.
-	 *
-	 * On the other hand, in-kernel OOM killer allows for an async victim
-	 * memory reclaim (oom_reaper) and that means that we are not solely
-	 * relying on the oom victim to make a forward progress and we can
-	 * invoke the oom killer here.
-	 *
-	 * Please note that mem_cgroup_out_of_memory might fail to find a
-	 * victim and then we have to bail out from the charge path.
-	 */
-	if (READ_ONCE(memcg->oom_kill_disable)) {
-		if (current->in_user_fault) {
-			css_get(&memcg->css);
-			current->memcg_in_oom = memcg;
-		}
+	if (!memcg1_oom_prepare(memcg, &locked))
 		return false;
-	}
-
-	mem_cgroup_mark_under_oom(memcg);
-
-	locked = mem_cgroup_oom_trylock(memcg);
 
-	if (locked)
-		mem_cgroup_oom_notify(memcg);
-
-	mem_cgroup_unmark_under_oom(memcg);
 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
 
-	if (locked)
-		mem_cgroup_oom_unlock(memcg);
+	memcg1_oom_finish(memcg, locked);
 
 	return ret;
 }
 
 /**
- * mem_cgroup_oom_synchronize - complete memcg OOM handling
- * @handle: actually kill/wait or just clean up the OOM state
- *
- * This has to be called at the end of a page fault if the memcg OOM
- * handler was enabled.
- *
- * Memcg supports userspace OOM handling where failed allocations must
- * sleep on a waitqueue until the userspace task resolves the
- * situation.  Sleeping directly in the charge context with all kinds
- * of locks held is not a good idea, instead we remember an OOM state
- * in the task and mem_cgroup_oom_synchronize() has to be called at
- * the end of the page fault to complete the OOM handling.
- *
- * Returns %true if an ongoing memcg OOM situation was detected and
- * completed, %false otherwise.
- */
-bool mem_cgroup_oom_synchronize(bool handle)
-{
-	struct mem_cgroup *memcg = current->memcg_in_oom;
-	struct oom_wait_info owait;
-	bool locked;
-
-	/* OOM is global, do not handle */
-	if (!memcg)
-		return false;
-
-	if (!handle)
-		goto cleanup;
-
-	owait.memcg = memcg;
-	owait.wait.flags = 0;
-	owait.wait.func = memcg_oom_wake_function;
-	owait.wait.private = current;
-	INIT_LIST_HEAD(&owait.wait.entry);
-
-	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
-	mem_cgroup_mark_under_oom(memcg);
-
-	locked = mem_cgroup_oom_trylock(memcg);
-
-	if (locked)
-		mem_cgroup_oom_notify(memcg);
-
-	schedule();
-	mem_cgroup_unmark_under_oom(memcg);
-	finish_wait(&memcg_oom_waitq, &owait.wait);
-
-	if (locked)
-		mem_cgroup_oom_unlock(memcg);
-cleanup:
-	current->memcg_in_oom = NULL;
-	css_put(&memcg->css);
-	return true;
-}
-
-/**
  * mem_cgroup_get_oom_group - get a memory cgroup to clean up after OOM
  * @victim: task to be killed by the OOM killer
  * @oom_domain: memcg in case of memcg OOM, NULL in case of system-wide OOM
--- a/mm/memcontrol-v1.c~mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c
+++ a/mm/memcontrol-v1.c
@@ -110,7 +110,13 @@ struct mem_cgroup_event {
 	struct work_struct remove;
 };
 
-extern spinlock_t memcg_oom_lock;
+#ifdef CONFIG_LOCKDEP
+static struct lockdep_map memcg_oom_lock_dep_map = {
+	.name = "memcg_oom_lock",
+};
+#endif
+
+DEFINE_SPINLOCK(memcg_oom_lock);
 
 static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 					 struct mem_cgroup_tree_per_node *mctz,
@@ -1469,7 +1475,7 @@ static int mem_cgroup_oom_notify_cb(stru
 	return 0;
 }
 
-void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
+static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter;
 
@@ -1959,6 +1965,225 @@ void memcg1_css_offline(struct mem_cgrou
 	spin_unlock_irq(&memcg->event_list_lock);
 }
 
+/*
+ * Check OOM-Killer is already running under our hierarchy.
+ * If someone is running, return false.
+ */
+static bool mem_cgroup_oom_trylock(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter, *failed = NULL;
+
+	spin_lock(&memcg_oom_lock);
+
+	for_each_mem_cgroup_tree(iter, memcg) {
+		if (iter->oom_lock) {
+			/*
+			 * this subtree of our hierarchy is already locked
+			 * so we cannot give a lock.
+			 */
+			failed = iter;
+			mem_cgroup_iter_break(memcg, iter);
+			break;
+		} else
+			iter->oom_lock = true;
+	}
+
+	if (failed) {
+		/*
+		 * OK, we failed to lock the whole subtree so we have
+		 * to clean up what we set up to the failing subtree
+		 */
+		for_each_mem_cgroup_tree(iter, memcg) {
+			if (iter == failed) {
+				mem_cgroup_iter_break(memcg, iter);
+				break;
+			}
+			iter->oom_lock = false;
+		}
+	} else
+		mutex_acquire(&memcg_oom_lock_dep_map, 0, 1, _RET_IP_);
+
+	spin_unlock(&memcg_oom_lock);
+
+	return !failed;
+}
+
+static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	spin_lock(&memcg_oom_lock);
+	mutex_release(&memcg_oom_lock_dep_map, _RET_IP_);
+	for_each_mem_cgroup_tree(iter, memcg)
+		iter->oom_lock = false;
+	spin_unlock(&memcg_oom_lock);
+}
+
+static void mem_cgroup_mark_under_oom(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	spin_lock(&memcg_oom_lock);
+	for_each_mem_cgroup_tree(iter, memcg)
+		iter->under_oom++;
+	spin_unlock(&memcg_oom_lock);
+}
+
+static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	/*
+	 * Be careful about under_oom underflows because a child memcg
+	 * could have been added after mem_cgroup_mark_under_oom.
+	 */
+	spin_lock(&memcg_oom_lock);
+	for_each_mem_cgroup_tree(iter, memcg)
+		if (iter->under_oom > 0)
+			iter->under_oom--;
+	spin_unlock(&memcg_oom_lock);
+}
+
+static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
+
+struct oom_wait_info {
+	struct mem_cgroup *memcg;
+	wait_queue_entry_t	wait;
+};
+
+static int memcg_oom_wake_function(wait_queue_entry_t *wait,
+	unsigned mode, int sync, void *arg)
+{
+	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg;
+	struct mem_cgroup *oom_wait_memcg;
+	struct oom_wait_info *oom_wait_info;
+
+	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
+	oom_wait_memcg = oom_wait_info->memcg;
+
+	if (!mem_cgroup_is_descendant(wake_memcg, oom_wait_memcg) &&
+	    !mem_cgroup_is_descendant(oom_wait_memcg, wake_memcg))
+		return 0;
+	return autoremove_wake_function(wait, mode, sync, arg);
+}
+
+void memcg_oom_recover(struct mem_cgroup *memcg)
+{
+	/*
+	 * For the following lockless ->under_oom test, the only required
+	 * guarantee is that it must see the state asserted by an OOM when
+	 * this function is called as a result of userland actions
+	 * triggered by the notification of the OOM.  This is trivially
+	 * achieved by invoking mem_cgroup_mark_under_oom() before
+	 * triggering notification.
+	 */
+	if (memcg && memcg->under_oom)
+		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
+}
+
+/**
+ * mem_cgroup_oom_synchronize - complete memcg OOM handling
+ * @handle: actually kill/wait or just clean up the OOM state
+ *
+ * This has to be called at the end of a page fault if the memcg OOM
+ * handler was enabled.
+ *
+ * Memcg supports userspace OOM handling where failed allocations must
+ * sleep on a waitqueue until the userspace task resolves the
+ * situation.  Sleeping directly in the charge context with all kinds
+ * of locks held is not a good idea, instead we remember an OOM state
+ * in the task and mem_cgroup_oom_synchronize() has to be called at
+ * the end of the page fault to complete the OOM handling.
+ *
+ * Returns %true if an ongoing memcg OOM situation was detected and
+ * completed, %false otherwise.
+ */
+bool mem_cgroup_oom_synchronize(bool handle)
+{
+	struct mem_cgroup *memcg = current->memcg_in_oom;
+	struct oom_wait_info owait;
+	bool locked;
+
+	/* OOM is global, do not handle */
+	if (!memcg)
+		return false;
+
+	if (!handle)
+		goto cleanup;
+
+	owait.memcg = memcg;
+	owait.wait.flags = 0;
+	owait.wait.func = memcg_oom_wake_function;
+	owait.wait.private = current;
+	INIT_LIST_HEAD(&owait.wait.entry);
+
+	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
+	mem_cgroup_mark_under_oom(memcg);
+
+	locked = mem_cgroup_oom_trylock(memcg);
+
+	if (locked)
+		mem_cgroup_oom_notify(memcg);
+
+	schedule();
+	mem_cgroup_unmark_under_oom(memcg);
+	finish_wait(&memcg_oom_waitq, &owait.wait);
+
+	if (locked)
+		mem_cgroup_oom_unlock(memcg);
+cleanup:
+	current->memcg_in_oom = NULL;
+	css_put(&memcg->css);
+	return true;
+}
+
+
+bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	/*
+	 * We are in the middle of the charge context here, so we
+	 * don't want to block when potentially sitting on a callstack
+	 * that holds all kinds of filesystem and mm locks.
+	 *
+	 * cgroup1 allows disabling the OOM killer and waiting for outside
+	 * handling until the charge can succeed; remember the context and put
+	 * the task to sleep at the end of the page fault when all locks are
+	 * released.
+	 *
+	 * On the other hand, in-kernel OOM killer allows for an async victim
+	 * memory reclaim (oom_reaper) and that means that we are not solely
+	 * relying on the oom victim to make a forward progress and we can
+	 * invoke the oom killer here.
+	 *
+	 * Please note that mem_cgroup_out_of_memory might fail to find a
+	 * victim and then we have to bail out from the charge path.
+	 */
+	if (READ_ONCE(memcg->oom_kill_disable)) {
+		if (current->in_user_fault) {
+			css_get(&memcg->css);
+			current->memcg_in_oom = memcg;
+		}
+		return false;
+	}
+
+	mem_cgroup_mark_under_oom(memcg);
+
+	*locked = mem_cgroup_oom_trylock(memcg);
+
+	if (*locked)
+		mem_cgroup_oom_notify(memcg);
+
+	mem_cgroup_unmark_under_oom(memcg);
+
+	return true;
+}
+
+void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked)
+{
+	if (locked)
+		mem_cgroup_oom_unlock(memcg);
+}
+
 static int __init memcg1_init(void)
 {
 	int node;
--- a/mm/memcontrol-v1.h~mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c
+++ a/mm/memcontrol-v1.h
@@ -87,9 +87,10 @@ enum res_type {
 bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 				enum mem_cgroup_events_target target);
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
 ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off);
 
+bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked);
+void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
 
 #endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

