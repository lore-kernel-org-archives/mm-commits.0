From: akpm@linux-foundation.org
Subject: [merged] um-add-ucast-ethernet-transport.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:01 -0700
Message-ID: <201105252029.p4PKTOXp014838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1EYUaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nolan@sigbus.net, davem@davemloft.net, nolan@cumulusnetworks.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: add ucast ethernet transport
has been removed from the -mm tree.  Its filename was
     um-add-ucast-ethernet-transport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: add ucast ethernet transport
From: Nolan Leake <nolan@sigbus.net>

The ucast transport is similar to the mcast transport (and, in fact,
shares most of its code), only it uses UDP unicast to move packets.

Obviously this is only useful for point-to-point connections between
virtual ethernet devices.

Signed-off-by: Nolan Leake <nolan@cumulusnetworks.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/virtual/uml/UserModeLinux-HOWTO.txt |   10 
 arch/um/drivers/Makefile                          |    4 
 arch/um/drivers/mcast.h                           |   24 -
 arch/um/drivers/mcast_kern.c                      |  120 -------
 arch/um/drivers/mcast_user.c                      |  165 ----------
 arch/um/drivers/umcast.h                          |   27 +
 arch/um/drivers/umcast_kern.c                     |  188 ++++++++++++
 arch/um/drivers/umcast_user.c                     |  186 +++++++++++
 8 files changed, 413 insertions(+), 311 deletions(-)

diff -puN Documentation/virtual/uml/UserModeLinux-HOWTO.txt~um-add-ucast-ethernet-transport Documentation/virtual/uml/UserModeLinux-HOWTO.txt
--- a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt~um-add-ucast-ethernet-transport
+++ a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
@@ -1182,6 +1182,16 @@
   forge.net/>  and explains these in detail, as well as
   some other issues.
 
+  There is also a related point-to-point only "ucast" transport.
+  This is useful when your network does not support multicast, and
+  all network connections are simple point to point links.
+
+  The full set of command line options for this transport are
+
+
+       ethn=ucast,ethernet address,remote address,listen port,remote port
+
+
 
 
   66..66..  TTUUNN//TTAAPP wwiitthh tthhee uummll__nneett hheellppeerr
diff -puN arch/um/drivers/Makefile~um-add-ucast-ethernet-transport arch/um/drivers/Makefile
--- a/arch/um/drivers/Makefile~um-add-ucast-ethernet-transport
+++ a/arch/um/drivers/Makefile
@@ -9,7 +9,7 @@
 slip-objs := slip_kern.o slip_user.o
 slirp-objs := slirp_kern.o slirp_user.o
 daemon-objs := daemon_kern.o daemon_user.o
-mcast-objs := mcast_kern.o mcast_user.o
+umcast-objs := umcast_kern.o umcast_user.o
 net-objs := net_kern.o net_user.o
 mconsole-objs := mconsole_kern.o mconsole_user.o
 hostaudio-objs := hostaudio_kern.o
@@ -44,7 +44,7 @@ obj-$(CONFIG_UML_NET_SLIP) += slip.o sli
 obj-$(CONFIG_UML_NET_SLIRP) += slirp.o slip_common.o
 obj-$(CONFIG_UML_NET_DAEMON) += daemon.o 
 obj-$(CONFIG_UML_NET_VDE) += vde.o
-obj-$(CONFIG_UML_NET_MCAST) += mcast.o 
+obj-$(CONFIG_UML_NET_MCAST) += umcast.o
 obj-$(CONFIG_UML_NET_PCAP) += pcap.o
 obj-$(CONFIG_UML_NET) += net.o 
 obj-$(CONFIG_MCONSOLE) += mconsole.o
diff -puN arch/um/drivers/mcast.h~um-add-ucast-ethernet-transport /dev/null
--- a/arch/um/drivers/mcast.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* 
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __DRIVERS_MCAST_H
-#define __DRIVERS_MCAST_H
-
-#include "net_user.h"
-
-struct mcast_data {
-	char *addr;
-	unsigned short port;
-	void *mcast_addr;
-	int ttl;
-	void *dev;
-};
-
-extern const struct net_user_info mcast_user_info;
-
-extern int mcast_user_write(int fd, void *buf, int len, 
-			    struct mcast_data *pri);
-
-#endif
diff -puN arch/um/drivers/mcast_kern.c~um-add-ucast-ethernet-transport /dev/null
--- a/arch/um/drivers/mcast_kern.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- * user-mode-linux networking multicast transport
- * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- *
- * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
- * Copyright (C) 2001 by various other people who didn't put their name here.
- *
- * Licensed under the GPL.
- */
-
-#include "linux/init.h"
-#include <linux/netdevice.h>
-#include "mcast.h"
-#include "net_kern.h"
-
-struct mcast_init {
-	char *addr;
-	int port;
-	int ttl;
-};
-
-static void mcast_init(struct net_device *dev, void *data)
-{
-	struct uml_net_private *pri;
-	struct mcast_data *dpri;
-	struct mcast_init *init = data;
-
-	pri = netdev_priv(dev);
-	dpri = (struct mcast_data *) pri->user;
-	dpri->addr = init->addr;
-	dpri->port = init->port;
-	dpri->ttl = init->ttl;
-	dpri->dev = dev;
-
-	printk("mcast backend multicast address: %s:%u, TTL:%u\n",
-	       dpri->addr, dpri->port, dpri->ttl);
-}
-
-static int mcast_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
-{
-	return net_recvfrom(fd, skb_mac_header(skb),
-			    skb->dev->mtu + ETH_HEADER_OTHER);
-}
-
-static int mcast_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
-{
-	return mcast_user_write(fd, skb->data, skb->len,
-				(struct mcast_data *) &lp->user);
-}
-
-static const struct net_kern_info mcast_kern_info = {
-	.init			= mcast_init,
-	.protocol		= eth_protocol,
-	.read			= mcast_read,
-	.write			= mcast_write,
-};
-
-static int mcast_setup(char *str, char **mac_out, void *data)
-{
-	struct mcast_init *init = data;
-	char *port_str = NULL, *ttl_str = NULL, *remain;
-	char *last;
-
-	*init = ((struct mcast_init)
-		{ .addr 	= "239.192.168.1",
-		  .port 	= 1102,
-		  .ttl 		= 1 });
-
-	remain = split_if_spec(str, mac_out, &init->addr, &port_str, &ttl_str,
-			       NULL);
-	if (remain != NULL) {
-		printk(KERN_ERR "mcast_setup - Extra garbage on "
-		       "specification : '%s'\n", remain);
-		return 0;
-	}
-
-	if (port_str != NULL) {
-		init->port = simple_strtoul(port_str, &last, 10);
-		if ((*last != '\0') || (last == port_str)) {
-			printk(KERN_ERR "mcast_setup - Bad port : '%s'\n",
-			       port_str);
-			return 0;
-		}
-	}
-
-	if (ttl_str != NULL) {
-		init->ttl = simple_strtoul(ttl_str, &last, 10);
-		if ((*last != '\0') || (last == ttl_str)) {
-			printk(KERN_ERR "mcast_setup - Bad ttl : '%s'\n",
-			       ttl_str);
-			return 0;
-		}
-	}
-
-	printk(KERN_INFO "Configured mcast device: %s:%u-%u\n", init->addr,
-	       init->port, init->ttl);
-
-	return 1;
-}
-
-static struct transport mcast_transport = {
-	.list 		= LIST_HEAD_INIT(mcast_transport.list),
-	.name 		= "mcast",
-	.setup  	= mcast_setup,
-	.user 		= &mcast_user_info,
-	.kern 		= &mcast_kern_info,
-	.private_size 	= sizeof(struct mcast_data),
-	.setup_size 	= sizeof(struct mcast_init),
-};
-
-static int register_mcast(void)
-{
-	register_transport(&mcast_transport);
-	return 0;
-}
-
-late_initcall(register_mcast);
diff -puN arch/um/drivers/mcast_user.c~um-add-ucast-ethernet-transport /dev/null
--- a/arch/um/drivers/mcast_user.c
+++ /dev/null
@@ -1,165 +0,0 @@
-/*
- * user-mode-linux networking multicast transport
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
- *
- * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
- * Copyright (C) 2001 by various other people who didn't put their name here.
- *
- * Licensed under the GPL.
- *
- */
-
-#include <unistd.h>
-#include <errno.h>
-#include <netinet/in.h>
-#include "kern_constants.h"
-#include "mcast.h"
-#include "net_user.h"
-#include "um_malloc.h"
-#include "user.h"
-
-static struct sockaddr_in *new_addr(char *addr, unsigned short port)
-{
-	struct sockaddr_in *sin;
-
-	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
-	if (sin == NULL) {
-		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
-		       "failed\n");
-		return NULL;
-	}
-	sin->sin_family = AF_INET;
-	sin->sin_addr.s_addr = in_aton(addr);
-	sin->sin_port = htons(port);
-	return sin;
-}
-
-static int mcast_user_init(void *data, void *dev)
-{
-	struct mcast_data *pri = data;
-
-	pri->mcast_addr = new_addr(pri->addr, pri->port);
-	pri->dev = dev;
-	return 0;
-}
-
-static void mcast_remove(void *data)
-{
-	struct mcast_data *pri = data;
-
-	kfree(pri->mcast_addr);
-	pri->mcast_addr = NULL;
-}
-
-static int mcast_open(void *data)
-{
-	struct mcast_data *pri = data;
-	struct sockaddr_in *sin = pri->mcast_addr;
-	struct ip_mreq mreq;
-	int fd, yes = 1, err = -EINVAL;
-
-
-	if ((sin->sin_addr.s_addr == 0) || (sin->sin_port == 0))
-		goto out;
-
-	fd = socket(AF_INET, SOCK_DGRAM, 0);
-
-	if (fd < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open : data socket failed, "
-		       "errno = %d\n", errno);
-		goto out;
-	}
-
-	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open: SO_REUSEADDR failed, "
-		       "errno = %d\n", errno);
-		goto out_close;
-	}
-
-	/* set ttl according to config */
-	if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
-		       sizeof(pri->ttl)) < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open: IP_MULTICAST_TTL failed, "
-		       "error = %d\n", errno);
-		goto out_close;
-	}
-
-	/* set LOOP, so data does get fed back to local sockets */
-	if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP, &yes, sizeof(yes)) < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open: IP_MULTICAST_LOOP failed, "
-		       "error = %d\n", errno);
-		goto out_close;
-	}
-
-	/* bind socket to mcast address */
-	if (bind(fd, (struct sockaddr *) sin, sizeof(*sin)) < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open : data bind failed, "
-		       "errno = %d\n", errno);
-		goto out_close;
-	}
-
-	/* subscribe to the multicast group */
-	mreq.imr_multiaddr.s_addr = sin->sin_addr.s_addr;
-	mreq.imr_interface.s_addr = 0;
-	if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
-		       &mreq, sizeof(mreq)) < 0) {
-		err = -errno;
-		printk(UM_KERN_ERR "mcast_open: IP_ADD_MEMBERSHIP failed, "
-		       "error = %d\n", errno);
-		printk(UM_KERN_ERR "There appears not to be a multicast-"
-		       "capable network interface on the host.\n");
-		printk(UM_KERN_ERR "eth0 should be configured in order to use "
-		       "the multicast transport.\n");
-		goto out_close;
-	}
-
-	return fd;
-
- out_close:
-	close(fd);
- out:
-	return err;
-}
-
-static void mcast_close(int fd, void *data)
-{
-	struct ip_mreq mreq;
-	struct mcast_data *pri = data;
-	struct sockaddr_in *sin = pri->mcast_addr;
-
-	mreq.imr_multiaddr.s_addr = sin->sin_addr.s_addr;
-	mreq.imr_interface.s_addr = 0;
-	if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
-		       &mreq, sizeof(mreq)) < 0) {
-		printk(UM_KERN_ERR "mcast_open: IP_DROP_MEMBERSHIP failed, "
-		       "error = %d\n", errno);
-	}
-
-	close(fd);
-}
-
-int mcast_user_write(int fd, void *buf, int len, struct mcast_data *pri)
-{
-	struct sockaddr_in *data_addr = pri->mcast_addr;
-
-	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
-}
-
-const struct net_user_info mcast_user_info = {
-	.init		= mcast_user_init,
-	.open		= mcast_open,
-	.close	 	= mcast_close,
-	.remove	 	= mcast_remove,
-	.add_address	= NULL,
-	.delete_address = NULL,
-	.mtu		= ETH_MAX_PACKET,
-	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
-};
diff -puN /dev/null arch/um/drivers/umcast.h
--- /dev/null
+++ a/arch/um/drivers/umcast.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __DRIVERS_UMCAST_H
+#define __DRIVERS_UMCAST_H
+
+#include "net_user.h"
+
+struct umcast_data {
+	char *addr;
+	unsigned short lport;
+	unsigned short rport;
+	void *listen_addr;
+	void *remote_addr;
+	int ttl;
+	int unicast;
+	void *dev;
+};
+
+extern const struct net_user_info umcast_user_info;
+
+extern int umcast_user_write(int fd, void *buf, int len,
+			     struct umcast_data *pri);
+
+#endif
diff -puN /dev/null arch/um/drivers/umcast_kern.c
--- /dev/null
+++ a/arch/um/drivers/umcast_kern.c
@@ -0,0 +1,188 @@
+/*
+ * user-mode-linux networking multicast transport
+ * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ *
+ * based on the existing uml-networking code, which is
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 by various other people who didn't put their name here.
+ *
+ * Licensed under the GPL.
+ */
+
+#include "linux/init.h"
+#include <linux/netdevice.h>
+#include "umcast.h"
+#include "net_kern.h"
+
+struct umcast_init {
+	char *addr;
+	int lport;
+	int rport;
+	int ttl;
+	bool unicast;
+};
+
+static void umcast_init(struct net_device *dev, void *data)
+{
+	struct uml_net_private *pri;
+	struct umcast_data *dpri;
+	struct umcast_init *init = data;
+
+	pri = netdev_priv(dev);
+	dpri = (struct umcast_data *) pri->user;
+	dpri->addr = init->addr;
+	dpri->lport = init->lport;
+	dpri->rport = init->rport;
+	dpri->unicast = init->unicast;
+	dpri->ttl = init->ttl;
+	dpri->dev = dev;
+
+	if (dpri->unicast) {
+		printk(KERN_INFO "ucast backend address: %s:%u listen port: "
+		       "%u\n", dpri->addr, dpri->rport, dpri->lport);
+	} else {
+		printk(KERN_INFO "mcast backend multicast address: %s:%u, "
+		       "TTL:%u\n", dpri->addr, dpri->lport, dpri->ttl);
+	}
+}
+
+static int umcast_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
+{
+	return net_recvfrom(fd, skb_mac_header(skb),
+			    skb->dev->mtu + ETH_HEADER_OTHER);
+}
+
+static int umcast_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
+{
+	return umcast_user_write(fd, skb->data, skb->len,
+				(struct umcast_data *) &lp->user);
+}
+
+static const struct net_kern_info umcast_kern_info = {
+	.init			= umcast_init,
+	.protocol		= eth_protocol,
+	.read			= umcast_read,
+	.write			= umcast_write,
+};
+
+static int mcast_setup(char *str, char **mac_out, void *data)
+{
+	struct umcast_init *init = data;
+	char *port_str = NULL, *ttl_str = NULL, *remain;
+	char *last;
+
+	*init = ((struct umcast_init)
+		{ .addr	= "239.192.168.1",
+		  .lport	= 1102,
+		  .ttl	= 1 });
+
+	remain = split_if_spec(str, mac_out, &init->addr, &port_str, &ttl_str,
+			       NULL);
+	if (remain != NULL) {
+		printk(KERN_ERR "mcast_setup - Extra garbage on "
+		       "specification : '%s'\n", remain);
+		return 0;
+	}
+
+	if (port_str != NULL) {
+		init->lport = simple_strtoul(port_str, &last, 10);
+		if ((*last != '\0') || (last == port_str)) {
+			printk(KERN_ERR "mcast_setup - Bad port : '%s'\n",
+			       port_str);
+			return 0;
+		}
+	}
+
+	if (ttl_str != NULL) {
+		init->ttl = simple_strtoul(ttl_str, &last, 10);
+		if ((*last != '\0') || (last == ttl_str)) {
+			printk(KERN_ERR "mcast_setup - Bad ttl : '%s'\n",
+			       ttl_str);
+			return 0;
+		}
+	}
+
+	init->unicast = false;
+	init->rport = init->lport;
+
+	printk(KERN_INFO "Configured mcast device: %s:%u-%u\n", init->addr,
+	       init->lport, init->ttl);
+
+	return 1;
+}
+
+static int ucast_setup(char *str, char **mac_out, void *data)
+{
+	struct umcast_init *init = data;
+	char *lport_str = NULL, *rport_str = NULL, *remain;
+	char *last;
+
+	*init = ((struct umcast_init)
+		{ .addr		= "",
+		  .lport	= 1102,
+		  .rport	= 1102 });
+
+	remain = split_if_spec(str, mac_out, &init->addr,
+			       &lport_str, &rport_str, NULL);
+	if (remain != NULL) {
+		printk(KERN_ERR "ucast_setup - Extra garbage on "
+		       "specification : '%s'\n", remain);
+		return 0;
+	}
+
+	if (lport_str != NULL) {
+		init->lport = simple_strtoul(lport_str, &last, 10);
+		if ((*last != '\0') || (last == lport_str)) {
+			printk(KERN_ERR "ucast_setup - Bad listen port : "
+			       "'%s'\n", lport_str);
+			return 0;
+		}
+	}
+
+	if (rport_str != NULL) {
+		init->rport = simple_strtoul(rport_str, &last, 10);
+		if ((*last != '\0') || (last == rport_str)) {
+			printk(KERN_ERR "ucast_setup - Bad remote port : "
+			       "'%s'\n", rport_str);
+			return 0;
+		}
+	}
+
+	init->unicast = true;
+
+	printk(KERN_INFO "Configured ucast device: :%u -> %s:%u\n",
+	       init->lport, init->addr, init->rport);
+
+	return 1;
+}
+
+static struct transport mcast_transport = {
+	.list	= LIST_HEAD_INIT(mcast_transport.list),
+	.name	= "mcast",
+	.setup	= mcast_setup,
+	.user	= &umcast_user_info,
+	.kern	= &umcast_kern_info,
+	.private_size	= sizeof(struct umcast_data),
+	.setup_size	= sizeof(struct umcast_init),
+};
+
+static struct transport ucast_transport = {
+	.list	= LIST_HEAD_INIT(ucast_transport.list),
+	.name	= "ucast",
+	.setup	= ucast_setup,
+	.user	= &umcast_user_info,
+	.kern	= &umcast_kern_info,
+	.private_size	= sizeof(struct umcast_data),
+	.setup_size	= sizeof(struct umcast_init),
+};
+
+static int register_umcast(void)
+{
+	register_transport(&mcast_transport);
+	register_transport(&ucast_transport);
+	return 0;
+}
+
+late_initcall(register_umcast);
diff -puN /dev/null arch/um/drivers/umcast_user.c
--- /dev/null
+++ a/arch/um/drivers/umcast_user.c
@@ -0,0 +1,186 @@
+/*
+ * user-mode-linux networking multicast transport
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
+ *
+ * based on the existing uml-networking code, which is
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 by various other people who didn't put their name here.
+ *
+ * Licensed under the GPL.
+ *
+ */
+
+#include <unistd.h>
+#include <errno.h>
+#include <netinet/in.h>
+#include "kern_constants.h"
+#include "umcast.h"
+#include "net_user.h"
+#include "um_malloc.h"
+#include "user.h"
+
+static struct sockaddr_in *new_addr(char *addr, unsigned short port)
+{
+	struct sockaddr_in *sin;
+
+	sin = uml_kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
+	if (sin == NULL) {
+		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
+		       "failed\n");
+		return NULL;
+	}
+	sin->sin_family = AF_INET;
+	if (addr)
+		sin->sin_addr.s_addr = in_aton(addr);
+	else
+		sin->sin_addr.s_addr = INADDR_ANY;
+	sin->sin_port = htons(port);
+	return sin;
+}
+
+static int umcast_user_init(void *data, void *dev)
+{
+	struct umcast_data *pri = data;
+
+	pri->remote_addr = new_addr(pri->addr, pri->rport);
+	if (pri->unicast)
+		pri->listen_addr = new_addr(NULL, pri->lport);
+	else
+		pri->listen_addr = pri->remote_addr;
+	pri->dev = dev;
+	return 0;
+}
+
+static void umcast_remove(void *data)
+{
+	struct umcast_data *pri = data;
+
+	kfree(pri->listen_addr);
+	if (pri->unicast)
+		kfree(pri->remote_addr);
+	pri->listen_addr = pri->remote_addr = NULL;
+}
+
+static int umcast_open(void *data)
+{
+	struct umcast_data *pri = data;
+	struct sockaddr_in *lsin = pri->listen_addr;
+	struct sockaddr_in *rsin = pri->remote_addr;
+	struct ip_mreq mreq;
+	int fd, yes = 1, err = -EINVAL;
+
+
+	if ((!pri->unicast && lsin->sin_addr.s_addr == 0) ||
+	    (rsin->sin_addr.s_addr == 0) ||
+	    (lsin->sin_port == 0) || (rsin->sin_port == 0))
+		goto out;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+
+	if (fd < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "umcast_open : data socket failed, "
+		       "errno = %d\n", errno);
+		goto out;
+	}
+
+	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "umcast_open: SO_REUSEADDR failed, "
+		       "errno = %d\n", errno);
+		goto out_close;
+	}
+
+	if (!pri->unicast) {
+		/* set ttl according to config */
+		if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
+			       sizeof(pri->ttl)) < 0) {
+			err = -errno;
+			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_TTL "
+			       "failed, error = %d\n", errno);
+			goto out_close;
+		}
+
+		/* set LOOP, so data does get fed back to local sockets */
+		if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP,
+			       &yes, sizeof(yes)) < 0) {
+			err = -errno;
+			printk(UM_KERN_ERR "umcast_open: IP_MULTICAST_LOOP "
+			       "failed, error = %d\n", errno);
+			goto out_close;
+		}
+	}
+
+	/* bind socket to the address */
+	if (bind(fd, (struct sockaddr *) lsin, sizeof(*lsin)) < 0) {
+		err = -errno;
+		printk(UM_KERN_ERR "umcast_open : data bind failed, "
+		       "errno = %d\n", errno);
+		goto out_close;
+	}
+
+	if (!pri->unicast) {
+		/* subscribe to the multicast group */
+		mreq.imr_multiaddr.s_addr = lsin->sin_addr.s_addr;
+		mreq.imr_interface.s_addr = 0;
+		if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
+			       &mreq, sizeof(mreq)) < 0) {
+			err = -errno;
+			printk(UM_KERN_ERR "umcast_open: IP_ADD_MEMBERSHIP "
+			       "failed, error = %d\n", errno);
+			printk(UM_KERN_ERR "There appears not to be a "
+			       "multicast-capable network interface on the "
+			       "host.\n");
+			printk(UM_KERN_ERR "eth0 should be configured in order "
+			       "to use the multicast transport.\n");
+			goto out_close;
+		}
+	}
+
+	return fd;
+
+ out_close:
+	close(fd);
+ out:
+	return err;
+}
+
+static void umcast_close(int fd, void *data)
+{
+	struct umcast_data *pri = data;
+
+	if (!pri->unicast) {
+		struct ip_mreq mreq;
+		struct sockaddr_in *lsin = pri->listen_addr;
+
+		mreq.imr_multiaddr.s_addr = lsin->sin_addr.s_addr;
+		mreq.imr_interface.s_addr = 0;
+		if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
+			       &mreq, sizeof(mreq)) < 0) {
+			printk(UM_KERN_ERR "umcast_close: IP_DROP_MEMBERSHIP "
+			       "failed, error = %d\n", errno);
+		}
+	}
+
+	close(fd);
+}
+
+int umcast_user_write(int fd, void *buf, int len, struct umcast_data *pri)
+{
+	struct sockaddr_in *data_addr = pri->remote_addr;
+
+	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
+}
+
+const struct net_user_info umcast_user_info = {
+	.init	= umcast_user_init,
+	.open	= umcast_open,
+	.close	= umcast_close,
+	.remove	= umcast_remove,
+	.add_address	= NULL,
+	.delete_address = NULL,
+	.mtu	= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
+};
_

Patches currently in -mm which might be from nolan@sigbus.net are

origin.patch

