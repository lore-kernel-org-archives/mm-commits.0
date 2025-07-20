Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A072601
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976920; cv=none; b=LJFlVRkYM2OTb058fu3OR3xQMtTLAg3QjyInFnbWW/bv0RytXFLBr5X1sv2H0VbHU1t2ki2AT0T9RTC2gW/ZkWXCF9o5ka/v2gktl0Uuet43KrDQzcUbzFtIirqQ16QOrKsq68bswIFcRbFNR7sE5B4pmgeBF0dqWqj4LdGj5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976920; c=relaxed/simple;
	bh=a2ONDG8TC/Im0pF3mdWGsqSlT2rTRP3PYlyQk4o0Eww=;
	h=Date:To:From:Subject:Message-Id; b=tGxzaPgBjGYT96bmwS6B910+6DVb5g422fdw8WRqmF44N+kf7t0YchOqCdGbZ+LP3lnPF/9D4E60K+Hu/v4kdU1ZDM3C/BBSsq0v8Wb805I9wxHkWmQ/L0oiLICSfiwYO3zcm1qWzltDt/PJica3YIq4nwVbczs38d98ItjiYqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fhsjg3ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fhsjg3ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5545C4CEE3;
	Sun, 20 Jul 2025 02:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976920;
	bh=a2ONDG8TC/Im0pF3mdWGsqSlT2rTRP3PYlyQk4o0Eww=;
	h=Date:To:From:Subject:From;
	b=Fhsjg3ft/286L25Sw+2zBFzSttPQQqU/JaQvnQc/jDT1tCLe/X47jZTUT+rpRBQUG
	 2LS6knp6erju4ahn+YIlyHzhyv/w+KvMqa/KNhA8BITsjA3xOakPM9LFuqTCx42VzT
	 De8jXeW7SgnMAKLtgVId5zKUXKbZ7O6LWU1QzY1o=
Date: Sat, 19 Jul 2025 19:02:00 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-per-node-proactive-reclaim-interface.patch removed from -mm tree
Message-Id: <20250720020200.A5545C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce per-node proactive reclaim interface
has been removed from the -mm tree.  Its filename was
     mm-introduce-per-node-proactive-reclaim-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: user_proactive_reclaim(): return -EBUSY on PGDAT_RECLAIM_LOCKED contention, per Roman]
[dave@stgolabs.net: memcg && node is also a bogus case, per Shakeel]
  Link: https://lkml.kernel.org/r/20250717235604.2atyx2aobwowpge3@offworld
Link: https://lkml.kernel.org/r/20250623185851.830632-5-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-devices-node |    9 ++
 drivers/base/node.c                         |    2 
 include/linux/swap.h                        |   16 +++++
 mm/vmscan.c                                 |   55 +++++++++++++++---
 4 files changed, 75 insertions(+), 7 deletions(-)

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
@@ -7732,15 +7730,17 @@ static const match_table_t tokens = {
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
 
-	if (!buf || (!memcg && !pgdat))
+	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
 		return -EINVAL;
 
 	buf = strstrip(buf);
@@ -7792,11 +7792,29 @@ int user_proactive_reclaim(char *buf, st
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
+				return -EBUSY;
+
+			reclaimed = __node_reclaim(pgdat, gfp_mask,
+						   batch_size, &sc);
+			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
 		if (!reclaimed && !nr_retries--)
@@ -7855,3 +7873,26 @@ void check_move_unevictable_folios(struc
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


