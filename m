From: akpm@linux-foundation.org
Subject: + misdn-endian-annotations-for-struct-zt.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:14:26 -0700
Message-ID: <200808120014.m7C0EQkR029640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYHLAPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, kkeil@suse.de


The patch titled
     mISDN: endian annotations for struct zt
has been added to the -mm tree.  Its filename is
     misdn-endian-annotations-for-struct-zt.patch

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
Subject: mISDN: endian annotations for struct zt
From: Harvey Harrison <harvey.harrison@gmail.com>

Found two possible bugs where the z1 value was used directly without
byteswapping.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfc_pci.h |    4 ++--
 drivers/isdn/hardware/mISDN/hfcpci.c  |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/isdn/hardware/mISDN/hfc_pci.h~misdn-endian-annotations-for-struct-zt drivers/isdn/hardware/mISDN/hfc_pci.h
--- a/drivers/isdn/hardware/mISDN/hfc_pci.h~misdn-endian-annotations-for-struct-zt
+++ a/drivers/isdn/hardware/mISDN/hfc_pci.h
@@ -183,8 +183,8 @@
 #define D_FREG_MASK  0xF
 
 struct zt {
-	unsigned short z1;  /* Z1 pointer 16 Bit */
-	unsigned short z2;  /* Z2 pointer 16 Bit */
+	__le16 z1;  /* Z1 pointer 16 Bit */
+	__le16 z2;  /* Z2 pointer 16 Bit */
 };
 
 struct dfifo {
diff -puN drivers/isdn/hardware/mISDN/hfcpci.c~misdn-endian-annotations-for-struct-zt drivers/isdn/hardware/mISDN/hfcpci.c
--- a/drivers/isdn/hardware/mISDN/hfcpci.c~misdn-endian-annotations-for-struct-zt
+++ a/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -366,8 +366,7 @@ static void hfcpci_clear_fifo_tx(struct 
 	bzt->f2 = MAX_B_FRAMES;
 	bzt->f1 = bzt->f2;	/* init F pointers to remain constant */
 	bzt->za[MAX_B_FRAMES].z1 = cpu_to_le16(B_FIFO_SIZE + B_SUB_VAL - 1);
-	bzt->za[MAX_B_FRAMES].z2 = cpu_to_le16(
-	    le16_to_cpu(bzt->za[MAX_B_FRAMES].z1 - 1));
+	bzt->za[MAX_B_FRAMES].z2 = cpu_to_le16(B_FIFO_SIZE + B_SUB_VAL - 2);
 	if (fifo_state)
 		hc->hw.fifo_en |= fifo_state;
 	Write_hfc(hc, HFCPCI_FIFO_EN, hc->hw.fifo_en);
@@ -482,7 +481,7 @@ receive_dmsg(struct hfc_pci *hc)
 			df->f2 = ((df->f2 + 1) & MAX_D_FRAMES) |
 			    (MAX_D_FRAMES + 1);	/* next buffer */
 			df->za[df->f2 & D_FREG_MASK].z2 =
-			    cpu_to_le16((zp->z2 + rcnt) & (D_FIFO_SIZE - 1));
+			    cpu_to_le16((le16_to_cpu(zp->z2) + rcnt) & (D_FIFO_SIZE - 1));
 		} else {
 			dch->rx_skb = mI_alloc_skb(rcnt - 3, GFP_ATOMIC);
 			if (!dch->rx_skb) {
@@ -526,7 +525,7 @@ receive_dmsg(struct hfc_pci *hc)
 int
 hfcpci_empty_fifo_trans(struct bchannel *bch, struct bzfifo *bz, u_char *bdata)
 {
-	unsigned short	*z1r, *z2r;
+	 __le16 *z1r, *z2r;
 	int		new_z2, fcnt, maxlen;
 	u_char		*ptr, *ptr1;
 
@@ -724,7 +723,7 @@ hfcpci_fill_fifo(struct bchannel *bch)
 	struct bzfifo	*bz;
 	u_char		*bdata;
 	u_char		new_f1, *src, *dst;
-	unsigned short	*z1t, *z2t;
+	__le16 *z1t, *z2t;
 
 	if ((bch->debug & DEBUG_HW_BCHANNEL) && !(bch->debug & DEBUG_HW_BFIFO))
 		printk(KERN_DEBUG "%s\n", __func__);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch

