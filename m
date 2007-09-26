From: akpm@linux-foundation.org
Subject: + uml-network-formatting.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:11:19 -0700
Message-ID: <200709262211.l8QMBJKj006550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbXIZWL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: network formatting
has been added to the -mm tree.  Its filename is
     uml-network-formatting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: network formatting
From: Jeff Dike <jdike@addtoit.com>

Style and other non-functional changes in the UML networking code, including
	include tidying
	style violations
	copyright updates
	printks getting severities
	userspace code calling libc directly rather than using the os_*
wrappers

There's also a exit path cleanup in the pcap driver.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/um/drivers/daemon.h~uml-network-formatting arch/um/drivers/daemon.h
--- a/arch/um/drivers/daemon.h~uml-network-formatting
+++ a/arch/um/drivers/daemon.h
@@ -1,8 +1,11 @@
-/* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
+#ifndef __DAEMON_H__
+#define __DAEMON_H__
+
 #include "net_user.h"
 
 #define SWITCH_VERSION 3
@@ -20,16 +23,7 @@ struct daemon_data {
 
 extern const struct net_user_info daemon_user_info;
 
-extern int daemon_user_write(int fd, void *buf, int len, 
+extern int daemon_user_write(int fd, void *buf, int len,
 			     struct daemon_data *pri);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
+#endif
diff -puN arch/um/drivers/daemon_kern.c~uml-network-formatting arch/um/drivers/daemon_kern.c
--- a/arch/um/drivers/daemon_kern.c~uml-network-formatting
+++ a/arch/um/drivers/daemon_kern.c
@@ -1,16 +1,14 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
 
-#include "linux/kernel.h"
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
+#include <linux/netdevice.h>
 #include "net_kern.h"
-#include "net_user.h"
 #include "daemon.h"
 
 struct daemon_init {
@@ -36,25 +34,26 @@ static void daemon_init(struct net_devic
 	dpri->data_addr = NULL;
 	dpri->local_addr = NULL;
 
-	printk("daemon backend (uml_switch version %d) - %s:%s", 
+	printk("daemon backend (uml_switch version %d) - %s:%s",
 	       SWITCH_VERSION, dpri->sock_type, dpri->ctl_sock);
 	printk("\n");
 }
 
-static int daemon_read(int fd, struct sk_buff **skb, 
+static int daemon_read(int fd, struct sk_buff **skb,
 		       struct uml_net_private *lp)
 {
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if(*skb == NULL) return(-ENOMEM);
-	return(net_recvfrom(fd, skb_mac_header(*skb),
-			    (*skb)->dev->mtu + ETH_HEADER_OTHER));
+	if (*skb == NULL)
+		return -ENOMEM;
+	return net_recvfrom(fd, skb_mac_header(*skb),
+			    (*skb)->dev->mtu + ETH_HEADER_OTHER);
 }
 
 static int daemon_write(int fd, struct sk_buff **skb,
 			struct uml_net_private *lp)
 {
-	return(daemon_user_write(fd, (*skb)->data, (*skb)->len, 
-				 (struct daemon_data *) &lp->user));
+	return daemon_user_write(fd, (*skb)->data, (*skb)->len,
+				 (struct daemon_data *) &lp->user);
 }
 
 static const struct net_kern_info daemon_kern_info = {
@@ -72,14 +71,14 @@ static int daemon_setup(char *str, char 
 	*init = ((struct daemon_init)
 		{ .sock_type 		= "unix",
 		  .ctl_sock 		= "/tmp/uml.ctl" });
-	
+
 	remain = split_if_spec(str, mac_out, &init->sock_type, &init->ctl_sock,
 			       NULL);
-	if(remain != NULL)
+	if (remain != NULL)
 		printk(KERN_WARNING "daemon_setup : Ignoring data socket "
 		       "specification\n");
-	
-	return(1);
+
+	return 1;
 }
 
 static struct transport daemon_transport = {
diff -puN arch/um/drivers/daemon_user.c~uml-network-formatting arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-network-formatting
+++ a/arch/um/drivers/daemon_user.c
@@ -1,22 +1,23 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
 
-#include <errno.h>
-#include <unistd.h>
 #include <stdint.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/types.h>
 #include <sys/socket.h>
-#include <sys/un.h>
 #include <sys/time.h>
-#include "net_user.h"
+#include <sys/un.h>
 #include "daemon.h"
-#include "kern_util.h"
-#include "user.h"
+#include "net_user.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "user.h"
 
 #define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
 
@@ -36,8 +37,9 @@ static struct sockaddr_un *new_addr(void
 	struct sockaddr_un *sun;
 
 	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
-	if(sun == NULL){
-		printk("new_addr: allocation of sockaddr_un failed\n");
+	if (sun == NULL) {
+		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		       "failed\n");
 		return NULL;
 	}
 	sun->sun_family = AF_UNIX;
@@ -54,38 +56,39 @@ static int connect_to_switch(struct daem
 	int fd, n, err;
 
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
-	if(pri->control < 0){
+	if (pri->control < 0) {
 		err = -errno;
-		printk("daemon_open : control socket failed, errno = %d\n", 
-		       -err);
+		printk(UM_KERN_ERR "daemon_open : control socket failed, "
+		       "errno = %d\n", -err);
 		return err;
 	}
 
-	if(connect(pri->control, (struct sockaddr *) ctl_addr, 
-		   sizeof(*ctl_addr)) < 0){
+	if (connect(pri->control, (struct sockaddr *) ctl_addr,
+		   sizeof(*ctl_addr)) < 0) {
 		err = -errno;
-		printk("daemon_open : control connect failed, errno = %d\n",
-		       -err);
+		printk(UM_KERN_ERR "daemon_open : control connect failed, "
+		       "errno = %d\n", -err);
 		goto out;
 	}
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
-	if(fd < 0){
+	if (fd < 0) {
 		err = -errno;
-		printk("daemon_open : data socket failed, errno = %d\n",
-		       -err);
+		printk(UM_KERN_ERR "daemon_open : data socket failed, "
+		       "errno = %d\n", -err);
 		goto out;
 	}
-	if(bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0){
+	if (bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0) {
 		err = -errno;
-		printk("daemon_open : data bind failed, errno = %d\n",
-		       -err);
+		printk(UM_KERN_ERR "daemon_open : data bind failed, "
+		       "errno = %d\n", -err);
 		goto out_close;
 	}
 
 	sun = kmalloc(sizeof(struct sockaddr_un), UM_GFP_KERNEL);
-	if(sun == NULL){
-		printk("new_addr: allocation of sockaddr_un failed\n");
+	if (sun == NULL) {
+		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_un "
+		       "failed\n");
 		err = -ENOMEM;
 		goto out_close;
 	}
@@ -94,18 +97,18 @@ static int connect_to_switch(struct daem
 	req.version = SWITCH_VERSION;
 	req.type = REQ_NEW_CONTROL;
 	req.sock = *local_addr;
-	n = os_write_file(pri->control, &req, sizeof(req));
-	if(n != sizeof(req)){
-		printk("daemon_open : control setup request failed, err = %d\n",
-		       -n);
+	n = write(pri->control, &req, sizeof(req));
+	if (n != sizeof(req)) {
+		printk(UM_KERN_ERR "daemon_open : control setup request "
+		       "failed, err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
 	}
 
-	n = os_read_file(pri->control, sun, sizeof(*sun));
-	if(n != sizeof(*sun)){
-		printk("daemon_open : read of data socket failed, err = %d\n",
-		       -n);
+	n = read(pri->control, sun, sizeof(*sun));
+	if (n != sizeof(*sun)) {
+		printk(UM_KERN_ERR "daemon_open : read of data socket failed, "
+		       "err = %d\n", -errno);
 		err = -ENOTCONN;
 		goto out_free;
 	}
@@ -116,9 +119,9 @@ static int connect_to_switch(struct daem
  out_free:
 	kfree(sun);
  out_close:
-	os_close_file(fd);
+	close(fd);
  out:
-	os_close_file(pri->control);
+	close(pri->control);
 	return err;
 }
 
@@ -132,8 +135,8 @@ static int daemon_user_init(void *data, 
 		int usecs;
 	} name;
 
-	if(!strcmp(pri->sock_type, "unix"))
-		pri->ctl_addr = new_addr(pri->ctl_sock, 
+	if (!strcmp(pri->sock_type, "unix"))
+		pri->ctl_addr = new_addr(pri->ctl_sock,
 					 strlen(pri->ctl_sock) + 1);
 	name.zero = 0;
 	name.pid = os_getpid();
@@ -142,7 +145,7 @@ static int daemon_user_init(void *data, 
 	pri->local_addr = new_addr(&name, sizeof(name));
 	pri->dev = dev;
 	pri->fd = connect_to_switch(pri);
-	if(pri->fd < 0){
+	if (pri->fd < 0) {
 		kfree(pri->local_addr);
 		pri->local_addr = NULL;
 		return pri->fd;
@@ -161,9 +164,9 @@ static void daemon_remove(void *data)
 {
 	struct daemon_data *pri = data;
 
-	os_close_file(pri->fd);
+	close(pri->fd);
 	pri->fd = -1;
-	os_close_file(pri->control);
+	close(pri->control);
 	pri->control = -1;
 
 	kfree(pri->data_addr);
diff -puN arch/um/drivers/mcast.h~uml-network-formatting arch/um/drivers/mcast.h
--- a/arch/um/drivers/mcast.h~uml-network-formatting
+++ a/arch/um/drivers/mcast.h
@@ -1,8 +1,11 @@
 /* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
+#ifndef __DRIVERS_MCAST_H
+#define __DRIVERS_MCAST_H
+
 #include "net_user.h"
 
 struct mcast_data {
@@ -18,13 +21,4 @@ extern const struct net_user_info mcast_
 extern int mcast_user_write(int fd, void *buf, int len, 
 			    struct mcast_data *pri);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
+#endif
diff -puN arch/um/drivers/mcast_kern.c~uml-network-formatting arch/um/drivers/mcast_kern.c
--- a/arch/um/drivers/mcast_kern.c~uml-network-formatting
+++ a/arch/um/drivers/mcast_kern.c
@@ -1,24 +1,20 @@
 /*
  * user-mode-linux networking multicast transport
  * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
  * Licensed under the GPL.
  */
 
-#include "linux/kernel.h"
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
-#include "linux/in.h"
-#include "linux/inet.h"
-#include "net_kern.h"
-#include "net_user.h"
+#include <linux/netdevice.h>
 #include "mcast.h"
