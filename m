From: akpm@linux-foundation.org
Subject: + pnp-lindent-all-source-files.patch added to -mm tree
Date: Thu, 26 Jul 2007 10:20:24 -0700
Message-ID: <200707261720.l6QHKOOQ011224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759810AbXGZRVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 13:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org


The patch titled
     PNP: Lindent all source files
has been added to the -mm tree.  Its filename is
     pnp-lindent-all-source-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: Lindent all source files
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Run Lindent on all PNP source files.

Produced by:

    $ quilt new pnp-lindent
    $ find drivers/pnp -name \*.[ch] | xargs quilt add
    $ quilt add include/linux/{pnp.h,pnpbios.h}
    $ scripts/Lindent drivers/pnp/*.c drivers/pnp/*/*.c include/linux/pnp*.h
    $ quilt refresh --sort

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/card.c              |  137 +++++----
 drivers/pnp/core.c              |   25 -
 drivers/pnp/driver.c            |   58 ++--
 drivers/pnp/interface.c         |  215 ++++++++------
 drivers/pnp/isapnp/compat.c     |   30 --
 drivers/pnp/isapnp/core.c       |  302 ++++++++++++--------
 drivers/pnp/isapnp/proc.c       |   14 
 drivers/pnp/manager.c           |  120 ++++----
 drivers/pnp/pnpacpi/core.c      |   87 +++---
 drivers/pnp/pnpacpi/rsparser.c  |  435 ++++++++++++++++--------------
 drivers/pnp/pnpbios/bioscalls.c |  282 ++++++++++---------
 drivers/pnp/pnpbios/core.c      |  241 ++++++++--------
 drivers/pnp/pnpbios/proc.c      |  102 +++----
 drivers/pnp/pnpbios/rsparser.c  |  278 ++++++++++---------
 drivers/pnp/quirks.c            |   79 ++---
 drivers/pnp/resource.c          |   79 ++---
 drivers/pnp/support.c           |    9 
 drivers/pnp/system.c            |   38 +-
 include/linux/pnp.h             |  363 ++++++++++++++++---------
 include/linux/pnpbios.h         |   62 ++--
 20 files changed, 1653 insertions(+), 1303 deletions(-)

diff -puN drivers/pnp/card.c~pnp-lindent-all-source-files drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/card.c
@@ -13,26 +13,28 @@
 LIST_HEAD(pnp_cards);
 static LIST_HEAD(pnp_card_drivers);
 
