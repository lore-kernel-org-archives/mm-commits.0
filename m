Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78558C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E13664E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhBXUCf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235102AbhBXUCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B575564F25;
        Wed, 24 Feb 2021 20:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196873;
        bh=rItnaG2cH6d6XPeZ6bkSwlBLsFnuNmEyhSPvslokdxs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XCB7c09YqxUX+8JahP3DKX7kv5RFcRZo4w4s6dp1pzHddZCL9MPf7dhJyjPaZ5hO7
         1yJy8rbtIyWygniG/RHRIUfWsh4eEODWMEsM6H3rgW6LWwkIdonHxU+48A2dLURwkQ
         IZKVIqUq3WT6rTQ/b26CBrjrMajm7CV0wIBaw56M=
Date:   Wed, 24 Feb 2021 12:01:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@redhat.com, cl@linux.com,
        david@redhat.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 019/173] mm, slab, slub: stop taking memory
 hotplug lock
Message-ID: <20210224200112.lvAMjFt4C%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab, slub: stop taking memory hotplug lock

Since commit 03afc0e25f7f ("slab: get_online_mems for
kmem_cache_{create,destroy,shrink}") we are taking memory hotplug lock for
SLAB and SLUB when creating, destroying or shrinking a cache.  It is quite
a heavy lock and it's best to avoid it if possible, as we had several
issues with lockdep complaining about ordering in the past, see e.g. 
e4f8e513c3d3 ("mm/slub: fix a deadlock in show_slab_objects()").

The problem scenario in 03afc0e25f7f (solved by the memory hotplug lock)
can be summarized as follows: while there's slab_mutex synchronizing new
kmem cache creation and SLUB's MEM_GOING_ONLINE callback
slab_mem_going_online_callback(), we may miss creation of kmem_cache_node
for the hotplugged node in the new kmem cache, because the hotplug
callback doesn't yet see the new cache, and cache creation in
init_kmem_cache_nodes() only inits kmem_cache_node for nodes in the
N_NORMAL_MEMORY nodemask, which however may not yet include the new node,
as that happens only later after the MEM_GOING_ONLINE callback.

Instead of using get/put_online_mems(), the problem can be solved by SLUB
maintaining its own nodemask of nodes for which it has allocated the
per-node kmem_cache_node structures.  This nodemask would generally mirror
the N_NORMAL_MEMORY nodemask, but would be updated only in under SLUB's
control in its memory hotplug callbacks under the slab_mutex.  This patch
adds such nodemask and its handling.

Commit 03afc0e25f7f mentiones "issues like [the one above]", but there
don't appear to be further issues.  All the paths (shared for SLAB and
SLUB) taking the memory hotplug locks are also taking the slab_mutex,
except kmem_cache_shrink() where 03afc0e25f7f replaced slab_mutex with
get/put_online_mems().

We however cannot simply restore slab_mutex in kmem_cache_shrink(), as
SLUB can enters the function from a write to sysfs 'shrink' file, thus
holding kernfs lock, and in kmem_cache_create() the kernfs lock is nested
within slab_mutex.  But on closer inspection we don't actually need to
protect kmem_cache_shrink() from hotplug callbacks: While SLUB's
__kmem_cache_shrink() does for_each_kmem_cache_node(), missing a new node
added in parallel hotplug is not fatal, and parallel hotremove does not
free kmem_cache_node's anymore after the previous patch, so use-after free
cannot happen.  The per-node shrinking itself is protected by
n->list_lock.  Same is true for SLAB, and SLOB is no-op.

SLAB also doesn't need the memory hotplug locking, which it only gained by
03afc0e25f7f through the shared paths in slab_common.c.  Its memory
hotplug callbacks are also protected by slab_mutex against races with
these paths.  The problem of SLUB relying on N_NORMAL_MEMORY doesn't apply
to SLAB, as its setup_kmem_cache_nodes relies on N_ONLINE, and the new
node is already set there during the MEM_GOING_ONLINE callback, so no
special care is needed for SLAB.

As such, this patch removes all get/put_online_mems() usage by the slab
subsystem.

Link: https://lkml.kernel.org/r/20210113131634.3671-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <cai@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    8 ++------
 mm/slub.c        |   28 +++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/mm/slab_common.c~mm-slab-slub-stop-taking-memory-hotplug-lock
