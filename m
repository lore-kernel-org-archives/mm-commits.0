From: akpm@linux-foundation.org
Subject: - docbook-make-a-networking-book-and-fix-a-few-errors.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:41 -0500
Message-ID: <200802150226.m1F2Q0CW015198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765361AbYBOC0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bfields@fieldses.org, davem@davemloft.net, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     docbook: make a networking book and fix a few errors
has been removed from the -mm tree.  Its filename was
     docbook-make-a-networking-book-and-fix-a-few-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: make a networking book and fix a few errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Move networking (core and drivers) docbook to its own networking book.
Fix a few kernel-doc errors in header and source files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile        |    2 
 Documentation/DocBook/kernel-api.tmpl |   65 --------------
 Documentation/DocBook/networking.tmpl |  106 ++++++++++++++++++++++++
 include/linux/etherdevice.h           |    3 
 net/core/dev.c                        |    3 
 net/core/skbuff.c                     |    4 
 6 files changed, 111 insertions(+), 72 deletions(-)

diff -puN Documentation/DocBook/Makefile~docbook-make-a-networking-book-and-fix-a-few-errors Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~docbook-make-a-networking-book-and-fix-a-few-errors
+++ a/Documentation/DocBook/Makefile
@@ -8,7 +8,7 @@
 
 DOCBOOKS := wanbook.xml z8530book.xml mcabook.xml videobook.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
-	    procfs-guide.xml writing_usb_driver.xml \
+	    procfs-guide.xml writing_usb_driver.xml networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml
diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-make-a-networking-book-and-fix-a-few-errors Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-make-a-networking-book-and-fix-a-few-errors
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -204,71 +204,6 @@ X!Ilib/string.c
      </sect1>
   </chapter>
 
-  <chapter id="netcore">
-     <title>Linux Networking</title>
-     <sect1><title>Networking Base Types</title>
-!Iinclude/linux/net.h
-     </sect1>
-     <sect1><title>Socket Buffer Functions</title>
-!Iinclude/linux/skbuff.h
-!Iinclude/net/sock.h
-!Enet/socket.c
-!Enet/core/skbuff.c
-!Enet/core/sock.c
-!Enet/core/datagram.c
-!Enet/core/stream.c
-     </sect1>
-     <sect1><title>Socket Filter</title>
-!Enet/core/filter.c
-     </sect1>
-     <sect1><title>Generic Network Statistics</title>
-!Iinclude/linux/gen_stats.h
-!Enet/core/gen_stats.c
-!Enet/core/gen_estimator.c
-     </sect1>
-     <sect1><title>SUN RPC subsystem</title>
-<!-- The !D functionality is not perfect, garbage has to be protected by comments
-!Dnet/sunrpc/sunrpc_syms.c
--->
-!Enet/sunrpc/xdr.c
-!Enet/sunrpc/svc_xprt.c
-!Enet/sunrpc/xprt.c
-!Enet/sunrpc/sched.c
-!Enet/sunrpc/socklib.c
-!Enet/sunrpc/stats.c
-!Enet/sunrpc/rpc_pipe.c
-!Enet/sunrpc/rpcb_clnt.c
-!Enet/sunrpc/clnt.c
-     </sect1>
-  </chapter>
-
-  <chapter id="netdev">
-     <title>Network device support</title>
-     <sect1><title>Driver Support</title>
-!Enet/core/dev.c
-!Enet/ethernet/eth.c
-!Enet/sched/sch_generic.c
-!Iinclude/linux/etherdevice.h
-!Iinclude/linux/netdevice.h
-     </sect1>
-     <sect1><title>PHY Support</title>
-!Edrivers/net/phy/phy.c
-!Idrivers/net/phy/phy.c
-!Edrivers/net/phy/phy_device.c
-!Idrivers/net/phy/phy_device.c
-!Edrivers/net/phy/mdio_bus.c
-!Idrivers/net/phy/mdio_bus.c
-     </sect1>
-<!-- FIXME: Removed for now since no structured comments in source
-     <sect1><title>Wireless</title>
-X!Enet/core/wireless.c
-     </sect1>
--->
-     <sect1><title>Synchronous PPP</title>
-!Edrivers/net/wan/syncppp.c
-     </sect1>
-  </chapter>
-
   <chapter id="modload">
      <title>Module Support</title>
      <sect1><title>Module Loading</title>
