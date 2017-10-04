From: akpm@linux-foundation.org
Subject: + mm-slabinfo-dump-config_slabinfo.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:04:52 -0700
Message-ID: <59d55b04.xCeumDaHs+/JK3Ba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44182 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDWEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slabinfo: remove CONFIG_SLABINFO
has been added to the -mm tree.  Its filename is
     mm-slabinfo-dump-config_slabinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabinfo-dump-config_slabinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabinfo-dump-config_slabinfo.patch

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
Subject: mm: slabinfo: remove CONFIG_SLABINFO

According to discussion with Christoph
(https://marc.info/?l=linux-kernel&m=150695909709711&w=2), it sounds like
it is pointless to keep CONFIG_SLABINFO around.

This patch removes the CONFIG_SLABINFO config option, but /proc/slabinfo
is still available.

Link: http://lkml.kernel.org/r/1507152550-46205-3-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |    6 ------
 mm/memcontrol.c  |    2 --
 mm/slab.c        |    2 --
 mm/slab_common.c |    3 ---
 mm/slub.c        |    2 --
 5 files changed, 15 deletions(-)

diff -puN init/Kconfig~mm-slabinfo-dump-config_slabinfo init/Kconfig
--- a/init/Kconfig~mm-slabinfo-dump-config_slabinfo
+++ a/init/Kconfig
@@ -1657,12 +1657,6 @@ config HAVE_GENERIC_DMA_COHERENT
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
@@ -4049,7 +4049,6 @@ static struct cftype mem_cgroup_legacy_f
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
-#ifdef CONFIG_SLABINFO
 	{
 		.name = "kmem.slabinfo",
 		.seq_start = memcg_slab_start,
@@ -4057,7 +4056,6 @@ static struct cftype mem_cgroup_legacy_f
 		.seq_stop = memcg_slab_stop,
 		.seq_show = memcg_slab_show,
 	},
-#endif
 	{
 		.name = "kmem.tcp.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_TCP, RES_LIMIT),
diff -puN mm/slab.c~mm-slabinfo-dump-config_slabinfo mm/slab.c
--- a/mm/slab.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slab.c
@@ -4096,7 +4096,6 @@ out:
 	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_AC));
 }
 
-#ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *cachep, struct slabinfo *sinfo)
 {
 	unsigned long active_objs, num_objs, active_slabs;
@@ -4404,7 +4403,6 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
-#endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
 /*
diff -puN mm/slab_common.c~mm-slabinfo-dump-config_slabinfo mm/slab_common.c
--- a/mm/slab_common.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slab_common.c
@@ -1183,8 +1183,6 @@ void cache_random_seq_destroy(struct kme
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
-#ifdef CONFIG_SLABINFO
-
 #ifdef CONFIG_SLAB
 #define SLABINFO_RIGHTS (S_IWUSR | S_IRUSR)
 #else
@@ -1354,7 +1352,6 @@ static int __init slab_proc_init(void)
 	return 0;
 }
 module_init(slab_proc_init);
-#endif /* CONFIG_SLABINFO */
 
 static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 					   gfp_t flags)
diff -puN mm/slub.c~mm-slabinfo-dump-config_slabinfo mm/slub.c
--- a/mm/slub.c~mm-slabinfo-dump-config_slabinfo
+++ a/mm/slub.c
@@ -5851,7 +5851,6 @@ __initcall(slab_sysfs_init);
 /*
  * The /proc/slabinfo ABI
  */
-#ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 {
 	unsigned long nr_slabs = 0;
@@ -5883,4 +5882,3 @@ ssize_t slabinfo_write(struct file *file
 {
 	return -EIO;
 }
-#endif /* CONFIG_SLABINFO */
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch
tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch

