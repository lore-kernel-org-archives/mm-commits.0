From: akpm@linux-foundation.org
Subject: [merged]
 memcg-use-generic-slab-iterators-for-showing-slabinfo.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 10:57:20 -0800
Message-ID: <5489e910.vgZc6wE/lTNgm+hf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaLKS5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use generic slab iterators for showing slabinfo
has been removed from the -mm tree.  Its filename was
     memcg-use-generic-slab-iterators-for-showing-slabinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: use generic slab iterators for showing slabinfo

Let's use generic slab_start/next/stop for showing memcg caches info.  In
contrast to the current implementation, this will work even if all memcg
caches' info doesn't fit into a seq buffer (a page), plus it simply looks
neater.

Actually, the main reason I do this isn't mere cleanup.  I'm going to zap
the memcg_slab_caches list, because I find it useless provided we have the
slab_caches list, and this patch is a step in this direction.

It should be noted that before this patch an attempt to read
memory.kmem.slabinfo of a cgroup that doesn't have kmem limit set resulted
in -EIO, while after this patch it will silently show nothing except the
header, but I don't think it will frustrate anyone.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ----
 mm/memcontrol.c      |   25 ++++---------------------
 mm/slab.h            |    1 +
 mm/slab_common.c     |   25 +++++++++++++++++++------
 4 files changed, 24 insertions(+), 31 deletions(-)

diff -puN include/linux/slab.h~memcg-use-generic-slab-iterators-for-showing-slabinfo include/linux/slab.h
--- a/include/linux/slab.h~memcg-use-generic-slab-iterators-for-showing-slabinfo
+++ a/include/linux/slab.h
@@ -513,10 +513,6 @@ struct memcg_cache_params {
 
 int memcg_update_all_caches(int num_memcgs);
 
-struct seq_file;
-int cache_show(struct kmem_cache *s, struct seq_file *m);
-void print_slabinfo_header(struct seq_file *m);
-
 /**
  * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
diff -puN mm/memcontrol.c~memcg-use-generic-slab-iterators-for-showing-slabinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-generic-slab-iterators-for-showing-slabinfo
+++ a/mm/memcontrol.c
@@ -2547,26 +2547,6 @@ static struct kmem_cache *memcg_params_t
 	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
 }
 
-#ifdef CONFIG_SLABINFO
-static int mem_cgroup_slabinfo_read(struct seq_file *m, void *v)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
-	struct memcg_cache_params *params;
-
-	if (!memcg_kmem_is_active(memcg))
-		return -EIO;
-
-	print_slabinfo_header(m);
-
-	mutex_lock(&memcg_slab_mutex);
-	list_for_each_entry(params, &memcg->memcg_slab_caches, list)
-		cache_show(memcg_params_to_cache(params), m);
-	mutex_unlock(&memcg_slab_mutex);
-
-	return 0;
-}
-#endif
-
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
 			     unsigned long nr_pages)
 {
@@ -4708,7 +4688,10 @@ static struct cftype mem_cgroup_files[]
 #ifdef CONFIG_SLABINFO
 	{
 		.name = "kmem.slabinfo",
-		.seq_show = mem_cgroup_slabinfo_read,
+		.seq_start = slab_start,
+		.seq_next = slab_next,
+		.seq_stop = slab_stop,
+		.seq_show = memcg_slab_show,
 	},
 #endif
 #endif
diff -puN mm/slab.h~memcg-use-generic-slab-iterators-for-showing-slabinfo mm/slab.h
--- a/mm/slab.h~memcg-use-generic-slab-iterators-for-showing-slabinfo
+++ a/mm/slab.h
@@ -360,5 +360,6 @@ static inline struct kmem_cache_node *ge
 void *slab_start(struct seq_file *m, loff_t *pos);
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
+int memcg_slab_show(struct seq_file *m, void *p);
 
 #endif /* MM_SLAB_H */
diff -puN mm/slab_common.c~memcg-use-generic-slab-iterators-for-showing-slabinfo mm/slab_common.c
--- a/mm/slab_common.c~memcg-use-generic-slab-iterators-for-showing-slabinfo
+++ a/mm/slab_common.c
@@ -811,7 +811,7 @@ EXPORT_SYMBOL(kmalloc_order_trace);
 #define SLABINFO_RIGHTS S_IRUSR
 #endif
 
-void print_slabinfo_header(struct seq_file *m)
+static void print_slabinfo_header(struct seq_file *m)
 {
 	/*
 	 * Output format version, so at least we can change it
@@ -876,7 +876,7 @@ memcg_accumulate_slabinfo(struct kmem_ca
 	}
 }
 
-int cache_show(struct kmem_cache *s, struct seq_file *m)
+static void cache_show(struct kmem_cache *s, struct seq_file *m)
 {
 	struct slabinfo sinfo;
 
@@ -895,7 +895,6 @@ int cache_show(struct kmem_cache *s, str
 		   sinfo.active_slabs, sinfo.num_slabs, sinfo.shared_avail);
 	slabinfo_show_stats(m, s);
 	seq_putc(m, '\n');
-	return 0;
 }
 
 static int slab_show(struct seq_file *m, void *p)
@@ -904,10 +903,24 @@ static int slab_show(struct seq_file *m,
 
 	if (p == slab_caches.next)
 		print_slabinfo_header(m);
-	if (!is_root_cache(s))
-		return 0;
-	return cache_show(s, m);
+	if (is_root_cache(s))
+		cache_show(s, m);
+	return 0;
+}
+
+#ifdef CONFIG_MEMCG_KMEM
+int memcg_slab_show(struct seq_file *m, void *p)
+{
+	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+
+	if (p == slab_caches.next)
+		print_slabinfo_header(m);
+	if (!is_root_cache(s) && s->memcg_params->memcg == memcg)
+		cache_show(s, m);
+	return 0;
 }
+#endif
 
 /*
  * slabinfo_op - iterator that generates /proc/slabinfo
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

