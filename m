Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C784AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B064761C88
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhGFTLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B29761C85;
        Tue,  6 Jul 2021 19:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598555;
        bh=8ao/WV5cjxZaG88epxqGXYas/wsVyTku++Q0M5IAkwE=;
        h=Date:From:To:Subject:From;
        b=L91/5aavU6s2KBcWYx995FVurRx2IhJc4dcidxKzBI/LWTKKcDRzsv6kfIo3o1uEs
         4AV6ADsK++zuJVrAngpvhbU/+L9Y+g/jYWcB4r5xI7XtTC6gauUcIn8h+eh6DTfPl9
         uvJYAov+HNDfPpy4F7pT1I8CRBj8hbWAzqvJo3QA=
Date:   Tue, 06 Jul 2021 12:09:15 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, faiyazm@codeaurora.org, gregkh@linuxfoundation.org,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs.patch removed from
 -mm tree
Message-ID: <20210706190915.bFi4Y34Jy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: move sysfs slab alloc/free interfaces to debugfs
has been removed from the -mm tree.  Its filename was
     mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: mm: slub: move sysfs slab alloc/free interfaces to debugfs

alloc_calls and free_calls implementation in sysfs have two issues, one is
PAGE_SIZE limitation of sysfs and other is it does not adhere to "one
value per file" rule.

To overcome this issues, move the alloc_calls and free_calls
implementation to debugfs.

Debugfs cache will be created if SLAB_STORE_USER flag is set.

Rename the alloc_calls/free_calls to alloc_traces/free_traces, to be
inline with what it does.

[faiyazm@codeaurora.org: fix the leak of alloc/free traces debugfs interface]
  Link: https://lkml.kernel.org/r/1624248060-30286-1-git-send-email-faiyazm@codeaurora.org
Link: https://lkml.kernel.org/r/1623438200-19361-1-git-send-email-faiyazm@codeaurora.org
Signed-off-by: Faiyaz Mohammed <faiyazm@codeaurora.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    6 
 mm/slab_common.c |    2 
 mm/slub.c        |  274 +++++++++++++++++++++++++++++----------------
 3 files changed, 189 insertions(+), 93 deletions(-)

