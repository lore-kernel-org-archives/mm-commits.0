From: akpm@linux-foundation.org
Subject: + eisa-fix-coding-style-for-eisa-bus-code.patch added to -mm tree
Date: Mon, 25 Jan 2010 15:00:31 -0800
Message-ID: <201001252300.o0PN0V0R016155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203Ab0AYXAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 18:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     eisa: fix coding style for eisa bus code
has been added to the -mm tree.  Its filename is
     eisa-fix-coding-style-for-eisa-bus-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eisa: fix coding style for eisa bus code
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/eisa-bus.c |  240 ++++++++++++++++++++------------------
 1 file changed, 128 insertions(+), 112 deletions(-)

diff -puN drivers/eisa/eisa-bus.c~eisa-fix-coding-style-for-eisa-bus-code drivers/eisa/eisa-bus.c
--- a/drivers/eisa/eisa-bus.c~eisa-fix-coding-style-for-eisa-bus-code
+++ a/drivers/eisa/eisa-bus.c
@@ -39,10 +39,10 @@ static unsigned int enable_dev_count;
 static int disable_dev[EISA_MAX_FORCED_DEV];
 static unsigned int disable_dev_count;
 
-static int is_forced_dev (int *forced_tab,
-			  int forced_count,
-			  struct eisa_root_device *root,
-			  struct eisa_device *edev)
+static int is_forced_dev(int *forced_tab,
+			 int forced_count,
+			 struct eisa_root_device *root,
+			 struct eisa_device *edev)
 {
 	int i, x;
 
@@ -55,21 +55,21 @@ static int is_forced_dev (int *forced_ta
 	return 0;
 }
 
-static void __init eisa_name_device (struct eisa_device *edev)
+static void __init eisa_name_device(struct eisa_device *edev)
 {
 #ifdef CONFIG_EISA_NAMES
 	int i;
 	for (i = 0; i < EISA_INFOS; i++) {
-		if (!strcmp (edev->id.sig, eisa_table[i].id.sig)) {
-			strlcpy (edev->pretty_name,
-				 eisa_table[i].name,
-				 sizeof(edev->pretty_name));
+		if (!strcmp(edev->id.sig, eisa_table[i].id.sig)) {
+			strlcpy(edev->pretty_name,
+				eisa_table[i].name,
+				sizeof(edev->pretty_name));
 			return;
 		}
 	}
 
 	/* No name was found */
-	sprintf (edev->pretty_name, "EISA device %.7s", edev->id.sig);
+	sprintf(edev->pretty_name, "EISA device %.7s", edev->id.sig);
 #endif
 }
 
@@ -91,7 +91,7 @@ static char __init *decode_eisa_sig(unsi
 		 */
 		outb(0x80 + i, addr);
 #endif
-		sig[i] = inb (addr + i);
+		sig[i] = inb(addr + i);
 
 		if (!i && (sig[0] & 0x80))
 			return NULL;
@@ -106,17 +106,17 @@ static char __init *decode_eisa_sig(unsi
         return sig_str;
 }
 
-static int eisa_bus_match (struct device *dev, struct device_driver *drv)
+static int eisa_bus_match(struct device *dev, struct device_driver *drv)
 {
-	struct eisa_device *edev = to_eisa_device (dev);
-	struct eisa_driver *edrv = to_eisa_driver (drv);
+	struct eisa_device *edev = to_eisa_device(dev);
+	struct eisa_driver *edrv = to_eisa_driver(drv);
 	const struct eisa_device_id *eids = edrv->id_table;
 
 	if (!eids)
 		return 0;
 
-	while (strlen (eids->sig)) {
-		if (!strcmp (eids->sig, edev->id.sig) &&
+	while (strlen(eids->sig)) {
+		if (!strcmp(eids->sig, edev->id.sig) &&
 		    edev->state & EISA_CONFIG_ENABLED) {
 			edev->id.driver_data = eids->driver_data;
 			return 1;
@@ -141,61 +141,71 @@ struct bus_type eisa_bus_type = {
 	.match = eisa_bus_match,
 	.uevent = eisa_bus_uevent,
 };
+EXPORT_SYMBOL(eisa_bus_type);
 
-int eisa_driver_register (struct eisa_driver *edrv)
+int eisa_driver_register(struct eisa_driver *edrv)
 {
 	edrv->driver.bus = &eisa_bus_type;
-	return driver_register (&edrv->driver);
+	return driver_register(&edrv->driver);
 }
+EXPORT_SYMBOL(eisa_driver_register);
 
-void eisa_driver_unregister (struct eisa_driver *edrv)
+void eisa_driver_unregister(struct eisa_driver *edrv)
 {
-	driver_unregister (&edrv->driver);
+	driver_unregister(&edrv->driver);
 }
+EXPORT_SYMBOL(eisa_driver_unregister);
 
-static ssize_t eisa_show_sig (struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t eisa_show_sig(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
-        struct eisa_device *edev = to_eisa_device (dev);
-        return sprintf (buf,"%s\n", edev->id.sig);
+	struct eisa_device *edev = to_eisa_device(dev);
+	return sprintf(buf, "%s\n", edev->id.sig);
 }
 
 static DEVICE_ATTR(signature, S_IRUGO, eisa_show_sig, NULL);
 
-static ssize_t eisa_show_state (struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t eisa_show_state(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
 {
-        struct eisa_device *edev = to_eisa_device (dev);
-        return sprintf (buf,"%d\n", edev->state & EISA_CONFIG_ENABLED);
+	struct eisa_device *edev = to_eisa_device(dev);
+	return sprintf(buf, "%d\n", edev->state & EISA_CONFIG_ENABLED);
 }
 
 static DEVICE_ATTR(enabled, S_IRUGO, eisa_show_state, NULL);
 
-static ssize_t eisa_show_modalias (struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t eisa_show_modalias(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
 {
-        struct eisa_device *edev = to_eisa_device (dev);
-        return sprintf (buf, EISA_DEVICE_MODALIAS_FMT "\n", edev->id.sig);
+	struct eisa_device *edev = to_eisa_device(dev);
+	return sprintf(buf, EISA_DEVICE_MODALIAS_FMT "\n", edev->id.sig);
 }
 
 static DEVICE_ATTR(modalias, S_IRUGO, eisa_show_modalias, NULL);
 
-static int __init eisa_init_device (struct eisa_root_device *root,
-				    struct eisa_device *edev,
-				    int slot)
+static int __init eisa_init_device(struct eisa_root_device *root,
+				   struct eisa_device *edev,
+				   int slot)
 {
 	char *sig;
-        unsigned long sig_addr;
+	unsigned long sig_addr;
 	int i;
 
-	sig_addr = SLOT_ADDRESS (root, slot) + EISA_VENDOR_ID_OFFSET;
+	sig_addr = SLOT_ADDRESS(root, slot) + EISA_VENDOR_ID_OFFSET;
 
-	if (!(sig = decode_eisa_sig (sig_addr)))
+	sig = decode_eisa_sig(sig_addr);
+	if (!sig)
 		return -1;	/* No EISA device here */
 	
-	memcpy (edev->id.sig, sig, EISA_SIG_LEN);
+	memcpy(edev->id.sig, sig, EISA_SIG_LEN);
 	edev->slot = slot;
-	edev->state = inb (SLOT_ADDRESS (root, slot) + EISA_CONFIG_OFFSET) & EISA_CONFIG_ENABLED;
-	edev->base_addr = SLOT_ADDRESS (root, slot);
+	edev->state = inb(SLOT_ADDRESS(root, slot) + EISA_CONFIG_OFFSET)
+		      & EISA_CONFIG_ENABLED;
+	edev->base_addr = SLOT_ADDRESS(root, slot);
 	edev->dma_mask = root->dma_mask; /* Default DMA mask */
-	eisa_name_device (edev);
+	eisa_name_device(edev);
 	edev->dev.parent = root->dev;
 	edev->dev.bus = &eisa_bus_type;
 	edev->dev.dma_mask = &edev->dma_mask;
@@ -210,42 +220,45 @@ static int __init eisa_init_device (stru
 #endif
 	}
 
-	if (is_forced_dev (enable_dev, enable_dev_count, root, edev))
+	if (is_forced_dev(enable_dev, enable_dev_count, root, edev))
 		edev->state = EISA_CONFIG_ENABLED | EISA_CONFIG_FORCED;
 	
-	if (is_forced_dev (disable_dev, disable_dev_count, root, edev))
+	if (is_forced_dev(disable_dev, disable_dev_count, root, edev))
 		edev->state = EISA_CONFIG_FORCED;
 
 	return 0;
 }
 
-static int __init eisa_register_device (struct eisa_device *edev)
+static int __init eisa_register_device(struct eisa_device *edev)
 {
-	int rc = device_register (&edev->dev);
+	int rc = device_register(&edev->dev);
 	if (rc)
 		return rc;
 
-	rc = device_create_file (&edev->dev, &dev_attr_signature);
-	if (rc) goto err_devreg;
-	rc = device_create_file (&edev->dev, &dev_attr_enabled);
-	if (rc) goto err_sig;
-	rc = device_create_file (&edev->dev, &dev_attr_modalias);
-	if (rc) goto err_enab;
+	rc = device_create_file(&edev->dev, &dev_attr_signature);
+	if (rc)
+		goto err_devreg;
+	rc = device_create_file(&edev->dev, &dev_attr_enabled);
+	if (rc)
+		goto err_sig;
+	rc = device_create_file(&edev->dev, &dev_attr_modalias);
+	if (rc)
+		goto err_enab;
 
 	return 0;
 
 err_enab:
-	device_remove_file (&edev->dev, &dev_attr_enabled);
+	device_remove_file(&edev->dev, &dev_attr_enabled);
 err_sig:
-	device_remove_file (&edev->dev, &dev_attr_signature);
+	device_remove_file(&edev->dev, &dev_attr_signature);
 err_devreg:
 	device_unregister(&edev->dev);
 	return rc;
 }
 
-static int __init eisa_request_resources (struct eisa_root_device *root,
-					  struct eisa_device *edev,
-					  int slot)
+static int __init eisa_request_resources(struct eisa_root_device *root,
+					 struct eisa_device *edev,
+					 int slot)
 {
 	int i;
 
@@ -263,17 +276,19 @@ static int __init eisa_request_resources
 		
 		if (slot) {
 			edev->res[i].name  = NULL;
-			edev->res[i].start = SLOT_ADDRESS (root, slot) + (i * 0x400);
+			edev->res[i].start = SLOT_ADDRESS(root, slot)
+					     + (i * 0x400);
 			edev->res[i].end   = edev->res[i].start + 0xff;
 			edev->res[i].flags = IORESOURCE_IO;
 		} else {
 			edev->res[i].name  = NULL;
-			edev->res[i].start = SLOT_ADDRESS (root, slot) + EISA_VENDOR_ID_OFFSET;
+			edev->res[i].start = SLOT_ADDRESS(root, slot)
+					     + EISA_VENDOR_ID_OFFSET;
 			edev->res[i].end   = edev->res[i].start + 3;
 			edev->res[i].flags = IORESOURCE_BUSY;
 		}
 
-		if (request_resource (root->res, &edev->res[i]))
+		if (request_resource(root->res, &edev->res[i]))
 			goto failed;
 	}
 
@@ -281,99 +296,100 @@ static int __init eisa_request_resources
 	
  failed:
 	while (--i >= 0)
-		release_resource (&edev->res[i]);
+		release_resource(&edev->res[i]);
 
 	return -1;
 }
 
-static void __init eisa_release_resources (struct eisa_device *edev)
+static void __init eisa_release_resources(struct eisa_device *edev)
 {
 	int i;
 
 	for (i = 0; i < EISA_MAX_RESOURCES; i++)
 		if (edev->res[i].start || edev->res[i].end)
-			release_resource (&edev->res[i]);
+			release_resource(&edev->res[i]);
 }
 
-static int __init eisa_probe (struct eisa_root_device *root)
+static int __init eisa_probe(struct eisa_root_device *root)
 {
         int i, c;
 	struct eisa_device *edev;
 
-        printk (KERN_INFO "EISA: Probing bus %d at %s\n",
-		root->bus_nr, dev_name(root->dev));
+	printk(KERN_INFO "EISA: Probing bus %d at %s\n",
+	       root->bus_nr, dev_name(root->dev));
 
 	/* First try to get hold of slot 0. If there is no device
 	 * here, simply fail, unless root->force_probe is set. */
 	
-	if (!(edev = kzalloc (sizeof (*edev), GFP_KERNEL))) {
-		printk (KERN_ERR "EISA: Couldn't allocate mainboard slot\n");
+	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+	if (!edev) {
+		printk(KERN_ERR "EISA: Couldn't allocate mainboard slot\n");
 		return -ENOMEM;
 	}
 		
-	if (eisa_request_resources (root, edev, 0)) {
-		printk (KERN_WARNING \
-			"EISA: Cannot allocate resource for mainboard\n");
-		kfree (edev);
+	if (eisa_request_resources(root, edev, 0)) {
+		printk(KERN_WARNING \
+		       "EISA: Cannot allocate resource for mainboard\n");
+		kfree(edev);
 		if (!root->force_probe)
 			return -EBUSY;
 		goto force_probe;
 	}
 
-	if (eisa_init_device (root, edev, 0)) {
-		eisa_release_resources (edev);
-		kfree (edev);
+	if (eisa_init_device(root, edev, 0)) {
+		eisa_release_resources(edev);
+		kfree(edev);
 		if (!root->force_probe)
 			return -ENODEV;
 		goto force_probe;
 	}
 
-	printk (KERN_INFO "EISA: Mainboard %s detected.\n", edev->id.sig);
+	printk(KERN_INFO "EISA: Mainboard %s detected.\n", edev->id.sig);
 
-	if (eisa_register_device (edev)) {
-		printk (KERN_ERR "EISA: Failed to register %s\n",
-			edev->id.sig);
-		eisa_release_resources (edev);
-		kfree (edev);
+	if (eisa_register_device(edev)) {
+		printk(KERN_ERR "EISA: Failed to register %s\n",
+		       edev->id.sig);
+		eisa_release_resources(edev);
+		kfree(edev);
 	}
 	
  force_probe:
 	
         for (c = 0, i = 1; i <= root->slots; i++) {
-		if (!(edev = kzalloc (sizeof (*edev), GFP_KERNEL))) {
-			printk (KERN_ERR "EISA: Out of memory for slot %d\n",
-				i);
+		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+		if (!edev) {
+			printk(KERN_ERR "EISA: Out of memory for slot %d\n", i);
 			continue;
 		}
 
-		if (eisa_request_resources (root, edev, i)) {
-			printk (KERN_WARNING \
-				"Cannot allocate resource for EISA slot %d\n",
-				i);
-			kfree (edev);
+		if (eisa_request_resources(root, edev, i)) {
+			printk(KERN_WARNING \
+			       "Cannot allocate resource for EISA slot %d\n",
+			       i);
+			kfree(edev);
 			continue;
 		}
 
-                if (eisa_init_device (root, edev, i)) {
-			eisa_release_resources (edev);
-			kfree (edev);
+		if (eisa_init_device(root, edev, i)) {
+			eisa_release_resources(edev);
+			kfree(edev);
 			continue;
 		}
 		
-		printk (KERN_INFO "EISA: slot %d : %s detected",
-			i, edev->id.sig);
+		printk(KERN_INFO "EISA: slot %d : %s detected",
+		       i, edev->id.sig);
 			
 		switch (edev->state) {
 		case EISA_CONFIG_ENABLED | EISA_CONFIG_FORCED:
-			printk (" (forced enabled)");
+			printk(" (forced enabled)");
 			break;
 
 		case EISA_CONFIG_FORCED:
-			printk (" (forced disabled)");
+			printk(" (forced disabled)");
 			break;
 
 		case 0:
-			printk (" (disabled)");
+			printk(" (disabled)");
 			break;
 		}
 			
@@ -381,15 +397,15 @@ static int __init eisa_probe (struct eis
 
 		c++;
 
-		if (eisa_register_device (edev)) {
-			printk (KERN_ERR "EISA: Failed to register %s\n",
-				edev->id.sig);
-			eisa_release_resources (edev);
-			kfree (edev);
+		if (eisa_register_device(edev)) {
+			printk(KERN_ERR "EISA: Failed to register %s\n",
+			       edev->id.sig);
+			eisa_release_resources(edev);
+			kfree(edev);
 		}
         }
 
-        printk (KERN_INFO "EISA: Detected %d card%s.\n", c, c == 1 ? "" : "s");
+	printk(KERN_INFO "EISA: Detected %d card%s.\n", c, c == 1 ? "" : "s");
 
 	return 0;
 }
@@ -403,7 +419,7 @@ static struct resource eisa_root_res = {
 
 static int eisa_bus_count;
 
-int __init eisa_root_register (struct eisa_root_device *root)
+int __init eisa_root_register(struct eisa_root_device *root)
 {
 	int err;
 
@@ -417,35 +433,35 @@ int __init eisa_root_register (struct ei
 	root->eisa_root_res.end   = root->res->end;
 	root->eisa_root_res.flags = IORESOURCE_BUSY;
 
-	if ((err = request_resource (&eisa_root_res, &root->eisa_root_res)))
+	err = request_resource(&eisa_root_res, &root->eisa_root_res);
+	if (err)
 		return err;
 	
 	root->bus_nr = eisa_bus_count++;
 
-	if ((err = eisa_probe (root)))
-		release_resource (&root->eisa_root_res);
+	err = eisa_probe(root);
+	if (err)
+		release_resource(&root->eisa_root_res);
 
 	return err;
 }
 
-static int __init eisa_init (void)
+static int __init eisa_init(void)
 {
 	int r;
 	
-	if ((r = bus_register (&eisa_bus_type)))
+	r = bus_register(&eisa_bus_type);
+	if (r)
 		return r;
 
-	printk (KERN_INFO "EISA bus registered\n");
+	printk(KERN_INFO "EISA bus registered\n");
 	return 0;
 }
 
 module_param_array(enable_dev, int, &enable_dev_count, 0444);
 module_param_array(disable_dev, int, &disable_dev_count, 0444);
 
-postcore_initcall (eisa_init);
+postcore_initcall(eisa_init);
 
 int EISA_bus;		/* for legacy drivers */
-EXPORT_SYMBOL (EISA_bus);
-EXPORT_SYMBOL (eisa_bus_type);
-EXPORT_SYMBOL (eisa_driver_register);
-EXPORT_SYMBOL (eisa_driver_unregister);
+EXPORT_SYMBOL(EISA_bus);
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
doc-document-nopat-parameter.patch
eisa-fix-coding-style-for-eisa-bus-code.patch

