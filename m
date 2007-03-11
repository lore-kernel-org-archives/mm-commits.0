From: akpm@linux-foundation.org
Subject: + drivers-char-synclinkc-check-kmalloc-return-value.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:00:04 -0800
Message-ID: <200703110900.l2B9031R008278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbXCKJAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit2030@gmail.com, paulkf@microgate.com


The patch titled
     drivers/char/synclink.c: check kmalloc() return value
has been added to the -mm tree.  Its filename is
     drivers-char-synclinkc-check-kmalloc-return-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/synclink.c: check kmalloc() return value
From: Amit Choudhary <amit2030@gmail.com>

Signed-off-by: Amit Choudhary <amit2030@gmail.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/synclink.c~drivers-char-synclinkc-check-kmalloc-return-value drivers/char/synclink.c
--- a/drivers/char/synclink.c~drivers-char-synclinkc-check-kmalloc-return-value
+++ a/drivers/char/synclink.c
@@ -4010,8 +4010,13 @@ static int mgsl_alloc_intermediate_txbuf
 	for ( i=0; i<info->num_tx_holding_buffers; ++i) {
 		info->tx_holding_buffers[i].buffer =
 			kmalloc(info->max_frame_size, GFP_KERNEL);
-		if ( info->tx_holding_buffers[i].buffer == NULL )
+		if (info->tx_holding_buffers[i].buffer == NULL) {
+			for (--i; i >= 0; i--) {
+				kfree(info->tx_holding_buffers[i].buffer);
+				info->tx_holding_buffers[i].buffer = NULL;
+			}
 			return -ENOMEM;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from amit2030@gmail.com are

drivers-char-synclinkc-check-kmalloc-return-value.patch
