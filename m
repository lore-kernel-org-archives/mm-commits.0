From: akpm@linux-foundation.org
Subject: - block-aoe-switch-to-the-new-endian-helpers.patch removed from -mm tree
Date: Fri, 28 Nov 2008 22:14:18 -0800
Message-ID: <200811290614.mAT6EISs014023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbYK2GOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 01:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ecashin@coraid.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: aoe switch to the new endian helpers
has been removed from the -mm tree.  Its filename was
     block-aoe-switch-to-the-new-endian-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: aoe switch to the new endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Add the necesary casts now that the unaligned helpers are typesafe and
switch to load_* where possible as it is more efficient.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   30 +++++++++++++++---------------
 drivers/block/aoe/aoenet.c |    4 ++--
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~block-aoe-switch-to-the-new-endian-helpers drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~block-aoe-switch-to-the-new-endian-helpers
+++ a/drivers/block/aoe/aoecmd.c
@@ -642,16 +642,16 @@ ataid_complete(struct aoedev *d, struct 
 	u16 n;
 
 	/* word 83: command set supported */
-	n = get_unaligned_le16(&id[83 << 1]);
+	n = load_le16_noalign((__le16 *)&id[83 << 1]);
 
 	/* word 86: command set/feature enabled */
-	n |= get_unaligned_le16(&id[86 << 1]);
+	n |= load_le16_noalign((__le16 *)&id[86 << 1]);
 
 	if (n & (1<<10)) {	/* bit 10: LBA 48 */
 		d->flags |= DEVFL_EXT;
 
 		/* word 100: number lba48 sectors */
-		ssize = get_unaligned_le64(&id[100 << 1]);
+		ssize = load_le16_noalign((__le16 *)&id[100 << 1]);
 
 		/* set as in ide-disk.c:init_idedisk_capacity */
 		d->geo.cylinders = ssize;
@@ -662,12 +662,12 @@ ataid_complete(struct aoedev *d, struct 
 		d->flags &= ~DEVFL_EXT;
 
 		/* number lba28 sectors */
-		ssize = get_unaligned_le32(&id[60 << 1]);
+		ssize = load_le32_noalign((__le32 *)&id[60 << 1]);
 
 		/* NOTE: obsolete in ATA 6 */
-		d->geo.cylinders = get_unaligned_le16(&id[54 << 1]);
-		d->geo.heads = get_unaligned_le16(&id[55 << 1]);
-		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
+		d->geo.cylinders = load_le16_noalign((__le16 *)&id[54 << 1]);
+		d->geo.heads = load_le16_noalign((__le16 *)&id[55 << 1]);
+		d->geo.sectors = load_le16_noalign((__le16 *)&id[56 << 1]);
 	}
 
 	if (d->ssize != ssize)
@@ -760,7 +760,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	u16 aoemajor;
 
 	hin = (struct aoe_hdr *) skb_mac_header(skb);
-	aoemajor = get_unaligned_be16(&hin->major);
+	aoemajor = load_be16_noalign(&hin->major);
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
@@ -772,7 +772,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	n = get_unaligned_be32(&hin->tag);
+	n = load_be32_noalign(&hin->tag);
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
@@ -787,9 +787,9 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
-			get_unaligned_be16(&hin->major),
+			load_be16_noalign(&hin->major),
 			hin->minor,
-			get_unaligned_be32(&hin->tag),
+			load_be32_noalign(&hin->tag),
 			jiffies);
 		aoechr_error(ebuf);
 		return;
@@ -854,7 +854,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
 				ahout->cmdstat,
-				get_unaligned_be16(&hin->major),
+				load_be16_noalign(&hin->major),
 				hin->minor);
 		}
 	}
@@ -982,7 +982,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	 * Enough people have their dip switches set backwards to
 	 * warrant a loud message for this special case.
 	 */
-	aoemajor = get_unaligned_be16(&h->major);
+	aoemajor = load_be16_noalign(&h->major);
 	if (aoemajor == 0xfff) {
 		printk(KERN_ERR "aoe: Warning: shelf address is all ones.  "
 			"Check shelf dip switches.\n");
@@ -996,7 +996,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		return;
 	}
 
-	n = be16_to_cpu(ch->bufcnt);
+	n = load_be16(&ch->bufcnt);
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
@@ -1049,7 +1049,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
-	d->fw_ver = be16_to_cpu(ch->fwver);
+	d->fw_ver = load_be16(&ch->fwver);
 
 	sl = aoecmd_ata_id(d);
 
diff -puN drivers/block/aoe/aoenet.c~block-aoe-switch-to-the-new-endian-helpers drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~block-aoe-switch-to-the-new-endian-helpers
+++ a/drivers/block/aoe/aoenet.c
@@ -127,7 +127,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	n = get_unaligned_be32(&h->tag);
+	n = load_be32_noalign(&h->tag);
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
 
@@ -139,7 +139,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 			printk(KERN_ERR
 				"%s%d.%d@%s; ecode=%d '%s'\n",
 				"aoe: error packet from ",
-				get_unaligned_be16(&h->major),
+				load_be16_noalign(&h->major),
 				h->minor, skb->dev->name,
 				h->err, aoe_errlist[n]);
 		goto exit;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
unaligned-introduce-common-header.patch
unaligned-introduce-common-header-fix.patch
unaligned-introduce-common-header-fix-2.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch
block-aoe-switch-to-the-new-endian-helpers.patch

