From: akpm@linux-foundation.org
Subject: + sfc-add-checks-for-heap-allocation-failure.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:45 -0700
Message-ID: <200805200327.m4K3RjEQ002717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427AbYETD1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: add checks for heap allocation failure
has been added to the -mm tree.  Its filename is
     sfc-add-checks-for-heap-allocation-failure.patch

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
Subject: sfc: add checks for heap allocation failure
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/selftest.c  |    2 ++
 drivers/net/sfc/tenxpress.c |    2 ++
 drivers/net/sfc/xfp_phy.c   |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/net/sfc/selftest.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/selftest.c
--- a/drivers/net/sfc/selftest.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/selftest.c
@@ -517,6 +517,8 @@ efx_test_loopback(struct efx_tx_queue *t
 		state->packet_count = min(1 << (i << 2), state->packet_count);
 		state->skbs = kzalloc(sizeof(state->skbs[0]) *
 				      state->packet_count, GFP_KERNEL);
+		if (!state->skbs)
+			return -ENOMEM;
 		state->flush = 0;
 
 		EFX_LOG(efx, "TX queue %d testing %s loopback with %d "
diff -puN drivers/net/sfc/tenxpress.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/tenxpress.c
--- a/drivers/net/sfc/tenxpress.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/tenxpress.c
@@ -211,6 +211,8 @@ static int tenxpress_phy_init(struct efx
 	int rc = 0;
 
 	phy_data = kzalloc(sizeof(*phy_data), GFP_KERNEL);
+	if (!phy_data)
+		return -ENOMEM;
 	efx->phy_data = phy_data;
 
 	tenxpress_set_state(efx, TENXPRESS_STATUS_NORMAL);
diff -puN drivers/net/sfc/xfp_phy.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/xfp_phy.c
--- a/drivers/net/sfc/xfp_phy.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/xfp_phy.c
@@ -85,6 +85,8 @@ static int xfp_phy_init(struct efx_nic *
 	int rc;
 
 	phy_data = kzalloc(sizeof(struct xfp_phy_data), GFP_KERNEL);
+	if (!phy_data)
+		return -ENOMEM;
 	efx->phy_data = phy_data;
 
 	EFX_INFO(efx, "XFP: PHY ID reg %x (OUI %x model %x revision"
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

