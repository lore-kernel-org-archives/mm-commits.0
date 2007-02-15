From: akpm@linux-foundation.org
Subject: + ehea-dynamic-add--remove-port.patch added to -mm tree
Date: Wed, 14 Feb 2007 19:12:11 -0800
Message-ID: <200702150312.l1F3CBjZ018368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbXBODMX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 22:12:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ossthema@de.ibm.com, themann@de.ibm.com


The patch titled
     ehea: dynamic add / remove port
has been added to the -mm tree.  Its filename is
     ehea-dynamic-add--remove-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehea: dynamic add / remove port
From: Jan-Bernd Themann <ossthema@de.ibm.com>

This patch enables dynamic adding / removing of ehea ports
by DLPAR tool.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    7 
 drivers/net/ehea/ehea_main.c |  335 +++++++++++++++++++++------------
 2 files changed, 218 insertions(+), 124 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-dynamic-add--remove-port drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-dynamic-add--remove-port
+++ a/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0046"
+#define DRV_VERSION	"EHEA_0047"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
@@ -380,10 +380,11 @@ struct ehea_port_res {
 };
 
 
+#define EHEA_MAX_PORTS 16
 struct ehea_adapter {
 	u64 handle;
-	u8 num_ports;
-	struct ehea_port *port[16];
+	struct ibmebus_dev *ebus_dev;
+	struct ehea_port *port[EHEA_MAX_PORTS];
 	struct ehea_eq *neq;       /* notification event queue */
 	struct workqueue_struct *ehea_wq;
 	struct tasklet_struct neq_tasklet;
diff -puN drivers/net/ehea/ehea_main.c~ehea-dynamic-add--remove-port drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-dynamic-add--remove-port
+++ a/drivers/net/ehea/ehea_main.c
@@ -580,7 +580,7 @@ static struct ehea_port *ehea_get_port(s
 {
 	int i;
 
-	for (i = 0; i < adapter->num_ports; i++)
+	for (i = 0; i < EHEA_MAX_PORTS; i++)
 		if (adapter->port[i])
 	                if (adapter->port[i]->logical_port_id == logical_port)
 				return adapter->port[i];
@@ -2274,8 +2274,6 @@ static void ehea_tx_watchdog(struct net_
 int ehea_sense_adapter_attr(struct ehea_adapter *adapter)
 {
 	struct hcp_query_ehea *cb;
-	struct device_node *lhea_dn = NULL;
-	struct device_node *eth_dn = NULL;
 	u64 hret;
 	int ret;
 
@@ -2292,18 +2290,6 @@ int ehea_sense_adapter_attr(struct ehea_
 		goto out_herr;
 	}
 
-	/* Determine the number of available logical ports
-	 * by counting the child nodes of the lhea OFDT entry
-	 */
-	adapter->num_ports = 0;
-	lhea_dn = of_find_node_by_name(lhea_dn, "lhea");
-	do {
-		eth_dn = of_get_next_child(lhea_dn, eth_dn);
-		if (eth_dn)
-			adapter->num_ports++;
-	} while ( eth_dn );
-	of_node_put(lhea_dn);
-
 	adapter->max_mc_mac = cb->max_mc_mac - 1;
 	ret = 0;
 
@@ -2313,79 +2299,89 @@ out:
 	return ret;
 }
 
-static int ehea_setup_single_port(struct ehea_port *port,
-				  struct device_node *dn)
+int ehea_get_jumboframe_status(struct ehea_port *port, int *jumbo)
 {
-	int ret;
-	u64 hret;
-	struct net_device *dev = port->netdev;
-	struct ehea_adapter *adapter = port->adapter;
 	struct hcp_ehea_port_cb4 *cb4;
-	u32 *dn_log_port_id;
-	int jumbo = 0;
-
-	sema_init(&port->port_lock, 1);
-	port->state = EHEA_PORT_DOWN;
-	port->sig_comp_iv = sq_entries / 10;
-
-	if (!dn) {
-		ehea_error("bad device node: dn=%p", dn);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	port->of_dev_node = dn;
-
-	/* Determine logical port id */
-	dn_log_port_id = (u32*)get_property(dn, "ibm,hea-port-no", NULL);
-
-	if (!dn_log_port_id) {
-		ehea_error("bad device node: dn_log_port_id=%p",
-			   dn_log_port_id);
-		ret = -EINVAL;
-		goto out;
-	}
-	port->logical_port_id = *dn_log_port_id;
-
-	port->mc_list = kzalloc(sizeof(struct ehea_mc_list), GFP_KERNEL);
-	if (!port->mc_list) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	INIT_LIST_HEAD(&port->mc_list->list);
+	u64 hret;
+	int ret = 0;
 
-	ret = ehea_sense_port_attr(port);
-	if (ret)
-		goto out;
+	*jumbo = 0;
 
-	/* Enable Jumbo frames */
+	/* (Try to) enable *jumbo frames */
 	cb4 = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!cb4) {
 		ehea_error("no mem for cb4");
+		ret = -ENOMEM;
+		goto out;
 	} else {
-		hret = ehea_h_query_ehea_port(adapter->handle,
+		hret = ehea_h_query_ehea_port(port->adapter->handle,
 					      port->logical_port_id,
 					      H_PORT_CB4,
 					      H_PORT_CB4_JUMBO, cb4);
-
 		if (hret == H_SUCCESS) {
 			if (cb4->jumbo_frame)
-				jumbo = 1;
+				*jumbo = 1;
 			else {
 				cb4->jumbo_frame = 1;
-				hret = ehea_h_modify_ehea_port(adapter->handle,
+				hret = ehea_h_modify_ehea_port(port->adapter->
+							       handle,
 							       port->
-							        logical_port_id,
+							       logical_port_id,
 							       H_PORT_CB4,
 							       H_PORT_CB4_JUMBO,
 							       cb4);
 				if (hret == H_SUCCESS)
-					jumbo = 1;
+					*jumbo = 1;
 			}
-		}
+		} else
+			ret = -EINVAL;
+
 		kfree(cb4);
 	}
+out:
+	return ret;
+}
+
+struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
+					 u32 logical_port_id)
+{
+	int ret;
+	struct net_device *dev;
+	struct ehea_port *port;
+	int jumbo;
+
+	/* allocate memory for the port structures */
+	dev = alloc_etherdev(sizeof(struct ehea_port));
+
+	if (!dev) {
+		ehea_error("no mem for net_device");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	port = netdev_priv(dev);
+
+	sema_init(&port->port_lock, 1);
+	port->state = EHEA_PORT_DOWN;
+	port->sig_comp_iv = sq_entries / 10;
+
+	port->adapter = adapter;
+	port->netdev = dev;
+	port->logical_port_id = logical_port_id;
+
+	port->msg_enable = netif_msg_init(msg_level, EHEA_MSG_DEFAULT);
+
+	port->mc_list = kzalloc(sizeof(struct ehea_mc_list), GFP_KERNEL);
+	if (!port->mc_list) {
+		ret = -ENOMEM;
+		goto out_free_ethdev;
+	}
+
+	INIT_LIST_HEAD(&port->mc_list->list);
+
+	ret = ehea_sense_port_attr(port);
+	if (ret)
+		goto out_free_mc_list;
 
 	/* initialize net_device structure */
 	SET_MODULE_OWNER(dev);
@@ -2418,79 +2414,173 @@ static int ehea_setup_single_port(struct
 	ret = register_netdev(dev);
 	if (ret) {
 		ehea_error("register_netdev failed. ret=%d", ret);
-		goto out_free;
+		goto out_free_mc_list;
+	}
+
+	ret = ehea_get_jumboframe_status(port, &jumbo);
+	if (ret) {
+		ehea_error("failed determining jumbo frame status for %s",
+			   port->netdev->name);
 	}
 
 	ehea_info("%s: Jumbo frames are %sabled", dev->name,
 		  jumbo == 1 ? "en" : "dis");
 
-	port->netdev = dev;
-	ret = 0;
-	goto out;
+	return port;
 
-out_free:
+out_free_mc_list:
 	kfree(port->mc_list);
-out:
-	return ret;
+
+out_free_ethdev:
+	free_netdev(dev);
+
+out_err:
+	ehea_error("setting up logical port with id=%d failed, ret=%d",
+		   logical_port_id, ret);
+	return NULL;
 }
 
-static int ehea_setup_ports(struct ehea_adapter *adapter)
+static void ehea_shutdown_single_port(struct ehea_port *port)
 {
-	int ret;
-	int port_setup_ok = 0;
-	struct ehea_port *port;
-	struct device_node *dn = NULL;
-	struct net_device *dev;
-	int i;
-
-	/* get port properties for all ports */
-	for (i = 0; i < adapter->num_ports; i++) {
+	unregister_netdev(port->netdev);
+	kfree(port->mc_list);
+	free_netdev(port->netdev);
+}
 
-		if (adapter->port[i])
-			continue;	/* port already up and running */
+static int ehea_setup_ports(struct ehea_adapter *adapter)
+{
+	struct device_node *lhea_dn = NULL;
+	struct device_node *eth_dn = NULL;
 
-		/* allocate memory for the port structures */
-		dev = alloc_etherdev(sizeof(struct ehea_port));
+	u32 *dn_log_port_id;
+	int port_setup_ok = 0;
+	int i = 0;
 
-		if (!dev) {
-			ehea_error("no mem for net_device");
+	lhea_dn = adapter->ebus_dev->ofdev.node;
+	do {
+		eth_dn = of_get_next_child(lhea_dn, eth_dn);
+		if (!eth_dn)
 			break;
-		}
-
-		port = netdev_priv(dev);
-		port->adapter = adapter;
-		port->netdev = dev;
-		adapter->port[i] = port;
-		port->msg_enable = netif_msg_init(msg_level, EHEA_MSG_DEFAULT);
 
-		dn = of_find_node_by_name(dn, "ethernet");
-		ret = ehea_setup_single_port(port, dn);
-		if (ret) {
-			/* Free mem for this port struct. The others will be
-			   processed on rollback */
-			free_netdev(dev);
-			adapter->port[i] = NULL;
-			ehea_error("eHEA port %d setup failed, ret=%d", i, ret);
+		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+						    NULL);
+		if (!dn_log_port_id) {
+			ehea_error("bad device node: dn_log_port_id=%p",
+				   dn_log_port_id);
+			continue;
 		}
-	}
 
-	of_node_put(dn);
+		adapter->port[i] = ehea_setup_single_port(adapter,
+							  *dn_log_port_id);
+
+		ehea_info("%s -> logial port id #%d",
+			  adapter->port[i]->netdev->name, *dn_log_port_id);
+		i++;
+	} while ( eth_dn );
+
+	of_node_put(lhea_dn);
 
 	/* Check for succesfully set up ports */
-	for (i = 0; i < adapter->num_ports; i++)
+	for (i = 0; i < EHEA_MAX_PORTS; i++)
 		if (adapter->port[i])
 			port_setup_ok++;
 
 	if (port_setup_ok)
-		ret = 0;	/* At least some ports are setup correctly */
+		return 0;	/* At least some ports are setup correctly */
 	else
-		ret = -EINVAL;
+		return -EINVAL;
+}
+
+static ssize_t ehea_probe_port(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct ehea_adapter *adapter = dev->driver_data;
+	struct ehea_port *port;
+	int i;
+	u32 logical_port_id;
+
+	sscanf(buf, "%d", &logical_port_id);
+
+	port = ehea_get_port(adapter, logical_port_id);
+
+	if (port) {
+		ehea_info("adding port with logical port id=%d failed. port "
+			  "already configured as %s.", logical_port_id,
+			  port->netdev->name);
+		goto out;
+	}
+
+	port = ehea_setup_single_port(adapter, logical_port_id);
+
+	if (port) {
+		for (i=0; i < EHEA_MAX_PORTS; i++)
+			if (!adapter->port[i]) {
+				adapter->port[i] = port;
+				break;
+			}
+
+		ehea_info("added %s (logical port id=%d)", port->netdev->name,
+			  logical_port_id);
+	}
+out:
+	return (ssize_t) count;
+}
+
+static ssize_t ehea_remove_port(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ehea_adapter *adapter = dev->driver_data;
+	struct ehea_port *port;
+	int i;
+	u32 logical_port_id;
+
+	sscanf(buf, "%d", &logical_port_id);
+
+	port = ehea_get_port(adapter, logical_port_id);
+
+	if (port) {
+		ehea_info("removed %s (logical port id=%d)", port->netdev->name,
+			  logical_port_id);
+
+		ehea_shutdown_single_port(port);
+
+		for (i=0; i < EHEA_MAX_PORTS; i++)
+			if (adapter->port[i] == port) {
+				adapter->port[i] = NULL;
+				break;
+			}
+	} else {
+		ehea_error("removing port with logical port id=%d failed. port "
+			   "not configured.", logical_port_id);
+	}
+
+	return (ssize_t) count;
+}
+
+static DEVICE_ATTR(probe_port, S_IWUSR, NULL, ehea_probe_port);
+static DEVICE_ATTR(remove_port, S_IWUSR, NULL, ehea_remove_port);
 
+int ehea_create_device_sysfs(struct ibmebus_dev *dev)
+{
+	int ret = device_create_file(&dev->ofdev.dev, &dev_attr_probe_port);
+	if (ret)
+		goto out;
+
+	ret = device_create_file(&dev->ofdev.dev, &dev_attr_remove_port);
+out:
 	return ret;
 }
 
-static int __devinit ehea_probe(struct ibmebus_dev *dev,
-				const struct of_device_id *id)
+void ehea_remove_device_sysfs(struct ibmebus_dev *dev)
+{
+	device_remove_file(&dev->ofdev.dev, &dev_attr_probe_port);
+	device_remove_file(&dev->ofdev.dev, &dev_attr_remove_port);
+}
+
+static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
+					const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
 	u64 *adapter_handle;
@@ -2503,6 +2593,8 @@ static int __devinit ehea_probe(struct i
 		goto out;
 	}
 
+	adapter->ebus_dev = dev;
+
 	adapter_handle = (u64*)get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
@@ -2532,7 +2624,6 @@ static int __devinit ehea_probe(struct i
 		dev_err(&dev->ofdev.dev, "sense_adapter_attr failed: %d", ret);
 		goto out_free_res;
 	}
-	dev_info(&dev->ofdev.dev, "%d eHEA ports found\n", adapter->num_ports);
 
 	adapter->neq = ehea_create_eq(adapter,
 				      EHEA_NEQ, EHEA_MAX_ENTRIES_EQ, 1);
@@ -2556,15 +2647,21 @@ static int __devinit ehea_probe(struct i
 	if (!adapter->ehea_wq)
 		goto out_free_irq;
 
+	if (ehea_create_device_sysfs(dev))
+		goto out_kill_wq;
+
 	ret = ehea_setup_ports(adapter);
 	if (ret) {
 		dev_err(&dev->ofdev.dev, "setup_ports failed");
-		goto out_kill_wq;
+		goto out_rem_dev_sysfs;
 	}
 
 	ret = 0;
 	goto out;
 
+out_rem_dev_sysfs:
+	ehea_remove_device_sysfs(dev);
+
 out_kill_wq:
 	destroy_workqueue(adapter->ehea_wq);
 
@@ -2583,24 +2680,20 @@ out:
 	return ret;
 }
 
-static void ehea_shutdown_single_port(struct ehea_port *port)
-{
-	unregister_netdev(port->netdev);
-	kfree(port->mc_list);
-	free_netdev(port->netdev);
-}
-
 static int __devexit ehea_remove(struct ibmebus_dev *dev)
 {
 	struct ehea_adapter *adapter = dev->ofdev.dev.driver_data;
 	u64 hret;
 	int i;
 
-	for (i = 0; i < adapter->num_ports; i++)
+	for (i = 0; i < EHEA_MAX_PORTS; i++)
 		if (adapter->port[i]) {
 			ehea_shutdown_single_port(adapter->port[i]);
 			adapter->port[i] = NULL;
 		}
+
+	ehea_remove_device_sysfs(dev);
+
 	destroy_workqueue(adapter->ehea_wq);
 
 	ibmebus_free_irq(NULL, adapter->neq->attr.ist1, adapter);
@@ -2656,7 +2749,7 @@ static struct of_device_id ehea_device_t
 static struct ibmebus_driver ehea_driver = {
 	.name = "ehea",
 	.id_table = ehea_device_table,
-	.probe = ehea_probe,
+	.probe = ehea_probe_adapter,
 	.remove = ehea_remove,
 };
 
_

Patches currently in -mm which might be from ossthema@de.ibm.com are

git-netdev-all.patch
ehea-dynamic-add--remove-port.patch
