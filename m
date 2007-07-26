From: akpm@linux-foundation.org
Subject: + pnp-fix-up-after-lindent.patch added to -mm tree
Date: Thu, 26 Jul 2007 10:20:30 -0700
Message-ID: <200707261720.l6QHKUIN011227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759638AbXGZRVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 13:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: fix up after Lindent
has been added to the -mm tree.  Its filename is
     pnp-fix-up-after-lindent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: fix up after Lindent
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

These are manual fixups after running Lindent.  No functional change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/card.c              |   33 +---
 drivers/pnp/core.c              |   29 ---
 drivers/pnp/driver.c            |   20 +-
 drivers/pnp/interface.c         |    2 
 drivers/pnp/isapnp/compat.c     |   23 +-
 drivers/pnp/isapnp/core.c       |   30 ---
 drivers/pnp/isapnp/proc.c       |    7 
 drivers/pnp/manager.c           |   24 ---
 drivers/pnp/pnpacpi/core.c      |   23 +-
 drivers/pnp/pnpacpi/rsparser.c  |  160 +++++++-------------
 drivers/pnp/pnpbios/bioscalls.c |  161 +++++---------------
 drivers/pnp/pnpbios/core.c      |   28 +--
 drivers/pnp/pnpbios/proc.c      |    5 
 drivers/pnp/pnpbios/rsparser.c  |   99 +++++-------
 drivers/pnp/quirks.c            |    1 
 drivers/pnp/resource.c          |   33 +---
 drivers/pnp/support.c           |    8 -
 drivers/pnp/system.c            |   12 -
 include/linux/pnp.h             |  238 +++++++-----------------------
 include/linux/pnpbios.h         |   10 -
 20 files changed, 312 insertions(+), 634 deletions(-)

