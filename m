Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC26BC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BF120723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027015;
	bh=HboONV7qQ14JflUeAnOsK2zF5ED4kmY3RjN2YK5utpc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Mr51j20mxbuQtJOiGbqgeu8qA7tTNowSUjIWqLT7L1Sj6zZ9Zea9+RophCihXL/jv
	 kaCr33bmgDqPGbJLimuzG9cuL8PaTTbRaVLYBC8l2odjmp5uwStxdUxaiYd3IF9r6o
	 sCNXk0ItLsM6qULzSgWXWUzU1jp9gCMxmX874UbE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgHJCgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgHJCgz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD873206C3;
        Mon, 10 Aug 2020 02:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027014;
        bh=HboONV7qQ14JflUeAnOsK2zF5ED4kmY3RjN2YK5utpc=;
        h=Date:From:To:Subject:From;
        b=i77gaZr54tXvutifXS8D+xQB3b7uNACThn+MCAsouvkQVx0RvuMqaW0wlcUuDDYXo
         uT3N8bgczzrjWIzni8f/uJQvXzyDoUBpXIXDqghf//tmnStpTxlEbreUTlB8qEcyjj
         05hxLm26vesDGav6z/jmuBGa9UQxKWg4EmG+4D5U=
Date:   Sun, 09 Aug 2020 19:36:53 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged] mm-memcg-slab-deprecate-slab_root_caches.patch
 removed from -mm tree
Message-ID: <20200810023653.XHUG9UkoQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: deprecate slab_root_caches
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-deprecate-slab_root_caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: deprecate slab_root_caches

Currently there are two lists of kmem_caches:
1) slab_caches, which contains all kmem_caches,
2) slab_root_caches, which contains only root kmem_caches.

And there is some preprocessor magic to have a single list if
CONFIG_MEMCG_KMEM isn't enabled.

It was required earlier because the number of non-root kmem_caches was
proportional to the number of memory cgroups and could reach really big
values.  Now, when it cannot exceed the number of root kmem_caches, there
is really no reason to maintain two lists.

We never iterate over the slab_root_caches list on any hot paths, so it's
perfectly fine to iterate over slab_caches and filter out non-root
kmem_caches.

It allows to remove a lot of config-dependent code and two pointers from
the kmem_cache structure.

Link: http://lkml.kernel.org/r/20200623174037.3951353-16-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    1 -
 mm/slab.h        |   17 -----------------
 mm/slab_common.c |   37 ++++++++-----------------------------
 mm/slub.c        |    1 -
 4 files changed, 8 insertions(+), 48 deletions(-)

--- a/mm/slab.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab.c
@@ -1249,7 +1249,6 @@ void __init kmem_cache_init(void)
 				  nr_node_ids * sizeof(struct kmem_cache_node *),
 				  SLAB_HWCACHE_ALIGN, 0, 0);
 	list_add(&kmem_cache->list, &slab_caches);
