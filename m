From: akpm@linux-foundation.org
Subject: [folded-merged] mm-slabinfo-dump-config_slabinfo-v11.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 17:15:06 -0800
Message-ID: <5a0ce69a.TFu//riPdtM4TCGm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBPI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slabinfo-dump-config_slabinfo-v11
has been removed from the -mm tree.  Its filename was
     mm-slabinfo-dump-config_slabinfo-v11.patch

This patch was dropped because it was folded into mm-slabinfo-dump-config_slabinfo.patch

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm-slabinfo-dump-config_slabinfo-v11

Link: http://lkml.kernel.org/r/1507656303-103845-3-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    2 ++
 mm/slab_common.c |    4 +++-
 mm/slub.c        |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-slabinfo-dump-config_slabinfo-v11 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-slabinfo-dump-config_slabinfo-v11
+++ a/mm/memcontrol.c
@@ -4049,6 +4049,7 @@ static struct cftype mem_cgroup_legacy_f
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 	{
 		.name = "kmem.slabinfo",
 		.seq_start = memcg_slab_start,
@@ -4056,6 +4057,7 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_stop = memcg_slab_stop,
 		.seq_show = memcg_slab_show,
 	},
+#endif
 	{
 		.name = "kmem.tcp.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_TCP, RES_LIMIT),
diff -puN mm/slab_common.c~mm-slabinfo-dump-config_slabinfo-v11 mm/slab_common.c
--- a/mm/slab_common.c~mm-slabinfo-dump-config_slabinfo-v11
+++ a/mm/slab_common.c
@@ -1184,6 +1184,7 @@ void cache_random_seq_destroy(struct kme
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 #ifdef CONFIG_SLAB
 #define SLABINFO_RIGHTS (S_IWUSR | S_IRUSR)
 #else
@@ -1279,7 +1280,7 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
-#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
+#if defined(CONFIG_MEMCG)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -1353,6 +1354,7 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
+#endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
 
 static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 					   gfp_t flags)
diff -puN mm/slub.c~mm-slabinfo-dump-config_slabinfo-v11 mm/slub.c
--- a/mm/slub.c~mm-slabinfo-dump-config_slabinfo-v11
+++ a/mm/slub.c
@@ -5852,6 +5852,7 @@ __initcall(slab_sysfs_init);
 /*
  * The /proc/slabinfo ABI
  */
+#ifdef CONFIG_SLUB_DEBUG
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
 	unsigned long nr_slabs = 0;
@@ -5883,3 +5884,4 @@ ssize_t slabinfo_write(struct file *file
 {
 	return -EIO;
 }
+#endif /* CONFIG_SLUB_DEBUG */
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch

