From: akpm@osdl.org
Subject: + ftp-get-or-put-stops-during-file-transfer.patch added to -mm tree
Date: Mon, 08 Jan 2007 23:04:47 -0800
Message-ID: <200701090704.l0974lsF031068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXAIHEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 02:04:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: craig@codefountain.com


The patch titled
     ftp: get or put stops during file-transfer
has been added to the -mm tree.  Its filename is
     ftp-get-or-put-stops-during-file-transfer.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ftp: get or put stops during file-transfer
From: Craig Schlenter <craig@codefountain.com>

Signed-off-by: Craig Schlenter <craig@codefountain.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ipv4/tcp_ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/tcp_ipv4.c~ftp-get-or-put-stops-during-file-transfer net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~ftp-get-or-put-stops-during-file-transfer
+++ a/net/ipv4/tcp_ipv4.c
@@ -648,7 +648,7 @@ static void tcp_v4_send_ack(struct tcp_t
 				   TCPOLEN_TIMESTAMP);
 		rep.opt[1] = htonl(tcp_time_stamp);
 		rep.opt[2] = htonl(ts);
-		arg.iov[0].iov_len = TCPOLEN_TSTAMP_ALIGNED;
+		arg.iov[0].iov_len += TCPOLEN_TSTAMP_ALIGNED;
 	}
 
 	/* Swap the send and the receive. */
_

Patches currently in -mm which might be from craig@codefountain.com are

ftp-get-or-put-stops-during-file-transfer.patch
