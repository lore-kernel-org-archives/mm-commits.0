From: akpm@linux-foundation.org
Subject: + e1000e-prevent-corruption-of-eeprom-nvm.patch added to -mm tree
Date: Tue, 02 Sep 2008 12:19:58 -0700
Message-ID: <200809021919.m82JJweC008488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbYIBTUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 15:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisl@vmware.com, arvidjaar@mail.ru, bruce.w.allan@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com, pratap@vmware.com, zach@vmware.com


The patch titled
     e1000e: prevent corruption of EEPROM/NVM
has been added to the -mm tree.  Its filename is
     e1000e-prevent-corruption-of-eeprom-nvm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: prevent corruption of EEPROM/NVM
From: Christopher Li <chrisl@vmware.com>

Andrey reports e1000e corruption, and that a patch in vmware's ESX fixed
it.

The EEPROM corruption is triggered by concurrent access of the EEPROM
read/write. Putting a lock around it solve the problem.

Signed-off-by: Christopher Li <chrisl@vmware.com>
Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Zach Amsden <zach@vmware.com>
Cc: Pratap Subrahmanyam <pratap@vmware.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_hw.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/net/e1000/e1000_hw.c~e1000e-prevent-corruption-of-eeprom-nvm drivers/net/e1000/e1000_hw.c
--- a/drivers/net/e1000/e1000_hw.c~e1000e-prevent-corruption-of-eeprom-nvm
+++ a/drivers/net/e1000/e1000_hw.c
@@ -144,6 +144,8 @@ static s32 e1000_host_if_read_cookie(str
 static u8 e1000_calculate_mng_checksum(char *buffer, u32 length);
 static s32 e1000_configure_kmrn_for_10_100(struct e1000_hw *hw, u16 duplex);
 static s32 e1000_configure_kmrn_for_1000(struct e1000_hw *hw);
+static s32 e1000_do_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
+static s32 e1000_do_write_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
 
 /* IGP cable length table */
 static const
@@ -168,6 +170,8 @@ u16 e1000_igp_2_cable_length_table[IGP02
       83, 89, 95, 100, 105, 109, 113, 116, 119, 122, 124,
       104, 109, 114, 118, 121, 124};
 
+static spinlock_t e1000_eeprom_lock = SPIN_LOCK_UNLOCKED;
+
 /******************************************************************************
  * Set the phy type member in the hw struct.
  *
@@ -4904,6 +4908,15 @@ static s32 e1000_spi_eeprom_ready(struct
  *****************************************************************************/
 s32 e1000_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
 {
+    s32 ret;
+    spin_lock(&e1000_eeprom_lock);
+    ret = e1000_do_read_eeprom(hw, offset, words, data);
+    spin_unlock(&e1000_eeprom_lock);
+    return ret;
+}
+
+static s32 e1000_do_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
+{
     struct e1000_eeprom_info *eeprom = &hw->eeprom;
     u32 i = 0;
 
@@ -5236,6 +5249,16 @@ s32 e1000_update_eeprom_checksum(struct 
  *****************************************************************************/
 s32 e1000_write_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
 {
+    s32 ret;
+    spin_lock(&e1000_eeprom_lock);
+    ret = e1000_do_write_eeprom(hw, offset, words, data);
+    spin_unlock(&e1000_eeprom_lock);
+    return ret;
+}
+
+
+static s32 e1000_do_write_eeprom(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
+{
     struct e1000_eeprom_info *eeprom = &hw->eeprom;
     s32 status = 0;
 
_

Patches currently in -mm which might be from chrisl@vmware.com are

e1000e-prevent-corruption-of-eeprom-nvm.patch

