From: akpm@linux-foundation.org
Subject: + mm-zpool-use-workqueue-for-zpool_destroy.patch added to -mm
 tree
Date: Mon, 25 Apr 2016 14:48:09 -0700
Message-ID: <571e9099.DK94Xl5DBmAUBRF5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbcDYVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 17:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, yuzhao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: use workqueue for zpool_destroy
has been added to the -mm tree.  Its filename is
     mm-zpool-use-workqueue-for-zpool_destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-use-workqueue-for-zpool_destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-use-workqueue-for-zpool_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zpool: use workqueue for zpool_destroy

Add a work_struct to struct zpool, and change zpool_destroy_pool to defer
calling the pool implementation destroy.

The zsmalloc pool destroy function, which is one of the zpool
implementations, may sleep during destruction of the pool.  However zswap,
which uses zpool, may call zpool_destroy_pool from atomic context.  So we
need to defer the call to the zpool implementation to destroy the pool.

This is essentially the same as Yu Zhao's proposed patch to zsmalloc,
but moved to zpool.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/zpool.c~mm-zpool-use-workqueue-for-zpool_destroy mm/zpool.c
--- a/mm/zpool.c~mm-zpool-use-workqueue-for-zpool_destroy
+++ a/mm/zpool.c
@@ -23,6 +23,7 @@ struct zpool {
 	const struct zpool_ops *ops;
 
 	struct list_head list;
+	struct work_struct work;
 };
 
 static LIST_HEAD(drivers_head);
@@ -197,6 +198,15 @@ struct zpool *zpool_create_pool(const ch
 	return zpool;
 }
 
+static void zpool_destroy_pool_work(struct work_struct *work)
+{
+	struct zpool *zpool = container_of(work, struct zpool, work);
+
+	zpool->driver->destroy(zpool->pool);
+	zpool_put_driver(zpool->driver);
+	kfree(zpool);
+}
+
 /**
  * zpool_destroy_pool() - Destroy a zpool
  * @pool	The zpool to destroy.
@@ -204,7 +214,8 @@ struct zpool *zpool_create_pool(const ch
  * Implementations must guarantee this to be thread-safe,
  * however only when destroying different pools.  The same
  * pool should only be destroyed once, and should not be used
- * after it is destroyed.
+ * after it is destroyed.  This defers calling the implementation
+ * to a workqueue, so the implementation may sleep.
  *
  * This destroys an existing zpool.  The zpool should not be in use.
  */
@@ -215,9 +226,8 @@ void zpool_destroy_pool(struct zpool *zp
 	spin_lock(&pools_lock);
 	list_del(&zpool->list);
 	spin_unlock(&pools_lock);
-	zpool->driver->destroy(zpool->pool);
-	zpool_put_driver(zpool->driver);
-	kfree(zpool);
+	INIT_WORK(&zpool->work, zpool_destroy_pool_work);
+	schedule_work(&zpool->work);
 }
 
 /**
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zpool-use-workqueue-for-zpool_destroy.patch

