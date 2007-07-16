From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-telephony.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:31 -0700
Message-ID: <200707162052.l6GKqVab001552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXGPVZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - Telephony
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-telephony.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - Telephony
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/Kconfig |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/telephony/Kconfig~use-menuconfig-objects-ii-telephony drivers/telephony/Kconfig
--- a/drivers/telephony/Kconfig~use-menuconfig-objects-ii-telephony
+++ a/drivers/telephony/Kconfig
@@ -2,11 +2,9 @@
 # Telephony device configuration
 #
 
-menu "Telephony Support"
+menuconfig PHONE
+	tristate "Telephony support"
 	depends on HAS_IOMEM
-
-config PHONE
-	tristate "Linux telephony support"
 	---help---
 	  Say Y here if you have a telephony card, which for example allows
 	  you to use a regular phone for voice-over-IP applications.
@@ -17,9 +15,10 @@ config PHONE
 	  To compile this driver as a module, choose M here: the
 	  module will be called phonedev.
 
+if PHONE
+
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
-	depends on PHONE
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
@@ -44,5 +43,4 @@ config PHONE_IXJ_PCMCIA
 	  cards manufactured by Quicknet Technologies, Inc.  This changes the
 	  card initialization code to work with the card manager daemon.
 
-endmenu
-
+endif # PHONE
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
