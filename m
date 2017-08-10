From: akpm@linux-foundation.org
Subject: [patch 20/21] zram: rework copy of compressor name in
 comp_algorithm_store()
Date: Thu, 10 Aug 2017 15:24:29 -0700
Message-ID: <598cdd1d.p6kbkR6esx1STFuV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdHJWYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mka@chromium.org, dianders@chromium.org, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Matthias Kaehlcke <mka@chromium.org>
Subject: zram: rework copy of compressor name in comp_algorithm_store()

comp_algorithm_store() passes the size of the source buffer to strlcpy()
instead of the destination buffer size.  Make it explicit that the two
buffers have the same size and use strcpy() instead of strlcpy().  The
latter can be done safely since the function ensures that the string in
the source buffer is terminated.

Link: http://lkml.kernel.org/r/20170803163350.45245-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-copy-of-compressor-name-in-comp_algorithm_store drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-copy-of-compressor-name-in-comp_algorithm_store
+++ a/drivers/block/zram/zram_drv.c
@@ -308,7 +308,7 @@ static ssize_t comp_algorithm_store(stru
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	char compressor[CRYPTO_MAX_ALG_NAME];
+	char compressor[ARRAY_SIZE(zram->compressor)];
 	size_t sz;
 
 	strlcpy(compressor, buf, sizeof(compressor));
@@ -327,7 +327,7 @@ static ssize_t comp_algorithm_store(stru
 		return -EBUSY;
 	}
 
-	strlcpy(zram->compressor, compressor, sizeof(compressor));
+	strcpy(zram->compressor, compressor);
 	up_write(&zram->init_lock);
 	return len;
 }
_
