Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D474136349
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750117774; cv=none; b=LdIbEteoBAQWiNfilpVb7IaqiYzluX0b4cRp+yEgju9PSUEgPvYf7Wthvt/IWJKVQngcxZ1mV8HLskcc9vCcwXPqr933D0fb5VZmYTIzg5kyfkX0J/eNEMseuYA/JtD+pW1oAcbscpNvyyHr4TGiSpNPEz6fD5ptis0Mi6Xl0iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750117774; c=relaxed/simple;
	bh=MumE0vBHW2xoTg6ESIixtISn+bi+Q0uB73OeS30t2dg=;
	h=Date:To:From:Subject:Message-Id; b=R8/467EMjnkDY34VhdtX6MTPWGuAE1A15jEL9WLO6plRFTnP8opPLj9XC3jnUPocOGUAvJubit/G7MQJzvlvltMvyuxgoU5jfA65YNLPexUsxRpl3o1XC/3JFi7zMk/lYA83XKLoRh7guQsmVvZRyy+TkasJThS/OguF08u7sTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMtqBuMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMtqBuMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD16C4CEEA;
	Mon, 16 Jun 2025 23:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750117773;
	bh=MumE0vBHW2xoTg6ESIixtISn+bi+Q0uB73OeS30t2dg=;
	h=Date:To:From:Subject:From;
	b=JMtqBuMyNMhfOnsC8IWsMW+8Yy02wkJKNtyfSeAdzqg1jgsbv0EVZH9WqI0JRavr7
	 pyi9FCg/pKtx6XW/GcPu3dBRDv74WSskBkfGeE8gOhEGGolKjqjeV5pKQb/T9DsscP
	 6wc7tuLo4lIVYDhYnVMXhZH9idAcl5MZBm0Ov1Dk=
Date: Mon, 16 Jun 2025 16:49:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmslub-use-node-notifier-instead-of-memory-notifier.patch added to mm-unstable branch
Message-Id: <20250616234933.CBD16C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,slub: use node-notifier instead of memory-notifier
has been added to the -mm mm-unstable branch.  Its filename is
     mmslub-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmslub-use-node-notifier-instead-of-memory-notifier.patch

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
Subject: mm,slub: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:47 +0200

slub is only concerned when a numa node changes its memory state, so stop
using the memory notifier and use the new numa node notifer instead.

Link: https://lkml.kernel.org/r/20250616135158.450136-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/mm/slub.c~mmslub-use-node-notifier-instead-of-memory-notifier
+++ a/mm/slub.c
@@ -6149,7 +6149,7 @@ int __kmem_cache_shrink(struct kmem_cach
 	return __kmem_cache_do_shrink(s);
 }
 
-static int slab_mem_going_offline_callback(void *arg)
+static int slab_mem_going_offline_callback(void)
 {
 	struct kmem_cache *s;
 
@@ -6163,22 +6163,13 @@ static int slab_mem_going_offline_callba
 	return 0;
 }
 
-static int slab_mem_going_online_callback(void *arg)
+static int slab_mem_going_online_callback(int nid)
 {
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
-	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
 	int ret = 0;
 
 	/*
-	 * If the node's memory is already available, then kmem_cache_node is
-	 * already created. Nothing to do.
-	 */
-	if (nid < 0)
-		return 0;
-
-	/*
 	 * We are bringing a node online. No memory is available yet. We must
 	 * allocate a kmem_cache_node structure in order to bring the node
 	 * online.
@@ -6217,17 +6208,16 @@ out:
 static int slab_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
+	struct node_notify *nn = arg;
+	int nid = nn->nid;
 	int ret = 0;
 
 	switch (action) {
-	case MEM_GOING_ONLINE:
-		ret = slab_mem_going_online_callback(arg);
-		break;
-	case MEM_GOING_OFFLINE:
-		ret = slab_mem_going_offline_callback(arg);
+	case NODE_ADDING_FIRST_MEMORY:
+		ret = slab_mem_going_online_callback(nid);
 		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
+	case NODE_REMOVING_LAST_MEMORY:
+		ret = slab_mem_going_offline_callback();
 		break;
 	}
 	if (ret)
@@ -6303,7 +6293,7 @@ void __init kmem_cache_init(void)
 			sizeof(struct kmem_cache_node),
 			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
-	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
+	hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
 	/* Able to allocate the per node structures */
 	slab_state = PARTIAL;
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

