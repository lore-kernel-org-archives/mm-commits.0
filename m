Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BFE1D54FA
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449998; cv=none; b=KCsOuAgLDjIH5QRW73aAgXCZSfFkz0B+oCsJFNtfGMKWyglBE5F3OJ9oic5sNYocEzeBy55trtKfGnwRmR/rxwYyAvKbnx9I49bb7gTxl7r3LzOtkbKSZ4CKHFoTj/GM9+SJCgKs2ftIeucuAE0oMElF5BBzydlg0uWNH65Aqqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449998; c=relaxed/simple;
	bh=yg0qXIsnhWtJCEgd7rpIzWfKF9T5H3+q1WTUQ82BFtE=;
	h=Date:To:From:Subject:Message-Id; b=ptLWwRO2ZhH1FKAD6jw3QmnhMJaS/RCPdW4SL0euYfJp3hwckzWd0woB6OE4JktwM8EpQtzWBEpN3SK2MjO7g90rPo9EVHYHevuUtTzBvWNKUUlVMKJnC3uh70SHwYXDWNwCr+Agyyswyt3hNjkgJywjPCyVwTpdCYHcQ7TjaTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qH/iDCE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qH/iDCE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5B9C4CEE3;
	Sun, 13 Jul 2025 23:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449998;
	bh=yg0qXIsnhWtJCEgd7rpIzWfKF9T5H3+q1WTUQ82BFtE=;
	h=Date:To:From:Subject:From;
	b=qH/iDCE30UfwUoJb73z+mDzdyBzLSaZ6kSCVHMI+TxqOU8t/v5jgNF6iAV+iicLXq
	 TkdTvUpt/JXPWRK5zO4NnMCmNLoVxRA1IHHg7qQBo8Rdeh8JTD+m9Uq8sBlx70xCi+
	 DA7Zo9coQGbaZH8mjlTg3gFptJOoZ8YYzQScB5DA=
Date: Sun, 13 Jul 2025 16:39:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmslub-use-node-notifier-instead-of-memory-notifier.patch removed from -mm tree
Message-Id: <20250713233958.1B5B9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,slub: use node-notifier instead of memory-notifier
has been removed from the -mm tree.  Its filename was
     mmslub-use-node-notifier-instead-of-memory-notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,slub: use node-notifier instead of memory-notifier
Date: Mon, 16 Jun 2025 15:51:47 +0200

slub is only concerned when a numa node changes its memory state, so stop
using the memory notifier and use the new numa node notifer instead.

[akpm@linux-foundation.org: slub.c needs node.h for struct node_notify]
  Link: https://lore.kernel.org/oe-kbuild-all/202506202144.dGkFxasv-lkp@intel.com/
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

 mm/slub.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/mm/slub.c~mmslub-use-node-notifier-instead-of-memory-notifier
+++ a/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/kasan.h>
+#include <linux/node.h>
 #include <linux/kmsan.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
@@ -6149,7 +6150,7 @@ int __kmem_cache_shrink(struct kmem_cach
 	return __kmem_cache_do_shrink(s);
 }
 
-static int slab_mem_going_offline_callback(void *arg)
+static int slab_mem_going_offline_callback(void)
 {
 	struct kmem_cache *s;
 
@@ -6163,22 +6164,13 @@ static int slab_mem_going_offline_callba
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
@@ -6217,17 +6209,16 @@ out:
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
@@ -6303,7 +6294,7 @@ void __init kmem_cache_init(void)
 			sizeof(struct kmem_cache_node),
 			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
-	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
+	hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
 	/* Able to allocate the per node structures */
 	slab_state = PARTIAL;
_

Patches currently in -mm which might be from osalvador@suse.de are


