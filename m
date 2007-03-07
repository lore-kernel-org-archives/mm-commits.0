From: akpm@linux-foundation.org
Subject: - __devinit-__devexit-cleanups-for-de2104x-driver.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:23:20 -0800
Message-ID: <200703070423.l274NKlx019051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbXCGEYZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     __devinit & __devexit cleanups for de2104x driver
has been removed from the -mm tree.  Its filename was
     __devinit-__devexit-cleanups-for-de2104x-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: __devinit & __devexit cleanups for de2104x driver
From: Prarit Bhargava <prarit@redhat.com>

Fixes MODPOST warnings similar to:

WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.init.text:de_init_one from .data.rel.local after 'de_driver' (at offset 0x20)
WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.exit.text:de_remove_one from .data.rel.local after 'de_driver' (at offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/de2104x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/tulip/de2104x.c~__devinit-__devexit-cleanups-for-de2104x-driver drivers/net/tulip/de2104x.c
--- a/drivers/net/tulip/de2104x.c~__devinit-__devexit-cleanups-for-de2104x-driver
+++ a/drivers/net/tulip/de2104x.c
@@ -1685,7 +1685,7 @@ static const struct ethtool_ops de_ethto
 	.get_regs		= de_get_regs,
 };
 
-static void __init de21040_get_mac_address (struct de_private *de)
+static void __devinit de21040_get_mac_address (struct de_private *de)
 {
 	unsigned i;
 
@@ -1703,7 +1703,7 @@ static void __init de21040_get_mac_addre
 	}
 }
 
-static void __init de21040_get_media_info(struct de_private *de)
+static void __devinit de21040_get_media_info(struct de_private *de)
 {
 	unsigned int i;
 
@@ -1765,7 +1765,7 @@ static unsigned __devinit tulip_read_eep
 	return retval;
 }
 
-static void __init de21041_get_srom_info (struct de_private *de)
+static void __devinit de21041_get_srom_info (struct de_private *de)
 {
 	unsigned i, sa_offset = 0, ofs;
 	u8 ee_data[DE_EEPROM_SIZE + 6] = {};
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
use-stop_machine_run-in-the-intel-rng-driver.patch
change-rivafb_remove-to-__devexit.patch
