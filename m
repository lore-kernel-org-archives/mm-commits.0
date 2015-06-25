From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-check-comp-algorithm-availability-earlier-v2.patch removed from -mm
 tree
Date: Thu, 25 Jun 2015 14:49:54 -0700
Message-ID: <558c7782.32bxORe8Fx+USLFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbFYVtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, m.jabrzyk@samsung.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-check-comp-algorithm-availability-earlier-v2
has been removed from the -mm tree.  Its filename was
     zram-check-comp-algorithm-availability-earlier-v2.patch

This patch was dropped because it was folded into zram-check-comp-algorithm-availability-earlier.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram-check-comp-algorithm-availability-earlier-v2

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |   10 +++++-----
 drivers/block/zram/zram_drv.c |    5 +----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-check-comp-algorithm-availability-earlier-v2 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-check-comp-algorithm-availability-earlier-v2
+++ a/drivers/block/zram/zcomp.c
@@ -286,6 +286,11 @@ ssize_t zcomp_available_show(const char
 	return sz;
 }
 
+bool zcomp_available_algorithm(const char *comp)
+{
+	return find_backend(comp) != NULL;
+}
+
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	return comp->set_max_streams(comp, num_strm);
@@ -320,11 +325,6 @@ void zcomp_destroy(struct zcomp *comp)
 	kfree(comp);
 }
 
-bool zcomp_available_algorithm(const char *comp)
-{
-	return find_backend(comp) != NULL;
-}
-
 /*
  * search available compressors for requested algorithm.
  * allocate new zcomp and initialize it. return compressing
diff -puN drivers/block/zram/zram_drv.c~zram-check-comp-algorithm-availability-earlier-v2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-check-comp-algorithm-availability-earlier-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -378,11 +378,8 @@ static ssize_t comp_algorithm_store(stru
 	if (sz > 0 && zram->compressor[sz - 1] == '\n')
 		zram->compressor[sz - 1] = 0x00;
 
-	if (!zcomp_available_algorithm(zram->compressor)) {
-		pr_err("Error: unavailable compression algorithm: %s\n",
-				zram->compressor);
+	if (!zcomp_available_algorithm(zram->compressor))
 		len = -EINVAL;
-	}
 
 	up_write(&zram->init_lock);
 	return len;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-add-compact-sysfs-entry-to-documentation.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-cosmetic-zram_bvec_write-cleanup.patch
zram-cut-trailing-newline-in-algorithm-name.patch
zram-check-comp-algorithm-availability-earlier.patch

