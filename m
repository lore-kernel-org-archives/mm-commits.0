From: akpm@linux-foundation.org
Subject: +
 mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
 added to -mm tree
Date: Mon, 24 Nov 2014 14:00:33 -0800
Message-ID: <5473aa81.3a3Gia7OTN3nNbne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKXWAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: support allocating obj with size of ZS_MAX_ALLOC_SIZE
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size
+++ a/mm/zsmalloc.c
@@ -155,8 +155,6 @@
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
-#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
-					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
  * We do not maintain any list for completely empty or full pages
@@ -171,6 +169,11 @@ enum fullness_group {
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
@@ -214,7 +217,7 @@ struct link_free {
 };
 
 struct zs_pool {
-	struct size_class *size_class[ZS_SIZE_CLASSES];
+	struct size_class **size_class;
 
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
@@ -785,7 +788,7 @@ static inline int __zs_cpu_up(struct map
 	 */
 	if (area->vm_buf)
 		return 0;
-	area->vm_buf = (char *)__get_free_page(GFP_KERNEL);
+	area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE, GFP_KERNEL);
 	if (!area->vm_buf)
 		return -ENOMEM;
 	return 0;
@@ -793,8 +796,7 @@ static inline int __zs_cpu_up(struct map
 
 static inline void __zs_cpu_down(struct mapping_area *area)
 {
-	if (area->vm_buf)
-		free_page((unsigned long)area->vm_buf);
+	kfree(area->vm_buf);
 	area->vm_buf = NULL;
 }
 
@@ -912,6 +914,17 @@ static int zs_register_cpu_notifier(void
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
@@ -929,6 +942,8 @@ static int __init zs_init(void)
 		return ret;
 	}
 
+	init_zs_size_classes();
+
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
@@ -972,11 +987,18 @@ struct zs_pool *zs_create_pool(gfp_t fla
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
@@ -1029,7 +1051,7 @@ void zs_destroy_pool(struct zs_pool *poo
 {
 	int i;
 
-	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
+	for (i = 0; i < zs_size_classes; i++) {
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
@@ -1047,6 +1069,8 @@ void zs_destroy_pool(struct zs_pool *poo
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

zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

