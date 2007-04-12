From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-sctp.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:48:12 -0700
Message-ID: <200704122248.l3CMmC05018731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXDLWs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, sri@us.ibm.com, vladislav.yasevich@hp.com


The patch titled
     Use menuconfig objects: SCTP
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-sctp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: SCTP
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/Kconfig |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff -puN net/sctp/Kconfig~use-menuconfig-objects-sctp net/sctp/Kconfig
--- a/net/sctp/Kconfig~use-menuconfig-objects-sctp
+++ a/net/sctp/Kconfig
@@ -2,11 +2,9 @@
 # SCTP configuration
 #
 
-menu "SCTP Configuration (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
-
-config IP_SCTP
+menuconfig IP_SCTP
 	tristate "The SCTP Protocol (EXPERIMENTAL)"
+	depends on NET && EXPERIMENTAL
 	depends on IPV6 || IPV6=n
 	select CRYPTO if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
 	select CRYPTO_HMAC if SCTP_HMAC_SHA1 || SCTP_HMAC_MD5
@@ -36,9 +34,10 @@ config IP_SCTP
 
 	  If in doubt, say N.
 
+if IP_SCTP
+
 config SCTP_DBG_MSG
 	bool "SCTP: Debug messages"
-	depends on IP_SCTP
 	help
 	  If you say Y, this will enable verbose debugging messages. 
 
@@ -47,7 +46,6 @@ config SCTP_DBG_MSG
 
 config SCTP_DBG_OBJCNT
 	bool "SCTP: Debug object counts"
-	depends on IP_SCTP
 	help
 	  If you say Y, this will enable debugging support for counting the 
 	  type of objects that are currently allocated.  This is useful for 
@@ -59,7 +57,6 @@ config SCTP_DBG_OBJCNT
 
 choice
 	prompt "SCTP: Cookie HMAC Algorithm"
-	depends on IP_SCTP
 	default SCTP_HMAC_MD5
 	help
 	  HMAC algorithm to be used during association initialization.  It
@@ -86,4 +83,5 @@ config SCTP_HMAC_MD5
 	  advised to use either HMAC-MD5 or HMAC-SHA1.
 
 endchoice
-endmenu
+
+endif # IP_SCTP
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
