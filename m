From: akpm@linux-foundation.org
Subject: + zram-avoid-null-pointer-access-in-concurrent-situation.patch
 added to -mm tree
Date: Mon, 27 Oct 2014 15:51:28 -0700
Message-ID: <544ecc70.hOR0kttGLnnyiSmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaJ0Wv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 18:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: avoid NULL pointer access in concurrent situation
has been added to the -mm tree.  Its filename is
     zram-avoid-null-pointer-access-in-concurrent-situation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-avoid-null-pointer-access-in-concurrent-situation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-avoid-null-pointer-access-in-concurrent-situation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zram: avoid NULL pointer access in concurrent situation

There is a rare NULL pointer bug in mem_used_total_show() and
mem_used_max_store() in concurrent situation, like this:

zram is not initialized, process A is a mem_used_total reader which runs
periodically, while process B try to init zram.

	process A 				process B
access meta, get a NULL value
						init zram, done
init_done() is true
access meta->mem_pool, get a NULL pointer BUG

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-avoid-null-pointer-access-in-concurrent-situation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-avoid-null-pointer-access-in-concurrent-situation
+++ a/drivers/block/zram/zram_drv.c
@@ -99,11 +99,12 @@ static ssize_t mem_used_total_show(struc
 {
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
 
 	down_read(&zram->init_lock);
-	if (init_done(zram))
+	if (init_done(zram)) {
+		struct zram_meta *meta = zram->meta;
 		val = zs_get_total_pages(meta->mem_pool);
+	}
 	up_read(&zram->init_lock);
 
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
@@ -173,16 +174,17 @@ static ssize_t mem_used_max_store(struct
 	int err;
 	unsigned long val;
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
 
 	err = kstrtoul(buf, 10, &val);
 	if (err || val != 0)
 		return -EINVAL;
 
 	down_read(&zram->init_lock);
-	if (init_done(zram))
+	if (init_done(zram)) {
+		struct zram_meta *meta = zram->meta;
 		atomic_long_set(&zram->stats.max_used_pages,
 				zs_get_total_pages(meta->mem_pool));
+	}
 	up_read(&zram->init_lock);
 
 	return len;
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-avoid-null-pointer-access-in-concurrent-situation.patch
x86-cma-reserve-dma-contiguous-area-after-initmem_init.patch

