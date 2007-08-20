From: akpm@linux-foundation.org
Subject: - scsi-fix-incorrect-scsi-transfer-length-computation-from-odd-sized-scsi_execute_async-transfers.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:38 -0700
Message-ID: <200708201913.l7KJDcnM018458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759944AbXHTTVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michaelc@cs.wisc.edu, James.Bottomley@steeleye.com, jli@greshamstorage.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers
has been removed from the -mm tree.  Its filename was
     scsi-fix-incorrect-scsi-transfer-length-computation-from-odd-sized-scsi_execute_async-transfers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: fix incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers
From: Mike Christie <michaelc@cs.wisc.edu>

sg's may have setup a the buffer with a different length than the transfer
length so we should be using the bufflen passed in as the request's data
len.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jeremy Linton <jli@greshamstorage.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-fix-incorrect-scsi-transfer-length-computation-from-odd-sized-scsi_execute_async-transfers drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-fix-incorrect-scsi-transfer-length-computation-from-odd-sized-scsi_execute_async-transfers
+++ a/drivers/scsi/scsi_lib.c
@@ -306,7 +306,7 @@ static int scsi_req_map_sg(struct reques
 {
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned int data_len = 0, len, bytes, off;
+	unsigned int data_len = bufflen, len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
@@ -315,10 +315,15 @@ static int scsi_req_map_sg(struct reques
 		page = sgl[i].page;
 		off = sgl[i].offset;
 		len = sgl[i].length;
-		data_len += len;
 
-		while (len > 0) {
+		while (len > 0 && data_len > 0) {
+			/*
+			 * sg sends a scatterlist that is larger than
+			 * the data_len it wants transferred for certain
+			 * IO sizes
+			 */
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+			bytes = min(bytes, data_len);
 
 			if (!bio) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
@@ -350,12 +355,13 @@ static int scsi_req_map_sg(struct reques
 
 			page++;
 			len -= bytes;
+			data_len -=bytes;
 			off = 0;
 		}
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:
_

Patches currently in -mm which might be from michaelc@cs.wisc.edu are

git-scsi-misc.patch
git-scsi-rc-fixes.patch
add-includes-to-scsi_transport_iscsih.patch
