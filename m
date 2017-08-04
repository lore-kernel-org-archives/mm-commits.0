From: akpm@linux-foundation.org
Subject: +
 zram-rework-copy-of-compressor-name-in-comp_algorithm_store.patch added to
 -mm tree
Date: Fri, 04 Aug 2017 16:47:16 -0700
Message-ID: <59850784.P5W6mcRWzodtzL1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753477AbdHDXrR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 19:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, dianders@chromium.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rework copy of compressor name in comp_algorithm_store()
has been added to the -mm tree.  Its filename is
     zram-rework-copy-of-compressor-name-in-comp_algorithm_store.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rework-copy-of-compressor-name-in-comp_algorithm_store.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rework-copy-of-compressor-name-in-comp_algorithm_store.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mka@chromium.org are

zram-rework-copy-of-compressor-name-in-comp_algorithm_store.patch
mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch
bitops-avoid-integer-overflow-in-genmask_ull.patch

