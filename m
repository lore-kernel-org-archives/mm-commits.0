From: akpm@osdl.org
Subject: - ftp-get-or-put-stops-during-file-transfer.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:24 -0800
Message-ID: <200701092029.l09KTOJE014369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbXAIU3n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: craig@codefountain.com, mm-commits@vger.kernel.org


The patch titled
     ftp: get or put stops during file-transfer
has been removed from the -mm tree.  Its filename was
     ftp-get-or-put-stops-during-file-transfer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
