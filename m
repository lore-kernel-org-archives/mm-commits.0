Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA322DFA4
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749512282; cv=none; b=M19kaWcKn/Qh4Af1h+nCAE5kY/Ly81EJwSqzP62ojCq6vqCtU5pPSEau+HVkzXKJLS53Dbl9miAPw5W8jv2NZsXbJtHLuSV/NPCvXJlcGgp992UehJqYfwQw/BDPPWhUTPtLkuN/RKQHgEE1s1+J583iZcWtZwKRrGE5bA/d2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749512282; c=relaxed/simple;
	bh=toZ+cuIEAGG62F+teLYA/tdQ6WRAmgbvrh81i2Y5hsY=;
	h=Date:To:From:Subject:Message-Id; b=Dc2TSdY1YvuQf8GY4IYC+6DZr+BcSRXWkFY3+/IEqcBWsAXIcjHdNXwai3d0D390sUVDTsKiwr1LK+IQSbsiQKOo6wZH3Gie7RplRPj6cm7IFrTZGDRgU6Ut+CxdMzILNjcYzslQa1O2gGiOvXwrlHLMe5ampADKQwLHkcpk7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RVUi/x5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RVUi/x5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E2DC4CEEB;
	Mon,  9 Jun 2025 23:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749512282;
	bh=toZ+cuIEAGG62F+teLYA/tdQ6WRAmgbvrh81i2Y5hsY=;
	h=Date:To:From:Subject:From;
	b=RVUi/x5gZhtV0TEUamZIMyG82Fl+y9GLFKM53PG0e4Ne0gKvZQLXBOFiMhrjZj2xg
	 52z20Fyp8xZaZ7hCpw0tIMyq9Or0TOEqcJCPxLYlNlQmmKLvssEg9lFWyrrMNOMc6A
	 x6va670HPX+vO4S3P6DsY69i6VN0mP6VSgviXrtw=
Date: Mon, 09 Jun 2025 16:38:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmslub-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250609233801.E6E2DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,slub: use node-notifier instead of memory-notifier
has been added to the -mm mm-new branch.  Its filename is
     mmslub-use-node-notifier-instead-of-memory-notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmslub-use-node-notifier-instead-of-memory-notifier.patch

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
Subject: mm,slub: use node-notifier instead of memory-notifier
Date: Mon, 9 Jun 2025 11:21:41 +0200

slub is only concerned when a numa node changes its memory state, so stop
using the memory notifier and use the new numa node notifer instead.

Link: https://lkml.kernel.org/r/20250609092149.312114-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
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
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

