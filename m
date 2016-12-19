From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 14:27:19 -0800
Message-ID: <58585ec7.d0q5UUXO3VlOkLRZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43962 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSW0T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overwritting" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "overwritting" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  overwritting||overwriting

Link: http://lkml.kernel.org/r/1481573103-11329-29-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/lib/copy_template.S             |    2 +-
 drivers/net/ethernet/adi/bfin_mac.c        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h         |    2 +-
 drivers/usb/usbip/usbip_common.c           |    2 +-
 scripts/spelling.txt                       |    1 +
 7 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/arm64/lib/copy_template.S~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances arch/arm64/lib/copy_template.S
--- a/arch/arm64/lib/copy_template.S~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/arch/arm64/lib/copy_template.S
@@ -62,7 +62,7 @@ D_h	.req	x14
 	sub	count, count, tmp2
 	/*
 	* Copy the leading memory data from src to dst in an increasing
-	* address order.By this way,the risk of overwritting the source
+	* address order.By this way,the risk of overwriting the source
 	* memory data is eliminated when the distance between src and
 	* dst is less than 16. The memory accesses here are alignment.
 	*/
diff -puN drivers/net/ethernet/adi/bfin_mac.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances drivers/net/ethernet/adi/bfin_mac.c
--- a/drivers/net/ethernet/adi/bfin_mac.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/adi/bfin_mac.c
@@ -1206,7 +1206,7 @@ static void bfin_mac_rx(struct bfin_mac_
 	/* reserve 2 bytes for RXDWA padding */
 	skb_reserve(new_skb, NET_IP_ALIGN);
 	/* Invalidate the data cache of skb->data range when it is write back
-	 * cache. It will prevent overwritting the new data from DMA
+	 * cache. It will prevent overwriting the new data from DMA
 	 */
 	blackfin_dcache_invalidate_range((unsigned long)new_skb->head,
 					 (unsigned long)new_skb->end);
diff -puN drivers/net/ethernet/intel/igb/e1000_phy.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances drivers/net/ethernet/intel/igb/e1000_phy.c
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -290,7 +290,7 @@ s32 igb_write_phy_reg_i2c(struct e1000_h
 	u32 i, i2ccmd = 0;
 	u16 phy_data_swapped;
 
-	/* Prevent overwritting SFP I2C EEPROM which is at A0 address.*/
+	/* Prevent overwriting SFP I2C EEPROM which is at A0 address.*/
 	if ((hw->phy.addr == 0) || (hw->phy.addr > 7)) {
 		hw_dbg("PHY I2C Address %d is out of range.\n",
 			  hw->phy.addr);
diff -puN drivers/scsi/mpt3sas/mpt3sas_ctl.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances drivers/scsi/mpt3sas/mpt3sas_ctl.c
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1923,7 +1923,7 @@ mpt3sas_send_diag_release(struct MPT3SAS
  *
  * This allows ownership of the specified buffer to returned to the driver,
  * allowing an application to read the buffer without fear that firmware is
- * overwritting information in the buffer.
+ * overwriting information in the buffer.
  */
 static long
 _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
diff -puN drivers/scsi/mpt3sas/mpt3sas_ctl.h~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances drivers/scsi/mpt3sas/mpt3sas_ctl.h
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -390,7 +390,7 @@ struct mpt3_diag_query {
  *
  * This allows ownership of the specified buffer to returned to the driver,
  * allowing an application to read the buffer without fear that firmware is
- * overwritting information in the buffer.
+ * overwriting information in the buffer.
  */
 struct mpt3_diag_release {
 	struct mpt3_ioctl_header hdr;
diff -puN drivers/usb/usbip/usbip_common.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances drivers/usb/usbip/usbip_common.c
--- a/drivers/usb/usbip/usbip_common.c~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/drivers/usb/usbip/usbip_common.c
@@ -707,7 +707,7 @@ void usbip_pad_iso(struct usbip_device *
 		return;
 
 	/*
-	 * loop over all packets from last to first (to prevent overwritting
+	 * loop over all packets from last to first (to prevent overwriting
 	 * memory when padding) and move them into the proper place
 	 */
 	for (i = np-1; i > 0; i--) {
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -739,6 +739,7 @@ overide||override
 overrided||overridden
 overriden||overridden
 overun||overrun
+overwritting||overwriting
 pacakge||package
 pachage||package
 packacge||package
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

