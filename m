From: akpm@linux-foundation.org
Subject: + scsi-remove-unnecessary-null-test.patch added to -mm tree
Date: Thu, 10 Dec 2009 15:07:43 -0800
Message-ID: <200912102307.nBAN7hUo022997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090AbZLJXHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 18:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, jirislaby@gmail.com, michaelc@cs.wisc.edu


The patch titled
     scsi: remove unnecessary NULL test
has been added to the -mm tree.  Its filename is
     scsi-remove-unnecessary-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: remove unnecessary NULL test
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
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

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
scsi-remove-unnecessary-null-test.patch

