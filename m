From: akpm@linux-foundation.org
Subject: [merged]
 memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:07:12 -0800
Message-ID: <548d0cf0.VcaUTzNT2OMRYjnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaLNEHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: turn memcg_kmem_skip_account into a bit field
has been removed from the -mm tree.  Its filename was
     memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: turn memcg_kmem_skip_account into a bit field

It isn't supposed to stack, so turn it into a bit-field to save 4 bytes on
the task_struct.

Also, remove the memcg_stop/resume_kmem_account helpers - it is clearer to
set/clear the flag inline.  Regarding the overwhelming comment to the
helpers, which is removed by this patch too, we already have a compact yet
accurate explanation in memcg_schedule_cache_create, no need in yet
another one.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++--
 mm/memcontrol.c       |   35 ++---------------------------------
 2 files changed, 7 insertions(+), 35 deletions(-)

diff -puN include/linux/sched.h~memcg-turn-memcg_kmem_skip_account-into-a-bit-field include/linux/sched.h
--- a/include/linux/sched.h~memcg-turn-memcg_kmem_skip_account-into-a-bit-field
+++ a/include/linux/sched.h
@@ -1364,6 +1364,10 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+#ifdef CONFIG_MEMCG_KMEM
+	unsigned memcg_kmem_skip_account:1;
+#endif
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	pid_t pid;
@@ -1679,8 +1683,7 @@ struct task_struct {
 	/* bitmask and counter of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-#ifdef CONFIG_MEMCG /* memcg uses this to do batch job */
-	unsigned int memcg_kmem_skip_account;
+#ifdef CONFIG_MEMCG
 	struct memcg_oom_info {
 		struct mem_cgroup *memcg;
 		gfp_t gfp_mask;
diff -puN mm/memcontrol.c~memcg-turn-memcg_kmem_skip_account-into-a-bit-field mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-turn-memcg_kmem_skip_account-into-a-bit-field
+++ a/mm/memcontrol.c
@@ -2673,37 +2673,6 @@ static void memcg_unregister_cache(struc
 	css_put(&memcg->css);
 }
 
-/*
- * During the creation a new cache, we need to disable our accounting mechanism
- * altogether. This is true even if we are not creating, but rather just
- * enqueing new caches to be created.
- *
- * This is because that process will trigger allocations; some visible, like
- * explicit kmallocs to auxiliary data structures, name strings and internal
- * cache structures; some well concealed, like INIT_WORK() that can allocate
- * objects during debug.
- *
- * If any allocation happens during memcg_kmem_get_cache, we will recurse back
- * to it. This may not be a bounded recursion: since the first cache creation
- * failed to complete (waiting on the allocation), we'll just try to create the
- * cache again, failing at the same point.
- *
- * memcg_kmem_get_cache is prepared to abort after seeing a positive count of
- * memcg_kmem_skip_account. So we enclose anything that might allocate memory
- * inside the following two functions.
- */
-static inline void memcg_stop_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account++;
-}
-
-static inline void memcg_resume_kmem_account(void)
-{
-	VM_BUG_ON(!current->mm);
-	current->memcg_kmem_skip_account--;
-}
