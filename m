From: akpm@linux-foundation.org
Subject: + mtd-mtdcharc-silence-sparse-warning.patch added to -mm tree
Date: Thu, 15 May 2008 16:39:43 -0700
Message-ID: <200805152339.m4FNdhuP016385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308AbYEOXkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: mtdchar.c silence sparse warning
has been added to the -mm tree.  Its filename is
     mtd-mtdcharc-silence-sparse-warning.patch

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
Subject: mtd: mtdchar.c silence sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>

The copy_to_user was casting away the address space to get the offset of
the length member.  Use offsetof() instead and add it to the void __user
*argp.

drivers/mtd/mtdchar.c:527:23: warning: cast removes address space of expression
drivers/mtd/mtdchar.c:527:23: warning: incorrect type in argument 1 (different address spaces)
drivers/mtd/mtdchar.c:527:23:    expected void [noderef] <asn:1>*to
drivers/mtd/mtdchar.c:527:23:    got unsigned int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/mtdchar.c~mtd-mtdcharc-silence-sparse-warning drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-mtdcharc-silence-sparse-warning
+++ a/drivers/mtd/mtdchar.c
@@ -481,6 +481,7 @@ static int mtd_ioctl(struct inode *inode
 	{
 		struct mtd_oob_buf buf;
 		struct mtd_oob_ops ops;
+		struct mtd_oob_buf __user *user_buf = argp;
 	        uint32_t retlen;
 
 		if(!(file->f_mode & 2))
@@ -524,8 +525,7 @@ static int mtd_ioctl(struct inode *inode
 		if (ops.oobretlen > 0xFFFFFFFFU)
 			ret = -EOVERFLOW;
 		retlen = ops.oobretlen;
-		if (copy_to_user(&((struct mtd_oob_buf *)argp)->length,
-				 &retlen, sizeof(buf.length)))
+		if (copy_to_user(&user_buf->length, &retlen, sizeof(buf.length)))
 			ret = -EFAULT;
 
 		kfree(ops.oobbuf);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
lib-create-common-ascii-hex-array.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one.patch
b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

