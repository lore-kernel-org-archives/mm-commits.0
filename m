From: akpm@linux-foundation.org
Subject: + documentation-dma-api-howtotxt-fix-misleading-example.patch added to -mm tree
Date: Tue, 12 Jul 2011 16:48:37 -0700
Message-ID: <201107122348.p6CNmbI4011730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740Ab1GLXs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 19:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mirq-linux@rere.qmqm.pl, fujita.tomonori@lab.ntt.co.jp


The patch titled
     Documentation/DMA-API-HOWTO.txt: fix misleading example
has been added to the -mm tree.  Its filename is
     documentation-dma-api-howtotxt-fix-misleading-example.patch

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

linux-next.patch
documentation-dma-api-howtotxt-fix-misleading-example.patch

