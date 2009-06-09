From: akpm@linux-foundation.org
Subject: [merged] watchdog-fix-memory-corruption-when-rcba-is-disabled-by-hardware.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:30 -0700
Message-ID: <200906091812.n59ICU8f018731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbZFISMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, vvs@openvz.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     watchdog: fix memory corruption when RCBA is disabled by hardware
has been removed from the -mm tree.  Its filename was
     watchdog-fix-memory-corruption-when-rcba-is-disabled-by-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fix memory corruption when RCBA is disabled by hardware


According to 9.1.33 on p.343 of ICH8.pdf RCBA can be disabled by hardware
if bit 0 of RCBA register is not set.

Perform correct check for this to prevent memory corruption under some
virtual machines where this feature is disabled.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Vasily Averin <vvs@openvz.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/iTCO_wdt.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/watchdog/iTCO_wdt.c~watchdog-fix-memory-corruption-when-rcba-is-disabled-by-hardware drivers/watchdog/iTCO_wdt.c
--- a/drivers/watchdog/iTCO_wdt.c~watchdog-fix-memory-corruption-when-rcba-is-disabled-by-hardware
+++ a/drivers/watchdog/iTCO_wdt.c
@@ -666,6 +666,12 @@ static int __devinit iTCO_wdt_init(struc
 	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
+		if ((base_address & 1) == 0) {
+			printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+			       "RCBA is disabled by harddware\n");
+			ret = -ENODEV;
+			goto out_put;
+		}
 		RCBA = base_address & 0xffffc000;
 		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
 	}
@@ -745,6 +751,7 @@ unreg_smi_en:
 out:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
+out_put:
 	pci_dev_put(iTCO_wdt_private.pdev);
 	iTCO_wdt_private.ACPIBASE = 0;
 	return ret;
_

Patches currently in -mm which might be from den@openvz.org are

linux-next.patch

