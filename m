From: akpm@linux-foundation.org
Subject: - sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:15 -0700
Message-ID: <200805231859.m4NIxFmj004219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbYEWS7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: merge efx_page_offset() into efx_rx_buf_offset()
has been removed from the -mm tree.  Its filename was
     sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: merge efx_page_offset() into efx_rx_buf_offset()
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/rx.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/net/sfc/rx.c~sfc-merge-efx_page_offset-into-efx_rx_buf_offset drivers/net/sfc/rx.c
--- a/drivers/net/sfc/rx.c~sfc-merge-efx_page_offset-into-efx_rx_buf_offset
+++ a/drivers/net/sfc/rx.c
@@ -86,16 +86,12 @@ static unsigned int rx_refill_limit = 95
  */
 #define EFX_RXD_HEAD_ROOM 2
 
-static inline unsigned int efx_page_offset(void *p)
-{
-	return (__force unsigned int)p & (PAGE_SIZE - 1);
-}
 static inline unsigned int efx_rx_buf_offset(struct efx_rx_buffer *buf)
 {
 	/* Offset is always within one page, so we don't need to consider
 	 * the page order.
 	 */
-	return efx_page_offset(buf->data);
+	return (__force unsigned long) buf->data & (PAGE_SIZE - 1);
 }
 static inline unsigned int efx_rx_buf_size(struct efx_nic *efx)
 {
@@ -291,10 +287,10 @@ static inline int efx_init_rx_buffer_pag
 				      EFX_PAGE_IP_ALIGN);
 	}
 
-	offset = efx_page_offset(rx_queue->buf_data);
 	rx_buf->len = bytes;
-	rx_buf->dma_addr = rx_queue->buf_dma_addr + offset;
 	rx_buf->data = rx_queue->buf_data;
+	offset = efx_rx_buf_offset(rx_buf);
+	rx_buf->dma_addr = rx_queue->buf_dma_addr + offset;
 
 	/* Try to pack multiple buffers per page */
 	if (efx->rx_buffer_order == 0) {
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

