From: akpm@linux-foundation.org
Subject: - block-genhdc-check-class_register-return-value.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:08 -0700
Message-ID: <200803131859.m2DIx8UL027934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbYCMTAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lpotenza@inwind.it, jeff@garzik.org, jens.axboe@oracle.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     block/genhd.c: check class_register return value
has been removed from the -mm tree.  Its filename was
     block-genhdc-check-class_register-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/genhd.c: check class_register return value
From: Leonardo Potenza <lpotenza@inwind.it>

Add a check for the class_register() return value.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~block-genhdc-check-class_register-return-value block/genhd.c
--- a/block/genhd.c~block-genhdc-check-class_register-return-value
+++ a/block/genhd.c
@@ -360,7 +360,12 @@ static struct kobject *base_probe(dev_t 
 
 static int __init genhd_device_init(void)
 {
-	class_register(&block_class);
+	int ret;
+
+	ret = class_register(&block_class);
+	if (ret != 0)
+		return ret;
+
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
 	blk_dev_init();
 
_

Patches currently in -mm which might be from lpotenza@inwind.it are