-
-static const struct pnp_card_device_id * match_card(struct pnp_card_driver * drv, struct pnp_card * card)
+static const struct pnp_card_device_id *match_card(struct pnp_card_driver *drv,
+						   struct pnp_card *card)
 {
-	const struct pnp_card_device_id * drv_id = drv->id_table;
-	while (*drv_id->id){
-		if (compare_pnp_id(card->id,drv_id->id)) {
+	const struct pnp_card_device_id *drv_id = drv->id_table;
+	while (*drv_id->id) {
+		if (compare_pnp_id(card->id, drv_id->id)) {
 			int i = 0;
 			for (;;) {
 				int found;
 				struct pnp_dev *dev;
-				if (i == PNP_MAX_DEVICES || ! *drv_id->devs[i].id)
+				if (i == PNP_MAX_DEVICES
+				    || !*drv_id->devs[i].id)
 					return drv_id;
 				found = 0;
 				card_for_each_dev(card, dev) {
-					if (compare_pnp_id(dev->id, drv_id->devs[i].id)) {
+					if (compare_pnp_id
+					    (dev->id, drv_id->devs[i].id)) {
 						found = 1;
 						break;
 					}
 				}
-				if (! found)
+				if (!found)
 					break;
 				i++;
 			}
@@ -42,14 +44,14 @@ static const struct pnp_card_device_id *
 	return NULL;
 }
 
-static void card_remove(struct pnp_dev * dev)
+static void card_remove(struct pnp_dev *dev)
 {
 	dev->card_link = NULL;
 }
 
-static void card_remove_first(struct pnp_dev * dev)
+static void card_remove_first(struct pnp_dev *dev)
 {
-	struct pnp_card_driver * drv = to_pnp_card_driver(dev->driver);
+	struct pnp_card_driver *drv = to_pnp_card_driver(dev->driver);
 	if (!dev->card || !drv)
 		return;
 	if (drv->remove)
@@ -67,7 +69,7 @@ static int card_probe(struct pnp_card *c
 
 	if (!drv->probe)
 		return 0;
-	id = match_card(drv,card);
+	id = match_card(drv, card);
 	if (!id)
 		return 0;
 
@@ -97,9 +99,9 @@ static int card_probe(struct pnp_card *c
  *
  */
 
-int pnp_add_card_id(struct pnp_id *id, struct pnp_card * card)
+int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card)
 {
-	struct pnp_id * ptr;
+	struct pnp_id *ptr;
 	if (!id)
 		return -EINVAL;
 	if (!card)
@@ -115,9 +117,9 @@ int pnp_add_card_id(struct pnp_id *id, s
 	return 0;
 }
 
-static void pnp_free_card_ids(struct pnp_card * card)
+static void pnp_free_card_ids(struct pnp_card *card)
 {
-	struct pnp_id * id;
+	struct pnp_id *id;
 	struct pnp_id *next;
 	if (!card)
 		return;
@@ -131,49 +133,52 @@ static void pnp_free_card_ids(struct pnp
 
 static void pnp_release_card(struct device *dmdev)
 {
-	struct pnp_card * card = to_pnp_card(dmdev);
+	struct pnp_card *card = to_pnp_card(dmdev);
 	pnp_free_card_ids(card);
 	kfree(card);
 }
 
-
-static ssize_t pnp_show_card_name(struct device *dmdev, struct device_attribute *attr, char *buf)
+static ssize_t pnp_show_card_name(struct device *dmdev,
+				  struct device_attribute *attr, char *buf)
 {
 	char *str = buf;
 	struct pnp_card *card = to_pnp_card(dmdev);
-	str += sprintf(str,"%s\n", card->name);
+	str += sprintf(str, "%s\n", card->name);
 	return (str - buf);
 }
 
-static DEVICE_ATTR(name,S_IRUGO,pnp_show_card_name,NULL);
+static DEVICE_ATTR(name, S_IRUGO, pnp_show_card_name, NULL);
 
-static ssize_t pnp_show_card_ids(struct device *dmdev, struct device_attribute *attr, char *buf)
+static ssize_t pnp_show_card_ids(struct device *dmdev,
+				 struct device_attribute *attr, char *buf)
 {
 	char *str = buf;
 	struct pnp_card *card = to_pnp_card(dmdev);
-	struct pnp_id * pos = card->id;
+	struct pnp_id *pos = card->id;
 
 	while (pos) {
-		str += sprintf(str,"%s\n", pos->id);
+		str += sprintf(str, "%s\n", pos->id);
 		pos = pos->next;
 	}
 	return (str - buf);
 }
 
-static DEVICE_ATTR(card_id,S_IRUGO,pnp_show_card_ids,NULL);
+static DEVICE_ATTR(card_id, S_IRUGO, pnp_show_card_ids, NULL);
 
 static int pnp_interface_attach_card(struct pnp_card *card)
 {
-	int rc = device_create_file(&card->dev,&dev_attr_name);
-	if (rc) return rc;
-
-	rc = device_create_file(&card->dev,&dev_attr_card_id);
-	if (rc) goto err_name;
+	int rc = device_create_file(&card->dev, &dev_attr_name);
+	if (rc)
+		return rc;
+
+	rc = device_create_file(&card->dev, &dev_attr_card_id);
+	if (rc)
+		goto err_name;
 
 	return 0;
 
-err_name:
-	device_remove_file(&card->dev,&dev_attr_name);
+      err_name:
+	device_remove_file(&card->dev, &dev_attr_name);
 	return rc;
 }
 
@@ -182,14 +187,15 @@ err_name:
  * @card: pointer to the card to add
  */
 
-int pnp_add_card(struct pnp_card * card)
+int pnp_add_card(struct pnp_card *card)
 {
 	int error;
-	struct list_head * pos, * temp;
+	struct list_head *pos, *temp;
 	if (!card || !card->protocol)
 		return -EINVAL;
 
-	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number, card->number);
+	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
+		card->number);
 	card->dev.parent = &card->protocol->dev;
 	card->dev.bus = NULL;
 	card->dev.release = &pnp_release_card;
@@ -205,18 +211,21 @@ int pnp_add_card(struct pnp_card * card)
 		/* we wait until now to add devices in order to ensure the drivers
 		 * will be able to use all of the related devices on the card
 		 * without waiting any unresonable length of time */
-		list_for_each(pos,&card->devices){
+		list_for_each(pos, &card->devices) {
 			struct pnp_dev *dev = card_to_pnp_dev(pos);
 			__pnp_add_device(dev);
 		}
 
 		/* match with card drivers */
-		list_for_each_safe(pos,temp,&pnp_card_drivers){
-			struct pnp_card_driver * drv = list_entry(pos, struct pnp_card_driver, global_list);
-			card_probe(card,drv);
+		list_for_each_safe(pos, temp, &pnp_card_drivers) {
+			struct pnp_card_driver *drv =
+			    list_entry(pos, struct pnp_card_driver,
+				       global_list);
+			card_probe(card, drv);
 		}
 	} else
-		pnp_err("sysfs failure, card '%s' will be unavailable", card->dev.bus_id);
+		pnp_err("sysfs failure, card '%s' will be unavailable",
+			card->dev.bus_id);
 	return error;
 }
 
@@ -225,7 +234,7 @@ int pnp_add_card(struct pnp_card * card)
  * @card: pointer to the card to remove
  */
 
-void pnp_remove_card(struct pnp_card * card)
+void pnp_remove_card(struct pnp_card *card)
 {
 	struct list_head *pos, *temp;
 	if (!card)
@@ -235,7 +244,7 @@ void pnp_remove_card(struct pnp_card * c
 	list_del(&card->global_list);
 	list_del(&card->protocol_list);
 	spin_unlock(&pnp_lock);
-	list_for_each_safe(pos,temp,&card->devices){
+	list_for_each_safe(pos, temp, &card->devices) {
 		struct pnp_dev *dev = card_to_pnp_dev(pos);
 		pnp_remove_card_device(dev);
 	}
@@ -247,14 +256,14 @@ void pnp_remove_card(struct pnp_card * c
  * @dev: pointer to the device to add
  */
 
-int pnp_add_card_device(struct pnp_card * card, struct pnp_dev * dev)
+int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev)
 {
 	if (!card || !dev || !dev->protocol)
 		return -EINVAL;
 	dev->dev.parent = &card->dev;
 	dev->card_link = NULL;
-	snprintf(dev->dev.bus_id, BUS_ID_SIZE, "%02x:%02x.%02x", dev->protocol->number,
-		 card->number,dev->number);
+	snprintf(dev->dev.bus_id, BUS_ID_SIZE, "%02x:%02x.%02x",
+		 dev->protocol->number, card->number, dev->number);
 	spin_lock(&pnp_lock);
 	dev->card = card;
 	list_add_tail(&dev->card_list, &card->devices);
@@ -267,7 +276,7 @@ int pnp_add_card_device(struct pnp_card 
  * @dev: pointer to the device to remove
  */
 
-void pnp_remove_card_device(struct pnp_dev * dev)
+void pnp_remove_card_device(struct pnp_dev *dev)
 {
 	spin_lock(&pnp_lock);
 	dev->card = NULL;
@@ -283,12 +292,13 @@ void pnp_remove_card_device(struct pnp_d
  * @from: Starting place to search from. If NULL it will start from the begining.
  */
 
-struct pnp_dev * pnp_request_card_device(struct pnp_card_link *clink, const char * id, struct pnp_dev * from)
+struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
+					const char *id, struct pnp_dev *from)
 {
-	struct list_head * pos;
-	struct pnp_dev * dev;
-	struct pnp_card_driver * drv;
-	struct pnp_card * card;
+	struct list_head *pos;
+	struct pnp_dev *dev;
+	struct pnp_card_driver *drv;
+	struct pnp_card *card;
 	if (!clink || !id)
 		goto done;
 	card = clink->card;
@@ -302,15 +312,15 @@ struct pnp_dev * pnp_request_card_device
 	}
 	while (pos != &card->devices) {
 		dev = card_to_pnp_dev(pos);
-		if ((!dev->card_link) && compare_pnp_id(dev->id,id))
+		if ((!dev->card_link) && compare_pnp_id(dev->id, id))
 			goto found;
 		pos = pos->next;
 	}
 
-done:
+      done:
 	return NULL;
 
-found:
+      found:
 	dev->card_link = clink;
 	dev->dev.driver = &drv->link.driver;
 	if (pnp_bus_type.probe(&dev->dev))
@@ -320,7 +330,7 @@ found:
 
 	return dev;
 
-err_out:
+      err_out:
 	dev->dev.driver = NULL;
 	dev->card_link = NULL;
 	return NULL;
@@ -331,9 +341,9 @@ err_out:
  * @dev: pointer to the PnP device stucture
  */
 
-void pnp_release_card_device(struct pnp_dev * dev)
+void pnp_release_card_device(struct pnp_dev *dev)
 {
-	struct pnp_card_driver * drv = dev->card_link->driver;
+	struct pnp_card_driver *drv = dev->card_link->driver;
 	if (!drv)
 		return;
 	drv->link.remove = &card_remove;
@@ -368,7 +378,7 @@ static int card_resume(struct pnp_dev *d
  * @drv: pointer to the driver to register
  */
 
-int pnp_register_card_driver(struct pnp_card_driver * drv)
+int pnp_register_card_driver(struct pnp_card_driver *drv)
 {
 	int error;
 	struct list_head *pos, *temp;
@@ -389,9 +399,10 @@ int pnp_register_card_driver(struct pnp_
 	list_add_tail(&drv->global_list, &pnp_card_drivers);
 	spin_unlock(&pnp_lock);
 
-	list_for_each_safe(pos,temp,&pnp_cards){
-		struct pnp_card *card = list_entry(pos, struct pnp_card, global_list);
-		card_probe(card,drv);
+	list_for_each_safe(pos, temp, &pnp_cards) {
+		struct pnp_card *card =
+		    list_entry(pos, struct pnp_card, global_list);
+		card_probe(card, drv);
 	}
 	return 0;
 }
@@ -401,7 +412,7 @@ int pnp_register_card_driver(struct pnp_
  * @drv: pointer to the driver to unregister
  */
 
-void pnp_unregister_card_driver(struct pnp_card_driver * drv)
+void pnp_unregister_card_driver(struct pnp_card_driver *drv)
 {
 	spin_lock(&pnp_lock);
 	list_del(&drv->global_list);
@@ -415,7 +426,7 @@ EXPORT_SYMBOL(pnp_remove_card);
 EXPORT_SYMBOL(pnp_add_card_device);
 EXPORT_SYMBOL(pnp_remove_card_device);
 EXPORT_SYMBOL(pnp_add_card_id);
-#endif  /*  0  */
+#endif /*  0  */
 EXPORT_SYMBOL(pnp_request_card_device);
 EXPORT_SYMBOL(pnp_release_card_device);
 EXPORT_SYMBOL(pnp_register_card_driver);
diff -puN drivers/pnp/core.c~pnp-lindent-all-source-files drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/core.c
@@ -18,7 +18,6 @@
 
 #include "base.h"
 
-
 static LIST_HEAD(pnp_protocols);
 LIST_HEAD(pnp_global);
 DEFINE_SPINLOCK(pnp_lock);
@@ -36,7 +35,7 @@ void *pnp_alloc(long size)
 	void *result;
 
 	result = kzalloc(size, GFP_KERNEL);
-	if (!result){
+	if (!result) {
 		printk(KERN_ERR "pnp: Out of Memory\n");
 		return NULL;
 	}
@@ -53,7 +52,7 @@ void *pnp_alloc(long size)
 int pnp_register_protocol(struct pnp_protocol *protocol)
 {
 	int nodenum;
-	struct list_head * pos;
+	struct list_head *pos;
 
 	if (!protocol)
 		return -EINVAL;
@@ -64,9 +63,9 @@ int pnp_register_protocol(struct pnp_pro
 	spin_lock(&pnp_lock);
 
 	/* assign the lowest unused number */
-	list_for_each(pos,&pnp_protocols) {
-		struct pnp_protocol * cur = to_pnp_protocol(pos);
-		if (cur->number == nodenum){
+	list_for_each(pos, &pnp_protocols) {
+		struct pnp_protocol *cur = to_pnp_protocol(pos);
+		if (cur->number == nodenum) {
 			pos = &pnp_protocols;
 			nodenum++;
 		}
@@ -93,11 +92,10 @@ void pnp_unregister_protocol(struct pnp_
 	device_unregister(&protocol->dev);
 }
 
-
 static void pnp_free_ids(struct pnp_dev *dev)
 {
-	struct pnp_id * id;
-	struct pnp_id * next;
+	struct pnp_id *id;
+	struct pnp_id *next;
 	if (!dev)
 		return;
 	id = dev->id;
@@ -110,7 +108,7 @@ static void pnp_free_ids(struct pnp_dev 
 
 static void pnp_release_device(struct device *dmdev)
 {
-	struct pnp_dev * dev = to_pnp_dev(dmdev);
+	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	pnp_free_option(dev->independent);
 	pnp_free_option(dev->dependent);
 	pnp_free_ids(dev);
@@ -149,7 +147,8 @@ int pnp_add_device(struct pnp_dev *dev)
 	if (!dev || !dev->protocol || dev->card)
 		return -EINVAL;
 	dev->dev.parent = &dev->protocol->dev;
-	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number, dev->number);
+	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
+		dev->number);
 	return __pnp_add_device(dev);
 }
 
@@ -175,7 +174,7 @@ void pnp_remove_device(struct pnp_dev *d
 		return;
 	__pnp_remove_device(dev);
 }
-#endif  /*  0  */
+#endif /*  0  */
 
 static int __init pnp_init(void)
 {
@@ -190,4 +189,4 @@ EXPORT_SYMBOL(pnp_register_protocol);
 EXPORT_SYMBOL(pnp_unregister_protocol);
 EXPORT_SYMBOL(pnp_add_device);
 EXPORT_SYMBOL(pnp_remove_device);
-#endif  /*  0  */
+#endif /*  0  */
diff -puN drivers/pnp/driver.c~pnp-lindent-all-source-files drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/driver.c
@@ -17,11 +17,9 @@ static int compare_func(const char *ida,
 {
 	int i;
 	/* we only need to compare the last 4 chars */
-	for (i=3; i<7; i++)
-	{
+	for (i = 3; i < 7; i++) {
 		if (ida[i] != 'X' &&
-		    idb[i] != 'X' &&
-		    toupper(ida[i]) != toupper(idb[i]))
+		    idb[i] != 'X' && toupper(ida[i]) != toupper(idb[i]))
 			return 0;
 	}
 	return 1;
@@ -31,18 +29,19 @@ int compare_pnp_id(struct pnp_id *pos, c
 {
 	if (!pos || !id || (strlen(id) != 7))
 		return 0;
-	if (memcmp(id,"ANYDEVS",7)==0)
+	if (memcmp(id, "ANYDEVS", 7) == 0)
 		return 1;
-	while (pos){
-		if (memcmp(pos->id,id,3)==0)
-			if (compare_func(pos->id,id)==1)
+	while (pos) {
+		if (memcmp(pos->id, id, 3) == 0)
+			if (compare_func(pos->id, id) == 1)
 				return 1;
 		pos = pos->next;
 	}
 	return 0;
 }
 
-static const struct pnp_device_id * match_device(struct pnp_driver *drv, struct pnp_dev *dev)
+static const struct pnp_device_id *match_device(struct pnp_driver *drv,
+						struct pnp_dev *dev)
 {
 	const struct pnp_device_id *drv_id = drv->id_table;
 	if (!drv_id)
@@ -59,7 +58,7 @@ static const struct pnp_device_id * matc
 int pnp_device_attach(struct pnp_dev *pnp_dev)
 {
 	spin_lock(&pnp_lock);
-	if(pnp_dev->status != PNP_READY){
+	if (pnp_dev->status != PNP_READY) {
 		spin_unlock(&pnp_lock);
 		return -EBUSY;
 	}
@@ -86,7 +85,8 @@ static int pnp_device_probe(struct devic
 	pnp_dev = to_pnp_dev(dev);
 	pnp_drv = to_pnp_driver(dev->driver);
 
-	pnp_dbg("match found with the PnP device '%s' and the driver '%s'", dev->bus_id,pnp_drv->name);
+	pnp_dbg("match found with the PnP device '%s' and the driver '%s'",
+		dev->bus_id, pnp_drv->name);
 
 	error = pnp_device_attach(pnp_dev);
 	if (error < 0)
@@ -99,7 +99,7 @@ static int pnp_device_probe(struct devic
 				return error;
 		}
 	} else if ((pnp_drv->flags & PNP_DRIVER_RES_DISABLE)
-		    == PNP_DRIVER_RES_DISABLE) {
+		   == PNP_DRIVER_RES_DISABLE) {
 		error = pnp_disable_dev(pnp_dev);
 		if (error < 0)
 			return error;
@@ -110,22 +110,22 @@ static int pnp_device_probe(struct devic
 		if (dev_id != NULL)
 			error = pnp_drv->probe(pnp_dev, dev_id);
 	}
-	if (error >= 0){
+	if (error >= 0) {
 		pnp_dev->driver = pnp_drv;
 		error = 0;
 	} else
 		goto fail;
 	return error;
 
-fail:
+      fail:
 	pnp_device_detach(pnp_dev);
 	return error;
 }
 
 static int pnp_device_remove(struct device *dev)
 {
-	struct pnp_dev * pnp_dev = to_pnp_dev(dev);
-	struct pnp_driver * drv = pnp_dev->driver;
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *drv = pnp_dev->driver;
 
 	if (drv) {
 		if (drv->remove)
@@ -138,8 +138,8 @@ static int pnp_device_remove(struct devi
 
 static int pnp_bus_match(struct device *dev, struct device_driver *drv)
 {
-	struct pnp_dev * pnp_dev = to_pnp_dev(dev);
-	struct pnp_driver * pnp_drv = to_pnp_driver(drv);
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *pnp_drv = to_pnp_driver(drv);
 	if (match_device(pnp_drv, pnp_dev) == NULL)
 		return 0;
 	return 1;
@@ -147,8 +147,8 @@ static int pnp_bus_match(struct device *
 
 static int pnp_bus_suspend(struct device *dev, pm_message_t state)
 {
-	struct pnp_dev * pnp_dev = to_pnp_dev(dev);
-	struct pnp_driver * pnp_drv = pnp_dev->driver;
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *pnp_drv = pnp_dev->driver;
 	int error;
 
 	if (!pnp_drv)
@@ -162,9 +162,9 @@ static int pnp_bus_suspend(struct device
 
 	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
 	    pnp_can_disable(pnp_dev)) {
-	    	error = pnp_stop_dev(pnp_dev);
-	    	if (error)
-	    		return error;
+		error = pnp_stop_dev(pnp_dev);
+		if (error)
+			return error;
 	}
 
 	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
@@ -174,8 +174,8 @@ static int pnp_bus_suspend(struct device
 
 static int pnp_bus_resume(struct device *dev)
 {
-	struct pnp_dev * pnp_dev = to_pnp_dev(dev);
-	struct pnp_driver * pnp_drv = pnp_dev->driver;
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *pnp_drv = pnp_dev->driver;
 	int error;
 
 	if (!pnp_drv)
@@ -197,10 +197,10 @@ static int pnp_bus_resume(struct device 
 }
 
 struct bus_type pnp_bus_type = {
-	.name	= "pnp",
-	.match	= pnp_bus_match,
-	.probe	= pnp_device_probe,
-	.remove	= pnp_device_remove,
+	.name = "pnp",
+	.match = pnp_bus_match,
+	.probe = pnp_device_probe,
+	.remove = pnp_device_remove,
 	.suspend = pnp_bus_suspend,
 	.resume = pnp_bus_resume,
 };
diff -puN drivers/pnp/interface.c~pnp-lindent-all-source-files drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/interface.c
@@ -29,7 +29,7 @@ struct pnp_info_buffer {
 
 typedef struct pnp_info_buffer pnp_info_buffer_t;
 
-static int pnp_printf(pnp_info_buffer_t * buffer, char *fmt,...)
+static int pnp_printf(pnp_info_buffer_t * buffer, char *fmt, ...)
 {
 	va_list args;
 	int res;
@@ -48,14 +48,18 @@ static int pnp_printf(pnp_info_buffer_t 
 	return res;
 }
 
-static void pnp_print_port(pnp_info_buffer_t *buffer, char *space, struct pnp_port *port)
+static void pnp_print_port(pnp_info_buffer_t * buffer, char *space,
+			   struct pnp_port *port)
 {
-	pnp_printf(buffer, "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
-			space, port->min, port->max, port->align ? (port->align-1) : 0, port->size,
-			port->flags & PNP_PORT_FLAG_16BITADDR ? 16 : 10);
+	pnp_printf(buffer,
+		   "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
+		   space, port->min, port->max,
+		   port->align ? (port->align - 1) : 0, port->size,
+		   port->flags & PNP_PORT_FLAG_16BITADDR ? 16 : 10);
 }
 
-static void pnp_print_irq(pnp_info_buffer_t *buffer, char *space, struct pnp_irq *irq)
+static void pnp_print_irq(pnp_info_buffer_t * buffer, char *space,
+			  struct pnp_irq *irq)
 {
 	int first = 1, i;
 
@@ -85,14 +89,15 @@ static void pnp_print_irq(pnp_info_buffe
 	pnp_printf(buffer, "\n");
 }
 
-static void pnp_print_dma(pnp_info_buffer_t *buffer, char *space, struct pnp_dma *dma)
+static void pnp_print_dma(pnp_info_buffer_t * buffer, char *space,
+			  struct pnp_dma *dma)
 {
 	int first = 1, i;
 	char *s;
 
 	pnp_printf(buffer, "%sdma ", space);
 	for (i = 0; i < 8; i++)
-		if (dma->map & (1<<i)) {
+		if (dma->map & (1 << i)) {
 			if (!first) {
 				pnp_printf(buffer, ",");
 			} else {
@@ -136,12 +141,13 @@ static void pnp_print_dma(pnp_info_buffe
 	pnp_printf(buffer, " %s\n", s);
 }
 
-static void pnp_print_mem(pnp_info_buffer_t *buffer, char *space, struct pnp_mem *mem)
+static void pnp_print_mem(pnp_info_buffer_t * buffer, char *space,
+			  struct pnp_mem *mem)
 {
 	char *s;
 
 	pnp_printf(buffer, "%sMemory 0x%x-0x%x, align 0x%x, size 0x%x",
-			space, mem->min, mem->max, mem->align, mem->size);
+		   space, mem->min, mem->max, mem->align, mem->size);
 	if (mem->flags & IORESOURCE_MEM_WRITEABLE)
 		pnp_printf(buffer, ", writeable");
 	if (mem->flags & IORESOURCE_MEM_CACHEABLE)
@@ -168,7 +174,7 @@ static void pnp_print_mem(pnp_info_buffe
 	pnp_printf(buffer, ", %s\n", s);
 }
 
-static void pnp_print_option(pnp_info_buffer_t *buffer, char *space,
+static void pnp_print_option(pnp_info_buffer_t * buffer, char *space,
 			     struct pnp_option *option, int dep)
 {
 	char *s;
@@ -179,19 +185,19 @@ static void pnp_print_option(pnp_info_bu
 
 	if (dep) {
 		switch (option->priority) {
-			case PNP_RES_PRIORITY_PREFERRED:
+		case PNP_RES_PRIORITY_PREFERRED:
 			s = "preferred";
 			break;
-			case PNP_RES_PRIORITY_ACCEPTABLE:
+		case PNP_RES_PRIORITY_ACCEPTABLE:
 			s = "acceptable";
 			break;
-			case PNP_RES_PRIORITY_FUNCTIONAL:
+		case PNP_RES_PRIORITY_FUNCTIONAL:
 			s = "functional";
 			break;
-			default:
+		default:
 			s = "invalid";
 		}
-		pnp_printf(buffer, "Dependent: %02i - Priority %s\n",dep, s);
+		pnp_printf(buffer, "Dependent: %02i - Priority %s\n", dep, s);
 	}
 
 	for (port = option->port; port; port = port->next)
@@ -204,16 +210,16 @@ static void pnp_print_option(pnp_info_bu
 		pnp_print_mem(buffer, space, mem);
 }
 
-
-static ssize_t pnp_show_options(struct device *dmdev, struct device_attribute *attr, char *buf)
+static ssize_t pnp_show_options(struct device *dmdev,
+				struct device_attribute *attr, char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
-	struct pnp_option * independent = dev->independent;
-	struct pnp_option * dependent = dev->dependent;
+	struct pnp_option *independent = dev->independent;
+	struct pnp_option *dependent = dev->dependent;
 	int ret, dep = 1;
 
 	pnp_info_buffer_t *buffer = (pnp_info_buffer_t *)
-				 pnp_alloc(sizeof(pnp_info_buffer_t));
+	    pnp_alloc(sizeof(pnp_info_buffer_t));
 	if (!buffer)
 		return -ENOMEM;
 
@@ -223,7 +229,7 @@ static ssize_t pnp_show_options(struct d
 	if (independent)
 		pnp_print_option(buffer, "", independent, 0);
 
-	while (dependent){
+	while (dependent) {
 		pnp_print_option(buffer, "   ", dependent, dep);
 		dependent = dependent->next;
 		dep++;
@@ -233,10 +239,11 @@ static ssize_t pnp_show_options(struct d
 	return ret;
 }
 
-static DEVICE_ATTR(options,S_IRUGO,pnp_show_options,NULL);
-
+static DEVICE_ATTR(options, S_IRUGO, pnp_show_options, NULL);
 
-static ssize_t pnp_show_current_resources(struct device *dmdev, struct device_attribute *attr, char *buf)
+static ssize_t pnp_show_current_resources(struct device *dmdev,
+					  struct device_attribute *attr,
+					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	int i, ret;
@@ -252,52 +259,56 @@ static ssize_t pnp_show_current_resource
 	buffer->buffer = buf;
 	buffer->curr = buffer->buffer;
 
-	pnp_printf(buffer,"state = ");
+	pnp_printf(buffer, "state = ");
 	if (dev->active)
-		pnp_printf(buffer,"active\n");
+		pnp_printf(buffer, "active\n");
 	else
-		pnp_printf(buffer,"disabled\n");
+		pnp_printf(buffer, "disabled\n");
 
 	for (i = 0; i < PNP_MAX_PORT; i++) {
 		if (pnp_port_valid(dev, i)) {
-			pnp_printf(buffer,"io");
+			pnp_printf(buffer, "io");
 			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
-				pnp_printf(buffer," disabled\n");
+				pnp_printf(buffer, " disabled\n");
 			else
-				pnp_printf(buffer," 0x%llx-0x%llx\n",
-					(unsigned long long)pnp_port_start(dev, i),
-					(unsigned long long)pnp_port_end(dev, i));
+				pnp_printf(buffer, " 0x%llx-0x%llx\n",
+					   (unsigned long long)
+					   pnp_port_start(dev, i),
+					   (unsigned long long)pnp_port_end(dev,
+									    i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
 		if (pnp_mem_valid(dev, i)) {
-			pnp_printf(buffer,"mem");
+			pnp_printf(buffer, "mem");
 			if (pnp_mem_flags(dev, i) & IORESOURCE_DISABLED)
-				pnp_printf(buffer," disabled\n");
+				pnp_printf(buffer, " disabled\n");
 			else
-				pnp_printf(buffer," 0x%llx-0x%llx\n",
-					(unsigned long long)pnp_mem_start(dev, i),
-					(unsigned long long)pnp_mem_end(dev, i));
+				pnp_printf(buffer, " 0x%llx-0x%llx\n",
+					   (unsigned long long)
+					   pnp_mem_start(dev, i),
+					   (unsigned long long)pnp_mem_end(dev,
+									   i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
 		if (pnp_irq_valid(dev, i)) {
-			pnp_printf(buffer,"irq");
+			pnp_printf(buffer, "irq");
 			if (pnp_irq_flags(dev, i) & IORESOURCE_DISABLED)
-				pnp_printf(buffer," disabled\n");
+				pnp_printf(buffer, " disabled\n");
 			else
-				pnp_printf(buffer," %lld\n",
-					(unsigned long long)pnp_irq(dev, i));
+				pnp_printf(buffer, " %lld\n",
+					   (unsigned long long)pnp_irq(dev, i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
 		if (pnp_dma_valid(dev, i)) {
-			pnp_printf(buffer,"dma");
+			pnp_printf(buffer, "dma");
 			if (pnp_dma_flags(dev, i) & IORESOURCE_DISABLED)
-				pnp_printf(buffer," disabled\n");
+				pnp_printf(buffer, " disabled\n");
 			else
-				pnp_printf(buffer," %lld\n",
-					(unsigned long long)pnp_dma(dev, i));
+				pnp_printf(buffer, " %lld\n",
+					   (unsigned long long)pnp_dma(dev, i));
 		}
 	}
 	ret = (buffer->curr - buf);
@@ -308,55 +319,57 @@ static ssize_t pnp_show_current_resource
 extern struct semaphore pnp_res_mutex;
 
 static ssize_t
-pnp_set_current_resources(struct device * dmdev, struct device_attribute *attr, const char * ubuf, size_t count)
+pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
+			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
-	char	*buf = (void *)ubuf;
-	int	retval = 0;
+	char *buf = (void *)ubuf;
+	int retval = 0;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
-		pnp_info("Device %s cannot be configured because it is in use.", dev->dev.bus_id);
+		pnp_info("Device %s cannot be configured because it is in use.",
+			 dev->dev.bus_id);
 		goto done;
 	}
 
 	while (isspace(*buf))
 		++buf;
-	if (!strnicmp(buf,"disable",7)) {
+	if (!strnicmp(buf, "disable", 7)) {
 		retval = pnp_disable_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf,"activate",8)) {
+	if (!strnicmp(buf, "activate", 8)) {
 		retval = pnp_activate_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf,"fill",4)) {
+	if (!strnicmp(buf, "fill", 4)) {
 		if (dev->active)
 			goto done;
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf,"auto",4)) {
+	if (!strnicmp(buf, "auto", 4)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resource_table(&dev->res);
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf,"clear",5)) {
+	if (!strnicmp(buf, "clear", 5)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resource_table(&dev->res);
 		goto done;
 	}
-	if (!strnicmp(buf,"get",3)) {
+	if (!strnicmp(buf, "get", 3)) {
 		down(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev, &dev->res);
 		up(&pnp_res_mutex);
 		goto done;
 	}
-	if (!strnicmp(buf,"set",3)) {
+	if (!strnicmp(buf, "set", 3)) {
 		int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 		if (dev->active)
 			goto done;
@@ -366,65 +379,77 @@ pnp_set_current_resources(struct device 
 		while (1) {
 			while (isspace(*buf))
 				++buf;
-			if (!strnicmp(buf,"io",2)) {
+			if (!strnicmp(buf, "io", 2)) {
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start = simple_strtoul(buf,&buf,0);
+				dev->res.port_resource[nport].start =
+				    simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
-				if(*buf == '-') {
+				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end = simple_strtoul(buf,&buf,0);
+					dev->res.port_resource[nport].end =
+					    simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.port_resource[nport].end = dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags = IORESOURCE_IO;
+					dev->res.port_resource[nport].end =
+					    dev->res.port_resource[nport].start;
+				dev->res.port_resource[nport].flags =
+				    IORESOURCE_IO;
 				nport++;
 				if (nport >= PNP_MAX_PORT)
 					break;
 				continue;
 			}
-			if (!strnicmp(buf,"mem",3)) {
+			if (!strnicmp(buf, "mem", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.mem_resource[nmem].start = simple_strtoul(buf,&buf,0);
+				dev->res.mem_resource[nmem].start =
+				    simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
-				if(*buf == '-') {
+				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.mem_resource[nmem].end = simple_strtoul(buf,&buf,0);
+					dev->res.mem_resource[nmem].end =
+					    simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.mem_resource[nmem].end = dev->res.mem_resource[nmem].start;
-				dev->res.mem_resource[nmem].flags = IORESOURCE_MEM;
+					dev->res.mem_resource[nmem].end =
+					    dev->res.mem_resource[nmem].start;
+				dev->res.mem_resource[nmem].flags =
+				    IORESOURCE_MEM;
 				nmem++;
 				if (nmem >= PNP_MAX_MEM)
 					break;
 				continue;
 			}
-			if (!strnicmp(buf,"irq",3)) {
+			if (!strnicmp(buf, "irq", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
 				dev->res.irq_resource[nirq].start =
-				dev->res.irq_resource[nirq].end = simple_strtoul(buf,&buf,0);
-				dev->res.irq_resource[nirq].flags = IORESOURCE_IRQ;
+				    dev->res.irq_resource[nirq].end =
+				    simple_strtoul(buf, &buf, 0);
+				dev->res.irq_resource[nirq].flags =
+				    IORESOURCE_IRQ;
 				nirq++;
 				if (nirq >= PNP_MAX_IRQ)
 					break;
 				continue;
 			}
-			if (!strnicmp(buf,"dma",3)) {
+			if (!strnicmp(buf, "dma", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
 				dev->res.dma_resource[ndma].start =
-				dev->res.dma_resource[ndma].end = simple_strtoul(buf,&buf,0);
-				dev->res.dma_resource[ndma].flags = IORESOURCE_DMA;
+				    dev->res.dma_resource[ndma].end =
+				    simple_strtoul(buf, &buf, 0);
+				dev->res.dma_resource[ndma].flags =
+				    IORESOURCE_DMA;
 				ndma++;
 				if (ndma >= PNP_MAX_DMA)
 					break;
@@ -435,45 +460,49 @@ pnp_set_current_resources(struct device 
 		up(&pnp_res_mutex);
 		goto done;
 	}
- done:
+      done:
 	if (retval < 0)
 		return retval;
 	return count;
 }
 
-static DEVICE_ATTR(resources,S_IRUGO | S_IWUSR,
-		   pnp_show_current_resources,pnp_set_current_resources);
+static DEVICE_ATTR(resources, S_IRUGO | S_IWUSR,
+		   pnp_show_current_resources, pnp_set_current_resources);
 
-static ssize_t pnp_show_current_ids(struct device *dmdev, struct device_attribute *attr, char *buf)
+static ssize_t pnp_show_current_ids(struct device *dmdev,
+				    struct device_attribute *attr, char *buf)
 {
 	char *str = buf;
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
-	struct pnp_id * pos = dev->id;
+	struct pnp_id *pos = dev->id;
 
 	while (pos) {
-		str += sprintf(str,"%s\n", pos->id);
+		str += sprintf(str, "%s\n", pos->id);
 		pos = pos->next;
 	}
 	return (str - buf);
 }
 
-static DEVICE_ATTR(id,S_IRUGO,pnp_show_current_ids,NULL);
+static DEVICE_ATTR(id, S_IRUGO, pnp_show_current_ids, NULL);
 
 int pnp_interface_attach_device(struct pnp_dev *dev)
 {
-	int rc = device_create_file(&dev->dev,&dev_attr_options);
-	if (rc) goto err;
-	rc = device_create_file(&dev->dev,&dev_attr_resources);
-	if (rc) goto err_opt;
-	rc = device_create_file(&dev->dev,&dev_attr_id);
-	if (rc) goto err_res;
+	int rc = device_create_file(&dev->dev, &dev_attr_options);
+	if (rc)
+		goto err;
+	rc = device_create_file(&dev->dev, &dev_attr_resources);
+	if (rc)
+		goto err_opt;
+	rc = device_create_file(&dev->dev, &dev_attr_id);
+	if (rc)
+		goto err_res;
 
 	return 0;
 
-err_res:
-	device_remove_file(&dev->dev,&dev_attr_resources);
-err_opt:
-	device_remove_file(&dev->dev,&dev_attr_options);
-err:
+      err_res:
+	device_remove_file(&dev->dev, &dev_attr_resources);
+      err_opt:
+	device_remove_file(&dev->dev, &dev_attr_options);
+      err:
 	return rc;
 }
diff -puN drivers/pnp/isapnp/compat.c~pnp-lindent-all-source-files drivers/pnp/isapnp/compat.c
--- a/drivers/pnp/isapnp/compat.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/isapnp/compat.c
@@ -5,28 +5,26 @@
  * Copyright 2002 Adam Belay <ambx1@neo.rr.com>
  *
  */
- 
+
 /* TODO: see if more isapnp functions are needed here */
 
 #include <linux/module.h>
 #include <linux/isapnp.h>
 #include <linux/string.h>
 
-static void pnp_convert_id(char *buf, unsigned short vendor, unsigned short device)
+static void pnp_convert_id(char *buf, unsigned short vendor,
+			   unsigned short device)
 {
 	sprintf(buf, "%c%c%c%x%x%x%x",
-			'A' + ((vendor >> 2) & 0x3f) - 1,
-			'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
-			'A' + ((vendor >> 8) & 0x1f) - 1,
-			(device >> 4) & 0x0f,
-			device & 0x0f,
-			(device >> 12) & 0x0f,
-			(device >> 8) & 0x0f);
+		'A' + ((vendor >> 2) & 0x3f) - 1,
+		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
+		'A' + ((vendor >> 8) & 0x1f) - 1,
+		(device >> 4) & 0x0f,
+		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
 }
 
 struct pnp_card *pnp_find_card(unsigned short vendor,
-			       unsigned short device,
-			       struct pnp_card *from)
+			       unsigned short device, struct pnp_card *from)
 {
 	char id[8];
 	char any[8];
@@ -38,7 +36,7 @@ struct pnp_card *pnp_find_card(unsigned 
 
 	while (list != &pnp_cards) {
 		struct pnp_card *card = global_to_pnp_card(list);
-		if (compare_pnp_id(card->id,id) || (memcmp(id,any,7)==0))
+		if (compare_pnp_id(card->id, id) || (memcmp(id, any, 7) == 0))
 			return card;
 		list = list->next;
 	}
@@ -47,8 +45,7 @@ struct pnp_card *pnp_find_card(unsigned 
 
 struct pnp_dev *pnp_find_dev(struct pnp_card *card,
 			     unsigned short vendor,
-			     unsigned short function,
-			     struct pnp_dev *from)
+			     unsigned short function, struct pnp_dev *from)
 {
 	char id[8];
 	char any[8];
@@ -63,7 +60,8 @@ struct pnp_dev *pnp_find_dev(struct pnp_
 
 		while (list != &pnp_global) {
 			struct pnp_dev *dev = global_to_pnp_dev(list);
-			if (compare_pnp_id(dev->id,id) || (memcmp(id,any,7)==0))
+			if (compare_pnp_id(dev->id, id)
+			    || (memcmp(id, any, 7) == 0))
 				return dev;
 			list = list->next;
 		}
@@ -78,7 +76,7 @@ struct pnp_dev *pnp_find_dev(struct pnp_
 		}
 		while (list != &card->devices) {
 			struct pnp_dev *dev = card_to_pnp_dev(list);
-			if (compare_pnp_id(dev->id,id))
+			if (compare_pnp_id(dev->id, id))
 				return dev;
 			list = list->next;
 		}
diff -puN drivers/pnp/isapnp/core.c~pnp-lindent-all-source-files drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/isapnp/core.c
@@ -51,10 +51,10 @@
 #define ISAPNP_DEBUG
 #endif
 
-int isapnp_disable;			/* Disable ISA PnP */
-static int isapnp_rdp;			/* Read Data Port */
-static int isapnp_reset = 1;		/* reset all PnP cards (deactivate) */
-static int isapnp_verbose = 1;		/* verbose mode */
+int isapnp_disable;		/* Disable ISA PnP */
+static int isapnp_rdp;		/* Read Data Port */
+static int isapnp_reset = 1;	/* reset all PnP cards (deactivate) */
+static int isapnp_verbose = 1;	/* verbose mode */
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@suse.cz>");
 MODULE_DESCRIPTION("Generic ISA Plug & Play support");
@@ -126,7 +126,7 @@ static unsigned short isapnp_read_word(u
 	unsigned short val;
 
 	val = isapnp_read_byte(idx);
-	val = (val << 8) + isapnp_read_byte(idx+1);
+	val = (val << 8) + isapnp_read_byte(idx + 1);
 	return val;
 }
 
@@ -139,7 +139,7 @@ void isapnp_write_byte(unsigned char idx
 static void isapnp_write_word(unsigned char idx, unsigned short val)
 {
 	isapnp_write_byte(idx, val >> 8);
-	isapnp_write_byte(idx+1, val);
+	isapnp_write_byte(idx + 1, val);
 }
 
 static void isapnp_key(void)
@@ -193,7 +193,7 @@ static void isapnp_deactivate(unsigned c
 static void __init isapnp_peek(unsigned char *data, int bytes)
 {
 	int i, j;
-	unsigned char d=0;
+	unsigned char d = 0;
 
 	for (i = 1; i <= bytes; i++) {
 		for (j = 0; j < 20; j++) {
@@ -220,19 +220,18 @@ static int isapnp_next_rdp(void)
 {
 	int rdp = isapnp_rdp;
 	static int old_rdp = 0;
-	
-	if(old_rdp)
-	{
+
+	if (old_rdp) {
 		release_region(old_rdp, 1);
 		old_rdp = 0;
 	}
 	while (rdp <= 0x3ff) {
 		/*
-		 *	We cannot use NE2000 probe spaces for ISAPnP or we
-		 *	will lock up machines.
+		 *      We cannot use NE2000 probe spaces for ISAPnP or we
+		 *      will lock up machines.
 		 */
-		if ((rdp < 0x280 || rdp >  0x380) && request_region(rdp, 1, "ISAPnP"))
-		{
+		if ((rdp < 0x280 || rdp > 0x380)
+		    && request_region(rdp, 1, "ISAPnP")) {
 			isapnp_rdp = rdp;
 			old_rdp = rdp;
 			return 0;
@@ -305,7 +304,9 @@ static int __init isapnp_isolate(void)
 			udelay(250);
 			if (data == 0x55aa)
 				bit = 0x01;
-			checksum = ((((checksum ^ (checksum >> 1)) & 0x01) ^ bit) << 7) | (checksum >> 1);
+			checksum =
+			    ((((checksum ^ (checksum >> 1)) & 0x01) ^ bit) << 7)
+			    | (checksum >> 1);
 			bit = 0x00;
 		}
 		for (i = 65; i <= 72; i++) {
@@ -357,7 +358,7 @@ static int __init isapnp_read_tag(unsign
 	unsigned char tag, tmp[2];
 
 	isapnp_peek(&tag, 1);
-	if (tag == 0)				/* invalid tag */
+	if (tag == 0)		/* invalid tag */
 		return -1;
 	if (tag & 0x80) {	/* large item */
 		*type = tag;
@@ -368,7 +369,8 @@ static int __init isapnp_read_tag(unsign
 		*size = tag & 0x07;
 	}
 #if 0
-	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type, *size);
+	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type,
+	       *size);
 #endif
 	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
 		return -1;
@@ -388,22 +390,21 @@ static void __init isapnp_skip_bytes(int
  *  Parse EISA id.
  */
 
-static void isapnp_parse_id(struct pnp_dev * dev, unsigned short vendor, unsigned short device)
+static void isapnp_parse_id(struct pnp_dev *dev, unsigned short vendor,
+			    unsigned short device)
 {
-	struct pnp_id * id;
+	struct pnp_id *id;
 	if (!dev)
 		return;
 	id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!id)
 		return;
 	sprintf(id->id, "%c%c%c%x%x%x%x",
-			'A' + ((vendor >> 2) & 0x3f) - 1,
-			'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
-			'A' + ((vendor >> 8) & 0x1f) - 1,
-			(device >> 4) & 0x0f,
-			device & 0x0f,
-			(device >> 12) & 0x0f,
-			(device >> 8) & 0x0f);
+		'A' + ((vendor >> 2) & 0x3f) - 1,
+		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
+		'A' + ((vendor >> 8) & 0x1f) - 1,
+		(device >> 4) & 0x0f,
+		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
 	pnp_add_id(id, dev);
 }
 
@@ -411,7 +412,8 @@ static void isapnp_parse_id(struct pnp_d
  *  Parse logical device tag.
  */
 
-static struct pnp_dev * __init isapnp_parse_device(struct pnp_card *card, int size, int number)
+static struct pnp_dev *__init isapnp_parse_device(struct pnp_card *card,
+						  int size, int number)
 {
 	unsigned char tmp[6];
 	struct pnp_dev *dev;
@@ -435,13 +437,12 @@ static struct pnp_dev * __init isapnp_pa
 	return dev;
 }
 
-
 /*
  *  Add IRQ resource to resources list.
  */
 
 static void __init isapnp_parse_irq_resource(struct pnp_option *option,
-					       int size)
+					     int size)
 {
 	unsigned char tmp[3];
 	struct pnp_irq *irq;
@@ -466,7 +467,7 @@ static void __init isapnp_parse_irq_reso
  */
 
 static void __init isapnp_parse_dma_resource(struct pnp_option *option,
-                                    	       int size)
+					     int size)
 {
 	unsigned char tmp[2];
 	struct pnp_dma *dma;
@@ -486,7 +487,7 @@ static void __init isapnp_parse_dma_reso
  */
 
 static void __init isapnp_parse_port_resource(struct pnp_option *option,
-						int size)
+					      int size)
 {
 	unsigned char tmp[7];
 	struct pnp_port *port;
@@ -500,7 +501,7 @@ static void __init isapnp_parse_port_res
 	port->align = tmp[5];
 	port->size = tmp[6];
 	port->flags = tmp[0] ? PNP_PORT_FLAG_16BITADDR : 0;
-	pnp_register_port_resource(option,port);
+	pnp_register_port_resource(option, port);
 	return;
 }
 
@@ -509,7 +510,7 @@ static void __init isapnp_parse_port_res
  */
 
 static void __init isapnp_parse_fixed_port_resource(struct pnp_option *option,
-						      int size)
+						    int size)
 {
 	unsigned char tmp[3];
 	struct pnp_port *port;
@@ -522,7 +523,7 @@ static void __init isapnp_parse_fixed_po
 	port->size = tmp[2];
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
-	pnp_register_port_resource(option,port);
+	pnp_register_port_resource(option, port);
 	return;
 }
 
@@ -531,7 +532,7 @@ static void __init isapnp_parse_fixed_po
  */
 
 static void __init isapnp_parse_mem_resource(struct pnp_option *option,
-					       int size)
+					     int size)
 {
 	unsigned char tmp[9];
 	struct pnp_mem *mem;
@@ -545,7 +546,7 @@ static void __init isapnp_parse_mem_reso
 	mem->align = (tmp[6] << 8) | tmp[5];
 	mem->size = ((tmp[8] << 8) | tmp[7]) << 8;
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 	return;
 }
 
@@ -554,7 +555,7 @@ static void __init isapnp_parse_mem_reso
  */
 
 static void __init isapnp_parse_mem32_resource(struct pnp_option *option,
-						 int size)
+					       int size)
 {
 	unsigned char tmp[17];
 	struct pnp_mem *mem;
@@ -565,10 +566,12 @@ static void __init isapnp_parse_mem32_re
 		return;
 	mem->min = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
 	mem->max = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
-	mem->align = (tmp[12] << 24) | (tmp[11] << 16) | (tmp[10] << 8) | tmp[9];
-	mem->size = (tmp[16] << 24) | (tmp[15] << 16) | (tmp[14] << 8) | tmp[13];
+	mem->align =
+	    (tmp[12] << 24) | (tmp[11] << 16) | (tmp[10] << 8) | tmp[9];
+	mem->size =
+	    (tmp[16] << 24) | (tmp[15] << 16) | (tmp[14] << 8) | tmp[13];
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 }
 
 /*
@@ -576,7 +579,7 @@ static void __init isapnp_parse_mem32_re
  */
 
 static void __init isapnp_parse_fixed_mem32_resource(struct pnp_option *option,
-						       int size)
+						     int size)
 {
 	unsigned char tmp[9];
 	struct pnp_mem *mem;
@@ -585,28 +588,30 @@ static void __init isapnp_parse_fixed_me
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
-	mem->min = mem->max = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
+	mem->min = mem->max =
+	    (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
 	mem->size = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
 	mem->align = 0;
 	mem->flags = tmp[0];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 }
 
 /*
  *  Parse card name for ISA PnP device.
- */ 
+ */
 
 static void __init
 isapnp_parse_name(char *name, unsigned int name_max, unsigned short *size)
 {
 	if (name[0] == '\0') {
-		unsigned short size1 = *size >= name_max ? (name_max - 1) : *size;
+		unsigned short size1 =
+		    *size >= name_max ? (name_max - 1) : *size;
 		isapnp_peek(name, size1);
 		name[size1] = '\0';
 		*size -= size1;
 
 		/* clean whitespace from end of string */
-		while (size1 > 0  &&  name[--size1] == ' ')
+		while (size1 > 0 && name[--size1] == ' ')
 			name[size1] = '\0';
 	}
 }
@@ -629,17 +634,19 @@ static int __init isapnp_create_device(s
 		kfree(dev);
 		return 1;
 	}
-	pnp_add_card_device(card,dev);
+	pnp_add_card_device(card, dev);
 
 	while (1) {
-		if (isapnp_read_tag(&type, &size)<0)
+		if (isapnp_read_tag(&type, &size) < 0)
 			return 1;
 		if (skip && type != _STAG_LOGDEVID && type != _STAG_END)
 			goto __skip;
 		switch (type) {
 		case _STAG_LOGDEVID:
 			if (size >= 5 && size <= 6) {
-				if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
+				if ((dev =
+				     isapnp_parse_device(card, size,
+							 number++)) == NULL)
 					return 1;
 				size = 0;
 				skip = 0;
@@ -648,7 +655,7 @@ static int __init isapnp_create_device(s
 					kfree(dev);
 					return 1;
 				}
-				pnp_add_card_device(card,dev);
+				pnp_add_card_device(card, dev);
 			} else {
 				skip = 1;
 			}
@@ -658,7 +665,8 @@ static int __init isapnp_create_device(s
 		case _STAG_COMPATDEVID:
 			if (size == 4 && compat < DEVICE_COUNT_COMPATIBLE) {
 				isapnp_peek(tmp, 4);
-				isapnp_parse_id(dev,(tmp[1] << 8) | tmp[0], (tmp[3] << 8) | tmp[2]);
+				isapnp_parse_id(dev, (tmp[1] << 8) | tmp[0],
+						(tmp[3] << 8) | tmp[2]);
 				compat++;
 				size = 0;
 			}
@@ -684,7 +692,7 @@ static int __init isapnp_create_device(s
 				priority = 0x100 | tmp[0];
 				size = 0;
 			}
-			option = pnp_register_dependent_option(dev,priority);
+			option = pnp_register_dependent_option(dev, priority);
 			if (!option)
 				return 1;
 			break;
@@ -739,11 +747,13 @@ static int __init isapnp_create_device(s
 				isapnp_skip_bytes(size);
 			return 1;
 		default:
-			printk(KERN_ERR "isapnp: unexpected or unknown tag type 0x%x for logical device %i (device %i), ignored\n", type, dev->number, card->number);
+			printk(KERN_ERR
+			       "isapnp: unexpected or unknown tag type 0x%x for logical device %i (device %i), ignored\n",
+			       type, dev->number, card->number);
 		}
 	      __skip:
-	      	if (size > 0)
-		      	isapnp_skip_bytes(size);
+		if (size > 0)
+			isapnp_skip_bytes(size);
 	}
 	return 0;
 }
@@ -758,7 +768,7 @@ static void __init isapnp_parse_resource
 	unsigned short size;
 
 	while (1) {
-		if (isapnp_read_tag(&type, &size)<0)
+		if (isapnp_read_tag(&type, &size) < 0)
 			return;
 		switch (type) {
 		case _STAG_PNPVERNO:
@@ -771,7 +781,7 @@ static void __init isapnp_parse_resource
 			break;
 		case _STAG_LOGDEVID:
 			if (size >= 5 && size <= 6) {
-				if (isapnp_create_device(card, size)==1)
+				if (isapnp_create_device(card, size) == 1)
 					return;
 				size = 0;
 			}
@@ -779,7 +789,8 @@ static void __init isapnp_parse_resource
 		case _STAG_VENDOR:
 			break;
 		case _LTAG_ANSISTR:
-			isapnp_parse_name(card->name, sizeof(card->name), &size);
+			isapnp_parse_name(card->name, sizeof(card->name),
+					  &size);
 			break;
 		case _LTAG_UNICODESTR:
 			/* silently ignore */
@@ -792,11 +803,13 @@ static void __init isapnp_parse_resource
 				isapnp_skip_bytes(size);
 			return;
 		default:
-			printk(KERN_ERR "isapnp: unexpected or unknown tag type 0x%x for device %i, ignored\n", type, card->number);
+			printk(KERN_ERR
+			       "isapnp: unexpected or unknown tag type 0x%x for device %i, ignored\n",
+			       type, card->number);
 		}
 	      __skip:
-	      	if (size > 0)
-		      	isapnp_skip_bytes(size);
+		if (size > 0)
+			isapnp_skip_bytes(size);
 	}
 }
 
@@ -815,7 +828,9 @@ static unsigned char __init isapnp_check
 			bit = 0;
 			if (b & (1 << j))
 				bit = 1;
-			checksum = ((((checksum ^ (checksum >> 1)) & 0x01) ^ bit) << 7) | (checksum >> 1);
+			checksum =
+			    ((((checksum ^ (checksum >> 1)) & 0x01) ^ bit) << 7)
+			    | (checksum >> 1);
 		}
 	}
 	return checksum;
@@ -825,20 +840,19 @@ static unsigned char __init isapnp_check
  *  Parse EISA id for ISA PnP card.
  */
 
-static void isapnp_parse_card_id(struct pnp_card * card, unsigned short vendor, unsigned short device)
+static void isapnp_parse_card_id(struct pnp_card *card, unsigned short vendor,
+				 unsigned short device)
 {
-	struct pnp_id * id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	struct pnp_id *id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!id)
 		return;
 	sprintf(id->id, "%c%c%c%x%x%x%x",
-			'A' + ((vendor >> 2) & 0x3f) - 1,
-			'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
-			'A' + ((vendor >> 8) & 0x1f) - 1,
-			(device >> 4) & 0x0f,
-			device & 0x0f,
-			(device >> 12) & 0x0f,
-			(device >> 8) & 0x0f);
-	pnp_add_card_id(id,card);
+		'A' + ((vendor >> 2) & 0x3f) - 1,
+		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
+		'A' + ((vendor >> 8) & 0x1f) - 1,
+		(device >> 4) & 0x0f,
+		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
+	pnp_add_card_id(id, card);
 }
 
 /*
@@ -858,22 +872,29 @@ static int __init isapnp_build_device_li
 		isapnp_peek(header, 9);
 		checksum = isapnp_checksum(header);
 #if 0
-		printk(KERN_DEBUG "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
-			header[0], header[1], header[2], header[3],
-			header[4], header[5], header[6], header[7], header[8]);
+		printk(KERN_DEBUG
+		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+		       header[0], header[1], header[2], header[3], header[4],
+		       header[5], header[6], header[7], header[8]);
 		printk(KERN_DEBUG "checksum = 0x%x\n", checksum);
 #endif
-		if ((card = kzalloc(sizeof(struct pnp_card), GFP_KERNEL)) == NULL)
+		if ((card =
+		     kzalloc(sizeof(struct pnp_card), GFP_KERNEL)) == NULL)
 			continue;
 
 		card->number = csn;
 		INIT_LIST_HEAD(&card->devices);
-		isapnp_parse_card_id(card, (header[1] << 8) | header[0], (header[3] << 8) | header[2]);
-		card->serial = (header[7] << 24) | (header[6] << 16) | (header[5] << 8) | header[4];
+		isapnp_parse_card_id(card, (header[1] << 8) | header[0],
+				     (header[3] << 8) | header[2]);
+		card->serial =
+		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
+		    header[4];
 		isapnp_checksum_value = 0x00;
 		isapnp_parse_resource_map(card);
 		if (isapnp_checksum_value != 0x00)
-			printk(KERN_ERR "isapnp: checksum for device %i is not valid (0x%x)\n", csn, isapnp_checksum_value);
+			printk(KERN_ERR
+			       "isapnp: checksum for device %i is not valid (0x%x)\n",
+			       csn, isapnp_checksum_value);
 		card->checksum = isapnp_checksum_value;
 		card->protocol = &isapnp_protocol;
 
@@ -911,13 +932,13 @@ int isapnp_cfg_begin(int csn, int logdev
 	/* it is possible to set RDP only in the isolation phase */
 	/*   Jens Thoms Toerring <Jens.Toerring@physik.fu-berlin.de> */
 	isapnp_write_byte(0x02, 0x04);	/* clear CSN of card */
-	mdelay(2);			/* is this necessary? */
-	isapnp_wake(csn);		/* bring card into sleep state */
-	isapnp_wake(0);			/* bring card into isolation state */
-	isapnp_set_rdp();		/* reset the RDP port */
-	udelay(1000);			/* delay 1000us */
+	mdelay(2);		/* is this necessary? */
+	isapnp_wake(csn);	/* bring card into sleep state */
+	isapnp_wake(0);		/* bring card into isolation state */
+	isapnp_set_rdp();	/* reset the RDP port */
+	udelay(1000);		/* delay 1000us */
 	isapnp_write_byte(0x06, csn);	/* reset CSN to previous value */
-	udelay(250);			/* is this necessary? */
+	udelay(250);		/* is this necessary? */
 #endif
 	if (logdev >= 0)
 		isapnp_device(logdev);
@@ -931,12 +952,10 @@ int isapnp_cfg_end(void)
 	return 0;
 }
 
-
 /*
  *  Inititialization.
  */
 
-
 EXPORT_SYMBOL(isapnp_protocol);
 EXPORT_SYMBOL(isapnp_present);
 EXPORT_SYMBOL(isapnp_cfg_begin);
@@ -946,7 +965,8 @@ EXPORT_SYMBOL(isapnp_read_byte);
 #endif
 EXPORT_SYMBOL(isapnp_write_byte);
 
-static int isapnp_read_resources(struct pnp_dev *dev, struct pnp_resource_table *res)
+static int isapnp_read_resources(struct pnp_dev *dev,
+				 struct pnp_resource_table *res)
 {
 	int tmp, ret;
 
@@ -960,31 +980,37 @@ static int isapnp_read_resources(struct 
 			res->port_resource[tmp].flags = IORESOURCE_IO;
 		}
 		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
-			ret = isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
+			ret =
+			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
 			res->mem_resource[tmp].start = ret;
 			res->mem_resource[tmp].flags = IORESOURCE_MEM;
 		}
 		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
-			ret = (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >> 8);
+			ret =
+			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
+			     8);
 			if (!ret)
 				continue;
-			res->irq_resource[tmp].start = res->irq_resource[tmp].end = ret;
+			res->irq_resource[tmp].start =
+			    res->irq_resource[tmp].end = ret;
 			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
 		}
 		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res->dma_resource[tmp].start = res->dma_resource[tmp].end = ret;
+			res->dma_resource[tmp].start =
+			    res->dma_resource[tmp].end = ret;
 			res->dma_resource[tmp].flags = IORESOURCE_DMA;
 		}
 	}
 	return 0;
 }
 
-static int isapnp_get_resources(struct pnp_dev *dev, struct pnp_resource_table * res)
+static int isapnp_get_resources(struct pnp_dev *dev,
+				struct pnp_resource_table *res)
 {
 	int ret;
 	pnp_init_resource_table(res);
@@ -994,24 +1020,44 @@ static int isapnp_get_resources(struct p
 	return ret;
 }
 
-static int isapnp_set_resources(struct pnp_dev *dev, struct pnp_resource_table * res)
+static int isapnp_set_resources(struct pnp_dev *dev,
+				struct pnp_resource_table *res)
 {
 	int tmp;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
-	for (tmp = 0; tmp < PNP_MAX_PORT && (res->port_resource[tmp].flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO; tmp++)
-		isapnp_write_word(ISAPNP_CFG_PORT+(tmp<<1), res->port_resource[tmp].start);
-	for (tmp = 0; tmp < PNP_MAX_IRQ && (res->irq_resource[tmp].flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ; tmp++) {
+	for (tmp = 0;
+	     tmp < PNP_MAX_PORT
+	     && (res->port_resource[tmp].
+		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
+	     tmp++)
+		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
+				  res->port_resource[tmp].start);
+	for (tmp = 0;
+	     tmp < PNP_MAX_IRQ
+	     && (res->irq_resource[tmp].
+		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
+	     tmp++) {
 		int irq = res->irq_resource[tmp].start;
 		if (irq == 2)
 			irq = 9;
-		isapnp_write_byte(ISAPNP_CFG_IRQ+(tmp<<1), irq);
+		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 	}
-	for (tmp = 0; tmp < PNP_MAX_DMA && (res->dma_resource[tmp].flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA; tmp++)
-		isapnp_write_byte(ISAPNP_CFG_DMA+tmp, res->dma_resource[tmp].start);
-	for (tmp = 0; tmp < PNP_MAX_MEM && (res->mem_resource[tmp].flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM; tmp++)
-		isapnp_write_word(ISAPNP_CFG_MEM+(tmp<<3), (res->mem_resource[tmp].start >> 8) & 0xffff);
+	for (tmp = 0;
+	     tmp < PNP_MAX_DMA
+	     && (res->dma_resource[tmp].
+		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
+	     tmp++)
+		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
+				  res->dma_resource[tmp].start);
+	for (tmp = 0;
+	     tmp < PNP_MAX_MEM
+	     && (res->mem_resource[tmp].
+		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
+	     tmp++)
+		isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
+				  (res->mem_resource[tmp].start >> 8) & 0xffff);
 	/* FIXME: We aren't handling 32bit mems properly here */
 	isapnp_activate(dev->number);
 	isapnp_cfg_end();
@@ -1030,9 +1076,9 @@ static int isapnp_disable_resources(stru
 }
 
 struct pnp_protocol isapnp_protocol = {
-	.name	= "ISA Plug and Play",
-	.get	= isapnp_get_resources,
-	.set	= isapnp_set_resources,
+	.name = "ISA Plug and Play",
+	.get = isapnp_get_resources,
+	.set = isapnp_set_resources,
 	.disable = isapnp_disable_resources,
 };
 
@@ -1053,31 +1099,36 @@ static int __init isapnp_init(void)
 #endif
 #ifdef ISAPNP_REGION_OK
 	if (!request_region(_PIDXR, 1, "isapnp index")) {
-		printk(KERN_ERR "isapnp: Index Register 0x%x already used\n", _PIDXR);
+		printk(KERN_ERR "isapnp: Index Register 0x%x already used\n",
+		       _PIDXR);
 		return -EBUSY;
 	}
 #endif
 	if (!request_region(_PNPWRP, 1, "isapnp write")) {
-		printk(KERN_ERR "isapnp: Write Data Register 0x%x already used\n", _PNPWRP);
+		printk(KERN_ERR
+		       "isapnp: Write Data Register 0x%x already used\n",
+		       _PNPWRP);
 #ifdef ISAPNP_REGION_OK
 		release_region(_PIDXR, 1);
 #endif
 		return -EBUSY;
 	}
 
-	if(pnp_register_protocol(&isapnp_protocol)<0)
+	if (pnp_register_protocol(&isapnp_protocol) < 0)
 		return -EBUSY;
 
 	/*
-	 *	Print a message. The existing ISAPnP code is hanging machines
-	 *	so let the user know where.
+	 *      Print a message. The existing ISAPnP code is hanging machines
+	 *      so let the user know where.
 	 */
-	 
+
 	printk(KERN_INFO "isapnp: Scanning for PnP cards...\n");
 	if (isapnp_rdp >= 0x203 && isapnp_rdp <= 0x3ff) {
 		isapnp_rdp |= 3;
 		if (!request_region(isapnp_rdp, 1, "isapnp read")) {
-			printk(KERN_ERR "isapnp: Read Data Register 0x%x already used\n", isapnp_rdp);
+			printk(KERN_ERR
+			       "isapnp: Read Data Register 0x%x already used\n",
+			       isapnp_rdp);
 #ifdef ISAPNP_REGION_OK
 			release_region(_PIDXR, 1);
 #endif
@@ -1089,14 +1140,14 @@ static int __init isapnp_init(void)
 	isapnp_detected = 1;
 	if (isapnp_rdp < 0x203 || isapnp_rdp > 0x3ff) {
 		cards = isapnp_isolate();
-		if (cards < 0 || 
-		    (isapnp_rdp < 0x203 || isapnp_rdp > 0x3ff)) {
+		if (cards < 0 || (isapnp_rdp < 0x203 || isapnp_rdp > 0x3ff)) {
 #ifdef ISAPNP_REGION_OK
 			release_region(_PIDXR, 1);
 #endif
 			release_region(_PNPWRP, 1);
 			isapnp_detected = 0;
-			printk(KERN_INFO "isapnp: No Plug & Play device found\n");
+			printk(KERN_INFO
+			       "isapnp: No Plug & Play device found\n");
 			return 0;
 		}
 		request_region(isapnp_rdp, 1, "isapnp read");
@@ -1104,19 +1155,23 @@ static int __init isapnp_init(void)
 	isapnp_build_device_list();
 	cards = 0;
 
-	protocol_for_each_card(&isapnp_protocol,card) {
+	protocol_for_each_card(&isapnp_protocol, card) {
 		cards++;
 		if (isapnp_verbose) {
-			printk(KERN_INFO "isapnp: Card '%s'\n", card->name[0]?card->name:"Unknown");
+			printk(KERN_INFO "isapnp: Card '%s'\n",
+			       card->name[0] ? card->name : "Unknown");
 			if (isapnp_verbose < 2)
 				continue;
-			card_for_each_dev(card,dev) {
-				printk(KERN_INFO "isapnp:   Device '%s'\n", dev->name[0]?dev->name:"Unknown");
+			card_for_each_dev(card, dev) {
+				printk(KERN_INFO "isapnp:   Device '%s'\n",
+				       dev->name[0] ? dev->name : "Unknown");
 			}
 		}
 	}
 	if (cards) {
-		printk(KERN_INFO "isapnp: %i Plug & Play card%s detected total\n", cards, cards>1?"s":"");
+		printk(KERN_INFO
+		       "isapnp: %i Plug & Play card%s detected total\n", cards,
+		       cards > 1 ? "s" : "");
 	} else {
 		printk(KERN_INFO "isapnp: No Plug & Play card found\n");
 	}
@@ -1141,11 +1196,10 @@ __setup("noisapnp", isapnp_setup_disable
 
 static int __init isapnp_setup_isapnp(char *str)
 {
-	(void)((get_option(&str,&isapnp_rdp) == 2) &&
-	       (get_option(&str,&isapnp_reset) == 2) &&
-	       (get_option(&str,&isapnp_verbose) == 2));
+	(void)((get_option(&str, &isapnp_rdp) == 2) &&
+	       (get_option(&str, &isapnp_reset) == 2) &&
+	       (get_option(&str, &isapnp_verbose) == 2));
 	return 1;
 }
 
 __setup("isapnp=", isapnp_setup_isapnp);
-
diff -puN drivers/pnp/isapnp/proc.c~pnp-lindent-all-source-files drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/isapnp/proc.c
@@ -54,7 +54,8 @@ static loff_t isapnp_proc_bus_lseek(stru
 	return (file->f_pos = new);
 }
 
-static ssize_t isapnp_proc_bus_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
+				    size_t nbytes, loff_t * ppos)
 {
 	struct inode *ino = file->f_path.dentry->d_inode;
 	struct proc_dir_entry *dp = PDE(ino);
@@ -74,7 +75,7 @@ static ssize_t isapnp_proc_bus_read(stru
 		return -EINVAL;
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
-	for ( ; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
+	for (; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
 		unsigned char val;
 		val = isapnp_read_byte(pos);
 		__put_user(val, buf);
@@ -85,10 +86,9 @@ static ssize_t isapnp_proc_bus_read(stru
 	return nbytes;
 }
 
-static const struct file_operations isapnp_proc_bus_file_operations =
-{
-	.llseek		= isapnp_proc_bus_lseek,
-	.read		= isapnp_proc_bus_read,
+static const struct file_operations isapnp_proc_bus_file_operations = {
+	.llseek = isapnp_proc_bus_lseek,
+	.read = isapnp_proc_bus_read,
 };
 
 static int isapnp_proc_attach_device(struct pnp_dev *dev)
@@ -145,7 +145,7 @@ int __init isapnp_proc_init(void)
 {
 	struct pnp_dev *dev;
 	isapnp_proc_bus_dir = proc_mkdir("isapnp", proc_bus);
-	protocol_for_each_dev(&isapnp_protocol,dev) {
+	protocol_for_each_dev(&isapnp_protocol, dev) {
 		isapnp_proc_attach_device(dev);
 	}
 	return 0;
diff -puN drivers/pnp/manager.c~pnp-lindent-all-source-files drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/manager.c
@@ -26,7 +26,8 @@ static int pnp_assign_port(struct pnp_de
 		return -EINVAL;
 
 	if (idx >= PNP_MAX_PORT) {
-		pnp_err("More than 4 ports is incompatible with pnp specifications.");
+		pnp_err
+		    ("More than 4 ports is incompatible with pnp specifications.");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -41,11 +42,11 @@ static int pnp_assign_port(struct pnp_de
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
-	*flags &=  ~IORESOURCE_UNSET;
+	*flags &= ~IORESOURCE_UNSET;
 
 	if (!rule->size) {
 		*flags |= IORESOURCE_DISABLED;
-		return 1; /* skip disabled resource requests */
+		return 1;	/* skip disabled resource requests */
 	}
 
 	*start = rule->min;
@@ -70,7 +71,8 @@ static int pnp_assign_mem(struct pnp_dev
 		return -EINVAL;
 
 	if (idx >= PNP_MAX_MEM) {
-		pnp_err("More than 8 mems is incompatible with pnp specifications.");
+		pnp_err
+		    ("More than 8 mems is incompatible with pnp specifications.");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -85,7 +87,7 @@ static int pnp_assign_mem(struct pnp_dev
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_MEM;
-	*flags &=  ~IORESOURCE_UNSET;
+	*flags &= ~IORESOURCE_UNSET;
 
 	/* convert pnp flags to standard Linux flags */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
@@ -99,11 +101,11 @@ static int pnp_assign_mem(struct pnp_dev
 
 	if (!rule->size) {
 		*flags |= IORESOURCE_DISABLED;
-		return 1; /* skip disabled resource requests */
+		return 1;	/* skip disabled resource requests */
 	}
 
 	*start = rule->min;
-	*end = *start + rule->size -1;
+	*end = *start + rule->size - 1;
 
 	/* run through until pnp_check_mem is happy */
 	while (!pnp_check_mem(dev, idx)) {
@@ -115,7 +117,7 @@ static int pnp_assign_mem(struct pnp_dev
 	return 1;
 }
 
-static int pnp_assign_irq(struct pnp_dev * dev, struct pnp_irq *rule, int idx)
+static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
@@ -130,7 +132,8 @@ static int pnp_assign_irq(struct pnp_dev
 		return -EINVAL;
 
 	if (idx >= PNP_MAX_IRQ) {
-		pnp_err("More than 2 irqs is incompatible with pnp specifications.");
+		pnp_err
+		    ("More than 2 irqs is incompatible with pnp specifications.");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -145,11 +148,11 @@ static int pnp_assign_irq(struct pnp_dev
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IRQ;
-	*flags &=  ~IORESOURCE_UNSET;
+	*flags &= ~IORESOURCE_UNSET;
 
 	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
 		*flags |= IORESOURCE_DISABLED;
-		return 1; /* skip disabled resource requests */
+		return 1;	/* skip disabled resource requests */
 	}
 
 	/* TBD: need check for >16 IRQ */
@@ -159,9 +162,9 @@ static int pnp_assign_irq(struct pnp_dev
 		return 1;
 	}
 	for (i = 0; i < 16; i++) {
-		if(test_bit(xtab[i], rule->map)) {
+		if (test_bit(xtab[i], rule->map)) {
 			*start = *end = xtab[i];
-			if(pnp_check_irq(dev, idx))
+			if (pnp_check_irq(dev, idx))
 				return 1;
 		}
 	}
@@ -183,7 +186,8 @@ static int pnp_assign_dma(struct pnp_dev
 		return -EINVAL;
 
 	if (idx >= PNP_MAX_DMA) {
-		pnp_err("More than 2 dmas is incompatible with pnp specifications.");
+		pnp_err
+		    ("More than 2 dmas is incompatible with pnp specifications.");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
@@ -198,17 +202,17 @@ static int pnp_assign_dma(struct pnp_dev
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_DMA;
-	*flags &=  ~IORESOURCE_UNSET;
+	*flags &= ~IORESOURCE_UNSET;
 
 	if (!rule->map) {
 		*flags |= IORESOURCE_DISABLED;
-		return 1; /* skip disabled resource requests */
+		return 1;	/* skip disabled resource requests */
 	}
 
 	for (i = 0; i < 8; i++) {
-		if(rule->map & (1<<xtab[i])) {
+		if (rule->map & (1 << xtab[i])) {
 			*start = *end = xtab[i];
-			if(pnp_check_dma(dev, idx))
+			if (pnp_check_dma(dev, idx))
 				return 1;
 		}
 	}
@@ -227,25 +231,29 @@ void pnp_init_resource_table(struct pnp_
 		table->irq_resource[idx].name = NULL;
 		table->irq_resource[idx].start = -1;
 		table->irq_resource[idx].end = -1;
-		table->irq_resource[idx].flags = IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		table->irq_resource[idx].flags =
+		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
 		table->dma_resource[idx].name = NULL;
 		table->dma_resource[idx].start = -1;
 		table->dma_resource[idx].end = -1;
-		table->dma_resource[idx].flags = IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		table->dma_resource[idx].flags =
+		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
 		table->port_resource[idx].name = NULL;
 		table->port_resource[idx].start = 0;
 		table->port_resource[idx].end = 0;
-		table->port_resource[idx].flags = IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		table->port_resource[idx].flags =
+		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
 		table->mem_resource[idx].name = NULL;
 		table->mem_resource[idx].start = 0;
 		table->mem_resource[idx].end = 0;
-		table->mem_resource[idx].flags = IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		table->mem_resource[idx].flags =
+		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 }
 
@@ -254,7 +262,7 @@ void pnp_init_resource_table(struct pnp_
  * @res: the resources to clean
  *
  */
-static void pnp_clean_resource_table(struct pnp_resource_table * res)
+static void pnp_clean_resource_table(struct pnp_resource_table *res)
 {
 	int idx;
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
@@ -262,28 +270,32 @@ static void pnp_clean_resource_table(str
 			continue;
 		res->irq_resource[idx].start = -1;
 		res->irq_resource[idx].end = -1;
-		res->irq_resource[idx].flags = IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res->irq_resource[idx].flags =
+		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
 		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
 		res->dma_resource[idx].start = -1;
 		res->dma_resource[idx].end = -1;
-		res->dma_resource[idx].flags = IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res->dma_resource[idx].flags =
+		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
 		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
 		res->port_resource[idx].start = 0;
 		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags = IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res->port_resource[idx].flags =
+		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
 		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
 		res->mem_resource[idx].start = 0;
 		res->mem_resource[idx].end = 0;
-		res->mem_resource[idx].flags = IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+		res->mem_resource[idx].flags =
+		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 }
 
@@ -306,7 +318,7 @@ static int pnp_assign_resources(struct p
 		return -ENODEV;
 
 	down(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res); /* start with a fresh slate */
+	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
 		mem = dev->independent->mem;
@@ -341,10 +353,11 @@ static int pnp_assign_resources(struct p
 	if (depnum) {
 		struct pnp_option *dep;
 		int i;
-		for (i=1,dep=dev->dependent; i<depnum; i++, dep=dep->next)
-			if(!dep)
+		for (i = 1, dep = dev->dependent; i < depnum;
+		     i++, dep = dep->next)
+			if (!dep)
 				goto fail;
-		port =dep->port;
+		port = dep->port;
 		mem = dep->mem;
 		irq = dep->irq;
 		dma = dep->dma;
@@ -378,7 +391,7 @@ static int pnp_assign_resources(struct p
 	up(&pnp_res_mutex);
 	return 1;
 
-fail:
+      fail:
 	pnp_clean_resource_table(&dev->res);
 	up(&pnp_res_mutex);
 	return 0;
@@ -392,10 +405,11 @@ fail:
  *
  * This function can be used by drivers that want to manually set thier resources.
  */
-int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table * res, int mode)
+int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
+			  int mode)
 {
 	int i;
-	struct pnp_resource_table * bak;
+	struct pnp_resource_table *bak;
 	if (!dev || !res)
 		return -EINVAL;
 	if (!pnp_can_configure(dev))
@@ -409,19 +423,19 @@ int pnp_manual_config_dev(struct pnp_dev
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
 		for (i = 0; i < PNP_MAX_PORT; i++) {
-			if(!pnp_check_port(dev,i))
+			if (!pnp_check_port(dev, i))
 				goto fail;
 		}
 		for (i = 0; i < PNP_MAX_MEM; i++) {
-			if(!pnp_check_mem(dev,i))
+			if (!pnp_check_mem(dev, i))
 				goto fail;
 		}
 		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			if(!pnp_check_irq(dev,i))
+			if (!pnp_check_irq(dev, i))
 				goto fail;
 		}
 		for (i = 0; i < PNP_MAX_DMA; i++) {
-			if(!pnp_check_dma(dev,i))
+			if (!pnp_check_dma(dev, i))
 				goto fail;
 		}
 	}
@@ -430,7 +444,7 @@ int pnp_manual_config_dev(struct pnp_dev
 	kfree(bak);
 	return 0;
 
-fail:
+      fail:
 	dev->res = *bak;
 	up(&pnp_res_mutex);
 	kfree(bak);
@@ -447,11 +461,12 @@ int pnp_auto_config_dev(struct pnp_dev *
 	struct pnp_option *dep;
 	int i = 1;
 
-	if(!dev)
+	if (!dev)
 		return -EINVAL;
 
-	if(!pnp_can_configure(dev)) {
-		pnp_dbg("Device %s does not support resource configuration.", dev->dev.bus_id);
+	if (!pnp_can_configure(dev)) {
+		pnp_dbg("Device %s does not support resource configuration.",
+			dev->dev.bus_id);
 		return -ENODEV;
 	}
 
@@ -482,11 +497,12 @@ int pnp_auto_config_dev(struct pnp_dev *
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
-		pnp_dbg("Device %s does not support activation.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support activation.",
+			dev->dev.bus_id);
 		return -EINVAL;
 	}
 
-	if (dev->protocol->set(dev, &dev->res)<0) {
+	if (dev->protocol->set(dev, &dev->res) < 0) {
 		pnp_err("Failed to activate device %s.", dev->dev.bus_id);
 		return -EIO;
 	}
@@ -506,10 +522,11 @@ int pnp_start_dev(struct pnp_dev *dev)
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
-		pnp_dbg("Device %s does not support disabling.", dev->dev.bus_id);
+		pnp_dbg("Device %s does not support disabling.",
+			dev->dev.bus_id);
 		return -EINVAL;
 	}
-	if (dev->protocol->disable(dev)<0) {
+	if (dev->protocol->disable(dev) < 0) {
 		pnp_err("Failed to disable device %s.", dev->dev.bus_id);
 		return -EIO;
 	}
@@ -532,7 +549,7 @@ int pnp_activate_dev(struct pnp_dev *dev
 	if (!dev)
 		return -EINVAL;
 	if (dev->active) {
-		return 0; /* the device is already active */
+		return 0;	/* the device is already active */
 	}
 
 	/* ensure resources are allocated */
@@ -558,10 +575,10 @@ int pnp_disable_dev(struct pnp_dev *dev)
 {
 	int error;
 
-        if (!dev)
-                return -EINVAL;
+	if (!dev)
+		return -EINVAL;
 	if (!dev->active) {
-		return 0; /* the device is already disabled */
+		return 0;	/* the device is already disabled */
 	}
 
 	error = pnp_stop_dev(dev);
@@ -586,7 +603,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
  *
  */
 void pnp_resource_change(struct resource *resource, resource_size_t start,
-				resource_size_t size)
+			 resource_size_t size)
 {
 	if (resource == NULL)
 		return;
@@ -595,7 +612,6 @@ void pnp_resource_change(struct resource
 	resource->end = start + size - 1;
 }
 
-
 EXPORT_SYMBOL(pnp_manual_config_dev);
 #if 0
 EXPORT_SYMBOL(pnp_auto_config_dev);
diff -puN drivers/pnp/pnpacpi/core.c~pnp-lindent-all-source-files drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpacpi/core.c
@@ -36,11 +36,11 @@ static int num = 0;
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
  * Finaly only devices that have a CRS method need to be in this list.
  */
-static __initdata struct acpi_device_id excluded_id_list[] ={
-	{"PNP0C09", 0}, /* EC */
-	{"PNP0C0F", 0}, /* Link device */
-	{"PNP0000", 0}, /* PIC */
-	{"PNP0100", 0}, /* Timer */
+static __initdata struct acpi_device_id excluded_id_list[] = {
+	{"PNP0C09", 0},		/* EC */
+	{"PNP0C0F", 0},		/* Link device */
+	{"PNP0000", 0},		/* PIC */
+	{"PNP0100", 0},		/* Timer */
 	{"", 0},
 };
 
@@ -84,15 +84,17 @@ static void __init pnpidacpi_to_pnpid(ch
 	str[7] = '\0';
 }
 
-static int pnpacpi_get_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
+static int pnpacpi_get_resources(struct pnp_dev *dev,
+				 struct pnp_resource_table *res)
 {
 	acpi_status status;
-	status = pnpacpi_parse_allocated_resource((acpi_handle)dev->data,
-		&dev->res);
+	status = pnpacpi_parse_allocated_resource((acpi_handle) dev->data,
+						  &dev->res);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
-static int pnpacpi_set_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
+static int pnpacpi_set_resources(struct pnp_dev *dev,
+				 struct pnp_resource_table *res)
 {
 	acpi_handle handle = dev->data;
 	struct acpi_buffer buffer;
@@ -119,27 +121,29 @@ static int pnpacpi_disable_resources(str
 	acpi_status status;
 
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle)dev->data,
-		"_DIS", NULL, NULL);
+	status = acpi_evaluate_object((acpi_handle) dev->data,
+				      "_DIS", NULL, NULL);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
 
 static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 {
-	return acpi_bus_set_power((acpi_handle)dev->data,
-		acpi_pm_device_sleep_state(&dev->dev,
-		device_may_wakeup(&dev->dev), NULL));
+	return acpi_bus_set_power((acpi_handle) dev->data,
+				  acpi_pm_device_sleep_state(&dev->dev,
+							     device_may_wakeup
+							     (&dev->dev),
+							     NULL));
 }
 
 static int pnpacpi_resume(struct pnp_dev *dev)
 {
-	return acpi_bus_set_power((acpi_handle)dev->data, ACPI_STATE_D0);
+	return acpi_bus_set_power((acpi_handle) dev->data, ACPI_STATE_D0);
 }
 
 static struct pnp_protocol pnpacpi_protocol = {
-	.name	= "Plug and Play ACPI",
-	.get	= pnpacpi_get_resources,
-	.set	= pnpacpi_set_resources,
+	.name = "Plug and Play ACPI",
+	.get = pnpacpi_get_resources,
+	.set = pnpacpi_set_resources,
 	.disable = pnpacpi_disable_resources,
 	.suspend = pnpacpi_suspend,
 	.resume = pnpacpi_resume,
@@ -154,11 +158,11 @@ static int __init pnpacpi_add_device(str
 
 	status = acpi_get_handle(device->handle, "_CRS", &temp);
 	if (ACPI_FAILURE(status) || !ispnpidacpi(acpi_device_hid(device)) ||
-		is_exclusive_device(device))
+	    is_exclusive_device(device))
 		return 0;
 
 	pnp_dbg("ACPI device : hid %s", acpi_device_hid(device));
-	dev =  kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 	if (!dev) {
 		pnp_err("Out of memory");
 		return -ENOMEM;
@@ -194,20 +198,23 @@ static int __init pnpacpi_add_device(str
 	pnpidacpi_to_pnpid(acpi_device_hid(device), dev_id->id);
 	pnp_add_id(dev_id, dev);
 
-	if(dev->active) {
+	if (dev->active) {
 		/* parse allocated resource */
-		status = pnpacpi_parse_allocated_resource(device->handle, &dev->res);
+		status =
+		    pnpacpi_parse_allocated_resource(device->handle, &dev->res);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
-			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s", dev_id->id);
+			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s",
+				dev_id->id);
 			goto err1;
 		}
 	}
 
-	if(dev->capabilities & PNP_CONFIGURABLE) {
+	if (dev->capabilities & PNP_CONFIGURABLE) {
 		status = pnpacpi_parse_resource_option_data(device->handle,
-			dev);
+							    dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
-			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s", dev_id->id);
+			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s",
+				dev_id->id);
 			goto err1;
 		}
 	}
@@ -233,18 +240,19 @@ static int __init pnpacpi_add_device(str
 	if (!dev->active)
 		pnp_init_resource_table(&dev->res);
 	pnp_add_device(dev);
-	num ++;
+	num++;
 
 	return AE_OK;
-err1:
+      err1:
 	kfree(dev_id);
-err:
+      err:
 	kfree(dev);
 	return -EINVAL;
 }
 
 static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
-	u32 lvl, void *context, void **rv)
+						     u32 lvl, void *context,
+						     void **rv)
 {
 	struct acpi_device *device;
 
@@ -257,23 +265,22 @@ static acpi_status __init pnpacpi_add_de
 
 static int __init acpi_pnp_match(struct device *dev, void *_pnp)
 {
-	struct acpi_device	*acpi = to_acpi_device(dev);
-	struct pnp_dev		*pnp = _pnp;
+	struct acpi_device *acpi = to_acpi_device(dev);
+	struct pnp_dev *pnp = _pnp;
 
 	/* true means it matched */
 	return acpi->flags.hardware_id
-		&& !acpi_get_physical_device(acpi->handle)
-		&& compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
+	    && !acpi_get_physical_device(acpi->handle)
+	    && compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
 }
 
-static int __init acpi_pnp_find_device(struct device *dev, acpi_handle *handle)
+static int __init acpi_pnp_find_device(struct device *dev, acpi_handle * handle)
 {
-	struct device		*adev;
-	struct acpi_device	*acpi;
+	struct device *adev;
+	struct acpi_device *acpi;
 
 	adev = bus_find_device(&acpi_bus_type, NULL,
-			to_pnp_dev(dev),
-			acpi_pnp_match);
+			       to_pnp_dev(dev), acpi_pnp_match);
 	if (!adev)
 		return -ENODEV;
 
@@ -307,6 +314,7 @@ static int __init pnpacpi_init(void)
 	pnp_platform_devices = 1;
 	return 0;
 }
+
 subsys_initcall(pnpacpi_init);
 
 static int __init pnpacpi_setup(char *str)
@@ -317,6 +325,7 @@ static int __init pnpacpi_setup(char *st
 		pnpacpi_disabled = 1;
 	return 1;
 }
+
 __setup("pnpacpi=", pnpacpi_setup);
 
 #if 0
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-lindent-all-source-files drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -40,8 +40,7 @@ static int irq_flags(int triggering, int
 			flag = IORESOURCE_IRQ_LOWLEVEL;
 		else
 			flag = IORESOURCE_IRQ_HIGHLEVEL;
-	}
-	else {
+	} else {
 		if (polarity == ACPI_ACTIVE_LOW)
 			flag = IORESOURCE_IRQ_LOWEDGE;
 		else
@@ -74,7 +73,7 @@ static void decode_irq_flags(int flag, i
 
 static void
 pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res, u32 gsi,
-	int triggering, int polarity, int shareable)
+				    int triggering, int polarity, int shareable)
 {
 	int i = 0;
 	int irq;
@@ -83,12 +82,12 @@ pnpacpi_parse_allocated_irqresource(stru
 		return;
 
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
-			i < PNP_MAX_IRQ)
+	       i < PNP_MAX_IRQ)
 		i++;
 	if (i >= PNP_MAX_IRQ)
 		return;
 
-	res->irq_resource[i].flags = IORESOURCE_IRQ;  // Also clears _UNSET flag
+	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
 	if (irq < 0) {
@@ -149,15 +148,16 @@ static int dma_flags(int type, int bus_m
 
 static void
 pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res, u32 dma,
-	int type, int bus_master, int transfer)
+				    int type, int bus_master, int transfer)
 {
 	int i = 0;
 	while (i < PNP_MAX_DMA &&
-			!(res->dma_resource[i].flags & IORESOURCE_UNSET))
+	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
 		i++;
 	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;  // Also clears _UNSET flag
-		res->dma_resource[i].flags |= dma_flags(type, bus_master, transfer);
+		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
+		res->dma_resource[i].flags |=
+		    dma_flags(type, bus_master, transfer);
 		if (dma == -1) {
 			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
@@ -169,17 +169,17 @@ pnpacpi_parse_allocated_dmaresource(stru
 
 static void
 pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
-	u64 io, u64 len, int io_decode)
+				   u64 io, u64 len, int io_decode)
 {
 	int i = 0;
 	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-			i < PNP_MAX_PORT)
+	       i < PNP_MAX_PORT)
 		i++;
 	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;  // Also clears _UNSET flag
+		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
 		if (io_decode == ACPI_DECODE_16)
 			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
-		if (len <= 0 || (io + len -1) >= 0x10003) {
+		if (len <= 0 || (io + len - 1) >= 0x10003) {
 			res->port_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
@@ -190,19 +190,19 @@ pnpacpi_parse_allocated_ioresource(struc
 
 static void
 pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
-	u64 mem, u64 len, int write_protect)
+				    u64 mem, u64 len, int write_protect)
 {
 	int i = 0;
 	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
-			(i < PNP_MAX_MEM))
+	       (i < PNP_MAX_MEM))
 		i++;
 	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;  // Also clears _UNSET flag
+		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
 		if (len <= 0) {
 			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		if(write_protect == ACPI_READ_WRITE_MEMORY)
+		if (write_protect == ACPI_READ_WRITE_MEMORY)
 			res->mem_resource[i].flags |= IORESOURCE_MEM_WRITEABLE;
 
 		res->mem_resource[i].start = mem;
@@ -212,7 +212,7 @@ pnpacpi_parse_allocated_memresource(stru
 
 static void
 pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
-	struct acpi_resource *res)
+				      struct acpi_resource *res)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
@@ -220,7 +220,7 @@ pnpacpi_parse_allocated_address_space(st
 	status = acpi_resource_to_address64(res, p);
 	if (!ACPI_SUCCESS(status)) {
 		pnp_warn("PnPACPI: failed to convert resource type %d",
-			res->type);
+			 res->type);
 		return;
 	}
 
@@ -229,17 +229,23 @@ pnpacpi_parse_allocated_address_space(st
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
 		pnpacpi_parse_allocated_memresource(res_table,
-				p->minimum, p->address_length, p->info.mem.write_protect);
+						    p->minimum,
+						    p->address_length,
+						    p->info.mem.write_protect);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnpacpi_parse_allocated_ioresource(res_table,
-				p->minimum, p->address_length,
-				p->granularity == 0xfff ? ACPI_DECODE_10 : ACPI_DECODE_16);
+						   p->minimum,
+						   p->address_length,
+						   p->granularity ==
+						   0xfff ? ACPI_DECODE_10 :
+						   ACPI_DECODE_16);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
-	void *data)
+					      void *data)
 {
-	struct pnp_resource_table *res_table = (struct pnp_resource_table *)data;
+	struct pnp_resource_table *res_table =
+	    (struct pnp_resource_table *)data;
 	int i;
 
 	switch (res->type) {
@@ -250,27 +256,34 @@ static acpi_status pnpacpi_allocated_res
 		 */
 		for (i = 0; i < res->data.irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.irq.interrupts[i],
-				res->data.irq.triggering,
-				res->data.irq.polarity,
-				res->data.irq.sharable);
+							    res->data.irq.
+							    interrupts[i],
+							    res->data.irq.
+							    triggering,
+							    res->data.irq.
+							    polarity,
+							    res->data.irq.
+							    sharable);
 		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		if (res->data.dma.channel_count > 0)
 			pnpacpi_parse_allocated_dmaresource(res_table,
-					res->data.dma.channels[0],
-					res->data.dma.type,
-					res->data.dma.bus_master,
-					res->data.dma.transfer);
+							    res->data.dma.
+							    channels[0],
+							    res->data.dma.type,
+							    res->data.dma.
+							    bus_master,
+							    res->data.dma.
+							    transfer);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
 		pnpacpi_parse_allocated_ioresource(res_table,
-				res->data.io.minimum,
-				res->data.io.address_length,
-				res->data.io.io_decode);
+						   res->data.io.minimum,
+						   res->data.io.address_length,
+						   res->data.io.io_decode);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -279,9 +292,10 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		pnpacpi_parse_allocated_ioresource(res_table,
-				res->data.fixed_io.address,
-				res->data.fixed_io.address_length,
-				ACPI_DECODE_10);
+						   res->data.fixed_io.address,
+						   res->data.fixed_io.
+						   address_length,
+						   ACPI_DECODE_10);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
@@ -292,21 +306,28 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		pnpacpi_parse_allocated_memresource(res_table,
-				res->data.memory24.minimum,
-				res->data.memory24.address_length,
-				res->data.memory24.write_protect);
+						    res->data.memory24.minimum,
+						    res->data.memory24.
+						    address_length,
+						    res->data.memory24.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-				res->data.memory32.minimum,
-				res->data.memory32.address_length,
-				res->data.memory32.write_protect);
+						    res->data.memory32.minimum,
+						    res->data.memory32.
+						    address_length,
+						    res->data.memory32.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-				res->data.fixed_memory32.address,
-				res->data.fixed_memory32.address_length,
-				res->data.fixed_memory32.write_protect);
+						    res->data.fixed_memory32.
+						    address,
+						    res->data.fixed_memory32.
+						    address_length,
+						    res->data.fixed_memory32.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
@@ -325,10 +346,18 @@ static acpi_status pnpacpi_allocated_res
 
 		for (i = 0; i < res->data.extended_irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.extended_irq.interrupts[i],
-				res->data.extended_irq.triggering,
-				res->data.extended_irq.polarity,
-				res->data.extended_irq.sharable);
+							    res->data.
+							    extended_irq.
+							    interrupts[i],
+							    res->data.
+							    extended_irq.
+							    triggering,
+							    res->data.
+							    extended_irq.
+							    polarity,
+							    res->data.
+							    extended_irq.
+							    sharable);
 		}
 		break;
 
@@ -343,18 +372,21 @@ static acpi_status pnpacpi_allocated_res
 	return AE_OK;
 }
 
-acpi_status pnpacpi_parse_allocated_resource(acpi_handle handle, struct pnp_resource_table *res)
+acpi_status pnpacpi_parse_allocated_resource(acpi_handle handle,
+					     struct pnp_resource_table * res)
 {
 	/* Blank the resource table values */
 	pnp_init_resource_table(res);
 
-	return acpi_walk_resources(handle, METHOD_NAME__CRS, pnpacpi_allocated_resource, res);
+	return acpi_walk_resources(handle, METHOD_NAME__CRS,
+				   pnpacpi_allocated_resource, res);
 }
 
-static void pnpacpi_parse_dma_option(struct pnp_option *option, struct acpi_resource_dma *p)
+static void pnpacpi_parse_dma_option(struct pnp_option *option,
+				     struct acpi_resource_dma *p)
 {
 	int i;
-	struct pnp_dma * dma;
+	struct pnp_dma *dma;
 
 	if (p->channel_count == 0)
 		return;
@@ -362,7 +394,7 @@ static void pnpacpi_parse_dma_option(str
 	if (!dma)
 		return;
 
-	for(i = 0; i < p->channel_count; i++)
+	for (i = 0; i < p->channel_count; i++)
 		dma->map |= 1 << p->channels[i];
 
 	dma->flags = dma_flags(p->type, p->bus_master, p->transfer);
@@ -371,9 +403,8 @@ static void pnpacpi_parse_dma_option(str
 	return;
 }
 
-
 static void pnpacpi_parse_irq_option(struct pnp_option *option,
-	struct acpi_resource_irq *p)
+				     struct acpi_resource_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -384,7 +415,7 @@ static void pnpacpi_parse_irq_option(str
 	if (!irq)
 		return;
 
-	for(i = 0; i < p->interrupt_count; i++)
+	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
 	irq->flags = irq_flags(p->triggering, p->polarity);
@@ -394,7 +425,7 @@ static void pnpacpi_parse_irq_option(str
 }
 
 static void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
-	struct acpi_resource_extended_irq *p)
+					 struct acpi_resource_extended_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -405,7 +436,7 @@ static void pnpacpi_parse_ext_irq_option
 	if (!irq)
 		return;
 
-	for(i = 0; i < p->interrupt_count; i++)
+	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], irq->map);
 	irq->flags = irq_flags(p->triggering, p->polarity);
@@ -416,7 +447,7 @@ static void pnpacpi_parse_ext_irq_option
 
 static void
 pnpacpi_parse_port_option(struct pnp_option *option,
-	struct acpi_resource_io *io)
+			  struct acpi_resource_io *io)
 {
 	struct pnp_port *port;
 
@@ -430,14 +461,14 @@ pnpacpi_parse_port_option(struct pnp_opt
 	port->align = io->alignment;
 	port->size = io->address_length;
 	port->flags = ACPI_DECODE_16 == io->io_decode ?
-		PNP_PORT_FLAG_16BITADDR : 0;
+	    PNP_PORT_FLAG_16BITADDR : 0;
 	pnp_register_port_resource(option, port);
 	return;
 }
 
 static void
 pnpacpi_parse_fixed_port_option(struct pnp_option *option,
-	struct acpi_resource_fixed_io *io)
+				struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
 
@@ -456,7 +487,7 @@ pnpacpi_parse_fixed_port_option(struct p
 
 static void
 pnpacpi_parse_mem24_option(struct pnp_option *option,
-	struct acpi_resource_memory24 *p)
+			   struct acpi_resource_memory24 *p)
 {
 	struct pnp_mem *mem;
 
@@ -471,7 +502,7 @@ pnpacpi_parse_mem24_option(struct pnp_op
 	mem->size = p->address_length;
 
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-			IORESOURCE_MEM_WRITEABLE : 0;
+	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
 	return;
@@ -479,7 +510,7 @@ pnpacpi_parse_mem24_option(struct pnp_op
 
 static void
 pnpacpi_parse_mem32_option(struct pnp_option *option,
-	struct acpi_resource_memory32 *p)
+			   struct acpi_resource_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -494,7 +525,7 @@ pnpacpi_parse_mem32_option(struct pnp_op
 	mem->size = p->address_length;
 
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-			IORESOURCE_MEM_WRITEABLE : 0;
+	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
 	return;
@@ -502,7 +533,7 @@ pnpacpi_parse_mem32_option(struct pnp_op
 
 static void
 pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-	struct acpi_resource_fixed_memory32 *p)
+				 struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -516,7 +547,7 @@ pnpacpi_parse_fixed_mem32_option(struct 
 	mem->align = 0;
 
 	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-			IORESOURCE_MEM_WRITEABLE : 0;
+	    IORESOURCE_MEM_WRITEABLE : 0;
 
 	pnp_register_mem_resource(option, mem);
 	return;
@@ -532,7 +563,8 @@ pnpacpi_parse_address_option(struct pnp_
 
 	status = acpi_resource_to_address64(r, p);
 	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d", r->type);
+		pnp_warn("PnPACPI: failed to convert resource type %d",
+			 r->type);
 		return;
 	}
 
@@ -547,7 +579,8 @@ pnpacpi_parse_address_option(struct pnp_
 		mem->size = p->address_length;
 		mem->align = 0;
 		mem->flags = (p->info.mem.write_protect ==
-		    ACPI_READ_WRITE_MEMORY) ? IORESOURCE_MEM_WRITEABLE : 0;
+			      ACPI_READ_WRITE_MEMORY) ? IORESOURCE_MEM_WRITEABLE
+		    : 0;
 		pnp_register_mem_resource(option, mem);
 	} else if (p->resource_type == ACPI_IO_RANGE) {
 		port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
@@ -568,109 +601,108 @@ struct acpipnp_parse_option_s {
 };
 
 static acpi_status pnpacpi_option_resource(struct acpi_resource *res,
-	void *data)
+					   void *data)
 {
 	int priority = 0;
-	struct acpipnp_parse_option_s *parse_data = (struct acpipnp_parse_option_s *)data;
+	struct acpipnp_parse_option_s *parse_data =
+	    (struct acpipnp_parse_option_s *)data;
 	struct pnp_dev *dev = parse_data->dev;
 	struct pnp_option *option = parse_data->option;
 
 	switch (res->type) {
-		case ACPI_RESOURCE_TYPE_IRQ:
-			pnpacpi_parse_irq_option(option, &res->data.irq);
-			break;
+	case ACPI_RESOURCE_TYPE_IRQ:
+		pnpacpi_parse_irq_option(option, &res->data.irq);
+		break;
 
-		case ACPI_RESOURCE_TYPE_DMA:
-			pnpacpi_parse_dma_option(option, &res->data.dma);
-			break;
+	case ACPI_RESOURCE_TYPE_DMA:
+		pnpacpi_parse_dma_option(option, &res->data.dma);
+		break;
 
-		case ACPI_RESOURCE_TYPE_START_DEPENDENT:
-			switch (res->data.start_dpf.compatibility_priority) {
-				case ACPI_GOOD_CONFIGURATION:
-					priority = PNP_RES_PRIORITY_PREFERRED;
-					break;
-
-				case ACPI_ACCEPTABLE_CONFIGURATION:
-					priority = PNP_RES_PRIORITY_ACCEPTABLE;
-					break;
-
-				case ACPI_SUB_OPTIMAL_CONFIGURATION:
-					priority = PNP_RES_PRIORITY_FUNCTIONAL;
-					break;
-				default:
-					priority = PNP_RES_PRIORITY_INVALID;
-					break;
-			}
-			/* TBD: Considering performace/robustness bits */
-			option = pnp_register_dependent_option(dev, priority);
-			if (!option)
-				return AE_ERROR;
-			parse_data->option = option;
+	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
+		switch (res->data.start_dpf.compatibility_priority) {
+		case ACPI_GOOD_CONFIGURATION:
+			priority = PNP_RES_PRIORITY_PREFERRED;
 			break;
 
-		case ACPI_RESOURCE_TYPE_END_DEPENDENT:
-			/*only one EndDependentFn is allowed*/
-			if (!parse_data->option_independent) {
-				pnp_warn("PnPACPI: more than one EndDependentFn");
-				return AE_ERROR;
-			}
-			parse_data->option = parse_data->option_independent;
-			parse_data->option_independent = NULL;
+		case ACPI_ACCEPTABLE_CONFIGURATION:
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			break;
 
-		case ACPI_RESOURCE_TYPE_IO:
-			pnpacpi_parse_port_option(option, &res->data.io);
+		case ACPI_SUB_OPTIMAL_CONFIGURATION:
+			priority = PNP_RES_PRIORITY_FUNCTIONAL;
 			break;
-
-		case ACPI_RESOURCE_TYPE_FIXED_IO:
-			pnpacpi_parse_fixed_port_option(option,
-				&res->data.fixed_io);
+		default:
+			priority = PNP_RES_PRIORITY_INVALID;
 			break;
+		}
+		/* TBD: Considering performace/robustness bits */
+		option = pnp_register_dependent_option(dev, priority);
+		if (!option)
+			return AE_ERROR;
+		parse_data->option = option;
+		break;
 
-		case ACPI_RESOURCE_TYPE_VENDOR:
-		case ACPI_RESOURCE_TYPE_END_TAG:
-			break;
+	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
+		/*only one EndDependentFn is allowed */
+		if (!parse_data->option_independent) {
+			pnp_warn("PnPACPI: more than one EndDependentFn");
+			return AE_ERROR;
+		}
+		parse_data->option = parse_data->option_independent;
+		parse_data->option_independent = NULL;
+		break;
 
-		case ACPI_RESOURCE_TYPE_MEMORY24:
-			pnpacpi_parse_mem24_option(option, &res->data.memory24);
-			break;
+	case ACPI_RESOURCE_TYPE_IO:
+		pnpacpi_parse_port_option(option, &res->data.io);
+		break;
 
-		case ACPI_RESOURCE_TYPE_MEMORY32:
-			pnpacpi_parse_mem32_option(option, &res->data.memory32);
-			break;
+	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		pnpacpi_parse_fixed_port_option(option, &res->data.fixed_io);
+		break;
 
-		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-			pnpacpi_parse_fixed_mem32_option(option,
-				&res->data.fixed_memory32);
-			break;
+	case ACPI_RESOURCE_TYPE_VENDOR:
+	case ACPI_RESOURCE_TYPE_END_TAG:
+		break;
 
-		case ACPI_RESOURCE_TYPE_ADDRESS16:
-		case ACPI_RESOURCE_TYPE_ADDRESS32:
-		case ACPI_RESOURCE_TYPE_ADDRESS64:
-			pnpacpi_parse_address_option(option, res);
-			break;
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+		pnpacpi_parse_mem24_option(option, &res->data.memory24);
+		break;
 
-		case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
-			break;
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+		pnpacpi_parse_mem32_option(option, &res->data.memory32);
+		break;
 
-		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-			pnpacpi_parse_ext_irq_option(option,
-				&res->data.extended_irq);
-			break;
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		pnpacpi_parse_fixed_mem32_option(option,
+						 &res->data.fixed_memory32);
+		break;
 
-		case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
-			break;
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		pnpacpi_parse_address_option(option, res);
+		break;
 
-		default:
-			pnp_warn("PnPACPI: unknown resource type %d", res->type);
-			return AE_ERROR;
+	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
+		break;
+
+	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
+		pnpacpi_parse_ext_irq_option(option, &res->data.extended_irq);
+		break;
+
+	case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
+		break;
+
+	default:
+		pnp_warn("PnPACPI: unknown resource type %d", res->type);
+		return AE_ERROR;
 	}
 
 	return AE_OK;
 }
 
 acpi_status pnpacpi_parse_resource_option_data(acpi_handle handle,
-	struct pnp_dev *dev)
+					       struct pnp_dev * dev)
 {
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
@@ -681,7 +713,7 @@ acpi_status pnpacpi_parse_resource_optio
 	parse_data.option_independent = parse_data.option;
 	parse_data.dev = dev;
 	status = acpi_walk_resources(handle, METHOD_NAME__PRS,
-		pnpacpi_option_resource, &parse_data);
+				     pnpacpi_option_resource, &parse_data);
 
 	return status;
 }
@@ -709,7 +741,7 @@ static int pnpacpi_supported_resource(st
  * Set resource
  */
 static acpi_status pnpacpi_count_resources(struct acpi_resource *res,
-	void *data)
+					   void *data)
 {
 	int *res_cnt = (int *)data;
 
@@ -732,14 +764,14 @@ static acpi_status pnpacpi_type_resource
 }
 
 int pnpacpi_build_resource_template(acpi_handle handle,
-	struct acpi_buffer *buffer)
+				    struct acpi_buffer *buffer)
 {
 	struct acpi_resource *resource;
 	int res_cnt = 0;
 	acpi_status status;
 
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
-		pnpacpi_count_resources, &res_cnt);
+				     pnpacpi_count_resources, &res_cnt);
 	if (ACPI_FAILURE(status)) {
 		pnp_err("Evaluate _CRS failed");
 		return -EINVAL;
@@ -753,7 +785,7 @@ int pnpacpi_build_resource_template(acpi
 	pnp_dbg("Res cnt %d", res_cnt);
 	resource = (struct acpi_resource *)buffer->pointer;
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
-		pnpacpi_type_resources, &resource);
+				     pnpacpi_type_resources, &resource);
 	if (ACPI_FAILURE(status)) {
 		kfree(buffer->pointer);
 		pnp_err("Evaluate _CRS failed");
@@ -766,7 +798,7 @@ int pnpacpi_build_resource_template(acpi
 }
 
 static void pnpacpi_encode_irq(struct acpi_resource *resource,
-	struct resource *p)
+			       struct resource *p)
 {
 	int triggering, polarity;
 
@@ -782,7 +814,7 @@ static void pnpacpi_encode_irq(struct ac
 }
 
 static void pnpacpi_encode_ext_irq(struct acpi_resource *resource,
-	struct resource *p)
+				   struct resource *p)
 {
 	int triggering, polarity;
 
@@ -799,32 +831,32 @@ static void pnpacpi_encode_ext_irq(struc
 }
 
 static void pnpacpi_encode_dma(struct acpi_resource *resource,
-	struct resource *p)
+			       struct resource *p)
 {
 	/* Note: pnp_assign_dma will copy pnp_dma->flags into p->flags */
 	switch (p->flags & IORESOURCE_DMA_SPEED_MASK) {
-		case IORESOURCE_DMA_TYPEA:
-			resource->data.dma.type = ACPI_TYPE_A;
-			break;
-		case IORESOURCE_DMA_TYPEB:
-			resource->data.dma.type = ACPI_TYPE_B;
-			break;
-		case IORESOURCE_DMA_TYPEF:
-			resource->data.dma.type = ACPI_TYPE_F;
-			break;
-		default:
-			resource->data.dma.type = ACPI_COMPATIBILITY;
+	case IORESOURCE_DMA_TYPEA:
+		resource->data.dma.type = ACPI_TYPE_A;
+		break;
+	case IORESOURCE_DMA_TYPEB:
+		resource->data.dma.type = ACPI_TYPE_B;
+		break;
+	case IORESOURCE_DMA_TYPEF:
+		resource->data.dma.type = ACPI_TYPE_F;
+		break;
+	default:
+		resource->data.dma.type = ACPI_COMPATIBILITY;
 	}
 
 	switch (p->flags & IORESOURCE_DMA_TYPE_MASK) {
-		case IORESOURCE_DMA_8BIT:
-			resource->data.dma.transfer = ACPI_TRANSFER_8;
-			break;
-		case IORESOURCE_DMA_8AND16BIT:
-			resource->data.dma.transfer = ACPI_TRANSFER_8_16;
-			break;
-		default:
-			resource->data.dma.transfer = ACPI_TRANSFER_16;
+	case IORESOURCE_DMA_8BIT:
+		resource->data.dma.transfer = ACPI_TRANSFER_8;
+		break;
+	case IORESOURCE_DMA_8AND16BIT:
+		resource->data.dma.transfer = ACPI_TRANSFER_8_16;
+		break;
+	default:
+		resource->data.dma.transfer = ACPI_TRANSFER_16;
 	}
 
 	resource->data.dma.bus_master = !!(p->flags & IORESOURCE_DMA_MASTER);
@@ -833,31 +865,31 @@ static void pnpacpi_encode_dma(struct ac
 }
 
 static void pnpacpi_encode_io(struct acpi_resource *resource,
-	struct resource *p)
+			      struct resource *p)
 {
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
-	resource->data.io.io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR)?
-		ACPI_DECODE_16 : ACPI_DECODE_10;
+	resource->data.io.io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
+	    ACPI_DECODE_16 : ACPI_DECODE_10;
 	resource->data.io.minimum = p->start;
 	resource->data.io.maximum = p->end;
-	resource->data.io.alignment = 0; /* Correct? */
+	resource->data.io.alignment = 0;	/* Correct? */
 	resource->data.io.address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_fixed_io(struct acpi_resource *resource,
-	struct resource *p)
+				    struct resource *p)
 {
 	resource->data.fixed_io.address = p->start;
 	resource->data.fixed_io.address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_mem24(struct acpi_resource *resource,
-	struct resource *p)
+				 struct resource *p)
 {
 	/* Note: pnp_assign_mem will copy pnp_mem->flags into p->flags */
 	resource->data.memory24.write_protect =
-		(p->flags & IORESOURCE_MEM_WRITEABLE) ?
-		ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
+	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
 	resource->data.memory24.minimum = p->start;
 	resource->data.memory24.maximum = p->end;
 	resource->data.memory24.alignment = 0;
@@ -865,11 +897,11 @@ static void pnpacpi_encode_mem24(struct 
 }
 
 static void pnpacpi_encode_mem32(struct acpi_resource *resource,
-	struct resource *p)
+				 struct resource *p)
 {
 	resource->data.memory32.write_protect =
-		(p->flags & IORESOURCE_MEM_WRITEABLE) ?
-		ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
+	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
 	resource->data.memory32.minimum = p->start;
 	resource->data.memory32.maximum = p->end;
 	resource->data.memory32.alignment = 0;
@@ -877,74 +909,77 @@ static void pnpacpi_encode_mem32(struct 
 }
 
 static void pnpacpi_encode_fixed_mem32(struct acpi_resource *resource,
-	struct resource *p)
+				       struct resource *p)
 {
 	resource->data.fixed_memory32.write_protect =
-		(p->flags & IORESOURCE_MEM_WRITEABLE) ?
-		ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
+	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
 	resource->data.fixed_memory32.address = p->start;
 	resource->data.fixed_memory32.address_length = p->end - p->start + 1;
 }
 
 int pnpacpi_encode_resources(struct pnp_resource_table *res_table,
-	struct acpi_buffer *buffer)
+			     struct acpi_buffer *buffer)
 {
 	int i = 0;
 	/* pnpacpi_build_resource_template allocates extra mem */
-	int res_cnt = (buffer->length - 1)/sizeof(struct acpi_resource) - 1;
-	struct acpi_resource *resource = (struct acpi_resource*)buffer->pointer;
+	int res_cnt = (buffer->length - 1) / sizeof(struct acpi_resource) - 1;
+	struct acpi_resource *resource =
+	    (struct acpi_resource *)buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
 	pnp_dbg("res cnt %d", res_cnt);
 	while (i < res_cnt) {
-		switch(resource->type) {
+		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
 			pnp_dbg("Encode irq");
 			pnpacpi_encode_irq(resource,
-				&res_table->irq_resource[irq]);
+					   &res_table->irq_resource[irq]);
 			irq++;
 			break;
 
 		case ACPI_RESOURCE_TYPE_DMA:
 			pnp_dbg("Encode dma");
 			pnpacpi_encode_dma(resource,
-				&res_table->dma_resource[dma]);
+					   &res_table->dma_resource[dma]);
 			dma++;
 			break;
 		case ACPI_RESOURCE_TYPE_IO:
 			pnp_dbg("Encode io");
 			pnpacpi_encode_io(resource,
-				&res_table->port_resource[port]);
+					  &res_table->port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_IO:
 			pnp_dbg("Encode fixed io");
 			pnpacpi_encode_fixed_io(resource,
-				&res_table->port_resource[port]);
+						&res_table->
+						port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY24:
 			pnp_dbg("Encode mem24");
 			pnpacpi_encode_mem24(resource,
-				&res_table->mem_resource[mem]);
+					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY32:
 			pnp_dbg("Encode mem32");
 			pnpacpi_encode_mem32(resource,
-				&res_table->mem_resource[mem]);
+					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 			pnp_dbg("Encode fixed mem32");
 			pnpacpi_encode_fixed_mem32(resource,
-				&res_table->mem_resource[mem]);
+						   &res_table->
+						   mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 			pnp_dbg("Encode ext irq");
 			pnpacpi_encode_ext_irq(resource,
-				&res_table->irq_resource[irq]);
+					       &res_table->irq_resource[irq]);
 			irq++;
 			break;
 		case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -956,7 +991,7 @@ int pnpacpi_encode_resources(struct pnp_
 		case ACPI_RESOURCE_TYPE_ADDRESS64:
 		case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
 		case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
-		default: /* other type */
+		default:	/* other type */
 			pnp_warn("unknown resource type %d", resource->type);
 			return -EINVAL;
 		}
diff -puN drivers/pnp/pnpbios/bioscalls.c~pnp-lindent-all-source-files drivers/pnp/pnpbios/bioscalls.c
--- a/drivers/pnp/pnpbios/bioscalls.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpbios/bioscalls.c
@@ -26,11 +26,10 @@
 #include "pnpbios.h"
 
 static struct {
-	u16	offset;
-	u16	segment;
+	u16 offset;
+	u16 segment;
 } pnp_bios_callpoint;
 
-
 /*
  * These are some opcodes for a "static asmlinkage"
  * As this code is *not* executed inside the linux kernel segment, but in a
@@ -44,8 +43,7 @@ static struct {
 
 asmlinkage void pnp_bios_callfunc(void);
 
-__asm__(
-	".text			\n"
+__asm__(".text			\n"
 	__ALIGN_STR "\n"
 	"pnp_bios_callfunc:\n"
 	"	pushl %edx	\n"
@@ -54,9 +52,7 @@ __asm__(
 	"	pushl %eax	\n"
 	"	lcallw *pnp_bios_callpoint\n"
 	"	addl $16, %esp	\n"
-	"	lret		\n"
-	".previous		\n"
-);
+	"	lret		\n" ".previous		\n");
 
 #define Q2_SET_SEL(cpu, selname, address, size) \
 do { \
@@ -78,7 +74,6 @@ u32 pnp_bios_is_utter_crap = 0;
 
 static spinlock_t pnp_bios_lock;
 
-
 /*
  * Support Functions
  */
@@ -97,7 +92,7 @@ static inline u16 call_pnp_bios(u16 func
 	 * PnP BIOSes are generally not terribly re-entrant.
 	 * Also, don't rely on them to save everything correctly.
 	 */
-	if(pnp_bios_is_utter_crap)
+	if (pnp_bios_is_utter_crap)
 		return PNP_FUNCTION_NOT_SUPPORTED;
 
 	cpu = get_cpu();
@@ -113,112 +108,127 @@ static inline u16 call_pnp_bios(u16 func
 	if (ts2_size)
 		Q2_SET_SEL(smp_processor_id(), PNP_TS2, ts2_base, ts2_size);
 
-	__asm__ __volatile__(
-	        "pushl %%ebp\n\t"
-		"pushl %%edi\n\t"
-		"pushl %%esi\n\t"
-		"pushl %%ds\n\t"
-		"pushl %%es\n\t"
-		"pushl %%fs\n\t"
-		"pushl %%gs\n\t"
-		"pushfl\n\t"
-		"movl %%esp, pnp_bios_fault_esp\n\t"
-		"movl $1f, pnp_bios_fault_eip\n\t"
-		"lcall %5,%6\n\t"
-		"1:popfl\n\t"
-		"popl %%gs\n\t"
-		"popl %%fs\n\t"
-		"popl %%es\n\t"
-		"popl %%ds\n\t"
-	        "popl %%esi\n\t"
-		"popl %%edi\n\t"
-		"popl %%ebp\n\t"
-		: "=a" (status)
-		: "0" ((func) | (((u32)arg1) << 16)),
-		  "b" ((arg2) | (((u32)arg3) << 16)),
-		  "c" ((arg4) | (((u32)arg5) << 16)),
-		  "d" ((arg6) | (((u32)arg7) << 16)),
-		  "i" (PNP_CS32),
-		  "i" (0)
-		: "memory"
-	);
+	__asm__ __volatile__("pushl %%ebp\n\t"
+			     "pushl %%edi\n\t"
+			     "pushl %%esi\n\t"
+			     "pushl %%ds\n\t"
+			     "pushl %%es\n\t"
+			     "pushl %%fs\n\t"
+			     "pushl %%gs\n\t"
+			     "pushfl\n\t"
+			     "movl %%esp, pnp_bios_fault_esp\n\t"
+			     "movl $1f, pnp_bios_fault_eip\n\t"
+			     "lcall %5,%6\n\t"
+			     "1:popfl\n\t"
+			     "popl %%gs\n\t"
+			     "popl %%fs\n\t"
+			     "popl %%es\n\t"
+			     "popl %%ds\n\t"
+			     "popl %%esi\n\t"
+			     "popl %%edi\n\t" "popl %%ebp\n\t":"=a"(status)
+			     :"0"((func) | (((u32) arg1) << 16)),
+			     "b"((arg2) | (((u32) arg3) << 16)),
+			     "c"((arg4) | (((u32) arg5) << 16)),
+			     "d"((arg6) | (((u32) arg7) << 16)),
+			     "i"(PNP_CS32), "i"(0)
+			     :"memory");
 	spin_unlock_irqrestore(&pnp_bios_lock, flags);
 
 	get_cpu_gdt_table(cpu)[0x40 / 8] = save_desc_40;
 	put_cpu();
 
 	/* If we get here and this is set then the PnP BIOS faulted on us. */
-	if(pnp_bios_is_utter_crap)
-	{
-		printk(KERN_ERR "PnPBIOS: Warning! Your PnP BIOS caused a fatal error. Attempting to continue\n");
-		printk(KERN_ERR "PnPBIOS: You may need to reboot with the \"pnpbios=off\" option to operate stably\n");
-		printk(KERN_ERR "PnPBIOS: Check with your vendor for an updated BIOS\n");
+	if (pnp_bios_is_utter_crap) {
+		printk(KERN_ERR
+		       "PnPBIOS: Warning! Your PnP BIOS caused a fatal error. Attempting to continue\n");
+		printk(KERN_ERR
+		       "PnPBIOS: You may need to reboot with the \"pnpbios=off\" option to operate stably\n");
+		printk(KERN_ERR
+		       "PnPBIOS: Check with your vendor for an updated BIOS\n");
 	}
 
 	return status;
 }
 
-void pnpbios_print_status(const char * module, u16 status)
+void pnpbios_print_status(const char *module, u16 status)
 {
-	switch(status) {
+	switch (status) {
 	case PNP_SUCCESS:
 		printk(KERN_ERR "PnPBIOS: %s: function successful\n", module);
 		break;
 	case PNP_NOT_SET_STATICALLY:
-		printk(KERN_ERR "PnPBIOS: %s: unable to set static resources\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: unable to set static resources\n",
+		       module);
 		break;
 	case PNP_UNKNOWN_FUNCTION:
-		printk(KERN_ERR "PnPBIOS: %s: invalid function number passed\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: invalid function number passed\n",
+		       module);
 		break;
 	case PNP_FUNCTION_NOT_SUPPORTED:
-		printk(KERN_ERR "PnPBIOS: %s: function not supported on this system\n", module);
+		printk(KERN_ERR
+		       "PnPBIOS: %s: function not supported on this system\n",
+		       module);
 		break;
 	case PNP_INVALID_HANDLE:
 		printk(KERN_ERR "PnPBIOS: %s: invalid handle\n", module);
 		break;
 	case PNP_BAD_PARAMETER:
-		printk(KERN_ERR "PnPBIOS: %s: invalid parameters were passed\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: invalid parameters were passed\n",
+		       module);
 		break;
 	case PNP_SET_FAILED:
-		printk(KERN_ERR "PnPBIOS: %s: unable to set resources\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: unable to set resources\n",
+		       module);
 		break;
 	case PNP_EVENTS_NOT_PENDING:
 		printk(KERN_ERR "PnPBIOS: %s: no events are pending\n", module);
 		break;
 	case PNP_SYSTEM_NOT_DOCKED:
-		printk(KERN_ERR "PnPBIOS: %s: the system is not docked\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: the system is not docked\n",
+		       module);
 		break;
 	case PNP_NO_ISA_PNP_CARDS:
-		printk(KERN_ERR "PnPBIOS: %s: no isapnp cards are installed on this system\n", module);
+		printk(KERN_ERR
+		       "PnPBIOS: %s: no isapnp cards are installed on this system\n",
+		       module);
 		break;
 	case PNP_UNABLE_TO_DETERMINE_DOCK_CAPABILITIES:
-		printk(KERN_ERR "PnPBIOS: %s: cannot determine the capabilities of the docking station\n", module);
+		printk(KERN_ERR
+		       "PnPBIOS: %s: cannot determine the capabilities of the docking station\n",
+		       module);
 		break;
 	case PNP_CONFIG_CHANGE_FAILED_NO_BATTERY:
-		printk(KERN_ERR "PnPBIOS: %s: unable to undock, the system does not have a battery\n", module);
+		printk(KERN_ERR
+		       "PnPBIOS: %s: unable to undock, the system does not have a battery\n",
+		       module);
 		break;
 	case PNP_CONFIG_CHANGE_FAILED_RESOURCE_CONFLICT:
-		printk(KERN_ERR "PnPBIOS: %s: could not dock due to resource conflicts\n", module);
+		printk(KERN_ERR
+		       "PnPBIOS: %s: could not dock due to resource conflicts\n",
+		       module);
 		break;
 	case PNP_BUFFER_TOO_SMALL:
-		printk(KERN_ERR "PnPBIOS: %s: the buffer passed is too small\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: the buffer passed is too small\n",
+		       module);
 		break;
 	case PNP_USE_ESCD_SUPPORT:
 		printk(KERN_ERR "PnPBIOS: %s: use ESCD instead\n", module);
 		break;
 	case PNP_MESSAGE_NOT_SUPPORTED:
-		printk(KERN_ERR "PnPBIOS: %s: the message is unsupported\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: the message is unsupported\n",
+		       module);
 		break;
 	case PNP_HARDWARE_ERROR:
-		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occured\n", module);
+		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occured\n",
+		       module);
 		break;
 	default:
-		printk(KERN_ERR "PnPBIOS: %s: unexpected status 0x%x\n", module, status);
+		printk(KERN_ERR "PnPBIOS: %s: unexpected status 0x%x\n", module,
+		       status);
 		break;
 	}
 }
 
-
 /*
  * PnP BIOS Low Level Calls
  */
@@ -245,17 +255,19 @@ static int __pnp_bios_dev_node_info(stru
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_NUM_SYS_DEV_NODES, 0, PNP_TS1, 2, PNP_TS1, PNP_DS, 0, 0,
-			       data, sizeof(struct pnp_dev_node_info), NULL, 0);
+	status =
+	    call_pnp_bios(PNP_GET_NUM_SYS_DEV_NODES, 0, PNP_TS1, 2, PNP_TS1,
+			  PNP_DS, 0, 0, data, sizeof(struct pnp_dev_node_info),
+			  NULL, 0);
 	data->no_nodes &= 0xff;
 	return status;
 }
 
 int pnp_bios_dev_node_info(struct pnp_dev_node_info *data)
 {
-	int status = __pnp_bios_dev_node_info( data );
-	if ( status )
-		pnpbios_print_status( "dev_node_info", status );
+	int status = __pnp_bios_dev_node_info(data);
+	if (status)
+		pnpbios_print_status("dev_node_info", status);
 	return status;
 }
 
@@ -273,60 +285,64 @@ int pnp_bios_dev_node_info(struct pnp_de
  *               or volatile current (0) config
  * Output: *nodenum=next node or 0xff if no more nodes
  */
-static int __pnp_bios_get_dev_node(u8 *nodenum, char boot, struct pnp_bios_node *data)
+static int __pnp_bios_get_dev_node(u8 * nodenum, char boot,
+				   struct pnp_bios_node *data)
 {
 	u16 status;
 	u16 tmp_nodenum;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	if ( !boot && pnpbios_dont_use_current_config )
+	if (!boot && pnpbios_dont_use_current_config)
 		return PNP_FUNCTION_NOT_SUPPORTED;
 	tmp_nodenum = *nodenum;
-	status = call_pnp_bios(PNP_GET_SYS_DEV_NODE, 0, PNP_TS1, 0, PNP_TS2, boot ? 2 : 1, PNP_DS, 0,
-			       &tmp_nodenum, sizeof(tmp_nodenum), data, 65536);
+	status =
+	    call_pnp_bios(PNP_GET_SYS_DEV_NODE, 0, PNP_TS1, 0, PNP_TS2,
+			  boot ? 2 : 1, PNP_DS, 0, &tmp_nodenum,
+			  sizeof(tmp_nodenum), data, 65536);
 	*nodenum = tmp_nodenum;
 	return status;
 }
 
-int pnp_bios_get_dev_node(u8 *nodenum, char boot, struct pnp_bios_node *data)
+int pnp_bios_get_dev_node(u8 * nodenum, char boot, struct pnp_bios_node *data)
 {
 	int status;
-	status =  __pnp_bios_get_dev_node( nodenum, boot, data );
-	if ( status )
-		pnpbios_print_status( "get_dev_node", status );
+	status = __pnp_bios_get_dev_node(nodenum, boot, data);
+	if (status)
+		pnpbios_print_status("get_dev_node", status);
 	return status;
 }
 
-
 /*
  * Call PnP BIOS with function 0x02, "set system device node"
  * Input: *nodenum = desired node, 
  *        boot = whether to set nonvolatile boot (!=0)
  *               or volatile current (0) config
  */
-static int __pnp_bios_set_dev_node(u8 nodenum, char boot, struct pnp_bios_node *data)
+static int __pnp_bios_set_dev_node(u8 nodenum, char boot,
+				   struct pnp_bios_node *data)
 {
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	if ( !boot && pnpbios_dont_use_current_config )
+	if (!boot && pnpbios_dont_use_current_config)
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_SET_SYS_DEV_NODE, nodenum, 0, PNP_TS1, boot ? 2 : 1, PNP_DS, 0, 0,
-			       data, 65536, NULL, 0);
+	status =
+	    call_pnp_bios(PNP_SET_SYS_DEV_NODE, nodenum, 0, PNP_TS1,
+			  boot ? 2 : 1, PNP_DS, 0, 0, data, 65536, NULL, 0);
 	return status;
 }
 
 int pnp_bios_set_dev_node(u8 nodenum, char boot, struct pnp_bios_node *data)
 {
 	int status;
-	status =  __pnp_bios_set_dev_node( nodenum, boot, data );
-	if ( status ) {
-		pnpbios_print_status( "set_dev_node", status );
+	status = __pnp_bios_set_dev_node(nodenum, boot, data);
+	if (status) {
+		pnpbios_print_status("set_dev_node", status);
 		return status;
 	}
-	if ( !boot ) { /* Update devlist */
-		status =  pnp_bios_get_dev_node( &nodenum, boot, data );
-		if ( status )
+	if (!boot) {		/* Update devlist */
+		status = pnp_bios_get_dev_node(&nodenum, boot, data);
+		if (status)
 			return status;
 	}
 	return status;
@@ -336,12 +352,12 @@ int pnp_bios_set_dev_node(u8 nodenum, ch
 /*
  * Call PnP BIOS with function 0x03, "get event"
  */
-static int pnp_bios_get_event(u16 *event)
+static int pnp_bios_get_event(u16 * event)
 {
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_EVENT, 0, PNP_TS1, PNP_DS, 0, 0 ,0 ,0,
+	status = call_pnp_bios(PNP_GET_EVENT, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
 			       event, sizeof(u16), NULL, 0);
 	return status;
 }
@@ -356,7 +372,9 @@ static int pnp_bios_send_message(u16 mes
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_SEND_MESSAGE, message, PNP_DS, 0, 0, 0, 0, 0, 0, 0, 0, 0);
+	status =
+	    call_pnp_bios(PNP_SEND_MESSAGE, message, PNP_DS, 0, 0, 0, 0, 0, 0,
+			  0, 0, 0);
 	return status;
 }
 #endif
@@ -369,8 +387,10 @@ int pnp_bios_dock_station_info(struct pn
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_DOCKING_STATION_INFORMATION, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
-			       data, sizeof(struct pnp_docking_station_info), NULL, 0);
+	status =
+	    call_pnp_bios(PNP_GET_DOCKING_STATION_INFORMATION, 0, PNP_TS1,
+			  PNP_DS, 0, 0, 0, 0, data,
+			  sizeof(struct pnp_docking_station_info), NULL, 0);
 	return status;
 }
 
@@ -384,8 +404,9 @@ static int pnp_bios_set_stat_res(char *i
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_SET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
-			       info, *((u16 *) info), 0, 0);
+	status =
+	    call_pnp_bios(PNP_SET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS,
+			  0, 0, 0, 0, info, *((u16 *) info), 0, 0);
 	return status;
 }
 #endif
@@ -399,17 +420,18 @@ static int __pnp_bios_get_stat_res(char 
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
-			       info, 65536, NULL, 0);
+	status =
+	    call_pnp_bios(PNP_GET_STATIC_ALLOCED_RES_INFO, 0, PNP_TS1, PNP_DS,
+			  0, 0, 0, 0, info, 65536, NULL, 0);
 	return status;
 }
 
 int pnp_bios_get_stat_res(char *info)
 {
 	int status;
-	status = __pnp_bios_get_stat_res( info );
-	if ( status )
-		pnpbios_print_status( "get_stat_res", status );
+	status = __pnp_bios_get_stat_res(info);
+	if (status)
+		pnpbios_print_status("get_stat_res", status);
 	return status;
 }
 
@@ -417,13 +439,14 @@ int pnp_bios_get_stat_res(char *info)
 /*
  * Call PnP BIOS with function 0x0b, "get APM id table"
  */
-static int pnp_bios_apm_id_table(char *table, u16 *size)
+static int pnp_bios_apm_id_table(char *table, u16 * size)
 {
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_APM_ID_TABLE, 0, PNP_TS2, 0, PNP_TS1, PNP_DS, 0, 0,
-			       table, *size, size, sizeof(u16));
+	status =
+	    call_pnp_bios(PNP_GET_APM_ID_TABLE, 0, PNP_TS2, 0, PNP_TS1, PNP_DS,
+			  0, 0, table, *size, size, sizeof(u16));
 	return status;
 }
 #endif
@@ -436,17 +459,19 @@ static int __pnp_bios_isapnp_config(stru
 	u16 status;
 	if (!pnp_bios_present())
 		return PNP_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_PNP_ISA_CONFIG_STRUC, 0, PNP_TS1, PNP_DS, 0, 0, 0, 0,
-			       data, sizeof(struct pnp_isa_config_struc), NULL, 0);
+	status =
+	    call_pnp_bios(PNP_GET_PNP_ISA_CONFIG_STRUC, 0, PNP_TS1, PNP_DS, 0,
+			  0, 0, 0, data, sizeof(struct pnp_isa_config_struc),
+			  NULL, 0);
 	return status;
 }
 
 int pnp_bios_isapnp_config(struct pnp_isa_config_struc *data)
 {
 	int status;
-	status = __pnp_bios_isapnp_config( data );
-	if ( status )
-		pnpbios_print_status( "isapnp_config", status );
+	status = __pnp_bios_isapnp_config(data);
+	if (status)
+		pnpbios_print_status("isapnp_config", status);
 	return status;
 }
 
@@ -458,17 +483,19 @@ static int __pnp_bios_escd_info(struct e
 	u16 status;
 	if (!pnp_bios_present())
 		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_GET_ESCD_INFO, 0, PNP_TS1, 2, PNP_TS1, 4, PNP_TS1, PNP_DS,
-			       data, sizeof(struct escd_info_struc), NULL, 0);
+	status =
+	    call_pnp_bios(PNP_GET_ESCD_INFO, 0, PNP_TS1, 2, PNP_TS1, 4, PNP_TS1,
+			  PNP_DS, data, sizeof(struct escd_info_struc), NULL,
+			  0);
 	return status;
 }
 
 int pnp_bios_escd_info(struct escd_info_struc *data)
 {
 	int status;
-	status = __pnp_bios_escd_info( data );
-	if ( status )
-		pnpbios_print_status( "escd_info", status );
+	status = __pnp_bios_escd_info(data);
+	if (status)
+		pnpbios_print_status("escd_info", status);
 	return status;
 }
 
@@ -481,17 +508,18 @@ static int __pnp_bios_read_escd(char *da
 	u16 status;
 	if (!pnp_bios_present())
 		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_READ_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
-			       data, 65536, __va(nvram_base), 65536);
+	status =
+	    call_pnp_bios(PNP_READ_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
+			  data, 65536, __va(nvram_base), 65536);
 	return status;
 }
 
 int pnp_bios_read_escd(char *data, u32 nvram_base)
 {
 	int status;
-	status = __pnp_bios_read_escd( data, nvram_base );
-	if ( status )
-		pnpbios_print_status( "read_escd", status );
+	status = __pnp_bios_read_escd(data, nvram_base);
+	if (status)
+		pnpbios_print_status("read_escd", status);
 	return status;
 }
 
@@ -504,13 +532,13 @@ static int pnp_bios_write_escd(char *dat
 	u16 status;
 	if (!pnp_bios_present())
 		return ESCD_FUNCTION_NOT_SUPPORTED;
-	status = call_pnp_bios(PNP_WRITE_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
-			       data, 65536, __va(nvram_base), 65536);
+	status =
+	    call_pnp_bios(PNP_WRITE_ESCD, 0, PNP_TS1, PNP_TS2, PNP_DS, 0, 0, 0,
+			  data, 65536, __va(nvram_base), 65536);
 	return status;
 }
 #endif
 
-
 /*
  * Initialization
  */
@@ -524,12 +552,14 @@ void pnpbios_calls_init(union pnp_bios_i
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
- 	for (i = 0; i < NR_CPUS; i++) {
-  		struct desc_struct *gdt = get_cpu_gdt_table(i);
-  		if (!gdt)
-  			continue;
- 		set_base(gdt[GDT_ENTRY_PNPBIOS_CS32], &pnp_bios_callfunc);
- 		set_base(gdt[GDT_ENTRY_PNPBIOS_CS16], __va(header->fields.pm16cseg));
- 		set_base(gdt[GDT_ENTRY_PNPBIOS_DS], __va(header->fields.pm16dseg));
-  	}
+	for (i = 0; i < NR_CPUS; i++) {
+		struct desc_struct *gdt = get_cpu_gdt_table(i);
+		if (!gdt)
+			continue;
+		set_base(gdt[GDT_ENTRY_PNPBIOS_CS32], &pnp_bios_callfunc);
+		set_base(gdt[GDT_ENTRY_PNPBIOS_CS16],
+			 __va(header->fields.pm16cseg));
+		set_base(gdt[GDT_ENTRY_PNPBIOS_DS],
+			 __va(header->fields.pm16dseg));
+	}
 }
diff -puN drivers/pnp/pnpbios/core.c~pnp-lindent-all-source-files drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpbios/core.c
@@ -32,7 +32,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
- 
+
 /* Change Log
  *
  * Adam Belay - <ambx1@neo.rr.com> - March 16, 2003
@@ -71,14 +71,13 @@
 
 #include "pnpbios.h"
 
-
 /*
  *
  * PnP BIOS INTERFACE
  *
  */
 
-static union pnp_bios_install_struct * pnp_bios_install = NULL;
+static union pnp_bios_install_struct *pnp_bios_install = NULL;
 
 int pnp_bios_present(void)
 {
@@ -101,36 +100,36 @@ static struct completion unload_sem;
 /*
  * (Much of this belongs in a shared routine somewhere)
  */
- 
+
 static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 {
-	char *argv [3], **envp, *buf, *scratch;
+	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
 	if (!current->fs->root) {
 		return -EAGAIN;
 	}
-	if (!(envp = kcalloc(20, sizeof (char *), GFP_KERNEL))) {
+	if (!(envp = kcalloc(20, sizeof(char *), GFP_KERNEL))) {
 		return -ENOMEM;
 	}
 	if (!(buf = kzalloc(256, GFP_KERNEL))) {
-		kfree (envp);
+		kfree(envp);
 		return -ENOMEM;
 	}
 
 	/* FIXME: if there are actual users of this, it should be integrated into
 	 * the driver core and use the usual infrastructure like sysfs and uevents */
-	argv [0] = "/sbin/pnpbios";
-	argv [1] = "dock";
-	argv [2] = NULL;
+	argv[0] = "/sbin/pnpbios";
+	argv[1] = "dock";
+	argv[2] = NULL;
 
 	/* minimal command environment */
-	envp [i++] = "HOME=/";
-	envp [i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[i++] = "HOME=/";
+	envp[i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 
 #ifdef	DEBUG
 	/* hint that policy agent should enter no-stdout debug mode */
-	envp [i++] = "DEBUG=kernel";
+	envp[i++] = "DEBUG=kernel";
 #endif
 	/* extensible set of named bus-specific parameters,
 	 * supporting multiple driver selection algorithms.
@@ -138,33 +137,32 @@ static int pnp_dock_event(int dock, stru
 	scratch = buf;
 
 	/* action:  add, remove */
-	envp [i++] = scratch;
-	scratch += sprintf (scratch, "ACTION=%s", dock?"add":"remove") + 1;
+	envp[i++] = scratch;
+	scratch += sprintf(scratch, "ACTION=%s", dock ? "add" : "remove") + 1;
 
 	/* Report the ident for the dock */
-	envp [i++] = scratch;
-	scratch += sprintf (scratch, "DOCK=%x/%x/%x",
-		info->location_id, info->serial, info->capabilities);
+	envp[i++] = scratch;
+	scratch += sprintf(scratch, "DOCK=%x/%x/%x",
+			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
-	
-	value = call_usermodehelper (argv [0], argv, envp, UMH_WAIT_EXEC);
-	kfree (buf);
-	kfree (envp);
+
+	value = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	kfree(buf);
+	kfree(envp);
 	return 0;
 }
 
 /*
  * Poll the PnP docking at regular intervals
  */
-static int pnp_dock_thread(void * unused)
+static int pnp_dock_thread(void *unused)
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
 	set_freezable();
-	while (!unloading)
-	{
+	while (!unloading) {
 		int status;
-		
+
 		/*
 		 * Poll every 2 seconds
 		 */
@@ -175,30 +173,29 @@ static int pnp_dock_thread(void * unused
 
 		status = pnp_bios_dock_station_info(&now);
 
-		switch(status)
-		{
+		switch (status) {
 			/*
 			 * No dock to manage
 			 */
-			case PNP_FUNCTION_NOT_SUPPORTED:
-				complete_and_exit(&unload_sem, 0);
-			case PNP_SYSTEM_NOT_DOCKED:
-				d = 0;
-				break;
-			case PNP_SUCCESS:
-				d = 1;
-				break;
-			default:
-				pnpbios_print_status( "pnp_dock_thread", status );
-				continue;
+		case PNP_FUNCTION_NOT_SUPPORTED:
+			complete_and_exit(&unload_sem, 0);
+		case PNP_SYSTEM_NOT_DOCKED:
+			d = 0;
+			break;
+		case PNP_SUCCESS:
+			d = 1;
+			break;
+		default:
+			pnpbios_print_status("pnp_dock_thread", status);
+			continue;
 		}
-		if(d != docked)
-		{
-			if(pnp_dock_event(d, &now)==0)
-			{
+		if (d != docked) {
+			if (pnp_dock_event(d, &now) == 0) {
 				docked = d;
 #if 0
-				printk(KERN_INFO "PnPBIOS: Docking station %stached\n", docked?"at":"de");
+				printk(KERN_INFO
+				       "PnPBIOS: Docking station %stached\n",
+				       docked ? "at" : "de");
 #endif
 			}
 		}
@@ -206,21 +203,22 @@ static int pnp_dock_thread(void * unused
 	complete_and_exit(&unload_sem, 0);
 }
 
-#endif   /* CONFIG_HOTPLUG */
+#endif /* CONFIG_HOTPLUG */
 
-static int pnpbios_get_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
+static int pnpbios_get_resources(struct pnp_dev *dev,
+				 struct pnp_resource_table *res)
 {
 	u8 nodenum = dev->number;
-	struct pnp_bios_node * node;
+	struct pnp_bios_node *node;
 
 	/* just in case */
-	if(!pnpbios_is_dynamic(dev))
+	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
-	if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node)) {
+	if (pnp_bios_get_dev_node(&nodenum, (char)PNPMODE_DYNAMIC, node)) {
 		kfree(node);
 		return -ENODEV;
 	}
@@ -230,10 +228,11 @@ static int pnpbios_get_resources(struct 
 	return 0;
 }
 
-static int pnpbios_set_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
+static int pnpbios_set_resources(struct pnp_dev *dev,
+				 struct pnp_resource_table *res)
 {
 	u8 nodenum = dev->number;
-	struct pnp_bios_node * node;
+	struct pnp_bios_node *node;
 	int ret;
 
 	/* just in case */
@@ -243,11 +242,11 @@ static int pnpbios_set_resources(struct 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
-	if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node)) {
+	if (pnp_bios_get_dev_node(&nodenum, (char)PNPMODE_DYNAMIC, node)) {
 		kfree(node);
 		return -ENODEV;
 	}
-	if(pnpbios_write_resources_to_node(res, node)<0) {
+	if (pnpbios_write_resources_to_node(res, node) < 0) {
 		kfree(node);
 		return -1;
 	}
@@ -258,18 +257,18 @@ static int pnpbios_set_resources(struct 
 	return ret;
 }
 
-static void pnpbios_zero_data_stream(struct pnp_bios_node * node)
+static void pnpbios_zero_data_stream(struct pnp_bios_node *node)
 {
-	unsigned char * p = (char *)node->data;
-	unsigned char * end = (char *)(node->data + node->size);
+	unsigned char *p = (char *)node->data;
+	unsigned char *end = (char *)(node->data + node->size);
 	unsigned int len;
 	int i;
 	while ((char *)p < (char *)end) {
-		if(p[0] & 0x80) { /* large tag */
+		if (p[0] & 0x80) {	/* large tag */
 			len = (p[2] << 8) | p[1];
 			p += 3;
 		} else {
-			if (((p[0]>>3) & 0x0f) == 0x0f)
+			if (((p[0] >> 3) & 0x0f) == 0x0f)
 				return;
 			len = p[0] & 0x07;
 			p += 1;
@@ -278,24 +277,25 @@ static void pnpbios_zero_data_stream(str
 			p[i] = 0;
 		p += len;
 	}
-	printk(KERN_ERR "PnPBIOS: Resource structure did not contain an end tag.\n");
+	printk(KERN_ERR
+	       "PnPBIOS: Resource structure did not contain an end tag.\n");
 }
 
 static int pnpbios_disable_resources(struct pnp_dev *dev)
 {
-	struct pnp_bios_node * node;
+	struct pnp_bios_node *node;
 	u8 nodenum = dev->number;
 	int ret;
 
 	/* just in case */
-	if(dev->flags & PNPBIOS_NO_DISABLE || !pnpbios_is_dynamic(dev))
+	if (dev->flags & PNPBIOS_NO_DISABLE || !pnpbios_is_dynamic(dev))
 		return -EPERM;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 
-	if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node)) {
+	if (pnp_bios_get_dev_node(&nodenum, (char)PNPMODE_DYNAMIC, node)) {
 		kfree(node);
 		return -ENODEV;
 	}
@@ -311,22 +311,22 @@ static int pnpbios_disable_resources(str
 /* PnP Layer support */
 
 struct pnp_protocol pnpbios_protocol = {
-	.name	= "Plug and Play BIOS",
-	.get	= pnpbios_get_resources,
-	.set	= pnpbios_set_resources,
+	.name = "Plug and Play BIOS",
+	.get = pnpbios_get_resources,
+	.set = pnpbios_set_resources,
 	.disable = pnpbios_disable_resources,
 };
 
-static int insert_device(struct pnp_dev *dev, struct pnp_bios_node * node)
+static int insert_device(struct pnp_dev *dev, struct pnp_bios_node *node)
 {
-	struct list_head * pos;
-	struct pnp_dev * pnp_dev;
+	struct list_head *pos;
+	struct pnp_dev *pnp_dev;
 	struct pnp_id *dev_id;
 	char id[8];
 
 	/* check if the device is already added */
 	dev->number = node->handle;
-	list_for_each (pos, &pnpbios_protocol.devices){
+	list_for_each(pos, &pnpbios_protocol.devices) {
 		pnp_dev = list_entry(pos, struct pnp_dev, protocol_list);
 		if (dev->number == pnp_dev->number)
 			return -1;
@@ -336,8 +336,8 @@ static int insert_device(struct pnp_dev 
 	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!dev_id)
 		return -1;
-	pnpid32_to_pnpid(node->eisa_id,id);
-	memcpy(dev_id->id,id,7);
+	pnpid32_to_pnpid(node->eisa_id, id);
+	memcpy(dev_id->id, id, 7);
 	pnp_add_id(dev_id, dev);
 	pnpbios_parse_data_stream(dev, node);
 	dev->active = pnp_is_active(dev);
@@ -375,35 +375,41 @@ static void __init build_devlist(void)
 	if (!node)
 		return;
 
-	for(nodenum=0; nodenum<0xff; ) {
+	for (nodenum = 0; nodenum < 0xff;) {
 		u8 thisnodenum = nodenum;
 		/* eventually we will want to use PNPMODE_STATIC here but for now
 		 * dynamic will help us catch buggy bioses to add to the blacklist.
 		 */
 		if (!pnpbios_dont_use_current_config) {
-			if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node))
+			if (pnp_bios_get_dev_node
+			    (&nodenum, (char)PNPMODE_DYNAMIC, node))
 				break;
 		} else {
-			if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_STATIC, node))
+			if (pnp_bios_get_dev_node
+			    (&nodenum, (char)PNPMODE_STATIC, node))
 				break;
 		}
 		nodes_got++;
-		dev =  kzalloc(sizeof (struct pnp_dev), GFP_KERNEL);
+		dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 		if (!dev)
 			break;
-		if(insert_device(dev,node)<0)
+		if (insert_device(dev, node) < 0)
 			kfree(dev);
 		else
 			devs++;
 		if (nodenum <= thisnodenum) {
-			printk(KERN_ERR "PnPBIOS: build_devlist: Node number 0x%x is out of sequence following node 0x%x. Aborting.\n", (unsigned int)nodenum, (unsigned int)thisnodenum);
+			printk(KERN_ERR
+			       "PnPBIOS: build_devlist: Node number 0x%x is out of sequence following node 0x%x. Aborting.\n",
+			       (unsigned int)nodenum,
+			       (unsigned int)thisnodenum);
 			break;
 		}
 	}
 	kfree(node);
 
-	printk(KERN_INFO "PnPBIOS: %i node%s reported by PnP BIOS; %i recorded by driver\n",
-		nodes_got, nodes_got != 1 ? "s" : "", devs);
+	printk(KERN_INFO
+	       "PnPBIOS: %i node%s reported by PnP BIOS; %i recorded by driver\n",
+	       nodes_got, nodes_got != 1 ? "s" : "", devs);
 }
 
 /*
@@ -412,8 +418,8 @@ static void __init build_devlist(void)
  *
  */
 
-static int pnpbios_disabled; /* = 0 */
-int pnpbios_dont_use_current_config; /* = 0 */
+static int pnpbios_disabled;	/* = 0 */
+int pnpbios_dont_use_current_config;	/* = 0 */
 
 #ifndef MODULE
 static int __init pnpbios_setup(char *str)
@@ -422,9 +428,9 @@ static int __init pnpbios_setup(char *st
 
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "off", 3) == 0)
-			pnpbios_disabled=1;
+			pnpbios_disabled = 1;
 		if (strncmp(str, "on", 2) == 0)
-			pnpbios_disabled=0;
+			pnpbios_disabled = 0;
 		invert = (strncmp(str, "no-", 3) == 0);
 		if (invert)
 			str += 3;
@@ -453,35 +459,41 @@ static int __init pnpbios_probe_system(v
 	printk(KERN_INFO "PnPBIOS: Scanning system for PnP BIOS support...\n");
 
 	/*
- 	 * Search the defined area (0xf0000-0xffff0) for a valid PnP BIOS
+	 * Search the defined area (0xf0000-0xffff0) for a valid PnP BIOS
 	 * structure and, if one is found, sets up the selectors and
 	 * entry points
 	 */
-	for (check = (union pnp_bios_install_struct *) __va(0xf0000);
-	     check < (union pnp_bios_install_struct *) __va(0xffff0);
+	for (check = (union pnp_bios_install_struct *)__va(0xf0000);
+	     check < (union pnp_bios_install_struct *)__va(0xffff0);
 	     check = (void *)check + 16) {
 		if (check->fields.signature != PNP_SIGNATURE)
 			continue;
-		printk(KERN_INFO "PnPBIOS: Found PnP BIOS installation structure at 0x%p\n", check);
+		printk(KERN_INFO
+		       "PnPBIOS: Found PnP BIOS installation structure at 0x%p\n",
+		       check);
 		length = check->fields.length;
 		if (!length) {
-			printk(KERN_ERR "PnPBIOS: installation structure is invalid, skipping\n");
+			printk(KERN_ERR
+			       "PnPBIOS: installation structure is invalid, skipping\n");
 			continue;
 		}
 		for (sum = 0, i = 0; i < length; i++)
 			sum += check->chars[i];
 		if (sum) {
-			printk(KERN_ERR "PnPBIOS: installation structure is corrupted, skipping\n");
+			printk(KERN_ERR
+			       "PnPBIOS: installation structure is corrupted, skipping\n");
 			continue;
 		}
 		if (check->fields.version < 0x10) {
-			printk(KERN_WARNING "PnPBIOS: PnP BIOS version %d.%d is not supported\n",
+			printk(KERN_WARNING
+			       "PnPBIOS: PnP BIOS version %d.%d is not supported\n",
 			       check->fields.version >> 4,
 			       check->fields.version & 15);
 			continue;
 		}
-		printk(KERN_INFO "PnPBIOS: PnP BIOS version %d.%d, entry 0x%x:0x%x, dseg 0x%x\n",
-                       check->fields.version >> 4, check->fields.version & 15,
+		printk(KERN_INFO
+		       "PnPBIOS: PnP BIOS version %d.%d, entry 0x%x:0x%x, dseg 0x%x\n",
+		       check->fields.version >> 4, check->fields.version & 15,
 		       check->fields.pm16cseg, check->fields.pm16offset,
 		       check->fields.pm16dseg);
 		pnp_bios_install = check;
@@ -499,25 +511,25 @@ static int __init exploding_pnp_bios(str
 }
 
 static struct dmi_system_id pnpbios_dmi_table[] __initdata = {
-	{	/* PnPBIOS GPF on boot */
-		.callback = exploding_pnp_bios,
-		.ident = "Higraded P14H",
-		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-			DMI_MATCH(DMI_BIOS_VERSION, "07.00T"),
-			DMI_MATCH(DMI_SYS_VENDOR, "Higraded"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "P14H"),
-		},
-	},
-	{	/* PnPBIOS GPF on boot */
-		.callback = exploding_pnp_bios,
-		.ident = "ASUS P4P800",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "P4P800"),
-		},
-	},
-	{ }
+	{			/* PnPBIOS GPF on boot */
+	 .callback = exploding_pnp_bios,
+	 .ident = "Higraded P14H",
+	 .matches = {
+		     DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+		     DMI_MATCH(DMI_BIOS_VERSION, "07.00T"),
+		     DMI_MATCH(DMI_SYS_VENDOR, "Higraded"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "P14H"),
+		     },
+	 },
+	{			/* PnPBIOS GPF on boot */
+	 .callback = exploding_pnp_bios,
+	 .ident = "ASUS P4P800",
+	 .matches = {
+		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
+		     DMI_MATCH(DMI_BOARD_NAME, "P4P800"),
+		     },
+	 },
+	{}
 };
 
 static int __init pnpbios_init(void)
@@ -533,7 +545,6 @@ static int __init pnpbios_init(void)
 		printk(KERN_INFO "PnPBIOS: Disabled\n");
 		return -ENODEV;
 	}
-
 #ifdef CONFIG_PNPACPI
 	if (!acpi_disabled && !pnpacpi_disabled) {
 		pnpbios_disabled = 1;
@@ -552,14 +563,16 @@ static int __init pnpbios_init(void)
 	/* read the node info */
 	ret = pnp_bios_dev_node_info(&node_info);
 	if (ret) {
-		printk(KERN_ERR "PnPBIOS: Unable to get node info.  Aborting.\n");
+		printk(KERN_ERR
+		       "PnPBIOS: Unable to get node info.  Aborting.\n");
 		return ret;
 	}
 
 	/* register with the pnp layer */
 	ret = pnp_register_protocol(&pnpbios_protocol);
 	if (ret) {
-		printk(KERN_ERR "PnPBIOS: Unable to register driver.  Aborting.\n");
+		printk(KERN_ERR
+		       "PnPBIOS: Unable to register driver.  Aborting.\n");
 		return ret;
 	}
 
diff -puN drivers/pnp/pnpbios/proc.c~pnp-lindent-all-source-files drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpbios/proc.c
@@ -37,42 +37,37 @@ static struct proc_dir_entry *proc_pnp =
 static struct proc_dir_entry *proc_pnp_boot = NULL;
 
 static int proc_read_pnpconfig(char *buf, char **start, off_t pos,
-                               int count, int *eof, void *data)
+			       int count, int *eof, void *data)
 {
 	struct pnp_isa_config_struc pnps;
 
 	if (pnp_bios_isapnp_config(&pnps))
 		return -EIO;
 	return snprintf(buf, count,
-		"structure_revision %d\n"
-		"number_of_CSNs %d\n"
-		"ISA_read_data_port 0x%x\n",
-		pnps.revision,
-		pnps.no_csns,
-		pnps.isa_rd_data_port
-	);
+			"structure_revision %d\n"
+			"number_of_CSNs %d\n"
+			"ISA_read_data_port 0x%x\n",
+			pnps.revision, pnps.no_csns, pnps.isa_rd_data_port);
 }
 
 static int proc_read_escdinfo(char *buf, char **start, off_t pos,
-                              int count, int *eof, void *data)
+			      int count, int *eof, void *data)
 {
 	struct escd_info_struc escd;
 
 	if (pnp_bios_escd_info(&escd))
 		return -EIO;
 	return snprintf(buf, count,
-		"min_ESCD_write_size %d\n"
-		"ESCD_size %d\n"
-		"NVRAM_base 0x%x\n",
-		escd.min_escd_write_size,
-		escd.escd_size,
-		escd.nv_storage_base
-	);
+			"min_ESCD_write_size %d\n"
+			"ESCD_size %d\n"
+			"NVRAM_base 0x%x\n",
+			escd.min_escd_write_size,
+			escd.escd_size, escd.nv_storage_base);
 }
 
 #define MAX_SANE_ESCD_SIZE (32*1024)
 static int proc_read_escd(char *buf, char **start, off_t pos,
-                          int count, int *eof, void *data)
+			  int count, int *eof, void *data)
 {
 	struct escd_info_struc escd;
 	char *tmpbuf;
@@ -83,30 +78,36 @@ static int proc_read_escd(char *buf, cha
 
 	/* sanity check */
 	if (escd.escd_size > MAX_SANE_ESCD_SIZE) {
-		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by BIOS escd_info call is too great\n");
+		printk(KERN_ERR
+		       "PnPBIOS: proc_read_escd: ESCD size reported by BIOS escd_info call is too great\n");
 		return -EFBIG;
 	}
 
 	tmpbuf = kzalloc(escd.escd_size, GFP_KERNEL);
-	if (!tmpbuf) return -ENOMEM;
+	if (!tmpbuf)
+		return -ENOMEM;
 
 	if (pnp_bios_read_escd(tmpbuf, escd.nv_storage_base)) {
 		kfree(tmpbuf);
 		return -EIO;
 	}
 
-	escd_size = (unsigned char)(tmpbuf[0]) + (unsigned char)(tmpbuf[1])*256;
+	escd_size =
+	    (unsigned char)(tmpbuf[0]) + (unsigned char)(tmpbuf[1]) * 256;
 
 	/* sanity check */
 	if (escd_size > MAX_SANE_ESCD_SIZE) {
-		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by BIOS read_escd call is too great\n");
+		printk(KERN_ERR
+		       "PnPBIOS: proc_read_escd: ESCD size reported by BIOS read_escd call is too great\n");
 		return -EFBIG;
 	}
 
 	escd_left_to_read = escd_size - pos;
-	if (escd_left_to_read < 0) escd_left_to_read = 0;
-	if (escd_left_to_read == 0) *eof = 1;
-	n = min(count,escd_left_to_read);
+	if (escd_left_to_read < 0)
+		escd_left_to_read = 0;
+	if (escd_left_to_read == 0)
+		*eof = 1;
+	n = min(count, escd_left_to_read);
 	memcpy(buf, tmpbuf + pos, n);
 	kfree(tmpbuf);
 	*start = buf;
@@ -114,17 +115,17 @@ static int proc_read_escd(char *buf, cha
 }
 
 static int proc_read_legacyres(char *buf, char **start, off_t pos,
-                               int count, int *eof, void *data)
+			       int count, int *eof, void *data)
 {
 	/* Assume that the following won't overflow the buffer */
-	if (pnp_bios_get_stat_res(buf)) 
+	if (pnp_bios_get_stat_res(buf))
 		return -EIO;
 
-	return count;  // FIXME: Return actual length
+	return count;		// FIXME: Return actual length
 }
 
 static int proc_read_devices(char *buf, char **start, off_t pos,
-                             int count, int *eof, void *data)
+			     int count, int *eof, void *data)
 {
 	struct pnp_bios_node *node;
 	u8 nodenum;
@@ -134,9 +135,10 @@ static int proc_read_devices(char *buf, 
 		return 0;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
-	if (!node) return -ENOMEM;
+	if (!node)
+		return -ENOMEM;
 
-	for (nodenum=pos; nodenum<0xff; ) {
+	for (nodenum = pos; nodenum < 0xff;) {
 		u8 thisnodenum = nodenum;
 		/* 26 = the number of characters per line sprintf'ed */
 		if ((p - buf + 26) > count)
@@ -148,7 +150,11 @@ static int proc_read_devices(char *buf, 
 			     node->type_code[0], node->type_code[1],
 			     node->type_code[2], node->flags);
 		if (nodenum <= thisnodenum) {
-			printk(KERN_ERR "%s Node number 0x%x is out of sequence following node 0x%x. Aborting.\n", "PnPBIOS: proc_read_devices:", (unsigned int)nodenum, (unsigned int)thisnodenum);
+			printk(KERN_ERR
+			       "%s Node number 0x%x is out of sequence following node 0x%x. Aborting.\n",
+			       "PnPBIOS: proc_read_devices:",
+			       (unsigned int)nodenum,
+			       (unsigned int)thisnodenum);
 			*eof = 1;
 			break;
 		}
@@ -156,12 +162,12 @@ static int proc_read_devices(char *buf, 
 	kfree(node);
 	if (nodenum == 0xff)
 		*eof = 1;
-	*start = (char *)((off_t)nodenum - pos);
+	*start = (char *)((off_t) nodenum - pos);
 	return p - buf;
 }
 
 static int proc_read_node(char *buf, char **start, off_t pos,
-                          int count, int *eof, void *data)
+			  int count, int *eof, void *data)
 {
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
@@ -169,7 +175,8 @@ static int proc_read_node(char *buf, cha
 	int len;
 
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
-	if (!node) return -ENOMEM;
+	if (!node)
+		return -ENOMEM;
 	if (pnp_bios_get_dev_node(&nodenum, boot, node)) {
 		kfree(node);
 		return -EIO;
@@ -180,8 +187,8 @@ static int proc_read_node(char *buf, cha
 	return len;
 }
 
-static int proc_write_node(struct file *file, const char __user *buf,
-                           unsigned long count, void *data)
+static int proc_write_node(struct file *file, const char __user * buf,
+			   unsigned long count, void *data)
 {
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
@@ -208,12 +215,12 @@ static int proc_write_node(struct file *
 		goto out;
 	}
 	ret = count;
-out:
+      out:
 	kfree(node);
 	return ret;
 }
 
-int pnpbios_interface_attach_device(struct pnp_bios_node * node)
+int pnpbios_interface_attach_device(struct pnp_bios_node *node)
 {
 	char name[3];
 	struct proc_dir_entry *ent;
@@ -222,7 +229,7 @@ int pnpbios_interface_attach_device(stru
 
 	if (!proc_pnp)
 		return -EIO;
-	if ( !pnpbios_dont_use_current_config ) {
+	if (!pnpbios_dont_use_current_config) {
 		ent = create_proc_entry(name, 0, proc_pnp);
 		if (ent) {
 			ent->read_proc = proc_read_node;
@@ -237,7 +244,7 @@ int pnpbios_interface_attach_device(stru
 	if (ent) {
 		ent->read_proc = proc_read_node;
 		ent->write_proc = proc_write_node;
-		ent->data = (void *)(long)(node->handle+0x100);
+		ent->data = (void *)(long)(node->handle + 0x100);
 		return 0;
 	}
 
@@ -249,7 +256,7 @@ int pnpbios_interface_attach_device(stru
  * work and the pnpbios_dont_use_current_config flag
  * should already have been set to the appropriate value
  */
-int __init pnpbios_proc_init( void )
+int __init pnpbios_proc_init(void)
 {
 	proc_pnp = proc_mkdir("pnp", proc_bus);
 	if (!proc_pnp)
@@ -258,10 +265,13 @@ int __init pnpbios_proc_init( void )
 	if (!proc_pnp_boot)
 		return -EIO;
 	create_proc_read_entry("devices", 0, proc_pnp, proc_read_devices, NULL);
-	create_proc_read_entry("configuration_info", 0, proc_pnp, proc_read_pnpconfig, NULL);
-	create_proc_read_entry("escd_info", 0, proc_pnp, proc_read_escdinfo, NULL);
+	create_proc_read_entry("configuration_info", 0, proc_pnp,
+			       proc_read_pnpconfig, NULL);
+	create_proc_read_entry("escd_info", 0, proc_pnp, proc_read_escdinfo,
+			       NULL);
 	create_proc_read_entry("escd", S_IRUSR, proc_pnp, proc_read_escd, NULL);
-	create_proc_read_entry("legacy_device_resources", 0, proc_pnp, proc_read_legacyres, NULL);
+	create_proc_read_entry("legacy_device_resources", 0, proc_pnp,
+			       proc_read_legacyres, NULL);
 
 	return 0;
 }
@@ -274,9 +284,9 @@ void __exit pnpbios_proc_exit(void)
 	if (!proc_pnp)
 		return;
 
-	for (i=0; i<0xff; i++) {
+	for (i = 0; i < 0xff; i++) {
 		sprintf(name, "%02x", i);
-		if ( !pnpbios_dont_use_current_config )
+		if (!pnpbios_dont_use_current_config)
 			remove_proc_entry(name, proc_pnp);
 		remove_proc_entry(name, proc_pnp_boot);
 	}
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-lindent-all-source-files drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -12,7 +12,9 @@
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
 #else
-inline void pcibios_penalize_isa_irq(int irq, int active) {}
+inline void pcibios_penalize_isa_irq(int irq, int active)
+{
+}
 #endif /* CONFIG_PCI */
 
 #include "pnpbios.h"
@@ -53,74 +55,85 @@ inline void pcibios_penalize_isa_irq(int
  */
 
 static void
-pnpbios_parse_allocated_irqresource(struct pnp_resource_table * res, int irq)
+pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res, int irq)
 {
 	int i = 0;
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) && i < PNP_MAX_IRQ) i++;
+	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
+	       && i < PNP_MAX_IRQ)
+		i++;
 	if (i < PNP_MAX_IRQ) {
-		res->irq_resource[i].flags = IORESOURCE_IRQ;  // Also clears _UNSET flag
+		res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 		if (irq == -1) {
 			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
 		res->irq_resource[i].start =
-		res->irq_resource[i].end = (unsigned long) irq;
+		    res->irq_resource[i].end = (unsigned long)irq;
 		pcibios_penalize_isa_irq(irq, 1);
 	}
 }
 
 static void
-pnpbios_parse_allocated_dmaresource(struct pnp_resource_table * res, int dma)
+pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res, int dma)
 {
 	int i = 0;
 	while (i < PNP_MAX_DMA &&
-			!(res->dma_resource[i].flags & IORESOURCE_UNSET))
+	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
 		i++;
 	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;  // Also clears _UNSET flag
+		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
 		if (dma == -1) {
 			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
 		res->dma_resource[i].start =
-		res->dma_resource[i].end = (unsigned long) dma;
+		    res->dma_resource[i].end = (unsigned long)dma;
 	}
 }
 
 static void
-pnpbios_parse_allocated_ioresource(struct pnp_resource_table * res, int io, int len)
+pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res, int io,
+				   int len)
 {
 	int i = 0;
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) && i < PNP_MAX_PORT) i++;
+	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
+	       && i < PNP_MAX_PORT)
+		i++;
 	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;  // Also clears _UNSET flag
-		if (len <= 0 || (io + len -1) >= 0x10003) {
+		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
+		if (len <= 0 || (io + len - 1) >= 0x10003) {
 			res->port_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->port_resource[i].start = (unsigned long) io;
+		res->port_resource[i].start = (unsigned long)io;
 		res->port_resource[i].end = (unsigned long)(io + len - 1);
 	}
 }
 
 static void
-pnpbios_parse_allocated_memresource(struct pnp_resource_table * res, int mem, int len)
+pnpbios_parse_allocated_memresource(struct pnp_resource_table *res, int mem,
+				    int len)
 {
 	int i = 0;
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) && i < PNP_MAX_MEM) i++;
+	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
+	       && i < PNP_MAX_MEM)
+		i++;
 	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;  // Also clears _UNSET flag
+		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
 		if (len <= 0) {
 			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->mem_resource[i].start = (unsigned long) mem;
+		res->mem_resource[i].start = (unsigned long)mem;
 		res->mem_resource[i].end = (unsigned long)(mem + len - 1);
 	}
 }
 
-static unsigned char *
-pnpbios_parse_allocated_resource_data(unsigned char * p, unsigned char * end, struct pnp_resource_table * res)
+static unsigned char *pnpbios_parse_allocated_resource_data(unsigned char *p,
+							    unsigned char *end,
+							    struct
+							    pnp_resource_table
+							    *res)
 {
 	unsigned int len, tag;
 	int io, size, mask, i;
@@ -134,12 +147,12 @@ pnpbios_parse_allocated_resource_data(un
 	while ((char *)p < (char *)end) {
 
 		/* determine the type of tag */
-		if (p[0] & LARGE_TAG) { /* large tag */
+		if (p[0] & LARGE_TAG) {	/* large tag */
 			len = (p[2] << 8) | p[1];
 			tag = p[0];
-		} else { /* small tag */
+		} else {	/* small tag */
 			len = p[0] & 0x07;
-			tag = ((p[0]>>3) & 0x0f);
+			tag = ((p[0] >> 3) & 0x0f);
 		}
 
 		switch (tag) {
@@ -147,8 +160,8 @@ pnpbios_parse_allocated_resource_data(un
 		case LARGE_TAG_MEM:
 			if (len != 9)
 				goto len_err;
-			io = *(short *) &p[4];
-			size = *(short *) &p[10];
+			io = *(short *)&p[4];
+			size = *(short *)&p[10];
 			pnpbios_parse_allocated_memresource(res, io, size);
 			break;
 
@@ -163,16 +176,16 @@ pnpbios_parse_allocated_resource_data(un
 		case LARGE_TAG_MEM32:
 			if (len != 17)
 				goto len_err;
-			io = *(int *) &p[4];
-			size = *(int *) &p[16];
+			io = *(int *)&p[4];
+			size = *(int *)&p[16];
 			pnpbios_parse_allocated_memresource(res, io, size);
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
 			if (len != 9)
 				goto len_err;
-			io = *(int *) &p[4];
-			size = *(int *) &p[8];
+			io = *(int *)&p[4];
+			size = *(int *)&p[8];
 			pnpbios_parse_allocated_memresource(res, io, size);
 			break;
 
@@ -180,9 +193,10 @@ pnpbios_parse_allocated_resource_data(un
 			if (len < 2 || len > 3)
 				goto len_err;
 			io = -1;
-			mask= p[1] + p[2]*256;
-			for (i=0;i<16;i++, mask=mask>>1)
-				if(mask & 0x01) io=i;
+			mask = p[1] + p[2] * 256;
+			for (i = 0; i < 16; i++, mask = mask >> 1)
+				if (mask & 0x01)
+					io = i;
 			pnpbios_parse_allocated_irqresource(res, io);
 			break;
 
@@ -191,15 +205,16 @@ pnpbios_parse_allocated_resource_data(un
 				goto len_err;
 			io = -1;
 			mask = p[1];
-			for (i=0;i<8;i++, mask = mask>>1)
-				if(mask & 0x01) io=i;
+			for (i = 0; i < 8; i++, mask = mask >> 1)
+				if (mask & 0x01)
+					io = i;
 			pnpbios_parse_allocated_dmaresource(res, io);
 			break;
 
 		case SMALL_TAG_PORT:
 			if (len != 7)
 				goto len_err;
-			io = p[2] + p[3] *256;
+			io = p[2] + p[3] * 256;
 			size = p[7];
 			pnpbios_parse_allocated_ioresource(res, io, size);
 			break;
@@ -218,12 +233,14 @@ pnpbios_parse_allocated_resource_data(un
 
 		case SMALL_TAG_END:
 			p = p + 2;
-        		return (unsigned char *)p;
+			return (unsigned char *)p;
 			break;
 
-		default: /* an unkown tag */
-			len_err:
-			printk(KERN_ERR "PnPBIOS: Unknown tag '0x%x', length '%d'.\n", tag, len);
+		default:	/* an unkown tag */
+		      len_err:
+			printk(KERN_ERR
+			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
+			       tag, len);
 			break;
 		}
 
@@ -234,12 +251,12 @@ pnpbios_parse_allocated_resource_data(un
 			p += len + 1;
 	}
 
-	printk(KERN_ERR "PnPBIOS: Resource structure does not contain an end tag.\n");
+	printk(KERN_ERR
+	       "PnPBIOS: Resource structure does not contain an end tag.\n");
 
 	return NULL;
 }
 
-
 /*
  * Resource Configuration Options
  */
@@ -247,7 +264,7 @@ pnpbios_parse_allocated_resource_data(un
 static void
 pnpbios_parse_mem_option(unsigned char *p, int size, struct pnp_option *option)
 {
-	struct pnp_mem * mem;
+	struct pnp_mem *mem;
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -256,14 +273,15 @@ pnpbios_parse_mem_option(unsigned char *
 	mem->align = (p[9] << 8) | p[8];
 	mem->size = ((p[11] << 8) | p[10]) << 8;
 	mem->flags = p[3];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 	return;
 }
 
 static void
-pnpbios_parse_mem32_option(unsigned char *p, int size, struct pnp_option *option)
+pnpbios_parse_mem32_option(unsigned char *p, int size,
+			   struct pnp_option *option)
 {
-	struct pnp_mem * mem;
+	struct pnp_mem *mem;
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -272,14 +290,15 @@ pnpbios_parse_mem32_option(unsigned char
 	mem->align = (p[15] << 24) | (p[14] << 16) | (p[13] << 8) | p[12];
 	mem->size = (p[19] << 24) | (p[18] << 16) | (p[17] << 8) | p[16];
 	mem->flags = p[3];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 	return;
 }
 
 static void
-pnpbios_parse_fixed_mem32_option(unsigned char *p, int size, struct pnp_option *option)
+pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
+				 struct pnp_option *option)
 {
-	struct pnp_mem * mem;
+	struct pnp_mem *mem;
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -287,14 +306,14 @@ pnpbios_parse_fixed_mem32_option(unsigne
 	mem->size = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
 	mem->align = 0;
 	mem->flags = p[3];
-	pnp_register_mem_resource(option,mem);
+	pnp_register_mem_resource(option, mem);
 	return;
 }
 
 static void
 pnpbios_parse_irq_option(unsigned char *p, int size, struct pnp_option *option)
 {
-	struct pnp_irq * irq;
+	struct pnp_irq *irq;
 	unsigned long bits;
 
 	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
@@ -306,27 +325,27 @@ pnpbios_parse_irq_option(unsigned char *
 		irq->flags = p[3];
 	else
 		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
-	pnp_register_irq_resource(option,irq);
+	pnp_register_irq_resource(option, irq);
 	return;
 }
 
 static void
 pnpbios_parse_dma_option(unsigned char *p, int size, struct pnp_option *option)
 {
-	struct pnp_dma * dma;
+	struct pnp_dma *dma;
 	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
 	if (!dma)
 		return;
 	dma->map = p[1];
 	dma->flags = p[2];
-	pnp_register_dma_resource(option,dma);
+	pnp_register_dma_resource(option, dma);
 	return;
 }
 
 static void
 pnpbios_parse_port_option(unsigned char *p, int size, struct pnp_option *option)
 {
-	struct pnp_port * port;
+	struct pnp_port *port;
 	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
@@ -335,14 +354,15 @@ pnpbios_parse_port_option(unsigned char 
 	port->align = p[6];
 	port->size = p[7];
 	port->flags = p[1] ? PNP_PORT_FLAG_16BITADDR : 0;
-	pnp_register_port_resource(option,port);
+	pnp_register_port_resource(option, port);
 	return;
 }
 
 static void
-pnpbios_parse_fixed_port_option(unsigned char *p, int size, struct pnp_option *option)
+pnpbios_parse_fixed_port_option(unsigned char *p, int size,
+				struct pnp_option *option)
 {
-	struct pnp_port * port;
+	struct pnp_port *port;
 	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
@@ -350,12 +370,13 @@ pnpbios_parse_fixed_port_option(unsigned
 	port->size = p[3];
 	port->align = 0;
 	port->flags = PNP_PORT_FLAG_FIXED;
-	pnp_register_port_resource(option,port);
+	pnp_register_port_resource(option, port);
 	return;
 }
 
-static unsigned char *
-pnpbios_parse_resource_option_data(unsigned char * p, unsigned char * end, struct pnp_dev *dev)
+static unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
+							 unsigned char *end,
+							 struct pnp_dev *dev)
 {
 	unsigned int len, tag;
 	int priority = 0;
@@ -371,12 +392,12 @@ pnpbios_parse_resource_option_data(unsig
 	while ((char *)p < (char *)end) {
 
 		/* determine the type of tag */
-		if (p[0] & LARGE_TAG) { /* large tag */
+		if (p[0] & LARGE_TAG) {	/* large tag */
 			len = (p[2] << 8) | p[1];
 			tag = p[0];
-		} else { /* small tag */
+		} else {	/* small tag */
 			len = p[0] & 0x07;
-			tag = ((p[0]>>3) & 0x0f);
+			tag = ((p[0] >> 3) & 0x0f);
 		}
 
 		switch (tag) {
@@ -442,16 +463,19 @@ pnpbios_parse_resource_option_data(unsig
 			if (len != 0)
 				goto len_err;
 			if (option_independent == option)
-				printk(KERN_WARNING "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
+				printk(KERN_WARNING
+				       "PnPBIOS: Missing SMALL_TAG_STARTDEP tag\n");
 			option = option_independent;
 			break;
 
 		case SMALL_TAG_END:
-        		return p + 2;
+			return p + 2;
 
-		default: /* an unkown tag */
-			len_err:
-			printk(KERN_ERR "PnPBIOS: Unknown tag '0x%x', length '%d'.\n", tag, len);
+		default:	/* an unkown tag */
+		      len_err:
+			printk(KERN_ERR
+			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
+			       tag, len);
 			break;
 		}
 
@@ -462,12 +486,12 @@ pnpbios_parse_resource_option_data(unsig
 			p += len + 1;
 	}
 
-	printk(KERN_ERR "PnPBIOS: Resource structure does not contain an end tag.\n");
+	printk(KERN_ERR
+	       "PnPBIOS: Resource structure does not contain an end tag.\n");
 
 	return NULL;
 }
 
-
 /*
  * Compatible Device IDs
  */
@@ -483,7 +507,7 @@ void pnpid32_to_pnpid(u32 id, char *str)
 	id = be32_to_cpu(id);
 	str[0] = CHAR(id, 26);
 	str[1] = CHAR(id, 21);
-	str[2] = CHAR(id,16);
+	str[2] = CHAR(id, 16);
 	str[3] = HEX(id, 12);
 	str[4] = HEX(id, 8);
 	str[5] = HEX(id, 4);
@@ -492,12 +516,14 @@ void pnpid32_to_pnpid(u32 id, char *str)
 
 	return;
 }
+
 //
 #undef CHAR
 #undef HEX
 
-static unsigned char *
-pnpbios_parse_compatible_ids(unsigned char *p, unsigned char *end, struct pnp_dev *dev)
+static unsigned char *pnpbios_parse_compatible_ids(unsigned char *p,
+						   unsigned char *end,
+						   struct pnp_dev *dev)
 {
 	int len, tag;
 	char id[8];
@@ -509,40 +535,45 @@ pnpbios_parse_compatible_ids(unsigned ch
 	while ((char *)p < (char *)end) {
 
 		/* determine the type of tag */
-		if (p[0] & LARGE_TAG) { /* large tag */
+		if (p[0] & LARGE_TAG) {	/* large tag */
 			len = (p[2] << 8) | p[1];
 			tag = p[0];
-		} else { /* small tag */
+		} else {	/* small tag */
 			len = p[0] & 0x07;
-			tag = ((p[0]>>3) & 0x0f);
+			tag = ((p[0] >> 3) & 0x0f);
 		}
 
 		switch (tag) {
 
 		case LARGE_TAG_ANSISTR:
-			strncpy(dev->name, p + 3, len >= PNP_NAME_LEN ? PNP_NAME_LEN - 2 : len);
-			dev->name[len >= PNP_NAME_LEN ? PNP_NAME_LEN - 1 : len] = '\0';
+			strncpy(dev->name, p + 3,
+				len >= PNP_NAME_LEN ? PNP_NAME_LEN - 2 : len);
+			dev->name[len >=
+				  PNP_NAME_LEN ? PNP_NAME_LEN - 1 : len] = '\0';
 			break;
 
-		case SMALL_TAG_COMPATDEVID: /* compatible ID */
+		case SMALL_TAG_COMPATDEVID:	/* compatible ID */
 			if (len != 4)
 				goto len_err;
-			dev_id =  kzalloc(sizeof (struct pnp_id), GFP_KERNEL);
+			dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 			if (!dev_id)
 				return NULL;
-			pnpid32_to_pnpid(p[1] | p[2] << 8 | p[3] << 16 | p[4] << 24,id);
+			pnpid32_to_pnpid(p[1] | p[2] << 8 | p[3] << 16 | p[4] <<
+					 24, id);
 			memcpy(&dev_id->id, id, 7);
 			pnp_add_id(dev_id, dev);
 			break;
 
 		case SMALL_TAG_END:
 			p = p + 2;
-        		return (unsigned char *)p;
+			return (unsigned char *)p;
 			break;
 
-		default: /* an unkown tag */
-			len_err:
-			printk(KERN_ERR "PnPBIOS: Unknown tag '0x%x', length '%d'.\n", tag, len);
+		default:	/* an unkown tag */
+		      len_err:
+			printk(KERN_ERR
+			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
+			       tag, len);
 			break;
 		}
 
@@ -553,17 +584,17 @@ pnpbios_parse_compatible_ids(unsigned ch
 			p += len + 1;
 	}
 
-	printk(KERN_ERR "PnPBIOS: Resource structure does not contain an end tag.\n");
+	printk(KERN_ERR
+	       "PnPBIOS: Resource structure does not contain an end tag.\n");
 
 	return NULL;
 }
 
-
 /*
  * Allocated Resource Encoding
  */
 
-static void pnpbios_encode_mem(unsigned char *p, struct resource * res)
+static void pnpbios_encode_mem(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -576,7 +607,7 @@ static void pnpbios_encode_mem(unsigned 
 	return;
 }
 
-static void pnpbios_encode_mem32(unsigned char *p, struct resource * res)
+static void pnpbios_encode_mem32(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -595,8 +626,9 @@ static void pnpbios_encode_mem32(unsigne
 	return;
 }
 
-static void pnpbios_encode_fixed_mem32(unsigned char *p, struct resource * res)
-{	unsigned long base = res->start;
+static void pnpbios_encode_fixed_mem32(unsigned char *p, struct resource *res)
+{
+	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
@@ -609,7 +641,7 @@ static void pnpbios_encode_fixed_mem32(u
 	return;
 }
 
-static void pnpbios_encode_irq(unsigned char *p, struct resource * res)
+static void pnpbios_encode_irq(unsigned char *p, struct resource *res)
 {
 	unsigned long map = 0;
 	map = 1 << res->start;
@@ -618,7 +650,7 @@ static void pnpbios_encode_irq(unsigned 
 	return;
 }
 
-static void pnpbios_encode_dma(unsigned char *p, struct resource * res)
+static void pnpbios_encode_dma(unsigned char *p, struct resource *res)
 {
 	unsigned long map = 0;
 	map = 1 << res->start;
@@ -626,7 +658,7 @@ static void pnpbios_encode_dma(unsigned 
 	return;
 }
 
-static void pnpbios_encode_port(unsigned char *p, struct resource * res)
+static void pnpbios_encode_port(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -638,7 +670,7 @@ static void pnpbios_encode_port(unsigned
 	return;
 }
 
-static void pnpbios_encode_fixed_port(unsigned char *p, struct resource * res)
+static void pnpbios_encode_fixed_port(unsigned char *p, struct resource *res)
 {
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
@@ -648,8 +680,11 @@ static void pnpbios_encode_fixed_port(un
 	return;
 }
 
-static unsigned char *
-pnpbios_encode_allocated_resource_data(unsigned char * p, unsigned char * end, struct pnp_resource_table * res)
+static unsigned char *pnpbios_encode_allocated_resource_data(unsigned char *p,
+							     unsigned char *end,
+							     struct
+							     pnp_resource_table
+							     *res)
 {
 	unsigned int len, tag;
 	int port = 0, irq = 0, dma = 0, mem = 0;
@@ -660,12 +695,12 @@ pnpbios_encode_allocated_resource_data(u
 	while ((char *)p < (char *)end) {
 
 		/* determine the type of tag */
-		if (p[0] & LARGE_TAG) { /* large tag */
+		if (p[0] & LARGE_TAG) {	/* large tag */
 			len = (p[2] << 8) | p[1];
 			tag = p[0];
-		} else { /* small tag */
+		} else {	/* small tag */
 			len = p[0] & 0x07;
-			tag = ((p[0]>>3) & 0x0f);
+			tag = ((p[0] >> 3) & 0x0f);
 		}
 
 		switch (tag) {
@@ -725,12 +760,14 @@ pnpbios_encode_allocated_resource_data(u
 
 		case SMALL_TAG_END:
 			p = p + 2;
-        		return (unsigned char *)p;
+			return (unsigned char *)p;
 			break;
 
-		default: /* an unkown tag */
-			len_err:
-			printk(KERN_ERR "PnPBIOS: Unknown tag '0x%x', length '%d'.\n", tag, len);
+		default:	/* an unkown tag */
+		      len_err:
+			printk(KERN_ERR
+			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
+			       tag, len);
 			break;
 		}
 
@@ -741,28 +778,27 @@ pnpbios_encode_allocated_resource_data(u
 			p += len + 1;
 	}
 
-	printk(KERN_ERR "PnPBIOS: Resource structure does not contain an end tag.\n");
+	printk(KERN_ERR
+	       "PnPBIOS: Resource structure does not contain an end tag.\n");
 
 	return NULL;
 }
 
-
 /*
  * Core Parsing Functions
  */
 
-int
-pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node * node)
+int pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)
 {
-	unsigned char * p = (char *)node->data;
-	unsigned char * end = (char *)(node->data + node->size);
-	p = pnpbios_parse_allocated_resource_data(p,end,&dev->res);
+	unsigned char *p = (char *)node->data;
+	unsigned char *end = (char *)(node->data + node->size);
+	p = pnpbios_parse_allocated_resource_data(p, end, &dev->res);
 	if (!p)
 		return -EIO;
-	p = pnpbios_parse_resource_option_data(p,end,dev);
+	p = pnpbios_parse_resource_option_data(p, end, dev);
 	if (!p)
 		return -EIO;
-	p = pnpbios_parse_compatible_ids(p,end,dev);
+	p = pnpbios_parse_compatible_ids(p, end, dev);
 	if (!p)
 		return -EIO;
 	return 0;
@@ -770,11 +806,11 @@ pnpbios_parse_data_stream(struct pnp_dev
 
 int
 pnpbios_read_resources_from_node(struct pnp_resource_table *res,
-				 struct pnp_bios_node * node)
+				 struct pnp_bios_node *node)
 {
-	unsigned char * p = (char *)node->data;
-	unsigned char * end = (char *)(node->data + node->size);
-	p = pnpbios_parse_allocated_resource_data(p,end,res);
+	unsigned char *p = (char *)node->data;
+	unsigned char *end = (char *)(node->data + node->size);
+	p = pnpbios_parse_allocated_resource_data(p, end, res);
 	if (!p)
 		return -EIO;
 	return 0;
@@ -782,11 +818,11 @@ pnpbios_read_resources_from_node(struct 
 
 int
 pnpbios_write_resources_to_node(struct pnp_resource_table *res,
-				struct pnp_bios_node * node)
+				struct pnp_bios_node *node)
 {
-	unsigned char * p = (char *)node->data;
-	unsigned char * end = (char *)(node->data + node->size);
-	p = pnpbios_encode_allocated_resource_data(p,end,res);
+	unsigned char *p = (char *)node->data;
+	unsigned char *end = (char *)(node->data + node->size);
+	p = pnpbios_encode_allocated_resource_data(p, end, res);
 	if (!p)
 		return -EIO;
 	return 0;
diff -puN drivers/pnp/quirks.c~pnp-lindent-all-source-files drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/quirks.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include "base.h"
 
-
 static void quirk_awe32_resources(struct pnp_dev *dev)
 {
 	struct pnp_port *port, *port2, *port3;
@@ -31,7 +30,7 @@ static void quirk_awe32_resources(struct
 	 * two extra ports (at offset 0x400 and 0x800 from the one given) by
 	 * hand.
 	 */
-	for ( ; res ; res = res->next ) {
+	for (; res; res = res->next) {
 		port2 = pnp_alloc(sizeof(struct pnp_port));
 		if (!port2)
 			return;
@@ -58,18 +57,19 @@ static void quirk_cmi8330_resources(stru
 	struct pnp_option *res = dev->dependent;
 	unsigned long tmp;
 
-	for ( ; res ; res = res->next ) {
+	for (; res; res = res->next) {
 
 		struct pnp_irq *irq;
 		struct pnp_dma *dma;
 
-		for( irq = res->irq; irq; irq = irq->next ) {	// Valid irqs are 5, 7, 10
+		for (irq = res->irq; irq; irq = irq->next) {	// Valid irqs are 5, 7, 10
 			tmp = 0x04A0;
 			bitmap_copy(irq->map, &tmp, 16);	// 0000 0100 1010 0000
 		}
 
-		for( dma = res->dma; dma; dma = dma->next ) // Valid 8bit dma channels are 1,3
-			if( ( dma->flags & IORESOURCE_DMA_TYPE_MASK ) == IORESOURCE_DMA_8BIT )
+		for (dma = res->dma; dma; dma = dma->next)	// Valid 8bit dma channels are 1,3
+			if ((dma->flags & IORESOURCE_DMA_TYPE_MASK) ==
+			    IORESOURCE_DMA_8BIT)
 				dma->map = 0x000A;
 	}
 	printk(KERN_INFO "pnp: CMI8330 quirk - fixing interrupts and dma\n");
@@ -79,7 +79,7 @@ static void quirk_sb16audio_resources(st
 {
 	struct pnp_port *port;
 	struct pnp_option *res = dev->dependent;
-	int    changed = 0;
+	int changed = 0;
 
 	/*
 	 * The default range on the mpu port for these devices is 0x388-0x388.
@@ -87,23 +87,24 @@ static void quirk_sb16audio_resources(st
 	 * auto-configured.
 	 */
 
-	for( ; res ; res = res->next ) {
+	for (; res; res = res->next) {
 		port = res->port;
-		if(!port)
+		if (!port)
 			continue;
 		port = port->next;
-		if(!port)
+		if (!port)
 			continue;
 		port = port->next;
-		if(!port)
+		if (!port)
 			continue;
-		if(port->min != port->max)
+		if (port->min != port->max)
 			continue;
 		port->max += 0x70;
 		changed = 1;
 	}
-	if(changed)
-		printk(KERN_INFO "pnp: SB audio device quirk - increasing port range\n");
+	if (changed)
+		printk(KERN_INFO
+		       "pnp: SB audio device quirk - increasing port range\n");
 	return;
 }
 
@@ -124,7 +125,7 @@ static int quirk_smc_fir_enabled(struct 
 	outb(bank, firbase + 7);
 
 	high = inb(firbase + 0);
-	low  = inb(firbase + 1);
+	low = inb(firbase + 1);
 	chip = inb(firbase + 2);
 
 	/* This corresponds to the check in smsc_ircc_present() */
@@ -153,8 +154,8 @@ static void quirk_smc_enable(struct pnp_
 	 */
 	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
 		"auto-configuring\n", dev->id->id,
-		(unsigned long) pnp_port_start(dev, 0),
-		(unsigned long) pnp_port_start(dev, 1));
+		(unsigned long)pnp_port_start(dev, 0),
+		(unsigned long)pnp_port_start(dev, 1));
 
 	pnp_disable_dev(dev);
 	pnp_init_resource_table(&dev->res);
@@ -162,8 +163,8 @@ static void quirk_smc_enable(struct pnp_
 	pnp_activate_dev(dev);
 	if (quirk_smc_fir_enabled(dev)) {
 		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long) pnp_port_start(dev, 0),
-			(unsigned long) pnp_port_start(dev, 1));
+			(unsigned long)pnp_port_start(dev, 0),
+			(unsigned long)pnp_port_start(dev, 1));
 		return;
 	}
 
@@ -175,8 +176,8 @@ static void quirk_smc_enable(struct pnp_
 	 */
 	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
 		"swapping SIR/FIR and reconfiguring\n",
-		(unsigned long) pnp_port_start(dev, 0),
-		(unsigned long) pnp_port_start(dev, 1));
+		(unsigned long)pnp_port_start(dev, 0),
+		(unsigned long)pnp_port_start(dev, 1));
 
 	/*
 	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
@@ -200,8 +201,8 @@ static void quirk_smc_enable(struct pnp_
 
 	if (quirk_smc_fir_enabled(dev)) {
 		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long) pnp_port_start(dev, 0),
-			(unsigned long) pnp_port_start(dev, 1));
+			(unsigned long)pnp_port_start(dev, 0),
+			(unsigned long)pnp_port_start(dev, 1));
 		return;
 	}
 
@@ -209,7 +210,6 @@ static void quirk_smc_enable(struct pnp_
 		"email bjorn.helgaas@hp.com\n");
 }
 
-
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -217,21 +217,21 @@ static void quirk_smc_enable(struct pnp_
 
 static struct pnp_fixup pnp_fixups[] = {
 	/* Soundblaster awe io port quirk */
-	{ "CTL0021", quirk_awe32_resources },
-	{ "CTL0022", quirk_awe32_resources },
-	{ "CTL0023", quirk_awe32_resources },
+	{"CTL0021", quirk_awe32_resources},
+	{"CTL0022", quirk_awe32_resources},
+	{"CTL0023", quirk_awe32_resources},
 	/* CMI 8330 interrupt and dma fix */
-	{ "@X@0001", quirk_cmi8330_resources },
+	{"@X@0001", quirk_cmi8330_resources},
 	/* Soundblaster audio device io port range quirk */
-	{ "CTL0001", quirk_sb16audio_resources },
-	{ "CTL0031", quirk_sb16audio_resources },
-	{ "CTL0041", quirk_sb16audio_resources },
-	{ "CTL0042", quirk_sb16audio_resources },
-	{ "CTL0043", quirk_sb16audio_resources },
-	{ "CTL0044", quirk_sb16audio_resources },
-	{ "CTL0045", quirk_sb16audio_resources },
-	{ "SMCf010", quirk_smc_enable },
-	{ "" }
+	{"CTL0001", quirk_sb16audio_resources},
+	{"CTL0031", quirk_sb16audio_resources},
+	{"CTL0041", quirk_sb16audio_resources},
+	{"CTL0042", quirk_sb16audio_resources},
+	{"CTL0043", quirk_sb16audio_resources},
+	{"CTL0044", quirk_sb16audio_resources},
+	{"CTL0045", quirk_sb16audio_resources},
+	{"SMCf010", quirk_smc_enable},
+	{""}
 };
 
 void pnp_fixup_device(struct pnp_dev *dev)
@@ -239,9 +239,8 @@ void pnp_fixup_device(struct pnp_dev *de
 	int i = 0;
 
 	while (*pnp_fixups[i].id) {
-		if (compare_pnp_id(dev->id,pnp_fixups[i].id)) {
-			pnp_dbg("Calling quirk for %s",
-		                  dev->dev.bus_id);
+		if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
+			pnp_dbg("Calling quirk for %s", dev->dev.bus_id);
 			pnp_fixups[i].quirk_function(dev);
 		}
 		i++;
diff -puN drivers/pnp/resource.c~pnp-lindent-all-source-files drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/resource.c
@@ -20,17 +20,16 @@
 #include <linux/pnp.h>
 #include "base.h"
 
-static int pnp_reserve_irq[16] = { [0 ... 15] = -1 };	/* reserve (don't use) some IRQ */
-static int pnp_reserve_dma[8] = { [0 ... 7] = -1 };	/* reserve (don't use) some DMA */
-static int pnp_reserve_io[16] = { [0 ... 15] = -1 };	/* reserve (don't use) some I/O region */
-static int pnp_reserve_mem[16] = { [0 ... 15] = -1 };	/* reserve (don't use) some memory region */
-
+static int pnp_reserve_irq[16] = {[0...15] = -1 };	/* reserve (don't use) some IRQ */
+static int pnp_reserve_dma[8] = {[0...7] = -1 };	/* reserve (don't use) some DMA */
+static int pnp_reserve_io[16] = {[0...15] = -1 };	/* reserve (don't use) some I/O region */
+static int pnp_reserve_mem[16] = {[0...15] = -1 };	/* reserve (don't use) some memory region */
 
 /*
  * option registration
  */
 
-static struct pnp_option * pnp_build_option(int priority)
+static struct pnp_option *pnp_build_option(int priority)
 {
 	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
 
@@ -46,7 +45,7 @@ static struct pnp_option * pnp_build_opt
 	return option;
 }
 
-struct pnp_option * pnp_register_independent_option(struct pnp_dev *dev)
+struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev)
 {
 	struct pnp_option *option;
 	if (!dev)
@@ -61,7 +60,8 @@ struct pnp_option * pnp_register_indepen
 	return option;
 }
 
-struct pnp_option * pnp_register_dependent_option(struct pnp_dev *dev, int priority)
+struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
+						 int priority)
 {
 	struct pnp_option *option;
 	if (!dev)
@@ -222,7 +222,6 @@ void pnp_free_option(struct pnp_option *
 	}
 }
 
-
 /*
  * resource validity checking
  */
@@ -236,7 +235,7 @@ void pnp_free_option(struct pnp_option *
 #define cannot_compare(flags) \
 ((flags) & (IORESOURCE_UNSET | IORESOURCE_DISABLED))
 
-int pnp_check_port(struct pnp_dev * dev, int idx)
+int pnp_check_port(struct pnp_dev *dev, int idx)
 {
 	int tmp;
 	struct pnp_dev *tdev;
@@ -250,8 +249,8 @@ int pnp_check_port(struct pnp_dev * dev,
 
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
-	if(!dev->active) {
-		if (__check_region(&ioport_resource, *port, length(port,end)))
+	if (!dev->active) {
+		if (__check_region(&ioport_resource, *port, length(port, end)))
 			return 0;
 	}
 
@@ -259,7 +258,7 @@ int pnp_check_port(struct pnp_dev * dev,
 	for (tmp = 0; tmp < 8; tmp++) {
 		int rport = pnp_reserve_io[tmp << 1];
 		int rend = pnp_reserve_io[(tmp << 1) + 1] + rport - 1;
-		if (ranged_conflict(port,end,&rport,&rend))
+		if (ranged_conflict(port, end, &rport, &rend))
 			return 0;
 	}
 
@@ -268,7 +267,7 @@ int pnp_check_port(struct pnp_dev * dev,
 		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
 			tport = &dev->res.port_resource[tmp].start;
 			tend = &dev->res.port_resource[tmp].end;
-			if (ranged_conflict(port,end,tport,tend))
+			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
 	}
@@ -279,11 +278,12 @@ int pnp_check_port(struct pnp_dev * dev,
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
 			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-				if (cannot_compare(tdev->res.port_resource[tmp].flags))
+				if (cannot_compare
+				    (tdev->res.port_resource[tmp].flags))
 					continue;
 				tport = &tdev->res.port_resource[tmp].start;
 				tend = &tdev->res.port_resource[tmp].end;
-				if (ranged_conflict(port,end,tport,tend))
+				if (ranged_conflict(port, end, tport, tend))
 					return 0;
 			}
 		}
@@ -292,7 +292,7 @@ int pnp_check_port(struct pnp_dev * dev,
 	return 1;
 }
 
-int pnp_check_mem(struct pnp_dev * dev, int idx)
+int pnp_check_mem(struct pnp_dev *dev, int idx)
 {
 	int tmp;
 	struct pnp_dev *tdev;
@@ -306,8 +306,8 @@ int pnp_check_mem(struct pnp_dev * dev, 
 
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
-	if(!dev->active) {
-		if (check_mem_region(*addr, length(addr,end)))
+	if (!dev->active) {
+		if (check_mem_region(*addr, length(addr, end)))
 			return 0;
 	}
 
@@ -315,7 +315,7 @@ int pnp_check_mem(struct pnp_dev * dev, 
 	for (tmp = 0; tmp < 8; tmp++) {
 		int raddr = pnp_reserve_mem[tmp << 1];
 		int rend = pnp_reserve_mem[(tmp << 1) + 1] + raddr - 1;
-		if (ranged_conflict(addr,end,&raddr,&rend))
+		if (ranged_conflict(addr, end, &raddr, &rend))
 			return 0;
 	}
 
@@ -324,7 +324,7 @@ int pnp_check_mem(struct pnp_dev * dev, 
 		if (dev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
 			taddr = &dev->res.mem_resource[tmp].start;
 			tend = &dev->res.mem_resource[tmp].end;
-			if (ranged_conflict(addr,end,taddr,tend))
+			if (ranged_conflict(addr, end, taddr, tend))
 				return 0;
 		}
 	}
@@ -335,11 +335,12 @@ int pnp_check_mem(struct pnp_dev * dev, 
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
 			if (tdev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
-				if (cannot_compare(tdev->res.mem_resource[tmp].flags))
+				if (cannot_compare
+				    (tdev->res.mem_resource[tmp].flags))
 					continue;
 				taddr = &tdev->res.mem_resource[tmp].start;
 				tend = &tdev->res.mem_resource[tmp].end;
-				if (ranged_conflict(addr,end,taddr,tend))
+				if (ranged_conflict(addr, end, taddr, tend))
 					return 0;
 			}
 		}
@@ -353,11 +354,11 @@ static irqreturn_t pnp_test_handler(int 
 	return IRQ_HANDLED;
 }
 
-int pnp_check_irq(struct pnp_dev * dev, int idx)
+int pnp_check_irq(struct pnp_dev *dev, int idx)
 {
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t * irq = &dev->res.irq_resource[idx].start;
+	resource_size_t *irq = &dev->res.irq_resource[idx].start;
 
 	/* if the resource doesn't exist, don't complain about it */
 	if (cannot_compare(dev->res.irq_resource[idx].flags))
@@ -394,9 +395,9 @@ int pnp_check_irq(struct pnp_dev * dev, 
 
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
-	if(!dev->active) {
+	if (!dev->active) {
 		if (request_irq(*irq, pnp_test_handler,
-				IRQF_DISABLED|IRQF_PROBE_SHARED, "pnp", NULL))
+				IRQF_DISABLED | IRQF_PROBE_SHARED, "pnp", NULL))
 			return 0;
 		free_irq(*irq, NULL);
 	}
@@ -407,7 +408,8 @@ int pnp_check_irq(struct pnp_dev * dev, 
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
 			if (tdev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
-				if (cannot_compare(tdev->res.irq_resource[tmp].flags))
+				if (cannot_compare
+				    (tdev->res.irq_resource[tmp].flags))
 					continue;
 				if ((tdev->res.irq_resource[tmp].start == *irq))
 					return 0;
@@ -418,12 +420,12 @@ int pnp_check_irq(struct pnp_dev * dev, 
 	return 1;
 }
 
-int pnp_check_dma(struct pnp_dev * dev, int idx)
+int pnp_check_dma(struct pnp_dev *dev, int idx)
 {
 #ifndef CONFIG_IA64
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t * dma = &dev->res.dma_resource[idx].start;
+	resource_size_t *dma = &dev->res.dma_resource[idx].start;
 
 	/* if the resource doesn't exist, don't complain about it */
 	if (cannot_compare(dev->res.dma_resource[idx].flags))
@@ -449,7 +451,7 @@ int pnp_check_dma(struct pnp_dev * dev, 
 
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
-	if(!dev->active) {
+	if (!dev->active) {
 		if (request_dma(*dma, "pnp"))
 			return 0;
 		free_dma(*dma);
@@ -461,7 +463,8 @@ int pnp_check_dma(struct pnp_dev * dev, 
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
 			if (tdev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
-				if (cannot_compare(tdev->res.dma_resource[tmp].flags))
+				if (cannot_compare
+				    (tdev->res.dma_resource[tmp].flags))
 					continue;
 				if ((tdev->res.dma_resource[tmp].start == *dma))
 					return 0;
@@ -476,7 +479,6 @@ int pnp_check_dma(struct pnp_dev * dev, 
 #endif
 }
 
-
 #if 0
 EXPORT_SYMBOL(pnp_register_dependent_option);
 EXPORT_SYMBOL(pnp_register_independent_option);
@@ -484,8 +486,7 @@ EXPORT_SYMBOL(pnp_register_irq_resource)
 EXPORT_SYMBOL(pnp_register_dma_resource);
 EXPORT_SYMBOL(pnp_register_port_resource);
 EXPORT_SYMBOL(pnp_register_mem_resource);
-#endif  /*  0  */
-
+#endif /*  0  */
 
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 
@@ -494,7 +495,7 @@ static int __init pnp_setup_reserve_irq(
 	int i;
 
 	for (i = 0; i < 16; i++)
-		if (get_option(&str,&pnp_reserve_irq[i]) != 2)
+		if (get_option(&str, &pnp_reserve_irq[i]) != 2)
 			break;
 	return 1;
 }
@@ -508,7 +509,7 @@ static int __init pnp_setup_reserve_dma(
 	int i;
 
 	for (i = 0; i < 8; i++)
-		if (get_option(&str,&pnp_reserve_dma[i]) != 2)
+		if (get_option(&str, &pnp_reserve_dma[i]) != 2)
 			break;
 	return 1;
 }
@@ -522,7 +523,7 @@ static int __init pnp_setup_reserve_io(c
 	int i;
 
 	for (i = 0; i < 16; i++)
-		if (get_option(&str,&pnp_reserve_io[i]) != 2)
+		if (get_option(&str, &pnp_reserve_io[i]) != 2)
 			break;
 	return 1;
 }
@@ -536,7 +537,7 @@ static int __init pnp_setup_reserve_mem(
 	int i;
 
 	for (i = 0; i < 16; i++)
-		if (get_option(&str,&pnp_reserve_mem[i]) != 2)
+		if (get_option(&str, &pnp_reserve_mem[i]) != 2)
 			break;
 	return 1;
 }
diff -puN drivers/pnp/support.c~pnp-lindent-all-source-files drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/support.c
@@ -16,17 +16,14 @@
  *
  */
 
-int pnp_is_active(struct pnp_dev * dev)
+int pnp_is_active(struct pnp_dev *dev)
 {
 	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
 	    !pnp_mem_start(dev, 0) && pnp_mem_len(dev, 0) <= 1 &&
-	    pnp_irq(dev, 0) == -1 &&
-	    pnp_dma(dev, 0) == -1)
-	    	return 0;
+	    pnp_irq(dev, 0) == -1 && pnp_dma(dev, 0) == -1)
+		return 0;
 	else
 		return 1;
 }
 
-
-
 EXPORT_SYMBOL(pnp_is_active);
diff -puN drivers/pnp/system.c~pnp-lindent-all-source-files drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-lindent-all-source-files
+++ a/drivers/pnp/system.c
@@ -16,13 +16,14 @@
 
 static const struct pnp_device_id pnp_dev_table[] = {
 	/* General ID for reserving resources */
-	{	"PNP0c02",		0	},
+	{"PNP0c02", 0},
 	/* memory controller */
-	{	"PNP0c01",		0	},
-	{	"",			0	}
+	{"PNP0c01", 0},
+	{"", 0}
 };
 
-static void reserve_range(const char *pnpid, resource_size_t start, resource_size_t end, int port)
+static void reserve_range(const char *pnpid, resource_size_t start,
+			  resource_size_t end, int port)
 {
 	struct resource *res;
 	char *regionid;
@@ -32,9 +33,9 @@ static void reserve_range(const char *pn
 		return;
 	snprintf(regionid, 16, "pnp %s", pnpid);
 	if (port)
-		res = request_region(start, end-start+1, regionid);
+		res = request_region(start, end - start + 1, regionid);
 	else
-		res = request_mem_region(start, end-start+1, regionid);
+		res = request_mem_region(start, end - start + 1, regionid);
 	if (res == NULL)
 		kfree(regionid);
 	else
@@ -45,10 +46,10 @@ static void reserve_range(const char *pn
 	 * have double reservations.
 	 */
 	printk(KERN_INFO
-		"pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
-		pnpid, port ? "ioport" : "iomem",
-                (unsigned long long)start, (unsigned long long)end,
-		NULL != res ? "has been" : "could not be");
+	       "pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
+	       pnpid, port ? "ioport" : "iomem",
+	       (unsigned long long)start, (unsigned long long)end,
+	       NULL != res ? "has been" : "could not be");
 }
 
 static void reserve_resources_of_dev(const struct pnp_dev *dev)
@@ -74,7 +75,7 @@ static void reserve_resources_of_dev(con
 			continue;	/* invalid */
 
 		reserve_range(dev->dev.bus_id, pnp_port_start(dev, i),
-			pnp_port_end(dev, i), 1);
+			      pnp_port_end(dev, i), 1);
 	}
 
 	for (i = 0; i < PNP_MAX_MEM; i++) {
@@ -82,24 +83,25 @@ static void reserve_resources_of_dev(con
 			continue;
 
 		reserve_range(dev->dev.bus_id, pnp_mem_start(dev, i),
-			pnp_mem_end(dev, i), 0);
+			      pnp_mem_end(dev, i), 0);
 	}
 
 	return;
 }
 
-static int system_pnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id)
+static int system_pnp_probe(struct pnp_dev *dev,
+			    const struct pnp_device_id *dev_id)
 {
 	reserve_resources_of_dev(dev);
 	return 0;
 }
 
 static struct pnp_driver system_pnp_driver = {
-	.name		= "system",
-	.id_table	= pnp_dev_table,
-	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
-	.probe		= system_pnp_probe,
-	.remove		= NULL,
+	.name = "system",
+	.id_table = pnp_dev_table,
+	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
+	.probe = system_pnp_probe,
+	.remove = NULL,
 };
 
 static int __init pnp_system_init(void)
diff -puN include/linux/pnp.h~pnp-lindent-all-source-files include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-lindent-all-source-files
+++ a/include/linux/pnp.h
@@ -23,7 +23,6 @@
 struct pnp_protocol;
 struct pnp_dev;
 
-
 /*
  * Resource Management
  */
@@ -73,37 +72,37 @@ struct pnp_dev;
 #define PNP_PORT_FLAG_FIXED	(1<<1)
 
 struct pnp_port {
-	unsigned short min;		/* min base number */
-	unsigned short max;		/* max base number */
-	unsigned char align;		/* align boundary */
-	unsigned char size;		/* size of range */
-	unsigned char flags;		/* port flags */
-	unsigned char pad;		/* pad */
-	struct pnp_port *next;		/* next port */
+	unsigned short min;	/* min base number */
+	unsigned short max;	/* max base number */
+	unsigned char align;	/* align boundary */
+	unsigned char size;	/* size of range */
+	unsigned char flags;	/* port flags */
+	unsigned char pad;	/* pad */
+	struct pnp_port *next;	/* next port */
 };
 
 #define PNP_IRQ_NR 256
 struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR); /* bitmaks for IRQ lines */
-	unsigned char flags;		/* IRQ flags */
-	unsigned char pad;		/* pad */
-	struct pnp_irq *next;		/* next IRQ */
+	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmaks for IRQ lines */
+	unsigned char flags;	/* IRQ flags */
+	unsigned char pad;	/* pad */
+	struct pnp_irq *next;	/* next IRQ */
 };
 
 struct pnp_dma {
-	unsigned char map;		/* bitmask for DMA channels */
-	unsigned char flags;		/* DMA flags */
-	struct pnp_dma *next;		/* next port */
+	unsigned char map;	/* bitmask for DMA channels */
+	unsigned char flags;	/* DMA flags */
+	struct pnp_dma *next;	/* next port */
 };
 
 struct pnp_mem {
-	unsigned int min;		/* min base number */
-	unsigned int max;		/* max base number */
-	unsigned int align;		/* align boundary */
-	unsigned int size;		/* size of range */
-	unsigned char flags;		/* memory flags */
-	unsigned char pad;		/* pad */
-	struct pnp_mem *next;		/* next memory resource */
+	unsigned int min;	/* min base number */
+	unsigned int max;	/* max base number */
+	unsigned int align;	/* align boundary */
+	unsigned int size;	/* size of range */
+	unsigned char flags;	/* memory flags */
+	unsigned char pad;	/* pad */
+	struct pnp_mem *next;	/* next memory resource */
 };
 
 #define PNP_RES_PRIORITY_PREFERRED	0
@@ -113,10 +112,10 @@ struct pnp_mem {
 
 struct pnp_option {
 	unsigned short priority;	/* priority */
-	struct pnp_port *port;		/* first port */
-	struct pnp_irq *irq;		/* first IRQ */
-	struct pnp_dma *dma;		/* first DMA */
-	struct pnp_mem *mem;		/* first memory resource */
+	struct pnp_port *port;	/* first port */
+	struct pnp_irq *irq;	/* first IRQ */
+	struct pnp_dma *dma;	/* first DMA */
+	struct pnp_mem *mem;	/* first memory resource */
 	struct pnp_option *next;	/* used to chain dependent resources */
 };
 
@@ -127,26 +126,25 @@ struct pnp_resource_table {
 	struct resource irq_resource[PNP_MAX_IRQ];
 };
 
-
 /*
  * Device Managemnt
  */
 
 struct pnp_card {
-	struct device dev;		/* Driver Model device interface */
-	unsigned char number;		/* used as an index, must be unique */
+	struct device dev;	/* Driver Model device interface */
+	unsigned char number;	/* used as an index, must be unique */
 	struct list_head global_list;	/* node in global list of cards */
 	struct list_head protocol_list;	/* node in protocol's list of cards */
 	struct list_head devices;	/* devices attached to the card */
 
-	struct pnp_protocol * protocol;
-	struct pnp_id * id;		/* contains supported EISA IDs*/
+	struct pnp_protocol *protocol;
+	struct pnp_id *id;	/* contains supported EISA IDs */
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned char	pnpver;		/* Plug & Play version */
-	unsigned char	productver;	/* product version */
-	unsigned int	serial;		/* serial number */
-	unsigned char	checksum;	/* if zero - checksum passed */
+	unsigned char pnpver;	/* Plug & Play version */
+	unsigned char productver;	/* product version */
+	unsigned int serial;	/* serial number */
+	unsigned char checksum;	/* if zero - checksum passed */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/isapnp */
 };
 
@@ -159,26 +157,26 @@ struct pnp_card {
 	(card) = global_to_pnp_card((card)->global_list.next))
 
 struct pnp_card_link {
-	struct pnp_card * card;
-	struct pnp_card_driver * driver;
-	void * driver_data;
+	struct pnp_card *card;
+	struct pnp_card_driver *driver;
+	void *driver_data;
 	pm_message_t pm_state;
 };
 
-static inline void *pnp_get_card_drvdata (struct pnp_card_link *pcard)
+static inline void *pnp_get_card_drvdata(struct pnp_card_link *pcard)
 {
 	return pcard->driver_data;
 }
 
-static inline void pnp_set_card_drvdata (struct pnp_card_link *pcard, void *data)
+static inline void pnp_set_card_drvdata(struct pnp_card_link *pcard, void *data)
 {
 	pcard->driver_data = data;
 }
 
 struct pnp_dev {
-	struct device dev;		/* Driver Model device interface */
+	struct device dev;	/* Driver Model device interface */
 	u64 dma_mask;
-	unsigned char number;		/* used as an index, must be unique */
+	unsigned char number;	/* used as an index, must be unique */
 	int status;
 
 	struct list_head global_list;	/* node in global list of devices */
@@ -186,22 +184,22 @@ struct pnp_dev {
 	struct list_head card_list;	/* node in card's list of devices */
 	struct list_head rdev_list;	/* node in cards list of requested devices */
 
-	struct pnp_protocol * protocol;
-	struct pnp_card * card;		/* card the device is attached to, none if NULL */
-	struct pnp_driver * driver;
-	struct pnp_card_link * card_link;
+	struct pnp_protocol *protocol;
+	struct pnp_card *card;	/* card the device is attached to, none if NULL */
+	struct pnp_driver *driver;
+	struct pnp_card_link *card_link;
 
-	struct pnp_id	* id;	/* supported EISA IDs*/
+	struct pnp_id *id;	/* supported EISA IDs */
 
 	int active;
 	int capabilities;
-	struct pnp_option * independent;
-	struct pnp_option * dependent;
+	struct pnp_option *independent;
+	struct pnp_option *dependent;
 	struct pnp_resource_table res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned short	regs;		/* ISAPnP: supported registers */
-	int 		flags;		/* used by protocols */
+	unsigned short regs;	/* ISAPnP: supported registers */
+	int flags;		/* used by protocols */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/isapnp */
 	void *data;
 };
@@ -220,19 +218,19 @@ struct pnp_dev {
 	(dev) = card_to_pnp_dev((dev)->card_list.next))
 #define pnp_dev_name(dev) (dev)->name
 
-static inline void *pnp_get_drvdata (struct pnp_dev *pdev)
+static inline void *pnp_get_drvdata(struct pnp_dev *pdev)
 {
 	return dev_get_drvdata(&pdev->dev);
 }
 
-static inline void pnp_set_drvdata (struct pnp_dev *pdev, void *data)
+static inline void pnp_set_drvdata(struct pnp_dev *pdev, void *data)
 {
 	dev_set_drvdata(&pdev->dev, data);
 }
 
 struct pnp_fixup {
 	char id[7];
-	void (*quirk_function)(struct pnp_dev *dev);	/* fixup function */
+	void (*quirk_function) (struct pnp_dev * dev);	/* fixup function */
 };
 
 /* config parameters */
@@ -269,7 +267,6 @@ extern struct pnp_protocol pnpbios_proto
 #define pnp_device_is_pnpbios(dev) 0
 #endif
 
-
 /* status */
 #define PNP_READY		0x0000
 #define PNP_ATTACHED		0x0001
@@ -287,17 +284,18 @@ extern struct pnp_protocol pnpbios_proto
 
 struct pnp_id {
 	char id[PNP_ID_LEN];
-	struct pnp_id * next;
+	struct pnp_id *next;
 };
 
 struct pnp_driver {
-	char * name;
+	char *name;
 	const struct pnp_device_id *id_table;
 	unsigned int flags;
-	int  (*probe)  (struct pnp_dev *dev, const struct pnp_device_id *dev_id);
-	void (*remove) (struct pnp_dev *dev);
-	int  (*suspend) (struct pnp_dev *dev, pm_message_t state);
-	int  (*resume) (struct pnp_dev *dev);
+	int (*probe) (struct pnp_dev * dev,
+		      const struct pnp_device_id * dev_id);
+	void (*remove) (struct pnp_dev * dev);
+	int (*suspend) (struct pnp_dev * dev, pm_message_t state);
+	int (*resume) (struct pnp_dev * dev);
 	struct device_driver driver;
 };
 
@@ -305,13 +303,14 @@ struct pnp_driver {
 
 struct pnp_card_driver {
 	struct list_head global_list;
-	char * name;
+	char *name;
 	const struct pnp_card_device_id *id_table;
 	unsigned int flags;
-	int  (*probe)  (struct pnp_card_link *card, const struct pnp_card_device_id *card_id);
-	void (*remove) (struct pnp_card_link *card);
-	int  (*suspend) (struct pnp_card_link *card, pm_message_t state);
-	int  (*resume) (struct pnp_card_link *card);
+	int (*probe) (struct pnp_card_link * card,
+		      const struct pnp_card_device_id * card_id);
+	void (*remove) (struct pnp_card_link * card);
+	int (*suspend) (struct pnp_card_link * card, pm_message_t state);
+	int (*resume) (struct pnp_card_link * card);
 	struct pnp_driver link;
 };
 
@@ -321,29 +320,28 @@ struct pnp_card_driver {
 #define PNP_DRIVER_RES_DO_NOT_CHANGE	0x0001	/* do not change the state of the device */
 #define PNP_DRIVER_RES_DISABLE		0x0003	/* ensure the device is disabled */
 
-
 /*
  * Protocol Management
  */
 
 struct pnp_protocol {
-	struct list_head	protocol_list;
-	char		      * name;
+	struct list_head protocol_list;
+	char *name;
 
 	/* resource control functions */
-	int (*get)(struct pnp_dev *dev, struct pnp_resource_table *res);
-	int (*set)(struct pnp_dev *dev, struct pnp_resource_table *res);
-	int (*disable)(struct pnp_dev *dev);
+	int (*get) (struct pnp_dev * dev, struct pnp_resource_table * res);
+	int (*set) (struct pnp_dev * dev, struct pnp_resource_table * res);
+	int (*disable) (struct pnp_dev * dev);
 
 	/* protocol specific suspend/resume */
-	int (*suspend)(struct pnp_dev *dev, pm_message_t state);
-	int (*resume)(struct pnp_dev *dev);
+	int (*suspend) (struct pnp_dev * dev, pm_message_t state);
+	int (*resume) (struct pnp_dev * dev);
 
 	/* used by pnp layer only (look but don't touch) */
-	unsigned char		number;		/* protocol number*/
-	struct device		dev;		/* link to driver model */
-	struct list_head	cards;
-	struct list_head	devices;
+	unsigned char number;	/* protocol number */
+	struct device dev;	/* link to driver model */
+	struct list_head cards;
+	struct list_head devices;
 };
 
 #define to_pnp_protocol(n) list_entry(n, struct pnp_protocol, protocol_list)
@@ -356,7 +354,6 @@ struct pnp_protocol {
 	(dev) != protocol_to_pnp_dev(&(protocol)->devices); \
 	(dev) = protocol_to_pnp_dev((dev)->protocol_list.next))
 
-
 extern struct bus_type pnp_bus_type;
 
 #if defined(CONFIG_PNP)
@@ -376,21 +373,25 @@ void pnp_remove_card(struct pnp_card *ca
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
 int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card);
-struct pnp_dev * pnp_request_card_device(struct pnp_card_link *clink, const char * id, struct pnp_dev * from);
-void pnp_release_card_device(struct pnp_dev * dev);
-int pnp_register_card_driver(struct pnp_card_driver * drv);
-void pnp_unregister_card_driver(struct pnp_card_driver * drv);
+struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
+					const char *id, struct pnp_dev *from);
+void pnp_release_card_device(struct pnp_dev *dev);
+int pnp_register_card_driver(struct pnp_card_driver *drv);
+void pnp_unregister_card_driver(struct pnp_card_driver *drv);
 extern struct list_head pnp_cards;
 
 /* resource management */
-struct pnp_option * pnp_register_independent_option(struct pnp_dev *dev);
-struct pnp_option * pnp_register_dependent_option(struct pnp_dev *dev, int priority);
+struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
+struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
+						 int priority);
 int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data);
 int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data);
-int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data);
+int pnp_register_port_resource(struct pnp_option *option,
+			       struct pnp_port *data);
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
 void pnp_init_resource_table(struct pnp_resource_table *table);
-int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode);
+int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
+			  int mode);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_validate_config(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
@@ -398,11 +399,11 @@ int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
 int pnp_disable_dev(struct pnp_dev *dev);
 void pnp_resource_change(struct resource *resource, resource_size_t start,
-				resource_size_t size);
+			 resource_size_t size);
 
 /* protocol helpers */
-int pnp_is_active(struct pnp_dev * dev);
-int compare_pnp_id(struct pnp_id * pos, const char * id);
+int pnp_is_active(struct pnp_dev *dev);
+int compare_pnp_id(struct pnp_id *pos, const char *id);
 int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev);
 int pnp_register_driver(struct pnp_driver *drv);
 void pnp_unregister_driver(struct pnp_driver *drv);
@@ -410,54 +411,162 @@ void pnp_unregister_driver(struct pnp_dr
 #else
 
 /* device management */
-static inline int pnp_register_protocol(struct pnp_protocol *protocol) { return -ENODEV; }
-static inline void pnp_unregister_protocol(struct pnp_protocol *protocol) { }
-static inline int pnp_init_device(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_add_device(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_device_attach(struct pnp_dev *pnp_dev) { return -ENODEV; }
-static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { ; }
+static inline int pnp_register_protocol(struct pnp_protocol *protocol)
+{
+	return -ENODEV;
+}
+static inline void pnp_unregister_protocol(struct pnp_protocol *protocol)
+{
+}
+static inline int pnp_init_device(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_add_device(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_device_attach(struct pnp_dev *pnp_dev)
+{
+	return -ENODEV;
+}
+static inline void pnp_device_detach(struct pnp_dev *pnp_dev)
+{;
+}
+
 #define pnp_platform_devices 0
 
 /* multidevice card support */
-static inline int pnp_add_card(struct pnp_card *card) { return -ENODEV; }
-static inline void pnp_remove_card(struct pnp_card *card) { ; }
-static inline int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev) { return -ENODEV; }
-static inline void pnp_remove_card_device(struct pnp_dev *dev) { ; }
-static inline int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card) { return -ENODEV; }
-static inline struct pnp_dev * pnp_request_card_device(struct pnp_card_link *clink, const char * id, struct pnp_dev * from) { return NULL; }
-static inline void pnp_release_card_device(struct pnp_dev * dev) { ; }
-static inline int pnp_register_card_driver(struct pnp_card_driver * drv) { return -ENODEV; }
-static inline void pnp_unregister_card_driver(struct pnp_card_driver * drv) { ; }
+static inline int pnp_add_card(struct pnp_card *card)
+{
+	return -ENODEV;
+}
+static inline void pnp_remove_card(struct pnp_card *card)
+{;
+}
+static inline int pnp_add_card_device(struct pnp_card *card,
+				      struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline void pnp_remove_card_device(struct pnp_dev *dev)
+{;
+}
+static inline int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card)
+{
+	return -ENODEV;
+}
+static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link
+						      *clink, const char *id,
+						      struct pnp_dev *from)
+{
+	return NULL;
+}
+static inline void pnp_release_card_device(struct pnp_dev *dev)
+{;
+}
+static inline int pnp_register_card_driver(struct pnp_card_driver *drv)
+{
+	return -ENODEV;
+}
+static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv)
+{;
+}
 
 /* resource management */
-static inline struct pnp_option * pnp_register_independent_option(struct pnp_dev *dev) { return NULL; }
-static inline struct pnp_option * pnp_register_dependent_option(struct pnp_dev *dev, int priority) { return NULL; }
-static inline int pnp_register_irq_resource(struct pnp_option *option, struct pnp_irq *data) { return -ENODEV; }
-static inline int pnp_register_dma_resource(struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
-static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
-static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
-static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
-static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
-static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline struct pnp_option *pnp_register_independent_option(struct pnp_dev
+								 *dev)
+{
+	return NULL;
+}
+static inline struct pnp_option *pnp_register_dependent_option(struct pnp_dev
+							       *dev,
+							       int priority)
+{
+	return NULL;
+}
+static inline int pnp_register_irq_resource(struct pnp_option *option,
+					    struct pnp_irq *data)
+{
+	return -ENODEV;
+}
+static inline int pnp_register_dma_resource(struct pnp_option *option,
+					    struct pnp_dma *data)
+{
+	return -ENODEV;
+}
+static inline int pnp_register_port_resource(struct pnp_option *option,
+					     struct pnp_port *data)
+{
+	return -ENODEV;
+}
+static inline int pnp_register_mem_resource(struct pnp_option *option,
+					    struct pnp_mem *data)
+{
+	return -ENODEV;
+}
+static inline void pnp_init_resource_table(struct pnp_resource_table *table)
+{
+}
+static inline int pnp_manual_config_dev(struct pnp_dev *dev,
+					struct pnp_resource_table *res,
+					int mode)
+{
+	return -ENODEV;
+}
+static inline int pnp_auto_config_dev(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_validate_config(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_start_dev(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_stop_dev(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_activate_dev(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_disable_dev(struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
 static inline void pnp_resource_change(struct resource *resource,
-					resource_size_t start,
-					resource_size_t size) { }
+				       resource_size_t start,
+				       resource_size_t size)
+{
+}
 
 /* protocol helpers */
-static inline int pnp_is_active(struct pnp_dev * dev) { return 0; }
-static inline int compare_pnp_id(struct pnp_id * pos, const char * id) { return -ENODEV; }
-static inline int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_register_driver(struct pnp_driver *drv) { return -ENODEV; }
-static inline void pnp_unregister_driver(struct pnp_driver *drv) { ; }
+static inline int pnp_is_active(struct pnp_dev *dev)
+{
+	return 0;
+}
+static inline int compare_pnp_id(struct pnp_id *pos, const char *id)
+{
+	return -ENODEV;
+}
+static inline int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pnp_register_driver(struct pnp_driver *drv)
+{
+	return -ENODEV;
+}
+static inline void pnp_unregister_driver(struct pnp_driver *drv)
+{;
+}
 
 #endif /* CONFIG_PNP */
 
-
 #define pnp_err(format, arg...) printk(KERN_ERR "pnp: " format "\n" , ## arg)
 #define pnp_info(format, arg...) printk(KERN_INFO "pnp: " format "\n" , ## arg)
 #define pnp_warn(format, arg...) printk(KERN_WARNING "pnp: " format "\n" , ## arg)
diff -puN include/linux/pnpbios.h~pnp-lindent-all-source-files include/linux/pnpbios.h
--- a/include/linux/pnpbios.h~pnp-lindent-all-source-files
+++ a/include/linux/pnpbios.h
@@ -99,32 +99,32 @@
 
 #pragma pack(1)
 struct pnp_dev_node_info {
-	__u16	no_nodes;
-	__u16	max_node_size;
+	__u16 no_nodes;
+	__u16 max_node_size;
 };
 struct pnp_docking_station_info {
-	__u32	location_id;
-	__u32	serial;
-	__u16	capabilities;
+	__u32 location_id;
+	__u32 serial;
+	__u16 capabilities;
 };
 struct pnp_isa_config_struc {
-	__u8	revision;
-	__u8	no_csns;
-	__u16	isa_rd_data_port;
-	__u16	reserved;
+	__u8 revision;
+	__u8 no_csns;
+	__u16 isa_rd_data_port;
+	__u16 reserved;
 };
 struct escd_info_struc {
-	__u16	min_escd_write_size;
-	__u16	escd_size;
-	__u32	nv_storage_base;
+	__u16 min_escd_write_size;
+	__u16 escd_size;
+	__u32 nv_storage_base;
 };
 struct pnp_bios_node {
-	__u16	size;
-	__u8	handle;
-	__u32	eisa_id;
-	__u8	type_code[3];
-	__u16	flags;
-	__u8	data[0];
+	__u16 size;
+	__u8 handle;
+	__u32 eisa_id;
+	__u8 type_code[3];
+	__u16 flags;
+	__u8 data[0];
 };
 #pragma pack()
 
@@ -133,21 +133,23 @@ struct pnp_bios_node {
 /* non-exported */
 extern struct pnp_dev_node_info node_info;
 
-extern int pnp_bios_dev_node_info (struct pnp_dev_node_info *data);
-extern int pnp_bios_get_dev_node (u8 *nodenum, char config, struct pnp_bios_node *data);
-extern int pnp_bios_set_dev_node (u8 nodenum, char config, struct pnp_bios_node *data);
-extern int pnp_bios_get_stat_res (char *info);
-extern int pnp_bios_isapnp_config (struct pnp_isa_config_struc *data);
-extern int pnp_bios_escd_info (struct escd_info_struc *data);
-extern int pnp_bios_read_escd (char *data, u32 nvram_base);
+extern int pnp_bios_dev_node_info(struct pnp_dev_node_info *data);
+extern int pnp_bios_get_dev_node(u8 * nodenum, char config,
+				 struct pnp_bios_node *data);
+extern int pnp_bios_set_dev_node(u8 nodenum, char config,
+				 struct pnp_bios_node *data);
+extern int pnp_bios_get_stat_res(char *info);
+extern int pnp_bios_isapnp_config(struct pnp_isa_config_struc *data);
+extern int pnp_bios_escd_info(struct escd_info_struc *data);
+extern int pnp_bios_read_escd(char *data, u32 nvram_base);
 extern int pnp_bios_dock_station_info(struct pnp_docking_station_info *data);
 #define needed 0
 #if needed
-extern int pnp_bios_get_event (u16 *message);
-extern int pnp_bios_send_message (u16 message);
-extern int pnp_bios_set_stat_res (char *info);
-extern int pnp_bios_apm_id_table (char *table, u16 *size);
-extern int pnp_bios_write_escd (char *data, u32 nvram_base);
+extern int pnp_bios_get_event(u16 * message);
+extern int pnp_bios_send_message(u16 message);
+extern int pnp_bios_set_stat_res(char *info);
+extern int pnp_bios_apm_id_table(char *table, u16 * size);
+extern int pnp_bios_write_escd(char *data, u32 nvram_base);
 #endif
 
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
