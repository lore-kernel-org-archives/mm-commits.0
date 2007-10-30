From: akpm@linux-foundation.org
Subject: - itco_wdt_start-undo-locking-when-reboot-is-disabled.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:55 -0700
Message-ID: <200710301806.l9UI6tHZ020561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbXJ3SSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     iTCO_wdt_start: undo locking when reboot is disabled
has been removed from the -mm tree.  Its filename was
     itco_wdt_start-undo-locking-when-reboot-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
i4l-errors-with-assignments-in-if.patch
git-arm-master.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
git-watchdog.patch
cris-gpio-undo-locks-before-returning.patch
arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
