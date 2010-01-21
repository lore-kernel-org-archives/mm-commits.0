From: akpm@linux-foundation.org
Subject: [merged] scsi-remove-unnecessary-null-test.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:29:03 -0800
Message-ID: <201001212129.o0LLT3Cm030777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358Ab0AUV3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, James.Bottomley@HansenPartnership.com, kxie@chelsio.com, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org


The patch titled
     scsi: remove unnecessary NULL test
has been removed from the -mm tree.  Its filename was
     scsi-remove-unnecessary-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: remove unnecessary NULL test
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/cxgb3i/cxgb3i_pdu.c~scsi-remove-unnecessary-null-test drivers/scsi/cxgb3i/cxgb3i_pdu.c
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c~scsi-remove-unnecessary-null-test
+++ a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_con
 		skb = skb_peek(&c3cn->receive_queue);
 	}
 	read_unlock(&c3cn->callback_lock);
-	if (c3cn) {
-		c3cn->copied_seq += read;
-		cxgb3i_c3cn_rx_credits(c3cn, read);
-	}
+	c3cn->copied_seq += read;
+	cxgb3i_c3cn_rx_credits(c3cn, read);
 	conn->rxdata_octets += read;
 
 	if (err) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