-	memcg_link_cache(kmem_cache);
 	slab_state = PARTIAL;
 
 	/*
--- a/mm/slab_common.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab_common.c
@@ -131,9 +131,6 @@ int __kmem_cache_alloc_bulk(struct kmem_
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-
-LIST_HEAD(slab_root_caches);
-
 static void memcg_kmem_cache_create_func(struct work_struct *work)
 {
 	struct kmem_cache *cachep = container_of(work, struct kmem_cache,
@@ -156,27 +153,11 @@ static void init_memcg_params(struct kme
 	else
 		slab_init_memcg_params(s);
 }
-
-void memcg_link_cache(struct kmem_cache *s)
-{
-	if (is_root_cache(s))
-		list_add(&s->root_caches_node, &slab_root_caches);
-}
-
-static void memcg_unlink_cache(struct kmem_cache *s)
-{
-	if (is_root_cache(s))
-		list_del(&s->root_caches_node);
-}
 #else
 static inline void init_memcg_params(struct kmem_cache *s,
 				     struct kmem_cache *root_cache)
 {
 }
-
-static inline void memcg_unlink_cache(struct kmem_cache *s)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
@@ -253,7 +234,7 @@ struct kmem_cache *find_mergeable(unsign
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
 
-	list_for_each_entry_reverse(s, &slab_root_caches, root_caches_node) {
+	list_for_each_entry_reverse(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -312,7 +293,6 @@ static struct kmem_cache *create_cache(c
 
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 out:
 	if (err)
 		return ERR_PTR(err);
@@ -507,7 +487,6 @@ static int shutdown_cache(struct kmem_ca
 	if (__kmem_cache_shutdown(s) != 0)
 		return -EBUSY;
 
-	memcg_unlink_cache(s);
 	list_del(&s->list);
 
 	if (s->flags & SLAB_TYPESAFE_BY_RCU) {
@@ -751,7 +730,6 @@ struct kmem_cache *__init create_kmalloc
 
 	create_boot_cache(s, name, size, flags, useroffset, usersize);
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 	s->refcount = 1;
 	return s;
 }
@@ -1107,12 +1085,12 @@ static void print_slabinfo_header(struct
 void *slab_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&slab_mutex);
-	return seq_list_start(&slab_root_caches, *pos);
+	return seq_list_start(&slab_caches, *pos);
 }
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_list_next(p, &slab_root_caches, pos);
+	return seq_list_next(p, &slab_caches, pos);
 }
 
 void slab_stop(struct seq_file *m, void *p)
@@ -1165,11 +1143,12 @@ static void cache_show(struct kmem_cache
 
 static int slab_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache, root_caches_node);
+	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
 
-	if (p == slab_root_caches.next)
+	if (p == slab_caches.next)
 		print_slabinfo_header(m);
-	cache_show(s, m);
+	if (is_root_cache(s))
+		cache_show(s, m);
 	return 0;
 }
 
@@ -1271,7 +1250,7 @@ static int memcg_slabinfo_show(struct se
 	mutex_lock(&slab_mutex);
 	seq_puts(m, "# <name> <css_id[:dead|deact]> <active_objs> <num_objs>");
 	seq_puts(m, " <active_slabs> <num_slabs>\n");
-	list_for_each_entry(s, &slab_root_caches, root_caches_node) {
+	list_for_each_entry(s, &slab_caches, list) {
 		/*
 		 * Skip kmem caches that don't have the memcg cache.
 		 */
--- a/mm/slab.h~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slab.h
@@ -44,14 +44,12 @@ struct kmem_cache {
  *
  * @memcg_cache: pointer to memcg kmem cache, used by all non-root memory
  *		cgroups.
- * @root_caches_node: list node for slab_root_caches list.
  * @work: work struct used to create the non-root cache.
  */
 struct memcg_cache_params {
 	struct kmem_cache *root_cache;
 
 	struct kmem_cache *memcg_cache;
-	struct list_head __root_caches_node;
 	struct work_struct work;
 };
 #endif /* CONFIG_SLOB */
@@ -265,11 +263,6 @@ static inline bool kmem_cache_debug_flag
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-
-/* List of all root caches. */
-extern struct list_head		slab_root_caches;
-#define root_caches_node	memcg_params.__root_caches_node
-
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return !s->memcg_params.root_cache;
@@ -447,14 +440,8 @@ static inline void memcg_slab_free_hook(
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
-extern void memcg_link_cache(struct kmem_cache *s);
 
 #else /* CONFIG_MEMCG_KMEM */
-
-/* If !memcg, all caches are root. */
-#define slab_root_caches	slab_caches
-#define root_caches_node	list
-
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return true;
@@ -523,10 +510,6 @@ static inline void slab_init_memcg_param
 {
 }
 
-static inline void memcg_link_cache(struct kmem_cache *s)
-{
-}
-
 #endif /* CONFIG_MEMCG_KMEM */
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
--- a/mm/slub.c~mm-memcg-slab-deprecate-slab_root_caches
+++ a/mm/slub.c
@@ -4360,7 +4360,6 @@ static struct kmem_cache * __init bootst
 	}
 	slab_init_memcg_params(s);
 	list_add(&s->list, &slab_caches);
-	memcg_link_cache(s);
 	return s;
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

