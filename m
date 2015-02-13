From: akpm@linux-foundation.org
Subject: [merged] slub-fix-kmem_cache_shrink-return-value.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:20:33 -0800
Message-ID: <54de5c91.ma/R8OpOjJ85whOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbbBMUUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix kmem_cache_shrink return value
has been removed from the -mm tree.  Its filename was
     slub-fix-kmem_cache_shrink-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: fix kmem_cache_shrink return value

It is supposed to return 0 if the cache has no remaining objects and 1
otherwise, while currently it always returns 0.  Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-kmem_cache_shrink-return-value mm/slub.c
--- a/mm/slub.c~slub-fix-kmem_cache_shrink-return-value
+++ a/mm/slub.c
@@ -3379,6 +3379,7 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct list_head discard;
 	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
+	int ret = 0;
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
@@ -3425,9 +3426,12 @@ int __kmem_cache_shrink(struct kmem_cach
 		/* Release empty slabs */
 		list_for_each_entry_safe(page, t, &discard, lru)
 			discard_slab(s, page);
+
+		if (slabs_node(s, node))
+			ret = 1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int slab_mem_going_offline_callback(void *arg)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

