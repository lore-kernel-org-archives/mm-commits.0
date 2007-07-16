From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-auxdisplay.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:13 -0700
Message-ID: <200707162052.l6GKqDgf001520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbXGPVcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - auxdisplay
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-auxdisplay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - auxdisplay
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~use-menuconfig-objects-ii-auxdisplay drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~use-menuconfig-objects-ii-auxdisplay
+++ a/drivers/auxdisplay/Kconfig
@@ -5,8 +5,11 @@
 # Auxiliary display drivers configuration.
 #
 
-menu "Auxiliary Display support"
+menuconfig AUXDISPLAY
 	depends on PARPORT
+	bool "Auxiliary Display support"
+
+if AUXDISPLAY && PARPORT
 
 config KS0108
 	tristate "KS0108 LCD Controller"
@@ -111,4 +114,5 @@ config CFAG12864B_RATE
 
 	  If you compile this as a module, you can still override this
 	  value using the module parameters.
-endmenu
+
+endif # AUXDISPLAY
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
