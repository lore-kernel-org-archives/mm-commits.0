Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02A7C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379841AbiFQCtu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379808AbiFQCtm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF165432
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D08A9B826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB1CC34114;
        Fri, 17 Jun 2022 02:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434178;
        bh=LTGZN1mpUq29O7XpuiT7kPHv2qyT2vFhQgcXPWvRYkQ=;
        h=Date:To:From:Subject:From;
        b=LNjJUOE1jm/HpMLj0CjNteTKA9oqWeqemBBqJmTHzVIeWJ0+4CvfRNR/b8uqR7KPz
         bUhhTyqg+mK403fYQuCGbtk4ZTBJHYwdFcBEbwtp2LGzl04DkbKd/G1KbEVUgQ+ZBl
         DaYV5x9ZZFnQNmB3ReHl3QUWSACyJuD6bUKMcyLA=
Date:   Thu, 16 Jun 2022 19:49:37 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vvs@openvz.org, vbabka@suse.cz, songmuchun@bytedance.com,
        shakeelb@google.com, quic_qiancai@quicinc.com, pabeni@redhat.com,
        naresh.kamboju@linaro.org, mkoutny@suse.com, mhocko@suse.com,
        lkft@linaro.org, kuba@kernel.org, hannes@cmpxchg.org, fw@strlen.de,
        edumazet@google.com, davem@davemloft.net, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmem-make-mem_cgroup_from_obj-vmalloc-safe.patch removed from -mm tree
Message-Id: <20220617024938.8DB1CC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmem: make mem_cgroup_from_obj() vmalloc()-safe
has been removed from the -mm tree.  Its filename was
     mm-kmem-make-mem_cgroup_from_obj-vmalloc-safe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: make mem_cgroup_from_obj() vmalloc()-safe
Date: Fri, 10 Jun 2022 11:03:10 -0700

Currently mem_cgroup_from_obj() is not working properly with objects
allocated using vmalloc().  It creates problems in some cases, when it's
called for static objects belonging to modules or generally allocated
using vmalloc().

This patch makes mem_cgroup_from_obj() safe to be called on objects
allocated using vmalloc().

It also introduces mem_cgroup_from_slab_obj(), which is a faster version
to use in places when we know the object is either a slab object or a
generic slab page (e.g.  when adding an object to a lru list).

Link: https://lkml.kernel.org/r/20220610180310.1725111-1-roman.gushchin@linux.dev
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Vasily Averin <vvs@openvz.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++
 mm/list_lru.c              |    2 
 mm/memcontrol.c            |   71 ++++++++++++++++++++++++-----------
 3 files changed, 57 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-make-mem_cgroup_from_obj-vmalloc-safe
+++ a/include/linux/memcontrol.h
@@ -1740,6 +1740,7 @@ static inline int memcg_kmem_id(struct m
 }
 
 struct mem_cgroup *mem_cgroup_from_obj(void *p);
+struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
 
 static inline void count_objcg_event(struct obj_cgroup *objcg,
 				     enum vm_event_item idx)
@@ -1801,6 +1802,11 @@ static inline struct mem_cgroup *mem_cgr
        return NULL;
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+{
+	return NULL;
+}
+
 static inline void count_objcg_event(struct obj_cgroup *objcg,
 				     enum vm_event_item idx)
 {
--- a/mm/list_lru.c~mm-kmem-make-mem_cgroup_from_obj-vmalloc-safe
+++ a/mm/list_lru.c
@@ -71,7 +71,7 @@ list_lru_from_kmem(struct list_lru *lru,
 	if (!list_lru_memcg_aware(lru))
 		goto out;
 
-	memcg = mem_cgroup_from_obj(ptr);
+	memcg = mem_cgroup_from_slab_obj(ptr);
 	if (!memcg)
 		goto out;
 
--- a/mm/memcontrol.c~mm-kmem-make-mem_cgroup_from_obj-vmalloc-safe
+++ a/mm/memcontrol.c
@@ -783,7 +783,7 @@ void __mod_lruvec_kmem_state(void *p, en
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_obj(p);
+	memcg = mem_cgroup_from_slab_obj(p);
 
 	/*
 	 * Untracked pages have no memcg, no lruvec. Update only the
@@ -2841,27 +2841,9 @@ int memcg_alloc_slab_cgroups(struct slab
 	return 0;
 }
 
-/*
- * Returns a pointer to the memory cgroup to which the kernel object is charged.
- *
- * A passed kernel object can be a slab object or a generic kernel page, so
- * different mechanisms for getting the memory cgroup pointer should be used.
- * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the caller
- * can not know for sure how the kernel object is implemented.
- * mem_cgroup_from_obj() can be safely used in such cases.
- *
- * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
- * cgroup_mutex, etc.
- */
-struct mem_cgroup *mem_cgroup_from_obj(void *p)
+static __always_inline
+struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
 {
-	struct folio *folio;
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	folio = virt_to_folio(p);
-
 	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
@@ -2894,6 +2876,53 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	return page_memcg_check(folio_page(folio, 0));
 }
 
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * A passed kernel object can be a slab object, vmalloc object or a generic
+ * kernel page, so different mechanisms for getting the memory cgroup pointer
+ * should be used.
+ *
+ * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the caller
+ * can not know for sure how the kernel object is implemented.
+ * mem_cgroup_from_obj() can be safely used in such cases.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct folio *folio;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	if (unlikely(is_vmalloc_addr(p)))
+		folio = page_folio(vmalloc_to_page(p));
+	else
+		folio = virt_to_folio(p);
+
+	return mem_cgroup_from_obj_folio(folio, p);
+}
+
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ * Similar to mem_cgroup_from_obj(), but faster and not suitable for objects,
+ * allocated using vmalloc().
+ *
+ * A passed kernel object must be a slab object or a generic kernel page.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
+}
+
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix.patch

