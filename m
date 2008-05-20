From: akpm@linux-foundation.org
Subject: + sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:30 -0700
Message-ID: <200805200327.m4K3RU3t002692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140AbYETD1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: simplify efx_rx_calc_buffer_size() using get_order()
has been added to the -mm tree.  Its filename is
     sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch

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
Subject: sfc: simplify efx_rx_calc_buffer_size() using get_order()
From: Ben Hutchings <bhutchings@solarflare.com>

Merged it into its only caller, efx_init_channels().

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-simplify-efx_rx_calc_buffer_size-using-get_order drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-simplify-efx_rx_calc_buffer_size-using-get_order
+++ a/drivers/net/sfc/efx.c
@@ -317,26 +317,6 @@ static void efx_remove_eventq(struct efx
  *
  *************************************************************************/
 
-/* Setup per-NIC RX buffer parameters.
- * Calculate the rx buffer allocation parameters required to support
- * the current MTU, including padding for header alignment and overruns.
- */
-static void efx_calc_rx_buffer_params(struct efx_nic *efx)
-{
-	unsigned int order, len;
-
-	len = (max(EFX_PAGE_IP_ALIGN, NET_IP_ALIGN) +
-	       EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
-	       efx->type->rx_buffer_padding);
-
-	/* Calculate page-order */
-	for (order = 0; ((1u << order) * PAGE_SIZE) < len; ++order)
-		;
-
-	efx->rx_buffer_len = len;
-	efx->rx_buffer_order = order;
-}
-
 static int efx_probe_channel(struct efx_channel *channel)
 {
 	struct efx_tx_queue *tx_queue;
@@ -387,7 +367,14 @@ static int efx_init_channels(struct efx_
 	struct efx_channel *channel;
 	int rc = 0;
 
-	efx_calc_rx_buffer_params(efx);
+	/* Calculate the rx buffer allocation parameters required to
+	 * support the current MTU, including padding for header
+	 * alignment and overruns.
+	 */
+	efx->rx_buffer_len = (max(EFX_PAGE_IP_ALIGN, NET_IP_ALIGN) +
+			      EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
+			      efx->type->rx_buffer_padding);
+	efx->rx_buffer_order = get_order(efx->rx_buffer_len);
 
 	/* Initialise the channels */
 	efx_for_each_channel(channel, efx) {
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

