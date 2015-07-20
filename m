From: akpm@linux-foundation.org
Subject: +
 genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch added to
 -mm tree
Date: Mon, 20 Jul 2015 13:42:59 -0700
Message-ID: <55ad5d53.Vv4VPZdtiP8Th8Mq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbGTUnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 16:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: freeing const data pointers
has been added to the -mm tree.  Its filename is
     genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch
linux-next.patch

