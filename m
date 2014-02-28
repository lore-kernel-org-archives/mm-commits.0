From: akpm@linux-foundation.org
Subject: + zram-introduce-compressing-backend-abstraction.patch added to
 -mm tree
Date: Fri, 28 Feb 2014 15:52:34 -0800
Message-ID: <53112142.tkTPQSgkvPu/KIJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaB1Xwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-introduce-compressing-backend-abstraction.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:52:34 -0800


The patch titled
     Subject: zram: introduce compressing backend abstraction
has been added to the -mm tree.  Its filename is
     zram-introduce-compressing-backend-abstraction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-compressing-backend-abstraction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-compressing-backend-abstraction.patch

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
Subject: zram: introduce compressing backend abstraction

ZRAM performs direct LZO compression algorithm calls, making it the one
and only option.  While LZO is generally performs well, LZ4 algorithm
tends to have a faster decompression (see http://code.google.com/p/lz4/
for full report)

	Name            Ratio  C.speed D.speed
	                        MB/s    MB/s
	LZ4 (r101)      2.084    422    1820
	LZO 2.06        2.106    414     600

Thus, users who have mostly read (decompress) usage scenarious or mixed
workflow (writes with relatively high read ops number) will benefit from
using LZ4 compression backend.

Introduce compressing backend abstraction zcomp in order to support
multiple compression algorithms with the following set of operations:

        .create
        .destroy
        .compress
        .decompress

Schematically zram write() usually contains the following steps:
0) preparation (decompression of partioal IO, etc.)
1) lock buffer_lock mutex (protects meta compress buffers)
2) compress (using meta compress buffers)
3) alloc and map zs_pool object
4) copy compressed data (from meta compress buffers) to object allocated by 3)
5) free previous pool page, assign a new one
6) unlock buffer_lock mutex

