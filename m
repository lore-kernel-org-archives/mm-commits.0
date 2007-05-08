From: akpm@linux-foundation.org
Subject: - uml-network-interface-hotplug-error-handling.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:10 -0700
Message-ID: <200705080006.l4806AYO009159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbXEHAGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     uml: network interface hotplug error handling
has been removed from the -mm tree.  Its filename was
     uml-network-interface-hotplug-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: network interface hotplug error handling
From: Jeff Dike <jdike@addtoit.com>

This fixes a number of problems associated with network interface hotplug.

The userspace initialization function can fail in some cases, but the
failure was never passed back to eth_configure, which proceeded with the
configuration.  This results in a zombie device that is present, but can't
work.  This is fixed by allowing the initialization routines to return an
error, which is checked, and the configuration aborted on failure.

eth_configure failed to check for many failures.  Even when it did check,
it didn't undo whatever initializations has already happened, so a present,
but partially initialized and non-working device could result.  It now
checks everything that can fail, and bails out, undoing whatever had been
done.

The return value of eth_configure was always ignored, so it is now just
void.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/daemon_user.c            |    5 +
 arch/um/drivers/mcast_user.c             |    3 
 arch/um/drivers/net_kern.c               |   81 +++++++++++----------
 arch/um/drivers/pcap_user.c              |    5 -
 arch/um/drivers/slip_user.c              |    3 
 arch/um/drivers/slirp_user.c             |    3 
 arch/um/include/net_user.h               |    2 
 arch/um/os-Linux/drivers/ethertap_user.c |    3 
 arch/um/os-Linux/drivers/tuntap_user.c   |    3 
 9 files changed, 64 insertions(+), 44 deletions(-)

diff -puN arch/um/drivers/daemon_user.c~uml-network-interface-hotplug-error-handling arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/daemon_user.c
@@ -123,7 +123,7 @@ static int connect_to_switch(struct daem
 	return err;
 }
 
-static void daemon_user_init(void *data, void *dev)
+static int daemon_user_init(void *data, void *dev)
 {
 	struct daemon_data *pri = data;
 	struct timeval tv;
@@ -146,7 +146,10 @@ static void daemon_user_init(void *data,
 	if(pri->fd < 0){
 		kfree(pri->local_addr);
 		pri->local_addr = NULL;
+		return pri->fd;
 	}
+
+	return 0;
 }
 
 static int daemon_open(void *data)
diff -puN arch/um/drivers/mcast_user.c~uml-network-interface-hotplug-error-handling arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/mcast_user.c
@@ -42,12 +42,13 @@ static struct sockaddr_in *new_addr(char
 	return sin;
 }
 
-static void mcast_user_init(void *data, void *dev)
+static int mcast_user_init(void *data, void *dev)
 {
 	struct mcast_data *pri = data;
 
 	pri->mcast_addr = new_addr(pri->addr, pri->port);
 	pri->dev = dev;
+	return 0;
 }
 
 static void mcast_remove(void *data)
diff -puN arch/um/drivers/net_kern.c~uml-network-interface-hotplug-error-handling arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/net_kern.c
@@ -325,8 +325,8 @@ static struct platform_driver uml_net_dr
 };
 static int driver_registered;
 
