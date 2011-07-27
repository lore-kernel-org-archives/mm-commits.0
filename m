From: akpm@linux-foundation.org
Subject: [merged] documentation-dma-api-howtotxt-fix-misleading-example.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:13 -0700
Message-ID: <201107271928.p6RJRxtS003260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946Ab1G0T21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mirq-linux@rere.qmqm.pl, fujita.tomonori@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Documentation/DMA-API-HOWTO.txt: fix misleading example
has been removed from the -mm tree.  Its filename was
     documentation-dma-api-howtotxt-fix-misleading-example.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/DMA-API-HOWTO.txt: fix misleading example
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

See: DMA-API.txt, part Id, DMA_FROM_DEVICE description.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-fix-misleading-example Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howtotxt-fix-misleading-example
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -613,13 +613,13 @@ to use the dma_sync_*() interfaces.
 				pass_to_upper_layers(cp->rx_buf);
 				make_and_setup_new_rx_buf(cp);
 			} else {
-				/* Just sync the buffer and give it back
-				 * to the card.
+				/* CPU should not write to
+				 * DMA_FROM_DEVICE-mapped area,
+				 * so dma_sync_single_for_device() is
+				 * not needed here. It would be required
+				 * for DMA_BIDIRECTIONAL mapping if
+				 * the memory was modified.
 				 */
-				dma_sync_single_for_device(&cp->dev,
-							   cp->rx_dma,
-							   cp->rx_len,
-							   DMA_FROM_DEVICE);
 				give_rx_buf_to_card(cp);
 			}
 		}
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

origin.patch

