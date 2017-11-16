From: akpm@linux-foundation.org
Subject: [patch 014/131] mm: slabinfo: remove CONFIG_SLABINFO
Date: Wed, 15 Nov 2017 17:32:03 -0800
Message-ID: <20171116013203.f0LKDwWGw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754571AbdKPBcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.s@alibaba-inc.com

From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: slabinfo: remove CONFIG_SLABINFO

According to discussion with Christoph
(https://marc.info/?l=linux-kernel&m=150695909709711&w=2), it sounds like
it is pointless to keep CONFIG_SLABINFO around.

This patch removes the CONFIG_SLABINFO config option, but /proc/slabinfo
is still available.

[yang.s@alibaba-inc.com: v11]
  Link: http://lkml.kernel.org/r/1507656303-103845-3-git-send-email-yang.s@alibaba-inc.com
Link: http://lkml.kernel.org/r/1507152550-46205-3-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |    6 ------
 mm/memcontrol.c  |    2 +-
 mm/slab.c        |    2 --
 mm/slab_common.c |    7 +++----
 mm/slub.c        |    4 ++--
 5 files changed, 6 insertions(+), 15 deletions(-)

diff -puN init/Kconfig~mm-slabinfo-dump-config_slabinfo init/Kconfig
--- a/init/Kconfig~mm-slabinfo-dump-config_slabinfo
+++ a/init/Kconfig
@@ -1664,12 +1664,6 @@ config HAVE_GENERIC_DMA_COHERENT
 	bool
 	default n
 
-config SLABINFO
-	bool
-	depends on PROC_FS
-	depends on SLAB || SLUB_DEBUG
-	default y
-
 config RT_MUTEXES
 	bool
 
diff -puN mm/memcontrol.c~mm-slabinfo-dump-config_slabinfo mm/memcontrol.c
--- a/mm/memcontrol.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/memcontrol.c
@@ -4049,7 +4049,7 @@ static struct cftype mem_cgroup_legacy_f
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
-#ifdef CONFIG_SLABINFO
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 	{
 		.name = "kmem.slabinfo",
 		.seq_start = memcg_slab_start,
diff -puN mm/slab.c~mm-slabinfo-dump-config_slabinfo mm/slab.c
--- a/mm/slab.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slab.c
@@ -4097,7 +4097,6 @@ out:
 	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_AC));
 }
 
-#ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *cachep, struct slabinfo *sinfo)
 {
 	unsigned long active_objs, num_objs, active_slabs;
@@ -4405,7 +4404,6 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
-#endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
 /*
diff -puN mm/slab_common.c~mm-slabinfo-dump-config_slabinfo mm/slab_common.c
--- a/mm/slab_common.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slab_common.c
@@ -1184,8 +1184,7 @@ void cache_random_seq_destroy(struct kme
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
-#ifdef CONFIG_SLABINFO
-
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 #ifdef CONFIG_SLAB
 #define SLABINFO_RIGHTS (S_IWUSR | S_IRUSR)
 #else
@@ -1281,7 +1280,7 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
-#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
+#if defined(CONFIG_MEMCG)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -1355,7 +1354,7 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
-#endif /* CONFIG_SLABINFO */
+#endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
 
 static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 					   gfp_t flags)
diff -puN mm/slub.c~mm-slabinfo-dump-config_slabinfo mm/slub.c
--- a/mm/slub.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slub.c
@@ -5852,7 +5852,7 @@ __initcall(slab_sysfs_init);
 /*
  * The /proc/slabinfo ABI
  */
-#ifdef CONFIG_SLABINFO
+#ifdef CONFIG_SLUB_DEBUG
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
 	unsigned long nr_slabs = 0;
@@ -5884,4 +5884,4 @@ ssize_t slabinfo_write(struct file *file
 {
 	return -EIO;
 }
-#endif /* CONFIG_SLABINFO */
+#endif /* CONFIG_SLUB_DEBUG */
_
