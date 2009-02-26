From: akpm@linux-foundation.org
Subject: + misdn-l1oip-reduce-stack-memory-footprint.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:17:01 -0800
Message-ID: <200902262217.n1QMH2GX028067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZBZWR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frank@f-seidel.de, kkeil@suse.de


The patch titled
     mISDN: l1oip: reduce stack memory footprint
has been added to the -mm tree.  Its filename is
     misdn-l1oip-reduce-stack-memory-footprint.patch

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
Subject: mISDN: l1oip: reduce stack memory footprint
From: Frank Seidel <frank@f-seidel.de>

Before: 1656 bytes on i386, now 164.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/l1oip_core.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/mISDN/l1oip_core.c~misdn-l1oip-reduce-stack-memory-footprint drivers/isdn/mISDN/l1oip_core.c
--- a/drivers/isdn/mISDN/l1oip_core.c~misdn-l1oip-reduce-stack-memory-footprint
+++ a/drivers/isdn/mISDN/l1oip_core.c
@@ -663,18 +663,28 @@ l1oip_socket_thread(void *data)
 	struct iovec iov;
 	mm_segment_t oldfs;
 	struct sockaddr_in sin_rx;
-	unsigned char recvbuf[1500];
+	unsigned char *recvbuf;
+	size_t recvbuf_size = 1500;
 	int recvlen;
 	struct socket *socket = NULL;
 	DECLARE_COMPLETION(wait);
 
+	/* allocate buffer memory */
+	recvbuf = kmalloc(recvbuf_size * sizeof(*recvbuf), GFP_KERNEL);
+	if (!recvbuf) {
+		printk(KERN_ERR "%s: Failed to allocate memory.\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* make daemon */
 	allow_signal(SIGTERM);
 
 	/* create socket */
 	if (sock_create(PF_INET, SOCK_DGRAM, IPPROTO_UDP, &socket)) {
 		printk(KERN_ERR "%s: Failed to create socket.\n", __func__);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	/* set incoming address */
@@ -730,10 +740,10 @@ l1oip_socket_thread(void *data)
 			__func__);
 	while (!signal_pending(current)) {
 		iov.iov_base = recvbuf;
-		iov.iov_len = sizeof(recvbuf);
+		iov.iov_len = recvbuf_size;
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
-		recvlen = sock_recvmsg(socket, &msg, sizeof(recvbuf), 0);
+		recvlen = sock_recvmsg(socket, &msg, recvbuf_size, 0);
 		set_fs(oldfs);
 		if (recvlen > 0) {
 			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
@@ -771,6 +781,9 @@ fail:
 	if (debug & DEBUG_L1OIP_SOCKET)
 		printk(KERN_DEBUG "%s: socket thread terminated\n",
 			__func__);
+
+out:
+	kfree(recvbuf);
 	return ret;
 }
 
_

Patches currently in -mm which might be from frank@f-seidel.de are

linux-next.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
misdn-l1oip-reduce-stack-memory-footprint-cleanup.patch
airo-reduce-stack-memory-footprint.patch

