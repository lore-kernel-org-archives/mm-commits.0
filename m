From: akpm@linux-foundation.org
Subject: [merged] memstick-dont-allocate-unused-major-for-ms_block.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:11:41 -0700
Message-ID: <57a233dd.SwWFaF+D8I6fQjIh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: don't allocate unused major for ms_block
has been removed from the -mm tree.  Its filename was
     memstick-dont-allocate-unused-major-for-ms_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2338,23 +2338,11 @@ static struct memstick_driver msb_driver
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
