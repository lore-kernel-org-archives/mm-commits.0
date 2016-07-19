From: akpm@linux-foundation.org
Subject: [merged] nvme-dont-allocate-unused-nvme_major.patch removed from
 -mm tree
Date: Tue, 19 Jul 2016 11:10:43 -0700
Message-ID: <578e6d23.yDSHyFxddvvUnPTa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbcGSSKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, axboe@kernel.dk, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: NVMe: don't allocate unused nvme_major
has been removed from the -mm tree.  Its filename was
     nvme-dont-allocate-unused-nvme_major.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: NVMe: don't allocate unused nvme_major

When alloc_disk(0) is used, the ->major number is ignored.  All device
numbers are allocated with a major of BLOCK_EXT_MAJOR.

So remove all references to nvme_major.

[akpm@linux-foundation.org: one unregister_blkdev() was missed]
Link: http://lkml.kernel.org/r/20160602064318.4403.93301.stgit@noble
Signed-off-by: NeilBrown <neilb@suse.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/core.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major drivers/nvme/host/core.c
--- a/drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major
+++ a/drivers/nvme/host/core.c
@@ -53,9 +53,6 @@ module_param_named(max_retries, nvme_max
 MODULE_PARM_DESC(max_retries, "max number of retries a command may have");
 EXPORT_SYMBOL_GPL(nvme_max_retries);
 
-static int nvme_major;
-module_param(nvme_major, int, 0);
-
 static int nvme_char_major;
 module_param(nvme_char_major, int, 0);
 
@@ -1674,8 +1671,6 @@ static void nvme_alloc_ns(struct nvme_ct
 	blk_queue_logical_block_size(ns->queue, 1 << ns->lba_shift);
 	nvme_set_queue_limits(ctrl, ns->queue);
 
-	disk->major = nvme_major;
-	disk->first_minor = 0;
 	disk->fops = &nvme_fops;
 	disk->private_data = ns;
 	disk->queue = ns->queue;
@@ -2085,16 +2080,10 @@ int __init nvme_core_init(void)
 {
 	int result;
 
-	result = register_blkdev(nvme_major, "nvme");
-	if (result < 0)
-		return result;
-	else if (result > 0)
-		nvme_major = result;
-
 	result = __register_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme",
 							&nvme_dev_fops);
 	if (result < 0)
-		goto unregister_blkdev;
+		return result;
 	else if (result > 0)
 		nvme_char_major = result;
 
@@ -2108,8 +2097,6 @@ int __init nvme_core_init(void)
 
  unregister_chrdev:
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
- unregister_blkdev:
-	unregister_blkdev(nvme_major, "nvme");
 	return result;
 }
 
@@ -2117,7 +2104,6 @@ void nvme_core_exit(void)
 {
 	class_destroy(nvme_class);
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
-	unregister_blkdev(nvme_major, "nvme");
 }
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from neilb@suse.com are

memstick-dont-allocate-unused-major-for-ms_block.patch