As we can see, compressing buffers must remain untouched from 1) to 4),
because, otherwise, concurrent write() can overwrite data.  At the same
time, zram_meta must be aware of a) specific compression algorithm memory
requirements and b) necessary locking to protect compression buffers.  To
remove requirement a) new struct zcomp_strm introduced, which contains a
compress/decompress `buffer' and compression algorithm `private' part. 
While struct zcomp implements zcomp_strm stream handling and locking and
removes requirement b) from zram meta.  zcomp ->create() and ->destroy(),
respectively, allocate and deallocate algorithm specific zcomp_strm
`private' part.

Every zcomp has zcomp stream and mutex to protect its compression stream. 
Stream usage semantics remains the same -- only one write can hold stream
lock and use its buffers.  zcomp_strm_find() turns caller into exclusive
user of a stream (holding stream mutex until zram release stream), and
zcomp_strm_release() makes zcomp stream available (unlock the stream
mutex).  Hence no concurrent write (compression) operations possible at
the moment.

iozone -t 3 -R -r 16K -s 60M -I +Z

       test            base           patched
--------------------------------------------------
  Initial write      597992.91       591660.58
        Rewrite      609674.34       616054.97
           Read     2404771.75      2452909.12
        Re-read     2459216.81      2470074.44
   Reverse Read     1652769.66      1589128.66
    Stride read     2202441.81      2202173.31
    Random read     2236311.47      2276565.31
 Mixed workload     1423760.41      1709760.06
   Random write      579584.08       615933.86
         Pwrite      597550.02       594933.70
          Pread     1703672.53      1718126.72
         Fwrite     1330497.06      1461054.00
          Fread     3922851.00      3957242.62

Usage examples:

	comp = zcomp_create(NAME) /* NAME e.g. "lzo" */

which initialises compressing backend if requested algorithm is supported.

Compress:
	zstrm = zcomp_strm_find(comp)
	zcomp_compress(comp, zstrm, src, &dst_len)
	[..] /* copy compressed data */
	zcomp_strm_release(comp, zstrm)

Decompress:
	zcomp_decompress(comp, src, src_len, dst);

Free compessing backend and its zcomp stream:
	zcomp_destroy(comp)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c     |  115 +++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h     |   58 +++++++++++++++
 drivers/block/zram/zcomp_lzo.c |   47 ++++++++++++
 drivers/block/zram/zcomp_lzo.h |   17 ++++
 4 files changed, 237 insertions(+)

diff -puN /dev/null drivers/block/zram/zcomp.c
--- /dev/null
+++ a/drivers/block/zram/zcomp.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+#include "zcomp.h"
+#include "zcomp_lzo.h"
+
+static struct zcomp_backend *find_backend(const char *compress)
+{
+	if (strncmp(compress, "lzo", 3) == 0)
+		return &zcomp_lzo;
+	return NULL;
+}
+
+static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	if (zstrm->private)
+		comp->backend->destroy(zstrm->private);
+	free_pages((unsigned long)zstrm->buffer, 1);
+	kfree(zstrm);
+}
+
+/*
+ * allocate new zcomp_strm structure with ->private initialized by
+ * backend, return NULL on error
+ */
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
+{
+	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
+	if (!zstrm)
+		return NULL;
+
+	zstrm->private = comp->backend->create();
+	/*
+	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
+	 * case when compressed size is larger than the original one
+	 */
+	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!zstrm->private || !zstrm->buffer) {
+		zcomp_strm_free(comp, zstrm);
+		zstrm = NULL;
+	}
+	return zstrm;
+}
+
+struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
+{
+	mutex_lock(&comp->strm_lock);
+	return comp->zstrm;
+}
+
+void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	mutex_unlock(&comp->strm_lock);
+}
+
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src, size_t *dst_len)
+{
+	return comp->backend->compress(src, zstrm->buffer, dst_len,
+			zstrm->private);
+}
+
+int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst)
+{
+	return comp->backend->decompress(src, src_len, dst);
+}
+
+void zcomp_destroy(struct zcomp *comp)
+{
+	zcomp_strm_free(comp, comp->zstrm);
+	kfree(comp);
+}
+
+/*
+ * search available compressors for requested algorithm.
+ * allocate new zcomp and initialize it. return NULL
+ * if requested algorithm is not supported or in case
+ * of init error
+ */
+struct zcomp *zcomp_create(const char *compress)
+{
+	struct zcomp *comp;
+	struct zcomp_backend *backend;
+
+	backend = find_backend(compress);
+	if (!backend)
+		return NULL;
+
+	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
+	if (!comp)
+		return NULL;
+
+	comp->backend = backend;
+	mutex_init(&comp->strm_lock);
+
+	comp->zstrm = zcomp_strm_alloc(comp);
+	if (!comp->zstrm) {
+		kfree(comp);
+		return NULL;
+	}
+	return comp;
+}
diff -puN /dev/null drivers/block/zram/zcomp.h
--- /dev/null
+++ a/drivers/block/zram/zcomp.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_H_
+#define _ZCOMP_H_
+
+#include <linux/mutex.h>
+
+struct zcomp_strm {
+	/* compression/decompression buffer */
+	void *buffer;
+	/*
+	 * The private data of the compression stream, only compression
+	 * stream backend can touch this (e.g. compression algorithm
+	 * working memory)
+	 */
+	void *private;
+};
+
+/* static compression backend */
+struct zcomp_backend {
+	int (*compress)(const unsigned char *src, unsigned char *dst,
+			size_t *dst_len, void *private);
+
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst);
+
+	void *(*create)(void);
+	void (*destroy)(void *private);
+
+	const char *name;
+};
+
+/* dynamic per-device compression frontend */
+struct zcomp {
+	struct mutex strm_lock;
+	struct zcomp_strm *zstrm;
+	struct zcomp_backend *backend;
+};
+
+struct zcomp *zcomp_create(const char *comp);
+void zcomp_destroy(struct zcomp *comp);
+
+struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
+void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
+
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src, size_t *dst_len);
+
+int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst);
+#endif /* _ZCOMP_H_ */
diff -puN /dev/null drivers/block/zram/zcomp_lzo.c
--- /dev/null
+++ a/drivers/block/zram/zcomp_lzo.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lzo.h>
+
+#include "zcomp_lzo.h"
+
+static void *lzo_create(void)
+{
+	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void lzo_destroy(void *private)
+{
+	kfree(private);
+}
+
+static int lzo_compress(const unsigned char *src, unsigned char *dst,
+		size_t *dst_len, void *private)
+{
+	int ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, private);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+static int lzo_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst)
+{
+	size_t dst_len = PAGE_SIZE;
+	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+struct zcomp_backend zcomp_lzo = {
+	.compress = lzo_compress,
+	.decompress = lzo_decompress,
+	.create = lzo_create,
+	.destroy = lzo_destroy,
+	.name = "lzo",
+};
diff -puN /dev/null drivers/block/zram/zcomp_lzo.h
--- /dev/null
+++ a/drivers/block/zram/zcomp_lzo.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_LZO_H_
+#define _ZCOMP_LZO_H_
+
+#include "zcomp.h"
+
+extern struct zcomp_backend zcomp_lzo;
+
+#endif /* _ZCOMP_LZO_H_ */
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

