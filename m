From: akpm@linux-foundation.org
Subject: + ehea-dynamic-add--remove-port-update.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:17:20 -0800
Message-ID: <200702251317.l1PDHMvO030099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960AbXBYNU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:20:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ossthema@de.ibm.com, johnrose@austin.ibm.com, themann@de.ibm.com


The patch titled
     ehea: dynamic add / remove port (update)
has been added to the -mm tree.  Its filename is
     ehea-dynamic-add--remove-port-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehea: dynamic add / remove port (update)
From: Jan-Bernd Themann <ossthema@de.ibm.com>

This patch introduces functionality to dynamically add / remove ehea ports
via an userspace DLPAR tool.  It creates a subnode for each logical port in
the sysfs.

This subnode contains the following attributes:
- link to ethX that represents the port
- logical port number
- path in the OFDT (devspec)

Logical ports can be added / removed by writing the logical
port id into the probe_port / remove_port file located in
the lhea adapter directory.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
Acked-by: John Rose <johnrose@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    4 
 drivers/net/ehea/ehea_main.c |  144 ++++++++++++++++++++++++++++-----
 2 files changed, 126 insertions(+), 22 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-dynamic-add--remove-port-update drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-dynamic-add--remove-port-update
+++ a/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0047"
+#define DRV_VERSION	"EHEA_0048"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
@@ -407,7 +407,7 @@ struct ehea_port {
 	struct net_device *netdev;
 	struct net_device_stats stats;
 	struct ehea_port_res port_res[EHEA_MAX_PORT_RES];
-	struct device_node *of_dev_node; /* Open Firmware Device Node */
+	struct of_device  ofdev; /* Open Firmware Device */
 	struct ehea_mc_list *mc_list;	 /* Multicast MAC addresses */
 	struct vlan_group *vgrp;
 	struct ehea_eq *qp_eq;
diff -puN drivers/net/ehea/ehea_main.c~ehea-dynamic-add--remove-port-update drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-dynamic-add--remove-port-update
+++ a/drivers/net/ehea/ehea_main.c
@@ -2342,12 +2342,67 @@ out:
 	return ret;
 }
 
+static ssize_t ehea_show_port_id(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ehea_port *port = container_of(dev, struct ehea_port, ofdev.dev);
+	return sprintf(buf, "0x%X", port->logical_port_id);
+}
+
+static DEVICE_ATTR(log_port_id, S_IRUSR | S_IRGRP | S_IROTH, ehea_show_port_id,
+		   NULL);
+
+static void __devinit logical_port_release(struct device *dev)
+{
+	struct ehea_port *port = container_of(dev, struct ehea_port, ofdev.dev);
+	of_node_put(port->ofdev.node);
+}
+
+static struct device *ehea_register_port(struct ehea_port *port,
+					 struct device_node *dn)
+{
+	int ret;
+
+	port->ofdev.node = of_node_get(dn);
+	port->ofdev.dev.parent = &port->adapter->ebus_dev->ofdev.dev;
+
+	sprintf(port->ofdev.dev.bus_id, "port%d", port->logical_port_id);
+	port->ofdev.dev.release = logical_port_release;
+
+	ret = of_device_register(&port->ofdev);
+	if (ret) {
+		ehea_error("failed to register device. ret=%d", ret);
+		goto out;
+	}
+
+	ret = device_create_file(&port->ofdev.dev, &dev_attr_log_port_id);
+        if (ret) {
+		ehea_error("failed to register attributes, ret=%d", ret);
+		goto out_unreg_of_dev;
+	}
+
+	return &port->ofdev.dev;
+
+out_unreg_of_dev:
+	of_device_unregister(&port->ofdev);
+out:
+	return NULL;
+}
+
+static void ehea_unregister_port(struct ehea_port *port)
+{
+	device_remove_file(&port->ofdev.dev, &dev_attr_log_port_id);
+	of_device_unregister(&port->ofdev);
+}
+
 struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
-					 u32 logical_port_id)
+					 u32 logical_port_id,
+					 struct device_node *dn)
 {
 	int ret;
 	struct net_device *dev;
 	struct ehea_port *port;
+	struct device *port_dev;
 	int jumbo;
 
 	/* allocate memory for the port structures */
@@ -2383,6 +2438,12 @@ struct ehea_port *ehea_setup_single_port
 	if (ret)
 		goto out_free_mc_list;
 
+	port_dev = ehea_register_port(port, dn);
+	if (!port_dev)
+		goto out_free_mc_list;
+
+	SET_NETDEV_DEV(dev, port_dev);
+
 	/* initialize net_device structure */
 	SET_MODULE_OWNER(dev);
 
@@ -2414,20 +2475,22 @@ struct ehea_port *ehea_setup_single_port
 	ret = register_netdev(dev);
 	if (ret) {
 		ehea_error("register_netdev failed. ret=%d", ret);
-		goto out_free_mc_list;
+		goto out_unreg_port;
 	}
 
 	ret = ehea_get_jumboframe_status(port, &jumbo);
-	if (ret) {
+	if (ret)
 		ehea_error("failed determining jumbo frame status for %s",
 			   port->netdev->name);
-	}
 
 	ehea_info("%s: Jumbo frames are %sabled", dev->name,
 		  jumbo == 1 ? "en" : "dis");
 
 	return port;
 
+out_unreg_port:
+	ehea_unregister_port(port);
+
 out_free_mc_list:
 	kfree(port->mc_list);
 
@@ -2443,13 +2506,14 @@ out_err:
 static void ehea_shutdown_single_port(struct ehea_port *port)
 {
 	unregister_netdev(port->netdev);
+	ehea_unregister_port(port);
 	kfree(port->mc_list);
 	free_netdev(port->netdev);
 }
 
 static int ehea_setup_ports(struct ehea_adapter *adapter)
 {
-	struct device_node *lhea_dn = NULL;
+	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
 
 	u32 *dn_log_port_id;
@@ -2465,18 +2529,20 @@ static int ehea_setup_ports(struct ehea_
 		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (!dn_log_port_id) {
-			ehea_error("bad device node: dn_log_port_id=%p",
-				   dn_log_port_id);
+			ehea_error("bad device node: eth_dn name=%s",
+				   eth_dn->full_name);
 			continue;
 		}
 
 		adapter->port[i] = ehea_setup_single_port(adapter,
-							  *dn_log_port_id);
-
-		ehea_info("%s -> logial port id #%d",
-			  adapter->port[i]->netdev->name, *dn_log_port_id);
+							  *dn_log_port_id,
+							  eth_dn);
+		if (adapter->port[i])
+			ehea_info("%s -> logical port id #%d",
+				  adapter->port[i]->netdev->name,
+				  *dn_log_port_id);
 		i++;
-	} while ( eth_dn );
+	} while (eth_dn);
 
 	of_node_put(lhea_dn);
 
@@ -2487,8 +2553,35 @@ static int ehea_setup_ports(struct ehea_
 
 	if (port_setup_ok)
 		return 0;	/* At least some ports are setup correctly */
-	else
-		return -EINVAL;
+
+	return -EINVAL;
+}
+
+static struct device_node *ehea_get_eth_dn(struct ehea_adapter *adapter,
+					   u32 logical_port_id)
+{
+	struct device_node *lhea_dn;
+	struct device_node *eth_dn = NULL;
+	u32 *dn_log_port_id;
+
+	lhea_dn = adapter->ebus_dev->ofdev.node;
+	do {
+		eth_dn = of_get_next_child(lhea_dn, eth_dn);
+		if (!eth_dn)
+			break;
+
+		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+						    NULL);
+
+		if (dn_log_port_id)
+			if (*dn_log_port_id == logical_port_id)
+				return eth_dn;
+
+	} while (eth_dn);
+
+	of_node_put(lhea_dn);
+
+	return NULL;
 }
 
 static ssize_t ehea_probe_port(struct device *dev,
@@ -2497,10 +2590,12 @@ static ssize_t ehea_probe_port(struct de
 {
 	struct ehea_adapter *adapter = dev->driver_data;
 	struct ehea_port *port;
+	struct device_node *eth_dn = NULL;
 	int i;
+
 	u32 logical_port_id;
 
-	sscanf(buf, "%d", &logical_port_id);
+	sscanf(buf, "%X", &logical_port_id);
 
 	port = ehea_get_port(adapter, logical_port_id);
 
@@ -2508,10 +2603,17 @@ static ssize_t ehea_probe_port(struct de
 		ehea_info("adding port with logical port id=%d failed. port "
 			  "already configured as %s.", logical_port_id,
 			  port->netdev->name);
-		goto out;
+		return -EINVAL;
 	}
 
-	port = ehea_setup_single_port(adapter, logical_port_id);
+	eth_dn = ehea_get_eth_dn(adapter, logical_port_id);
+
+	if (!eth_dn) {
+		ehea_info("no logical port with id %d found", logical_port_id);
+		return -EINVAL;
+	}
+
+	port = ehea_setup_single_port(adapter, logical_port_id, eth_dn);
 
 	if (port) {
 		for (i=0; i < EHEA_MAX_PORTS; i++)
@@ -2522,8 +2624,9 @@ static ssize_t ehea_probe_port(struct de
 
 		ehea_info("added %s (logical port id=%d)", port->netdev->name,
 			  logical_port_id);
-	}
-out:
+	} else
+		return -EIO;
+
 	return (ssize_t) count;
 }
 
@@ -2536,7 +2639,7 @@ static ssize_t ehea_remove_port(struct d
 	int i;
 	u32 logical_port_id;
 
-	sscanf(buf, "%d", &logical_port_id);
+	sscanf(buf, "%X", &logical_port_id);
 
 	port = ehea_get_port(adapter, logical_port_id);
 
@@ -2554,6 +2657,7 @@ static ssize_t ehea_remove_port(struct d
 	} else {
 		ehea_error("removing port with logical port id=%d failed. port "
 			   "not configured.", logical_port_id);
+		return -EINVAL;
 	}
 
 	return (ssize_t) count;
_

Patches currently in -mm which might be from ossthema@de.ibm.com are

ehea-dynamic-add--remove-port.patch
ehea-dynamic-add--remove-port-update.patch
