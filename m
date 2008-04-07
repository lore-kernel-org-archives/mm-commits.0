From: akpm@linux-foundation.org
Subject: + v4l-common-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:20:42 -0700
Message-ID: <200804072320.m37NKggu030195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbYDGXUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mchehab@infradead.org


The patch titled
     v4l: common/ replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     v4l-common-replace-remaining-__function__-occurences.patch

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
Subject: v4l: common/ replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/saa7146_core.c |    8 ++++----
 drivers/media/common/saa7146_i2c.c  |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/media/common/saa7146_core.c~v4l-common-replace-remaining-__function__-occurences drivers/media/common/saa7146_core.c
--- a/drivers/media/common/saa7146_core.c~v4l-common-replace-remaining-__function__-occurences
+++ a/drivers/media/common/saa7146_core.c
@@ -74,7 +74,7 @@ static inline int saa7146_wait_for_debi_
 		if (err) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -89,7 +89,7 @@ static inline int saa7146_wait_for_debi_
 		saa7146_read(dev, MC2);
 		if (err) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n",	dev->name, __FUNCTION__));
+				"completion\n",	dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -111,7 +111,7 @@ static inline int saa7146_wait_for_debi_
 		if (!loops--) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		udelay(1);
@@ -125,7 +125,7 @@ static inline int saa7146_wait_for_debi_
 		saa7146_read(dev, MC2);
 		if (!loops--) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n", dev->name, __FUNCTION__));
+				"completion\n", dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		udelay(5);
diff -puN drivers/media/common/saa7146_i2c.c~v4l-common-replace-remaining-__function__-occurences drivers/media/common/saa7146_i2c.c
--- a/drivers/media/common/saa7146_i2c.c~v4l-common-replace-remaining-__function__-occurences
+++ a/drivers/media/common/saa7146_i2c.c
@@ -203,7 +203,7 @@ static int saa7146_i2c_writeout(struct s
 				return -ERESTARTSYS;
 
 			printk(KERN_WARNING "%s %s [irq]: timed out waiting for end of xfer\n",
-				dev->name, __FUNCTION__);
+				dev->name, __func__);
 			return -EIO;
 		}
 		status = saa7146_read(dev, I2C_STATUS);
@@ -221,7 +221,7 @@ static int saa7146_i2c_writeout(struct s
 			}
 			if (time_after(jiffies,timeout)) {
 				printk(KERN_WARNING "%s %s: timed out waiting for MC2\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 				return -EIO;
 			}
 		}
@@ -238,7 +238,7 @@ static int saa7146_i2c_writeout(struct s
 				 * (no answer from nonexisistant device...)
 				 */
 				printk(KERN_WARNING "%s %s [poll]: timed out waiting for end of xfer\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 				return -EIO;
 			}
 			if (++trial < 50 && short_delay)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
v4l-common-replace-remaining-__function__-occurences.patch
v4l-dvb-replace-remaining-__function__-occurences.patch
v4l-video-replace-remaining-__function__-occurences.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
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
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
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
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

