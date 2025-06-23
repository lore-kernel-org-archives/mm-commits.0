Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80649221DA8
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 21:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715419; cv=none; b=iqpbCyOeIRasaOJ+jN6gzjzsvRRaw2WVgoiUX+r3jUuXX+aqUTZfv4eIuAeJSV6gpeZE48JG4bKNOfYgxJ/MhDel6bgM51WIQLKGSPnVGdLiG3829+ZIwTSNzkkIOpzjlIqiCVqbnm/quJIj4vm7Qbm8w/jBuwVbBTdth69rnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715419; c=relaxed/simple;
	bh=BaEhJ5v/4WVbXYRElz3SHH5ELw4fss5ySRa9dz3OkPs=;
	h=Date:To:From:Subject:Message-Id; b=Tq33M6xTNEgcErlOWrXop1darucLHV0f5/gcCz6uC8xHfWtlAnvUVQcGSCzZFcZx2DdIhxZ13FaiuarM3RWjfI7EZ+/HquYNgdsDdnpbYdTEis19Gq5I1GiF1D5plzH0+XZjH91sJVNYsMUI+K9xapDVi8y0Z1cFK/9MVrZzS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OiNmiltz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OiNmiltz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F8FC4CEEA;
	Mon, 23 Jun 2025 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715419;
	bh=BaEhJ5v/4WVbXYRElz3SHH5ELw4fss5ySRa9dz3OkPs=;
	h=Date:To:From:Subject:From;
	b=OiNmiltz9JDrxtGci+i0ncNuDoxjCd5Y7olqjH0qYw4SpGnIXgHL4C6OeQISYU5KE
	 YK/bb7ZAN44TjimyzeuwUP2q6d8Gbwvu7/iTqnJl8qNhI96bxgz0btVwQvdG6LG+zW
	 NnoPwQNtw02Sy+D9kERPGyXx/RlPyAjKLsnAqUUk=
Date: Mon, 23 Jun 2025 14:50:18 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-per-node-proactive-reclaim-interface.patch added to mm-new branch
Message-Id: <20250623215019.32F8FC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce per-node proactive reclaim interface
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-per-node-proactive-reclaim-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-per-node-proactive-reclaim-interface.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm: introduce per-node proactive reclaim interface
Date: Mon, 23 Jun 2025 11:58:51 -0700

This adds support for allowing proactive reclaim in general on a NUMA
system.  A per-node interface extends support for beyond a memcg-specific
interface, respecting the current semantics of memory.reclaim: respecting
aging LRU and not supporting artificially triggering eviction on nodes
belonging to non-bottom tiers.

This patch allows userspace to do:

     echo "512M swappiness=10" > /sys/devices/system/node/nodeX/reclaim

One of the premises for this is to semantically align as best as possible
with memory.reclaim.  During a brief time memcg did support nodemask until
55ab834a86a9 (Revert "mm: add nodes= arg to memory.reclaim"), for which
semantics around reclaim (eviction) vs demotion were not clear, rendering
charging expectations to be broken.

With this approach:

1. Users who do not use memcg can benefit from proactive reclaim.  The
   memcg interface is not NUMA aware and there are usecases that are
   focusing on NUMA balancing rather than workload memory footprint.

2. Proactive reclaim on top tiers will trigger demotion, for which
   memory is still byte-addressable.  Reclaiming on the bottom nodes will
   trigger evicting to swap (the traditional sense of reclaim).  This
   follows the semantics of what is today part of the aging process on
   tiered memory, mirroring what every other form of reclaim does
   (reactive and memcg proactive reclaim).  Furthermore per-node proactive
   reclaim is not as susceptible to the memcg charging problem mentioned
   above.

3. Unlike the nodes= arg, this interface avoids confusing semantics,
   such as what exactly the user wants when mixing top-tier and low-tier
   nodes in the nodemask.  Further per-node interface is less exposed to
   "free up memory in my container" usecases, where eviction is intended.

4. Users that *really* want to free up memory can use proactive
   reclaim on nodes knowingly to be on the bottom tiers to force eviction
   in a natural way - higher access latencies are still better than swap. 
   If compelled, while no guarantees and perhaps not worth the effort,
   users could also also potentially follow a ladder-like approach to
   eventually free up the memory.  Alternatively, perhaps an 'evict'
   option could be added to the parameters for both memory.reclaim and
   per-node interfaces to force this action unconditionally.

Link: https://lkml.kernel.org/r/20250623185851.830632-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-devices-node |    9 +++
 drivers/base/node.c                         |    2 
 include/linux/swap.h                        |   16 +++++
 mm/vmscan.c                                 |   53 +++++++++++++++---
 4 files changed, 74 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/stable/sysfs-devices-node~mm-introduce-per-node-proactive-reclaim-interface
