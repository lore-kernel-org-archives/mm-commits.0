From: akpm@linux-foundation.org
Subject: - mtd-mtdcharc-silence-sparse-warning.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:35 -0700
Message-ID: <200807141935.m6EJZZNY023932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbYGNTfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: mtdchar.c silence sparse warning
has been removed from the -mm tree.  Its filename was
     mtd-mtdcharc-silence-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -492,6 +492,7 @@ static int mtd_ioctl(struct inode *inode
 	{
 		struct mtd_oob_buf buf;
 		struct mtd_oob_ops ops;
+		struct mtd_oob_buf __user *user_buf = argp;
 	        uint32_t retlen;
 
 		if(!(file->f_mode & 2))
@@ -535,8 +536,7 @@ static int mtd_ioctl(struct inode *inode
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

linux-next.patch
cifs-remove-global_extern-macro.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

