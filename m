From: akpm@linux-foundation.org
Subject: - serial-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:33 -0800
Message-ID: <200702150847.l1F8lXbb024989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965294AbXBOIrg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     serial: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     serial-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_acorn.c     |    3 +--
 drivers/serial/8250_pci.c       |    5 +----
 drivers/serial/icom.c           |    4 +---
 drivers/serial/ioc3_serial.c    |    6 ++----
 drivers/serial/ioc4_serial.c    |    9 +++------
 drivers/serial/ip22zilog.c      |    8 +-------
 drivers/serial/jsm/jsm_driver.c |    6 ++----
 drivers/serial/jsm/jsm_tty.c    |   12 ++++--------
 drivers/serial/serial_core.c    |    7 ++-----
 drivers/serial/serial_cs.c      |    3 +--
 10 files changed, 18 insertions(+), 45 deletions(-)

diff -puN drivers/serial/8250_acorn.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/8250_acorn.c
--- a/drivers/serial/8250_acorn.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/8250_acorn.c
@@ -47,11 +47,10 @@ serial_card_probe(struct expansion_card 
 	unsigned long bus_addr;
 	unsigned int i;
 
-	info = kmalloc(sizeof(struct serial_card_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct serial_card_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct serial_card_info));
 	info->num_ports = type->num_ports;
 
 	bus_addr = ecard_resource_start(ec, type->type);
diff -puN drivers/serial/8250_pci.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/8250_pci.c
@@ -1628,7 +1628,7 @@ pciserial_init_ports(struct pci_dev *dev
 			nr_ports = rc;
 	}
 
-	priv = kmalloc(sizeof(struct serial_private) +
+	priv = kzalloc(sizeof(struct serial_private) +
 		       sizeof(unsigned int) * nr_ports,
 		       GFP_KERNEL);
 	if (!priv) {
@@ -1636,9 +1636,6 @@ pciserial_init_ports(struct pci_dev *dev
 		goto err_deinit;
 	}
 
-	memset(priv, 0, sizeof(struct serial_private) +
-			sizeof(unsigned int) * nr_ports);
-
 	priv->dev = dev;
 	priv->quirk = quirk;
 
diff -puN drivers/serial/icom.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/icom.c
--- a/drivers/serial/icom.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/icom.c
@@ -1417,14 +1417,12 @@ static int __devinit icom_alloc_adapter(
 	struct list_head *tmp;
 
 	icom_adapter = (struct icom_adapter *)
-	    kmalloc(sizeof(struct icom_adapter), GFP_KERNEL);
+	    kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
 
 	if (!icom_adapter) {
 		return -ENOMEM;
 	}
 
-	memset(icom_adapter, 0, sizeof(struct icom_adapter));
-
 	list_for_each(tmp, &icom_adapter_head) {
 		cur_adapter_entry =
 		    list_entry(tmp, struct icom_adapter,
diff -puN drivers/serial/ioc3_serial.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/ioc3_serial.c
--- a/drivers/serial/ioc3_serial.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/ioc3_serial.c
@@ -2019,13 +2019,12 @@ ioc3uart_probe(struct ioc3_submodule *is
 
 	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __FUNCTION__, is, idd));
 
-	card_ptr = kmalloc(sizeof(struct ioc3_card), GFP_KERNEL);
+	card_ptr = kzalloc(sizeof(struct ioc3_card), GFP_KERNEL);
 	if (!card_ptr) {
 		printk(KERN_WARNING "ioc3_attach_one"
 		       ": unable to get memory for the IOC3\n");
 		return -ENOMEM;
 	}
-	memset(card_ptr, 0, sizeof(struct ioc3_card));
 	idd->data[is->id] = card_ptr;
 	Submodule_slot = is->id;
 
@@ -2040,13 +2039,12 @@ ioc3uart_probe(struct ioc3_submodule *is
 
 	/* Create port structures for each port */
 	for (phys_port = 0; phys_port < PORTS_PER_CARD; phys_port++) {
-		port = kmalloc(sizeof(struct ioc3_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct ioc3_port), GFP_KERNEL);
 		if (!port) {
 			printk(KERN_WARNING
 			       "IOC3 serial memory not available for port\n");
 			goto out4;
 		}
-		memset(port, 0, sizeof(struct ioc3_port));
 		spin_lock_init(&port->ip_lock);
 
 		/* we need to remember the previous ones, to point back to
diff -puN drivers/serial/ioc4_serial.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/ioc4_serial.c
@@ -1076,13 +1076,12 @@ static int inline ioc4_attach_local(stru
 	/* Create port structures for each port */
 	for (port_number = 0; port_number < IOC4_NUM_SERIAL_PORTS;
 							port_number++) {
-		port = kmalloc(sizeof(struct ioc4_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct ioc4_port), GFP_KERNEL);
 		if (!port) {
 			printk(KERN_WARNING
 				"IOC4 serial memory not available for port\n");
 			return -ENOMEM;
 		}
-		memset(port, 0, sizeof(struct ioc4_port));
 		spin_lock_init(&port->ip_lock);
 
 		/* we need to remember the previous ones, to point back to
@@ -2811,7 +2810,7 @@ ioc4_serial_attach_one(struct ioc4_drive
 				(void *)serial));
 
 	/* Get memory for the new card */
-	control = kmalloc(sizeof(struct ioc4_control), GFP_KERNEL);
+	control = kzalloc(sizeof(struct ioc4_control), GFP_KERNEL);
 
 	if (!control) {
 		printk(KERN_WARNING "ioc4_attach_one"
@@ -2819,11 +2818,10 @@ ioc4_serial_attach_one(struct ioc4_drive
 		ret = -ENOMEM;
 		goto out2;
 	}
-	memset(control, 0, sizeof(struct ioc4_control));
 	idd->idd_serial_data = control;
 
 	/* Allocate the soft structure */
-	soft = kmalloc(sizeof(struct ioc4_soft), GFP_KERNEL);
+	soft = kzalloc(sizeof(struct ioc4_soft), GFP_KERNEL);
 	if (!soft) {
 		printk(KERN_WARNING
 		       "ioc4 (%p): unable to get memory for the soft struct\n",
@@ -2831,7 +2829,6 @@ ioc4_serial_attach_one(struct ioc4_drive
 		ret = -ENOMEM;
 		goto out3;
 	}
-	memset(soft, 0, sizeof(struct ioc4_soft));
 
 	spin_lock_init(&soft->is_ir_lock);
 	soft->is_ioc4_misc_addr = idd->idd_misc_regs;
diff -puN drivers/serial/ip22zilog.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/ip22zilog.c
--- a/drivers/serial/ip22zilog.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/ip22zilog.c
@@ -922,13 +922,7 @@ static int zilog_irq = -1;
 
 static void * __init alloc_one_table(unsigned long size)
 {
-	void *ret;
-
-	ret = kmalloc(size, GFP_KERNEL);
-	if (ret != NULL)
-		memset(ret, 0, size);
-
-	return ret;
+	return kzalloc(size, GFP_KERNEL);
 }
 
 static void __init ip22zilog_alloc_tables(void)
diff -puN drivers/serial/jsm/jsm_driver.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -71,14 +71,13 @@ static int jsm_probe_one(struct pci_dev 
 		goto out_disable_device;
 	}
 
-	brd = kmalloc(sizeof(struct jsm_board), GFP_KERNEL);
+	brd = kzalloc(sizeof(struct jsm_board), GFP_KERNEL);
 	if (!brd) {
 		dev_err(&pdev->dev,
 			"memory allocation for board structure failed\n");
 		rc = -ENOMEM;
 		goto out_release_regions;
 	}
-	memset(brd, 0, sizeof(struct jsm_board));
 
 	/* store the info for the board we've found */
 	brd->boardnum = adapter_count++;
@@ -152,7 +151,7 @@ static int jsm_probe_one(struct pci_dev 
 	 * Okay to malloc with GFP_KERNEL, we are not at interrupt
 	 * context, and there are no locks held.
 	 */
-	brd->flipbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
+	brd->flipbuf = kzalloc(MYFLIPLEN, GFP_KERNEL);
 	if (!brd->flipbuf) {
 		/* XXX: leaking all resources from jsm_tty_init and
 		 	jsm_uart_port_init here! */
@@ -160,7 +159,6 @@ static int jsm_probe_one(struct pci_dev 
 		retval = -ENOMEM;
 		goto out_free_irq;
 	}
-	memset(brd->flipbuf, 0, MYFLIPLEN);
 
 	pci_set_drvdata(pdev, brd);
 
diff -puN drivers/serial/jsm/jsm_tty.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -194,31 +194,28 @@ static int jsm_tty_open(struct uart_port
 	/* Drop locks, as malloc with GFP_KERNEL can sleep */
 
 	if (!channel->ch_rqueue) {
-		channel->ch_rqueue = (u8 *) kmalloc(RQUEUESIZE, GFP_KERNEL);
+		channel->ch_rqueue = kzalloc(RQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_rqueue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate read queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_rqueue, 0, RQUEUESIZE);
 	}
 	if (!channel->ch_equeue) {
-		channel->ch_equeue = (u8 *) kmalloc(EQUEUESIZE, GFP_KERNEL);
+		channel->ch_equeue = kzalloc(EQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_equeue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate error queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_equeue, 0, EQUEUESIZE);
 	}
 	if (!channel->ch_wqueue) {
-		channel->ch_wqueue = (u8 *) kmalloc(WQUEUESIZE, GFP_KERNEL);
+		channel->ch_wqueue = kzalloc(WQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_wqueue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate write queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_wqueue, 0, WQUEUESIZE);
 	}
 
 	channel->ch_flags &= ~(CH_OPENING);
@@ -392,13 +389,12 @@ int jsm_tty_init(struct jsm_board *brd)
 			 * Okay to malloc with GFP_KERNEL, we are not at
 			 * interrupt context, and there are no locks held.
 			 */
-			brd->channels[i] = kmalloc(sizeof(struct jsm_channel), GFP_KERNEL);
+			brd->channels[i] = kzalloc(sizeof(struct jsm_channel), GFP_KERNEL);
 			if (!brd->channels[i]) {
 				jsm_printk(CORE, ERR, &brd->pci_dev,
 					"%s:%d Unable to allocate memory for channel struct\n",
 							 __FILE__, __LINE__);
 			}
-			memset(brd->channels[i], 0, sizeof(struct jsm_channel));
 		}
 	}
 
diff -puN drivers/serial/serial_core.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/serial_core.c
@@ -1523,9 +1523,8 @@ static struct uart_state *uart_get(struc
 	}
 
 	if (!state->info) {
-		state->info = kmalloc(sizeof(struct uart_info), GFP_KERNEL);
+		state->info = kzalloc(sizeof(struct uart_info), GFP_KERNEL);
 		if (state->info) {
-			memset(state->info, 0, sizeof(struct uart_info));
 			init_waitqueue_head(&state->info->open_wait);
 			init_waitqueue_head(&state->info->delta_msr_wait);
 
@@ -2178,13 +2177,11 @@ int uart_register_driver(struct uart_dri
 	 * Maybe we should be using a slab cache for this, especially if
 	 * we have a large number of ports to handle.
 	 */
-	drv->state = kmalloc(sizeof(struct uart_state) * drv->nr, GFP_KERNEL);
+	drv->state = kzalloc(sizeof(struct uart_state) * drv->nr, GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!drv->state)
 		goto out;
 
-	memset(drv->state, 0, sizeof(struct uart_state) * drv->nr);
-
 	normal  = alloc_tty_driver(drv->nr);
 	if (!normal)
 		goto out;
diff -puN drivers/serial/serial_cs.c~serial-replace-kmallocmemset-with-kzalloc drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~serial-replace-kmallocmemset-with-kzalloc
+++ a/drivers/serial/serial_cs.c
@@ -334,10 +334,9 @@ static int serial_probe(struct pcmcia_de
 	DEBUG(0, "serial_attach()\n");
 
 	/* Create new serial device */
-	info = kmalloc(sizeof (*info), GFP_KERNEL);
+	info = kzalloc(sizeof (*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-	memset(info, 0, sizeof (*info));
 	info->p_dev = link;
 	link->priv = info;
 
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
