From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-sctp.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:45 -0700
Message-ID: <200705291854.l4TIsitT008547@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbXE2SzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, sri@us.ibm.com, vladislav.yasevich@hp.com, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: SCTP
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-sctp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+	depends on INET && EXPERIMENTAL
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

use-menuconfig-objects-acpi.patch
git-hid.patch
use-menuconfig-objects-ii-infiniband.patch
git-kvm.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
