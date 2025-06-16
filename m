Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EF6136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117779; cv=none; b=qz+wj0E2vucC9WYqmOoi8Pd9ufY9fvVrA7QF6HcAewjEPVBr23KwXvfqWzt+/T74fs6PWsJA81Gdu5F1h+s5vOGGGnuuluQMOQQDFXWIrPZxrY/F4GuPE/EO8HuNGo43kciseD7EdoxqYZvehkcUqM++7dPzcJZWjKzxj9eATZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117779; c=relaxed/simple;
	bh=vc2APnrh7sKdZc4mh5vyVac6fjJ7oPvYLPA4+JyPP+I=;
	h=Date:To:From:Subject:Message-Id; b=jYL7Upn+8BAaQM8FM41Za3HcvAI7h7UJLyhxLHHlByByIWno2DwnE614YC+CGj6h1qK/DWXI7qUYOVgXip6kmV6Fed8XDUFLpTH0IZ8Pz3XoT+9E3gKsKqBLOu9DvjlRnLOXeH7qo6ulkoOuM6sqttQdUY3avMQGTXJoEua6nGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QswyhsLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QswyhsLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DBBC4CEEA;
	Mon, 16 Jun 2025 23:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117775;
	bh=vc2APnrh7sKdZc4mh5vyVac6fjJ7oPvYLPA4+JyPP+I=;
	h=Date:To:From:Subject:From;
	b=QswyhsLn6YN9CREOKgrBHv7LGjoPMOYmk1ba133lHatVCYjI0RgDBHAdqkuKvtC9D
	 9gfJo5OV1e/QUI6QYTWFDNv8ZAs4loiDRqJ9Kbgf+Y8SWCu1NwX+MBx8n+JAyNebMN
	 /Nt1+SU+LCjH3Dmby5DHgQd7lBSiTBUXW/MDbQBY=
Date: Mon, 16 Jun 2025 16:49:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch added to mm-unstable branch
Message-Id: <20250616234935.A8DBBC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory-tiers: use node-notifier instead of memory-notifier
has been added to the -mm mm-unstable branch.  Its filename is
     mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

