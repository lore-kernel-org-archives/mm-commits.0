From: akpm@linux-foundation.org
Subject: [merged] ipu_idmac-fix-spinlock-type.patch removed from -mm tree
Date: Wed, 04 Mar 2009 10:37:17 -0800
Message-ID: <200903041837.n24IbHXt020571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464AbZCDSlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 13:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.fu@pengutronix.de, dan.j.williams@intel.com, lg@denx.de, mm-commits@vger.kernel.org


The patch titled
     ipu_idmac: fix spinlock type
has been removed from the -mm tree.  Its filename was
     ipu_idmac-fix-spinlock-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipu_idmac: fix spinlock type
From: Luotao Fu <l.fu@pengutronix.de>

Fix a probably accidently dropped reference operator while calling
spin_unlock_restore to an ipu lock.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Cc: Guennadi Liakhovetski <lg@denx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ipu/ipu_idmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ipu/ipu_idmac.c~ipu_idmac-fix-spinlock-type drivers/dma/ipu/ipu_idmac.c
--- a/drivers/dma/ipu/ipu_idmac.c~ipu_idmac-fix-spinlock-type
+++ a/drivers/dma/ipu/ipu_idmac.c
@@ -729,7 +729,7 @@ static int ipu_init_channel_buffer(struc
 
 	ichan->status = IPU_CHANNEL_READY;
 
-	spin_unlock_irqrestore(ipu->lock, flags);
+	spin_unlock_irqrestore(&ipu->lock, flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from l.fu@pengutronix.de are

linux-next.patch

