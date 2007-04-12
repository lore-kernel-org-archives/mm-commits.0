From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ipvs.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:05 -0700
Message-ID: <200704122248.l3CMmA3M018728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXDLWs0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, horms@verge.net.au, jengelh@gmx.de


The patch titled
     Use menuconfig objects: IPVS
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ipvs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: IPVS
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipvs/Kconfig |   30 +++++-------------------------
 1 files changed, 5 insertions(+), 25 deletions(-)

diff -puN net/ipv4/ipvs/Kconfig~use-menuconfig-objects-ipvs net/ipv4/ipvs/Kconfig
--- a/net/ipv4/ipvs/Kconfig~use-menuconfig-objects-ipvs
+++ a/net/ipv4/ipvs/Kconfig
@@ -1,10 +1,7 @@
 #
 # IP Virtual Server configuration
 #
-menu	"IP: Virtual Server Configuration"
-	depends on NETFILTER
-
-config	IP_VS
+menuconfig IP_VS
 	tristate "IP virtual server support (EXPERIMENTAL)"
 	depends on NETFILTER
 	---help---
@@ -25,9 +22,10 @@ config	IP_VS
 	  If you want to compile it in kernel, say Y. To compile it as a
 	  module, choose M here. If unsure, say N.
 
+if IP_VS
+
 config	IP_VS_DEBUG
 	bool "IP virtual server debugging"
-	depends on IP_VS
 	---help---
 	  Say Y here if you want to get additional messages useful in
 	  debugging the IP virtual server code. You can change the debug
@@ -35,7 +33,6 @@ config	IP_VS_DEBUG
 
 config	IP_VS_TAB_BITS
 	int "IPVS connection table size (the Nth power of 2)"
-	depends on IP_VS 
 	default "12" 
 	---help---
 	  The IPVS connection hash table uses the chaining scheme to handle
@@ -61,42 +58,35 @@ config	IP_VS_TAB_BITS
 	  needed for your box.
 
 comment "IPVS transport protocol load balancing support"
-        depends on IP_VS
 
 config	IP_VS_PROTO_TCP
 	bool "TCP load balancing support"
-	depends on IP_VS
 	---help---
 	  This option enables support for load balancing TCP transport
 	  protocol. Say Y if unsure.
 
 config	IP_VS_PROTO_UDP
 	bool "UDP load balancing support"
-	depends on IP_VS
 	---help---
 	  This option enables support for load balancing UDP transport
 	  protocol. Say Y if unsure.
 
 config	IP_VS_PROTO_ESP
 	bool "ESP load balancing support"
-	depends on IP_VS
 	---help---
 	  This option enables support for load balancing ESP (Encapsulation
 	  Security Payload) transport protocol. Say Y if unsure.
 
 config	IP_VS_PROTO_AH
 	bool "AH load balancing support"
-	depends on IP_VS
 	---help---
 	  This option enables support for load balancing AH (Authentication
 	  Header) transport protocol. Say Y if unsure.
 
 comment "IPVS scheduler"
-        depends on IP_VS
 
 config	IP_VS_RR
 	tristate "round-robin scheduling"
-	depends on IP_VS
 	---help---
 	  The robin-robin scheduling algorithm simply directs network
 	  connections to different real servers in a round-robin manner.
@@ -106,7 +96,6 @@ config	IP_VS_RR
  
 config	IP_VS_WRR
         tristate "weighted round-robin scheduling" 
-	depends on IP_VS
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
@@ -120,7 +109,6 @@ config	IP_VS_WRR
 
 config	IP_VS_LC
         tristate "least-connection scheduling"
-        depends on IP_VS
 	---help---
 	  The least-connection scheduling algorithm directs network
 	  connections to the server with the least number of active 
@@ -131,7 +119,6 @@ config	IP_VS_LC
 
 config	IP_VS_WLC
         tristate "weighted least-connection scheduling"
-        depends on IP_VS
 	---help---
 	  The weighted least-connection scheduling algorithm directs network
 	  connections to the server with the least active connections
@@ -142,7 +129,6 @@ config	IP_VS_WLC
 
 config	IP_VS_LBLC
 	tristate "locality-based least-connection scheduling"
-        depends on IP_VS
 	---help---
 	  The locality-based least-connection scheduling algorithm is for
 	  destination IP load balancing. It is usually used in cache cluster.
@@ -157,7 +143,6 @@ config	IP_VS_LBLC
 
 config  IP_VS_LBLCR
 	tristate "locality-based least-connection with replication scheduling"
-        depends on IP_VS
 	---help---
 	  The locality-based least-connection with replication scheduling
 	  algorithm is also for destination IP load balancing. It is 
@@ -176,7 +161,6 @@ config  IP_VS_LBLCR
 
 config	IP_VS_DH
 	tristate "destination hashing scheduling"
-        depends on IP_VS
 	---help---
 	  The destination hashing scheduling algorithm assigns network
 	  connections to the servers through looking up a statically assigned
@@ -187,7 +171,6 @@ config	IP_VS_DH
 
 config	IP_VS_SH
 	tristate "source hashing scheduling"
-        depends on IP_VS
 	---help---
 	  The source hashing scheduling algorithm assigns network
 	  connections to the servers through looking up a statically assigned
@@ -198,7 +181,6 @@ config	IP_VS_SH
 
 config	IP_VS_SED
 	tristate "shortest expected delay scheduling"
-        depends on IP_VS
 	---help---
 	  The shortest expected delay scheduling algorithm assigns network
 	  connections to the server with the shortest expected delay. The 
@@ -212,7 +194,6 @@ config	IP_VS_SED
 
 config	IP_VS_NQ
 	tristate "never queue scheduling"
-        depends on IP_VS
 	---help---
 	  The never queue scheduling algorithm adopts a two-speed model.
 	  When there is an idle server available, the job will be sent to
@@ -225,11 +206,10 @@ config	IP_VS_NQ
 	  module, choose M here. If unsure, say N.
 
 comment 'IPVS application helper'
-	depends on IP_VS
 
 config	IP_VS_FTP
   	tristate "FTP protocol helper"
-        depends on IP_VS && IP_VS_PROTO_TCP
+        depends on IP_VS_PROTO_TCP
 	---help---
 	  FTP is a protocol that transfers IP address and/or port number in
 	  the payload. In the virtual server via Network Address Translation,
@@ -241,4 +221,4 @@ config	IP_VS_FTP
 	  If you want to compile it in kernel, say Y. To compile it as a
 	  module, choose M here. If unsure, say N.
 
-endmenu
+endif # IP_VS
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-mtd.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcihotplug.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
