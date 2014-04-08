From: akpm@linux-foundation.org
Subject: [merged] zram-return-error-valued-pointer-from-zcomp_create.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:10:21 -0700
Message-ID: <534465bd.2Dzg2X3etrhU3D/E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbaDHVKV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:10:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, arnd@arndb.de, sergey.senozhatsky@gmail.com

Subject: [merged] zram-return-error-valued-pointer-from-zcomp_create.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,arnd@arndb.de,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:10:21 -0700


The patch titled
     Subject: zram: return error-valued pointer from zcomp_create()
has been removed from the -mm tree.  Its filename was
     zram-return-error-valued-pointer-from-zcomp_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: return error-valued pointer from zcomp_create()

Instead of returning just NULL, return ERR_PTR from zcomp_create() if
compressing backend creation has failed.  ERR_PTR(-EINVAL) for unsupported
compression algorithm request, ERR_PTR(-ENOMEM) for allocation (zcomp or
compression stream) error.

Perform IS_ERR() check of returned from zcomp_create() value in
disksize_store() and set return code to PTR_ERR().

Change suggested by Jerome Marchand.

[akpm@linux-foundation.org: clean up error recovery flow]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |   14 ++++++++------
 drivers/block/zram/zram_drv.c |   19 ++++++++++---------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-return-error-valued-pointer-from-zcomp_create
+++ a/drivers/block/zram/zcomp.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
@@ -319,9 +320,10 @@ void zcomp_destroy(struct zcomp *comp)
 
 /*
  * search available compressors for requested algorithm.
- * allocate new zcomp and initialize it. return NULL
- * if requested algorithm is not supported or in case
- * of init error
+ * allocate new zcomp and initialize it. return compressing
+ * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
+ * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
+ * case of allocation error.
  */
 struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
@@ -330,11 +332,11 @@ struct zcomp *zcomp_create(const char *c
 
 	backend = find_backend(compress);
 	if (!backend)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	comp->backend = backend;
 	if (max_strm > 1)
@@ -343,7 +345,7 @@ struct zcomp *zcomp_create(const char *c
 		zcomp_strm_single_create(comp);
 	if (!comp->stream) {
 		kfree(comp);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	return comp;
 }
diff -puN drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create
+++ a/drivers/block/zram/zram_drv.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 
 #include "zram_drv.h"
 
@@ -583,7 +584,7 @@ static ssize_t disksize_store(struct dev
 	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err = -EINVAL;
+	int err;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -595,18 +596,18 @@ static ssize_t disksize_store(struct dev
 		return -ENOMEM;
 
 	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!comp) {
+	if (IS_ERR(comp)) {
 		pr_info("Cannot initialise %s compressing backend\n",
 				zram->compressor);
-		goto out_cleanup;
+		err = PTR_ERR(comp);
+		goto out_free_meta;
 	}
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		err = -EBUSY;
-		goto out_cleanup;
+		goto out_destroy_comp;
 	}
 
 	zram->meta = meta;
@@ -614,12 +615,12 @@ static ssize_t disksize_store(struct dev
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
