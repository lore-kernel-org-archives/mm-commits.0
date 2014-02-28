From: akpm@linux-foundation.org
Subject: + zram-use-zcomp-compressing-backends.patch added to -mm tree
Date: Fri, 28 Feb 2014 15:52:36 -0800
Message-ID: <53112144.tK6AYnTct+AnDm8h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaB1Xwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-use-zcomp-compressing-backends.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:52:36 -0800


The patch titled
     Subject: zram: use zcomp compressing backends
has been added to the -mm tree.  Its filename is
     zram-use-zcomp-compressing-backends.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-zcomp-compressing-backends.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-zcomp-compressing-backends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use zcomp compressing backends

Do not perform direct LZO compress/decompress calls, initialise
and use zcomp LZO backend (single compression stream) instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Makefile   |    2 -
 drivers/block/zram/zram_drv.c |   59 +++++++++++++-------------------
 drivers/block/zram/zram_drv.h |    8 ++--
 3 files changed, 29 insertions(+), 40 deletions(-)

diff -puN drivers/block/zram/Makefile~zram-use-zcomp-compressing-backends drivers/block/zram/Makefile
--- a/drivers/block/zram/Makefile~zram-use-zcomp-compressing-backends
+++ a/drivers/block/zram/Makefile
@@ -1,3 +1,3 @@
-zram-y	:=	zram_drv.o
+zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff -puN drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends
+++ a/drivers/block/zram/zram_drv.c
@@ -29,7 +29,6 @@
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <linux/lzo.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
@@ -38,6 +37,7 @@
 /* Globals */
 static int zram_major;
 static struct zram *zram_devices;
+static const char *default_compressor = "lzo";
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
@@ -160,8 +160,6 @@ static inline int valid_io_request(struc
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
 }
@@ -173,22 +171,11 @@ static struct zram_meta *zram_meta_alloc
 	if (!meta)
 		goto out;
 
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem)
-		goto free_meta;
-
-	meta->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!meta->compress_buffer) {
-		pr_err("Error allocating compressor buffer space\n");
-		goto free_workmem;
-	}
-
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
+		goto free_meta;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
@@ -198,15 +185,10 @@ static struct zram_meta *zram_meta_alloc
 	}
 
 	rwlock_init(&meta->tb_lock);
-	mutex_init(&meta->buffer_lock);
 	return meta;
 
 free_table:
 	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
 free_meta:
 	kfree(meta);
 	meta = NULL;
@@ -280,8 +262,7 @@ static void zram_free_page(struct zram *
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = LZO_E_OK;
-	size_t clen = PAGE_SIZE;
+	int ret = 0;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
@@ -301,12 +282,12 @@ static int zram_decompress_page(struct z
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = zcomp_decompress(zram->comp, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
@@ -349,7 +330,7 @@ static int zram_bvec_read(struct zram *z
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
+	if (unlikely(ret))
 		goto out_cleanup;
 
 	if (is_partial_io(bvec))
@@ -374,11 +355,10 @@ static int zram_bvec_write(struct zram *
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	struct zcomp_strm *zstrm;
 	bool locked = false;
 
 	page = bvec->bv_page;
-	src = meta->compress_buffer;
-
 	if (is_partial_io(bvec)) {
 		/*
 		 * This is a partial IO. We need to read the full page
@@ -394,7 +374,7 @@ static int zram_bvec_write(struct zram *
 			goto out;
 	}
 
-	mutex_lock(&meta->buffer_lock);
+	zstrm = zcomp_strm_find(zram->comp);
 	locked = true;
 	user_mem = kmap_atomic(page);
 
@@ -420,22 +400,20 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
 		uncmem = NULL;
 	}
 
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
-
+	src = zstrm->buffer;
 	if (unlikely(clen > max_zpage_size)) {
 		clen = PAGE_SIZE;
-		src = NULL;
 		if (is_partial_io(bvec))
 			src = uncmem;
 	}
@@ -457,6 +435,8 @@ static int zram_bvec_write(struct zram *
 		memcpy(cmem, src, clen);
 	}
 
+	zcomp_strm_release(zram->comp, zstrm);
+	locked = false;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -475,10 +455,9 @@ static int zram_bvec_write(struct zram *
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (locked)
-		mutex_unlock(&meta->buffer_lock);
+		zcomp_strm_release(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-
 	if (ret)
 		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
@@ -522,6 +501,7 @@ static void zram_reset_device(struct zra
 		zs_free(meta->mem_pool, handle);
 	}
 
+	zcomp_destroy(zram->comp);
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -550,9 +530,18 @@ static ssize_t disksize_store(struct dev
 		return -EBUSY;
 	}
 
+	zram->comp = zcomp_create(default_compressor);
+	if (!zram->comp) {
+		up_write(&zram->init_lock);
+		pr_info("Cannot initialise %s compressing backend\n",
+				default_compressor);
+		return -EINVAL;
+	}
+
 	disksize = PAGE_ALIGN(disksize);
 	zram->meta = zram_meta_alloc(disksize);
 	if (!zram->meta) {
+		zcomp_destroy(zram->comp);
 		up_write(&zram->init_lock);
 		return -ENOMEM;
 	}
diff -puN drivers/block/zram/zram_drv.h~zram-use-zcomp-compressing-backends drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-use-zcomp-compressing-backends
+++ a/drivers/block/zram/zram_drv.h
@@ -16,9 +16,10 @@
 #define _ZRAM_DRV_H_
 
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
 #include <linux/zsmalloc.h>
 
+#include "zcomp.h"
+
 /*
  * Some arbitrary value. This is just to catch
  * invalid value for num_devices module parameter.
@@ -81,17 +82,16 @@ struct zram_stats {
 
 struct zram_meta {
 	rwlock_t tb_lock;	/* protect table */
-	void *compress_workmem;
-	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
-	struct mutex buffer_lock; /* protect compress buffers */
 };
 
 struct zram {
 	struct zram_meta *meta;
 	struct request_queue *queue;
 	struct gendisk *disk;
+	struct zcomp *comp;
+
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch

