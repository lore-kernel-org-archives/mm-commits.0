From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-misc-strange-dev.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:22 -0700
Message-ID: <200707162052.l6GKqM4u001543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXGPVXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - misc strange dev
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-misc-strange-dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - misc strange dev
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev
+++ a/drivers/misc/Kconfig
@@ -2,7 +2,11 @@
 # Misc strange devices
 #
 
-menu "Misc devices"
+menuconfig MISC_STRANGE_DEV
+	bool "Misc devices"
+	default y
+
+if MISC_STRANGE_DEV
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
@@ -192,4 +196,4 @@ config THINKPAD_ACPI_BAY
 
 	  If you are not sure, say Y here.
 
-endmenu
+endif # MISC_STRANGE_DEV
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
