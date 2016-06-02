From: akpm@linux-foundation.org
Subject: + memstick-dont-allocate-unused-major-for-ms_block.patch added to -mm tree
Date: Thu, 02 Jun 2016 12:56:11 -0700
Message-ID: <57508f5b.fsI5weBCc69ITc63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbcFBT4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: don't allocate unused major for ms_block
has been added to the -mm tree.  Its filename is
     memstick-dont-allocate-unused-major-for-ms_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-dont-allocate-unused-major-for-ms_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-dont-allocate-unused-major-for-ms_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: memstick: don't allocate unused major for ms_block

When alloc_disk(0) is used the ->major number is completely ignored.  All
devices are allocated with a major of BLOCK_EXT_MAJOR.

So remove registration and deregistration of 'major'.

Link: http://lkml.kernel.org/r/20160602064318.4403.49955.stgit@noble
Signed-off-by: NeilBrown <neilb@suse.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-dont-allocate-unused-major-for-ms_block drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-dont-allocate-unused-major-for-ms_block
+++ a/drivers/memstick/core/ms_block.c
@@ -2340,23 +2340,11 @@ static struct memstick_driver msb_driver
 	.resume   = msb_resume
 };
 
-static int major;
-
 static int __init msb_init(void)
 {
-	int rc = register_blkdev(0, DRIVER_NAME);
-
-	if (rc < 0) {
-		pr_err("failed to register major (error %d)\n", rc);
-		return rc;
-	}
-
-	major = rc;
-	rc = memstick_register_driver(&msb_driver);
-	if (rc) {
-		unregister_blkdev(major, DRIVER_NAME);
+	int rc = memstick_register_driver(&msb_driver);
+	if (rc)
 		pr_err("failed to register memstick driver (error %d)\n", rc);
-	}
 
 	return rc;
 }
@@ -2364,7 +2352,6 @@ static int __init msb_init(void)
 static void __exit msb_exit(void)
 {
 	memstick_unregister_driver(&msb_driver);
-	unregister_blkdev(major, DRIVER_NAME);
 	idr_destroy(&msb_disk_idr);
 }
 
_

Patches currently in -mm which might be from neilb@suse.com are

memstick-dont-allocate-unused-major-for-ms_block.patch
nvme-dont-allocate-unused-nvme_major.patch

