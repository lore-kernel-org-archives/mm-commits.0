From: akpm@linux-foundation.org
Subject: + sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:37 -0700
Message-ID: <200805200327.m4K3Rbpj002704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140AbYETD1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: merge efx_page_offset() into efx_rx_buf_offset()
has been added to the -mm tree.  Its filename is
     sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch
sfc-remove-casts-to-void.patch
sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch
sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch
sfc-add-and-remove-braces-to-comply-with-kernel-style.patch
sfc-replace-various-macros-with-inline-functions.patch
sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch
sfc-use-resource_size_t-for-pci-bus-address.patch
sfc-correct-and-expand-some-comments.patch
sfc-do-not-define-inline-macro.patch
sfc-remove-redundant-casts-to-and-from-void.patch
sfc-add-checks-for-heap-allocation-failure.patch
sfc-remove-sub-minor-component-from-driver-version.patch

