From: akpm@linux-foundation.org
Subject: + drivers-block-use-get_unaligned_-helpers.patch added to -mm tree
Date: Tue, 15 Apr 2008 15:22:02 -0700
Message-ID: <200804152222.m3FMM2hj018781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757832AbYDOWXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, ecashin@coraid.com, jens.axboe@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     drivers/block: use get_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     drivers-block-use-get_unaligned_-helpers.patch

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

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-libata-all.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
input-replace-remaining-__function__-occurrences.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
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
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
radio-use-get-put_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