diff -puN /dev/null Documentation/DocBook/networking.tmpl
--- /dev/null
+++ a/Documentation/DocBook/networking.tmpl
@@ -0,0 +1,106 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="LinuxNetworking">
+ <bookinfo>
+  <title>Linux Networking and Network Devices APIs</title>
+
+  <legalnotice>
+   <para>
+     This documentation is free software; you can redistribute
+     it and/or modify it under the terms of the GNU General Public
+     License as published by the Free Software Foundation; either
+     version 2 of the License, or (at your option) any later
+     version.
+   </para>
+
+   <para>
+     This program is distributed in the hope that it will be
+     useful, but WITHOUT ANY WARRANTY; without even the implied
+     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+     See the GNU General Public License for more details.
+   </para>
+
+   <para>
+     You should have received a copy of the GNU General Public
+     License along with this program; if not, write to the Free
+     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+     MA 02111-1307 USA
+   </para>
+
+   <para>
+     For more details see the file COPYING in the source
+     distribution of Linux.
+   </para>
+  </legalnotice>
+ </bookinfo>
+
+<toc></toc>
+
+  <chapter id="netcore">
+     <title>Linux Networking</title>
+     <sect1><title>Networking Base Types</title>
+!Iinclude/linux/net.h
+     </sect1>
+     <sect1><title>Socket Buffer Functions</title>
+!Iinclude/linux/skbuff.h
+!Iinclude/net/sock.h
+!Enet/socket.c
+!Enet/core/skbuff.c
+!Enet/core/sock.c
+!Enet/core/datagram.c
+!Enet/core/stream.c
+     </sect1>
+     <sect1><title>Socket Filter</title>
+!Enet/core/filter.c
+     </sect1>
+     <sect1><title>Generic Network Statistics</title>
+!Iinclude/linux/gen_stats.h
+!Enet/core/gen_stats.c
+!Enet/core/gen_estimator.c
+     </sect1>
+     <sect1><title>SUN RPC subsystem</title>
+<!-- The !D functionality is not perfect, garbage has to be protected by comments
+!Dnet/sunrpc/sunrpc_syms.c
+-->
+!Enet/sunrpc/xdr.c
+!Enet/sunrpc/svc_xprt.c
+!Enet/sunrpc/xprt.c
+!Enet/sunrpc/sched.c
+!Enet/sunrpc/socklib.c
+!Enet/sunrpc/stats.c
+!Enet/sunrpc/rpc_pipe.c
+!Enet/sunrpc/rpcb_clnt.c
+!Enet/sunrpc/clnt.c
+     </sect1>
+  </chapter>
+
+  <chapter id="netdev">
+     <title>Network device support</title>
+     <sect1><title>Driver Support</title>
+!Enet/core/dev.c
+!Enet/ethernet/eth.c
+!Enet/sched/sch_generic.c
+!Iinclude/linux/etherdevice.h
+!Iinclude/linux/netdevice.h
+     </sect1>
+     <sect1><title>PHY Support</title>
+!Edrivers/net/phy/phy.c
+!Idrivers/net/phy/phy.c
+!Edrivers/net/phy/phy_device.c
+!Idrivers/net/phy/phy_device.c
+!Edrivers/net/phy/mdio_bus.c
+!Idrivers/net/phy/mdio_bus.c
+     </sect1>
+<!-- FIXME: Removed for now since no structured comments in source
+     <sect1><title>Wireless</title>
+X!Enet/core/wireless.c
+     </sect1>
+-->
+     <sect1><title>Synchronous PPP</title>
+!Edrivers/net/wan/syncppp.c
+     </sect1>
+  </chapter>
+
+</book>
diff -puN include/linux/etherdevice.h~docbook-make-a-networking-book-and-fix-a-few-errors include/linux/etherdevice.h
--- a/include/linux/etherdevice.h~docbook-make-a-networking-book-and-fix-a-few-errors
+++ a/include/linux/etherdevice.h
@@ -70,8 +70,7 @@ static inline int is_multicast_ether_add
 }
 
 /**
- * is_local_ether_addr - Determine if the Ethernet address is locally-assigned
- * one (IEEE 802).
+ * is_local_ether_addr - Determine if the Ethernet address is locally-assigned one (IEEE 802).
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
  * Return true if the address is a local address.
diff -puN net/core/dev.c~docbook-make-a-networking-book-and-fix-a-few-errors net/core/dev.c
--- a/net/core/dev.c~docbook-make-a-networking-book-and-fix-a-few-errors
+++ a/net/core/dev.c
@@ -3038,8 +3038,7 @@ int dev_unicast_sync(struct net_device *
 EXPORT_SYMBOL(dev_unicast_sync);
 
 /**
- *	dev_unicast_unsync - Remove synchronized addresses from the destination
- *			     device
+ *	dev_unicast_unsync - Remove synchronized addresses from the destination device
  *	@to: destination device
  *	@from: source device
  *
diff -puN net/core/skbuff.c~docbook-make-a-networking-book-and-fix-a-few-errors net/core/skbuff.c
--- a/net/core/skbuff.c~docbook-make-a-networking-book-and-fix-a-few-errors
+++ a/net/core/skbuff.c
@@ -1907,11 +1907,11 @@ void skb_prepare_seq_read(struct sk_buff
  * of bytes already consumed and the next call to
  * skb_seq_read() will return the remaining part of the block.
  *
- * Note: The size of each block of data returned can be arbitary,
+ * Note 1: The size of each block of data returned can be arbitary,
  *       this limitation is the cost for zerocopy seqeuental
  *       reads of potentially non linear data.
  *
- * Note: Fragment lists within fragments are not implemented
+ * Note 2: Fragment lists within fragments are not implemented
  *       at the moment, state->root_skb could be replaced with
  *       a stack for this purpose.
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-remove-fastcall.patch
git-acpi.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
