From: akpm@linux-foundation.org
Subject: + itco_wdt_start-undo-locking-when-reboot-is-disabled.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:01:41 -0700
Message-ID: <200710292101.l9TL1fL5023023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbXJ2VBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, wim@iguana.be


The patch titled
     iTCO_wdt_start: undo locking when reboot is disabled
has been added to the -mm tree.  Its filename is
     itco_wdt_start-undo-locking-when-reboot-is-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iTCO_wdt_start: undo locking when reboot is disabled
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/iTCO_wdt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/watchdog/iTCO_wdt.c~itco_wdt_start-undo-locking-when-reboot-is-disabled drivers/watchdog/iTCO_wdt.c
--- a/drivers/watchdog/iTCO_wdt.c~itco_wdt_start-undo-locking-when-reboot-is-disabled
+++ a/drivers/watchdog/iTCO_wdt.c
@@ -316,6 +316,7 @@ static int iTCO_wdt_start(struct watchdo
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
+		spin_unlock(&iTCO_wdt_private.io_lock);
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
 		return -EIO;
 	}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-arm-master.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
itco_wdt_start-undo-locking-when-reboot-is-disabled.patch
i4l-errors-with-assignments-in-if.patch
