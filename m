From: akpm@linux-foundation.org
Subject: - pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:20 -0700
Message-ID: <200807262113.m6QLDKsM019589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409AbYGZVNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rene.herman@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     pnp: set the pnp_card dma_mask for use by ISAPnP cards
has been removed from the -mm tree.  Its filename was
     pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: set the pnp_card dma_mask for use by ISAPnP cards
From: Rene Herman <rene.herman@keyaccess.nl>

dma_alloc_coherent() on x86 currently takes a passed in NULL device
pointer to mean that it should allocate an ISA compatible (24-bit) buffer
which is a bit of a hack.

The ALSA ISA drivers are the main consumers of this but have a struct
device in fact readily available.

For the PnP drivers, the specific pnp_dev->dev device pointer is not
always available at the right time so for now we want to pass the
pnp_card->dev instead which is always available.  Set its dma_mask in
preparation for doing so.

This does not fix a current bug -- 2.6.26-rc1 stumbled over the NULL hack
in dma_alloc_coherent() but this has already been fixed in commit
4a367f3a9dbf2e7ffcee4702203479809236ee6e by Takashi Iwai.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/card.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/pnp/card.c~pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards
+++ a/drivers/pnp/card.c
@@ -8,6 +8,7 @@
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
+#include <linux/dma-mapping.h>
 #include "base.h"
 
 LIST_HEAD(pnp_cards);
@@ -167,6 +168,9 @@ struct pnp_card *pnp_alloc_card(struct p
 	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
 		card->number);
 
+	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
+	card->dev.dma_mask = &card->dev.coherent_dma_mask;
+
 	dev_id = pnp_add_card_id(card, pnpid);
 	if (!dev_id) {
 		kfree(card);
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

origin.patch

