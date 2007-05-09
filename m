From: akpm@linux-foundation.org
Subject: - drivers-char-synclinkc-check-kmalloc-return-value.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:28 -0700
Message-ID: <200705090246.l492kSsp008856@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176AbXEICqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit2030@gmail.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/synclink.c: check kmalloc() return value
has been removed from the -mm tree.  Its filename was
     drivers-char-synclinkc-check-kmalloc-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
