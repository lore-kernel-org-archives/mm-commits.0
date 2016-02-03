From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show.patch
 removed from -mm tree
Date: Tue, 02 Feb 2016 19:50:33 -0800
Message-ID: <56b17909.zHupt/hiqKC9EXUy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbcBCDue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsafonov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix race with dereferencing NULL ptr in alloc_calls_show
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dmitry Safonov <dsafonov@virtuozzo.com>
Subject: mm/slab: fix race with dereferencing NULL ptr in alloc_calls_show

memcg_destroy_kmem_caches shutdowns in the first place kmem_caches under
slab_mutex which involves freeing NUMA node structures for kmem_cache and
only then under release_caches removes corresponding sysfs files for these
caches.  Which may lead to dereferencing NULL ptr on read.  Lets remove
sysfs files right there.

Fixes the following panic:
[43963.463055] BUG: unable to handle kernel
[43963.463090] NULL pointer dereference at 0000000000000020
[43963.463146] IP: [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.463185] PGD 257304067 PUD 438456067 PMD 0
[43963.463220] Oops: 0000 [#1] SMP
[43963.463850] CPU: 3 PID: 973074 Comm: cat ve: 0 Not tainted 3.10.0-229.7.2.ovz.9.30-00007-japdoll-dirty #2 9.30
[43963.463913] Hardware name: DEPO Computers To Be Filled By O.E.M./H67DE3, BIOS L1.60c 07/14/2011
[43963.463976] task: ffff88042a5dc5b0 ti: ffff88037f8d8000 task.ti: ffff88037f8d8000
[43963.464036] RIP: 0010:[<ffffffff811c6959>]  [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.464725] Call Trace:
[43963.464756]  [<ffffffff811c6d1d>] alloc_calls_show+0x1d/0x30
[43963.464793]  [<ffffffff811c15ab>] slab_attr_show+0x1b/0x30
[43963.464829]  [<ffffffff8125d27a>] sysfs_read_file+0x9a/0x1a0
[43963.464865]  [<ffffffff811e3c6c>] vfs_read+0x9c/0x170
[43963.464900]  [<ffffffff811e4798>] SyS_read+0x58/0xb0
[43963.464936]  [<ffffffff81612d49>] system_call_fastpath+0x16/0x1b
[43963.464970] Code: 5e 07 12 00 b9 00 04 00 00 3d 00 04 00 00 0f 4f c1 3d 00 04 00 00 89 45 b0 0f 84 c3 00 00 00 48 63 45 b0 49 8b 9c c4 f8 00 00 00 <48> 8b 43 20 48 85 c0 74 b6 48 89 df e8 46 37 44 00 48 8b 53 10
[43963.465119] RIP  [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.465155]  RSP <ffff88037f8dbe28>
[43963.465185] CR2: 0000000000000020

Signed-off-by: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   10 ----------
 mm/slab.h                |    8 ++++++++
 mm/slab_common.c         |   10 ++++------
 mm/slub.c                |    6 ------
 4 files changed, 12 insertions(+), 22 deletions(-)

diff -puN include/linux/slub_def.h~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show
+++ a/include/linux/slub_def.h
@@ -101,16 +101,6 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
-#ifdef CONFIG_SYSFS
-#define SLAB_SUPPORTS_SYSFS
-void sysfs_slab_remove(struct kmem_cache *);
-#else
-static inline void sysfs_slab_remove(struct kmem_cache *s)
-{
-}
-#endif
-
-
 /**
  * virt_to_obj - returns address of the beginning of object.
  * @s: object's kmem_cache
diff -puN mm/slab.h~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show mm/slab.h
--- a/mm/slab.h~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show
+++ a/mm/slab.h
@@ -367,6 +367,14 @@ static inline struct kmem_cache_node *ge
 
 #endif
 
+#if defined(CONFIG_SLUB) && defined(CONFIG_SYSFS)
+void sysfs_slab_remove(struct kmem_cache *);
+#else
+static inline void sysfs_slab_remove(struct kmem_cache *s)
+{
+}
+#endif
+
 void *slab_start(struct seq_file *m, loff_t *pos);
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
diff -puN mm/slab_common.c~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show
+++ a/mm/slab_common.c
@@ -468,13 +468,8 @@ static void release_caches(struct list_h
 	if (need_rcu_barrier)
 		rcu_barrier();
 
-	list_for_each_entry_safe(s, s2, release, list) {
-#ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_remove(s);
-#else
+	list_for_each_entry_safe(s, s2, release, list)
 		slab_kmem_cache_release(s);
-#endif
-	}
 }
 
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
@@ -614,6 +609,9 @@ void memcg_destroy_kmem_caches(struct me
 	list_for_each_entry_safe(s, s2, &slab_caches, list) {
 		if (is_root_cache(s) || s->memcg_params.memcg != memcg)
 			continue;
+
+		sysfs_slab_remove(s);
+
 		/*
 		 * The cgroup is about to be freed and therefore has no charges
 		 * left. Hence, all its caches must be empty by now.
diff -puN mm/slub.c~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show mm/slub.c
--- a/mm/slub.c~mm-slab-fix-race-with-dereferencing-null-ptr-in-alloc_calls_show
+++ a/mm/slub.c
@@ -5296,11 +5296,6 @@ static void memcg_propagate_slab_attrs(s
 #endif
 }
 
-static void kmem_cache_release(struct kobject *k)
-{
-	slab_kmem_cache_release(to_slab(k));
-}
