From: akpm@linux-foundation.org
Subject: - uml-limit-request-size-on-cowed-devices.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:34 -0700
Message-ID: <200707162051.l6GKpYEb001410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763824AbXGPVfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: limit request size on COWed devices
has been removed from the -mm tree.  Its filename was
     uml-limit-request-size-on-cowed-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: limit request size on COWed devices
From: Jeff Dike <jdike@addtoit.com>

COWed devices can't handle more than 32 (64 on x86_64) sectors in one request
due to the size of the bitmap being carried around in the io_thread_req.

Enforce that by telling the block layer not to put too many sectors in
requests to COWed devices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/drivers/ubd_kern.c~uml-limit-request-size-on-cowed-devices arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-limit-request-size-on-cowed-devices
+++ a/arch/um/drivers/ubd_kern.c
@@ -712,6 +712,8 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
+	if(ubd_dev->cow.file != NULL)
+		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
