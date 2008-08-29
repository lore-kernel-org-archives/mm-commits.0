From: akpm@linux-foundation.org
Subject: - e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch removed from -mm tree
Date: Thu, 28 Aug 2008 17:51:56 -0700
Message-ID: <200808290051.m7T0puR4023172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYH2Aw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com, mm-commi


The patch titled
     e1000e: avoid duplicated output of device name in kernel warning
has been removed from the -mm tree.  Its filename was
     e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: avoid duplicated output of device name in kernel warning
From: Frans Pop <elendil@planet.nl>

With 2.6.27-rc3 I noticed the following messages in my boot log:

0000:01:00.0: 0000:01:00.0: Warning: detected DSPD enabled in EEPROM
0000:01:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:04:ff:09

The second seems correct, but the first has a silly repetition of the
PCI device before the actual message. The message originates from
e1000_eeprom_checks in e1000e/netdev.c.

With this patch below the first message becomes

  e1000e 0000:01:00.0: Warning: detected DSPD enabled in EEPROM

which makes it similar to directly preceding messages.

Use dev_warn instead of e_warn in e1000_eeprom_checks() as the interface
name has not yet been assigned at that point.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning
+++ a/drivers/net/e1000e/netdev.c
@@ -4649,13 +4649,15 @@ static void e1000_eeprom_checks(struct e
 	ret_val = e1000_read_nvm(hw, NVM_INIT_CONTROL2_REG, 1, &buf);
 	if (!(le16_to_cpu(buf) & (1 << 0))) {
 		/* Deep Smart Power Down (DSPD) */
-		e_warn("Warning: detected DSPD enabled in EEPROM\n");
+		dev_warn(&adapter->pdev->dev,
+			 "Warning: detected DSPD enabled in EEPROM\n");
 	}
 
 	ret_val = e1000_read_nvm(hw, NVM_INIT_3GIO_3, 1, &buf);
 	if (le16_to_cpu(buf) & (3 << 2)) {
 		/* ASPM enable */
-		e_warn("Warning: detected ASPM enabled in EEPROM\n");
+		dev_warn(&adapter->pdev->dev,
+			 "Warning: detected ASPM enabled in EEPROM\n");
 	}
 }
 
_

Patches currently in -mm which might be from elendil@planet.nl are

e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch

