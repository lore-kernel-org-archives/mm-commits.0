From: akpm@linux-foundation.org
Subject: + g_file_storage-fix-bug-in-dma-buffer-handling.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:12:53 -0700
Message-ID: <200708172112.l7HLCrmw029668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897AbXHQVSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com


The patch titled
     g_file_storage: fix bug in DMA buffer handling
has been added to the -mm tree.  Its filename is
     g_file_storage-fix-bug-in-dma-buffer-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: g_file_storage: fix bug in DMA buffer handling
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as963) fixes a recently-introduced bug.  The gadget conversion
removing DMA-mapped buffer allocation did not remove quite enough code from
the g_file_storage driver; DMA pointers were being set to 0.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/file_storage.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/usb/gadget/file_storage.c~g_file_storage-fix-bug-in-dma-buffer-handling drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~g_file_storage-fix-bug-in-dma-buffer-handling
+++ a/drivers/usb/gadget/file_storage.c
@@ -576,7 +576,6 @@ enum fsg_buffer_state {
 
 struct fsg_buffhd {
 	void				*buf;
-	dma_addr_t			dma;
 	enum fsg_buffer_state		state;
 	struct fsg_buffhd		*next;
 
@@ -2570,7 +2569,6 @@ static int send_status(struct fsg_dev *f
 
 		fsg->intr_buffhd = bh;		// Point to the right buffhd
 		fsg->intreq->buf = bh->inreq->buf;
-		fsg->intreq->dma = bh->inreq->dma;
 		fsg->intreq->context = bh;
 		start_transfer(fsg, fsg->intr_in, fsg->intreq,
 				&fsg->intreq_busy, &bh->state);
@@ -3163,7 +3161,6 @@ reset:
 		if ((rc = alloc_request(fsg, fsg->bulk_out, &bh->outreq)) != 0)
 			goto reset;
 		bh->inreq->buf = bh->outreq->buf = bh->buf;
-		bh->inreq->dma = bh->outreq->dma = bh->dma;
 		bh->inreq->context = bh->outreq->context = bh;
 		bh->inreq->complete = bulk_in_complete;
 		bh->outreq->complete = bulk_out_complete;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch
usb-storage-fix-bugs-in-the-disconnect-pathway.patch
g_file_storage-fix-bug-in-dma-buffer-handling.patch
