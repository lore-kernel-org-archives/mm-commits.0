From: akpm@linux-foundation.org
Subject: [merged] misdn-l1oip-reduce-stack-memory-footprint.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:27 -0700
Message-ID: <200905261935.n4QJZR2i006339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbZEZTog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frank@f-seidel.de, kkeil@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     mISDN: l1oip: reduce stack memory footprint
has been removed from the -mm tree.  Its filename was
     misdn-l1oip-reduce-stack-memory-footprint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mISDN: l1oip: reduce stack memory footprint
From: Frank Seidel <frank@f-seidel.de>

Before: 1656 bytes on i386, now 164.

[akpm@linux-foundation.org: cleanuplet]
Signed-off-by: Frank Seidel <frank@f-seidel.de>
Cc: Karsten Keil <kkeil@linux-pingi.de>
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
+	recvbuf = kmalloc(recvbuf_size, GFP_KERNEL);
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

