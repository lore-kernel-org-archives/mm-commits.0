From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:51 -0800
Message-ID: <548d0d53.V4C2APgFPD/+TXyq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaLNEIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: support allocating obj with size of ZS_MAX_ALLOC_SIZE
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: support allocating obj with size of ZS_MAX_ALLOC_SIZE

I sent a patch [1] for unnecessary check in zsmalloc.  And Minchan Kim
found zsmalloc even does not support allocating an obj with the size of
ZS_MAX_ALLOC_SIZE in some situations.

For example:
   In system with 64KB PAGE_SIZE and 32 bit of physical addr. Then:
   ZS_MIN_ALLOC_SIZE is 32 bytes which is calculated by:
      MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
   ZS_MAX_ALLOC_SIZE is 64KB(in current code, is PAGE_SIZE)
   ZS_SIZE_CLASS_DELTA is 256 bytes
   So, ZS_SIZE_CLASSES = (ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) /
                          ZS_SIZE_CLASS_DELTA + 1
                       = 256

   In zs_create_pool(), the max size obj which can be allocated will be:
      ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA = 32 + 255*256 = 65312

   We can see that 65312 < 65536 (ZS_MAX_ALLOC_SIZE). So we can NOT
   allocate objs with size ZS_MAX_ALLOC_SIZE(65536) which we promise upper
   users we can do.

 [1]  http://lkml.iu.edu/hypermail/linux/kernel/1411.2/03835.html
 [2]  http://lkml.iu.edu/hypermail/linux/kernel/1411.2/04534.html

This patch fixes this issue by dynamiclly calculating zs_size_classes when
module is loaded, allocates buffer with size ZS_MAX_ALLOC_SIZE.  Then the
max obj(size is ZS_MAX_ALLOC_SIZE) can be stored in it.

[akpm@linux-foundation.org: restore ZS_SIZE_CLASSES to fix bisectability]
Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size
+++ a/mm/zsmalloc.c
@@ -171,6 +171,11 @@ enum fullness_group {
 };
 
 /*
+ * number of size_classes
+ */
+static int zs_size_classes;
+
+/*
  * We assign a page to ZS_ALMOST_EMPTY fullness group when:
  *	n <= N / f, where
  * n = number of allocated objects
@@ -214,7 +219,7 @@ struct link_free {
 };
 
 struct zs_pool {
-	struct size_class *size_class[ZS_SIZE_CLASSES];
+	struct size_class **size_class;
 
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
@@ -785,7 +790,7 @@ static inline int __zs_cpu_up(struct map
 	 */
 	if (area->vm_buf)
 		return 0;
-	area->vm_buf = (char *)__get_free_page(GFP_KERNEL);
+	area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE, GFP_KERNEL);
 	if (!area->vm_buf)
 		return -ENOMEM;
 	return 0;
@@ -793,8 +798,7 @@ static inline int __zs_cpu_up(struct map
 
 static inline void __zs_cpu_down(struct mapping_area *area)
 {
-	if (area->vm_buf)
-		free_page((unsigned long)area->vm_buf);
+	kfree(area->vm_buf);
 	area->vm_buf = NULL;
 }
 
@@ -912,6 +916,17 @@ static int zs_register_cpu_notifier(void
 	return notifier_to_errno(ret);
 }
 
+static void init_zs_size_classes(void)
+{
+	int nr;
+
+	nr = (ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1;
+	if ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) % ZS_SIZE_CLASS_DELTA)
+		nr += 1;
+
+	zs_size_classes = nr;
+}
+
 static void __exit zs_exit(void)
 {
 #ifdef CONFIG_ZPOOL
@@ -929,6 +944,8 @@ static int __init zs_init(void)
 		return ret;
 	}
 
+	init_zs_size_classes();
+
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
@@ -972,11 +989,18 @@ struct zs_pool *zs_create_pool(gfp_t fla
 	if (!pool)
 		return NULL;
 
+	pool->size_class = kcalloc(zs_size_classes, sizeof(struct size_class *),
+			GFP_KERNEL);
+	if (!pool->size_class) {
+		kfree(pool);
+		return NULL;
+	}
+
 	/*
 	 * Iterate reversly, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
 	 */
-	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
+	for (i = zs_size_classes - 1; i >= 0; i--) {
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
@@ -1029,7 +1053,7 @@ void zs_destroy_pool(struct zs_pool *poo
 {
 	int i;
 
-	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
+	for (i = 0; i < zs_size_classes; i++) {
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
@@ -1047,6 +1071,8 @@ void zs_destroy_pool(struct zs_pool *poo
 		}
 		kfree(class);
 	}
+
+	kfree(pool->size_class);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

