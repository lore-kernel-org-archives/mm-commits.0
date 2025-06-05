Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2540204F93
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155984; cv=none; b=TdsYPY+kTWv5Ex3/dyfoAXqGAz+FcFgz5RYbNtBw4BazCXkqWv+/EA+N30XC6aW6D91671itGO8oEzh9oLSr7s1THc65xAQEbP2MYCdnegeKLxv69ZJjmv6WDlKuIt6VYylOdZ4xTrrrOEjQeY1YTe8jILWPoDmxxrYrB6e2ARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155984; c=relaxed/simple;
	bh=acTDhLM4iGme/WLkhIvTW9uz8ay4/iJH/nmXYPQKIWM=;
	h=Date:To:From:Subject:Message-Id; b=rDRrt7CoYGEVt41B9BoaWLfB+Ew+W88JLlBLub2wrpYMcLy+zRtmkhAY3ySJIJtBU/PT9JqHyTuK9Z90Rn6t63tqYc9BhNsY6wwuStFBqi6Obg51DRRPdUI7HyLS7QFLNM31t27USG5h2JcFPazdtO8Nfa8k+hApEwHo/eUEjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEgf8I/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEgf8I/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B41C4CEEB;
	Thu,  5 Jun 2025 20:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155984;
	bh=acTDhLM4iGme/WLkhIvTW9uz8ay4/iJH/nmXYPQKIWM=;
	h=Date:To:From:Subject:From;
	b=gEgf8I/W/wP9m2X2/MpTDiR4OqlJNhj5d8EyAIimFE0SdTw3Y6rQBcwuWtQsSNJbp
	 es8Dk08s2PKuraI4aWpogIfmm9v1NigKfvEDTqgnv+aXc3J1WPxypbdNPChw60JKsC
	 c2glVYNIylV6NciihfXSTP9NAWOQvMLFUtsdDp90=
Date: Thu, 05 Jun 2025 13:39:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250605203944.74B41C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory-tiers: use node-notifier instead of memory-notifier
has been added to the -mm mm-new branch.  Its filename is
     mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory-tiers: use node-notifier instead of memory-notifier
Date: Thu, 5 Jun 2025 16:22:56 +0200

memory-tier is only concerned when a numa node changes its memory state,
because it then needs to re-create the demotion list.  So stop using the
memory notifier and use the new numa node notifer instead.

Link: https://lkml.kernel.org/r/20250605142305.244465-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memory-tiers.c~mmmemory-tiers-use-node-notifier-instead-of-memory-notifier
+++ a/mm/memory-tiers.c
@@ -872,25 +872,25 @@ static int __meminit memtier_hotplug_cal
 					      unsigned long action, void *_arg)
 {
 	struct memory_tier *memtier;
-	struct memory_notify *arg = _arg;
+	struct node_notify *narg = _arg;
 
 	/*
 	 * Only update the node migration order when a node is
 	 * changing status, like online->offline.
 	 */
-	if (arg->status_change_nid < 0)
+	if (narg->nid < 0)
 		return notifier_from_errno(0);
 
 	switch (action) {
-	case MEM_OFFLINE:
+	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(arg->status_change_nid))
+		if (clear_node_memory_tier(narg->nid))
 			establish_demotion_targets();
 		mutex_unlock(&memory_tier_lock);
 		break;
-	case MEM_ONLINE:
+	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		memtier = set_node_memory_tier(arg->status_change_nid);
+		memtier = set_node_memory_tier(narg->nid);
 		if (!IS_ERR(memtier))
 			establish_demotion_targets();
 		mutex_unlock(&memory_tier_lock);
@@ -929,7 +929,7 @@ static int __init memory_tier_init(void)
 	nodes_and(default_dram_nodes, node_states[N_MEMORY],
 		  node_states[N_CPU]);
 
-	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
+	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
 subsys_initcall(memory_tier_init);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