-static int eth_configure(int n, void *init, char *mac,
-			 struct transport *transport)
+static void eth_configure(int n, void *init, char *mac,
+			  struct transport *transport)
 {
 	struct uml_net *device;
 	struct net_device *dev;
@@ -339,16 +339,12 @@ static int eth_configure(int n, void *in
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
 		printk(KERN_ERR "eth_configure failed to allocate uml_net\n");
-		return(1);
+		return;
 	}
 
 	INIT_LIST_HEAD(&device->list);
 	device->index = n;
 
-	spin_lock(&devices_lock);
-	list_add(&device->list, &devices);
-	spin_unlock(&devices_lock);
-
 	setup_etheraddr(mac, device->mac);
 
 	printk(KERN_INFO "Netdevice %d ", n);
@@ -360,7 +356,7 @@ static int eth_configure(int n, void *in
 	dev = alloc_etherdev(size);
 	if (dev == NULL) {
 		printk(KERN_ERR "eth_configure: failed to allocate device\n");
-		return 1;
+		goto out_free_device;
 	}
 
 	lp = dev->priv;
@@ -376,7 +372,8 @@ static int eth_configure(int n, void *in
 	}
 	device->pdev.id = n;
 	device->pdev.name = DRIVER_NAME;
-	platform_device_register(&device->pdev);
+	if(platform_device_register(&device->pdev))
+		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
 
 	/* If this name ends up conflicting with an existing registered
@@ -386,31 +383,12 @@ static int eth_configure(int n, void *in
 	snprintf(dev->name, sizeof(dev->name), "eth%d", n);
 	device->dev = dev;
 
+	/*
+	 * These just fill in a data structure, so there's no failure
+	 * to be worried about.
+	 */
 	(*transport->kern->init)(dev, init);
 
-	dev->mtu = transport->user->max_packet;
-	dev->open = uml_net_open;
-	dev->hard_start_xmit = uml_net_start_xmit;
-	dev->stop = uml_net_close;
-	dev->get_stats = uml_net_get_stats;
-	dev->set_multicast_list = uml_net_set_multicast_list;
-	dev->tx_timeout = uml_net_tx_timeout;
-	dev->set_mac_address = uml_net_set_mac;
-	dev->change_mtu = uml_net_change_mtu;
-	dev->ethtool_ops = &uml_net_ethtool_ops;
-	dev->watchdog_timeo = (HZ >> 1);
-	dev->irq = UM_ETH_IRQ;
-
-	rtnl_lock();
-	err = register_netdevice(dev);
-	rtnl_unlock();
-	if (err) {
-		device->dev = NULL;
-		/* XXX: should we call ->remove() here? */
-		free_netdev(dev);
-		return 1;
-	}
-
 	/* lp.user is the first four bytes of the transport data, which
 	 * has already been initialized.  This structure assignment will
 	 * overwrite that, so we make sure that .user gets overwritten with
@@ -438,12 +416,45 @@ static int eth_configure(int n, void *in
 	lp->tl.function = uml_net_user_timer_expire;
 	memcpy(lp->mac, device->mac, sizeof(lp->mac));
 
-	if (transport->user->init)
-		(*transport->user->init)(&lp->user, dev);
+	if ((transport->user->init != NULL) &&
+	    ((*transport->user->init)(&lp->user, dev) != 0))
+		goto out_unregister;
 
 	set_ether_mac(dev, device->mac);
+	dev->mtu = transport->user->max_packet;
+	dev->open = uml_net_open;
+	dev->hard_start_xmit = uml_net_start_xmit;
+	dev->stop = uml_net_close;
+	dev->get_stats = uml_net_get_stats;
+	dev->set_multicast_list = uml_net_set_multicast_list;
+	dev->tx_timeout = uml_net_tx_timeout;
+	dev->set_mac_address = uml_net_set_mac;
+	dev->change_mtu = uml_net_change_mtu;
+	dev->ethtool_ops = &uml_net_ethtool_ops;
+	dev->watchdog_timeo = (HZ >> 1);
+	dev->irq = UM_ETH_IRQ;
 
-	return 0;
+	rtnl_lock();
+	err = register_netdevice(dev);
+	rtnl_unlock();
+	if (err)
+		goto out_undo_user_init;
+
+	spin_lock(&devices_lock);
+	list_add(&device->list, &devices);
+	spin_unlock(&devices_lock);
+
+	return;
+
+out_undo_user_init:
+	if (transport->user->init != NULL)
+		(*transport->user->remove)(&lp->user);
+out_unregister:
+	platform_device_unregister(&device->pdev);
+out_free_netdev:
+	free_netdev(dev);
+out_free_device: ;
+	kfree(device);
 }
 
 static struct uml_net *find_device(int n)
diff -puN arch/um/drivers/pcap_user.c~uml-network-interface-hotplug-error-handling arch/um/drivers/pcap_user.c
--- a/arch/um/drivers/pcap_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/pcap_user.c
@@ -18,7 +18,7 @@
 
 #define PCAP_FD(p) (*(int *)(p))
 
-static void pcap_user_init(void *data, void *dev)
+static int pcap_user_init(void *data, void *dev)
 {
 	struct pcap_data *pri = data;
 	pcap_t *p;
@@ -28,11 +28,12 @@ static void pcap_user_init(void *data, v
 	if(p == NULL){
 		printk("pcap_user_init : pcap_open_live failed - '%s'\n", 
 		       errors);
-		return;
+		return -EINVAL;
 	}
 
 	pri->dev = dev;
 	pri->pcap = p;
+	return 0;
 }
 
 static int pcap_open(void *data)
diff -puN arch/um/drivers/slip_user.c~uml-network-interface-hotplug-error-handling arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/slip_user.c
@@ -17,11 +17,12 @@
 #include "os.h"
 #include "um_malloc.h"
 
-void slip_user_init(void *data, void *dev)
+static int slip_user_init(void *data, void *dev)
 {
 	struct slip_data *pri = data;
 
 	pri->dev = dev;
+	return 0;
 }
 
 static int set_up_tty(int fd)
diff -puN arch/um/drivers/slirp_user.c~uml-network-interface-hotplug-error-handling arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/drivers/slirp_user.c
@@ -15,11 +15,12 @@
 #include "slip_common.h"
 #include "os.h"
 
-void slirp_user_init(void *data, void *dev)
+static int slirp_user_init(void *data, void *dev)
 {
 	struct slirp_data *pri = data;
 
 	pri->dev = dev;
+	return 0;
 }
 
 struct slirp_pre_exec_data {
diff -puN arch/um/include/net_user.h~uml-network-interface-hotplug-error-handling arch/um/include/net_user.h
--- a/arch/um/include/net_user.h~uml-network-interface-hotplug-error-handling
+++ a/arch/um/include/net_user.h
@@ -14,7 +14,7 @@
 #define UML_NET_VERSION (4)
 
 struct net_user_info {
-	void (*init)(void *, void *);
+	int (*init)(void *, void *);
 	int (*open)(void *);
 	void (*close)(int, void *);
 	void (*remove)(void *);
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-network-interface-hotplug-error-handling arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -24,11 +24,12 @@
 
 #define MAX_PACKET ETH_MAX_PACKET
 
-void etap_user_init(void *data, void *dev)
+static int etap_user_init(void *data, void *dev)
 {
 	struct ethertap_data *pri = data;
 
 	pri->dev = dev;
+	return 0;
 }
 
 struct addr_change {
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-network-interface-hotplug-error-handling arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-network-interface-hotplug-error-handling
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -24,11 +24,12 @@
 
 #define MAX_PACKET ETH_MAX_PACKET
 
-void tuntap_user_init(void *data, void *dev)
+static int tuntap_user_init(void *data, void *dev)
 {
 	struct tuntap_data *pri = data;
 
 	pri->dev = dev;
+	return 0;
 }
 
 static void tuntap_add_addr(unsigned char *addr, unsigned char *netmask,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
