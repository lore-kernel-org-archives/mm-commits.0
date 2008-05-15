From: akpm@linux-foundation.org
Subject: + mtd-mtdcharc-remove-shadowed-variable-warnings.patch added to -mm tree
Date: Thu, 15 May 2008 16:39:45 -0700
Message-ID: <200805152339.m4FNdjbq016388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446AbYEOXkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: mtdchar.c remove shadowed variable warnings
has been added to the -mm tree.  Its filename is
     mtd-mtdcharc-remove-shadowed-variable-warnings.patch

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
@@ -579,29 +579,29 @@ static int mtd_ioctl(struct inode *inode
 
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
 
@@ -701,15 +701,15 @@ static int mtd_ioctl(struct inode *inode
 
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

