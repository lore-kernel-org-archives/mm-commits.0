From: akpm@linux-foundation.org
Subject: + net-tun-tap-fixed-hw-address-handling.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:48:57 -0800
Message-ID: <200703250948.l2P9mvVh025287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbXCYJtE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linuxkernel@bristyle.com


The patch titled
     net: tun/tap: fixed hw address handling
has been added to the -mm tree.  Its filename is
     net-tun-tap-fixed-hw-address-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: tun/tap: fixed hw address handling
From: Brian Braunstein <linuxkernel@bristyle.com>

Fixed tun/tap driver's handling of hw addresses.  The hw address is stored
in both the net_device.dev_addr and tun.dev_addr fields.  These fields were
not kept synchronized, and in fact weren't even initialized to the same
value.  Now during both init and when performing SIOCSIFHWADDR on the tun
device these values are both updated.  However, if SIOCSIFHWADDR is
performed on the net device directly (for instance, setting the hw address
using ifconfig), the tun device does not get updated.  Perhaps the
tun.dev_addr field should be removed completely at some point, as it is
redundant and net_device.dev_addr can be used anywhere it is used.

Signed-off-by: Brian Braunstein <linuxkernel@bristyle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tun.c |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff -puN drivers/net/tun.c~net-tun-tap-fixed-hw-address-handling drivers/net/tun.c
--- a/drivers/net/tun.c~net-tun-tap-fixed-hw-address-handling
+++ a/drivers/net/tun.c
@@ -18,6 +18,10 @@
 /*
  *  Changes:
  *
+ *  Brian Braunstein <linuxkernel@bristyle.com> 2007/03/23
+ *    Fixed hw address handling.  Now net_device.dev_addr is kept consistent
+ *    with tun.dev_addr when the address is set by this module.
+ *
  *  Mike Kershaw <dragorn@kismetwireless.net> 2005/08/14
  *    Add TUNSETLINK ioctl to set the link encapsulation
  *
@@ -196,7 +200,10 @@ static void tun_net_init(struct net_devi
 		dev->set_multicast_list = tun_net_mclist;
 
 		ether_setup(dev);
-		random_ether_addr(dev->dev_addr);
+
+		/* random address already created for us by tun_set_iff, use it */
+		memcpy(dev->dev_addr, tun->dev_addr, min(sizeof(tun->dev_addr), sizeof(dev->dev_addr)) );
+
 		dev->tx_queue_len = TUN_READQ_SIZE;  /* We prefer our own queue length */
 		break;
 	}
@@ -636,6 +643,7 @@ static int tun_chr_ioctl(struct inode *i
 		return 0;
 
 	case SIOCGIFHWADDR:
+		/* Note: the actual net device's address may be different */
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev_addr,
 				min(sizeof ifr.ifr_hwaddr.sa_data, sizeof tun->dev_addr));
 		if (copy_to_user( argp, &ifr, sizeof ifr))
@@ -643,16 +651,24 @@ static int tun_chr_ioctl(struct inode *i
 		return 0;
 
 	case SIOCSIFHWADDR:
-		/** Set the character device's hardware address. This is used when
-		 * filtering packets being sent from the network device to the character
-		 * device. */
-		memcpy(tun->dev_addr, ifr.ifr_hwaddr.sa_data,
-				min(sizeof ifr.ifr_hwaddr.sa_data, sizeof tun->dev_addr));
-		DBG(KERN_DEBUG "%s: set hardware address: %x:%x:%x:%x:%x:%x\n",
-				tun->dev->name,
-				tun->dev_addr[0], tun->dev_addr[1], tun->dev_addr[2],
-				tun->dev_addr[3], tun->dev_addr[4], tun->dev_addr[5]);
-		return 0;
+	{
+		/* try to set the actual net device's hw address */
+		int ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+
+		if (ret == 0) {
+			/** Set the character device's hardware address. This is used when
+			 * filtering packets being sent from the network device to the character
+			 * device. */
+			memcpy(tun->dev_addr, ifr.ifr_hwaddr.sa_data,
+					min(sizeof ifr.ifr_hwaddr.sa_data, sizeof tun->dev_addr));
+			DBG(KERN_DEBUG "%s: set hardware address: %x:%x:%x:%x:%x:%x\n",
+					tun->dev->name,
+					tun->dev_addr[0], tun->dev_addr[1], tun->dev_addr[2],
+					tun->dev_addr[3], tun->dev_addr[4], tun->dev_addr[5]);
+		}
+
+		return  ret;
+	}
 
 	case SIOCADDMULTI:
 		/** Add the specified group to the character device's multicast filter
_

Patches currently in -mm which might be from linuxkernel@bristyle.com are

net-tun-tap-fixed-hw-address-handling.patch
