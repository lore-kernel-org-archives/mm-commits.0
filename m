From: akpm@linux-foundation.org
Subject: + ata-piix-fix-pointer-deref-on-suspend.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:20:18 -0800
Message-ID: <200812030820.mB38KISu010957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbYLCIUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, a_romanescu@yahoo.co.uk, jgarzik@redhat.com, tj@kernel.org


The patch titled
     ata: piix, fix pointer deref on suspend
has been added to the -mm tree.  Its filename is
     ata-piix-fix-pointer-deref-on-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: piix, fix pointer deref on suspend
From: Jiri Slaby <jirislaby@gmail.com>

Commit
ata_piix: add borked Tecra M4 to broken suspend list
introduced DMI variables checking, but they can be null, so that
we possibly dereference null.

Check if they are null and avoid checks in that case.

Solves:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8043da97>] piix_pci_device_suspend+0x117/0x230

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ata_piix.c~ata-piix-fix-pointer-deref-on-suspend drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata-piix-fix-pointer-deref-on-suspend
+++ a/drivers/ata/ata_piix.c
@@ -1072,7 +1072,14 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (!strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
+	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
+	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
+	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
+	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
+	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
+	    dmi_get_system_info(DMI_BOARD_NAME) &&
+	    dmi_get_system_info(DMI_BOARD_VERSION) &&
+	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
ata-piix-fix-pointer-deref-on-suspend.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

