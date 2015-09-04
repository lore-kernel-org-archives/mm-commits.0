From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:32:08 -0700
Message-ID: <55ea1be8.1O4UmqvuF+inHAfj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbbIDWcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: freeing const data pointers
has been removed from the -mm tree.  Its filename was
     genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch

This patch was dropped because it was folded into genalloc-add-support-of-multiple-gen_pools-per-device.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: genalloc: freeing const data pointers

"pool->name" can be kmalloc()ed or const so we need to free it with
kfree_const().

I also cleaned up the error path in devm_gen_pool_create() a bit.  With
the current code you have to change the kfree() in multiple places which
is bug prone (my first draft of this patch had a bug).

Fixes: e89a70fd54f2 ('genalloc: add support of multiple gen_pools per device')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device-fix-2 lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-support-of-multiple-gen_pools-per-device-fix-2
+++ a/lib/genalloc.c
@@ -253,7 +253,7 @@ void gen_pool_destroy(struct gen_pool *p
 
 		kfree(chunk);
 	}
-	kfree(pool->name);
+	kfree_const(pool->name);
 	kfree(pool);
 }
 EXPORT_SYMBOL(gen_pool_destroy);
@@ -632,23 +632,25 @@ struct gen_pool *devm_gen_pool_create(st
 	}
 
 	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr) {
-		kfree(pool_name);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!ptr)
+		goto free_pool_name;
 
 	pool = gen_pool_create(min_alloc_order, nid);
-	if (pool) {
-		*ptr = pool;
-		pool->name = pool_name;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-		kfree(pool_name);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!pool)
+		goto free_devres;
+
+	*ptr = pool;
+	pool->name = pool_name;
+	devres_add(dev, ptr);
 
 	return pool;
+
+free_devres:
+	devres_free(ptr);
+free_pool_name:
+	kfree_const(pool_name);
+
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(devm_gen_pool_create);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

genalloc-add-support-of-multiple-gen_pools-per-device.patch

