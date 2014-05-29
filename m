From: akpm@linux-foundation.org
Subject: + nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch added
 to -mm tree
Date: Thu, 29 May 2014 14:59:57 -0700
Message-ID: <5387addd.yLTnON4t+viIYD70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019AbaE2V76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 17:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.clements@us.sios.com, hani@linux.com, Paul.Clements@steeleye.com, kroosec@gmail.com

Subject: + nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch added to -mm tree
To: kroosec@gmail.com,Paul.Clements@steeleye.com,hani@linux.com,paul.clements@us.sios.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 14:59:57 -0700


The patch titled
     Subject: nbd: zero from and len fields in NBD_CMD_DISCONNECT.
has been added to the -mm tree.  Its filename is
     nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nbd-zero-from-and-len-fields-in-nbd_cmd_disconnect.patch