diff -puN drivers/pnp/card.c~pnp-fix-up-after-lindent drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/card.c
@@ -2,7 +2,6 @@
  * card.c - contains functions for managing groups of PnP devices
  *
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/module.h>
@@ -17,12 +16,15 @@ static const struct pnp_card_device_id *
 						   struct pnp_card *card)
 {
 	const struct pnp_card_device_id *drv_id = drv->id_table;
+
 	while (*drv_id->id) {
 		if (compare_pnp_id(card->id, drv_id->id)) {
 			int i = 0;
+
 			for (;;) {
 				int found;
 				struct pnp_dev *dev;
+
 				if (i == PNP_MAX_DEVICES
 				    || !*drv_id->devs[i].id)
 					return drv_id;
@@ -52,6 +54,7 @@ static void card_remove(struct pnp_dev *
 static void card_remove_first(struct pnp_dev *dev)
 {
 	struct pnp_card_driver *drv = to_pnp_card_driver(dev->driver);
+
 	if (!dev->card || !drv)
 		return;
 	if (drv->remove)
@@ -96,12 +99,11 @@ static int card_probe(struct pnp_card *c
  * pnp_add_card_id - adds an EISA id to the specified card
  * @id: pointer to a pnp_id structure
  * @card: pointer to the desired card
- *
  */
-
 int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card)
 {
 	struct pnp_id *ptr;
+
 	if (!id)
 		return -EINVAL;
 	if (!card)
@@ -121,6 +123,7 @@ static void pnp_free_card_ids(struct pnp
 {
 	struct pnp_id *id;
 	struct pnp_id *next;
+
 	if (!card)
 		return;
 	id = card->id;
@@ -134,6 +137,7 @@ static void pnp_free_card_ids(struct pnp
 static void pnp_release_card(struct device *dmdev)
 {
 	struct pnp_card *card = to_pnp_card(dmdev);
+
 	pnp_free_card_ids(card);
 	kfree(card);
 }
@@ -143,6 +147,7 @@ static ssize_t pnp_show_card_name(struct
 {
 	char *str = buf;
 	struct pnp_card *card = to_pnp_card(dmdev);
+
 	str += sprintf(str, "%s\n", card->name);
 	return (str - buf);
 }
@@ -168,6 +173,7 @@ static DEVICE_ATTR(card_id, S_IRUGO, pnp
 static int pnp_interface_attach_card(struct pnp_card *card)
 {
 	int rc = device_create_file(&card->dev, &dev_attr_name);
+
 	if (rc)
 		return rc;
 
@@ -186,11 +192,11 @@ static int pnp_interface_attach_card(str
  * pnp_add_card - adds a PnP card to the PnP Layer
  * @card: pointer to the card to add
  */
-
 int pnp_add_card(struct pnp_card *card)
 {
 	int error;
 	struct list_head *pos, *temp;
+
 	if (!card || !card->protocol)
 		return -EINVAL;
 
@@ -233,10 +239,10 @@ int pnp_add_card(struct pnp_card *card)
  * pnp_remove_card - removes a PnP card from the PnP Layer
  * @card: pointer to the card to remove
  */
-
 void pnp_remove_card(struct pnp_card *card)
 {
 	struct list_head *pos, *temp;
+
 	if (!card)
 		return;
 	device_unregister(&card->dev);
@@ -255,7 +261,6 @@ void pnp_remove_card(struct pnp_card *ca
  * @card: pointer to the card to add to
  * @dev: pointer to the device to add
  */
-
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev)
 {
 	if (!card || !dev || !dev->protocol)
@@ -275,7 +280,6 @@ int pnp_add_card_device(struct pnp_card 
  * pnp_remove_card_device- removes a device from the specified card
  * @dev: pointer to the device to remove
  */
-
 void pnp_remove_card_device(struct pnp_dev *dev)
 {
 	spin_lock(&pnp_lock);
@@ -291,7 +295,6 @@ void pnp_remove_card_device(struct pnp_d
  * @id: pointer to a PnP ID structure that explains the rules for finding the device
  * @from: Starting place to search from. If NULL it will start from the begining.
  */
-
 struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
 					const char *id, struct pnp_dev *from)
 {
@@ -299,6 +302,7 @@ struct pnp_dev *pnp_request_card_device(
 	struct pnp_dev *dev;
 	struct pnp_card_driver *drv;
 	struct pnp_card *card;
+
 	if (!clink || !id)
 		goto done;
 	card = clink->card;
@@ -340,10 +344,10 @@ struct pnp_dev *pnp_request_card_device(
  * pnp_release_card_device - call this when the driver no longer needs the device
  * @dev: pointer to the PnP device stucture
  */
-
 void pnp_release_card_device(struct pnp_dev *dev)
 {
 	struct pnp_card_driver *drv = dev->card_link->driver;
+
 	if (!drv)
 		return;
 	drv->link.remove = &card_remove;
@@ -357,6 +361,7 @@ void pnp_release_card_device(struct pnp_
 static int card_suspend(struct pnp_dev *dev, pm_message_t state)
 {
 	struct pnp_card_link *link = dev->card_link;
+
 	if (link->pm_state.event == state.event)
 		return 0;
 	link->pm_state = state;
@@ -366,6 +371,7 @@ static int card_suspend(struct pnp_dev *
 static int card_resume(struct pnp_dev *dev)
 {
 	struct pnp_card_link *link = dev->card_link;
+
 	if (link->pm_state.event == PM_EVENT_ON)
 		return 0;
 	link->pm_state = PMSG_ON;
@@ -377,7 +383,6 @@ static int card_resume(struct pnp_dev *d
  * pnp_register_card_driver - registers a PnP card driver with the PnP Layer
  * @drv: pointer to the driver to register
  */
-
 int pnp_register_card_driver(struct pnp_card_driver *drv)
 {
 	int error;
@@ -411,7 +416,6 @@ int pnp_register_card_driver(struct pnp_
  * pnp_unregister_card_driver - unregisters a PnP card driver from the PnP Layer
  * @drv: pointer to the driver to unregister
  */
-
 void pnp_unregister_card_driver(struct pnp_card_driver *drv)
 {
 	spin_lock(&pnp_lock);
@@ -420,13 +424,6 @@ void pnp_unregister_card_driver(struct p
 	pnp_unregister_driver(&drv->link);
 }
 
-#if 0
-EXPORT_SYMBOL(pnp_add_card);
-EXPORT_SYMBOL(pnp_remove_card);
-EXPORT_SYMBOL(pnp_add_card_device);
-EXPORT_SYMBOL(pnp_remove_card_device);
-EXPORT_SYMBOL(pnp_add_card_id);
-#endif /*  0  */
 EXPORT_SYMBOL(pnp_request_card_device);
 EXPORT_SYMBOL(pnp_release_card_device);
 EXPORT_SYMBOL(pnp_register_card_driver);
diff -puN drivers/pnp/core.c~pnp-fix-up-after-lindent drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/core.c
@@ -2,7 +2,6 @@
  * core.c - contains all core device and protocol registration functions
  *
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/pnp.h>
@@ -48,7 +47,6 @@ void *pnp_alloc(long size)
  *
  *  Ex protocols: ISAPNP, PNPBIOS, etc
  */
-
 int pnp_register_protocol(struct pnp_protocol *protocol)
 {
 	int nodenum;
@@ -82,7 +80,6 @@ int pnp_register_protocol(struct pnp_pro
 /**
  * pnp_protocol_unregister - removes a pnp protocol from the pnp layer
  * @protocol: pointer to the corresponding pnp_protocol structure
- *
  */
 void pnp_unregister_protocol(struct pnp_protocol *protocol)
 {
@@ -96,6 +93,7 @@ static void pnp_free_ids(struct pnp_dev 
 {
 	struct pnp_id *id;
 	struct pnp_id *next;
+
 	if (!dev)
 		return;
 	id = dev->id;
@@ -109,6 +107,7 @@ static void pnp_free_ids(struct pnp_dev 
 static void pnp_release_device(struct device *dmdev)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+
 	pnp_free_option(dev->independent);
 	pnp_free_option(dev->dependent);
 	pnp_free_ids(dev);
@@ -118,6 +117,7 @@ static void pnp_release_device(struct de
 int __pnp_add_device(struct pnp_dev *dev)
 {
 	int ret;
+
 	pnp_fixup_device(dev);
 	dev->dev.bus = &pnp_bus_type;
 	dev->dev.dma_mask = &dev->dma_mask;
@@ -141,7 +141,6 @@ int __pnp_add_device(struct pnp_dev *dev
  *
  *  adds to driver model, name database, fixups, interface, etc.
  */
-
 int pnp_add_device(struct pnp_dev *dev)
 {
 	if (!dev || !dev->protocol || dev->card)
@@ -161,21 +160,6 @@ void __pnp_remove_device(struct pnp_dev 
 	device_unregister(&dev->dev);
 }
 
-/**
- * pnp_remove_device - removes a pnp device from the pnp layer
- * @dev: pointer to dev to add
- *
- * this function will free all mem used by dev
- */
-#if 0
-void pnp_remove_device(struct pnp_dev *dev)
-{
-	if (!dev || dev->card)
-		return;
-	__pnp_remove_device(dev);
-}
-#endif /*  0  */
-
 static int __init pnp_init(void)
 {
 	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
@@ -183,10 +167,3 @@ static int __init pnp_init(void)
 }
 
 subsys_initcall(pnp_init);
-
-#if 0
-EXPORT_SYMBOL(pnp_register_protocol);
-EXPORT_SYMBOL(pnp_unregister_protocol);
-EXPORT_SYMBOL(pnp_add_device);
-EXPORT_SYMBOL(pnp_remove_device);
-#endif /*  0  */
diff -puN drivers/pnp/driver.c~pnp-fix-up-after-lindent drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/driver.c
@@ -2,7 +2,6 @@
  * driver.c - device id matching, driver model, etc.
  *
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/string.h>
@@ -16,6 +15,7 @@
 static int compare_func(const char *ida, const char *idb)
 {
 	int i;
+
 	/* we only need to compare the last 4 chars */
 	for (i = 3; i < 7; i++) {
 		if (ida[i] != 'X' &&
@@ -44,6 +44,7 @@ static const struct pnp_device_id *match
 						struct pnp_dev *dev)
 {
 	const struct pnp_device_id *drv_id = drv->id_table;
+
 	if (!drv_id)
 		return NULL;
 
@@ -140,6 +141,7 @@ static int pnp_bus_match(struct device *
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
 	struct pnp_driver *pnp_drv = to_pnp_driver(drv);
+
 	if (match_device(pnp_drv, pnp_dev) == NULL)
 		return 0;
 	return 1;
@@ -197,12 +199,12 @@ static int pnp_bus_resume(struct device 
 }
 
 struct bus_type pnp_bus_type = {
-	.name = "pnp",
-	.match = pnp_bus_match,
-	.probe = pnp_device_probe,
-	.remove = pnp_device_remove,
+	.name    = "pnp",
+	.match   = pnp_bus_match,
+	.probe   = pnp_device_probe,
+	.remove  = pnp_device_remove,
 	.suspend = pnp_bus_suspend,
-	.resume = pnp_bus_resume,
+	.resume  = pnp_bus_resume,
 };
 
 int pnp_register_driver(struct pnp_driver *drv)
@@ -225,12 +227,11 @@ void pnp_unregister_driver(struct pnp_dr
  * pnp_add_id - adds an EISA id to the specified device
  * @id: pointer to a pnp_id structure
  * @dev: pointer to the desired device
- *
  */
-
 int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev)
 {
 	struct pnp_id *ptr;
+
 	if (!id)
 		return -EINVAL;
 	if (!dev)
@@ -248,8 +249,5 @@ int pnp_add_id(struct pnp_id *id, struct
 
 EXPORT_SYMBOL(pnp_register_driver);
 EXPORT_SYMBOL(pnp_unregister_driver);
-#if 0
-EXPORT_SYMBOL(pnp_add_id);
-#endif
 EXPORT_SYMBOL(pnp_device_attach);
 EXPORT_SYMBOL(pnp_device_detach);
diff -puN drivers/pnp/interface.c~pnp-fix-up-after-lindent drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/interface.c
@@ -3,7 +3,6 @@
  *
  * Some code, especially possible resource dumping is based on isapnp_proc.c (c) Jaroslav Kysela <perex@suse.cz>
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/pnp.h>
@@ -488,6 +487,7 @@ static DEVICE_ATTR(id, S_IRUGO, pnp_show
 int pnp_interface_attach_device(struct pnp_dev *dev)
 {
 	int rc = device_create_file(&dev->dev, &dev_attr_options);
+
 	if (rc)
 		goto err;
 	rc = device_create_file(&dev->dev, &dev_attr_resources);
diff -puN drivers/pnp/isapnp/compat.c~pnp-fix-up-after-lindent drivers/pnp/isapnp/compat.c
--- a/drivers/pnp/isapnp/compat.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/isapnp/compat.c
@@ -3,11 +3,8 @@
  *            the old isapnp APIs. If possible use the new APIs instead.
  *
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
-/* TODO: see if more isapnp functions are needed here */
-
 #include <linux/module.h>
 #include <linux/isapnp.h>
 #include <linux/string.h>
@@ -19,16 +16,17 @@ static void pnp_convert_id(char *buf, un
 		'A' + ((vendor >> 2) & 0x3f) - 1,
 		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
 		'A' + ((vendor >> 8) & 0x1f) - 1,
-		(device >> 4) & 0x0f,
-		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
+		(device >> 4) & 0x0f, device & 0x0f,
+		(device >> 12) & 0x0f, (device >> 8) & 0x0f);
 }
 
-struct pnp_card *pnp_find_card(unsigned short vendor,
-			       unsigned short device, struct pnp_card *from)
+struct pnp_card *pnp_find_card(unsigned short vendor, unsigned short device,
+			       struct pnp_card *from)
 {
 	char id[8];
 	char any[8];
 	struct list_head *list;
+
 	pnp_convert_id(id, vendor, device);
 	pnp_convert_id(any, ISAPNP_ANY_ID, ISAPNP_ANY_ID);
 
@@ -36,6 +34,7 @@ struct pnp_card *pnp_find_card(unsigned 
 
 	while (list != &pnp_cards) {
 		struct pnp_card *card = global_to_pnp_card(list);
+
 		if (compare_pnp_id(card->id, id) || (memcmp(id, any, 7) == 0))
 			return card;
 		list = list->next;
@@ -43,12 +42,12 @@ struct pnp_card *pnp_find_card(unsigned 
 	return NULL;
 }
 
-struct pnp_dev *pnp_find_dev(struct pnp_card *card,
-			     unsigned short vendor,
+struct pnp_dev *pnp_find_dev(struct pnp_card *card, unsigned short vendor,
 			     unsigned short function, struct pnp_dev *from)
 {
 	char id[8];
 	char any[8];
+
 	pnp_convert_id(id, vendor, function);
 	pnp_convert_id(any, ISAPNP_ANY_ID, ISAPNP_ANY_ID);
 	if (card == NULL) {	/* look for a logical device from all cards */
@@ -60,8 +59,9 @@ struct pnp_dev *pnp_find_dev(struct pnp_
 
 		while (list != &pnp_global) {
 			struct pnp_dev *dev = global_to_pnp_dev(list);
-			if (compare_pnp_id(dev->id, id)
-			    || (memcmp(id, any, 7) == 0))
+
+			if (compare_pnp_id(dev->id, id) ||
+			    (memcmp(id, any, 7) == 0))
 				return dev;
 			list = list->next;
 		}
@@ -76,6 +76,7 @@ struct pnp_dev *pnp_find_dev(struct pnp_
 		}
 		while (list != &card->devices) {
 			struct pnp_dev *dev = card_to_pnp_dev(list);
+
 			if (compare_pnp_id(dev->id, id))
 				return dev;
 			list = list->next;
diff -puN drivers/pnp/isapnp/core.c~pnp-fix-up-after-lindent drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/isapnp/core.c
@@ -252,7 +252,6 @@ static inline void isapnp_set_rdp(void)
  *	Perform an isolation. The port selection code now tries to avoid
  *	"dangerous to read" ports.
  */
-
 static int __init isapnp_isolate_rdp_select(void)
 {
 	isapnp_wait();
@@ -281,7 +280,6 @@ static int __init isapnp_isolate_rdp_sel
 /*
  *  Isolate (assign uniqued CSN) to all ISA PnP devices.
  */
-
 static int __init isapnp_isolate(void)
 {
 	unsigned char checksum = 0x6a;
@@ -352,7 +350,6 @@ static int __init isapnp_isolate(void)
 /*
  *  Read one tag from stream.
  */
-
 static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
 {
 	unsigned char tag, tmp[2];
@@ -380,7 +377,6 @@ static int __init isapnp_read_tag(unsign
 /*
  *  Skip specified number of bytes from stream.
  */
-
 static void __init isapnp_skip_bytes(int count)
 {
 	isapnp_peek(NULL, count);
@@ -389,11 +385,11 @@ static void __init isapnp_skip_bytes(int
 /*
  *  Parse EISA id.
  */
-
 static void isapnp_parse_id(struct pnp_dev *dev, unsigned short vendor,
 			    unsigned short device)
 {
 	struct pnp_id *id;
+
 	if (!dev)
 		return;
 	id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
@@ -411,7 +407,6 @@ static void isapnp_parse_id(struct pnp_d
 /*
  *  Parse logical device tag.
  */
-
 static struct pnp_dev *__init isapnp_parse_device(struct pnp_card *card,
 						  int size, int number)
 {
@@ -440,7 +435,6 @@ static struct pnp_dev *__init isapnp_par
 /*
  *  Add IRQ resource to resources list.
  */
-
 static void __init isapnp_parse_irq_resource(struct pnp_option *option,
 					     int size)
 {
@@ -459,13 +453,11 @@ static void __init isapnp_parse_irq_reso
 	else
 		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
 	pnp_register_irq_resource(option, irq);
-	return;
 }
 
 /*
  *  Add DMA resource to resources list.
  */
-
 static void __init isapnp_parse_dma_resource(struct pnp_option *option,
 					     int size)
 {
@@ -479,13 +471,11 @@ static void __init isapnp_parse_dma_reso
 	dma->map = tmp[0];
 	dma->flags = tmp[1];
 	pnp_register_dma_resource(option, dma);
-	return;
 }
 
 /*
  *  Add port resource to resources list.
  */
-
 static void __init isapnp_parse_port_resource(struct pnp_option *option,
 					      int size)
 {
@@ -502,13 +492,11 @@ static void __init isapnp_parse_port_res
 	port->size = tmp[6];
 	port->flags = tmp[0] ? PNP_PORT_FLAG_16BITADDR : 0;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
 /*
  *  Add fixed port resource to resources list.
  */
-
 static void __init isapnp_parse_fixed_port_resource(struct pnp_option *option,
 						    int size)
 {
@@ -524,13 +512,11 @@ static void __init isapnp_parse_fixed_po
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
 /*
  *  Add memory resource to resources list.
  */
-
 static void __init isapnp_parse_mem_resource(struct pnp_option *option,
 					     int size)
 {
@@ -547,13 +533,11 @@ static void __init isapnp_parse_mem_reso
 	mem->size = ((tmp[8] << 8) | tmp[7]) << 8;
 	mem->flags = tmp[0];
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
 /*
  *  Add 32-bit memory resource to resources list.
  */
-
 static void __init isapnp_parse_mem32_resource(struct pnp_option *option,
 					       int size)
 {
@@ -577,7 +561,6 @@ static void __init isapnp_parse_mem32_re
 /*
  *  Add 32-bit fixed memory resource to resources list.
  */
-
 static void __init isapnp_parse_fixed_mem32_resource(struct pnp_option *option,
 						     int size)
 {
@@ -599,7 +582,6 @@ static void __init isapnp_parse_fixed_me
 /*
  *  Parse card name for ISA PnP device.
  */
-
 static void __init
 isapnp_parse_name(char *name, unsigned int name_max, unsigned short *size)
 {
@@ -619,7 +601,6 @@ isapnp_parse_name(char *name, unsigned i
 /*
  *  Parse resource map for logical device.
  */
-
 static int __init isapnp_create_device(struct pnp_card *card,
 				       unsigned short size)
 {
@@ -627,6 +608,7 @@ static int __init isapnp_create_device(s
 	unsigned char type, tmp[17];
 	struct pnp_option *option;
 	struct pnp_dev *dev;
+
 	if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
 		return 1;
 	option = pnp_register_independent_option(dev);
@@ -761,7 +743,6 @@ static int __init isapnp_create_device(s
 /*
  *  Parse resource map for ISA PnP card.
  */
-
 static void __init isapnp_parse_resource_map(struct pnp_card *card)
 {
 	unsigned char type, tmp[17];
@@ -816,7 +797,6 @@ static void __init isapnp_parse_resource
 /*
  *  Compute ISA PnP checksum for first eight bytes.
  */
-
 static unsigned char __init isapnp_checksum(unsigned char *data)
 {
 	int i, j;
@@ -839,11 +819,11 @@ static unsigned char __init isapnp_check
 /*
  *  Parse EISA id for ISA PnP card.
  */
-
 static void isapnp_parse_card_id(struct pnp_card *card, unsigned short vendor,
 				 unsigned short device)
 {
 	struct pnp_id *id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+
 	if (!id)
 		return;
 	sprintf(id->id, "%c%c%c%x%x%x%x",
@@ -858,7 +838,6 @@ static void isapnp_parse_card_id(struct 
 /*
  *  Build device list for all present ISA PnP devices.
  */
-
 static int __init isapnp_build_device_list(void)
 {
 	int csn;
@@ -911,6 +890,7 @@ static int __init isapnp_build_device_li
 int isapnp_present(void)
 {
 	struct pnp_card *card;
+
 	pnp_for_each_card(card) {
 		if (card->protocol == &isapnp_protocol)
 			return 1;
@@ -953,7 +933,7 @@ int isapnp_cfg_end(void)
 }
 
 /*
- *  Inititialization.
+ *  Initialization.
  */
 
 EXPORT_SYMBOL(isapnp_protocol);
diff -puN drivers/pnp/isapnp/proc.c~pnp-fix-up-after-lindent drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/isapnp/proc.c
@@ -2,7 +2,6 @@
  *  ISA Plug & Play support
  *  Copyright (c) by Jaroslav Kysela <perex@suse.cz>
  *
- *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation; either version 2 of the License, or
@@ -16,7 +15,6 @@
  *   You should have received a copy of the GNU General Public License
  *   along with this program; if not, write to the Free Software
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 
 #include <linux/module.h>
@@ -139,11 +137,12 @@ static int __exit isapnp_proc_detach_bus
 	remove_proc_entry(name, isapnp_proc_bus_dir);
 	return 0;
 }
-#endif /* MODULE */
+#endif				/* MODULE */
 
 int __init isapnp_proc_init(void)
 {
 	struct pnp_dev *dev;
+
 	isapnp_proc_bus_dir = proc_mkdir("isapnp", proc_bus);
 	protocol_for_each_dev(&isapnp_protocol, dev) {
 		isapnp_proc_attach_device(dev);
@@ -167,4 +166,4 @@ int __exit isapnp_proc_done(void)
 		remove_proc_entry("isapnp", proc_bus);
 	return 0;
 }
-#endif /* MODULE */
+#endif				/* MODULE */
diff -puN drivers/pnp/manager.c~pnp-fix-up-after-lindent drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/manager.c
@@ -3,7 +3,6 @@
  *
  * based on isapnp.c resource management (c) Jaroslav Kysela <perex@suse.cz>
  * Copyright 2003 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/errno.h>
@@ -222,11 +221,11 @@ static int pnp_assign_dma(struct pnp_dev
 /**
  * pnp_init_resources - Resets a resource table to default values.
  * @table: pointer to the desired resource table
- *
  */
 void pnp_init_resource_table(struct pnp_resource_table *table)
 {
 	int idx;
+
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
 		table->irq_resource[idx].name = NULL;
 		table->irq_resource[idx].start = -1;
@@ -260,11 +259,11 @@ void pnp_init_resource_table(struct pnp_
 /**
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
- *
  */
 static void pnp_clean_resource_table(struct pnp_resource_table *res)
 {
 	int idx;
+
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
 		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
@@ -410,6 +409,7 @@ int pnp_manual_config_dev(struct pnp_dev
 {
 	int i;
 	struct pnp_resource_table *bak;
+
 	if (!dev || !res)
 		return -EINVAL;
 	if (!pnp_can_configure(dev))
@@ -454,7 +454,6 @@ int pnp_manual_config_dev(struct pnp_dev
 /**
  * pnp_auto_config_dev - automatically assigns resources to a device
  * @dev: pointer to the desired device
- *
  */
 int pnp_auto_config_dev(struct pnp_dev *dev)
 {
@@ -491,9 +490,8 @@ int pnp_auto_config_dev(struct pnp_dev *
  * pnp_start_dev - low-level start of the PnP device
  * @dev: pointer to the desired device
  *
- * assumes that resources have alread been allocated
+ * assumes that resources have already been allocated
  */
-
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
@@ -508,7 +506,6 @@ int pnp_start_dev(struct pnp_dev *dev)
 	}
 
 	pnp_info("Device %s activated.", dev->dev.bus_id);
-
 	return 0;
 }
 
@@ -518,7 +515,6 @@ int pnp_start_dev(struct pnp_dev *dev)
  *
  * does not free resources
  */
-
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
@@ -532,7 +528,6 @@ int pnp_stop_dev(struct pnp_dev *dev)
 	}
 
 	pnp_info("Device %s disabled.", dev->dev.bus_id);
-
 	return 0;
 }
 
@@ -548,9 +543,8 @@ int pnp_activate_dev(struct pnp_dev *dev
 
 	if (!dev)
 		return -EINVAL;
-	if (dev->active) {
+	if (dev->active)
 		return 0;	/* the device is already active */
-	}
 
 	/* ensure resources are allocated */
 	if (pnp_auto_config_dev(dev))
@@ -561,7 +555,6 @@ int pnp_activate_dev(struct pnp_dev *dev
 		return error;
 
 	dev->active = 1;
-
 	return 1;
 }
 
@@ -577,9 +570,8 @@ int pnp_disable_dev(struct pnp_dev *dev)
 
 	if (!dev)
 		return -EINVAL;
-	if (!dev->active) {
+	if (!dev->active)
 		return 0;	/* the device is already disabled */
-	}
 
 	error = pnp_stop_dev(dev);
 	if (error)
@@ -600,7 +592,6 @@ int pnp_disable_dev(struct pnp_dev *dev)
  * @resource: pointer to resource to be changed
  * @start: start of region
  * @size: size of region
- *
  */
 void pnp_resource_change(struct resource *resource, resource_size_t start,
 			 resource_size_t size)
@@ -613,9 +604,6 @@ void pnp_resource_change(struct resource
 }
 
 EXPORT_SYMBOL(pnp_manual_config_dev);
-#if 0
-EXPORT_SYMBOL(pnp_auto_config_dev);
-#endif
 EXPORT_SYMBOL(pnp_start_dev);
 EXPORT_SYMBOL(pnp_stop_dev);
 EXPORT_SYMBOL(pnp_activate_dev);
diff -puN drivers/pnp/pnpacpi/core.c~pnp-fix-up-after-lindent drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpacpi/core.c
@@ -34,9 +34,9 @@ static int num = 0;
  * used by the kernel (PCI root, ...), as it is harmless and there were
  * already present in pnpbios. But there is an exception for devices that
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
- * Finaly only devices that have a CRS method need to be in this list.
+ * Finally, only devices that have a CRS method need to be in this list.
  */
-static __initdata struct acpi_device_id excluded_id_list[] = {
+static struct __initdata acpi_device_id excluded_id_list[] = {
 	{"PNP0C09", 0},		/* EC */
 	{"PNP0C0F", 0},		/* Link device */
 	{"PNP0000", 0},		/* PIC */
@@ -88,6 +88,7 @@ static int pnpacpi_get_resources(struct 
 				 struct pnp_resource_table *res)
 {
 	acpi_status status;
+
 	status = pnpacpi_parse_allocated_resource((acpi_handle) dev->data,
 						  &dev->res);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
@@ -141,9 +142,9 @@ static int pnpacpi_resume(struct pnp_dev
 }
 
 static struct pnp_protocol pnpacpi_protocol = {
-	.name = "Plug and Play ACPI",
-	.get = pnpacpi_get_resources,
-	.set = pnpacpi_set_resources,
+	.name	 = "Plug and Play ACPI",
+	.get	 = pnpacpi_get_resources,
+	.set	 = pnpacpi_set_resources,
 	.disable = pnpacpi_disable_resources,
 	.suspend = pnpacpi_suspend,
 	.resume = pnpacpi_resume,
@@ -168,7 +169,7 @@ static int __init pnpacpi_add_device(str
 		return -ENOMEM;
 	}
 	dev->data = device->handle;
-	/* .enabled means if the device can decode the resources */
+	/* .enabled means the device can decode the resources */
 	dev->active = device->status.enabled;
 	status = acpi_get_handle(device->handle, "_SRS", &temp);
 	if (ACPI_SUCCESS(status))
@@ -200,8 +201,8 @@ static int __init pnpacpi_add_device(str
 
 	if (dev->active) {
 		/* parse allocated resource */
-		status =
-		    pnpacpi_parse_allocated_resource(device->handle, &dev->res);
+		status = pnpacpi_parse_allocated_resource(device->handle,
+							  &dev->res);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s",
 				dev_id->id);
@@ -294,7 +295,7 @@ static int __init acpi_pnp_find_device(s
  * pnpdev->dev.archdata.acpi_handle point to its ACPI sibling.
  */
 static struct acpi_bus_type __initdata acpi_pnp_bus = {
-	.bus = &pnp_bus_type,
+	.bus	     = &pnp_bus_type,
 	.find_device = acpi_pnp_find_device,
 };
 
@@ -327,7 +328,3 @@ static int __init pnpacpi_setup(char *st
 }
 
 __setup("pnpacpi=", pnpacpi_setup);
-
-#if 0
-EXPORT_SYMBOL(pnpacpi_protocol);
-#endif
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-fix-up-after-lindent drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -71,9 +71,9 @@ static void decode_irq_flags(int flag, i
 	}
 }
 
-static void
-pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res, u32 gsi,
-				    int triggering, int polarity, int shareable)
+static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
+						u32 gsi, int triggering,
+						int polarity, int shareable)
 {
 	int i = 0;
 	int irq;
@@ -146,11 +146,12 @@ static int dma_flags(int type, int bus_m
 	return flags;
 }
 
-static void
-pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res, u32 dma,
-				    int type, int bus_master, int transfer)
+static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
+						u32 dma, int type,
+						int bus_master, int transfer)
 {
 	int i = 0;
+
 	while (i < PNP_MAX_DMA &&
 	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
 		i++;
@@ -167,11 +168,11 @@ pnpacpi_parse_allocated_dmaresource(stru
 	}
 }
 
-static void
-pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
-				   u64 io, u64 len, int io_decode)
+static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
+					       u64 io, u64 len, int io_decode)
 {
 	int i = 0;
+
 	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_PORT)
 		i++;
@@ -188,11 +189,12 @@ pnpacpi_parse_allocated_ioresource(struc
 	}
 }
 
-static void
-pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
-				    u64 mem, u64 len, int write_protect)
+static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
+						u64 mem, u64 len,
+						int write_protect)
 {
 	int i = 0;
+
 	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
 	       (i < PNP_MAX_MEM))
 		i++;
@@ -210,9 +212,8 @@ pnpacpi_parse_allocated_memresource(stru
 	}
 }
 
-static void
-pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
-				      struct acpi_resource *res)
+static void pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
+						  struct acpi_resource *res)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
@@ -229,16 +230,13 @@ pnpacpi_parse_allocated_address_space(st
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
 		pnpacpi_parse_allocated_memresource(res_table,
-						    p->minimum,
-						    p->address_length,
-						    p->info.mem.write_protect);
+			p->minimum, p->address_length,
+			p->info.mem.write_protect);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnpacpi_parse_allocated_ioresource(res_table,
-						   p->minimum,
-						   p->address_length,
-						   p->granularity ==
-						   0xfff ? ACPI_DECODE_10 :
-						   ACPI_DECODE_16);
+			p->minimum, p->address_length,
+			p->granularity == 0xfff ? ACPI_DECODE_10 :
+				ACPI_DECODE_16);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
@@ -256,34 +254,27 @@ static acpi_status pnpacpi_allocated_res
 		 */
 		for (i = 0; i < res->data.irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-							    res->data.irq.
-							    interrupts[i],
-							    res->data.irq.
-							    triggering,
-							    res->data.irq.
-							    polarity,
-							    res->data.irq.
-							    sharable);
+				res->data.irq.interrupts[i],
+				res->data.irq.triggering,
+				res->data.irq.polarity,
+				res->data.irq.sharable);
 		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		if (res->data.dma.channel_count > 0)
 			pnpacpi_parse_allocated_dmaresource(res_table,
-							    res->data.dma.
-							    channels[0],
-							    res->data.dma.type,
-							    res->data.dma.
-							    bus_master,
-							    res->data.dma.
-							    transfer);
+				res->data.dma.channels[0],
+				res->data.dma.type,
+				res->data.dma.bus_master,
+				res->data.dma.transfer);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
 		pnpacpi_parse_allocated_ioresource(res_table,
-						   res->data.io.minimum,
-						   res->data.io.address_length,
-						   res->data.io.io_decode);
+			res->data.io.minimum,
+			res->data.io.address_length,
+			res->data.io.io_decode);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -292,10 +283,9 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		pnpacpi_parse_allocated_ioresource(res_table,
-						   res->data.fixed_io.address,
-						   res->data.fixed_io.
-						   address_length,
-						   ACPI_DECODE_10);
+			res->data.fixed_io.address,
+			res->data.fixed_io.address_length,
+			ACPI_DECODE_10);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
@@ -306,28 +296,21 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		pnpacpi_parse_allocated_memresource(res_table,
-						    res->data.memory24.minimum,
-						    res->data.memory24.
-						    address_length,
-						    res->data.memory24.
-						    write_protect);
+			res->data.memory24.minimum,
+			res->data.memory24.address_length,
+			res->data.memory24.write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-						    res->data.memory32.minimum,
-						    res->data.memory32.
-						    address_length,
-						    res->data.memory32.
-						    write_protect);
+			res->data.memory32.minimum,
+			res->data.memory32.address_length,
+			res->data.memory32.write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-						    res->data.fixed_memory32.
-						    address,
-						    res->data.fixed_memory32.
-						    address_length,
-						    res->data.fixed_memory32.
-						    write_protect);
+			res->data.fixed_memory32.address,
+			res->data.fixed_memory32.address_length,
+			res->data.fixed_memory32.write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
@@ -346,18 +329,10 @@ static acpi_status pnpacpi_allocated_res
 
 		for (i = 0; i < res->data.extended_irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-							    res->data.
-							    extended_irq.
-							    interrupts[i],
-							    res->data.
-							    extended_irq.
-							    triggering,
-							    res->data.
-							    extended_irq.
-							    polarity,
-							    res->data.
-							    extended_irq.
-							    sharable);
+				res->data.extended_irq.interrupts[i],
+				res->data.extended_irq.triggering,
+				res->data.extended_irq.polarity,
+				res->data.extended_irq.sharable);
 		}
 		break;
 
@@ -400,7 +375,6 @@ static void pnpacpi_parse_dma_option(str
 	dma->flags = dma_flags(p->type, p->bus_master, p->transfer);
 
 	pnp_register_dma_resource(option, dma);
-	return;
 }
 
 static void pnpacpi_parse_irq_option(struct pnp_option *option,
@@ -421,7 +395,6 @@ static void pnpacpi_parse_irq_option(str
 	irq->flags = irq_flags(p->triggering, p->polarity);
 
 	pnp_register_irq_resource(option, irq);
-	return;
 }
 
 static void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
@@ -442,12 +415,10 @@ static void pnpacpi_parse_ext_irq_option
 	irq->flags = irq_flags(p->triggering, p->polarity);
 
 	pnp_register_irq_resource(option, irq);
-	return;
 }
 
-static void
-pnpacpi_parse_port_option(struct pnp_option *option,
-			  struct acpi_resource_io *io)
+static void pnpacpi_parse_port_option(struct pnp_option *option,
+				      struct acpi_resource_io *io)
 {
 	struct pnp_port *port;
 
@@ -463,12 +434,10 @@ pnpacpi_parse_port_option(struct pnp_opt
 	port->flags = ACPI_DECODE_16 == io->io_decode ?
 	    PNP_PORT_FLAG_16BITADDR : 0;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
-static void
-pnpacpi_parse_fixed_port_option(struct pnp_option *option,
-				struct acpi_resource_fixed_io *io)
+static void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
+					    struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
 
@@ -482,12 +451,10 @@ pnpacpi_parse_fixed_port_option(struct p
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
-static void
-pnpacpi_parse_mem24_option(struct pnp_option *option,
-			   struct acpi_resource_memory24 *p)
+static void pnpacpi_parse_mem24_option(struct pnp_option *option,
+				       struct acpi_resource_memory24 *p)
 {
 	struct pnp_mem *mem;
 
@@ -505,12 +472,10 @@ pnpacpi_parse_mem24_option(struct pnp_op
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpacpi_parse_mem32_option(struct pnp_option *option,
-			   struct acpi_resource_memory32 *p)
+static void pnpacpi_parse_mem32_option(struct pnp_option *option,
+				       struct acpi_resource_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -528,12 +493,10 @@ pnpacpi_parse_mem32_option(struct pnp_op
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-				 struct acpi_resource_fixed_memory32 *p)
+static void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
+					 struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -550,11 +513,10 @@ pnpacpi_parse_fixed_mem32_option(struct 
 	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpacpi_parse_address_option(struct pnp_option *option, struct acpi_resource *r)
+static void pnpacpi_parse_address_option(struct pnp_option *option,
+					 struct acpi_resource *r)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
@@ -635,7 +597,7 @@ static acpi_status pnpacpi_option_resour
 			priority = PNP_RES_PRIORITY_INVALID;
 			break;
 		}
-		/* TBD: Considering performace/robustness bits */
+		/* TBD: Consider performance/robustness bits */
 		option = pnp_register_dependent_option(dev, priority);
 		if (!option)
 			return AE_ERROR;
diff -puN drivers/pnp/pnpbios/bioscalls.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/bioscalls.c
--- a/drivers/pnp/pnpbios/bioscalls.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/bioscalls.c
@@ -1,6 +1,5 @@
 /*
  * bioscalls.c - the lowlevel layer of the PnPBIOS driver
- *
  */
 
 #include <linux/types.h>
@@ -52,7 +51,8 @@ __asm__(".text			\n"
 	"	pushl %eax	\n"
 	"	lcallw *pnp_bios_callpoint\n"
 	"	addl $16, %esp	\n"
-	"	lret		\n" ".previous		\n");
+	"	lret		\n"
+	".previous		\n");
 
 #define Q2_SET_SEL(cpu, selname, address, size) \
 do { \
@@ -125,7 +125,8 @@ static inline u16 call_pnp_bios(u16 func
 			     "popl %%es\n\t"
 			     "popl %%ds\n\t"
 			     "popl %%esi\n\t"
-			     "popl %%edi\n\t" "popl %%ebp\n\t":"=a"(status)
+			     "popl %%edi\n\t"
+			     "popl %%ebp\n\t":"=a"(status)
 			     :"0"((func) | (((u32) arg1) << 16)),
 			     "b"((arg2) | (((u32) arg3) << 16)),
 			     "c"((arg4) | (((u32) arg5) << 16)),
@@ -253,12 +254,12 @@ void pnpbios_print_status(const char *mo
 static int __pnp_bios_dev_node_info(struct pnp_dev_node_info *data)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_NUM_SYS_DEV_NODES, 0, PNP_TS1, 2, PNP_TS1,
-			  PNP_DS, 0, 0, data, sizeof(struct pnp_dev_node_info),
-			  NULL, 0);
+	status = call_pnp_bios(PNP_GET_NUM_SYS_DEV_NODES, 0, PNP_TS1, 2,
+			       PNP_TS1, PNP_DS, 0, 0, data,
+			       sizeof(struct pnp_dev_node_info), NULL, 0);
 	data->no_nodes &= 0xff;
 	return status;
 }
@@ -266,6 +267,7 @@ static int __pnp_bios_dev_node_info(stru
 int pnp_bios_dev_node_info(struct pnp_dev_node_info *data)
 {
 	int status = __pnp_bios_dev_node_info(data);
+
 	if (status)
 		pnpbios_print_status("dev_node_info", status);
 	return status;
@@ -285,27 +287,28 @@ int pnp_bios_dev_node_info(struct pnp_de
  *               or volatile current (0) config
  * Output: *nodenum=next node or 0xff if no more nodes
  */
-static int __pnp_bios_get_dev_node(u8 * nodenum, char boot,
+static int __pnp_bios_get_dev_node(u8 *nodenum, char boot,
 				   struct pnp_bios_node *data)
 {
 	u16 status;
 	u16 tmp_nodenum;
+
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
 	if (!boot && pnpbios_dont_use_current_config)
 		return PNP_FUNCTION_NOT_SUPPORTED;
 	tmp_nodenum = *nodenum;
-	status =
-	    call_pnp_bios(PNP_GET_SYS_DEV_NODE, 0, PNP_TS1, 0, PNP_TS2,
-			  boot ? 2 : 1, PNP_DS, 0, &tmp_nodenum,
-			  sizeof(tmp_nodenum), data, 65536);
+	status = call_pnp_bios(PNP_GET_SYS_DEV_NODE, 0, PNP_TS1, 0, PNP_TS2,
+			       boot ? 2 : 1, PNP_DS, 0, &tmp_nodenum,
+			       sizeof(tmp_nodenum), data, 65536);
 	*nodenum = tmp_nodenum;
 	return status;
 }
 
-int pnp_bios_get_dev_node(u8 * nodenum, char boot, struct pnp_bios_node *data)
+int pnp_bios_get_dev_node(u8 *nodenum, char boot, struct pnp_bios_node *data)
 {
 	int status;
+
 	status = __pnp_bios_get_dev_node(nodenum, boot, data);
 	if (status)
 		pnpbios_print_status("get_dev_node", status);
@@ -322,19 +325,21 @@ static int __pnp_bios_set_dev_node(u8 no
 				   struct pnp_bios_node *data)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
 	if (!boot && pnpbios_dont_use_current_config)
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_SET_SYS_DEV_NODE, nodenum, 0, PNP_TS1,
-			  boot ? 2 : 1, PNP_DS, 0, 0, data, 65536, NULL, 0);
+	status = call_pnp_bios(PNP_SET_SYS_DEV_NODE, nodenum, 0, PNP_TS1,
+			       boot ? 2 : 1, PNP_DS, 0, 0, data, 65536, NULL,
+			       0);
 	return status;
 }
 
 int pnp_bios_set_dev_node(u8 nodenum, char boot, struct pnp_bios_node *data)
 {
 	int status;
+
 	status = __pnp_bios_set_dev_node(nodenum, boot, data);
 	if (status) {
 		pnpbios_print_status("set_dev_node", status);
@@ -348,68 +353,21 @@ int pnp_bios_set_dev_node(u8 nodenum, ch
 	return status;
 }
 
-#if needed
-/*
- * Call PnP BIOS with function 0x03, "get event"
- */
-static int pnp_bios_get_event(u16 * event)
-{
-	u16 status;
-	if (!pnp_bios_present())
-		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_EVENT, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
-			       event, sizeof(u16), NULL, 0);
-	return status;
-}
-#endif
-
-#if needed
-/*
- * Call PnP BIOS with function 0x04, "send message"
- */
-static int pnp_bios_send_message(u16 message)
-{
-	u16 status;
-	if (!pnp_bios_present())
-		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_SEND_MESSAGE, message, PNP_DS, 0, 0, 0, 0, 0, 0,
-			  0, 0, 0);
-	return status;
-}
-#endif
-
 /*
  * Call PnP BIOS with function 0x05, "get docking station information"
  */
 int pnp_bios_dock_station_info(struct pnp_docking_station_info *data)
 {
 	u16 status;
-	if (!pnp_bios_present())
-		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_DOCKING_STATION_INFORMATION, 0, PNP_TS1,
-			  PNP_DS, 0, 0, 0, 0, data,
-			  sizeof(struct pnp_docking_station_info), NULL, 0);
-	return status;
-}
 
-#if needed
-/*
- * Call PnP BIOS with function 0x09, "set statically allocated resource
- * information"
- */
-static int pnp_bios_set_stat_res(char *info)
-{
-	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_SET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS,
-			  0, 0, 0, 0, info, *((u16 *) info), 0, 0);
+	status = call_pnp_bios(PNP_GET_DOCKING_STATION_INFORMATION, 0, PNP_TS1,
+			       PNP_DS, 0, 0, 0, 0, data,
+			       sizeof(struct pnp_docking_station_info), NULL,
+			       0);
 	return status;
 }
-#endif
 
 /*
  * Call PnP BIOS with function 0x0a, "get statically allocated resource
@@ -418,57 +376,43 @@ static int pnp_bios_set_stat_res(char *i
 static int __pnp_bios_get_stat_res(char *info)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS,
-			  0, 0, 0, 0, info, 65536, NULL, 0);
+	status = call_pnp_bios(PNP_GET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1,
+			       PNP_DS, 0, 0, 0, 0, info, 65536, NULL, 0);
 	return status;
 }
 
 int pnp_bios_get_stat_res(char *info)
 {
 	int status;
+
 	status = __pnp_bios_get_stat_res(info);
 	if (status)
 		pnpbios_print_status("get_stat_res", status);
 	return status;
 }
 
-#if needed
-/*
- * Call PnP BIOS with function 0x0b, "get APM id table"
- */
-static int pnp_bios_apm_id_table(char *table, u16 * size)
-{
-	u16 status;
-	if (!pnp_bios_present())
-		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_APM_ID_TABLE, 0, PNP_TS2, 0, PNP_TS1, PNP_DS,
-			  0, 0, table, *size, size, sizeof(u16));
-	return status;
-}
-#endif
-
 /*
  * Call PnP BIOS with function 0x40, "get isa pnp configuration structure"
  */
 static int __pnp_bios_isapnp_config(struct pnp_isa_config_struc *data)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_PNP_ISA_CONFIG_STRUC, 0, PNP_TS1, PNP_DS, 0,
-			  0, 0, 0, data, sizeof(struct pnp_isa_config_struc),
-			  NULL, 0);
+	status = call_pnp_bios(PNP_GET_PNP_ISA_CONFIG_STRUC, 0, PNP_TS1, PNP_DS,
+			       0, 0, 0, 0, data,
+			       sizeof(struct pnp_isa_config_struc), NULL, 0);
 	return status;
 }
 
 int pnp_bios_isapnp_config(struct pnp_isa_config_struc *data)
 {
 	int status;
+
 	status = __pnp_bios_isapnp_config(data);
 	if (status)
 		pnpbios_print_status("isapnp_config", status);
@@ -481,18 +425,19 @@ int pnp_bios_isapnp_config(struct pnp_is
 static int __pnp_bios_escd_info(struct escd_info_struc *data)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_GET_ESCD_INFO, 0, PNP_TS1, 2, PNP_TS1, 4, PNP_TS1,
-			  PNP_DS, data, sizeof(struct escd_info_struc), NULL,
-			  0);
+	status = call_pnp_bios(PNP_GET_ESCD_INFO, 0, PNP_TS1, 2, PNP_TS1, 4,
+			       PNP_TS1, PNP_DS, data,
+			       sizeof(struct escd_info_struc), NULL, 0);
 	return status;
 }
 
 int pnp_bios_escd_info(struct escd_info_struc *data)
 {
 	int status;
+
 	status = __pnp_bios_escd_info(data);
 	if (status)
 		pnpbios_print_status("escd_info", status);
@@ -506,46 +451,28 @@ int pnp_bios_escd_info(struct escd_info_
 static int __pnp_bios_read_escd(char *data, u32 nvram_base)
 {
 	u16 status;
+
 	if (!pnp_bios_present())
 		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_READ_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
-			  data, 65536, __va(nvram_base), 65536);
+	status = call_pnp_bios(PNP_READ_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0,
+			       0, data, 65536, __va(nvram_base), 65536);
 	return status;
 }
 
 int pnp_bios_read_escd(char *data, u32 nvram_base)
 {
 	int status;
+
 	status = __pnp_bios_read_escd(data, nvram_base);
 	if (status)
 		pnpbios_print_status("read_escd", status);
 	return status;
 }
 
-#if needed
-/*
- * Call PnP BIOS function 0x43, "write ESCD"
- */
-static int pnp_bios_write_escd(char *data, u32 nvram_base)
-{
-	u16 status;
-	if (!pnp_bios_present())
-		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status =
-	    call_pnp_bios(PNP_WRITE_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
-			  data, 65536, __va(nvram_base), 65536);
-	return status;
-}
-#endif
-
-/*
- * Initialization
- */
-
 void pnpbios_calls_init(union pnp_bios_install_struct *header)
 {
 	int i;
+
 	spin_lock_init(&pnp_bios_lock);
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
diff -puN drivers/pnp/pnpbios/core.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/core.c
@@ -100,25 +100,24 @@ static struct completion unload_sem;
 /*
  * (Much of this belongs in a shared routine somewhere)
  */
-
 static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 {
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
-	if (!current->fs->root) {
+	if (!current->fs->root)
 		return -EAGAIN;
-	}
-	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL))) {
+	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL)))
 		return -ENOMEM;
-	}
 	if (!(buf = kzalloc(256, GFP_KERNEL))) {
 		kfree(envp);
 		return -ENOMEM;
 	}
 
-	/* FIXME: if there are actual users of this, it should be integrated into
-	 * the driver core and use the usual infrastructure like sysfs and uevents */
+	/* FIXME: if there are actual users of this, it should be
+	 * integrated into the driver core and use the usual infrastructure
+	 * like sysfs and uevents
+	 */
 	argv[0] = "/sbin/pnpbios";
 	argv[1] = "dock";
 	argv[2] = NULL;
@@ -146,7 +145,7 @@ static int pnp_dock_event(int dock, stru
 			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 
-	value = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
 	kfree(buf);
 	kfree(envp);
 	return 0;
@@ -159,6 +158,7 @@ static int pnp_dock_thread(void *unused)
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
+
 	set_freezable();
 	while (!unloading) {
 		int status;
@@ -203,7 +203,7 @@ static int pnp_dock_thread(void *unused)
 	complete_and_exit(&unload_sem, 0);
 }
 
-#endif /* CONFIG_HOTPLUG */
+#endif				/* CONFIG_HOTPLUG */
 
 static int pnpbios_get_resources(struct pnp_dev *dev,
 				 struct pnp_resource_table *res)
@@ -211,7 +211,6 @@ static int pnpbios_get_resources(struct 
 	u8 nodenum = dev->number;
 	struct pnp_bios_node *node;
 
-	/* just in case */
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
@@ -235,7 +234,6 @@ static int pnpbios_set_resources(struct 
 	struct pnp_bios_node *node;
 	int ret;
 
-	/* just in case */
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
@@ -263,6 +261,7 @@ static void pnpbios_zero_data_stream(str
 	unsigned char *end = (char *)(node->data + node->size);
 	unsigned int len;
 	int i;
+
 	while ((char *)p < (char *)end) {
 		if (p[0] & 0x80) {	/* large tag */
 			len = (p[2] << 8) | p[1];
@@ -287,7 +286,6 @@ static int pnpbios_disable_resources(str
 	u8 nodenum = dev->number;
 	int ret;
 
-	/* just in case */
 	if (dev->flags & PNPBIOS_NO_DISABLE || !pnpbios_is_dynamic(dev))
 		return -EPERM;
 
@@ -418,8 +416,8 @@ static void __init build_devlist(void)
  *
  */
 
-static int pnpbios_disabled;	/* = 0 */
-int pnpbios_dont_use_current_config;	/* = 0 */
+static int pnpbios_disabled;
+int pnpbios_dont_use_current_config;
 
 #ifndef MODULE
 static int __init pnpbios_setup(char *str)
@@ -551,7 +549,7 @@ static int __init pnpbios_init(void)
 		printk(KERN_INFO "PnPBIOS: Disabled by ACPI PNP\n");
 		return -ENODEV;
 	}
-#endif /* CONFIG_ACPI */
+#endif				/* CONFIG_ACPI */
 
 	/* scan the system for pnpbios support */
 	if (!pnpbios_probe_system())
diff -puN drivers/pnp/pnpbios/proc.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/proc.c
@@ -18,9 +18,6 @@
  * The other files are human-readable.
  */
 
-//#include <pcmcia/config.h>
-//#include <pcmcia/k_compat.h>
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -297,6 +294,4 @@ void __exit pnpbios_proc_exit(void)
 	remove_proc_entry("devices", proc_pnp);
 	remove_proc_entry("boot", proc_pnp);
 	remove_proc_entry("pnp", proc_bus);
-
-	return;
 }
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -1,6 +1,5 @@
 /*
  * rsparser.c - parses and encodes pnpbios resource data streams
- *
  */
 
 #include <linux/ctype.h>
@@ -15,7 +14,7 @@
 inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 }
-#endif /* CONFIG_PCI */
+#endif				/* CONFIG_PCI */
 
 #include "pnpbios.h"
 
@@ -54,10 +53,11 @@ inline void pcibios_penalize_isa_irq(int
  * Allocated Resources
  */
 
-static void
-pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res, int irq)
+static void pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res,
+						int irq)
 {
 	int i = 0;
+
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
 	       && i < PNP_MAX_IRQ)
 		i++;
@@ -73,10 +73,11 @@ pnpbios_parse_allocated_irqresource(stru
 	}
 }
 
-static void
-pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res, int dma)
+static void pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res,
+						int dma)
 {
 	int i = 0;
+
 	while (i < PNP_MAX_DMA &&
 	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
 		i++;
@@ -91,11 +92,11 @@ pnpbios_parse_allocated_dmaresource(stru
 	}
 }
 
-static void
-pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res, int io,
-				   int len)
+static void pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res,
+					       int io, int len)
 {
 	int i = 0;
+
 	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
 	       && i < PNP_MAX_PORT)
 		i++;
@@ -110,11 +111,11 @@ pnpbios_parse_allocated_ioresource(struc
 	}
 }
 
-static void
-pnpbios_parse_allocated_memresource(struct pnp_resource_table *res, int mem,
-				    int len)
+static void pnpbios_parse_allocated_memresource(struct pnp_resource_table *res,
+						int mem, int len)
 {
 	int i = 0;
+
 	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
 	       && i < PNP_MAX_MEM)
 		i++;
@@ -261,10 +262,11 @@ static unsigned char *pnpbios_parse_allo
  * Resource Configuration Options
  */
 
-static void
-pnpbios_parse_mem_option(unsigned char *p, int size, struct pnp_option *option)
+static void pnpbios_parse_mem_option(unsigned char *p, int size,
+				     struct pnp_option *option)
 {
 	struct pnp_mem *mem;
+
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -274,14 +276,13 @@ pnpbios_parse_mem_option(unsigned char *
 	mem->size = ((p[11] << 8) | p[10]) << 8;
 	mem->flags = p[3];
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpbios_parse_mem32_option(unsigned char *p, int size,
-			   struct pnp_option *option)
+static void pnpbios_parse_mem32_option(unsigned char *p, int size,
+				       struct pnp_option *option)
 {
 	struct pnp_mem *mem;
+
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -291,12 +292,10 @@ pnpbios_parse_mem32_option(unsigned char
 	mem->size = (p[19] << 24) | (p[18] << 16) | (p[17] << 8) | p[16];
 	mem->flags = p[3];
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
-				 struct pnp_option *option)
+static void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
+					     struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
@@ -307,11 +306,10 @@ pnpbios_parse_fixed_mem32_option(unsigne
 	mem->align = 0;
 	mem->flags = p[3];
 	pnp_register_mem_resource(option, mem);
-	return;
 }
 
-static void
-pnpbios_parse_irq_option(unsigned char *p, int size, struct pnp_option *option)
+static void pnpbios_parse_irq_option(unsigned char *p, int size,
+				     struct pnp_option *option)
 {
 	struct pnp_irq *irq;
 	unsigned long bits;
@@ -326,26 +324,26 @@ pnpbios_parse_irq_option(unsigned char *
 	else
 		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
 	pnp_register_irq_resource(option, irq);
-	return;
 }
 
-static void
-pnpbios_parse_dma_option(unsigned char *p, int size, struct pnp_option *option)
+static void pnpbios_parse_dma_option(unsigned char *p, int size,
+				     struct pnp_option *option)
 {
 	struct pnp_dma *dma;
+
 	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
 	if (!dma)
 		return;
 	dma->map = p[1];
 	dma->flags = p[2];
 	pnp_register_dma_resource(option, dma);
-	return;
 }
 
-static void
-pnpbios_parse_port_option(unsigned char *p, int size, struct pnp_option *option)
+static void pnpbios_parse_port_option(unsigned char *p, int size,
+				      struct pnp_option *option)
 {
 	struct pnp_port *port;
+
 	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
@@ -355,14 +353,13 @@ pnpbios_parse_port_option(unsigned char 
 	port->size = p[7];
 	port->flags = p[1] ? PNP_PORT_FLAG_16BITADDR : 0;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
-static void
-pnpbios_parse_fixed_port_option(unsigned char *p, int size,
-				struct pnp_option *option)
+static void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
+					    struct pnp_option *option)
 {
 	struct pnp_port *port;
+
 	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
@@ -371,7 +368,6 @@ pnpbios_parse_fixed_port_option(unsigned
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
 	pnp_register_port_resource(option, port);
-	return;
 }
 
 static unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
@@ -498,7 +494,6 @@ static unsigned char *pnpbios_parse_reso
 
 #define HEX(id,a) hex[((id)>>a) & 15]
 #define CHAR(id,a) (0x40 + (((id)>>a) & 31))
-//
 
 void pnpid32_to_pnpid(u32 id, char *str)
 {
@@ -513,11 +508,8 @@ void pnpid32_to_pnpid(u32 id, char *str)
 	str[5] = HEX(id, 4);
 	str[6] = HEX(id, 0);
 	str[7] = '\0';
-
-	return;
 }
 
-//
 #undef CHAR
 #undef HEX
 
@@ -598,19 +590,20 @@ static void pnpbios_encode_mem(unsigned 
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
+
 	p[4] = (base >> 8) & 0xff;
 	p[5] = ((base >> 8) >> 8) & 0xff;
 	p[6] = (base >> 8) & 0xff;
 	p[7] = ((base >> 8) >> 8) & 0xff;
 	p[10] = (len >> 8) & 0xff;
 	p[11] = ((len >> 8) >> 8) & 0xff;
-	return;
 }
 
 static void pnpbios_encode_mem32(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
+
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
 	p[6] = (base >> 16) & 0xff;
@@ -623,13 +616,13 @@ static void pnpbios_encode_mem32(unsigne
 	p[17] = (len >> 8) & 0xff;
 	p[18] = (len >> 16) & 0xff;
 	p[19] = (len >> 24) & 0xff;
-	return;
 }
 
 static void pnpbios_encode_fixed_mem32(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
+
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
 	p[6] = (base >> 16) & 0xff;
@@ -638,46 +631,45 @@ static void pnpbios_encode_fixed_mem32(u
 	p[9] = (len >> 8) & 0xff;
 	p[10] = (len >> 16) & 0xff;
 	p[11] = (len >> 24) & 0xff;
-	return;
 }
 
 static void pnpbios_encode_irq(unsigned char *p, struct resource *res)
 {
 	unsigned long map = 0;
+
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
-	return;
 }
 
 static void pnpbios_encode_dma(unsigned char *p, struct resource *res)
 {
 	unsigned long map = 0;
+
 	map = 1 << res->start;
 	p[1] = map & 0xff;
-	return;
 }
 
 static void pnpbios_encode_port(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
+
 	p[2] = base & 0xff;
 	p[3] = (base >> 8) & 0xff;
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
 	p[7] = len & 0xff;
-	return;
 }
 
 static void pnpbios_encode_fixed_port(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
+
 	p[1] = base & 0xff;
 	p[2] = (base >> 8) & 0xff;
 	p[3] = len & 0xff;
-	return;
 }
 
 static unsigned char *pnpbios_encode_allocated_resource_data(unsigned char *p,
@@ -792,6 +784,7 @@ int pnpbios_parse_data_stream(struct pnp
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
+
 	p = pnpbios_parse_allocated_resource_data(p, end, &dev->res);
 	if (!p)
 		return -EIO;
@@ -804,24 +797,24 @@ int pnpbios_parse_data_stream(struct pnp
 	return 0;
 }
 
-int
-pnpbios_read_resources_from_node(struct pnp_resource_table *res,
-				 struct pnp_bios_node *node)
+int pnpbios_read_resources_from_node(struct pnp_resource_table *res,
+				     struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
+
 	p = pnpbios_parse_allocated_resource_data(p, end, res);
 	if (!p)
 		return -EIO;
 	return 0;
 }
 
-int
-pnpbios_write_resources_to_node(struct pnp_resource_table *res,
-				struct pnp_bios_node *node)
+int pnpbios_write_resources_to_node(struct pnp_resource_table *res,
+				    struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
+
 	p = pnpbios_encode_allocated_resource_data(p, end, res);
 	if (!p)
 		return -EIO;
diff -puN drivers/pnp/quirks.c~pnp-fix-up-after-lindent drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/quirks.c
@@ -105,7 +105,6 @@ static void quirk_sb16audio_resources(st
 	if (changed)
 		printk(KERN_INFO
 		       "pnp: SB audio device quirk - increasing port range\n");
-	return;
 }
 
 static int quirk_smc_fir_enabled(struct pnp_dev *dev)
diff -puN drivers/pnp/resource.c~pnp-fix-up-after-lindent drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/resource.c
@@ -3,7 +3,6 @@
  *
  * based on isapnp.c resource management (c) Jaroslav Kysela <perex@suse.cz>
  * Copyright 2003 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/module.h>
@@ -20,10 +19,10 @@
 #include <linux/pnp.h>
 #include "base.h"
 
-static int pnp_reserve_irq[16] = {[0...15] = -1 };	/* reserve (don't use) some IRQ */
-static int pnp_reserve_dma[8] = {[0...7] = -1 };	/* reserve (don't use) some DMA */
-static int pnp_reserve_io[16] = {[0...15] = -1 };	/* reserve (don't use) some I/O region */
-static int pnp_reserve_mem[16] = {[0...15] = -1 };	/* reserve (don't use) some memory region */
+static int pnp_reserve_irq[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some IRQ */
+static int pnp_reserve_dma[8] = {[0 ... 7] = -1 };	/* reserve (don't use) some DMA */
+static int pnp_reserve_io[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some I/O region */
+static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some memory region */
 
 /*
  * option registration
@@ -33,7 +32,6 @@ static struct pnp_option *pnp_build_opti
 {
 	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
 
-	/* check if pnp_alloc ran out of memory */
 	if (!option)
 		return NULL;
 
@@ -48,6 +46,7 @@ static struct pnp_option *pnp_build_opti
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev)
 {
 	struct pnp_option *option;
+
 	if (!dev)
 		return NULL;
 
@@ -64,6 +63,7 @@ struct pnp_option *pnp_register_dependen
 						 int priority)
 {
 	struct pnp_option *option;
+
 	if (!dev)
 		return NULL;
 
@@ -82,6 +82,7 @@ struct pnp_option *pnp_register_dependen
 int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data)
 {
 	struct pnp_irq *ptr;
+
 	if (!option)
 		return -EINVAL;
 	if (!data)
@@ -110,6 +111,7 @@ int pnp_register_irq_resource(struct pnp
 int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data)
 {
 	struct pnp_dma *ptr;
+
 	if (!option)
 		return -EINVAL;
 	if (!data)
@@ -129,6 +131,7 @@ int pnp_register_dma_resource(struct pnp
 int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data)
 {
 	struct pnp_port *ptr;
+
 	if (!option)
 		return -EINVAL;
 	if (!data)
@@ -148,6 +151,7 @@ int pnp_register_port_resource(struct pn
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data)
 {
 	struct pnp_mem *ptr;
+
 	if (!option)
 		return -EINVAL;
 	if (!data)
@@ -240,6 +244,7 @@ int pnp_check_port(struct pnp_dev *dev, 
 	int tmp;
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
+
 	port = &dev->res.port_resource[idx].start;
 	end = &dev->res.port_resource[idx].end;
 
@@ -297,6 +302,7 @@ int pnp_check_mem(struct pnp_dev *dev, i
 	int tmp;
 	struct pnp_dev *tdev;
 	resource_size_t *addr, *end, *taddr, *tend;
+
 	addr = &dev->res.mem_resource[idx].start;
 	end = &dev->res.mem_resource[idx].end;
 
@@ -474,22 +480,12 @@ int pnp_check_dma(struct pnp_dev *dev, i
 
 	return 1;
 #else
-	/* IA64 hasn't legacy DMA */
+	/* IA64 does not have legacy DMA */
 	return 0;
 #endif
 }
 
-#if 0
-EXPORT_SYMBOL(pnp_register_dependent_option);
-EXPORT_SYMBOL(pnp_register_independent_option);
-EXPORT_SYMBOL(pnp_register_irq_resource);
-EXPORT_SYMBOL(pnp_register_dma_resource);
-EXPORT_SYMBOL(pnp_register_port_resource);
-EXPORT_SYMBOL(pnp_register_mem_resource);
-#endif /*  0  */
-
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
-
 static int __init pnp_setup_reserve_irq(char *str)
 {
 	int i;
@@ -503,7 +499,6 @@ static int __init pnp_setup_reserve_irq(
 __setup("pnp_reserve_irq=", pnp_setup_reserve_irq);
 
 /* format is: pnp_reserve_dma=dma1[,dma2] .... */
-
 static int __init pnp_setup_reserve_dma(char *str)
 {
 	int i;
@@ -517,7 +512,6 @@ static int __init pnp_setup_reserve_dma(
 __setup("pnp_reserve_dma=", pnp_setup_reserve_dma);
 
 /* format is: pnp_reserve_io=io1,size1[,io2,size2] .... */
-
 static int __init pnp_setup_reserve_io(char *str)
 {
 	int i;
@@ -531,7 +525,6 @@ static int __init pnp_setup_reserve_io(c
 __setup("pnp_reserve_io=", pnp_setup_reserve_io);
 
 /* format is: pnp_reserve_mem=mem1,size1[,mem2,size2] .... */
-
 static int __init pnp_setup_reserve_mem(char *str)
 {
 	int i;
diff -puN drivers/pnp/support.c~pnp-fix-up-after-lindent drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/support.c
@@ -1,8 +1,7 @@
 /*
- * support.c - provides standard pnp functions for the use of pnp protocol drivers,
+ * support.c - standard functions for the use of pnp protocol drivers
  *
  * Copyright 2003 Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #include <linux/module.h>
@@ -11,11 +10,10 @@
 #include "base.h"
 
 /**
- * pnp_is_active - Determines if a device is active based on its current resources
+ * pnp_is_active - Determines if a device is active based on its current
+ *	resources
  * @dev: pointer to the desired PnP device
- *
  */
-
 int pnp_is_active(struct pnp_dev *dev)
 {
 	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
diff -puN drivers/pnp/system.c~pnp-fix-up-after-lindent drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/system.c
@@ -45,8 +45,7 @@ static void reserve_range(const char *pn
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	printk(KERN_INFO
-	       "pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
+	printk(KERN_INFO "pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
 	       pnpid, port ? "ioport" : "iomem",
 	       (unsigned long long)start, (unsigned long long)end,
 	       NULL != res ? "has been" : "could not be");
@@ -85,8 +84,6 @@ static void reserve_resources_of_dev(con
 		reserve_range(dev->dev.bus_id, pnp_mem_start(dev, i),
 			      pnp_mem_end(dev, i), 0);
 	}
-
-	return;
 }
 
 static int system_pnp_probe(struct pnp_dev *dev,
@@ -97,11 +94,10 @@ static int system_pnp_probe(struct pnp_d
 }
 
 static struct pnp_driver system_pnp_driver = {
-	.name = "system",
+	.name     = "system",
 	.id_table = pnp_dev_table,
-	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
-	.probe = system_pnp_probe,
-	.remove = NULL,
+	.flags    = PNP_DRIVER_RES_DO_NOT_CHANGE,
+	.probe    = system_pnp_probe,
 };
 
 static int __init pnp_system_init(void)
diff -puN include/linux/pnp.h~pnp-fix-up-after-lindent include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-fix-up-after-lindent
+++ a/include/linux/pnp.h
@@ -1,7 +1,6 @@
 /*
  * Linux Plug and Play Support
  * Copyright by Adam Belay <ambx1@neo.rr.com>
- *
  */
 
 #ifndef _LINUX_PNP_H
@@ -83,7 +82,7 @@ struct pnp_port {
 
 #define PNP_IRQ_NR 256
 struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmaks for IRQ lines */
+	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
 	unsigned char flags;	/* IRQ flags */
 	unsigned char pad;	/* pad */
 	struct pnp_irq *next;	/* next IRQ */
@@ -112,10 +111,10 @@ struct pnp_mem {
 
 struct pnp_option {
 	unsigned short priority;	/* priority */
-	struct pnp_port *port;	/* first port */
-	struct pnp_irq *irq;	/* first IRQ */
-	struct pnp_dma *dma;	/* first DMA */
-	struct pnp_mem *mem;	/* first memory resource */
+	struct pnp_port *port;		/* first port */
+	struct pnp_irq *irq;		/* first IRQ */
+	struct pnp_dma *dma;		/* first DMA */
+	struct pnp_mem *mem;		/* first memory resource */
 	struct pnp_option *next;	/* used to chain dependent resources */
 };
 
@@ -131,20 +130,20 @@ struct pnp_resource_table {
  */
 
 struct pnp_card {
-	struct device dev;	/* Driver Model device interface */
-	unsigned char number;	/* used as an index, must be unique */
+	struct device dev;		/* Driver Model device interface */
+	unsigned char number;		/* used as an index, must be unique */
 	struct list_head global_list;	/* node in global list of cards */
 	struct list_head protocol_list;	/* node in protocol's list of cards */
 	struct list_head devices;	/* devices attached to the card */
 
 	struct pnp_protocol *protocol;
-	struct pnp_id *id;	/* contains supported EISA IDs */
+	struct pnp_id *id;		/* contains supported EISA IDs */
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned char pnpver;	/* Plug & Play version */
+	unsigned char pnpver;		/* Plug & Play version */
 	unsigned char productver;	/* product version */
-	unsigned int serial;	/* serial number */
-	unsigned char checksum;	/* if zero - checksum passed */
+	unsigned int serial;		/* serial number */
+	unsigned char checksum;		/* if zero - checksum passed */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/isapnp */
 };
 
@@ -174,9 +173,9 @@ static inline void pnp_set_card_drvdata(
 }
 
 struct pnp_dev {
-	struct device dev;	/* Driver Model device interface */
+	struct device dev;		/* Driver Model device interface */
 	u64 dma_mask;
-	unsigned char number;	/* used as an index, must be unique */
+	unsigned char number;		/* used as an index, must be unique */
 	int status;
 
 	struct list_head global_list;	/* node in global list of devices */
@@ -189,7 +188,7 @@ struct pnp_dev {
 	struct pnp_driver *driver;
 	struct pnp_card_link *card_link;
 
-	struct pnp_id *id;	/* supported EISA IDs */
+	struct pnp_id *id;		/* supported EISA IDs */
 
 	int active;
 	int capabilities;
@@ -198,8 +197,8 @@ struct pnp_dev {
 	struct pnp_resource_table res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned short regs;	/* ISAPnP: supported registers */
-	int flags;		/* used by protocols */
+	unsigned short regs;		/* ISAPnP: supported registers */
+	int flags;			/* used by protocols */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/isapnp */
 	void *data;
 };
@@ -291,11 +290,10 @@ struct pnp_driver {
 	char *name;
 	const struct pnp_device_id *id_table;
 	unsigned int flags;
-	int (*probe) (struct pnp_dev * dev,
-		      const struct pnp_device_id * dev_id);
-	void (*remove) (struct pnp_dev * dev);
-	int (*suspend) (struct pnp_dev * dev, pm_message_t state);
-	int (*resume) (struct pnp_dev * dev);
+	int (*probe) (struct pnp_dev *dev, const struct pnp_device_id *dev_id);
+	void (*remove) (struct pnp_dev *dev);
+	int (*suspend) (struct pnp_dev *dev, pm_message_t state);
+	int (*resume) (struct pnp_dev *dev);
 	struct device_driver driver;
 };
 
@@ -306,11 +304,11 @@ struct pnp_card_driver {
 	char *name;
 	const struct pnp_card_device_id *id_table;
 	unsigned int flags;
-	int (*probe) (struct pnp_card_link * card,
-		      const struct pnp_card_device_id * card_id);
-	void (*remove) (struct pnp_card_link * card);
-	int (*suspend) (struct pnp_card_link * card, pm_message_t state);
-	int (*resume) (struct pnp_card_link * card);
+	int (*probe) (struct pnp_card_link *card,
+		      const struct pnp_card_device_id *card_id);
+	void (*remove) (struct pnp_card_link *card);
+	int (*suspend) (struct pnp_card_link *card, pm_message_t state);
+	int (*resume) (struct pnp_card_link *card);
 	struct pnp_driver link;
 };
 
@@ -329,9 +327,9 @@ struct pnp_protocol {
 	char *name;
 
 	/* resource control functions */
-	int (*get) (struct pnp_dev * dev, struct pnp_resource_table * res);
-	int (*set) (struct pnp_dev * dev, struct pnp_resource_table * res);
-	int (*disable) (struct pnp_dev * dev);
+	int (*get) (struct pnp_dev *dev, struct pnp_resource_table *res);
+	int (*set) (struct pnp_dev *dev, struct pnp_resource_table *res);
+	int (*disable) (struct pnp_dev *dev);
 
 	/* protocol specific suspend/resume */
 	int (*suspend) (struct pnp_dev * dev, pm_message_t state);
@@ -411,159 +409,49 @@ void pnp_unregister_driver(struct pnp_dr
 #else
 
 /* device management */
-static inline int pnp_register_protocol(struct pnp_protocol *protocol)
-{
-	return -ENODEV;
-}
-static inline void pnp_unregister_protocol(struct pnp_protocol *protocol)
-{
-}
-static inline int pnp_init_device(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_add_device(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_device_attach(struct pnp_dev *pnp_dev)
-{
-	return -ENODEV;
-}
-static inline void pnp_device_detach(struct pnp_dev *pnp_dev)
-{;
-}
+static inline int pnp_register_protocol(struct pnp_protocol *protocol) { return -ENODEV; }
+static inline void pnp_unregister_protocol(struct pnp_protocol *protocol) { }
+static inline int pnp_init_device(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_add_device(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_device_attach(struct pnp_dev *pnp_dev) { return -ENODEV; }
+static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { }
 
 #define pnp_platform_devices 0
 
 /* multidevice card support */
-static inline int pnp_add_card(struct pnp_card *card)
-{
-	return -ENODEV;
-}
-static inline void pnp_remove_card(struct pnp_card *card)
-{;
-}
-static inline int pnp_add_card_device(struct pnp_card *card,
-				      struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline void pnp_remove_card_device(struct pnp_dev *dev)
-{;
-}
-static inline int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card)
-{
-	return -ENODEV;
-}
-static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link
-						      *clink, const char *id,
-						      struct pnp_dev *from)
-{
-	return NULL;
-}
-static inline void pnp_release_card_device(struct pnp_dev *dev)
-{;
-}
-static inline int pnp_register_card_driver(struct pnp_card_driver *drv)
-{
-	return -ENODEV;
-}
-static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv)
-{;
-}
+static inline int pnp_add_card(struct pnp_card *card) { return -ENODEV; }
+static inline void pnp_remove_card(struct pnp_card *card) { }
+static inline int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev) { return -ENODEV; }
+static inline void pnp_remove_card_device(struct pnp_dev *dev) { }
+static inline int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card) { return -ENODEV; }
+static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink, const char *id, struct pnp_dev *from) { return NULL; }
+static inline void pnp_release_card_device(struct pnp_dev *dev) { }
+static inline int pnp_register_card_driver(struct pnp_card_driver *drv) { return -ENODEV; }
+static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv) { }
 
 /* resource management */
-static inline struct pnp_option *pnp_register_independent_option(struct pnp_dev
-								 *dev)
-{
-	return NULL;
-}
-static inline struct pnp_option *pnp_register_dependent_option(struct pnp_dev
-							       *dev,
-							       int priority)
-{
-	return NULL;
-}
-static inline int pnp_register_irq_resource(struct pnp_option *option,
-					    struct pnp_irq *data)
-{
-	return -ENODEV;
-}
-static inline int pnp_register_dma_resource(struct pnp_option *option,
-					    struct pnp_dma *data)
-{
-	return -ENODEV;
-}
-static inline int pnp_register_port_resource(struct pnp_option *option,
-					     struct pnp_port *data)
-{
-	return -ENODEV;
-}
-static inline int pnp_register_mem_resource(struct pnp_option *option,
-					    struct pnp_mem *data)
-{
-	return -ENODEV;
-}
-static inline void pnp_init_resource_table(struct pnp_resource_table *table)
-{
-}
-static inline int pnp_manual_config_dev(struct pnp_dev *dev,
-					struct pnp_resource_table *res,
-					int mode)
-{
-	return -ENODEV;
-}
-static inline int pnp_auto_config_dev(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_validate_config(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_start_dev(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_stop_dev(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_activate_dev(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_disable_dev(struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline void pnp_resource_change(struct resource *resource,
-				       resource_size_t start,
-				       resource_size_t size)
-{
-}
+static inline struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev) { return NULL; }
+static inline struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev, int priority) { return NULL; }
+static inline int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data) { return -ENODEV; }
+static inline int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
+static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
+static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
+static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
+static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
+static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
 
 /* protocol helpers */
-static inline int pnp_is_active(struct pnp_dev *dev)
-{
-	return 0;
-}
-static inline int compare_pnp_id(struct pnp_id *pos, const char *id)
-{
-	return -ENODEV;
-}
-static inline int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pnp_register_driver(struct pnp_driver *drv)
-{
-	return -ENODEV;
-}
-static inline void pnp_unregister_driver(struct pnp_driver *drv)
-{;
-}
+static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
+static inline int compare_pnp_id(struct pnp_id *pos, const char *id) { return -ENODEV; }
+static inline int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_register_driver(struct pnp_driver *drv) { return -ENODEV; }
+static inline void pnp_unregister_driver(struct pnp_driver *drv) { }
 
 #endif /* CONFIG_PNP */
 
diff -puN include/linux/pnpbios.h~pnp-fix-up-after-lindent include/linux/pnpbios.h
--- a/include/linux/pnpbios.h~pnp-fix-up-after-lindent
+++ a/include/linux/pnpbios.h
@@ -134,7 +134,7 @@ struct pnp_bios_node {
 extern struct pnp_dev_node_info node_info;
 
 extern int pnp_bios_dev_node_info(struct pnp_dev_node_info *data);
-extern int pnp_bios_get_dev_node(u8 * nodenum, char config,
+extern int pnp_bios_get_dev_node(u8 *nodenum, char config,
 				 struct pnp_bios_node *data);
 extern int pnp_bios_set_dev_node(u8 nodenum, char config,
 				 struct pnp_bios_node *data);
@@ -143,14 +143,6 @@ extern int pnp_bios_isapnp_config(struct
 extern int pnp_bios_escd_info(struct escd_info_struc *data);
 extern int pnp_bios_read_escd(char *data, u32 nvram_base);
 extern int pnp_bios_dock_station_info(struct pnp_docking_station_info *data);
-#define needed 0
-#if needed
-extern int pnp_bios_get_event(u16 * message);
-extern int pnp_bios_send_message(u16 message);
-extern int pnp_bios_set_stat_res(char *info);
-extern int pnp_bios_apm_id_table(char *table, u16 * size);
-extern int pnp_bios_write_escd(char *data, u32 nvram_base);
-#endif
 
 #endif /* CONFIG_PNPBIOS */
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
pnp-lindent-all-source-files.patch
pnp-fix-up-after-lindent.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
