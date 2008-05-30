From: akpm@linux-foundation.org
Subject: + pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch added to -mm tree
Date: Fri, 30 May 2008 15:55:17 -0700
Message-ID: <200805302255.m4UMtI2T015577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbYE3W43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rene.herman@gmail.com, tiwai@suse.de


The patch titled
     pnp: set the pnp_card dma_mask for use by ISAPnP cards
has been added to the -mm tree.  Its filename is
     pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch

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
Subject: pnp: set the pnp_card dma_mask for use by ISAPnP cards
From: Rene Herman <rene.herman@keyaccess.nl>

This makes the pnp_card->dev available as a DMAable device same as
the pnp_dev->dev.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
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
 	dev_set_name(&card->dev, "%02x:%02x", card->protocol->number,
 		card->number);
 
+	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
+	card->dev.dma_mask = &card->dev.coherent_dma_mask;
+
 	dev_id = pnp_add_card_id(card, pnpid);
 	if (!dev_id) {
 		kfree(card);
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

