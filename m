From: akpm@linux-foundation.org
Subject: [wrecked] rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch removed from -mm tree
Date: Wed, 19 May 2010 10:16:55 -0400
Message-ID: <201005191718.o4JHILjY024988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab0ESRTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: remove INIT_RCU_HEAD, RCU_HEAD_INIT, RCU_HEAD
has been removed from the -mm tree.  Its filename was
     rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: remove INIT_RCU_HEAD, RCU_HEAD_INIT, RCU_HEAD
From: Alexey Dobriyan <adobriyan@gmail.com>

call_rcu() will unconditionally reinitialize RCU head anyway.  New users
of these macros constantly appear, so remove them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl   |    8 --------
 arch/powerpc/mm/pgtable.c                   |    1 -
 block/cfq-iosched.c                         |    1 -
 block/genhd.c                               |    1 -
 drivers/staging/batman-adv/hard-interface.c |    1 -
 fs/file.c                                   |    3 ---
 fs/fs-writeback.c                           |    1 -
 fs/partitions/check.c                       |    1 -
 include/linux/init_task.h                   |    1 -
 include/linux/rcupdate.h                    |    6 ------
 mm/backing-dev.c                            |    1 -
 mm/slob.c                                   |    1 -
 security/selinux/avc.c                      |    1 -
 security/selinux/netnode.c                  |    2 --
 14 files changed, 29 deletions(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~rcu-remove-init_rcu_head-rcu_head_init-rcu_head Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -1725,14 +1725,6 @@ the amount of locking which needs to be 
          if (++cache_num > MAX_CACHE_SIZE) {
                  struct object *i, *outcast = NULL;
                  list_for_each_entry(i, &amp;cache, list) {
-@@ -85,6 +94,7 @@
-         obj-&gt;popularity = 0;
-         atomic_set(&amp;obj-&gt;refcnt, 1); /* The cache holds a reference */
-         spin_lock_init(&amp;obj-&gt;lock);
-+        INIT_RCU_HEAD(&amp;obj-&gt;rcu);
-
-         spin_lock_irqsave(&amp;cache_lock, flags);
-         __cache_add(obj);
 @@ -104,12 +114,11 @@
  struct object *cache_find(int id)
  {
diff -puN arch/powerpc/mm/pgtable.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/arch/powerpc/mm/pgtable.c
@@ -92,7 +92,6 @@ static void pte_free_rcu_callback(struct
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
diff -puN block/cfq-iosched.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head block/cfq-iosched.c
--- a/block/cfq-iosched.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/block/cfq-iosched.c
@@ -3788,7 +3788,6 @@ static void *cfq_init_queue(struct reque
 	 * second, in order to have larger depth for async operations.
 	 */
 	cfqd->last_delayed_sync = jiffies - HZ;
-	INIT_RCU_HEAD(&cfqd->rcu);
 	return cfqd;
 }
 
diff -puN block/genhd.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head block/genhd.c
--- a/block/genhd.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/block/genhd.c
@@ -988,7 +988,6 @@ int disk_expand_part_tbl(struct gendisk 
 	if (!new_ptbl)
 		return -ENOMEM;
 
-	INIT_RCU_HEAD(&new_ptbl->rcu_head);
 	new_ptbl->len = target;
 
 	for (i = 0; i < len; i++)
diff -puN drivers/staging/batman-adv/hard-interface.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head drivers/staging/batman-adv/hard-interface.c
--- a/drivers/staging/batman-adv/hard-interface.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/drivers/staging/batman-adv/hard-interface.c
@@ -340,7 +340,6 @@ static struct batman_if *hardif_add_inte
 	batman_if->if_num = -1;
 	batman_if->net_dev = net_dev;
 	batman_if->if_status = IF_NOT_IN_USE;
-	INIT_RCU_HEAD(&batman_if->rcu);
 	INIT_LIST_HEAD(&batman_if->list);
 
 	check_known_mac_addr(batman_if->net_dev->dev_addr);
diff -puN fs/file.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head fs/file.c
--- a/fs/file.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(un
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff -puN fs/fs-writeback.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head fs/fs-writeback.c
--- a/fs/fs-writeback.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/fs/fs-writeback.c
@@ -78,7 +78,6 @@ static inline bool bdi_work_on_stack(str
 static inline void bdi_work_init(struct bdi_work *work,
 				 struct wb_writeback_args *args)
 {
-	INIT_RCU_HEAD(&work->rcu_head);
 	work->args = *args;
 	work->state = WS_USED;
 }
diff -puN fs/partitions/check.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head fs/partitions/check.c
--- a/fs/partitions/check.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/fs/partitions/check.c
@@ -456,7 +456,6 @@ struct hd_struct *add_partition(struct g
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
diff -puN include/linux/init_task.h~rcu-remove-init_rcu_head-rcu_head_init-rcu_head include/linux/init_task.h
--- a/include/linux/init_task.h~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/include/linux/init_task.h
@@ -49,7 +49,6 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
-	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
 	.numbers	= { {						\
 		.nr		= 0,					\
diff -puN include/linux/rcupdate.h~rcu-remove-init_rcu_head-rcu_head_init-rcu_head include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/include/linux/rcupdate.h
@@ -77,12 +77,6 @@ extern void rcu_scheduler_starting(void)
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern struct lockdep_map rcu_lock_map;
diff -puN mm/backing-dev.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head mm/backing-dev.c
--- a/mm/backing-dev.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/mm/backing-dev.c
@@ -663,7 +663,6 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
diff -puN mm/slob.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head mm/slob.c
--- a/mm/slob.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/mm/slob.c
@@ -647,7 +647,6 @@ void kmem_cache_free(struct kmem_cache *
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
diff -puN security/selinux/avc.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head security/selinux/avc.c
--- a/security/selinux/avc.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/security/selinux/avc.c
@@ -288,7 +288,6 @@ static struct avc_node *avc_alloc_node(v
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
diff -puN security/selinux/netnode.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head security/selinux/netnode.c
--- a/security/selinux/netnode.c~rcu-remove-init_rcu_head-rcu_head_init-rcu_head
+++ a/security/selinux/netnode.c
@@ -183,8 +183,6 @@ static void sel_netnode_insert(struct se
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
