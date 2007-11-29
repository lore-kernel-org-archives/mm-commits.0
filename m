From: akpm@linux-foundation.org
Subject: + r6040-compile-error.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:04:06 -0800
Message-ID: <200711292304.lATN46PU011954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934284AbXK2XEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:04:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     r6040: compile error
has been added to the -mm tree.  Its filename is
     r6040-compile-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
r6040-compile-error.patch
r6040-remove-virt_to_bus.patch
r6040-erroneous-dev-priv.patch
r6040-cleanups.patch
