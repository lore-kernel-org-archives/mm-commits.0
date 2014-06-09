From: akpm@linux-foundation.org
Subject: [merged] nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:41:41 -0700
Message-ID: <53960df5.SY0BVHEOYGDsF0Dk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaFITlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.clements@us.sios.com, hani@linux.com, Paul.Clements@steeleye.com, kroosec@gmail.com

Subject: [merged] nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch removed from -mm tree
To: kroosec@gmail.com,Paul.Clements@steeleye.com,hani@linux.com,paul.clements@us.sios.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:41 -0700


The patch titled
     Subject: nbd: zero from and len fields in NBD_CMD_DISCONNECT.
has been removed from the -mm tree.  Its filename was
     nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hani Benhabiles <kroosec@gmail.com>
Subject: nbd: zero from and len fields in NBD_CMD_DISCONNECT.

Len field is already set to zero, but not the from field which is sent as
0xfffffffffffffe00.  This makes no sense, and may cause confuse server
implementations doing sanity checks (qemu-nbd is an example.)

Signed-off-by: Hani Benhabiles <hani@linux.com>
Cc: Paul Clements <paul.clements@us.sios.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect
+++ a/drivers/block/nbd.c
@@ -243,14 +243,11 @@ static int nbd_send_req(struct nbd_devic
 	struct nbd_request request;
 	unsigned long size = blk_rq_bytes(req);
 
+	memset(&request, 0, sizeof(request));
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
 
-	if (nbd_cmd(req) == NBD_CMD_FLUSH) {
-		/* Other values are reserved for FLUSH requests.  */
-		request.from = 0;
-		request.len = 0;
-	} else {
+	if (nbd_cmd(req) != NBD_CMD_FLUSH && nbd_cmd(req) != NBD_CMD_DISC) {
 		request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
 		request.len = htonl(size);
 	}
_

Patches currently in -mm which might be from kroosec@gmail.com are

origin.patch

