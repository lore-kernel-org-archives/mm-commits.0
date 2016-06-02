From: akpm@linux-foundation.org
Subject: + nvme-dont-allocate-unused-nvme_major.patch added to -mm tree
Date: Thu, 02 Jun 2016 12:56:13 -0700
Message-ID: <57508f5d.VwYmDRcrwXoxybUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbcFBT4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: NVMe: don't allocate unused nvme_major
has been added to the -mm tree.  Its filename is
     nvme-dont-allocate-unused-nvme_major.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nvme-dont-allocate-unused-nvme_major.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nvme-dont-allocate-unused-nvme_major.patch

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
Subject: NVMe: don't allocate unused nvme_major

When alloc_disk(0) is used, the ->major number is ignored.  All device
numbers are allocated with a major of BLOCK_EXT_MAJOR.

So remove all references to nvme_major.

Link: http://lkml.kernel.org/r/20160602064318.4403.93301.stgit@noble
Signed-off-by: NeilBrown <neilb@suse.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/core.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major drivers/nvme/host/core.c
--- a/drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major
+++ a/drivers/nvme/host/core.c
@@ -47,9 +47,6 @@ unsigned char shutdown_timeout = 5;
 module_param(shutdown_timeout, byte, 0644);
 MODULE_PARM_DESC(shutdown_timeout, "timeout in seconds for controller shutdown");
 
-static int nvme_major;
-module_param(nvme_major, int, 0);
-
 static int nvme_char_major;
 module_param(nvme_char_major, int, 0);
 
@@ -1445,8 +1442,6 @@ static void nvme_alloc_ns(struct nvme_ct
 	blk_queue_logical_block_size(ns->queue, 1 << ns->lba_shift);
 	nvme_set_queue_limits(ctrl, ns->queue);
 
-	disk->major = nvme_major;
-	disk->first_minor = 0;
 	disk->fops = &nvme_fops;
 	disk->private_data = ns;
 	disk->queue = ns->queue;
@@ -1848,16 +1843,10 @@ int __init nvme_core_init(void)
 {
 	int result;
 
-	result = register_blkdev(nvme_major, "nvme");
-	if (result < 0)
-		return result;
-	else if (result > 0)
-		nvme_major = result;
