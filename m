From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-tipc.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:14 -0700
Message-ID: <200704122248.l3CMmG1w018734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXDLWs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, allan.stephens@windriver.com, jengelh@gmx.de, jon.maloy@ericsson.com, per.liden@ericsson.com


The patch titled
     Use menuconfig objects: TIPC
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-tipc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: TIPC
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Per Liden <per.liden@ericsson.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/tipc/Kconfig |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff -puN net/tipc/Kconfig~use-menuconfig-objects-tipc net/tipc/Kconfig
--- a/net/tipc/Kconfig~use-menuconfig-objects-tipc
+++ a/net/tipc/Kconfig
@@ -2,11 +2,9 @@
 # TIPC configuration
 #
 
-menu "TIPC Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config TIPC
+menuconfig TIPC
 	tristate "The TIPC Protocol (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
 	---help---
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
@@ -22,9 +20,10 @@ config TIPC
 
 	  If in doubt, say N.
 
+if TIPC
+
 config TIPC_ADVANCED
 	bool "TIPC: Advanced configuration"
-	depends on TIPC
 	default n
 	help
 	  Saying Y here will open some advanced configuration
@@ -33,7 +32,7 @@ config TIPC_ADVANCED
 
 config TIPC_ZONES
 	int "Maximum number of zones in network"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "3"
 	help
 	 Max number of zones inside TIPC network. Max supported value 
@@ -44,7 +43,7 @@ config TIPC_ZONES
 
 config TIPC_CLUSTERS
 	int "Maximum number of clusters in a zone"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "1"
 	help
           ***Only 1 (one cluster in a zone) is supported by current code.
@@ -59,7 +58,7 @@ config TIPC_CLUSTERS
 
 config TIPC_NODES
 	int "Maximum number of nodes in cluster"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "255"
 	help
 	  Maximum number of nodes inside a TIPC cluster. Maximum 
@@ -70,7 +69,7 @@ config TIPC_NODES
 
 config TIPC_SLAVE_NODES
 	int "Maximum number of slave nodes in cluster"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "0"
 	help
           ***This capability is not supported by current code.***
@@ -83,7 +82,7 @@ config TIPC_SLAVE_NODES
 
 config TIPC_PORTS
 	int "Maximum number of ports in a node"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default "8191"
 	help
 	  Maximum number of ports within a node. Maximum 
@@ -94,7 +93,7 @@ config TIPC_PORTS
 
 config TIPC_LOG
 	int "Size of log buffer"
-	depends on TIPC && TIPC_ADVANCED
+	depends on TIPC_ADVANCED
 	default 0
 	help
  	  Size (in bytes) of TIPC's internal log buffer, which records the
@@ -106,7 +105,6 @@ config TIPC_LOG
 
 config TIPC_DEBUG
 	bool "Enable debugging support"
-	depends on TIPC
 	default n
 	help
  	  This will enable debugging of TIPC.
@@ -114,4 +112,4 @@ config TIPC_DEBUG
 	  Only say Y here if you are having trouble with TIPC.  It will
 	  enable the display of detailed information about what is going on.
 
-endmenu
+endif # TIPC
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
