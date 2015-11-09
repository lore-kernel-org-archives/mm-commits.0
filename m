From: akpm@linux-foundation.org
Subject: [merged]
 zram-introduce-comp-algorithm-fallback-functionality.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:50 -0800
Message-ID: <5640f7b2.eqHCbIQwQWyRQQt8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbKITou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luis.henriques@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce comp algorithm fallback functionality
has been removed from the -mm tree.  Its filename was
     zram-introduce-comp-algorithm-fallback-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: zram: introduce comp algorithm fallback functionality

When the user supplies an unsupported compression algorithm, keep the
previously selected one (knowingly supported) or the default one (if the
compression algorithm hasn't been changed yet).

Note that previously this operation (i.e. setting an invalid algorithm)
would result in no algorithm being selected, which means that this
represents a small change in the default behaviour.

Minchan said:

For initializing zram, we need to set up 3 optional parameters in advance.

1. the number of compression streams
2. memory limitation
3. compression algorithm

Although user pass completely wrong value to set up for 1 and 2
parameters, it's okay because they have default value so zram will be
initialized with the default value (of course, when user passes a wrong
value via *echo*, sysfs returns -EINVAL so the user can notice it).

But 3 is not consistent with other optional parameters.  IOW, if the
user passes a wrong value to set up 3 parameter, zram's initialization
would fail unlike other optional parameters.

So this patch makes them consistent.

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
