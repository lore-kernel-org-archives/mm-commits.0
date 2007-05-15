From: akpm@linux-foundation.org
Subject: + libata-add-human-readable-error-value-decoding-v2.patch added to -mm tree
Date: Mon, 14 May 2007 22:44:02 -0700
Message-ID: <200705150544.l4F5i1ID002501@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbXEOFoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     libata: add human-readable error value decoding (v2)
has been added to the -mm tree.  Its filename is
     libata-add-human-readable-error-value-decoding-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add human-readable error value decoding (v2)
From: Robert Hancock <hancockr@shaw.ca>

This version reduces the length of the SError parsed output strings
relative to the previous version of this patch.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-eh.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/ata/libata-eh.c~libata-add-human-readable-error-value-decoding-v2 drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~libata-add-human-readable-error-value-decoding-v2
+++ a/drivers/ata/libata-eh.c
@@ -1536,23 +1536,23 @@ static void ata_eh_report(struct ata_por
 	if (ehc->i.serror)
 		ata_port_printk(ap, KERN_ERR,
 		  "SError: {%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
-		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovDataErr " : "",
-		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovCommErr " : "",
-		  ehc->i.serror & SERR_DATA ? "UnrecovDataErr " : "",
-		  ehc->i.serror & SERR_PERSISTENT ? "PersistErr " : "",
-		  ehc->i.serror & SERR_PROTOCOL ? "ProtocolErr " : "",
-		  ehc->i.serror & SERR_INTERNAL ? "HostInternalErr " : "",
+		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
+		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
+		  ehc->i.serror & SERR_DATA ? "UnrecovData " : "",
+		  ehc->i.serror & SERR_PERSISTENT ? "Persist " : "",
+		  ehc->i.serror & SERR_PROTOCOL ? "Proto " : "",
+		  ehc->i.serror & SERR_INTERNAL ? "HostInt " : "",
 		  ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
-		  ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInternalErr " : "",
+		  ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInt " : "",
 		  ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
-		  ehc->i.serror & SERR_10B_8B_ERR ? "10B8BErr " : "",
-		  ehc->i.serror & SERR_DISPARITY ? "Disparity " : "",
-		  ehc->i.serror & SERR_CRC ? "CRCErr " : "",
-		  ehc->i.serror & SERR_HANDSHAKE ? "HandshakeErr " : "",
-		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeqErr " : "",
-		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr " : "",
-		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
-		  ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
+		  ehc->i.serror & SERR_10B_8B_ERR ? "10B8B " : "",
+		  ehc->i.serror & SERR_DISPARITY ? "Dispar " : "",
+		  ehc->i.serror & SERR_CRC ? "BadCRC " : "",
+		  ehc->i.serror & SERR_HANDSHAKE ? "Handshk " : "",
+		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeq " : "",
+		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
+		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
+		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "" );
 
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		static const char *dma_str[] = {
_

Patches currently in -mm which might be from hancockr@shaw.ca are

libata-add-human-readable-error-value-decoding.patch
libata-add-human-readable-error-value-decoding-v2.patch
