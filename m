From: akpm@linux-foundation.org
Subject: + zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch
 added to -mm tree
Date: Thu, 19 May 2016 14:54:13 -0700
Message-ID: <573e3605.tYAPxxxckTTbxHV6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbcESVyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 17:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: zram: introduce per-device debug_stat sysfs node
has been added to the -mm tree.  Its filename is
     zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Re: zram: introduce per-device debug_stat sysfs node

Fortunately, Andrew isn't pick up this patch yet so I want to replace
it to below suggested by Sergey which is better.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 drivers/block/zram/zram_drv.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-minchan drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-minchan
+++ a/drivers/block/zram/zram_drv.c
@@ -446,7 +446,7 @@ static ssize_t debug_stat_show(struct de
 	ret = scnprintf(buf, PAGE_SIZE,
 			"version: %d\n%8llu\n",
 			version,
-			(u64)atomic64_read(&zram->stats.num_recompress));
+			(u64)atomic64_read(&zram->stats.writestall));
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -737,12 +737,12 @@ compress_again:
 		zcomp_strm_release(zram->comp, zstrm);
 		zstrm = NULL;
 
+		atomic64_inc(&zram->stats.writestall);
+
 		handle = zs_malloc(meta->mem_pool, clen,
 				GFP_NOIO | __GFP_HIGHMEM);
-		if (handle) {
-			atomic64_inc(&zram->stats.num_recompress);
+		if (handle)
 			goto compress_again;
-		}
 
 		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
 			index, clen);
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-minchan drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-minchan
+++ a/drivers/block/zram/zram_drv.h
@@ -85,7 +85,7 @@ struct zram_stats {
 	atomic64_t zero_pages;		/* no. of zero filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t num_recompress;	/* no. of compression slow paths */
+	atomic64_t writestall;		/* no. of write slow paths */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-disable-fault-around-on-emulated-access-bit-architecture.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zram-introduce-per-device-debug_stat-sysfs-node-update.patch
zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch

