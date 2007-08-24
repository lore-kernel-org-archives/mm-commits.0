From: akpm@linux-foundation.org
Subject: - g_file_storage-fix-bug-in-dma-buffer-handling.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:46 -0700
Message-ID: <200708242058.l7OKwk6e014332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758431AbXHXVIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     g_file_storage: fix bug in DMA buffer handling
has been removed from the -mm tree.  Its filename was
     g_file_storage-fix-bug-in-dma-buffer-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
