From: akpm@linux-foundation.org
Subject: + mm-slabinfo-dump-config_slabinfo-v11.patch added to -mm tree
Date: Tue, 10 Oct 2017 13:05:21 -0700
Message-ID: <59dd2801.Iwd0QHUIoGgM5lDe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935001AbdJJUFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slabinfo-dump-config_slabinfo-v11
has been added to the -mm tree.  Its filename is
     mm-slabinfo-dump-config_slabinfo-v11.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabinfo-dump-config_slabinfo-v11.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabinfo-dump-config_slabinfo-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1183,6 +1183,7 @@ void cache_random_seq_destroy(struct kme
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 #ifdef CONFIG_SLAB
 #define SLABINFO_RIGHTS (S_IWUSR | S_IRUSR)
 #else
@@ -1278,7 +1279,7 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
-#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
+#if defined(CONFIG_MEMCG)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -1352,6 +1353,7 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
+#endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
 
 static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 					   gfp_t flags)
diff -puN mm/slub.c~mm-slabinfo-dump-config_slabinfo-v11 mm/slub.c
--- a/mm/slub.c~mm-slabinfo-dump-config_slabinfo-v11
+++ a/mm/slub.c
@@ -5851,6 +5851,7 @@ __initcall(slab_sysfs_init);
 /*
  * The /proc/slabinfo ABI
  */
+#ifdef CONFIG_SLUB_DEBUG
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
 	unsigned long nr_slabs = 0;
@@ -5882,3 +5883,4 @@ ssize_t slabinfo_write(struct file *file
 {
 	return -EIO;
 }
+#endif /* CONFIG_SLUB_DEBUG */
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch
tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-slabinfo-dump-config_slabinfo-v11.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch

