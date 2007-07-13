From: akpm@linux-foundation.org
Subject: + uml-limit-request-size-on-cowed-devices.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:54:27 -0700
Message-ID: <200707131854.l6DIsRMi012472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758251AbXGMSzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: limit request size on COWed devices
has been added to the -mm tree.  Its filename is
     uml-limit-request-size-on-cowed-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: limit request size on COWed devices
From: Jeff Dike <jdike@addtoit.com>

COWed devices can't handle more than 32 (64 on x86_64) sectors in one request
due to the size of the bitmap being carried around in the io_thread_req.

Enforce that by telling the block layer not to put too many sectors in
requests to COWed devices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 ++
 1 files changed, 2 insertions(+)

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

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
uml-xterm-driver-tidying.patch
uml-pty-channel-tidying.patch
uml-handle-errors-on-opening-host-side-of-consoles.patch
uml-sigio-support-cleanup.patch
uml-simplify-helper-stack-handling.patch
uml-eliminate-kernel-allocator-wrappers.patch
uml-export-hostfs-symbols.patch
uml-limit-request-size-on-cowed-devices.patch
uml-remove-dead-file.patch
