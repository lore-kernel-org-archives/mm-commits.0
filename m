From: akpm@linux-foundation.org
Subject: + zram-introduce-per-device-debug_stat-sysfs-node-update-2.patch
 added to -mm tree
Date: Wed, 18 May 2016 14:54:40 -0700
Message-ID: <573ce4a0.6k0WQ3h2+8o6FQvh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbcERVyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 17:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-per-device-debug_stat-sysfs-node-update-2
has been added to the -mm tree.  Its filename is
     zram-introduce-per-device-debug_stat-sysfs-node-update-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-per-device-debug_stat-sysfs-node-update-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-per-device-debug_stat-sysfs-node-update-2.patch

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
Subject: zram-introduce-per-device-debug_stat-sysfs-node-update-2

Link: http://lkml.kernel.org/r/20160513130358.631-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 drivers/block/zram/zram_drv.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-update-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-update-2
+++ a/drivers/block/zram/zram_drv.c
@@ -446,7 +446,7 @@ static ssize_t debug_stat_show(struct de
 	ret = scnprintf(buf, PAGE_SIZE,
 			"version: %d\n%8llu\n",
 			version,
-			(u64)atomic64_read(&zram->stats.writestall));
+			(u64)atomic64_read(&zram->stats.num_recompress));
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -737,12 +737,12 @@ compress_again:
 		zcomp_strm_release(zram->comp, zstrm);
 		zstrm = NULL;
 
-		atomic64_inc(&zram->stats.writestall);
-
 		handle = zs_malloc(meta->mem_pool, clen,
 				GFP_NOIO | __GFP_HIGHMEM);
-		if (handle)
+		if (handle) {
+			atomic64_inc(&zram->stats.num_recompress);
 			goto compress_again;
+		}
 
 		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
 			index, clen);
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-update-2 drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-update-2
+++ a/drivers/block/zram/zram_drv.h
@@ -85,7 +85,7 @@ struct zram_stats {
 	atomic64_t zero_pages;		/* no. of zero filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t writestall;		/* no. of write slow paths */
+	atomic64_t num_recompress;	/* no. of compression slow paths */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-require-gfp-in-zs_malloc.patch
zsmalloc-require-gfp-in-zs_malloc-v2.patch
zram-user-per-cpu-compression-streams.patch
zram-user-per-cpu-compression-streams-fix.patch
zram-remove-max_comp_streams-internals.patch
zram-introduce-per-device-debug_stat-sysfs-node.patch
zram-introduce-per-device-debug_stat-sysfs-node-update-2.patch

