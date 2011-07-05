From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-pch_phubc-fix-register-miss-setting-issue.patch removed from -mm tree
Date: Tue, 05 Jul 2011 12:59:24 -0700
Message-ID: <201107051959.p65Jx0ls020578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab1GET7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 15:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomoya-linux@dsn.okisemi.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/pch_phub.c: fix register miss-setting issue
has been removed from the -mm tree.  Its filename was
     drivers-misc-pch_phubc-fix-register-miss-setting-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/pch_phub.c: fix register miss-setting issue
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Register "interrupt delay value" is for GbE which is connected to Bus-m of
PCIe.  However currently, the value is set for Bus-n.  As a result, the
value is not set correctly.  This patch moves setting the value processing
of Bus-n to Bus-m.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/pch_phub.c~drivers-misc-pch_phubc-fix-register-miss-setting-issue drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~drivers-misc-pch_phubc-fix-register-miss-setting-issue
+++ a/drivers/misc/pch_phub.c
@@ -735,6 +735,8 @@ static int __devinit pch_phub_probe(stru
 		 * Device8(GbE)
 		 */
 		iowrite32(0x000a0000, chip->pch_phub_base_address + 0x14);
+		/* set the interrupt delay value */
+		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
@@ -752,8 +754,6 @@ static int __devinit pch_phub_probe(stru
 		 * Device6(SATA 2):f
 		 */
 		iowrite32(0x0000ffa0, chip->pch_phub_base_address + 0x14);
-		/* set the interrupt delay value */
-		iowrite32(0x25, chip->pch_phub_base_address + 0x140);
 		chip->pch_opt_rom_start_address =\
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
_

Patches currently in -mm which might be from tomoya-linux@dsn.okisemi.com are

linux-next.patch
drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch

