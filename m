From: akpm@linux-foundation.org
Subject: - e1000e-perform-basic-82573-eeprom-checks-for-known-issues.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:14 -0700
Message-ID: <200808082208.m78M8EUQ031227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761812AbYHHWIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: auke-jan.h.kok@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: perform basic 82573 EEPROM checks for known issues
has been removed from the -mm tree.  Its filename was
     e1000e-perform-basic-82573-eeprom-checks-for-known-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: perform basic 82573 EEPROM checks for known issues
From: Auke Kok <auke-jan.h.kok@intel.com>

82573 EEPROMs have been shipped out with known issues.  While most people
will never see the issues some people do and we know how to address them. 
Warn the user if we find one of these EEPROM issues.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/net/e1000e/netdev.c~e1000e-perform-basic-82573-eeprom-checks-for-known-issues drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-perform-basic-82573-eeprom-checks-for-known-issues
+++ a/drivers/net/e1000e/netdev.c
@@ -4177,6 +4177,28 @@ static void e1000_print_device_info(stru
 	       hw->mac.type, hw->phy.type, (pba_num >> 8), (pba_num & 0xff));
 }
 
+static void e1000_eeprom_checks(struct e1000_adapter *adapter)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	int ret_val;
+	u16 buf = 0;
+
+	if (hw->mac.type != e1000_82573)
+		return;
+
+	ret_val = e1000_read_nvm(hw, NVM_INIT_CONTROL2_REG, 1, &buf);
+	if (!(le16_to_cpu(buf) & (1 << 0))) {
+		/* Deep Smart Power Down (DSPD) */
+		e_warn("Warning: detected DSPD enabled in EEPROM\n");
+	}
+
+	ret_val = e1000_read_nvm(hw, NVM_INIT_3GIO_3, 1, &buf);
+	if (le16_to_cpu(buf) & (3 << 2)) {
+		/* ASPM enable */
+		e_warn("Warning: detected ASPM enabled in EEPROM\n");
+	}
+}
+
 /**
  * e1000e_is_need_ioport - determine if an adapter needs ioport resources or not
  * @pdev: PCI device information struct
@@ -4400,6 +4422,8 @@ static int __devinit e1000_probe(struct 
 		}
 	}
 
+	e1000_eeprom_checks(adapter);
+
 	/* copy the MAC address out of the NVM */
 	if (e1000e_read_mac_addr(&adapter->hw))
 		e_err("NVM Read Error while reading MAC address\n");
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch

