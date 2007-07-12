From: akpm@linux-foundation.org
Subject: + incorrect-scsi-transfer-length-computation-from-odd.patch added to -mm tree
Date: Wed, 11 Jul 2007 18:03:42 -0700
Message-ID: <200707120103.l6C13gnB032093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbXGLBEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 21:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jli@greshamstorage.com


The patch titled
     Incorrect SCSI transfer length computation from odd sized scsi_execute_async() transfers.
has been added to the -mm tree.  Its filename is
     incorrect-scsi-transfer-length-computation-from-odd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -350,7 +350,7 @@ static int scsi_req_map_sg(struct reques
 	}
 
 	rq->buffer = rq->data = NULL;
-	rq->data_len = data_len;
+	rq->data_len = bufflen;
 	return 0;
 
 free_bios:
_

Patches currently in -mm which might be from jli@greshamstorage.com are

incorrect-scsi-transfer-length-computation-from-odd.patch
