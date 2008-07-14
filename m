From: akpm@linux-foundation.org
Subject: - mtd-mtdcharc-remove-shadowed-variable-warnings.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:37 -0700
Message-ID: <200807141935.m6EJZbl6023936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053AbYGNTfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: mtdchar.c remove shadowed variable warnings
has been removed from the -mm tree.  Its filename was
     mtd-mtdcharc-remove-shadowed-variable-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: mtdchar.c remove shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Use einfo, oinfo for the inner erase_info and otp_info structs used in
individual case statements.

drivers/mtd/mtdchar.c:582:26: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here
drivers/mtd/mtdchar.c:596:26: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here
drivers/mtd/mtdchar.c:704:19: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/mtd/mtdchar.c~mtd-mtdcharc-remove-shadowed-variable-warnings drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-mtdcharc-remove-shadowed-variable-warnings
+++ a/drivers/mtd/mtdchar.c
@@ -590,29 +590,29 @@ static int mtd_ioctl(struct inode *inode
 
 	case MEMLOCK:
 	{
-		struct erase_info_user info;
+		struct erase_info_user einfo;
 
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&einfo, argp, sizeof(einfo)))
 			return -EFAULT;
 
 		if (!mtd->lock)
 			ret = -EOPNOTSUPP;
 		else
-			ret = mtd->lock(mtd, info.start, info.length);
+			ret = mtd->lock(mtd, einfo.start, einfo.length);
 		break;
 	}
 
 	case MEMUNLOCK:
 	{
-		struct erase_info_user info;
+		struct erase_info_user einfo;
 
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&einfo, argp, sizeof(einfo)))
 			return -EFAULT;
 
 		if (!mtd->unlock)
 			ret = -EOPNOTSUPP;
 		else
-			ret = mtd->unlock(mtd, info.start, info.length);
+			ret = mtd->unlock(mtd, einfo.start, einfo.length);
 		break;
 	}
 
@@ -712,15 +712,15 @@ static int mtd_ioctl(struct inode *inode
 
 	case OTPLOCK:
 	{
-		struct otp_info info;
+		struct otp_info oinfo;
 
 		if (mfi->mode != MTD_MODE_OTP_USER)
 			return -EINVAL;
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&oinfo, argp, sizeof(oinfo)))
 			return -EFAULT;
 		if (!mtd->lock_user_prot_reg)
 			return -EOPNOTSUPP;
-		ret = mtd->lock_user_prot_reg(mtd, info.start, info.length);
+		ret = mtd->lock_user_prot_reg(mtd, oinfo.start, oinfo.length);
 		break;
 	}
 #endif
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

