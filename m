From: akpm@linux-foundation.org
Subject: + zram-add-lz4-algorithm-backend.patch added to -mm tree
Date: Fri, 28 Feb 2014 15:52:42 -0800
Message-ID: <5311214a.wXNUxHF60rLw8Mn2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaB1Xwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-add-lz4-algorithm-backend.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:52:42 -0800


The patch titled
     Subject: zram: add lz4 algorithm backend
has been added to the -mm tree.  Its filename is
     zram-add-lz4-algorithm-backend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-lz4-algorithm-backend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-lz4-algorithm-backend.patch

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
Subject: zram: add lz4 algorithm backend

Introduce LZ4 compression backend and make it available for selection. 
LZ4 support is optional and requires user to set ZRAM_LZ4_COMPRESS config
option.  The default compression backend is LZO.

TEST

(x86_64, core i5, 2 cores + 2 hyperthreading, zram disk size 1G,
ext4 file system, 3 compression streams)

iozone -t 3 -R -r 16K -s 60M -I +Z

       Test           LZO           LZ4
----------------------------------------------
  Initial write   1642744.62    1317005.09
        Rewrite   2498980.88    1800645.16
           Read   3957026.38    5877043.75
        Re-read   3950997.38    5861847.00
   Reverse Read   2937114.56    5047384.00
    Stride read   2948163.19    4929587.38
    Random read   3292692.69    4880793.62
 Mixed workload   1545602.62    3502940.38
   Random write   2448039.75    1758786.25
         Pwrite   1670051.03    1338329.69
          Pread   2530682.00    5097177.62
         Fwrite   3232085.62    3275942.56
          Fread   6306880.25    6645271.12

So on my system LZ4 is slower in write-only tests, while it performs
better in read-only and mixed (reads + writes) tests.

Official LZ4 benchmarks available here http://code.google.com/p/lz4/
(linux kernel uses revision r90).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig     |   10 ++++++
 drivers/block/zram/Makefile    |    2 +
 drivers/block/zram/zcomp.c     |    6 +++
 drivers/block/zram/zcomp_lz4.c |   47 +++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp_lz4.h |   17 +++++++++++
 5 files changed, 82 insertions(+)

diff -puN drivers/block/zram/Kconfig~zram-add-lz4-algorithm-backend drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-add-lz4-algorithm-backend
+++ a/drivers/block/zram/Kconfig
@@ -15,6 +15,16 @@ config ZRAM
 
 	  See zram.txt for more information.
 
+config ZRAM_LZ4_COMPRESS
+	bool "Enable LZ4 algorithm support"
+	depends on ZRAM
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	default n
+	help
+	  This option enables LZ4 compression algorithm support. Compression
+	  algorithm can be changed using `comp_algorithm' device attribute.
+
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
 	depends on ZRAM
diff -puN drivers/block/zram/Makefile~zram-add-lz4-algorithm-backend drivers/block/zram/Makefile
--- a/drivers/block/zram/Makefile~zram-add-lz4-algorithm-backend
+++ a/drivers/block/zram/Makefile
@@ -1,3 +1,5 @@
 zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
 
+zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
+
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff -puN drivers/block/zram/zcomp.c~zram-add-lz4-algorithm-backend drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-lz4-algorithm-backend
+++ a/drivers/block/zram/zcomp.c
@@ -15,6 +15,9 @@
 
 #include "zcomp.h"
 #include "zcomp_lzo.h"
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+#include "zcomp_lz4.h"
+#endif
 
 /*
  * single zcomp_strm backend
@@ -41,6 +44,9 @@ struct zcomp_strm_multi {
 
 static struct zcomp_backend *backends[] = {
 	&zcomp_lzo,
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+	&zcomp_lz4,
+#endif
 	NULL
 };
 
diff -puN /dev/null drivers/block/zram/zcomp_lz4.c
--- /dev/null
+++ a/drivers/block/zram/zcomp_lz4.c
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
+#include <linux/lz4.h>
+
+#include "zcomp_lz4.h"
+
+static void *zcomp_lz4_create(void)
+{
+	return kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void zcomp_lz4_destroy(void *private)
+{
+	kfree(private);
+}
+
+static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
+		size_t *dst_len, void *private)
+{
+	/* return  : Success if return 0 */
+	return lz4_compress(src, PAGE_SIZE, dst, dst_len, private);
+}
+
+static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst)
+{
+	size_t dst_len = PAGE_SIZE;
+	/* return  : Success if return 0 */
+	return lz4_decompress_unknownoutputsize(src, src_len, dst, &dst_len);
+}
+
+struct zcomp_backend zcomp_lz4 = {
+	.compress = zcomp_lz4_compress,
+	.decompress = zcomp_lz4_decompress,
+	.create = zcomp_lz4_create,
+	.destroy = zcomp_lz4_destroy,
+	.name = "lz4",
+};
diff -puN /dev/null drivers/block/zram/zcomp_lz4.h
--- /dev/null
+++ a/drivers/block/zram/zcomp_lz4.h
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
+#ifndef _ZCOMP_LZ4_H_
+#define _ZCOMP_LZ4_H_
+
+#include "zcomp.h"
+
+extern struct zcomp_backend zcomp_lz4;
+
+#endif /* _ZCOMP_LZ4_H_ */
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