+#include "net_kern.h"
 
 struct mcast_init {
 	char *addr;
@@ -39,26 +35,23 @@ static void mcast_init(struct net_device
 	dpri->ttl = init->ttl;
 	dpri->dev = dev;
 
-	printk("mcast backend ");
-	printk("multicast address: %s:%u, TTL:%u ",
+	printk("mcast backend multicast address: %s:%u, TTL:%u\n",
 	       dpri->addr, dpri->port, dpri->ttl);
-
-	printk("\n");
 }
 
 static int mcast_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
 {
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if(*skb == NULL) return(-ENOMEM);
-	return(net_recvfrom(fd, skb_mac_header(*skb),
-			    (*skb)->dev->mtu + ETH_HEADER_OTHER));
+	if (*skb == NULL)
+		return -ENOMEM;
+	return net_recvfrom(fd, skb_mac_header(*skb),
+			    (*skb)->dev->mtu + ETH_HEADER_OTHER);
 }
 
-static int mcast_write(int fd, struct sk_buff **skb,
-			struct uml_net_private *lp)
+static int mcast_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
 {
-	return mcast_user_write(fd, (*skb)->data, (*skb)->len, 
-				 (struct mcast_data *) &lp->user);
+	return mcast_user_write(fd, (*skb)->data, (*skb)->len,
+				(struct mcast_data *) &lp->user);
 }
 
 static const struct net_kern_info mcast_kern_info = {
@@ -81,34 +74,34 @@ int mcast_setup(char *str, char **mac_ou
 
 	remain = split_if_spec(str, mac_out, &init->addr, &port_str, &ttl_str,
 			       NULL);
-	if(remain != NULL){
+	if (remain != NULL) {
 		printk(KERN_ERR "mcast_setup - Extra garbage on "
 		       "specification : '%s'\n", remain);
-		return(0);
+		return 0;
 	}
-	
-	if(port_str != NULL){
+
+	if (port_str != NULL) {
 		init->port = simple_strtoul(port_str, &last, 10);
-		if((*last != '\0') || (last == port_str)){
-			printk(KERN_ERR "mcast_setup - Bad port : '%s'\n", 
+		if ((*last != '\0') || (last == port_str)) {
+			printk(KERN_ERR "mcast_setup - Bad port : '%s'\n",
 			       port_str);
-			return(0);
+			return 0;
 		}
 	}
 
-	if(ttl_str != NULL){
+	if (ttl_str != NULL) {
 		init->ttl = simple_strtoul(ttl_str, &last, 10);
-		if((*last != '\0') || (last == ttl_str)){
-			printk(KERN_ERR "mcast_setup - Bad ttl : '%s'\n", 
+		if ((*last != '\0') || (last == ttl_str)) {
+			printk(KERN_ERR "mcast_setup - Bad ttl : '%s'\n",
 			       ttl_str);
-			return(0);
+			return 0;
 		}
 	}
 
 	printk(KERN_INFO "Configured mcast device: %s:%u-%u\n", init->addr,
 	       init->port, init->ttl);
 
-	return(1);
+	return 1;
 }
 
 static struct transport mcast_transport = {
diff -puN arch/um/drivers/mcast_user.c~uml-network-formatting arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-network-formatting
+++ a/arch/um/drivers/mcast_user.c
@@ -1,9 +1,10 @@
 /*
  * user-mode-linux networking multicast transport
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
@@ -11,18 +12,13 @@
  *
  */
 
-#include <errno.h>
 #include <unistd.h>
-#include <sys/socket.h>
-#include <sys/un.h>
-#include <sys/time.h>
+#include <errno.h>
 #include <netinet/in.h>
-#include "net_user.h"
 #include "mcast.h"
-#include "kern_util.h"
-#include "user.h"
-#include "os.h"
+#include "net_user.h"
 #include "um_malloc.h"
+#include "user.h"
 
 #define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
 
@@ -31,8 +27,9 @@ static struct sockaddr_in *new_addr(char
 	struct sockaddr_in *sin;
 
 	sin = kmalloc(sizeof(struct sockaddr_in), UM_GFP_KERNEL);
-	if(sin == NULL){
-		printk("new_addr: allocation of sockaddr_in failed\n");
+	if (sin == NULL) {
+		printk(UM_KERN_ERR "new_addr: allocation of sockaddr_in "
+		       "failed\n");
 		return NULL;
 	}
 	sin->sin_family = AF_INET;
@@ -71,17 +68,17 @@ static int mcast_open(void *data)
 
 	fd = socket(AF_INET, SOCK_DGRAM, 0);
 
-	if (fd < 0){
+	if (fd < 0) {
 		err = -errno;
-		printk("mcast_open : data socket failed, errno = %d\n", 
-		       errno);
+		printk(UM_KERN_ERR "mcast_open : data socket failed, "
+		       "errno = %d\n", errno);
 		goto out;
 	}
 
 	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0) {
 		err = -errno;
-		printk("mcast_open: SO_REUSEADDR failed, errno = %d\n",
-			errno);
+		printk(UM_KERN_ERR "mcast_open: SO_REUSEADDR failed, "
+		       "errno = %d\n", errno);
 		goto out_close;
 	}
 
@@ -89,45 +86,46 @@ static int mcast_open(void *data)
 	if (setsockopt(fd, SOL_IP, IP_MULTICAST_TTL, &pri->ttl,
 		       sizeof(pri->ttl)) < 0) {
 		err = -errno;
-		printk("mcast_open: IP_MULTICAST_TTL failed, error = %d\n",
-			errno);
+		printk(UM_KERN_ERR "mcast_open: IP_MULTICAST_TTL failed, "
+		       "error = %d\n", errno);
 		goto out_close;
 	}
 
 	/* set LOOP, so data does get fed back to local sockets */
 	if (setsockopt(fd, SOL_IP, IP_MULTICAST_LOOP, &yes, sizeof(yes)) < 0) {
 		err = -errno;
-		printk("mcast_open: IP_MULTICAST_LOOP failed, error = %d\n",
-			errno);
+		printk(UM_KERN_ERR "mcast_open: IP_MULTICAST_LOOP failed, "
+		       "error = %d\n", errno);
 		goto out_close;
 	}
 
 	/* bind socket to mcast address */
 	if (bind(fd, (struct sockaddr *) sin, sizeof(*sin)) < 0) {
 		err = -errno;
-		printk("mcast_open : data bind failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "mcast_open : data bind failed, "
+		       "errno = %d\n", errno);
 		goto out_close;
 	}
 
 	/* subscribe to the multicast group */
 	mreq.imr_multiaddr.s_addr = sin->sin_addr.s_addr;
 	mreq.imr_interface.s_addr = 0;
-	if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP, 
+	if (setsockopt(fd, SOL_IP, IP_ADD_MEMBERSHIP,
 		       &mreq, sizeof(mreq)) < 0) {
 		err = -errno;
-		printk("mcast_open: IP_ADD_MEMBERSHIP failed, error = %d\n",
-			errno);
-		printk("There appears not to be a multicast-capable network "
-		       "interface on the host.\n");
-		printk("eth0 should be configured in order to use the "
-		       "multicast transport.\n");
+		printk(UM_KERN_ERR "mcast_open: IP_ADD_MEMBERSHIP failed, "
+		       "error = %d\n", errno);
+		printk(UM_KERN_ERR "There appears not to be a multicast-"
+		       "capable network interface on the host.\n");
+		printk(UM_KERN_ERR "eth0 should be configured in order to use "
+		       "the multicast transport.\n");
 		goto out_close;
 	}
 
 	return fd;
 
  out_close:
-	os_close_file(fd);
+	close(fd);
  out:
 	return err;
 }
@@ -142,11 +140,11 @@ static void mcast_close(int fd, void *da
 	mreq.imr_interface.s_addr = 0;
 	if (setsockopt(fd, SOL_IP, IP_DROP_MEMBERSHIP,
 		       &mreq, sizeof(mreq)) < 0) {
-		printk("mcast_open: IP_DROP_MEMBERSHIP failed, error = %d\n",
-			errno);
+		printk(UM_KERN_ERR "mcast_open: IP_DROP_MEMBERSHIP failed, "
+		       "error = %d\n", errno);
 	}
 
-	os_close_file(fd);
+	close(fd);
 }
 
 int mcast_user_write(int fd, void *buf, int len, struct mcast_data *pri)
diff -puN arch/um/drivers/net_kern.c~uml-network-formatting arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-formatting
+++ a/arch/um/drivers/net_kern.c
@@ -1,33 +1,28 @@
 /*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
 
-#include "linux/kernel.h"
-#include "linux/netdevice.h"
-#include "linux/rtnetlink.h"
-#include "linux/skbuff.h"
-#include "linux/socket.h"
-#include "linux/spinlock.h"
-#include "linux/module.h"
-#include "linux/init.h"
-#include "linux/etherdevice.h"
-#include "linux/list.h"
-#include "linux/inetdevice.h"
-#include "linux/ctype.h"
-#include "linux/bootmem.h"
-#include "linux/ethtool.h"
-#include "linux/platform_device.h"
-#include "asm/uaccess.h"
-#include "kern_util.h"
-#include "net_kern.h"
-#include "net_user.h"
-#include "mconsole_kern.h"
+#include <linux/bootmem.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/inetdevice.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
 #include "init.h"
-#include "irq_user.h"
 #include "irq_kern.h"
+#include "irq_user.h"
+#include "mconsole_kern.h"
+#include "net_kern.h"
+#include "net_user.h"
 
 static inline void set_ether_mac(struct net_device *dev, unsigned char *addr)
 {
@@ -84,12 +79,12 @@ irqreturn_t uml_net_interrupt(int irq, v
 	struct uml_net_private *lp = dev->priv;
 	int err;
 
-	if(!netif_running(dev))
-		return(IRQ_NONE);
+	if (!netif_running(dev))
+		return IRQ_NONE;
 
 	spin_lock(&lp->lock);
-	while((err = uml_net_rx(dev)) > 0) ;
-	if(err < 0) {
+	while ((err = uml_net_rx(dev)) > 0) ;
+	if (err < 0) {
 		printk(KERN_ERR
 		       "Device '%s' read returned %d, shutting it down\n",
 		       dev->name, err);
@@ -115,20 +110,20 @@ static int uml_net_open(struct net_devic
 	struct uml_net_private *lp = dev->priv;
 	int err;
 
-	if(lp->fd >= 0){
+	if (lp->fd >= 0) {
 		err = -ENXIO;
 		goto out;
 	}
 
 	lp->fd = (*lp->open)(&lp->user);
-	if(lp->fd < 0){
+	if (lp->fd < 0) {
 		err = lp->fd;
 		goto out;
 	}
 
 	err = um_request_irq(dev->irq, lp->fd, IRQ_READ, uml_net_interrupt,
 			     IRQF_DISABLED | IRQF_SHARED, dev->name, dev);
-	if(err != 0){
+	if (err != 0) {
 		printk(KERN_ERR "uml_net_open: failed to get irq(%d)\n", err);
 		err = -ENETUNREACH;
 		goto out_close;
@@ -141,7 +136,7 @@ static int uml_net_open(struct net_devic
 	 * is full when we get here.  In this case, new data is never queued,
 	 * SIGIOs never arrive, and the net never works.
 	 */
-	while((err = uml_net_rx(dev)) > 0) ;
+	while ((err = uml_net_rx(dev)) > 0) ;
 
 	spin_lock(&opened_lock);
 	list_add(&lp->list, &opened);
@@ -149,7 +144,7 @@ static int uml_net_open(struct net_devic
 
 	return 0;
 out_close:
-	if(lp->close != NULL) (*lp->close)(lp->fd, &lp->user);
+	if (lp->close != NULL) (*lp->close)(lp->fd, &lp->user);
 	lp->fd = -1;
 out:
 	return err;
@@ -162,7 +157,7 @@ static int uml_net_close(struct net_devi
 	netif_stop_queue(dev);
 
 	free_irq(dev->irq, dev);
-	if(lp->close != NULL)
+	if (lp->close != NULL)
 		(*lp->close)(lp->fd, &lp->user);
 	lp->fd = -1;
 
@@ -185,7 +180,7 @@ static int uml_net_start_xmit(struct sk_
 
 	len = (*lp->write)(lp->fd, &skb, lp);
 
-	if(len == skb->len) {
+	if (len == skb->len) {
 		lp->stats.tx_packets++;
 		lp->stats.tx_bytes += skb->len;
 		dev->trans_start = jiffies;
@@ -194,7 +189,7 @@ static int uml_net_start_xmit(struct sk_
 		/* this is normally done in the interrupt when tx finishes */
 		netif_wake_queue(dev);
 	}
-	else if(len == 0){
+	else if (len == 0) {
 		netif_start_queue(dev);
 		lp->stats.tx_dropped++;
 	}
@@ -218,8 +213,10 @@ static struct net_device_stats *uml_net_
 
 static void uml_net_set_multicast_list(struct net_device *dev)
 {
-	if (dev->flags & IFF_PROMISC) return;
-	else if (dev->mc_count)	dev->flags |= IFF_ALLMULTI;
+	if (dev->flags & IFF_PROMISC)
+		return;
+	else if (dev->mc_count)
+		dev->flags |= IFF_ALLMULTI;
 	else dev->flags &= ~IFF_ALLMULTI;
 }
 
@@ -249,7 +246,7 @@ static int uml_net_change_mtu(struct net
 	spin_lock_irq(&lp->lock);
 
 	new_mtu = (*lp->set_mtu)(new_mtu, &lp->user);
-	if(new_mtu < 0){
+	if (new_mtu < 0) {
 		err = new_mtu;
 		goto out;
 	}
@@ -288,13 +285,13 @@ static void setup_etheraddr(char *str, u
 	char *end;
 	int i;
 
-	if(str == NULL)
+	if (str == NULL)
 		goto random;
 
-	for(i=0;i<6;i++){
+	for (i = 0;i < 6; i++) {
 		addr[i] = simple_strtoul(str, &end, 16);
-		if((end == str) ||
-		   ((*end != ':') && (*end != ',') && (*end != '\0'))){
+		if ((end == str) ||
+		   ((*end != ':') && (*end != ',') && (*end != '\0'))) {
 			printk(KERN_ERR
 			       "setup_etheraddr: failed to parse '%s' "
 			       "as an ethernet address\n", str);
@@ -349,7 +346,7 @@ static void net_device_release(struct de
 	struct net_device *netdev = device->dev;
 	struct uml_net_private *lp = netdev->priv;
 
-	if(lp->remove != NULL)
+	if (lp->remove != NULL)
 		(*lp->remove)(&lp->user);
 	list_del(&device->list);
 	kfree(device);
@@ -413,7 +410,7 @@ static void eth_configure(int n, void *i
 	device->pdev.name = DRIVER_NAME;
 	device->pdev.dev.release = net_device_release;
 	device->pdev.dev.driver_data = device;
-	if(platform_device_register(&device->pdev))
+	if (platform_device_register(&device->pdev))
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
 
@@ -493,9 +490,9 @@ static struct uml_net *find_device(int n
 	struct list_head *ele;
 
 	spin_lock(&devices_lock);
-	list_for_each(ele, &devices){
+	list_for_each(ele, &devices) {
 		device = list_entry(ele, struct uml_net, list);
-		if(device->index == n)
+		if (device->index == n)
 			goto out;
 	}
 	device = NULL;
@@ -511,19 +508,19 @@ static int eth_parse(char *str, int *ind
 	int n, err = -EINVAL;;
 
 	n = simple_strtoul(str, &end, 0);
-	if(end == str){
+	if (end == str) {
 		*error_out = "Bad device number";
 		return err;
 	}
 
 	str = end;
-	if(*str != '='){
+	if (*str != '=') {
 		*error_out = "Expected '=' after device number";
 		return err;
 	}
 
 	str++;
-	if(find_device(n)){
+	if (find_device(n)) {
 		*error_out = "Device already configured";
 		return err;
 	}
@@ -551,20 +548,20 @@ static int check_transport(struct transp
 	int len;
 
 	len = strlen(transport->name);
-	if(strncmp(eth, transport->name, len))
+	if (strncmp(eth, transport->name, len))
 		return 0;
 
 	eth += len;
-	if(*eth == ',')
+	if (*eth == ',')
 		eth++;
-	else if(*eth != '\0')
+	else if (*eth != '\0')
 		return 0;
 
 	*init_out = kmalloc(transport->setup_size, GFP_KERNEL);
-	if(*init_out == NULL)
+	if (*init_out == NULL)
 		return 1;
 
-	if(!transport->setup(eth, mac_out, *init_out)){
+	if (!transport->setup(eth, mac_out, *init_out)) {
 		kfree(*init_out);
 		*init_out = NULL;
 	}
@@ -584,13 +581,13 @@ void register_transport(struct transport
 	list_add(&new->list, &transports);
 	spin_unlock(&transports_lock);
 
-	list_for_each_safe(ele, next, &eth_cmd_line){
+	list_for_each_safe(ele, next, &eth_cmd_line) {
 		eth = list_entry(ele, struct eth_init, list);
 		match = check_transport(new, eth->init, eth->index, &init,
 					&mac);
-		if(!match)
+		if (!match)
 			continue;
-		else if(init != NULL){
+		else if (init != NULL) {
 			eth_configure(eth->index, init, mac, new);
 			kfree(init);
 		}
@@ -607,11 +604,11 @@ static int eth_setup_common(char *str, i
 	int found = 0;
 
 	spin_lock(&transports_lock);
-	list_for_each(ele, &transports){
+	list_for_each(ele, &transports) {
 		transport = list_entry(ele, struct transport, list);
-	        if(!check_transport(transport, str, index, &init, &mac))
+	        if (!check_transport(transport, str, index, &init, &mac))
 			continue;
-		if(init != NULL){
+		if (init != NULL) {
 			eth_configure(index, init, mac, transport);
 			kfree(init);
 		}
@@ -630,15 +627,15 @@ static int __init eth_setup(char *str)
 	int n, err;
 
 	err = eth_parse(str, &n, &str, &error);
-	if(err){
+	if (err) {
 		printk(KERN_ERR "eth_setup - Couldn't parse '%s' : %s\n",
 		       str, error);
 		return 1;
 	}
 
 	new = alloc_bootmem(sizeof(*new));
-	if (new == NULL){
-		printk("eth_init : alloc_bootmem failed\n");
+	if (new == NULL) {
+		printk(KERN_ERR "eth_init : alloc_bootmem failed\n");
 		return 1;
 	}
 
@@ -661,36 +658,36 @@ static int net_config(char *str, char **
 	int n, err;
 
 	err = eth_parse(str, &n, &str, error_out);
-	if(err)
+	if (err)
 		return err;
 
 	/* This string is broken up and the pieces used by the underlying
 	 * driver.  So, it is freed only if eth_setup_common fails.
 	 */
 	str = kstrdup(str, GFP_KERNEL);
-	if(str == NULL){
+	if (str == NULL) {
 	        *error_out = "net_config failed to strdup string";
 		return -ENOMEM;
 	}
 	err = !eth_setup_common(str, n);
-	if(err)
+	if (err)
 		kfree(str);
-	return(err);
+	return err;
 }
 
 static int net_id(char **str, int *start_out, int *end_out)
 {
-        char *end;
-        int n;
+	char *end;
+	int n;
 
 	n = simple_strtoul(*str, &end, 0);
-	if((*end != '\0') || (end == *str))
+	if ((*end != '\0') || (end == *str))
 		return -1;
 
-        *start_out = n;
-        *end_out = n;
-        *str = end;
-        return n;
+	*start_out = n;
+	*end_out = n;
+	*str = end;
+	return n;
 }
 
 static int net_remove(int n, char **error_out)
@@ -700,12 +697,12 @@ static int net_remove(int n, char **erro
 	struct uml_net_private *lp;
 
 	device = find_device(n);
-	if(device == NULL)
+	if (device == NULL)
 		return -ENODEV;
 
 	dev = device->dev;
 	lp = dev->priv;
-	if(lp->fd > 0)
+	if (lp->fd > 0)
 		return -EBUSY;
 	unregister_netdev(dev);
 	platform_device_unregister(&device->pdev);
@@ -731,13 +728,13 @@ static int uml_inetaddr_event(struct not
 	void (*proc)(unsigned char *, unsigned char *, void *);
 	unsigned char addr_buf[4], netmask_buf[4];
 
-	if(dev->open != uml_net_open)
+	if (dev->open != uml_net_open)
 		return NOTIFY_DONE;
 
 	lp = dev->priv;
 
 	proc = NULL;
-	switch (event){
+	switch (event) {
 	case NETDEV_UP:
 		proc = lp->add_address;
 		break;
@@ -745,7 +742,7 @@ static int uml_inetaddr_event(struct not
 		proc = lp->delete_address;
 		break;
 	}
-	if(proc != NULL){
+	if (proc != NULL) {
 		memcpy(addr_buf, &ifa->ifa_address, sizeof(addr_buf));
 		memcpy(netmask_buf, &ifa->ifa_mask, sizeof(netmask_buf));
 		(*proc)(addr_buf, netmask_buf, &lp->user);
@@ -773,13 +770,13 @@ static int uml_net_init(void)
 	 * addresses which have already been set up get handled properly.
 	 */
 	spin_lock(&opened_lock);
-	list_for_each(ele, &opened){
+	list_for_each(ele, &opened) {
 		lp = list_entry(ele, struct uml_net_private, list);
 		ip = lp->dev->ip_ptr;
-		if(ip == NULL)
+		if (ip == NULL)
 			continue;
 		in = ip->ifa_list;
-		while(in != NULL){
+		while (in != NULL) {
 			uml_inetaddr_event(NULL, NETDEV_UP, in);
 			in = in->ifa_next;
 		}
@@ -797,12 +794,12 @@ static void close_devices(void)
 	struct uml_net_private *lp;
 
 	spin_lock(&opened_lock);
-	list_for_each(ele, &opened){
+	list_for_each(ele, &opened) {
 		lp = list_entry(ele, struct uml_net_private, list);
 		free_irq(lp->dev->irq, lp->dev);
-		if((lp->close != NULL) && (lp->fd >= 0))
+		if ((lp->close != NULL) && (lp->fd >= 0))
 			(*lp->close)(lp->fd, &lp->user);
-		if(lp->remove != NULL)
+		if (lp->remove != NULL)
 			(*lp->remove)(&lp->user);
 	}
 	spin_unlock(&opened_lock);
@@ -812,15 +809,15 @@ __uml_exitcall(close_devices);
 
 struct sk_buff *ether_adjust_skb(struct sk_buff *skb, int extra)
 {
-	if((skb != NULL) && (skb_tailroom(skb) < extra)){
+	if ((skb != NULL) && (skb_tailroom(skb) < extra)) {
 	  	struct sk_buff *skb2;
 
 		skb2 = skb_copy_expand(skb, 0, extra, GFP_ATOMIC);
 		dev_kfree_skb(skb);
 		skb = skb2;
 	}
-	if(skb != NULL) skb_put(skb, extra);
-	return(skb);
+	if (skb != NULL) skb_put(skb, extra);
+	return skb;
 }
 
 void iter_addresses(void *d, void (*cb)(unsigned char *, unsigned char *,
@@ -832,9 +829,9 @@ void iter_addresses(void *d, void (*cb)(
 	struct in_ifaddr *in;
 	unsigned char address[4], netmask[4];
 
-	if(ip == NULL) return;
+	if (ip == NULL) return;
 	in = ip->ifa_list;
-	while(in != NULL){
+	while (in != NULL) {
 		memcpy(address, &in->ifa_address, sizeof(address));
 		memcpy(netmask, &in->ifa_mask, sizeof(netmask));
 		(*cb)(address, netmask, arg);
@@ -849,15 +846,15 @@ int dev_netmask(void *d, void *m)
 	struct in_ifaddr *in;
 	__be32 *mask_out = m;
 
-	if(ip == NULL)
-		return(1);
+	if (ip == NULL)
+		return 1;
 
 	in = ip->ifa_list;
-	if(in == NULL)
-		return(1);
+	if (in == NULL)
+		return 1;
 
 	*mask_out = in->ifa_mask;
-	return(0);
+	return 0;
 }
 
 void *get_output_buffer(int *len_out)
@@ -865,7 +862,7 @@ void *get_output_buffer(int *len_out)
 	void *ret;
 
 	ret = (void *) __get_free_pages(GFP_KERNEL, 0);
-	if(ret) *len_out = PAGE_SIZE;
+	if (ret) *len_out = PAGE_SIZE;
 	else *len_out = 0;
 	return ret;
 }
@@ -881,16 +878,16 @@ int tap_setup_common(char *str, char *ty
 	char *remain;
 
 	remain = split_if_spec(str, dev_name, mac_out, gate_addr, NULL);
-	if(remain != NULL){
-		printk("tap_setup_common - Extra garbage on specification : "
-		       "'%s'\n", remain);
-		return(1);
+	if (remain != NULL) {
+		printk(KERN_ERR "tap_setup_common - Extra garbage on "
+		       "specification : '%s'\n", remain);
+		return 1;
 	}
 
-	return(0);
+	return 0;
 }
 
 unsigned short eth_protocol(struct sk_buff *skb)
 {
-	return(eth_type_trans(skb, skb->dev));
+	return eth_type_trans(skb, skb->dev);
 }
diff -puN arch/um/drivers/net_user.c~uml-network-formatting arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-network-formatting
+++ a/arch/um/drivers/net_user.c
@@ -1,34 +1,32 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stddef.h>
-#include <stdarg.h>
-#include <unistd.h>
 #include <stdio.h>
+#include <unistd.h>
+#include <stdarg.h>
 #include <errno.h>
-#include <stdlib.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
-#include <sys/time.h>
-#include "user.h"
-#include "kern_util.h"
 #include "net_user.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
-#include "kern_constants.h"
+#include "user.h"
 
 int tap_open_common(void *dev, char *gate_addr)
 {
 	int tap_addr[4];
 
-	if(gate_addr == NULL)
+	if (gate_addr == NULL)
 		return 0;
-	if(sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0], 
-		  &tap_addr[1], &tap_addr[2], &tap_addr[3]) != 4){
-		printk("Invalid tap IP address - '%s'\n", gate_addr);
+	if (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0],
+		  &tap_addr[1], &tap_addr[2], &tap_addr[3]) != 4) {
+		printk(UM_KERN_ERR "Invalid tap IP address - '%s'\n",
+		       gate_addr);
 		return -EINVAL;
 	}
 	return 0;
@@ -38,15 +36,15 @@ void tap_check_ips(char *gate_addr, unsi
 {
 	int tap_addr[4];
 
-	if((gate_addr != NULL) && 
-	   (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0], 
-		   &tap_addr[1], &tap_addr[2], &tap_addr[3]) == 4) &&
-	   (eth_addr[0] == tap_addr[0]) && 
-	   (eth_addr[1] == tap_addr[1]) && 
-	   (eth_addr[2] == tap_addr[2]) && 
-	   (eth_addr[3] == tap_addr[3])){
-		printk("The tap IP address and the UML eth IP address"
-		       " must be different\n");
+	if ((gate_addr != NULL) &&
+	    (sscanf(gate_addr, "%d.%d.%d.%d", &tap_addr[0],
+		    &tap_addr[1], &tap_addr[2], &tap_addr[3]) == 4) &&
+	    (eth_addr[0] == tap_addr[0]) &&
+	    (eth_addr[1] == tap_addr[1]) &&
+	    (eth_addr[2] == tap_addr[2]) &&
+	    (eth_addr[3] == tap_addr[3])) {
+		printk(UM_KERN_ERR "The tap IP address and the UML eth IP "
+		       "address must be different\n");
 	}
 }
 
@@ -57,24 +55,28 @@ void read_output(int fd, char *output, i
 	char c;
 	char *str;
 
-	if(output == NULL){
+	if (output == NULL) {
 		output = &c;
 		len = sizeof(c);
 	}
-		
+
 	*output = '\0';
-	ret = os_read_file(fd, &remain, sizeof(remain));
+	ret = read(fd, &remain, sizeof(remain));
 
 	if (ret != sizeof(remain)) {
+		if (ret < 0)
+			ret = -errno;
 		expected = sizeof(remain);
 		str = "length";
 		goto err;
 	}
 
-	while(remain != 0){
+	while (remain != 0) {
 		expected = (remain < len) ? remain : len;
-		ret = os_read_file(fd, output, expected);
+		ret = read(fd, output, expected);
 		if (ret != expected) {
+			if (ret < 0)
+				ret = -errno;
 			str = "data";
 			goto err;
 		}
@@ -85,20 +87,22 @@ void read_output(int fd, char *output, i
 
 err:
 	if (ret < 0)
-		printk("read_output - read of %s failed, errno = %d\n", str, -ret);
+		printk(UM_KERN_ERR "read_output - read of %s failed, "
+		       "errno = %d\n", str, -ret);
 	else
-		printk("read_output - read of %s failed, read only %d of %d bytes\n", str, ret, expected);
+		printk(UM_KERN_ERR "read_output - read of %s failed, read only "
+		       "%d of %d bytes\n", str, ret, expected);
 }
 
 int net_read(int fd, void *buf, int len)
 {
 	int n;
 
-	n = os_read_file(fd,  buf,  len);
+	n = read(fd,  buf,  len);
 
-	if(n == -EAGAIN)
+	if ((n < 0) && (errno == EAGAIN))
 		return 0;
-	else if(n == 0)
+	else if (n == 0)
 		return -ENOTCONN;
 	return n;
 }
@@ -108,12 +112,12 @@ int net_recvfrom(int fd, void *buf, int 
 	int n;
 
 	CATCH_EINTR(n = recvfrom(fd,  buf,  len, 0, NULL, NULL));
-	if(n < 0){
-		if(errno == EAGAIN)
+	if (n < 0) {
+		if (errno == EAGAIN)
 			return 0;
 		return -errno;
 	}
-	else if(n == 0)
+	else if (n == 0)
 		return -ENOTCONN;
 	return n;
 }
@@ -122,11 +126,11 @@ int net_write(int fd, void *buf, int len
 {
 	int n;
 
-	n = os_write_file(fd, buf, len);
+	n = write(fd, buf, len);
 
-	if(n == -EAGAIN)
+	if ((n < 0) && (errno == EAGAIN))
 		return 0;
-	else if(n == 0)
+	else if (n == 0)
 		return -ENOTCONN;
 	return n;
 }
@@ -136,12 +140,12 @@ int net_send(int fd, void *buf, int len)
 	int n;
 
 	CATCH_EINTR(n = send(fd, buf, len, 0));
-	if(n < 0){
-		if(errno == EAGAIN)
+	if (n < 0) {
+		if (errno == EAGAIN)
 			return 0;
 		return -errno;
 	}
-	else if(n == 0)
+	else if (n == 0)
 		return -ENOTCONN;
 	return n;
 }
@@ -152,12 +156,12 @@ int net_sendto(int fd, void *buf, int le
 
 	CATCH_EINTR(n = sendto(fd, buf, len, 0, (struct sockaddr *) to,
 			       sock_len));
-	if(n < 0){
-		if(errno == EAGAIN)
+	if (n < 0) {
+		if (errno == EAGAIN)
 			return 0;
 		return -errno;
 	}
-	else if(n == 0)
+	else if (n == 0)
 		return -ENOTCONN;
 	return n;
 }
@@ -171,7 +175,7 @@ static void change_pre_exec(void *arg)
 {
 	struct change_pre_exec_data *data = arg;
 
-	os_close_file(data->close_me);
+	close(data->close_me);
 	dup2(data->stdout, 1);
 }
 
@@ -181,8 +185,9 @@ static int change_tramp(char **argv, cha
 	struct change_pre_exec_data pe_data;
 
 	err = os_pipe(fds, 1, 0);
-	if(err < 0){
-		printk("change_tramp - pipe failed, err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "change_tramp - pipe failed, err = %d\n",
+		       -err);
 		return err;
 	}
 	pe_data.close_me = fds[0];
@@ -192,8 +197,8 @@ static int change_tramp(char **argv, cha
 	if (pid > 0)	/* Avoid hang as we won't get data in failure case. */
 		read_output(fds[0], output, output_len);
 
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
+	close(fds[0]);
+	close(fds[1]);
 
 	if (pid > 0)
 		CATCH_EINTR(err = waitpid(pid, NULL, 0));
@@ -206,25 +211,26 @@ static void change(char *dev, char *what
 	char addr_buf[sizeof("255.255.255.255\0")];
 	char netmask_buf[sizeof("255.255.255.255\0")];
 	char version[sizeof("nnnnn\0")];
-	char *argv[] = { "uml_net", version, what, dev, addr_buf, 
+	char *argv[] = { "uml_net", version, what, dev, addr_buf,
 			 netmask_buf, NULL };
 	char *output;
 	int output_len, pid;
 
 	sprintf(version, "%d", UML_NET_VERSION);
 	sprintf(addr_buf, "%d.%d.%d.%d", addr[0], addr[1], addr[2], addr[3]);
-	sprintf(netmask_buf, "%d.%d.%d.%d", netmask[0], netmask[1], 
+	sprintf(netmask_buf, "%d.%d.%d.%d", netmask[0], netmask[1],
 		netmask[2], netmask[3]);
 
 	output_len = UM_KERN_PAGE_SIZE;
 	output = kmalloc(output_len, UM_GFP_KERNEL);
-	if(output == NULL)
-		printk("change : failed to allocate output buffer\n");
+	if (output == NULL)
+		printk(UM_KERN_ERR "change : failed to allocate output "
+		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
-	if(pid < 0) return;
+	if (pid < 0) return;
 
-	if(output != NULL){
+	if (output != NULL) {
 		printk("%s", output);
 		kfree(output);
 	}
@@ -246,13 +252,13 @@ char *split_if_spec(char *str, ...)
 	va_list ap;
 
 	va_start(ap, str);
-	while((arg = va_arg(ap, char **)) != NULL){
-		if(*str == '\0')
+	while ((arg = va_arg(ap, char **)) != NULL) {
+		if (*str == '\0')
 			return NULL;
 		end = strchr(str, ',');
-		if(end != str)
+		if (end != str)
 			*arg = str;
-		if(end == NULL)
+		if (end == NULL)
 			return NULL;
 		*end++ = '\0';
 		str = end;
diff -puN arch/um/drivers/pcap_kern.c~uml-network-formatting arch/um/drivers/pcap_kern.c
--- a/arch/um/drivers/pcap_kern.c~uml-network-formatting
+++ a/arch/um/drivers/pcap_kern.c
@@ -1,13 +1,11 @@
 /*
- * Copyright (C) 2002 Jeff Dike <jdike@karaya.com>
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL.
  */
 
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
+#include <linux/netdevice.h>
 #include "net_kern.h"
-#include "net_user.h"
 #include "pcap_user.h"
 
 struct pcap_init {
@@ -37,7 +35,7 @@ static int pcap_read(int fd, struct sk_b
 		       struct uml_net_private *lp)
 {
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if(*skb == NULL)
+	if (*skb == NULL)
 		return -ENOMEM;
 
 	return pcap_user_read(fd, skb_mac_header(*skb),
@@ -71,28 +69,29 @@ int pcap_setup(char *str, char **mac_out
 
 	remain = split_if_spec(str, &host_if, &init->filter,
 			       &options[0], &options[1], mac_out, NULL);
-	if(remain != NULL){
+	if (remain != NULL) {
 		printk(KERN_ERR "pcap_setup - Extra garbage on "
 		       "specification : '%s'\n", remain);
 		return 0;
 	}
 
-	if(host_if != NULL)
+	if (host_if != NULL)
 		init->host_if = host_if;
 
-	for(i = 0; i < ARRAY_SIZE(options); i++){
-		if(options[i] == NULL)
+	for (i = 0; i < ARRAY_SIZE(options); i++) {
+		if (options[i] == NULL)
 			continue;
-		if(!strcmp(options[i], "promisc"))
+		if (!strcmp(options[i], "promisc"))
 			init->promisc = 1;
-		else if(!strcmp(options[i], "nopromisc"))
+		else if (!strcmp(options[i], "nopromisc"))
 			init->promisc = 0;
-		else if(!strcmp(options[i], "optimize"))
+		else if (!strcmp(options[i], "optimize"))
 			init->optimize = 1;
-		else if(!strcmp(options[i], "nooptimize"))
+		else if (!strcmp(options[i], "nooptimize"))
 			init->optimize = 0;
 		else {
-			printk("pcap_setup : bad option - '%s'\n", options[i]);
+			printk(KERN_ERR "pcap_setup : bad option - '%s'\n",
+			       options[i]);
 			return 0;
 		}
 	}
diff -puN arch/um/drivers/pcap_user.c~uml-network-formatting arch/um/drivers/pcap_user.c
--- a/arch/um/drivers/pcap_user.c~uml-network-formatting
+++ a/arch/um/drivers/pcap_user.c
@@ -1,19 +1,17 @@
 /*
- * Copyright (C) 2002 Jeff Dike <jdike@karaya.com>
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL.
  */
 
-#include <unistd.h>
-#include <stdlib.h>
-#include <string.h>
 #include <errno.h>
 #include <pcap.h>
+#include <string.h>
 #include <asm/types.h>
 #include "net_user.h"
 #include "pcap_user.h"
-#include "user.h"
-#include "um_malloc.h"
 #include "kern_constants.h"
+#include "um_malloc.h"
+#include "user.h"
 
 #define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
 
@@ -26,7 +24,7 @@ static int pcap_user_init(void *data, vo
 	char errors[PCAP_ERRBUF_SIZE];
 
 	p = pcap_open_live(pri->host_if, MAX_PACKET, pri->promisc, 0, errors);
-	if(p == NULL){
+	if (p == NULL) {
 		printk(UM_KERN_ERR "pcap_user_init : pcap_open_live failed - "
 		       "'%s'\n", errors);
 		return -EINVAL;
@@ -43,50 +41,55 @@ static int pcap_open(void *data)
 	__u32 netmask;
 	int err;
 
-	if(pri->pcap == NULL)
+	if (pri->pcap == NULL)
 		return -ENODEV;
 
-	if(pri->filter != NULL){
+	if (pri->filter != NULL) {
 		err = dev_netmask(pri->dev, &netmask);
-		if(err < 0){
+		if (err < 0) {
 			printk(UM_KERN_ERR "pcap_open : dev_netmask failed\n");
 			return -EIO;
 		}
 
-		pri->compiled = kmalloc(sizeof(struct bpf_program), UM_GFP_KERNEL);
-		if(pri->compiled == NULL){
+		pri->compiled = kmalloc(sizeof(struct bpf_program),
+					UM_GFP_KERNEL);
+		if (pri->compiled == NULL) {
 			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
 			return -ENOMEM;
 		}
 
-		err = pcap_compile(pri->pcap, 
-				   (struct bpf_program *) pri->compiled, 
+		err = pcap_compile(pri->pcap,
+				   (struct bpf_program *) pri->compiled,
 				   pri->filter, pri->optimize, netmask);
-		if(err < 0){
+		if (err < 0) {
 			printk(UM_KERN_ERR "pcap_open : pcap_compile failed - "
 			       "'%s'\n", pcap_geterr(pri->pcap));
-			return -EIO;
+			goto out;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
-		if(err < 0){
+		if (err < 0) {
 			printk(UM_KERN_ERR "pcap_open : pcap_setfilter "
 			       "failed - '%s'\n", pcap_geterr(pri->pcap));
-			return -EIO;
+			goto out;
 		}
 	}
 
 	return PCAP_FD(pri->pcap);
+
+ out:
+	kfree(pri->compiled);
+	return -EIO;
 }
 
 static void pcap_remove(void *data)
 {
 	struct pcap_data *pri = data;
 
-	if(pri->compiled != NULL)
+	if (pri->compiled != NULL)
 		pcap_freecode(pri->compiled);
 
-	if(pri->pcap != NULL)
+	if (pri->pcap != NULL)
 		pcap_close(pri->pcap);
 }
 
@@ -95,7 +98,7 @@ struct pcap_handler_data {
 	int len;
 };
 
-static void handler(u_char *data, const struct pcap_pkthdr *header, 
+static void handler(u_char *data, const struct pcap_pkthdr *header,
 		    const u_char *packet)
 {
 	int len;
@@ -115,12 +118,12 @@ int pcap_user_read(int fd, void *buffer,
 	int n;
 
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
-	if(n < 0){
+	if (n < 0) {
 		printk(UM_KERN_ERR "pcap_dispatch failed - %s\n",
 		       pcap_geterr(pri->pcap));
 		return -EIO;
 	}
-	else if(n == 0) 
+	else if (n == 0)
 		return 0;
 	return hdata.len;
 }
diff -puN arch/um/drivers/slip_kern.c~uml-network-formatting arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-network-formatting
+++ a/arch/um/drivers/slip_kern.c
@@ -1,11 +1,12 @@
-#include "linux/kernel.h"
-#include "linux/stddef.h"
-#include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/if_arp.h"
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL.
+ */
+
+#include <linux/if_arp.h>
+#include <linux/init.h>
+#include <linux/netdevice.h>
 #include "net_kern.h"
-#include "net_user.h"
-#include "kern.h"
 #include "slip.h"
 
 struct slip_init {
@@ -43,21 +44,21 @@ void slip_init(struct net_device *dev, v
 
 static unsigned short slip_protocol(struct sk_buff *skbuff)
 {
-	return(htons(ETH_P_IP));
+	return htons(ETH_P_IP);
 }
 
-static int slip_read(int fd, struct sk_buff **skb, 
+static int slip_read(int fd, struct sk_buff **skb,
 		       struct uml_net_private *lp)
 {
-	return(slip_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
-			      (struct slip_data *) &lp->user));
+	return slip_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
+			      (struct slip_data *) &lp->user);
 }
 
 static int slip_write(int fd, struct sk_buff **skb,
 		      struct uml_net_private *lp)
 {
-	return(slip_user_write(fd, (*skb)->data, (*skb)->len, 
-			       (struct slip_data *) &lp->user));
+	return slip_user_write(fd, (*skb)->data, (*skb)->len,
+			       (struct slip_data *) &lp->user);
 }
 
 const struct net_kern_info slip_kern_info = {
@@ -71,12 +72,11 @@ static int slip_setup(char *str, char **
 {
 	struct slip_init *init = data;
 
-	*init = ((struct slip_init)
-		{ .gate_addr 		= NULL });
+	*init = ((struct slip_init) { .gate_addr = NULL });
 
-	if(str[0] != '\0') 
+	if (str[0] != '\0')
 		init->gate_addr = str;
-	return(1);
+	return 1;
 }
 
 static struct transport slip_transport = {
diff -puN arch/um/drivers/slip_user.c~uml-network-formatting arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-network-formatting
+++ a/arch/um/drivers/slip_user.c
@@ -1,21 +1,22 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL.
+ */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <stddef.h>
-#include <sched.h>
-#include <string.h>
 #include <errno.h>
+#include <fcntl.h>
+#include <string.h>
 #include <sys/termios.h>
 #include <sys/wait.h>
-#include <sys/signal.h>
-#include "kern_util.h"
-#include "user.h"
+#include "kern_constants.h"
 #include "net_user.h"
-#include "slip.h"
-#include "slip_common.h"
 #include "os.h"
+#include "slip.h"
 #include "um_malloc.h"
-#include "kern_constants.h"
+#include "user.h"
 
 static int slip_user_init(void *data, void *dev)
 {
@@ -31,8 +32,9 @@ static int set_up_tty(int fd)
 	struct termios tios;
 
 	if (tcgetattr(fd, &tios) < 0) {
-		printk("could not get initial terminal attributes\n");
-		return(-1);
+		printk(UM_KERN_ERR "could not get initial terminal "
+		       "attributes\n");
+		return -1;
 	}
 
 	tios.c_cflag = CS8 | CREAD | HUPCL | CLOCAL;
@@ -48,10 +50,10 @@ static int set_up_tty(int fd)
 	cfsetispeed(&tios, B38400);
 
 	if (tcsetattr(fd, TCSAFLUSH, &tios) < 0) {
-		printk("failed to set terminal attributes\n");
-		return(-1);
+		printk(UM_KERN_ERR "failed to set terminal attributes\n");
+		return -1;
 	}
-	return(0);
+	return 0;
 }
 
 struct slip_pre_exec_data {
@@ -64,9 +66,11 @@ static void slip_pre_exec(void *arg)
 {
 	struct slip_pre_exec_data *data = arg;
 
-	if(data->stdin >= 0) dup2(data->stdin, 0);
+	if (data->stdin >= 0)
+		dup2(data->stdin, 0);
 	dup2(data->stdout, 1);
-	if(data->close_me >= 0) os_close_file(data->close_me);
+	if (data->close_me >= 0)
+		close(data->close_me);
 }
 
 static int slip_tramp(char **argv, int fd)
@@ -76,8 +80,9 @@ static int slip_tramp(char **argv, int f
 	int status, pid, fds[2], err, output_len;
 
 	err = os_pipe(fds, 1, 0);
-	if(err < 0){
-		printk("slip_tramp : pipe failed, err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "slip_tramp : pipe failed, err = %d\n",
+		       -err);
 		goto out;
 	}
 
@@ -86,41 +91,42 @@ static int slip_tramp(char **argv, int f
 	pe_data.stdout = fds[1];
 	pe_data.close_me = fds[0];
 	err = run_helper(slip_pre_exec, &pe_data, argv);
-	if(err < 0)
+	if (err < 0)
 		goto out_close;
 	pid = err;
 
 	output_len = UM_KERN_PAGE_SIZE;
 	output = kmalloc(output_len, UM_GFP_KERNEL);
-	if(output == NULL){
-		printk("slip_tramp : failed to allocate output buffer\n");
+	if (output == NULL) {
+		printk(UM_KERN_ERR "slip_tramp : failed to allocate output "
+		       "buffer\n");
 		os_kill_process(pid, 1);
 		err = -ENOMEM;
 		goto out_free;
 	}
 
-	os_close_file(fds[1]);
+	close(fds[1]);
 	read_output(fds[0], output, output_len);
 	printk("%s", output);
 
 	CATCH_EINTR(err = waitpid(pid, &status, 0));
-	if(err < 0)
+	if (err < 0)
 		err = errno;
-	else if(!WIFEXITED(status) || (WEXITSTATUS(status) != 0)){
-		printk("'%s' didn't exit with status 0\n", argv[0]);
+	else if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0)) {
+		printk(UM_KERN_ERR "'%s' didn't exit with status 0\n", argv[0]);
 		err = -EINVAL;
 	}
 	else err = 0;
 
-	os_close_file(fds[0]);
+	close(fds[0]);
 
 out_free:
 	kfree(output);
 	return err;
 
 out_close:
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
+	close(fds[0]);
+	close(fds[1]);
 out:
 	return err;
 }
@@ -130,60 +136,64 @@ static int slip_open(void *data)
 	struct slip_data *pri = data;
 	char version_buf[sizeof("nnnnn\0")];
 	char gate_buf[sizeof("nnn.nnn.nnn.nnn\0")];
-	char *argv[] = { "uml_net", version_buf, "slip", "up", gate_buf, 
+	char *argv[] = { "uml_net", version_buf, "slip", "up", gate_buf,
 			 NULL };
 	int sfd, mfd, err;
 
 	err = get_pty();
-	if(err < 0){
-		printk("slip-open : Failed to open pty, err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "slip-open : Failed to open pty, err = %d\n",
+		       -err);
 		goto out;
 	}
 	mfd = err;
 
-	err = os_open_file(ptsname(mfd), of_rdwr(OPENFLAGS()), 0);
-	if(err < 0){
-		printk("Couldn't open tty for slip line, err = %d\n", -err);
+	err = open(ptsname(mfd), O_RDWR, 0);
+	if (err < 0) {
+		printk(UM_KERN_ERR "Couldn't open tty for slip line, "
+		       "err = %d\n", -err);
 		goto out_close;
 	}
 	sfd = err;
 
-	if(set_up_tty(sfd))
+	if (set_up_tty(sfd))
 		goto out_close2;
 
 	pri->slave = sfd;
 	pri->slip.pos = 0;
 	pri->slip.esc = 0;
-	if(pri->gate_addr != NULL){
+	if (pri->gate_addr != NULL) {
 		sprintf(version_buf, "%d", UML_NET_VERSION);
 		strcpy(gate_buf, pri->gate_addr);
 
 		err = slip_tramp(argv, sfd);
 
-		if(err < 0){
-			printk("slip_tramp failed - err = %d\n", -err);
+		if (err < 0) {
+			printk(UM_KERN_ERR "slip_tramp failed - err = %d\n",
+			       -err);
 			goto out_close2;
 		}
 		err = os_get_ifname(pri->slave, pri->name);
-		if(err < 0){
-			printk("get_ifname failed, err = %d\n", -err);
+		if (err < 0) {
+			printk(UM_KERN_ERR "get_ifname failed, err = %d\n",
+			       -err);
 			goto out_close2;
 		}
 		iter_addresses(pri->dev, open_addr, pri->name);
 	}
 	else {
 		err = os_set_slip(sfd);
-		if(err < 0){
-			printk("Failed to set slip discipline encapsulation - "
-			       "err = %d\n", -err);
+		if (err < 0) {
+			printk(UM_KERN_ERR "Failed to set slip discipline "
+			       "encapsulation - err = %d\n", -err);
 			goto out_close2;
 		}
 	}
-	return(mfd);
+	return mfd;
 out_close2:
-	os_close_file(sfd);
+	close(sfd);
 out_close:
-	os_close_file(mfd);
+	close(mfd);
 out:
 	return err;
 }
@@ -192,21 +202,21 @@ static void slip_close(int fd, void *dat
 {
 	struct slip_data *pri = data;
 	char version_buf[sizeof("nnnnn\0")];
-	char *argv[] = { "uml_net", version_buf, "slip", "down", pri->name, 
+	char *argv[] = { "uml_net", version_buf, "slip", "down", pri->name,
 			 NULL };
 	int err;
 
-	if(pri->gate_addr != NULL)
+	if (pri->gate_addr != NULL)
 		iter_addresses(pri->dev, close_addr, pri->name);
 
 	sprintf(version_buf, "%d", UML_NET_VERSION);
 
 	err = slip_tramp(argv, pri->slave);
 
-	if(err != 0)
-		printk("slip_tramp failed - errno = %d\n", -err);
-	os_close_file(fd);
-	os_close_file(pri->slave);
+	if (err != 0)
+		printk(UM_KERN_ERR "slip_tramp failed - errno = %d\n", -err);
+	close(fd);
+	close(pri->slave);
 	pri->slave = -1;
 }
 
@@ -222,7 +232,7 @@ int slip_user_write(int fd, void *buf, i
 
 static int slip_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 static void slip_add_addr(unsigned char *addr, unsigned char *netmask,
@@ -230,7 +240,8 @@ static void slip_add_addr(unsigned char 
 {
 	struct slip_data *pri = data;
 
-	if(pri->slave < 0) return;
+	if (pri->slave < 0)
+		return;
 	open_addr(addr, netmask, pri->name);
 }
 
@@ -239,7 +250,8 @@ static void slip_del_addr(unsigned char 
 {
 	struct slip_data *pri = data;
 
-	if(pri->slave < 0) return;
+	if (pri->slave < 0)
+		return;
 	close_addr(addr, netmask, pri->name);
 }
 
diff -puN arch/um/drivers/slirp_kern.c~uml-network-formatting arch/um/drivers/slirp_kern.c
--- a/arch/um/drivers/slirp_kern.c~uml-network-formatting
+++ a/arch/um/drivers/slirp_kern.c
@@ -1,11 +1,14 @@
-#include "linux/kernel.h"
-#include "linux/stddef.h"
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL.
+ */
+
+#include <linux/if_arp.h>
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/if_arp.h"
+#include <linux/netdevice.h>
+#include <linux/string.h>
 #include "net_kern.h"
 #include "net_user.h"
-#include "kern.h"
 #include "slirp.h"
 
 struct slirp_init {
@@ -39,29 +42,28 @@ void slirp_init(struct net_device *dev, 
 	dev->tx_queue_len = 256;
 	dev->flags = IFF_NOARP;
 	printk("SLIRP backend - command line:");
-	for(i=0;spri->argw.argv[i]!=NULL;i++) {
+	for (i = 0; spri->argw.argv[i] != NULL; i++)
 		printk(" '%s'",spri->argw.argv[i]);
-	}
 	printk("\n");
 }
 
 static unsigned short slirp_protocol(struct sk_buff *skbuff)
 {
-	return(htons(ETH_P_IP));
+	return htons(ETH_P_IP);
 }
 
-static int slirp_read(int fd, struct sk_buff **skb, 
+static int slirp_read(int fd, struct sk_buff **skb,
 		       struct uml_net_private *lp)
 {
-	return(slirp_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
-			      (struct slirp_data *) &lp->user));
+	return slirp_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
+			      (struct slirp_data *) &lp->user);
 }
 
 static int slirp_write(int fd, struct sk_buff **skb,
 		      struct uml_net_private *lp)
 {
-	return(slirp_user_write(fd, (*skb)->data, (*skb)->len, 
-			       (struct slirp_data *) &lp->user));
+	return slirp_user_write(fd, (*skb)->data, (*skb)->len,
+			       (struct slirp_data *) &lp->user);
 }
 
 const struct net_kern_info slirp_kern_info = {
@@ -76,31 +78,32 @@ static int slirp_setup(char *str, char *
 	struct slirp_init *init = data;
 	int i=0;
 
-	*init = ((struct slirp_init)
-		{ .argw = { { "slirp", NULL  } } });
+	*init = ((struct slirp_init) { .argw = { { "slirp", NULL  } } });
 
 	str = split_if_spec(str, mac_out, NULL);
 
-	if(str == NULL) { /* no command line given after MAC addr */
-		return(1);
-	}
+	if (str == NULL) /* no command line given after MAC addr */
+		return 1;
 
 	do {
-		if(i>=SLIRP_MAX_ARGS-1) {
-			printk("slirp_setup: truncating slirp arguments\n");
+		if (i >= SLIRP_MAX_ARGS - 1) {
+			printk(KERN_WARNING "slirp_setup: truncating slirp "
+			       "arguments\n");
 			break;
 		}
 		init->argw.argv[i++] = str;
 		while(*str && *str!=',') {
-			if(*str=='_') *str=' ';
+			if (*str == '_')
+				*str=' ';
 			str++;
 		}
-		if(*str!=',')
+		if (*str != ',')
 			break;
-		*str++='\0';
-	} while(1);
-	init->argw.argv[i]=NULL;
-	return(1);
+		*str++ = '\0';
+	} while (1);
+
+	init->argw.argv[i] = NULL;
+	return 1;
 }
 
 static struct transport slirp_transport = {
diff -puN arch/um/drivers/slirp_user.c~uml-network-formatting arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-network-formatting
+++ a/arch/um/drivers/slirp_user.c
@@ -1,18 +1,17 @@
-#include <stdio.h>
-#include <stdlib.h>
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL.
+ */
+
 #include <unistd.h>
-#include <stddef.h>
-#include <sched.h>
-#include <string.h>
 #include <errno.h>
+#include <string.h>
 #include <sys/wait.h>
-#include <sys/signal.h>
-#include "kern_util.h"
-#include "user.h"
+#include "kern_constants.h"
 #include "net_user.h"
-#include "slirp.h"
-#include "slip_common.h"
 #include "os.h"
+#include "slirp.h"
+#include "user.h"
 
 static int slirp_user_init(void *data, void *dev)
 {
@@ -31,8 +30,10 @@ static void slirp_pre_exec(void *arg)
 {
 	struct slirp_pre_exec_data *data = arg;
 
-	if(data->stdin != -1) dup2(data->stdin, 0);
-	if(data->stdout != -1) dup2(data->stdout, 1);
+	if (data->stdin != -1)
+		dup2(data->stdin, 0);
+	if (data->stdout != -1)
+		dup2(data->stdout, 1);
 }
 
 static int slirp_tramp(char **argv, int fd)
@@ -44,7 +45,7 @@ static int slirp_tramp(char **argv, int 
 	pe_data.stdout = fd;
 	pid = run_helper(slirp_pre_exec, &pe_data, argv);
 
-	return(pid);
+	return pid;
 }
 
 static int slirp_open(void *data)
@@ -53,12 +54,12 @@ static int slirp_open(void *data)
 	int fds[2], pid, err;
 
 	err = os_pipe(fds, 1, 1);
-	if(err)
-		return(err);
+	if (err)
+		return err;
 
 	err = slirp_tramp(pri->argw.argv, fds[1]);
-	if(err < 0){
-		printk("slirp_tramp failed - errno = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "slirp_tramp failed - errno = %d\n", -err);
 		goto out;
 	}
 	pid = err;
@@ -68,10 +69,10 @@ static int slirp_open(void *data)
 	pri->slip.esc = 0;
 	pri->pid = err;
 
-	return(fds[0]);
+	return fds[0];
 out:
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
+	close(fds[0]);
+	close(fds[1]);
 	return err;
 }
 
@@ -80,31 +81,33 @@ static void slirp_close(int fd, void *da
 	struct slirp_data *pri = data;
 	int status,err;
 
-	os_close_file(fd);
-	os_close_file(pri->slave);
+	close(fd);
+	close(pri->slave);
 
 	pri->slave = -1;
 
-	if(pri->pid<1) {
-		printk("slirp_close: no child process to shut down\n");
+	if (pri->pid<1) {
+		printk(UM_KERN_ERR "slirp_close: no child process to shut "
+		       "down\n");
 		return;
 	}
 
 #if 0
-	if(kill(pri->pid, SIGHUP)<0) {
-		printk("slirp_close: sending hangup to %d failed (%d)\n",
-			pri->pid, errno);
+	if (kill(pri->pid, SIGHUP)<0) {
+		printk(UM_KERN_ERR "slirp_close: sending hangup to %d failed "
+		       "(%d)\n", pri->pid, errno);
 	}
 #endif
 
 	CATCH_EINTR(err = waitpid(pri->pid, &status, WNOHANG));
-	if(err < 0) {
-		printk("slirp_close: waitpid returned %d\n", errno);
+	if (err < 0) {
+		printk(UM_KERN_ERR "slirp_close: waitpid returned %d\n", errno);
 		return;
 	}
 
-	if(err == 0) {
-		printk("slirp_close: process %d has not exited\n", pri->pid);
+	if (err == 0) {
+		printk(UM_KERN_ERR "slirp_close: process %d has not exited\n",
+		       pri->pid);
 		return;
 	}
 
@@ -123,7 +126,7 @@ int slirp_user_write(int fd, void *buf, 
 
 static int slirp_set_mtu(int mtu, void *data)
 {
-	return(mtu);
+	return mtu;
 }
 
 const struct net_user_info slirp_user_info = {
diff -puN arch/um/drivers/vde_kern.c~uml-network-formatting arch/um/drivers/vde_kern.c
--- a/arch/um/drivers/vde_kern.c~uml-network-formatting
+++ a/arch/um/drivers/vde_kern.c
@@ -7,10 +7,8 @@
  *
  */
 
-#include "linux/kernel.h"
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
+#include <linux/netdevice.h>
 #include "net_kern.h"
 #include "net_user.h"
 #include "vde.h"
@@ -30,12 +28,12 @@ static void vde_init(struct net_device *
 	vpri->conn = NULL;
 	vpri->dev = dev;
 
-	printk(KERN_INFO "vde backend - %s, ", vpri->vde_switch ?
+	printk("vde backend - %s, ", vpri->vde_switch ?
 	       vpri->vde_switch : "(default socket)");
 
 	vde_init_libstuff(vpri, init);
 
-	printk(KERN_INFO "\n");
+	printk("\n");
 }
 
 static int vde_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
diff -puN arch/um/drivers/vde_user.c~uml-network-formatting arch/um/drivers/vde_user.c
--- a/arch/um/drivers/vde_user.c~uml-network-formatting
+++ a/arch/um/drivers/vde_user.c
@@ -3,15 +3,13 @@
  * Licensed under the GPL.
  */
 
+#include <stddef.h>
 #include <errno.h>
-#include <unistd.h>
 #include <libvdeplug.h>
-#include "net_user.h"
-#include "kern_util.h"
 #include "kern_constants.h"
-#include "user.h"
-#include "os.h"
+#include "net_user.h"
 #include "um_malloc.h"
+#include "user.h"
 #include "vde.h"
 
 #define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
diff -puN arch/um/os-Linux/drivers/etap.h~uml-network-formatting arch/um/os-Linux/drivers/etap.h
--- a/arch/um/os-Linux/drivers/etap.h~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/etap.h
@@ -1,8 +1,11 @@
 /* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
+#ifndef __DRIVERS_ETAP_H
+#define __DRIVERS_ETAP_H
+
 #include "net_user.h"
 
 struct ethertap_data {
@@ -15,13 +18,4 @@ struct ethertap_data {
 
 extern const struct net_user_info ethertap_user_info;
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
+#endif
diff -puN arch/um/os-Linux/drivers/ethertap_kern.c~uml-network-formatting arch/um/os-Linux/drivers/ethertap_kern.c
--- a/arch/um/os-Linux/drivers/ethertap_kern.c~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -1,16 +1,15 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and 
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
 
 #include "linux/init.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
-#include "net_kern.h"
-#include "net_user.h"
+#include <linux/netdevice.h>
 #include "etap.h"
+#include "net_kern.h"
 
 struct ethertap_init {
 	char *dev_name;
@@ -42,27 +41,30 @@ static int etap_read(int fd, struct sk_b
 	int len;
 
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_ETHERTAP);
-	if(*skb == NULL) return(-ENOMEM);
+	if (*skb == NULL)
+		return -ENOMEM;
 	len = net_recvfrom(fd, skb_mac_header(*skb),
 			   (*skb)->dev->mtu + 2 * ETH_HEADER_ETHERTAP);
-	if(len <= 0) return(len);
+	if (len <= 0)
+		return len;
 	skb_pull(*skb, 2);
 	len -= 2;
-	return(len);
+	return len;
 }
 
 static int etap_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
 {
-	if(skb_headroom(*skb) < 2){
+	if (skb_headroom(*skb) < 2) {
 	  	struct sk_buff *skb2;
 
 		skb2 = skb_realloc_headroom(*skb, 2);
 		dev_kfree_skb(*skb);
-		if (skb2 == NULL) return(-ENOMEM);
+		if (skb2 == NULL)
+			return -ENOMEM;
 		*skb = skb2;
 	}
 	skb_push(*skb, 2);
-	return(net_send(fd, (*skb)->data, (*skb)->len));
+	return net_send(fd, (*skb)->data, (*skb)->len);
 }
 
 const struct net_kern_info ethertap_kern_info = {
@@ -79,15 +81,15 @@ int ethertap_setup(char *str, char **mac
 	*init = ((struct ethertap_init)
 		{ .dev_name 	= NULL,
 		  .gate_addr 	= NULL });
-	if(tap_setup_common(str, "ethertap", &init->dev_name, mac_out,
+	if (tap_setup_common(str, "ethertap", &init->dev_name, mac_out,
 			    &init->gate_addr))
-		return(0);
-	if(init->dev_name == NULL){
-		printk("ethertap_setup : Missing tap device name\n");
-		return(0);
+		return 0;
+	if (init->dev_name == NULL) {
+		printk(KERN_ERR "ethertap_setup : Missing tap device name\n");
+		return 0;
 	}
 
-	return(1);
+	return 1;
 }
 
 static struct transport ethertap_transport = {
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-network-formatting arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
@@ -7,20 +8,16 @@
 
 #include <stdio.h>
 #include <unistd.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <sys/errno.h>
+#include <errno.h>
+#include <string.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
-#include <sys/un.h>
-#include <net/if.h>
-#include "user.h"
-#include "kern_util.h"
-#include "net_user.h"
 #include "etap.h"
+#include "kern_constants.h"
 #include "os.h"
+#include "net_user.h"
 #include "um_malloc.h"
-#include "kern_constants.h"
+#include "user.h"
 
 #define MAX_PACKET ETH_MAX_PACKET
 
@@ -49,16 +46,18 @@ static void etap_change(int op, unsigned
 	memcpy(change.addr, addr, sizeof(change.addr));
 	memcpy(change.netmask, netmask, sizeof(change.netmask));
 	CATCH_EINTR(n = write(fd, &change, sizeof(change)));
-	if(n != sizeof(change)){
-		printk("etap_change - request failed, err = %d\n", errno);
+	if (n != sizeof(change)) {
+		printk(UM_KERN_ERR "etap_change - request failed, err = %d\n",
+		       errno);
 		return;
 	}
 
 	output = kmalloc(UM_KERN_PAGE_SIZE, UM_GFP_KERNEL);
-	if(output == NULL)
-		printk("etap_change : Failed to allocate output buffer\n");
+	if (output == NULL)
+		printk(UM_KERN_ERR "etap_change : Failed to allocate output "
+		       "buffer\n");
 	read_output(fd, output, UM_KERN_PAGE_SIZE);
-	if(output != NULL){
+	if (output != NULL) {
 		printk("%s", output);
 		kfree(output);
 	}
@@ -107,7 +106,7 @@ static int etap_tramp(char *dev, char *g
 
 	sprintf(data_fd_buf, "%d", data_remote);
 	sprintf(version_buf, "%d", UML_NET_VERSION);
-	if(gate != NULL){
+	if (gate != NULL) {
 		strcpy(gate_buf, gate);
 		args = setup_args;
 	}
@@ -119,24 +118,26 @@ static int etap_tramp(char *dev, char *g
 	pe_data.data_me = data_me;
 	pid = run_helper(etap_pre_exec, &pe_data, args);
 
-	if(pid < 0)
+	if (pid < 0)
 		err = pid;
 	close(data_remote);
 	close(control_remote);
 	CATCH_EINTR(n = read(control_me, &c, sizeof(c)));
-	if(n != sizeof(c)){
+	if (n != sizeof(c)) {
 		err = -errno;
-		printk("etap_tramp : read of status failed, err = %d\n", -err);
+		printk(UM_KERN_ERR "etap_tramp : read of status failed, "
+		       "err = %d\n", -err);
 		return err;
 	}
-	if(c != 1){
-		printk("etap_tramp : uml_net failed\n");
+	if (c != 1) {
+		printk(UM_KERN_ERR "etap_tramp : uml_net failed\n");
 		err = -EINVAL;
 		CATCH_EINTR(n = waitpid(pid, &status, 0));
-		if(n < 0)
+		if (n < 0)
 			err = -errno;
-		else if(!WIFEXITED(status) || (WEXITSTATUS(status) != 1))
-			printk("uml_net didn't exit with status 1\n");
+		else if (!WIFEXITED(status) || (WEXITSTATUS(status) != 1))
+			printk(UM_KERN_ERR "uml_net didn't exit with "
+			       "status 1\n");
 	}
 	return err;
 }
@@ -148,22 +149,22 @@ static int etap_open(void *data)
 	int data_fds[2], control_fds[2], err, output_len;
 
 	err = tap_open_common(pri->dev, pri->gate_addr);
-	if(err)
+	if (err)
 		return err;
 
 	err = socketpair(AF_UNIX, SOCK_DGRAM, 0, data_fds);
-	if(err){
+	if (err) {
 		err = -errno;
-		printk("etap_open - data socketpair failed - err = %d\n",
-		       errno);
+		printk(UM_KERN_ERR "etap_open - data socketpair failed - "
+		       "err = %d\n", errno);
 		return err;
 	}
 
 	err = socketpair(AF_UNIX, SOCK_STREAM, 0, control_fds);
-	if(err){
+	if (err) {
 		err = -errno;
-		printk("etap_open - control socketpair failed - err = %d\n",
-		       errno);
+		printk(UM_KERN_ERR "etap_open - control socketpair failed - "
+		       "err = %d\n", errno);
 		goto out_close_data;
 	}
 
@@ -173,15 +174,16 @@ static int etap_open(void *data)
 	output = kmalloc(output_len, UM_GFP_KERNEL);
 	read_output(control_fds[0], output, output_len);
 
-	if(output == NULL)
-		printk("etap_open : failed to allocate output buffer\n");
+	if (output == NULL)
+		printk(UM_KERN_ERR "etap_open : failed to allocate output "
+		       "buffer\n");
 	else {
 		printk("%s", output);
 		kfree(output);
 	}
 
-	if(err < 0){
-		printk("etap_tramp failed - err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "etap_tramp failed - err = %d\n", -err);
 		goto out_close_control;
 	}
 
@@ -206,14 +208,14 @@ static void etap_close(int fd, void *dat
 	iter_addresses(pri->dev, etap_close_addr, &pri->control_fd);
 	close(fd);
 
-	if(shutdown(pri->data_fd, SHUT_RDWR) < 0)
-		printk("etap_close - shutdown data socket failed, errno = %d\n",
-		       errno);
-
-	if(shutdown(pri->control_fd, SHUT_RDWR) < 0)
-		printk("etap_close - shutdown control socket failed, "
+	if (shutdown(pri->data_fd, SHUT_RDWR) < 0)
+		printk(UM_KERN_ERR "etap_close - shutdown data socket failed, "
 		       "errno = %d\n", errno);
 
+	if (shutdown(pri->control_fd, SHUT_RDWR) < 0)
+		printk(UM_KERN_ERR "etap_close - shutdown control socket "
+		       "failed, errno = %d\n", errno);
+
 	close(pri->data_fd);
 	pri->data_fd = -1;
 	close(pri->control_fd);
@@ -231,7 +233,7 @@ static void etap_add_addr(unsigned char 
 	struct ethertap_data *pri = data;
 
 	tap_check_ips(pri->gate_addr, addr);
-	if(pri->control_fd == -1)
+	if (pri->control_fd == -1)
 		return;
 	etap_open_addr(addr, netmask, &pri->control_fd);
 }
@@ -241,7 +243,7 @@ static void etap_del_addr(unsigned char 
 {
 	struct ethertap_data *pri = data;
 
-	if(pri->control_fd == -1)
+	if (pri->control_fd == -1)
 		return;
 
 	etap_close_addr(addr, netmask, &pri->control_fd);
diff -puN arch/um/os-Linux/drivers/tuntap.h~uml-network-formatting arch/um/os-Linux/drivers/tuntap.h
--- a/arch/um/os-Linux/drivers/tuntap.h~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/tuntap.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -19,14 +19,3 @@ struct tuntap_data {
 extern const struct net_user_info tuntap_user_info;
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/os-Linux/drivers/tuntap_kern.c~uml-network-formatting arch/um/os-Linux/drivers/tuntap_kern.c
--- a/arch/um/os-Linux/drivers/tuntap_kern.c~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/tuntap_kern.c
@@ -1,16 +1,13 @@
-/* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/stddef.h"
-#include "linux/netdevice.h"
-#include "linux/etherdevice.h"
-#include "linux/skbuff.h"
-#include "linux/init.h"
-#include "asm/errno.h"
+#include <linux/netdevice.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <asm/errno.h>
 #include "net_kern.h"
-#include "net_user.h"
 #include "tuntap.h"
 
 struct tuntap_init {
@@ -38,19 +35,20 @@ static void tuntap_init(struct net_devic
 	printk("\n");
 }
 
-static int tuntap_read(int fd, struct sk_buff **skb, 
+static int tuntap_read(int fd, struct sk_buff **skb,
 		       struct uml_net_private *lp)
 {
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if(*skb == NULL) return(-ENOMEM);
-	return(net_read(fd, skb_mac_header(*skb),
-			(*skb)->dev->mtu + ETH_HEADER_OTHER));
+	if (*skb == NULL)
+		return -ENOMEM;
+	return net_read(fd, skb_mac_header(*skb),
+			(*skb)->dev->mtu + ETH_HEADER_OTHER);
 }
 
-static int tuntap_write(int fd, struct sk_buff **skb, 
+static int tuntap_write(int fd, struct sk_buff **skb,
 			struct uml_net_private *lp)
 {
-	return(net_write(fd, (*skb)->data, (*skb)->len));
+	return net_write(fd, (*skb)->data, (*skb)->len);
 }
 
 const struct net_kern_info tuntap_kern_info = {
@@ -67,11 +65,11 @@ int tuntap_setup(char *str, char **mac_o
 	*init = ((struct tuntap_init)
 		{ .dev_name 	= NULL,
 		  .gate_addr 	= NULL });
-	if(tap_setup_common(str, "tuntap", &init->dev_name, mac_out,
+	if (tap_setup_common(str, "tuntap", &init->dev_name, mac_out,
 			    &init->gate_addr))
-		return(0);
+		return 0;
 
-	return(1);
+	return 1;
 }
 
 static struct transport tuntap_transport = {
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-network-formatting arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-network-formatting
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -1,25 +1,22 @@
 /* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #include <stdio.h>
-#include <stddef.h>
-#include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <sys/wait.h>
+#include <string.h>
+#include <linux/if_tun.h>
+#include <net/if.h>
+#include <sys/ioctl.h>
 #include <sys/socket.h>
-#include <sys/un.h>
+#include <sys/wait.h>
 #include <sys/uio.h>
-#include <sys/ioctl.h>
-#include <net/if.h>
-#include <linux/if_tun.h>
-#include "net_user.h"
+#include "kern_constants.h"
+#include "os.h"
 #include "tuntap.h"
-#include "kern_util.h"
 #include "user.h"
-#include "os.h"
 
 #define MAX_PACKET ETH_MAX_PACKET
 
@@ -37,7 +34,7 @@ static void tuntap_add_addr(unsigned cha
 	struct tuntap_data *pri = data;
 
 	tap_check_ips(pri->gate_addr, addr);
-	if((pri->fd == -1) || pri->fixed_config)
+	if ((pri->fd == -1) || pri->fixed_config)
 		return;
 	open_addr(addr, netmask, pri->dev_name);
 }
@@ -47,7 +44,7 @@ static void tuntap_del_addr(unsigned cha
 {
 	struct tuntap_data *pri = data;
 
-	if((pri->fd == -1) || pri->fixed_config)
+	if ((pri->fd == -1) || pri->fixed_config)
 		return;
 	close_addr(addr, netmask, pri->dev_name);
 }
@@ -85,14 +82,14 @@ static int tuntap_open_tramp(char *gate,
 
 	pid = run_helper(tuntap_pre_exec, &data, argv);
 
-	if(pid < 0)
+	if (pid < 0)
 		return -pid;
 
 	close(remote);
 
 	msg.msg_name = NULL;
 	msg.msg_namelen = 0;
-	if(buffer != NULL){
+	if (buffer != NULL) {
 		iov = ((struct iovec) { buffer, buffer_len });
 		msg.msg_iov = &iov;
 		msg.msg_iovlen = 1;
@@ -106,22 +103,24 @@ static int tuntap_open_tramp(char *gate,
 	msg.msg_flags = 0;
 	n = recvmsg(me, &msg, 0);
 	*used_out = n;
-	if(n < 0){
+	if (n < 0) {
 		err = -errno;
-		printk("tuntap_open_tramp : recvmsg failed - errno = %d\n", 
-		       errno);
+		printk(UM_KERN_ERR "tuntap_open_tramp : recvmsg failed - "
+		       "errno = %d\n", errno);
 		return err;
 	}
 	CATCH_EINTR(waitpid(pid, NULL, 0));
 
 	cmsg = CMSG_FIRSTHDR(&msg);
-	if(cmsg == NULL){
-		printk("tuntap_open_tramp : didn't receive a message\n");
+	if (cmsg == NULL) {
+		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		       "message\n");
 		return -EINVAL;
 	}
-	if((cmsg->cmsg_level != SOL_SOCKET) || 
-	   (cmsg->cmsg_type != SCM_RIGHTS)){
-		printk("tuntap_open_tramp : didn't receive a descriptor\n");
+	if ((cmsg->cmsg_level != SOL_SOCKET) ||
+	   (cmsg->cmsg_type != SCM_RIGHTS)) {
+		printk(UM_KERN_ERR "tuntap_open_tramp : didn't receive a "
+		       "descriptor\n");
 		return -EINVAL;
 	}
 	*fd_out = ((int *) CMSG_DATA(cmsg))[0];
@@ -137,38 +136,39 @@ static int tuntap_open(void *data)
 	int err, fds[2], len, used;
 
 	err = tap_open_common(pri->dev, pri->gate_addr);
-	if(err < 0)
+	if (err < 0)
 		return err;
 
-	if(pri->fixed_config){
+	if (pri->fixed_config) {
 		pri->fd = os_open_file("/dev/net/tun",
 				       of_cloexec(of_rdwr(OPENFLAGS())), 0);
-		if(pri->fd < 0){
-			printk("Failed to open /dev/net/tun, err = %d\n",
-			       -pri->fd);
+		if (pri->fd < 0) {
+			printk(UM_KERN_ERR "Failed to open /dev/net/tun, "
+			       "err = %d\n", -pri->fd);
 			return pri->fd;
 		}
 		memset(&ifr, 0, sizeof(ifr));
 		ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
-		if(ioctl(pri->fd, TUNSETIFF, (void *) &ifr) < 0){
+		if (ioctl(pri->fd, TUNSETIFF, (void *) &ifr) < 0) {
 			err = -errno;
-			printk("TUNSETIFF failed, errno = %d\n", errno);
+			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
+			       errno);
 			close(pri->fd);
 			return err;
 		}
 	}
 	else {
 		err = socketpair(AF_UNIX, SOCK_DGRAM, 0, fds);
-		if(err){
+		if (err) {
 			err = -errno;
-			printk("tuntap_open : socketpair failed - errno = %d\n",
-			       errno);
+			printk(UM_KERN_ERR "tuntap_open : socketpair failed - "
+			       "errno = %d\n", errno);
 			return err;
 		}
 
 		buffer = get_output_buffer(&len);
-		if(buffer != NULL)
+		if (buffer != NULL)
 			len--;
 		used = 0;
 
@@ -176,10 +176,11 @@ static int tuntap_open(void *data)
 					fds[1], buffer, len, &used);
 
 		output = buffer;
-		if(err < 0) {
+		if (err < 0) {
 			printk("%s", output);
 			free_output_buffer(buffer);
-			printk("tuntap_open_tramp failed - err = %d\n", -err);
+			printk(UM_KERN_ERR "tuntap_open_tramp failed - "
+			       "err = %d\n", -err);
 			return err;
 		}
 
@@ -199,7 +200,7 @@ static void tuntap_close(int fd, void *d
 {
 	struct tuntap_data *pri = data;
 
-	if(!pri->fixed_config) 
+	if (!pri->fixed_config)
 		iter_addresses(pri->dev, close_addr, pri->dev_name);
 	close(fd);
 	pri->fd = -1;
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-stop-saving-process-fp-state-fix.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-time-build-fix.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
uml-network-formatting.patch
uml-network-driver-mtu-cleanups.patch
uml-correctly-handle-skb-allocation-failures.patch
uml-correctly-handle-skb-allocation-failures-fix.patch
bitops-introduce-lock-ops.patch
