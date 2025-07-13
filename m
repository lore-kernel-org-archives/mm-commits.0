Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7134C1F560B
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449992; cv=none; b=fA5Pv0ksQol9H2aTAi4+un5gNwsqLtG3fpnXtaPbIME+mQsbBgM7p28horrjN89wsfY2tCj3oof0NRaWbhIgN/LLF9gjTLVMS4OHB/gqozppPfw0X/ZK6f9ATlTUgZ+Z/INrZZhQ2FWrs5Th1MJTpzFUfqQi5K9B3oqjwKm8QIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449992; c=relaxed/simple;
	bh=zbey2hOioJNryTCv9OcNEzB4eOJGHWERaEtBX6PWfdM=;
	h=Date:To:From:Subject:Message-Id; b=mOfdQvx3PIZ+gXBJgit6Ha2cg2MXtxopFWoPndWHbok7gZcANHuDBH2BDl/RS0H9qO1QM9GiTJYqJu3d8xKGGW/BiMwJ8Nl/uSZmvJHgUghaYEMzTwFPtyuqkRpigQNto4/SvB9oOkhGt5XhFXBFyHDagx/TTDjqeoMjJgokEmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xvroKEW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xvroKEW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E01C4CEE3;
	Sun, 13 Jul 2025 23:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449992;
	bh=zbey2hOioJNryTCv9OcNEzB4eOJGHWERaEtBX6PWfdM=;
	h=Date:To:From:Subject:From;
	b=xvroKEW+BXwKaIMSu8a3M0UCBBs9JPRp/Q18ie8KLvMGBCxChxgZiM4krckpcXHcT
	 udQgJl7VuC8PEKjqObwi9ag6ACNPTEXz1CTogzzaxv8tDAnR2bvpRXdx3TOgNXFzkx
	 iDH9ssHxQDE1XFAJODYHj06p1FovhRt31OQ+4iNk=
Date: Sun, 13 Jul 2025 16:39:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch removed from -mm tree
Message-Id: <20250713233952.42E01C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,slub: do not special case N_NORMAL nodes for slab_nodes
has been removed from the -mm tree.  Its filename was
     mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,slub: do not special case N_NORMAL nodes for slab_nodes
Date: Mon, 16 Jun 2025 15:51:44 +0200

Patch series "Implement numa node notifier", v7.

Memory notifier is a tool that allow consumers to get notified whenever
memory gets onlined or offlined in the system.  Currently, there are 10
consumers of that, but 5 out of those 10 consumers are only interested in
getting notifications when a numa node changes its memory state.  That
means going from memoryless to memory-aware of vice versa.

Which means that for every {online,offline}_pages operation they get
notified even though the numa node might not have changed its state.  This
is suboptimal, and we want to decouple numa node state changes from memory
state changes.

While we are doing this, remove status_change_nid_normal, as the only
current user (slub) does not really need it.  This allows us to further
simplify and clean up the code.

The first patch gets rid of status_change_nid_normal in slub.  The second
patch implements a numa node notifier that does just that, and have those
consumers register in there, so they get notified only when they are
interested.

The third patch replaces 'status_change_nid{_normal}' fields within
memory_notify with a 'nid', as that is only what we need for memory
notifer and update the only user of it (page_ext).

Consumers that are only interested in numa node states change are:

 - memory-tier
 - slub
 - cpuset
 - hmat
 - cxl
 - autoweight-mempolicy


This patch (of 11):

Currently, slab_mem_going_online_callback() checks whether the node has
N_NORMAL memory in order to be set in slab_nodes.  While it is true that
getting rid of that enforcing would mean ending up with movables nodes in
slab_nodes, the memory waste that comes with that is negligible.

So stop checking for status_change_nid_normal and just use
status_change_nid instead which works for both types of memory.

Also, once we allocate the kmem_cache_node cache for the node in
slab_mem_online_callback(), we never deallocate it in
slab_mem_offline_callback() when the node goes memoryless, so we can just
get rid of it.

The side effects are that we will stop clearing the node from slab_nodes,
and also that newly created kmem caches after node hotremove will now
allocate their kmem_cache_node for the node(s) that was hotremoved, but
these should be negligible.

Link: https://lkml.kernel.org/r/20250616135158.450136-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250616135158.450136-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

--- a/mm/slub.c~mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes
+++ a/mm/slub.c
@@ -447,7 +447,7 @@ static inline struct kmem_cache_node *ge
 
 /*
  * Tracks for which NUMA nodes we have kmem_cache_nodes allocated.
- * Corresponds to node_state[N_NORMAL_MEMORY], but can temporarily
+ * Corresponds to node_state[N_MEMORY], but can temporarily
  * differ during memory hotplug/hotremove operations.
  * Protected by slab_mutex.
  */
@@ -6163,36 +6163,12 @@ static int slab_mem_going_offline_callba
 	return 0;
 }
 
-static void slab_mem_offline_callback(void *arg)
-{
-	struct memory_notify *marg = arg;
-	int offline_node;
-
-	offline_node = marg->status_change_nid_normal;
-
-	/*
-	 * If the node still has available memory. we need kmem_cache_node
-	 * for it yet.
-	 */
-	if (offline_node < 0)
-		return;
-
-	mutex_lock(&slab_mutex);
-	node_clear(offline_node, slab_nodes);
-	/*
-	 * We no longer free kmem_cache_node structures here, as it would be
-	 * racy with all get_node() users, and infeasible to protect them with
-	 * slab_mutex.
-	 */
-	mutex_unlock(&slab_mutex);
-}
-
 static int slab_mem_going_online_callback(void *arg)
 {
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid_normal;
+	int nid = marg->status_change_nid;
 	int ret = 0;
 
 	/*
@@ -6250,10 +6226,6 @@ static int slab_memory_callback(struct n
 	case MEM_GOING_OFFLINE:
 		ret = slab_mem_going_offline_callback(arg);
 		break;
-	case MEM_OFFLINE:
-	case MEM_CANCEL_ONLINE:
-		slab_mem_offline_callback(arg);
-		break;
 	case MEM_ONLINE:
 	case MEM_CANCEL_OFFLINE:
 		break;
@@ -6324,7 +6296,7 @@ void __init kmem_cache_init(void)
 	 * Initialize the nodemask for which we will allocate per node
 	 * structures. Here we don't need taking slab_mutex yet.
 	 */
-	for_each_node_state(node, N_NORMAL_MEMORY)
+	for_each_node_state(node, N_MEMORY)
 		node_set(node, slab_nodes);
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
_

Patches currently in -mm which might be from osalvador@suse.de are


