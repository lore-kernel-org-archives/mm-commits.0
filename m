From: akpm@linux-foundation.org
Subject: - ata-piix-cleanup-dmi-strings-checking.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:35 -0800
Message-ID: <200901050641.n056fZOE005637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZAEGmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:42:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, a_romanescu@yahoo.co.uk, alan@lxorguk.ukuu.org.uk, jgarzik@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ata: piix, cleanup dmi strings checking
has been removed from the -mm tree.  Its filename was
     ata-piix-cleanup-dmi-strings-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: piix, cleanup dmi strings checking
From: Jiri Slaby <jirislaby@gmail.com>

Commit
ATA: piix, fix pointer deref on suspend
fixed a possible oops in an ugly manner. Use newly introduced dmi_match()
to make the code pretty again.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata-piix-cleanup-dmi-strings-checking drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata-piix-cleanup-dmi-strings-checking
+++ a/drivers/ata/ata_piix.c
@@ -1072,20 +1072,13 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
-	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
-	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
-	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
-	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
-	    dmi_get_system_info(DMI_BOARD_NAME) &&
-	    dmi_get_system_info(DMI_BOARD_VERSION) &&
-	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_NAME), "Portable PC") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VERSION), "Version A0"))
+	if (dmi_match(DMI_SYS_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_PRODUCT_NAME, "000000") &&
+	    dmi_match(DMI_PRODUCT_VERSION, "000000") &&
+	    dmi_match(DMI_PRODUCT_SERIAL, "000000") &&
+	    dmi_match(DMI_BOARD_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_BOARD_NAME, "Portable PC") &&
+	    dmi_match(DMI_BOARD_VERSION, "Version A0"))
 		return 1;
 
 	return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
8250_pci-add-support-for-netmos-9835.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

