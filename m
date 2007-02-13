From: akpm@linux-foundation.org
Subject: + pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:32:43 -0800
Message-ID: <200702130532.l1D5Wh5H022691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161079AbXBMFeQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gd@spherenet.de, petero2@telia.com, stable@kernel.org


The patch titled
     pktcdvd: Correctly set cmd_len field in pkt_generic_packet
has been added to the -mm tree.  Its filename is
     pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pktcdvd: Correctly set cmd_len field in pkt_generic_packet
From: Gerhard Dirschl <gd@spherenet.de>

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=7810 - a silly
copy-paste bug introduced by the latest change.

Signed-off-by: Gerhard Dirschl <gd@spherenet.de>
Cc: Peter Osterlund <petero2@telia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet
+++ a/drivers/block/pktcdvd.c
@@ -765,7 +765,7 @@ static int pkt_generic_packet(struct pkt
 			goto out;
 	}
 
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
 		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
_

Patches currently in -mm which might be from gd@spherenet.de are

pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch
