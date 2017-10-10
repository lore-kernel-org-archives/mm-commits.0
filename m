From: akpm@linux-foundation.org
Subject: +
 mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch added to -mm tree
Date: Tue, 10 Oct 2017 13:05:25 -0700
Message-ID: <59dd2805.bnSFQbdtuZfLDwsc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935021AbdJJUF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11
has been added to the -mm tree.  Its filename is
     mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch

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
Subject: mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11

Link: http://lkml.kernel.org/r/1507656303-103845-4-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h        |    6 +++
 mm/slab_common.c |   69 ++++++++++++++++++++++-----------------------
 2 files changed, 40 insertions(+), 35 deletions(-)

diff -puN mm/slab_common.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11 mm/slab_common.c
--- a/mm/slab_common.c~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11
+++ a/mm/slab_common.c
@@ -558,41 +558,6 @@ static int shutdown_cache(struct kmem_ca
 	return 0;
 }
 
-void dump_unreclaimable_slab(void)
-{
-	struct kmem_cache *s, *s2;
-	struct slabinfo sinfo;
-
-	/*
-	 * Here acquiring slab_mutex is risky since we don't prefer to get
-	 * sleep in oom path. But, without mutex hold, it may introduce a
-	 * risk of crash.
-	 * Use mutex_trylock to protect the list traverse, dump nothing
-	 * without acquiring the mutex.
-	 */
-	if (!mutex_trylock(&slab_mutex)) {
-		pr_warn("excessive unreclaimable slab but cannot dump stats\n");
-		return;
-	}
-
-	pr_info("Unreclaimable slab info:\n");
-	pr_info("Name                      Used          Total\n");
-
-	list_for_each_entry_safe(s, s2, &slab_caches, list) {
-		if (!is_root_cache(s) || (s->flags & SLAB_RECLAIM_ACCOUNT))
-			continue;
-
-		memset(&sinfo, 0, sizeof(sinfo));
-		get_slabinfo(s, &sinfo);
-
-		if (sinfo.num_objs > 0)
-			pr_info("%-17s %10luKB %10luKB\n", cache_name(s),
-				(sinfo.active_objs * s->size) / 1024,
-				(sinfo.num_objs * s->size) / 1024);
-	}
-	mutex_unlock(&slab_mutex);
-}
-
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 /*
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
@@ -1314,6 +1279,40 @@ static int slab_show(struct seq_file *m,
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
diff -puN mm/slab.h~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11 mm/slab.h
--- a/mm/slab.h~mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11
+++ a/mm/slab.h
@@ -505,7 +505,13 @@ void *memcg_slab_next(struct seq_file *m
 void memcg_slab_stop(struct seq_file *m, void *p);
 int memcg_slab_show(struct seq_file *m, void *p);
 
+#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 void dump_unreclaimable_slab(void);
+#else
+static inline void dump_unreclaimable_slab(void)
+{
+}
+#endif
 
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
 
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-madvise-add-description-for-madv_wipeonfork-and-madv_keeponfork.patch
tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-slabinfo-dump-config_slabinfo-v11.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch

