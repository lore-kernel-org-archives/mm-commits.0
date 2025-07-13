Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F51D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450009; cv=none; b=NjqojR8RYfw64mTLTiJEN0lAs3oEclYnB4Np32ZxLRuCujY79Gw7mgflkIu6QJMfQN6iHW9r45gJCEMOgnGH2uCcLVjWu8WHh2UnZ6aa7fp/Ra3F8MgPAyuC9SeCMGSoHEd5efGfEkupq7LsG+ylJIX1JSLynPwPurtUQz5ZHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450009; c=relaxed/simple;
	bh=yTU23qm3B3Jw8nn5BNhwK/dCtHSwdClK70K/MlIcK1Y=;
	h=Date:To:From:Subject:Message-Id; b=NLIttBG41PaTyRqcG08QF6hNGfn9mLLsauURKg3hEUYbVWxUNHWTw0Ej5fJVNVQwmm6K5inVYxHBDs8NNirGjzN4wl5aflnohvCzKvPxzUII8h507tMUygZOop6nDx7yS6LNJElqL1+5DjMzayVVuuNo8Gi1SvIGglf5v4Ra/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isL1JFAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isL1JFAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC5CC4CEE3;
	Sun, 13 Jul 2025 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450009;
	bh=yTU23qm3B3Jw8nn5BNhwK/dCtHSwdClK70K/MlIcK1Y=;
	h=Date:To:From:Subject:From;
	b=isL1JFAvtwRfCMQygbsGPCOATM0NFQErwmuI1u/9/SLG0MxUaEhGZDT4cTPaSsXGM
	 pSj561BvxDtq86VVOPJZ0ADw/CpI0A/GdQGDS5bZLt1xEIlKNnnZDmWji3/lmoC0Xm
	 Vh1G8ZwvMB9LJLMr5SlhvFOZv3zt1LMSU78pqFpU=
Date: Sun, 13 Jul 2025 16:40:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch removed from -mm tree
Message-Id: <20250713234008.DFC5CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,memory_hotplug: drop status_change_nid parameter from memory_notify
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: drop status_change_nid parameter from memory_notify
Date: Mon, 16 Jun 2025 15:51:54 +0200

There no users left of status_change_nid, so drop it from memory_notify
struct.

Link: https://lkml.kernel.org/r/20250616135158.450136-12-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-hotplug.rst |    7 -------
 include/linux/memory.h                    |    1 -
 mm/memory_hotplug.c                       |    4 ----
 3 files changed, 12 deletions(-)

--- a/Documentation/core-api/memory-hotplug.rst~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/Documentation/core-api/memory-hotplug.rst
@@ -59,17 +59,10 @@ The third argument (arg) passes a pointe
 	struct memory_notify {
 		unsigned long start_pfn;
 		unsigned long nr_pages;
-		int status_change_nid;
 	}
 
 - start_pfn is start_pfn of online/offline memory.
 - nr_pages is # of pages of online/offline memory.
-- status_change_nid is set node id when N_MEMORY of nodemask is (will be)
-  set/clear. It means a new(memoryless) node gets new memory by online and a
-  node loses all memory. If this is -1, then nodemask status is not changed.
-
-  If status_changed_nid* >= 0, callback should create/discard structures for the
-  node if necessary.
 
 It is possible to get notified for MEM_CANCEL_ONLINE without having been notified
 for MEM_GOING_ONLINE, and the same applies to MEM_CANCEL_OFFLINE and
--- a/include/linux/memory.h~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/include/linux/memory.h
@@ -109,7 +109,6 @@ struct memory_notify {
 	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-	int status_change_nid;
 };
 
 struct notifier_block;
--- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify
+++ a/mm/memory_hotplug.c
@@ -1153,7 +1153,6 @@ int online_pages(unsigned long pfn, unsi
 	struct memory_notify mem_arg = {
 		.start_pfn = pfn,
 		.nr_pages = nr_pages,
-		.status_change_nid = NUMA_NO_NODE,
 	};
 	struct node_notify node_arg = {
 		.nid = NUMA_NO_NODE,
@@ -1181,7 +1180,6 @@ int online_pages(unsigned long pfn, unsi
 	if (!node_state(nid, N_MEMORY)) {
 		/* Adding memory to the node for the first time */
 		node_arg.nid = nid;
-		mem_arg.status_change_nid = nid;
 		ret = node_notify(NODE_ADDING_FIRST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
 		if (ret)
@@ -1904,7 +1902,6 @@ int offline_pages(unsigned long start_pf
 	struct memory_notify mem_arg = {
 		.start_pfn = start_pfn,
 		.nr_pages = nr_pages,
-		.status_change_nid = NUMA_NO_NODE,
 	};
 	struct node_notify node_arg = {
 		.nid = NUMA_NO_NODE,
@@ -1975,7 +1972,6 @@ int offline_pages(unsigned long start_pf
 	 */
 	if (nr_pages >= pgdat->node_present_pages) {
 		node_arg.nid = node;
-		mem_arg.status_change_nid = node;
 		ret = node_notify(NODE_REMOVING_LAST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
 		if (ret) {
_

Patches currently in -mm which might be from osalvador@suse.de are


