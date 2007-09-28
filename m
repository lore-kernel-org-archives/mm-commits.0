From: akpm@linux-foundation.org
Subject: + pnp-remove-null-pointer-checks.patch added to -mm tree
Date: Fri, 28 Sep 2007 16:31:27 -0700
Message-ID: <200709282331.l8SNVRn0022731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbXI1XcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 19:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: remove null pointer checks
has been added to the -mm tree.  Its filename is
     pnp-remove-null-pointer-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: remove null pointer checks
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Remove some null pointer checks.  Null pointers in these areas indicate
programming errors, and I think it's better to oops immediately rather than
return an error that is easily ignored.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/card.c~pnp-remove-null-pointer-checks drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-remove-null-pointer-checks
+++ a/drivers/pnp/card.c
@@ -104,10 +104,6 @@ int pnp_add_card_id(struct pnp_id *id, s
 {
 	struct pnp_id *ptr;
 
-	if (!id)
-		return -EINVAL;
-	if (!card)
-		return -EINVAL;
 	id->next = NULL;
 	ptr = card->id;
 	while (ptr && ptr->next)
@@ -124,8 +120,6 @@ static void pnp_free_card_ids(struct pnp
 	struct pnp_id *id;
 	struct pnp_id *next;
 
-	if (!card)
-		return;
 	id = card->id;
 	while (id) {
 		next = id->next;
@@ -197,9 +191,6 @@ int pnp_add_card(struct pnp_card *card)
 	int error;
 	struct list_head *pos, *temp;
 
-	if (!card || !card->protocol)
-		return -EINVAL;
-
 	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
 		card->number);
 	card->dev.parent = &card->protocol->dev;
@@ -243,8 +234,6 @@ void pnp_remove_card(struct pnp_card *ca
 {
 	struct list_head *pos, *temp;
 
-	if (!card)
-		return;
 	device_unregister(&card->dev);
 	spin_lock(&pnp_lock);
 	list_del(&card->global_list);
@@ -263,8 +252,6 @@ void pnp_remove_card(struct pnp_card *ca
  */
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev)
 {
-	if (!card || !dev || !dev->protocol)
-		return -EINVAL;
 	dev->dev.parent = &card->dev;
 	dev->card_link = NULL;
 	snprintf(dev->dev.bus_id, BUS_ID_SIZE, "%02x:%02x.%02x",
@@ -348,8 +335,6 @@ void pnp_release_card_device(struct pnp_
 {
 	struct pnp_card_driver *drv = dev->card_link->driver;
 
-	if (!drv)
-		return;
 	drv->link.remove = &card_remove;
 	device_release_driver(&dev->dev);
 	drv->link.remove = &card_remove_first;
diff -puN include/linux/pnp.h~pnp-remove-null-pointer-checks include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-remove-null-pointer-checks
+++ a/include/linux/pnp.h
@@ -243,11 +243,11 @@ struct pnp_fixup {
 #define PNP_CONFIGURABLE	0x0008
 #define PNP_REMOVABLE		0x0010
 
-#define pnp_can_read(dev)	(((dev)->protocol) && ((dev)->protocol->get) && \
+#define pnp_can_read(dev)	(((dev)->protocol->get) && \
 				 ((dev)->capabilities & PNP_READ))
-#define pnp_can_write(dev)	(((dev)->protocol) && ((dev)->protocol->set) && \
+#define pnp_can_write(dev)	(((dev)->protocol->set) && \
 				 ((dev)->capabilities & PNP_WRITE))
-#define pnp_can_disable(dev)	(((dev)->protocol) && ((dev)->protocol->disable) && \
+#define pnp_can_disable(dev)	(((dev)->protocol->disable) && \
 				 ((dev)->capabilities & PNP_DISABLE))
 #define pnp_can_configure(dev)	((!(dev)->active) && \
 				 ((dev)->capabilities & PNP_CONFIGURABLE))
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
pnp-remove-null-pointer-checks.patch
pnp-simplify-pnp-card-error-handling.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
pnp-use-dev_info-in-system-driver.patch
pnp-simplify-pnpbios-insert_device.patch
pnp-add-debug-message-for-adding-new-device.patch
