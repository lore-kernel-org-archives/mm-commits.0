From: akpm@linux-foundation.org
Subject: - uml-network-and-pcap-cleanup.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:41 -0700
Message-ID: <200705090255.l492tfif009955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032336AbXEICzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: network and pcap cleanup
has been removed from the -mm tree.  Its filename was
     uml-network-and-pcap-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: network and pcap cleanup
From: Jeff Dike <jdike@addtoit.com>

Some network device cleanup.

When setup_etheraddr found a globally valid MAC being assigned to an
interface, it went ahead and used it rather than assigning a random MAC like
the other cases do.  This isn't really an error like the others, but it seems
consistent to make it behave the same.

We were getting some duplicate kfree() in the error case in eth_configure
because platform_device_unregister frees buffers that the error cases
following tried to free again.

The pcap initialization routine wasn't doing the proper printk of its
information, causing a printk of the first part of that line to be
unterminated by a newline.

The pcap code had a bunch of style violations, which are now fixed.

pcap_setup wasn't returning false when it detected an unrecognized
option.

The printks in pcap_user all got UM_KERN_BLAH prepended to their
format strings.

pcap_remove now checks for a non-NULL pcap structure before it calls
pcap_close.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c  |   15 +++++++++------
 arch/um/drivers/pcap_kern.c |   25 ++++++++++++++++---------
 arch/um/drivers/pcap_user.c |   23 +++++++++++++----------
 3 files changed, 38 insertions(+), 25 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-network-and-pcap-cleanup arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-and-pcap-cleanup
+++ a/arch/um/drivers/net_kern.c
@@ -316,12 +316,14 @@ static void setup_etheraddr(char *str, u
 	}
 	if (!is_local_ether_addr(addr)) {
 		printk(KERN_WARNING
-		       "Warning: attempt to assign a globally valid ethernet address to a "
-		       "device\n");
-		printk(KERN_WARNING "You should better enable the 2nd rightmost bit "
-		      "in the first byte of the MAC, i.e. "
-		      "%02x:%02x:%02x:%02x:%02x:%02x\n",
-		      addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4], addr[5]);
+		       "Warning: attempt to assign a globally valid ethernet "
+		       "address to a device\n");
+		printk(KERN_WARNING "You should better enable the 2nd "
+		       "rightmost bit in the first byte of the MAC,\n");
+		printk(KERN_WARNING "i.e. %02x:%02x:%02x:%02x:%02x:%02x\n",
+		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
+		       addr[5]);
+		goto random;
 	}
 	return;
 
@@ -478,6 +480,7 @@ out_undo_user_init:
 		(*transport->user->remove)(&lp->user);
 out_unregister:
 	platform_device_unregister(&device->pdev);
+	return; /* platform_device_unregister frees dev and device */
 out_free_netdev:
 	free_netdev(dev);
 out_free_device:
diff -puN arch/um/drivers/pcap_kern.c~uml-network-and-pcap-cleanup arch/um/drivers/pcap_kern.c
--- a/arch/um/drivers/pcap_kern.c~uml-network-and-pcap-cleanup
+++ a/arch/um/drivers/pcap_kern.c
@@ -29,21 +29,25 @@ void pcap_init(struct net_device *dev, v
 	ppri->promisc = init->promisc;
 	ppri->optimize = init->optimize;
 	ppri->filter = init->filter;
+
+	printk("pcap backend, host interface %s\n", ppri->host_if);
 }
 
