From: akpm@linux-foundation.org
Subject: [patch 029/111] memstick: don't allocate unused major for
 ms_block
Date: Tue, 02 Aug 2016 14:03:30 -0700
Message-ID: <57a10aa2.C1Quh56ZokxdPq3C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbcHBVRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, neilb@suse.com, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com

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
