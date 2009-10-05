From: akpm@linux-foundation.org
Subject: [merged] icom-converting-space-to-tabs.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:17 -0700
Message-ID: <200910051839.n95IdHuS018736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbZJESkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, Scott.Kilau@digi.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     icom: convert space to tabs
has been removed from the -mm tree.  Its filename was
     icom-converting-space-to-tabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: icom: convert space to tabs
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Convert spaces to tabs and remove wrong spaces

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |   54 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff -puN drivers/serial/icom.c~icom-converting-space-to-tabs drivers/serial/icom.c
--- a/drivers/serial/icom.c~icom-converting-space-to-tabs
+++ a/drivers/serial/icom.c
@@ -307,7 +307,7 @@ static void stop_processor(struct icom_p
 	if (port < 4) {
 		temp = readl(stop_proc[port].global_control_reg);
 		temp =
-	    		(temp & ~start_proc[port].processor_id) | stop_proc[port].processor_id;
+			(temp & ~start_proc[port].processor_id) | stop_proc[port].processor_id;
 		writel(temp, stop_proc[port].global_control_reg);
 
 		/* write flush */
@@ -336,7 +336,7 @@ static void start_processor(struct icom_
 	if (port < 4) {
 		temp = readl(start_proc[port].global_control_reg);
 		temp =
-	    		(temp & ~stop_proc[port].processor_id) | start_proc[port].processor_id;
+			(temp & ~stop_proc[port].processor_id) | start_proc[port].processor_id;
 		writel(temp, start_proc[port].global_control_reg);
 
 		/* write flush */
@@ -509,8 +509,8 @@ static void load_code(struct icom_port *
 		dev_err(&icom_port->adapter->pci_dev->dev,"Port not opertional\n");
 	}
 
-      if (new_page != NULL)
-	      pci_free_consistent(dev, 4096, new_page, temp_pci);
+	if (new_page != NULL)
+		pci_free_consistent(dev, 4096, new_page, temp_pci);
 }
 
 static int startup(struct icom_port *icom_port)
@@ -1493,15 +1493,15 @@ static int __devinit icom_probe(struct p
 				const struct pci_device_id *ent)
 {
 	int index;
-        unsigned int command_reg;
-        int retval;
-        struct icom_adapter *icom_adapter;
-        struct icom_port *icom_port;
+	unsigned int command_reg;
+	int retval;
+	struct icom_adapter *icom_adapter;
+	struct icom_port *icom_port;
 
-        retval = pci_enable_device(dev);
-        if (retval) {
+	retval = pci_enable_device(dev);
+	if (retval) {
 		dev_err(&dev->dev, "Device enable FAILED\n");
-                return retval;
+		return retval;
 	}
 
 	if ( (retval = pci_request_regions(dev, "icom"))) {
@@ -1510,23 +1510,23 @@ static int __devinit icom_probe(struct p
 		 return retval;
 	 }
 
-        pci_set_master(dev);
+	pci_set_master(dev);
 
-        if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
+	if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-                return retval;
-        }
+		return retval;
+	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
 		command_reg | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER
  		| PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
-        if (ent->driver_data == ADAPTER_V1) {
+	if (ent->driver_data == ADAPTER_V1) {
 		pci_write_config_dword(dev, 0x44, 0x8300830A);
-	 } else {
+	} else {
 		pci_write_config_dword(dev, 0x44, 0x42004200);
 		pci_write_config_dword(dev, 0x48, 0x42004200);
-         }
+	}
 
 
 	retval = icom_alloc_adapter(&icom_adapter);
@@ -1536,10 +1536,10 @@ static int __devinit icom_probe(struct p
 		 goto probe_exit0;
 	}
 
-	 icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
-	 icom_adapter->pci_dev = dev;
-	 icom_adapter->version = ent->driver_data;
-	 icom_adapter->subsystem_id = ent->subdevice;
+	icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
+	icom_adapter->pci_dev = dev;
+	icom_adapter->version = ent->driver_data;
+	icom_adapter->subsystem_id = ent->subdevice;
 
 
 	retval = icom_init_ports(icom_adapter);
@@ -1548,7 +1548,7 @@ static int __devinit icom_probe(struct p
 		goto probe_exit1;
 	}
 
-	 icom_adapter->base_addr = pci_ioremap_bar(dev, 0);
+	icom_adapter->base_addr = pci_ioremap_bar(dev, 0);
 
 	if (!icom_adapter->base_addr)
 		goto probe_exit1;
@@ -1562,7 +1562,7 @@ static int __devinit icom_probe(struct p
 
 	retval = icom_load_ports(icom_adapter);
 
-        for (index = 0; index < icom_adapter->numb_ports; index++) {
+	for (index = 0; index < icom_adapter->numb_ports; index++) {
 		icom_port = &icom_adapter->port_info[index];
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
@@ -1579,7 +1579,7 @@ static int __devinit icom_probe(struct p
 				icom_port->status = ICOM_PORT_OFF;
 				dev_err(&dev->dev, "Device add failed\n");
 			 } else
-			        dev_info(&dev->dev, "Device added\n");
+				dev_info(&dev->dev, "Device added\n");
 		}
 	}
 
@@ -1595,9 +1595,7 @@ probe_exit0:
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 
-        return retval;
-
