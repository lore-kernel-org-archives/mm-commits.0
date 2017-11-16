From: akpm@linux-foundation.org
Subject: [patch 015/131] mm: oom: show unreclaimable slab info when
 unreclaimable slabs > user memory
Date: Wed, 15 Nov 2017 17:32:07 -0800
Message-ID: <20171116013207.Q7xRhbzka%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.s@alibaba-inc.com

From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: oom: show unreclaimable slab info when unreclaimable slabs > user memory

Kernel may panic when oom happens without killable process sometimes it is
caused by huge unreclaimable slabs used by kernel.

Although kdump could help debug such problem, however, kdump is not
available on all architectures and it might be malfunction sometime.  And,
since kernel already panic it is worthy capturing such information in
dmesg to aid touble shooting.

Print out unreclaimable slab info (used size and total size) which actual
memory usage is not zero (num_objs * size != 0) when unreclaimable slabs
amount is greater than total user memory (LRU pages).

The output looks like:

Unreclaimable slab info:
Name                      Used          Total
rpc_buffers               31KB         31KB
rpc_tasks                  7KB          7KB
ebitmap_node            1964KB       1964KB
avtab_node              5024KB       5024KB
xfs_buf                 1402KB       1402KB
xfs_ili                  134KB        134KB
xfs_efi_item             115KB        115KB
xfs_efd_item             115KB        115KB
xfs_buf_item             134KB        134KB
xfs_log_item_desc        342KB        342KB
xfs_trans               1412KB       1412KB
xfs_ifork                212KB        212KB

[yang.s@alibaba-inc.com: v11]
  Link: http://lkml.kernel.org/r/1507656303-103845-4-git-send-email-yang.s@alibaba-inc.com
Link: http://lkml.kernel.org/r/1507152550-46205-4-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c    |   27 +++++++++++++++++++++++++--
 mm/slab.h        |    8 ++++++++
 mm/slab_common.c |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory
+++ a/mm/oom_kill.c
@@ -44,6 +44,7 @@
 
 #include <asm/tlb.h>
 #include "internal.h"
+#include "slab.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
@@ -161,6 +162,25 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
+/*
+ * Print out unreclaimble slabs info when unreclaimable slabs amount is greater
+ * than all user memory (LRU pages)
+ */
+static bool is_dump_unreclaim_slabs(void)
+{
+	unsigned long nr_lru;
+
+	nr_lru = global_node_page_state(NR_ACTIVE_ANON) +
+		 global_node_page_state(NR_INACTIVE_ANON) +
+		 global_node_page_state(NR_ACTIVE_FILE) +
+		 global_node_page_state(NR_INACTIVE_FILE) +
+		 global_node_page_state(NR_ISOLATED_ANON) +
+		 global_node_page_state(NR_ISOLATED_FILE) +
+		 global_node_page_state(NR_UNEVICTABLE);
+
+	return (global_node_page_state(NR_SLAB_UNRECLAIMABLE) > nr_lru);
+}
+
 /**
  * oom_badness - heuristic function to determine which candidate task to kill
  * @p: task struct of which task we should calculate
@@ -420,10 +440,13 @@ static void dump_header(struct oom_contr
 
 	cpuset_print_current_mems_allowed();
 	dump_stack();
-	if (oc->memcg)
+	if (is_memcg_oom(oc))
 		mem_cgroup_print_oom_info(oc->memcg, p);
-	else
+	else {
 		show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask);
+		if (is_dump_unreclaim_slabs())
+			dump_unreclaimable_slab();
+	}
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc->memcg, oc->nodemask);
 }
diff -puN mm/slab_common.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory mm/slab_common.c
--- a/mm/slab_common.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory
+++ a/mm/slab_common.c
@@ -1280,6 +1280,40 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
+void dump_unreclaimable_slab(void)
+{
+	struct kmem_cache *s, *s2;
+	struct slabinfo sinfo;
+
+	/*
+	 * Here acquiring slab_mutex is risky since we don't prefer to get
+	 * sleep in oom path. But, without mutex hold, it may introduce a
+	 * risk of crash.
+	 * Use mutex_trylock to protect the list traverse, dump nothing
+	 * without acquiring the mutex.
+	 */
+	if (!mutex_trylock(&slab_mutex)) {
+		pr_warn("excessive unreclaimable slab but cannot dump stats\n");
+		return;
+	}
+
+	pr_info("Unreclaimable slab info:\n");
+	pr_info("Name                      Used          Total\n");
+
+	list_for_each_entry_safe(s, s2, &slab_caches, list) {
+		if (!is_root_cache(s) || (s->flags & SLAB_RECLAIM_ACCOUNT))
+			continue;
+
+		get_slabinfo(s, &sinfo);
+
+		if (sinfo.num_objs > 0)
+			pr_info("%-17s %10luKB %10luKB\n", cache_name(s),
+				(sinfo.active_objs * s->size) / 1024,
+				(sinfo.num_objs * s->size) / 1024);
+	}
+	mutex_unlock(&slab_mutex);
+}
+
 #if defined(CONFIG_MEMCG)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
diff -puN mm/slab.h~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory mm/slab.h
--- a/mm/slab.h~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory
+++ a/mm/slab.h
@@ -506,6 +506,14 @@ void *memcg_slab_next(struct seq_file *m
 void memcg_slab_stop(struct seq_file *m, void *p);
 int memcg_slab_show(struct seq_file *m, void *p);
 
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
+void dump_unreclaimable_slab(void);
+#else
+static inline void dump_unreclaimable_slab(void)
+{
+}
+#endif
+
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
_
