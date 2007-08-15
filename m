From: akpm@linux-foundation.org
Subject: - incorrect-scsi-transfer-length-computation-from-odd.patch removed from -mm tree
Date: Wed, 15 Aug 2007 16:34:44 -0700
Message-ID: <200708152334.l7FNYje4020830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760701AbXHOXfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jli@greshamstorage.com, mm-commits@vger.kernel.org


The patch titled
     Incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers.
has been removed from the -mm tree.  Its filename was
     incorrect-scsi-transfer-length-computation-from-odd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers.
From: Jeremy Linton <jli@greshamstorage.com>

Any function which use scsi_execute_async() and transfers "odd" sized data
that doesn't align correctly with the segment sizes may have its transfer
length padded out to the closest segment size.

For writes, this results in unnecessary data being transfered to the SCSI
target.  For reads, it affects the residual data length being returned to
the application since the residual length will be based on the padded
transfer size rather than the actual request size.

The easiest way to see this is by trying to read using the SG_IO ioctl a
large (>32k) buffer size from a tape device that only has a few bytes of
data stored for the current block.  The resulting resid will generally be
incorrect.

I've fixed this simply by changing scsi_req_map_sg() so that it places the
requested transfer length in rq->data_len rather than the sum of all the sg
segments.

Signed-off-by: Jeremy Linton <jli@greshamstorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~incorrect-scsi-transfer-length-computation-from-odd drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~incorrect-scsi-transfer-length-computation-from-odd
+++ a/drivers/scsi/scsi_lib.c
@@ -355,7 +355,7 @@ static int scsi_req_map_sg(struct reques
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:
_

Patches currently in -mm which might be from jli@greshamstorage.com are

incorrect-scsi-transfer-length-computation-from-odd.patch
