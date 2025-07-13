Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F501D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450000; cv=none; b=tS7Yr3CaDC7KEfpqFWD18O3zbQ8SJ+GG/9kY0F8Y9oRuXn9v3MwpuVXX/veT3qlHsIxEwJDS/6j1nv4q8EZCDrrpSbBXxsO8aOa8Xmv+wRhLa9ENj2+qJNWIexsvn8pZbm1ObOoD4Il1HlAtwPX723VnvYQjsGH26QW1DFkVdOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450000; c=relaxed/simple;
	bh=+7I/SrNRvYXrwk2+LCL5SVj9sp8dE+zxM3TpF1d/aLA=;
	h=Date:To:From:Subject:Message-Id; b=IKAHYygMLlU5Ek7KG5c2kHi58tD96nMBDNl9DiXBtEIvjn4ksXwTMkVj8RDeKjWI2Po0HxtRGa0TzjcYaFvLZQ9Fn6e64/03ha8iHZmivwa4O/BPyO3pzjrqwFsA/7cEmfhhck5YE+6tnv859pO9UxEkpy+xbd5KniA4VfhTt2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nBr7wfNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nBr7wfNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B343C4CEE3;
	Sun, 13 Jul 2025 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450000;
	bh=+7I/SrNRvYXrwk2+LCL5SVj9sp8dE+zxM3TpF1d/aLA=;
	h=Date:To:From:Subject:From;
	b=nBr7wfNIrXTQvFQapZS5xn1mHZRnNROHgOy3MUDresNTNwL8PaKt+qJFE3e1xvx7P
	 2EHq0lb3/pC38qpmYezFBFL0rljs5P/K2gwL7TOMhcEuWQ4oyuWu//ZABRA4unMRtG
	 xvyhHYTCb8F5NdjG1Dm8uTNAn32RN0PEu7IWqovc=
Date: Sun, 13 Jul 2025 16:40:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713234000.9B343C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,memory-tiers: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory-tiers: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:48 +0200

memory-tier is only concerned when a numa node changes its memory state,
because it then needs to re-create the demotion list.  So stop using the
memory notifier and use the new numa node notifer instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/memory-tiers.c~mmmemory-tiers-use-node-notifier-instead-of-memory-notifier
+++ a/mm/memory-tiers.c
@@ -872,25 +872,18 @@ static int __meminit memtier_hotplug_cal
 					      unsigned long action, void *_arg)
 {
 	struct memory_tier *memtier;
-	struct memory_notify *arg = _arg;
-
-	/*
-	 * Only update the node migration order when a node is
-	 * changing status, like online->offline.
-	 */
-	if (arg->status_change_nid < 0)
-		return notifier_from_errno(0);
+	struct node_notify *nn = _arg;
 
 	switch (action) {
-	case MEM_OFFLINE:
+	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(arg->status_change_nid))
+		if (clear_node_memory_tier(nn->nid))
 			establish_demotion_targets();
 		mutex_unlock(&memory_tier_lock);
 		break;
-	case MEM_ONLINE:
+	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		memtier = set_node_memory_tier(arg->status_change_nid);
+		memtier = set_node_memory_tier(nn->nid);
 		if (!IS_ERR(memtier))
 			establish_demotion_targets();
 		mutex_unlock(&memory_tier_lock);
@@ -929,7 +922,7 @@ static int __init memory_tier_init(void)
 	nodes_and(default_dram_nodes, node_states[N_MEMORY],
 		  node_states[N_CPU]);
 
-	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
+	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
 subsys_initcall(memory_tier_init);
_

Patches currently in -mm which might be from osalvador@suse.de are


