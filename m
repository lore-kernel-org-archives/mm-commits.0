From: akpm@linux-foundation.org
Subject: - r6040-compile-error.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:32 -0800
Message-ID: <200712040738.lB47cWq7006908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbXLDHtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     r6040: compile error
has been removed from the -mm tree.  Its filename was
     r6040-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r6040: compile error
From: Francois Romieu <romieu@fr.zoreil.com>

drivers/net/r6040.c: In function 'rx_buf_alloc':
drivers/net/r6040.c:262: warning: passing argument 2 of 'pci_map_single' makes pointer from integer without a cast

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r6040.c~r6040-compile-error drivers/net/r6040.c
--- a/drivers/net/r6040.c~r6040-compile-error
+++ a/drivers/net/r6040.c
@@ -260,7 +260,7 @@ static void rx_buf_alloc(struct r6040_pr
 		if (!descptr->skb_ptr)
 			break;
 		descptr->buf = cpu_to_le32(pci_map_single(lp->pdev,
-			descptr->skb_ptr->tail,
+			descptr->skb_ptr->data,
 			MAX_BUF_SIZE, PCI_DMA_FROMDEVICE));
 		descptr->status = 0x8000;
 		descptr = descptr->vndescp;
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-netdev-all.patch
