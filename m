Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EAC27CB1B
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749155984; cv=none; b=Tkcdk4e8O0Mn3VJEb9rX06fcfFtkz9kpEqlkh7pTs0z+EQzZjosEmEy6BdO+8NgzYGNgmW/PQlZLP/R6apRl1J8vBNkRPui3nmI31PulF0fAdIwAxqGDNdNDS2a4d43xruE2XuYt26Gc0SvpWIBPgDcixvhYAe7fidIIaKFgCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749155984; c=relaxed/simple;
	bh=kb0UXLtK+e0MwAZpR69L7P2j7jRlA90Xb4iGGN0/wik=;
	h=Date:To:From:Subject:Message-Id; b=S9Qq/1lcyQ8HaGdrv6856rBIrVRwFjnwoTVyyNxNKKrZPsT0GbsYMxIqgD2LFKy8lVpXDoAD932jwlIHb07GPtJ6iQsjWa7DW3Q17DBIAQLlIVjHHjR42pvz/Ix27/of8stxEtkxk3EKf1QCxV58Nru1B9B+BB19v0ujDvo3Iu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+qWYPjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+qWYPjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30611C4CEE7;
	Thu,  5 Jun 2025 20:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749155983;
	bh=kb0UXLtK+e0MwAZpR69L7P2j7jRlA90Xb4iGGN0/wik=;
	h=Date:To:From:Subject:From;
	b=M+qWYPjPFPaDeKIAESWdp3Cn1d0DAfdXLlybMgOOCGOCGqoIor5ztui7d/2ybhwxQ
	 Z/7pgDbwxKrBgzQpUw6ThO9CdpOuBJXE7h+8l1uANvKFAKLDzop+rDJMrVxBmKjwar
	 qPEr0KdT7QfjiAiCByqERmQOBhYeZJYgaxhllbyg=
Date: Thu, 05 Jun 2025 13:39:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmslub-use-node-notifier-instead-of-memory-notifier.patch added to mm-new branch
Message-Id: <20250605203943.30611C4CEE7@smtp.kernel.org>
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
Date: Thu, 5 Jun 2025 16:22:55 +0200

slub is only concerned when a numa node changes its memory state, so stop
using the memory notifier and use the new numa node notifer instead.

Link: https://lkml.kernel.org/r/20250605142305.244465-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/slub.c~mmslub-use-node-notifier-instead-of-memory-notifier
+++ a/mm/slub.c
@@ -6164,8 +6164,8 @@ static int slab_mem_going_online_callbac
 {
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
-	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	struct node_notify *narg = arg;
+	int nid = narg->nid;
 	int ret = 0;
 
 	/*
@@ -6217,15 +6217,12 @@ static int slab_memory_callback(struct n
 	int ret = 0;
 
 	switch (action) {
-	case MEM_GOING_ONLINE:
+	case NODE_ADDING_FIRST_MEMORY:
 		ret = slab_mem_going_online_callback(arg);
 		break;
-	case MEM_GOING_OFFLINE:
+	case NODE_REMOVING_LAST_MEMORY:
 		ret = slab_mem_going_offline_callback(arg);
 		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-		break;
 	}
 	if (ret)
 		ret = notifier_from_errno(ret);
@@ -6300,7 +6297,7 @@ void __init kmem_cache_init(void)
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
mmmemory_hotplug-rename-status_change_nid-parameter-in-memory_notify.patch