--- a/mm/slab_common.c~mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs
+++ a/mm/slab_common.c
@@ -448,6 +448,7 @@ static void slab_caches_to_rcu_destroy_w
 	rcu_barrier();
 
 	list_for_each_entry_safe(s, s2, &to_destroy, list) {
+		debugfs_slab_release(s);
 		kfence_shutdown_cache(s);
 #ifdef SLAB_SUPPORTS_SYSFS
 		sysfs_slab_release(s);
@@ -475,6 +476,7 @@ static int shutdown_cache(struct kmem_ca
 		schedule_work(&slab_caches_to_rcu_destroy_work);
 	} else {
 		kfence_shutdown_cache(s);
+		debugfs_slab_release(s);
 #ifdef SLAB_SUPPORTS_SYSFS
 		sysfs_slab_unlink(s);
 		sysfs_slab_release(s);
--- a/mm/slab.h~mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs
+++ a/mm/slab.h
@@ -631,6 +631,12 @@ static inline bool slab_want_init_on_fre
 	return false;
 }
 
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
+void debugfs_slab_release(struct kmem_cache *);
+#else
+static inline void debugfs_slab_release(struct kmem_cache *s) { }
+#endif
+
 #ifdef CONFIG_PRINTK
 #define KS_ADDRS_COUNT 16
 struct kmem_obj_info {
--- a/mm/slub.c~mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs
+++ a/mm/slub.c
@@ -38,6 +38,7 @@
 #include <linux/random.h>
 #include <kunit/test.h>
 
+#include <linux/debugfs.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -238,6 +239,12 @@ static inline int sysfs_slab_alias(struc
 							{ return 0; }
 #endif
 
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
+static void debugfs_slab_add(struct kmem_cache *);
+#else
+static inline void debugfs_slab_add(struct kmem_cache *s) { }
+#endif
+
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
@@ -4593,6 +4600,9 @@ int __kmem_cache_create(struct kmem_cach
 	if (err)
 		__kmem_cache_release(s);
 
+	if (s->flags & SLAB_STORE_USER)
+		debugfs_slab_add(s);
+
 	return err;
 }
 
@@ -4739,6 +4749,7 @@ long validate_slab_cache(struct kmem_cac
 }
 EXPORT_SYMBOL(validate_slab_cache);
 
+#ifdef CONFIG_DEBUG_FS
 /*
  * Generate lists of code addresses where slabcache objects are allocated
  * and freed.
@@ -4762,6 +4773,8 @@ struct loc_track {
 	struct location *loc;
 };
 
+static struct dentry *slab_debugfs_root;
+
 static void free_loc_track(struct loc_track *t)
 {
 	if (t->max)
@@ -4878,82 +4891,7 @@ static void process_slab(struct loc_trac
 			add_location(t, s, get_track(s, p, alloc));
 	put_map(map);
 }
-
-static int list_locations(struct kmem_cache *s, char *buf,
-			  enum track_item alloc)
-{
-	int len = 0;
-	unsigned long i;
-	struct loc_track t = { 0, 0, NULL };
-	int node;
-	struct kmem_cache_node *n;
-
-	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
-			     GFP_KERNEL)) {
-		return sysfs_emit(buf, "Out of memory\n");
-	}
-	/* Push back cpu slabs */
-	flush_all(s);
-
-	for_each_kmem_cache_node(s, node, n) {
-		unsigned long flags;
-		struct page *page;
-
-		if (!atomic_long_read(&n->nr_slabs))
-			continue;
-
-		spin_lock_irqsave(&n->list_lock, flags);
-		list_for_each_entry(page, &n->partial, slab_list)
-			process_slab(&t, s, page, alloc);
-		list_for_each_entry(page, &n->full, slab_list)
-			process_slab(&t, s, page, alloc);
-		spin_unlock_irqrestore(&n->list_lock, flags);
-	}
-
-	for (i = 0; i < t.count; i++) {
-		struct location *l = &t.loc[i];
-
-		len += sysfs_emit_at(buf, len, "%7ld ", l->count);
-
-		if (l->addr)
-			len += sysfs_emit_at(buf, len, "%pS", (void *)l->addr);
-		else
-			len += sysfs_emit_at(buf, len, "<not-available>");
-
-		if (l->sum_time != l->min_time)
-			len += sysfs_emit_at(buf, len, " age=%ld/%ld/%ld",
-					     l->min_time,
-					     (long)div_u64(l->sum_time,
-							   l->count),
-					     l->max_time);
-		else
-			len += sysfs_emit_at(buf, len, " age=%ld", l->min_time);
-
-		if (l->min_pid != l->max_pid)
-			len += sysfs_emit_at(buf, len, " pid=%ld-%ld",
-					     l->min_pid, l->max_pid);
-		else
-			len += sysfs_emit_at(buf, len, " pid=%ld",
-					     l->min_pid);
-
-		if (num_online_cpus() > 1 &&
-		    !cpumask_empty(to_cpumask(l->cpus)))
-			len += sysfs_emit_at(buf, len, " cpus=%*pbl",
-					     cpumask_pr_args(to_cpumask(l->cpus)));
-
-		if (nr_online_nodes > 1 && !nodes_empty(l->nodes))
-			len += sysfs_emit_at(buf, len, " nodes=%*pbl",
-					     nodemask_pr_args(&l->nodes));
-
-		len += sysfs_emit_at(buf, len, "\n");
-	}
-
-	free_loc_track(&t);
-	if (!t.count)
-		len += sysfs_emit_at(buf, len, "No data\n");
-
-	return len;
-}
+#endif  /* CONFIG_DEBUG_FS   */
 #endif	/* CONFIG_SLUB_DEBUG */
 
 #ifdef CONFIG_SYSFS
@@ -5343,21 +5281,6 @@ static ssize_t validate_store(struct kme
 }
 SLAB_ATTR(validate);
 
-static ssize_t alloc_calls_show(struct kmem_cache *s, char *buf)
-{
-	if (!(s->flags & SLAB_STORE_USER))
-		return -ENOSYS;
-	return list_locations(s, buf, TRACK_ALLOC);
-}
-SLAB_ATTR_RO(alloc_calls);
-
-static ssize_t free_calls_show(struct kmem_cache *s, char *buf)
-{
-	if (!(s->flags & SLAB_STORE_USER))
-		return -ENOSYS;
-	return list_locations(s, buf, TRACK_FREE);
-}
-SLAB_ATTR_RO(free_calls);
 #endif /* CONFIG_SLUB_DEBUG */
 
 #ifdef CONFIG_FAILSLAB
@@ -5521,8 +5444,6 @@ static struct attribute *slab_attrs[] =
 	&poison_attr.attr,
 	&store_user_attr.attr,
 	&validate_attr.attr,
-	&alloc_calls_attr.attr,
-	&free_calls_attr.attr,
 #endif
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
@@ -5810,6 +5731,173 @@ static int __init slab_sysfs_init(void)
 __initcall(slab_sysfs_init);
 #endif /* CONFIG_SYSFS */
 
+#if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS)
+static int slab_debugfs_show(struct seq_file *seq, void *v)
+{
+
+	struct location *l;
+	unsigned int idx = *(unsigned int *)v;
+	struct loc_track *t = seq->private;
+
+	if (idx < t->count) {
+		l = &t->loc[idx];
+
+		seq_printf(seq, "%7ld ", l->count);
+
+		if (l->addr)
+			seq_printf(seq, "%pS", (void *)l->addr);
+		else
+			seq_puts(seq, "<not-available>");
+
+		if (l->sum_time != l->min_time) {
+			seq_printf(seq, " age=%ld/%llu/%ld",
+				l->min_time, div_u64(l->sum_time, l->count),
+				l->max_time);
+		} else
+			seq_printf(seq, " age=%ld", l->min_time);
+
+		if (l->min_pid != l->max_pid)
+			seq_printf(seq, " pid=%ld-%ld", l->min_pid, l->max_pid);
+		else
+			seq_printf(seq, " pid=%ld",
+				l->min_pid);
+
+		if (num_online_cpus() > 1 && !cpumask_empty(to_cpumask(l->cpus)))
+			seq_printf(seq, " cpus=%*pbl",
+				 cpumask_pr_args(to_cpumask(l->cpus)));
+
+		if (nr_online_nodes > 1 && !nodes_empty(l->nodes))
+			seq_printf(seq, " nodes=%*pbl",
+				 nodemask_pr_args(&l->nodes));
+
+		seq_puts(seq, "\n");
+	}
+
+	if (!idx && !t->count)
+		seq_puts(seq, "No data\n");
+
+	return 0;
+}
+
+static void slab_debugfs_stop(struct seq_file *seq, void *v)
+{
+}
+
+static void *slab_debugfs_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	struct loc_track *t = seq->private;
+
+	v = ppos;
+	++*ppos;
+	if (*ppos <= t->count)
+		return v;
+
+	return NULL;
+}
+
+static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
+{
+	return ppos;
+}
+
+static const struct seq_operations slab_debugfs_sops = {
+	.start  = slab_debugfs_start,
+	.next   = slab_debugfs_next,
+	.stop   = slab_debugfs_stop,
+	.show   = slab_debugfs_show,
+};
+
+static int slab_debug_trace_open(struct inode *inode, struct file *filep)
+{
+
+	struct kmem_cache_node *n;
+	enum track_item alloc;
+	int node;
+	struct loc_track *t = __seq_open_private(filep, &slab_debugfs_sops,
+						sizeof(struct loc_track));
+	struct kmem_cache *s = file_inode(filep)->i_private;
+
+	if (strcmp(filep->f_path.dentry->d_name.name, "alloc_traces") == 0)
+		alloc = TRACK_ALLOC;
+	else
+		alloc = TRACK_FREE;
+
+	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL))
+		return -ENOMEM;
+
+	/* Push back cpu slabs */
+	flush_all(s);
+
+	for_each_kmem_cache_node(s, node, n) {
+		unsigned long flags;
+		struct page *page;
+
+		if (!atomic_long_read(&n->nr_slabs))
+			continue;
+
+		spin_lock_irqsave(&n->list_lock, flags);
+		list_for_each_entry(page, &n->partial, slab_list)
+			process_slab(t, s, page, alloc);
+		list_for_each_entry(page, &n->full, slab_list)
+			process_slab(t, s, page, alloc);
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	return 0;
+}
+
+static int slab_debug_trace_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct loc_track *t = seq->private;
+
+	free_loc_track(t);
+	return seq_release_private(inode, file);
+}
+
+static const struct file_operations slab_debugfs_fops = {
+	.open    = slab_debug_trace_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = slab_debug_trace_release,
+};
+
+static void debugfs_slab_add(struct kmem_cache *s)
+{
+	struct dentry *slab_cache_dir;
+
+	if (unlikely(!slab_debugfs_root))
+		return;
+
+	slab_cache_dir = debugfs_create_dir(s->name, slab_debugfs_root);
+
+	debugfs_create_file("alloc_traces", 0400,
+		slab_cache_dir, s, &slab_debugfs_fops);
+
+	debugfs_create_file("free_traces", 0400,
+		slab_cache_dir, s, &slab_debugfs_fops);
+}
+
+void debugfs_slab_release(struct kmem_cache *s)
+{
+	debugfs_remove_recursive(debugfs_lookup(s->name, slab_debugfs_root));
+}
+
+static int __init slab_debugfs_init(void)
+{
+	struct kmem_cache *s;
+
+	slab_debugfs_root = debugfs_create_dir("slab", NULL);
+
+	list_for_each_entry(s, &slab_caches, list)
+		if (s->flags & SLAB_STORE_USER)
+			debugfs_slab_add(s);
+
+	return 0;
+
+}
+__initcall(slab_debugfs_init);
+#endif
 /*
  * The /proc/slabinfo ABI
  */
_

Patches currently in -mm which might be from faiyazm@codeaurora.org are


