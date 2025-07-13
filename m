Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FAE1D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450004; cv=none; b=KsUwdGu6LQiLJZPDQQOGmf9ul1Q+QjHe9eLt4eqSB1QKpil13/a2gb4j7UR6/45Z2ftCfnJHR14WQ+HGljSzTGlGJ5Y38BTAzc7+Ym8dEOpCDI8GNuDWzLPjwk8e+IuKRZr+kE6rDHxs76PdWhfEa/XMtSZnpvCUjXnYflf8pzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450004; c=relaxed/simple;
	bh=3FSAtrlfpXAS2VFuzTME8I8+je+Lv5DEWxcIPYsUSFw=;
	h=Date:To:From:Subject:Message-Id; b=bcEr/fnprsyuYr+hq6tk3OBVbTMVkGrK+JASCgLXt0Us7XtcGJ207Rw9UwexbySqQXZtXQT3pzjmrUEiikhzBAg0LOWz/DVXY/3txVsOruEsHejlCFO+9/FzOalMGZgncB8KhwX6tQ1ke2W9/s7hXPmQO/RqsSpxuXe/YSw2PtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFu2jeTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFu2jeTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712C4C4CEE3;
	Sun, 13 Jul 2025 23:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450003;
	bh=3FSAtrlfpXAS2VFuzTME8I8+je+Lv5DEWxcIPYsUSFw=;
	h=Date:To:From:Subject:From;
	b=HFu2jeTB6iyYLvTyyej9yKIiVw3kQITT5u5a735dKjBo+k2qVzJROy3ks/VYpw7q/
	 YDBroxJ4oueY0hNvyZzpM8com6JdSg6gnLjjWcJ9eR1m8LC5TFKfxLGfcj/H0C3ZDp
	 mj4arNXlWuSY1vnYraDcgcI38blZIX3YohEBYDdM=
Date: Sun, 13 Jul 2025 16:40:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivershmat-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713234003.712C4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers,hmat: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     drivershmat-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: drivers,hmat: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:50 +0200

hmat driver is only concerned when a numa node changes its memory state,
specifically when a numa node with memory comes into play for the first
time, because it will register the memory_targets belonging to that numa
node.  So stop using the memory notifier and use the new numa node notifer
instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/numa/hmat.c~drivershmat-use-node-notifier-instead-of-memory-notifier
+++ a/drivers/acpi/numa/hmat.c
@@ -962,10 +962,10 @@ static int hmat_callback(struct notifier
 			 unsigned long action, void *arg)
 {
 	struct memory_target *target;
-	struct memory_notify *mnb = arg;
-	int pxm, nid = mnb->status_change_nid;
+	struct node_notify *nn = arg;
+	int pxm, nid = nn->nid;
 
-	if (nid == NUMA_NO_NODE || action != MEM_ONLINE)
+	if (action != NODE_ADDED_FIRST_MEMORY)
 		return NOTIFY_OK;
 
 	pxm = node_to_pxm(nid);
@@ -1118,7 +1118,7 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
+	if (hotplug_node_notifier(hmat_callback, HMAT_CALLBACK_PRI))
 		goto out_put;
 
 	if (!hmat_set_default_dram_perf())
_

Patches currently in -mm which might be from osalvador@suse.de are


