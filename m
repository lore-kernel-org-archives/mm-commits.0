From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-dccp.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:47:34 -0700
Message-ID: <200704122247.l3CMlYXm018709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXDLWsR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, acme@conectiva.com.br, jengelh@gmx.de


The patch titled
     Use menuconfig objects: DCCP
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-dccp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: DCCP
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@conectiva.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/Kconfig |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff -puN net/dccp/Kconfig~use-menuconfig-objects-dccp net/dccp/Kconfig
--- a/net/dccp/Kconfig~use-menuconfig-objects-dccp
+++ a/net/dccp/Kconfig
@@ -1,8 +1,6 @@
-menu "DCCP Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config IP_DCCP
+menuconfig IP_DCCP
 	tristate "The DCCP Protocol (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
 	---help---
 	  Datagram Congestion Control Protocol (RFC 4340)
 
@@ -19,19 +17,20 @@ config IP_DCCP
 
 	  If in doubt, say N.
 
+if IP_DCCP
+
 config INET_DCCP_DIAG
-	depends on IP_DCCP && INET_DIAG
+	depends on INET_DIAG
 	def_tristate y if (IP_DCCP = y && INET_DIAG = y)
 	def_tristate m
 
 config IP_DCCP_ACKVEC
-	depends on IP_DCCP
 	bool
 
 source "net/dccp/ccids/Kconfig"
 
 menu "DCCP Kernel Hacking"
-	depends on IP_DCCP && DEBUG_KERNEL=y
+	depends on DEBUG_KERNEL=y
 
 config IP_DCCP_DEBUG
 	bool "DCCP debug messages"
@@ -61,4 +60,4 @@ config NET_DCCPPROBE
 
 endmenu
 
-endmenu
+endif # IP_DDCP
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
