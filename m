From: akpm@osdl.org
Subject: + uml-network-driver-whitespace-and-style-fixes.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:32:08 -0800
Message-ID: <200701022132.l02LW8oG030404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbXABVff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jeff@garzik.org


The patch titled
     uml: network driver whitespace and style fixes
has been added to the -mm tree.  Its filename is
     uml-network-driver-whitespace-and-style-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: network driver whitespace and style fixes
From: Jeff Dike <jdike@addtoit.com>

Some whitespace and coding style cleanups in the network driver code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/net_kern.c |   29 +++++++++++++++--------------
 arch/um/include/net_kern.h |    6 +++---
 2 files changed, 18 insertions(+), 17 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-network-driver-whitespace-and-style-fixes arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-driver-whitespace-and-style-fixes
+++ a/arch/um/drivers/net_kern.c
@@ -108,7 +108,7 @@ irqreturn_t uml_net_interrupt(int irq, v
 
 out:
 	spin_unlock(&lp->lock);
-	return(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 static int uml_net_open(struct net_device *dev)
@@ -239,7 +239,7 @@ static int uml_net_set_mac(struct net_de
 	set_ether_mac(dev, hwaddr->sa_data);
 	spin_unlock_irq(&lp->lock);
 
-	return(0);
+	return 0;
 }
 
 static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
@@ -460,7 +460,7 @@ static struct uml_net *find_device(int n
 	device = NULL;
  out:
 	spin_unlock(&devices_lock);
-	return(device);
+	return device;
 }
 
 static int eth_parse(char *str, int *index_out, char **str_out,
@@ -511,23 +511,23 @@ static int check_transport(struct transp
 
 	len = strlen(transport->name);
 	if(strncmp(eth, transport->name, len))
-		return(0);
+		return 0;
 
 	eth += len;
 	if(*eth == ',')
 		eth++;
 	else if(*eth != '\0')
-		return(0);
+		return 0;
 
 	*init_out = kmalloc(transport->setup_size, GFP_KERNEL);
 	if(*init_out == NULL)
-		return(1);
+		return 1;
 
 	if(!transport->setup(eth, mac_out, *init_out)){
 		kfree(*init_out);
 		*init_out = NULL;
 	}
-	return(1);
+	return 1;
 }
 
 void register_transport(struct transport *new)
@@ -572,9 +572,9 @@ static int eth_setup_common(char *str, i
 			eth_configure(index, init, mac, transport);
 			kfree(init);
 		}
-		return(1);
+		return 1;
 	}
-	return(0);
+	return 0;
 }
 
 static int eth_setup(char *str)
@@ -678,7 +678,7 @@ static int net_remove(int n, char **erro
 	dev = device->dev;
 	lp = dev->priv;
 	if(lp->fd > 0)
-                return -EBUSY;
+		return -EBUSY;
 	if(lp->remove != NULL) (*lp->remove)(&lp->user);
 	unregister_netdev(dev);
 	platform_device_unregister(&device->pdev);
@@ -693,7 +693,7 @@ static struct mc_device net_mc = {
 	.name		= "eth",
 	.config		= net_config,
 	.get_config	= NULL,
-        .id		= net_id,
+	.id		= net_id,
 	.remove		= net_remove,
 };
 
@@ -706,7 +706,8 @@ static int uml_inetaddr_event(struct not
 	void (*proc)(unsigned char *, unsigned char *, void *);
 	unsigned char addr_buf[4], netmask_buf[4];
 
-	if(dev->open != uml_net_open) return(NOTIFY_DONE);
+	if(dev->open != uml_net_open)
+		return NOTIFY_DONE;
 
 	lp = dev->priv;
 
@@ -724,7 +725,7 @@ static int uml_inetaddr_event(struct not
 		memcpy(netmask_buf, &ifa->ifa_mask, sizeof(netmask_buf));
 		(*proc)(addr_buf, netmask_buf, &lp->user);
 	}
-	return(NOTIFY_DONE);
+	return NOTIFY_DONE;
 }
 
 struct notifier_block uml_inetaddr_notifier = {
@@ -834,7 +835,7 @@ void *get_output_buffer(int *len_out)
 	ret = (void *) __get_free_pages(GFP_KERNEL, 0);
 	if(ret) *len_out = PAGE_SIZE;
 	else *len_out = 0;
-	return(ret);
+	return ret;
 }
 
 void free_output_buffer(void *buffer)
diff -puN arch/um/include/net_kern.h~uml-network-driver-whitespace-and-style-fixes arch/um/include/net_kern.h
--- a/arch/um/include/net_kern.h~uml-network-driver-whitespace-and-style-fixes
+++ a/arch/um/include/net_kern.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -36,7 +36,7 @@ struct uml_net_private {
 	void (*remove)(void *);
 	int (*read)(int, struct sk_buff **skb, struct uml_net_private *);
 	int (*write)(int, struct sk_buff **skb, struct uml_net_private *);
-	
+
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
 	int (*set_mtu)(int mtu, void *);
@@ -63,7 +63,7 @@ struct transport {
 extern struct net_device *ether_init(int);
 extern unsigned short ether_protocol(struct sk_buff *);
 extern struct sk_buff *ether_adjust_skb(struct sk_buff *skb, int extra);
-extern int tap_setup_common(char *str, char *type, char **dev_name, 
+extern int tap_setup_common(char *str, char *type, char **dev_name,
 			    char **mac_out, char **gate_addr);
 extern void register_transport(struct transport *new);
 extern unsigned short eth_protocol(struct sk_buff *skb);
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
