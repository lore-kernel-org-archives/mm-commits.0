From: akpm@linux-foundation.org
Subject: [merged] auxdisplay-remove-parport-dependency.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:47 -0700
Message-ID: <200904011839.n31IdlbJ008780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758272AbZDATlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hsweeten@visionengravers.com, miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     auxdisplay: remove PARPORT dependency
has been removed from the -mm tree.  Its filename was
     auxdisplay-remove-parport-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: auxdisplay: remove PARPORT dependency
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Remove PARPORT dependency for Auxiliary Display support.

This is not needed since the dependency for the KS0108 driver is
PARPORT_PC.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~auxdisplay-remove-parport-dependency drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~auxdisplay-remove-parport-dependency
+++ a/drivers/auxdisplay/Kconfig
@@ -6,7 +6,6 @@
 #
 
 menuconfig AUXDISPLAY
-	depends on PARPORT
 	bool "Auxiliary Display support"
 	---help---
 	  Say Y here to get to see options for auxiliary display drivers.
@@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
 
 	  If you say N, all options in this submenu will be skipped and disabled.
 
-if AUXDISPLAY && PARPORT
+if AUXDISPLAY
 
 config KS0108
 	tristate "KS0108 LCD Controller"
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

origin.patch
linux-next.patch
mtd-plat_nand-add-platform-probe-remove-callbacks.patch
mtd-plat_nand-allow-platform-to-set-partitions.patch