-static int pcap_read(int fd, struct sk_buff **skb, 
+static int pcap_read(int fd, struct sk_buff **skb,
 		       struct uml_net_private *lp)
 {
 	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if(*skb == NULL) return(-ENOMEM);
-	return(pcap_user_read(fd, skb_mac_header(*skb),
+	if(*skb == NULL)
+		return -ENOMEM;
+
+	return pcap_user_read(fd, skb_mac_header(*skb),
 			      (*skb)->dev->mtu + ETH_HEADER_OTHER,
-			      (struct pcap_data *) &lp->user));
+			      (struct pcap_data *) &lp->user);
 }
 
 static int pcap_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
 {
-	return(-EPERM);
+	return -EPERM;
 }
 
 static const struct net_kern_info pcap_kern_info = {
@@ -65,12 +69,12 @@ int pcap_setup(char *str, char **mac_out
 		  .optimize 	= 0,
 		  .filter 	= NULL });
 
-	remain = split_if_spec(str, &host_if, &init->filter, 
+	remain = split_if_spec(str, &host_if, &init->filter,
 			       &options[0], &options[1], NULL);
 	if(remain != NULL){
 		printk(KERN_ERR "pcap_setup - Extra garbage on "
 		       "specification : '%s'\n", remain);
-		return(0);
+		return 0;
 	}
 
 	if(host_if != NULL)
@@ -87,10 +91,13 @@ int pcap_setup(char *str, char **mac_out
 			init->optimize = 1;
 		else if(!strcmp(options[i], "nooptimize"))
 			init->optimize = 0;
-		else printk("pcap_setup : bad option - '%s'\n", options[i]);
+		else {
+			printk("pcap_setup : bad option - '%s'\n", options[i]);
+			return 0;
+		}
 	}
 
-	return(1);
+	return 1;
 }
 
 static struct transport pcap_transport = {
diff -puN arch/um/drivers/pcap_user.c~uml-network-and-pcap-cleanup arch/um/drivers/pcap_user.c
--- a/arch/um/drivers/pcap_user.c~uml-network-and-pcap-cleanup
+++ a/arch/um/drivers/pcap_user.c
@@ -13,6 +13,7 @@
 #include "pcap_user.h"
 #include "user.h"
 #include "um_malloc.h"
+#include "kern_constants.h"
 
 #define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
 
@@ -26,8 +27,8 @@ static int pcap_user_init(void *data, vo
 
 	p = pcap_open_live(pri->host_if, MAX_PACKET, pri->promisc, 0, errors);
 	if(p == NULL){
-		printk("pcap_user_init : pcap_open_live failed - '%s'\n", 
-		       errors);
+		printk(UM_KERN_ERR "pcap_user_init : pcap_open_live failed - "
+		       "'%s'\n", errors);
 		return -EINVAL;
 	}
 
@@ -48,13 +49,13 @@ static int pcap_open(void *data)
 	if(pri->filter != NULL){
 		err = dev_netmask(pri->dev, &netmask);
 		if(err < 0){
-			printk("pcap_open : dev_netmask failed\n");
+			printk(UM_KERN_ERR "pcap_open : dev_netmask failed\n");
 			return -EIO;
 		}
 
 		pri->compiled = um_kmalloc(sizeof(struct bpf_program));
 		if(pri->compiled == NULL){
-			printk("pcap_open : kmalloc failed\n");
+			printk(UM_KERN_ERR "pcap_open : kmalloc failed\n");
 			return -ENOMEM;
 		}
 
@@ -62,15 +63,15 @@ static int pcap_open(void *data)
 				   (struct bpf_program *) pri->compiled, 
 				   pri->filter, pri->optimize, netmask);
 		if(err < 0){
-			printk("pcap_open : pcap_compile failed - '%s'\n", 
-			       pcap_geterr(pri->pcap));
+			printk(UM_KERN_ERR "pcap_open : pcap_compile failed - "
+			       "'%s'\n", pcap_geterr(pri->pcap));
 			return -EIO;
 		}
 
 		err = pcap_setfilter(pri->pcap, pri->compiled);
 		if(err < 0){
-			printk("pcap_open : pcap_setfilter failed - '%s'\n", 
-			       pcap_geterr(pri->pcap));
+			printk(UM_KERN_ERR "pcap_open : pcap_setfilter "
+			       "failed - '%s'\n", pcap_geterr(pri->pcap));
 			return -EIO;
 		}
 	}
@@ -85,7 +86,8 @@ static void pcap_remove(void *data)
 	if(pri->compiled != NULL)
 		pcap_freecode(pri->compiled);
 
-	pcap_close(pri->pcap);
+	if(pri->pcap != NULL)
+		pcap_close(pri->pcap);
 }
 
 struct pcap_handler_data {
@@ -114,7 +116,8 @@ int pcap_user_read(int fd, void *buffer,
 
 	n = pcap_dispatch(pri->pcap, 1, handler, (u_char *) &hdata);
 	if(n < 0){
-		printk("pcap_dispatch failed - %s\n", pcap_geterr(pri->pcap));
+		printk(UM_KERN_ERR "pcap_dispatch failed - %s\n",
+		       pcap_geterr(pri->pcap));
 		return -EIO;
 	}
 	else if(n == 0) 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
