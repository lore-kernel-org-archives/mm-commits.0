From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn-gigaset.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:56 -0700
Message-ID: <200707230934.l6N9YuCl016435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757997AbXGWJp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, jengelh@gmx.de, kkeil@suse.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN/Gigaset
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn-gigaset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ISDN/Gigaset
From: Jan Engelhardt <jengelh@computergmbh.de>

Change Kconfig objects from "menu, config" into "menuconfig" so that the user
can disable the whole feature without having to enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/Kconfig |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-isdn-gigaset drivers/isdn/gigaset/Kconfig
--- a/drivers/isdn/gigaset/Kconfig~use-menuconfig-objects-isdn-gigaset
+++ a/drivers/isdn/gigaset/Kconfig
@@ -1,6 +1,4 @@
-menu "Siemens Gigaset"
-
-config ISDN_DRV_GIGASET
+menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
 	select CRC_CCITT
 	select BITREVERSE
@@ -53,6 +51,4 @@ config GIGASET_UNDOCREQ
 	  features like configuration mode of M105, say yes. If you
 	  care about your device, say no.
 
-endif
-
-endmenu
+endif # ISDN_DRV_GIGASET != n
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
