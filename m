From: akpm@linux-foundation.org
Subject: + zram-try-vmalloc-after-kmalloc.patch added to -mm tree
Date: Mon, 30 Nov 2015 16:05:42 -0800
Message-ID: <565ce456.okSPI8KbIdW8lrhp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbbLAAFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:05:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyeongdon.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: try vmalloc() after kmalloc()
has been added to the -mm tree.  Its filename is
     zram-try-vmalloc-after-kmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-try-vmalloc-after-kmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-try-vmalloc-after-kmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kyeongdon Kim <kyeongdon.kim@lge.com>
Subject: zram: try vmalloc() after kmalloc()

When we're using LZ4 multi compression streams for zram swap, we found out
page allocation failure message in system running test.  That was not only
once, but a few(2 - 5 times per test).  Also, some failure cases were
continually occurring to try allocation order 3.

In order to make parallel compression private data, we should call
kzalloc() with order 2/3 in runtime(lzo/lz4).  But if there is no order
2/3 size memory to allocate in that time, page allocation fails.  This
patch makes to use vmalloc() as fallback of kmalloc(), this prevents page
alloc failure warning.

After using this, we never found warning message in running test, also It
could reduce process startup latency about 60-120ms in each case.

For reference a call trace :

Binder_1: page allocation failure: order:3, mode:0x10c0d0
CPU: 0 PID: 424 Comm: Binder_1 Tainted: GW 3.10.49-perf-g991d02b-dirty #20
Call trace:
[<ffffffc0002069c8>] dump_backtrace+0x0/0x270
[<ffffffc000206c48>] show_stack+0x10/0x1c
[<ffffffc000cb51c8>] dump_stack+0x1c/0x28
[<ffffffc0002bbfc8>] warn_alloc_failed+0xfc/0x11c
[<ffffffc0002bf518>] __alloc_pages_nodemask+0x724/0x7f0
[<ffffffc0002bf5f8>] __get_free_pages+0x14/0x5c
[<ffffffc0002ed6a4>] kmalloc_order_trace+0x38/0xd8
[<ffffffc0005d9738>] zcomp_lz4_create+0x2c/0x38
[<ffffffc0005d78f0>] zcomp_strm_alloc+0x34/0x78
[<ffffffc0005d7a58>] zcomp_strm_multi_find+0x124/0x1ec
[<ffffffc0005d7c14>] zcomp_strm_find+0xc/0x18
[<ffffffc0005d8fa0>] zram_bvec_rw+0x2fc/0x780
[<ffffffc0005d9680>] zram_make_request+0x25c/0x2d4
[<ffffffc00040f8ac>] generic_make_request+0x80/0xbc
[<ffffffc00040f98c>] submit_bio+0xa4/0x15c
[<ffffffc0002e8bb0>] __swap_writepage+0x218/0x230
[<ffffffc0002e8c04>] swap_writepage+0x3c/0x4c
[<ffffffc0002c7384>] shrink_page_list+0x51c/0x8d0
[<ffffffc0002c7e88>] shrink_inactive_list+0x3f8/0x60c
[<ffffffc0002c86c8>] shrink_lruvec+0x33c/0x4cc
[<ffffffc0002c8894>] shrink_zone+0x3c/0x100
[<ffffffc0002c8c10>] try_to_free_pages+0x2b8/0x54c
[<ffffffc0002bf308>] __alloc_pages_nodemask+0x514/0x7f0
[<ffffffc0002bf5f8>] __get_free_pages+0x14/0x5c
[<ffffffc0003446cc>] proc_info_read+0x50/0xe4
[<ffffffc0002f5204>] vfs_read+0xa0/0x12c
[<ffffffc0002f59c8>] SyS_read+0x44/0x74
DMA: 3397*4kB (MC) 26*8kB (RC) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB
     0*512kB 0*1024kB 0*2048kB 0*4096kB = 13796kB

[minchan@kernel.org: change vmalloc gfp and adding comment about gfp]
[sergey.senozhatsky@gmail.com: tweak comments and styles]
Signed-off-by: Kyeongdon Kim <kyeongdon.kim@lge.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp_lz4.c |   23 +++++++++++++++++++++--
 drivers/block/zram/zcomp_lzo.c |   23 +++++++++++++++++++++--
 2 files changed, 42 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zcomp_lz4.c~zram-try-vmalloc-after-kmalloc drivers/block/zram/zcomp_lz4.c
--- a/drivers/block/zram/zcomp_lz4.c~zram-try-vmalloc-after-kmalloc
+++ a/drivers/block/zram/zcomp_lz4.c
@@ -10,17 +10,36 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/lz4.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
 
 #include "zcomp_lz4.h"
 
 static void *zcomp_lz4_create(void)
 {
-	return kzalloc(LZ4_MEM_COMPRESS, GFP_NOIO);
+	void *ret;
+
+	/*
+	 * This function can be called in swapout/fs write path
+	 * so we can't use GFP_FS|IO. And it assumes we already
+	 * have at least one stream in zram initialization so we
+	 * don't do best effort to allocate more stream in here.
+	 * A default stream will work well without further multiple
+	 * streams. That's why we use NORETRY | NOWARN | NOMEMALLOC.
+	 */
+	ret = kzalloc(LZ4_MEM_COMPRESS, GFP_NOIO | __GFP_NORETRY |
+					__GFP_NOWARN | __GFP_NOMEMALLOC);
+	if (!ret)
+		ret = __vmalloc(LZ4_MEM_COMPRESS,
+				GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN |
+				__GFP_NOMEMALLOC | __GFP_ZERO | __GFP_HIGHMEM,
+				PAGE_KERNEL);
+	return ret;
 }
 
 static void zcomp_lz4_destroy(void *private)
 {
-	kfree(private);
+	kvfree(private);
 }
 
 static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
diff -puN drivers/block/zram/zcomp_lzo.c~zram-try-vmalloc-after-kmalloc drivers/block/zram/zcomp_lzo.c
--- a/drivers/block/zram/zcomp_lzo.c~zram-try-vmalloc-after-kmalloc
+++ a/drivers/block/zram/zcomp_lzo.c
@@ -10,17 +10,36 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/lzo.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
 
 #include "zcomp_lzo.h"
 
 static void *lzo_create(void)
 {
-	return kzalloc(LZO1X_MEM_COMPRESS, GFP_NOIO);
+	void *ret;
+
+	/*
+	 * This function can be called in swapout/fs write path
+	 * so we can't use GFP_FS|IO. And it assumes we already
+	 * have at least one stream in zram initialization so we
+	 * don't do best effort to allocate more stream in here.
+	 * A default stream will work well without further multiple
+	 * streams. That's why we use NORETRY | NOWARN | NOMEMALLOC.
+	 */
+	ret = kzalloc(LZO1X_MEM_COMPRESS, GFP_NOIO | __GFP_NORETRY |
+					__GFP_NOWARN | __GFP_NOMEMALLOC);
+	if (!ret)
+		ret = __vmalloc(LZO1X_MEM_COMPRESS,
+				GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN |
+				__GFP_NOMEMALLOC | __GFP_ZERO | __GFP_HIGHMEM,
+				PAGE_KERNEL);
+	return ret;
 }
 
 static void lzo_destroy(void *private)
 {
-	kfree(private);
+	kvfree(private);
 }
 
 static int lzo_compress(const unsigned char *src, unsigned char *dst,
_

Patches currently in -mm which might be from kyeongdon.kim@lge.com are

zram-try-vmalloc-after-kmalloc.patch

