From: akpm@linux-foundation.org
Subject: - drivers-block-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:11 -0700
Message-ID: <200804300549.m3U5nBFR029975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758811AbYD3Ftz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ecashin@coraid.com, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/block: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     drivers-block-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ed L. Cashin <ecashin@coraid.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   24 ++++++++++++------------
 drivers/block/aoe/aoenet.c |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~drivers-block-use-get_unaligned_-helpers drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~drivers-block-use-get_unaligned_-helpers
+++ a/drivers/block/aoe/aoecmd.c
@@ -668,16 +668,16 @@ ataid_complete(struct aoedev *d, struct 
 	u16 n;
 
 	/* word 83: command set supported */
-	n = le16_to_cpu(get_unaligned((__le16 *) &id[83<<1]));
+	n = get_unaligned_le16(&id[83 << 1]);
 
 	/* word 86: command set/feature enabled */
-	n |= le16_to_cpu(get_unaligned((__le16 *) &id[86<<1]));
+	n |= get_unaligned_le16(&id[86 << 1]);
 
 	if (n & (1<<10)) {	/* bit 10: LBA 48 */
 		d->flags |= DEVFL_EXT;
 
 		/* word 100: number lba48 sectors */
-		ssize = le64_to_cpu(get_unaligned((__le64 *) &id[100<<1]));
+		ssize = get_unaligned_le64(&id[100 << 1]);
 
 		/* set as in ide-disk.c:init_idedisk_capacity */
 		d->geo.cylinders = ssize;
@@ -688,12 +688,12 @@ ataid_complete(struct aoedev *d, struct 
 		d->flags &= ~DEVFL_EXT;
 
 		/* number lba28 sectors */
-		ssize = le32_to_cpu(get_unaligned((__le32 *) &id[60<<1]));
+		ssize = get_unaligned_le32(&id[60 << 1]);
 
 		/* NOTE: obsolete in ATA 6 */
-		d->geo.cylinders = le16_to_cpu(get_unaligned((__le16 *) &id[54<<1]));
-		d->geo.heads = le16_to_cpu(get_unaligned((__le16 *) &id[55<<1]));
-		d->geo.sectors = le16_to_cpu(get_unaligned((__le16 *) &id[56<<1]));
+		d->geo.cylinders = get_unaligned_le16(&id[54 << 1]);
+		d->geo.heads = get_unaligned_le16(&id[55 << 1]);
+		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
 	}
 
 	if (d->ssize != ssize)
@@ -779,7 +779,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	u16 aoemajor;
 
 	hin = (struct aoe_hdr *) skb_mac_header(skb);
-	aoemajor = be16_to_cpu(get_unaligned(&hin->major));
+	aoemajor = get_unaligned_be16(&hin->major);
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
@@ -791,7 +791,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	n = be32_to_cpu(get_unaligned(&hin->tag));
+	n = get_unaligned_be32(&hin->tag);
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
@@ -806,9 +806,9 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
-			be16_to_cpu(get_unaligned(&hin->major)),
+			get_unaligned_be16(&hin->major),
 			hin->minor,
-			be32_to_cpu(get_unaligned(&hin->tag)),
+			get_unaligned_be32(&hin->tag),
 			jiffies);
 		aoechr_error(ebuf);
 		return;
@@ -873,7 +873,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
 				ahout->cmdstat,
-				be16_to_cpu(get_unaligned(&hin->major)),
+				get_unaligned_be16(&hin->major),
 				hin->minor);
 		}
 	}
diff -puN drivers/block/aoe/aoenet.c~drivers-block-use-get_unaligned_-helpers drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~drivers-block-use-get_unaligned_-helpers
+++ a/drivers/block/aoe/aoenet.c
@@ -128,7 +128,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	n = be32_to_cpu(get_unaligned(&h->tag));
+	n = get_unaligned_be32(&h->tag);
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
 
@@ -140,7 +140,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 			printk(KERN_ERR
 				"%s%d.%d@%s; ecode=%d '%s'\n",
 				"aoe: error packet from ",
-				be16_to_cpu(get_unaligned(&h->major)),
+				get_unaligned_be16(&h->major),
 				h->minor, skb->dev->name,
 				h->err, aoe_errlist[n]);
 		goto exit;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

