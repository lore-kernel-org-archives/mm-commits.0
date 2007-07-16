From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-crypto-hw.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:40 -0700
Message-ID: <200707162052.l6GKqe7g001561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758312AbXGPVcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: crypto hw
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-crypto-hw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: crypto hw
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/Kconfig |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw
+++ a/drivers/crypto/Kconfig
@@ -1,4 +1,9 @@
-menu "Hardware crypto devices"
+
+menuconfig CRYPTO_HW
+	bool "Hardware crypto devices"
+	default y
+
+if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
@@ -78,4 +83,4 @@ config ZCRYPT_MONOLITHIC
 	  that contains all parts of the crypto device driver (ap bus,
 	  request router and all the card drivers).
 
-endmenu
+endif # CRYPTO_HW
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