+++ a/mm/slab_common.c
@@ -310,7 +310,6 @@ kmem_cache_create_usercopy(const char *n
 	int err;
 
 	get_online_cpus();
-	get_online_mems();
 
 	mutex_lock(&slab_mutex);
 
@@ -360,7 +359,6 @@ kmem_cache_create_usercopy(const char *n
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
-	put_online_mems();
 	put_online_cpus();
 
 	if (err) {
@@ -487,7 +485,6 @@ void kmem_cache_destroy(struct kmem_cach
 		return;
 
 	get_online_cpus();
-	get_online_mems();
 
 	mutex_lock(&slab_mutex);
 
@@ -504,7 +501,6 @@ void kmem_cache_destroy(struct kmem_cach
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
-	put_online_mems();
 	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
@@ -523,10 +519,10 @@ int kmem_cache_shrink(struct kmem_cache
 	int ret;
 
 	get_online_cpus();
-	get_online_mems();
+
 	kasan_cache_shrink(cachep);
 	ret = __kmem_cache_shrink(cachep);
-	put_online_mems();
+
 	put_online_cpus();
 	return ret;
 }
--- a/mm/slub.c~mm-slab-slub-stop-taking-memory-hotplug-lock
+++ a/mm/slub.c
@@ -235,6 +235,14 @@ static inline void stat(const struct kme
 #endif
 }
 
+/*
+ * Tracks for which NUMA nodes we have kmem_cache_nodes allocated.
+ * Corresponds to node_state[N_NORMAL_MEMORY], but can temporarily
+ * differ during memory hotplug/hotremove operations.
+ * Protected by slab_mutex.
+ */
+static nodemask_t slab_nodes;
+
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -2678,7 +2686,7 @@ static void *___slab_alloc(struct kmem_c
 		 * ignore the node constraint
 		 */
 		if (unlikely(node != NUMA_NO_NODE &&
-			     !node_state(node, N_NORMAL_MEMORY)))
+			     !node_isset(node, slab_nodes)))
 			node = NUMA_NO_NODE;
 		goto new_slab;
 	}
@@ -2689,7 +2697,7 @@ redo:
 		 * same as above but node_match() being false already
 		 * implies node != NUMA_NO_NODE
 		 */
-		if (!node_state(node, N_NORMAL_MEMORY)) {
+		if (!node_isset(node, slab_nodes)) {
 			node = NUMA_NO_NODE;
 			goto redo;
 		} else {
@@ -3592,7 +3600,7 @@ static int init_kmem_cache_nodes(struct
 {
 	int node;
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
+	for_each_node_mask(node, slab_nodes) {
 		struct kmem_cache_node *n;
 
 		if (slab_state == DOWN) {
@@ -4286,6 +4294,7 @@ static void slab_mem_offline_callback(vo
 		return;
 
 	mutex_lock(&slab_mutex);
+	node_clear(offline_node, slab_nodes);
 	/*
 	 * We no longer free kmem_cache_node structures here, as it would be
 	 * racy with all get_node() users, and infeasible to protect them with
@@ -4335,6 +4344,11 @@ static int slab_mem_going_online_callbac
 		init_kmem_cache_node(n);
 		s->node[nid] = n;
 	}
+	/*
+	 * Any cache created after this point will also have kmem_cache_node
+	 * initialized for the new node.
+	 */
+	node_set(nid, slab_nodes);
 out:
 	mutex_unlock(&slab_mutex);
 	return ret;
@@ -4415,6 +4429,7 @@ void __init kmem_cache_init(void)
 {
 	static __initdata struct kmem_cache boot_kmem_cache,
 		boot_kmem_cache_node;
+	int node;
 
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
@@ -4422,6 +4437,13 @@ void __init kmem_cache_init(void)
 	kmem_cache_node = &boot_kmem_cache_node;
 	kmem_cache = &boot_kmem_cache;
 
+	/*
+	 * Initialize the nodemask for which we will allocate per node
+	 * structures. Here we don't need taking slab_mutex yet.
+	 */
+	for_each_node_state(node, N_NORMAL_MEMORY)
+		node_set(node, slab_nodes);
+
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 		sizeof(struct kmem_cache_node), SLAB_HWCACHE_ALIGN, 0, 0);
 
_