+++ a/Documentation/ABI/stable/sysfs-devices-node
@@ -227,3 +227,12 @@ Contact:	Jiaqi Yan <jiaqiyan@google.com>
 Description:
 		Of the raw poisoned pages on a NUMA node, how many pages are
 		recovered by memory error recovery attempt.
+
+What:		/sys/devices/system/node/nodeX/reclaim
+Date:		June 2025
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Perform user-triggered proactive reclaim on a NUMA node.
+		This interface is equivalent to the memcg variant.
+
+		See Documentation/admin-guide/cgroup-v2.rst
--- a/drivers/base/node.c~mm-introduce-per-node-proactive-reclaim-interface
+++ a/drivers/base/node.c
@@ -659,6 +659,7 @@ static int register_node(struct node *no
 	} else {
 		hugetlb_register_node(node);
 		compaction_register_node(node);
+		reclaim_register_node(node);
 	}
 
 	return error;
@@ -675,6 +676,7 @@ void unregister_node(struct node *node)
 {
 	hugetlb_unregister_node(node);
 	compaction_unregister_node(node);
+	reclaim_unregister_node(node);
 	node_remove_accesses(node);
 	node_remove_caches(node);
 	device_unregister(&node->dev);
--- a/include/linux/swap.h~mm-introduce-per-node-proactive-reclaim-interface
+++ a/include/linux/swap.h
@@ -431,6 +431,22 @@ extern unsigned long shrink_all_memory(u
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+extern int reclaim_register_node(struct node *node);
+extern void reclaim_unregister_node(struct node *node);
+
+#else
+
+static inline int reclaim_register_node(struct node *node)
+{
+	return 0;
+}
+
+static inline void reclaim_unregister_node(struct node *node)
+{
+}
+#endif /* CONFIG_SYSFS && CONFIG_NUMA */
+
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
--- a/mm/vmscan.c~mm-introduce-per-node-proactive-reclaim-interface
+++ a/mm/vmscan.c
@@ -94,10 +94,8 @@ struct scan_control {
 	unsigned long	anon_cost;
 	unsigned long	file_cost;
 
-#ifdef CONFIG_MEMCG
 	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
 	int *proactive_swappiness;
-#endif
 
 	/* Can active folios be deactivated as part of reclaim? */
 #define DEACTIVATE_ANON 1
@@ -121,7 +119,7 @@ struct scan_control {
 	/* Has cache_trim_mode failed at least once? */
 	unsigned int cache_trim_mode_failed:1;
 
-	/* Proactive reclaim invoked by userspace through memory.reclaim */
+	/* Proactive reclaim invoked by userspace */
 	unsigned int proactive:1;
 
 	/*
@@ -7730,13 +7728,15 @@ static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
-int user_proactive_reclaim(char *buf, struct mem_cgroup *memcg, pg_data_t *pgdat)
+int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat)
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
+	gfp_t gfp_mask = GFP_KERNEL;
 
 	if (!buf || (!memcg && !pgdat))
 		return -EINVAL;
@@ -7790,11 +7790,29 @@ int user_proactive_reclaim(char *buf, st
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
-						 batch_size, GFP_KERNEL,
+						 batch_size, gfp_mask,
 						 reclaim_options,
 						 swappiness == -1 ? NULL : &swappiness);
 		} else {
-			return -EINVAL;
+			struct scan_control sc = {
+				.gfp_mask = current_gfp_context(gfp_mask),
+				.reclaim_idx = gfp_zone(gfp_mask),
+				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
+				.priority = DEF_PRIORITY,
+				.may_writepage = !laptop_mode,
+				.nr_to_reclaim = max(batch_size, SWAP_CLUSTER_MAX),
+				.may_unmap = 1,
+				.may_swap = 1,
+				.proactive = 1,
+			};
+
+			if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED,
+						  &pgdat->flags))
+				return -EAGAIN;
+
+			reclaimed = __node_reclaim(pgdat, gfp_mask,
+						   batch_size, &sc);
+			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
 		if (!reclaimed && !nr_retries--)
@@ -7853,3 +7871,26 @@ void check_move_unevictable_folios(struc
 	}
 }
 EXPORT_SYMBOL_GPL(check_move_unevictable_folios);
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+static ssize_t reclaim_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	int ret, nid = dev->id;
+
+	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
+	return ret ? -EAGAIN : count;
+}
+
+static DEVICE_ATTR_WO(reclaim);
+int reclaim_register_node(struct node *node)
+{
+	return device_create_file(&node->dev, &dev_attr_reclaim);
+}
+
+void reclaim_unregister_node(struct node *node)
+{
+	return device_remove_file(&node->dev, &dev_attr_reclaim);
+}
+#endif
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch
mm-memcg-make-memoryreclaim-interface-generic.patch
mm-vmscan-make-__node_reclaim-more-generic.patch
mm-introduce-per-node-proactive-reclaim-interface.patch

