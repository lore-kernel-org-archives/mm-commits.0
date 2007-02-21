From: akpm@linux-foundation.org
Subject: - pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:34 -0800
Message-ID: <200702211045.l1LAjYDk006380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813AbXBUKrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gd@spherenet.de, petero2@telia.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: Correctly set cmd_len field in pkt_generic_packet
has been removed from the -mm tree.  Its filename was
     pktcdvd-correctly-set-cmd_len-field-in-pkt_generic_packet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
