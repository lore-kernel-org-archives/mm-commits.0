From: akpm@linux-foundation.org
Subject: + pnp-simplify-pnp-card-error-handling.patch added to -mm tree
Date: Fri, 28 Sep 2007 16:31:29 -0700
Message-ID: <200709282331.l8SNVTDY022734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbXI1XcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 19:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: simplify PNP card error handling
has been added to the -mm tree.  Its filename is
     pnp-simplify-pnp-card-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: simplify PNP card error handling
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No functional change; just return errors early instead of putting the main
part of the function inside an "if" statement.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/card.c~pnp-simplify-pnp-card-error-handling drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-simplify-pnp-card-error-handling
+++ a/drivers/pnp/card.c
@@ -197,33 +197,34 @@ int pnp_add_card(struct pnp_card *card)
 	card->dev.bus = NULL;
 	card->dev.release = &pnp_release_card;
 	error = device_register(&card->dev);
-
-	if (error == 0) {
-		pnp_interface_attach_card(card);
-		spin_lock(&pnp_lock);
-		list_add_tail(&card->global_list, &pnp_cards);
-		list_add_tail(&card->protocol_list, &card->protocol->cards);
-		spin_unlock(&pnp_lock);
-
-		/* we wait until now to add devices in order to ensure the drivers
-		 * will be able to use all of the related devices on the card
-		 * without waiting any unresonable length of time */
-		list_for_each(pos, &card->devices) {
-			struct pnp_dev *dev = card_to_pnp_dev(pos);
-			__pnp_add_device(dev);
-		}
-
-		/* match with card drivers */
-		list_for_each_safe(pos, temp, &pnp_card_drivers) {
-			struct pnp_card_driver *drv =
-			    list_entry(pos, struct pnp_card_driver,
-				       global_list);
-			card_probe(card, drv);
-		}
-	} else
+	if (error) {
 		pnp_err("sysfs failure, card '%s' will be unavailable",
 			card->dev.bus_id);
-	return error;
+		return error;
+	}
+
+	pnp_interface_attach_card(card);
+	spin_lock(&pnp_lock);
+	list_add_tail(&card->global_list, &pnp_cards);
+	list_add_tail(&card->protocol_list, &card->protocol->cards);
+	spin_unlock(&pnp_lock);
+
+	/* we wait until now to add devices in order to ensure the drivers
+	 * will be able to use all of the related devices on the card
+	 * without waiting an unreasonable length of time */
+	list_for_each(pos, &card->devices) {
+		struct pnp_dev *dev = card_to_pnp_dev(pos);
+		__pnp_add_device(dev);
+	}
+
+	/* match with card drivers */
+	list_for_each_safe(pos, temp, &pnp_card_drivers) {
+		struct pnp_card_driver *drv =
+		    list_entry(pos, struct pnp_card_driver,
+			       global_list);
+		card_probe(card, drv);
+	}
+	return 0;
 }
 
 /**
@@ -291,14 +292,15 @@ struct pnp_dev *pnp_request_card_device(
 	struct pnp_card *card;
 
 	if (!clink || !id)
-		goto done;
+		return NULL;
+
 	card = clink->card;
 	drv = clink->driver;
 	if (!from) {
 		pos = card->devices.next;
 	} else {
 		if (from->card != card)
-			goto done;
+			return NULL;
 		pos = from->card_list.next;
 	}
 	while (pos != &card->devices) {
@@ -308,7 +310,6 @@ struct pnp_dev *pnp_request_card_device(
 		pos = pos->next;
 	}
 
-done:
 	return NULL;
 
 found:
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
