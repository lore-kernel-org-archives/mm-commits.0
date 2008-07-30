From: akpm@linux-foundation.org
Subject: + configure-out-ethtool-support.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:03:43 -0700
Message-ID: <200807300003.m6U03h6Q029132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbYG3AGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, davem@davemloft.net, jeff@garzik.org, mpm@selenic.com


The patch titled
     Configure out ethtool support
has been added to the -mm tree.  Its filename is
     configure-out-ethtool-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Configure out ethtool support
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Add the CONFIG_ETHTOOL option which allows to remove support for ethtool,
not necessarly used on embedded systems.  As this is a size-reduction
option, it depends on CONFIG_EMBEDDED.  It allows to save ~6 kilobytes of
kernel code:

   text	   data	    bss	    dec	    hex	filename
1258447	 123592	 212992	1595031	 185697	vmlinux
1252147	 123592	 212992	1588731	 183dfb	vmlinux.new
  -6300       0       0   -6300   -189C +/-

Question: should we also remove ethtool-related functions from all network
drivers ?

This patch has been originally written by Matt Mackall
<mpm@selenic.com>, and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ethtool.h |   16 ++++++++++++++++
 init/Kconfig            |    8 ++++++++
 net/core/Makefile       |    3 ++-
 net/core/dev.c          |    4 ++++
 4 files changed, 30 insertions(+), 1 deletion(-)

diff -puN include/linux/ethtool.h~configure-out-ethtool-support include/linux/ethtool.h
--- a/include/linux/ethtool.h~configure-out-ethtool-support
+++ a/include/linux/ethtool.h
@@ -283,6 +283,7 @@ struct ethtool_rxnfc {
 struct net_device;
 
 /* Some generic methods drivers may use in their ethtool_ops */
+#ifdef CONFIG_ETHTOOL
 u32 ethtool_op_get_link(struct net_device *dev);
 u32 ethtool_op_get_tx_csum(struct net_device *dev);
 int ethtool_op_set_tx_csum(struct net_device *dev, u32 data);
@@ -296,6 +297,21 @@ u32 ethtool_op_get_ufo(struct net_device
 int ethtool_op_set_ufo(struct net_device *dev, u32 data);
 u32 ethtool_op_get_flags(struct net_device *dev);
 int ethtool_op_set_flags(struct net_device *dev, u32 data);
+#else
+static inline u32 ethtool_op_get_link(struct net_device *dev) { return 0; }
+static inline u32 ethtool_op_get_tx_csum(struct net_device *dev) { return 0; }
+static inline int ethtool_op_set_tx_csum(struct net_device *dev, u32 data) { return 0; }
+static inline int ethtool_op_set_tx_hw_csum(struct net_device *dev, u32 data) { return 0; }
+static inline int ethtool_op_set_tx_ipv6_csum(struct net_device *dev, u32 data) { return 0; }
+static inline u32 ethtool_op_get_sg(struct net_device *dev) { return 0; }
+static inline int ethtool_op_set_sg(struct net_device *dev, u32 data) { return 0; }
+static inline u32 ethtool_op_get_tso(struct net_device *dev) { return 0; }
+static inline int ethtool_op_set_tso(struct net_device *dev, u32 data) { return 0; }
+static inline u32 ethtool_op_get_ufo(struct net_device *dev) { return 0; }
+static inline int ethtool_op_set_ufo(struct net_device *dev, u32 data) { return 0; }
+static inline u32 ethtool_op_get_flags(struct net_device *dev) { return 0; }
+static inline int ethtool_op_set_flags(struct net_device *dev, u32 data) { return 0; }
+#endif
 
 /**
  * &ethtool_ops - Alter and report network device settings
diff -puN init/Kconfig~configure-out-ethtool-support init/Kconfig
--- a/init/Kconfig~configure-out-ethtool-support
+++ a/init/Kconfig
@@ -724,6 +724,14 @@ config SHMEM
 	  option replaces shmem and tmpfs with the much simpler ramfs code,
 	  which may be appropriate on small systems without swap.
 
+config ETHTOOL
+	bool "Enable ethtool support" if EMBEDDED
+	depends on NET
+	default y
+	help
+	  Disabling this option removes support for configuring
+	  ethernet device features via ethtool. Saves about 6k.
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff -puN net/core/Makefile~configure-out-ethtool-support net/core/Makefile
--- a/net/core/Makefile~configure-out-ethtool-support
+++ a/net/core/Makefile
@@ -7,10 +7,11 @@ obj-y := sock.o request_sock.o skbuff.o 
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
-obj-y		     += dev.o ethtool.o dev_mcast.o dst.o netevent.o \
+obj-y		     += dev.o dev_mcast.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o
 
 obj-$(CONFIG_XFRM) += flow.o
+obj-$(CONFIG_ETHTOOL) += ethtool.o
 obj-y += net-sysfs.o
 obj-$(CONFIG_NET_PKTGEN) += pktgen.o
 obj-$(CONFIG_NETPOLL) += netpoll.o
diff -puN net/core/dev.c~configure-out-ethtool-support net/core/dev.c
--- a/net/core/dev.c~configure-out-ethtool-support
+++ a/net/core/dev.c
@@ -3669,6 +3669,7 @@ int dev_ioctl(struct net *net, unsigned 
 			return ret;
 
 		case SIOCETHTOOL:
+#ifdef CONFIG_ETHTOOL
 			dev_load(net, ifr.ifr_name);
 			rtnl_lock();
 			ret = dev_ethtool(net, &ifr);
@@ -3681,6 +3682,9 @@ int dev_ioctl(struct net *net, unsigned 
 					ret = -EFAULT;
 			}
 			return ret;
+#else
+			return -EINVAL;
+#endif
 
 		/*
 		 *	These ioctl calls:
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

configure-out-ethtool-support.patch
configure-out-file-locking-features.patch
configure-out-aio-support.patch
configure-out-igmp-support.patch

