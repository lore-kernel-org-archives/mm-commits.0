From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-md.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:00 -0700
Message-ID: <200707172309.l6HN90q2012329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936324AbXGQXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - MD
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - MD
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/md/Kconfig~use-menuconfig-objects-ii-md drivers/md/Kconfig
--- a/drivers/md/Kconfig~use-menuconfig-objects-ii-md
+++ a/drivers/md/Kconfig
@@ -2,19 +2,17 @@
 # Block device driver configuration
 #
 
-if BLOCK
-
-menu "Multi-device support (RAID and LVM)"
-
-config MD
+menuconfig MD
 	bool "Multiple devices driver support (RAID and LVM)"
+	depends on BLOCK
 	help
 	  Support multiple physical spindles through a single logical device.
 	  Required for RAID and logical volume management.
 
+if MD
+
 config BLK_DEV_MD
 	tristate "RAID support"
-	depends on MD
 	---help---
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one
@@ -191,7 +189,6 @@ config MD_FAULTY
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
-	depends on MD
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
@@ -279,6 +276,4 @@ config DM_DELAY
 
 	If unsure, say N.
 
-endmenu
-
-endif
+endif # MD
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
