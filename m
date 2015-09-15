From: akpm@linux-foundation.org
Subject: + zram-introduce-comp-algorithm-fallback-functionality.patch
 added to -mm tree
Date: Tue, 15 Sep 2015 16:07:38 -0700
Message-ID: <55f8a4ba.Yw5HWIhCxVWnRQu7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbIOXHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 19:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luis.henriques@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce comp algorithm fallback functionality
has been added to the -mm tree.  Its filename is
     zram-introduce-comp-algorithm-fallback-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-comp-algorithm-fallback-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-comp-algorithm-fallback-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: zram: introduce comp algorithm fallback functionality

When the user supplies an unsupported compression algorithm, keep the
previously selected one (knowingly supported) or the default one (if the
compression algorithm hasn't been changed yet).

Note that previously this operation (i.e. setting an invalid algorithm)
would result in no algorithm being selected, which means that this
represents a small change in the default behaviour.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-comp-algorithm-fallback-functionality drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-comp-algorithm-fallback-functionality
+++ a/drivers/block/zram/zram_drv.c
@@ -365,6 +365,9 @@ static ssize_t comp_algorithm_store(stru
 	struct zram *zram = dev_to_zram(dev);
 	size_t sz;
 
+	if (!zcomp_available_algorithm(buf))
+		return -EINVAL;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
@@ -378,9 +381,6 @@ static ssize_t comp_algorithm_store(stru
 	if (sz > 0 && zram->compressor[sz - 1] == '\n')
 		zram->compressor[sz - 1] = 0x00;
 
-	if (!zcomp_available_algorithm(zram->compressor))
-		len = -EINVAL;
