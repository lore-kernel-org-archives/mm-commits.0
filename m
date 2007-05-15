From: akpm@linux-foundation.org
Subject: + pci-x-pci-express-read-control-interfaces-e1000.patch added to -mm tree
Date: Tue, 15 May 2007 12:38:48 -0700
Message-ID: <200705151938.l4FJcmWa015923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762444AbXEOTjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oruba@amd.com, auke-jan.h.kok@intel.com, jeff@garzik.org, shemminger@linux-foundation.org


The patch titled
     PCI-X/PCI-Express read control interfaces: use them in e1000
has been added to the -mm tree.  Its filename is
     pci-x-pci-express-read-control-interfaces-e1000.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI-X/PCI-Express read control interfaces: use them in e1000
From: "Peter Oruba" <peter.oruba@amd.com>

These driver changes incorporate the proposed PCI-X / PCI-Express read byte
count interface.  Reading and setting those valuse doesn't take place
"manually", instead wrapping functions are called to allow quirks for some
PCI bridges.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on work by Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_hw.c   |   25 +++----------------------
 drivers/net/e1000/e1000_hw.h   |    2 ++
 drivers/net/e1000/e1000_main.c |   14 ++++++++++++++
 3 files changed, 19 insertions(+), 22 deletions(-)

diff -puN drivers/net/e1000/e1000_hw.c~pci-x-pci-express-read-control-interfaces-e1000 drivers/net/e1000/e1000_hw.c
--- a/drivers/net/e1000/e1000_hw.c~pci-x-pci-express-read-control-interfaces-e1000
+++ a/drivers/net/e1000/e1000_hw.c
@@ -865,10 +865,6 @@ e1000_init_hw(struct e1000_hw *hw)
     uint32_t ctrl;
     uint32_t i;
     int32_t ret_val;
-    uint16_t pcix_cmd_word;
-    uint16_t pcix_stat_hi_word;
-    uint16_t cmd_mmrbc;
-    uint16_t stat_mmrbc;
     uint32_t mta_size;
     uint32_t reg_data;
     uint32_t ctrl_ext;
@@ -958,24 +954,9 @@ e1000_init_hw(struct e1000_hw *hw)
         break;
     default:
         /* Workaround for PCI-X problem when BIOS sets MMRBC incorrectly. */
-        if (hw->bus_type == e1000_bus_type_pcix) {
-            e1000_read_pci_cfg(hw, PCIX_COMMAND_REGISTER, &pcix_cmd_word);
-            e1000_read_pci_cfg(hw, PCIX_STATUS_REGISTER_HI,
-                &pcix_stat_hi_word);
-            cmd_mmrbc = (pcix_cmd_word & PCIX_COMMAND_MMRBC_MASK) >>
-                PCIX_COMMAND_MMRBC_SHIFT;
-            stat_mmrbc = (pcix_stat_hi_word & PCIX_STATUS_HI_MMRBC_MASK) >>
-                PCIX_STATUS_HI_MMRBC_SHIFT;
-            if (stat_mmrbc == PCIX_STATUS_HI_MMRBC_4K)
-                stat_mmrbc = PCIX_STATUS_HI_MMRBC_2K;
-            if (cmd_mmrbc > stat_mmrbc) {
-                pcix_cmd_word &= ~PCIX_COMMAND_MMRBC_MASK;
-                pcix_cmd_word |= stat_mmrbc << PCIX_COMMAND_MMRBC_SHIFT;
-                e1000_write_pci_cfg(hw, PCIX_COMMAND_REGISTER,
-                    &pcix_cmd_word);
-            }
-        }
-        break;
+	if (hw->bus_type == e1000_bus_type_pcix && e1000_pcix_get_mmrbc(hw) > 2048)
+		e1000_pcix_set_mmrbc(hw, 2048);
+	break;
     }
 
     /* More time needed for PHY to initialize */
diff -puN drivers/net/e1000/e1000_hw.h~pci-x-pci-express-read-control-interfaces-e1000 drivers/net/e1000/e1000_hw.h
--- a/drivers/net/e1000/e1000_hw.h~pci-x-pci-express-read-control-interfaces-e1000
+++ a/drivers/net/e1000/e1000_hw.h
@@ -424,6 +424,8 @@ void e1000_pci_clear_mwi(struct e1000_hw
 void e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
 void e1000_write_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
 int32_t e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t *value);
+void e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc);
+int e1000_pcix_get_mmrbc(struct e1000_hw *hw);
 /* Port I/O is only supported on 82544 and newer */
 void e1000_io_write(struct e1000_hw *hw, unsigned long port, uint32_t value);
 int32_t e1000_disable_pciex_master(struct e1000_hw *hw);
diff -puN drivers/net/e1000/e1000_main.c~pci-x-pci-express-read-control-interfaces-e1000 drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~pci-x-pci-express-read-control-interfaces-e1000
+++ a/drivers/net/e1000/e1000_main.c
@@ -4912,6 +4912,20 @@ e1000_write_pci_cfg(struct e1000_hw *hw,
 	pci_write_config_word(adapter->pdev, reg, *value);
 }
 
+int
+e1000_pcix_get_mmrbc(struct e1000_hw *hw)
+{
+	struct e1000_adapter *adapter = hw->back;
+	return pcix_get_mmrbc(adapter->pdev);
+}
+
+void
+e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc)
+{
+	struct e1000_adapter *adapter = hw->back;
+	pcix_set_mmrbc(adapter->pdev, mmrbc);
+}
+
 int32_t
 e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t *value)
 {
_

Patches currently in -mm which might be from peter.oruba@amd.com are

pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces.patch
pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
