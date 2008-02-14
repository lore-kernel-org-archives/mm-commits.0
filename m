From: akpm@linux-foundation.org
Subject: + block-genhdc-check-class_register-return-value.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:10:59 -0800
Message-ID: <200802142111.m1ELAxIN003040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934274AbYBNVLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lpotenza@inwind.it, jens.axboe@oracle.com


The patch titled
     block/genhd.c: check class_register return value
has been added to the -mm tree.  Its filename is
     block-genhdc-check-class_register-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -358,7 +358,12 @@ static struct kobject *base_probe(dev_t 
 
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

block-genhdc-check-class_register-return-value.patch
