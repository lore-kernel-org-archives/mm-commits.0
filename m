From: akpm@linux-foundation.org
Subject: + input-use-get_unaligned_-helpers.patch added to -mm tree
Date: Tue, 15 Apr 2008 15:22:08 -0700
Message-ID: <200804152222.m3FMM8Yf018790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbYDOWWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dtor@mail.ru, jirislaby@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     input: use get_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     input-use-get_unaligned_-helpers.patch

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
Subject: input: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/tablet/aiptek.c |   16 ++++++++--------
 drivers/input/tablet/gtco.c   |   14 +++++++-------
 drivers/input/tablet/kbtab.c  |    4 ++--
 3 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/input/tablet/aiptek.c~input-use-get_unaligned_-helpers drivers/input/tablet/aiptek.c
--- a/drivers/input/tablet/aiptek.c~input-use-get_unaligned_-helpers
+++ a/drivers/input/tablet/aiptek.c
@@ -528,9 +528,9 @@ static void aiptek_irq(struct urb *urb)
 			    (aiptek->curSetting.pointerMode)) {
 				aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
-			x = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
-			y = le16_to_cpu(get_unaligned((__le16 *) (data + 3)));
-			z = le16_to_cpu(get_unaligned((__le16 *) (data + 6)));
+			x = get_unaligned_le16(data + 1);
+			y = get_unaligned_le16(data + 3);
+			z = get_unaligned_le16(data + 6);
 
 			dv = (data[5] & 0x01) != 0 ? 1 : 0;
 			p = (data[5] & 0x02) != 0 ? 1 : 0;
@@ -613,8 +613,8 @@ static void aiptek_irq(struct urb *urb)
 			(aiptek->curSetting.pointerMode)) {
 			aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
-			x = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
-			y = le16_to_cpu(get_unaligned((__le16 *) (data + 3)));
+			x = get_unaligned_le16(data + 1);
+			y = get_unaligned_le16(data + 3);
 
 			jitterable = data[5] & 0x1c;
 
@@ -679,7 +679,7 @@ static void aiptek_irq(struct urb *urb)
 		pck = (data[1] & aiptek->curSetting.stylusButtonUpper) != 0 ? 1 : 0;
 
 		macro = dv && p && tip && !(data[3] & 1) ? (data[3] >> 1) : -1;
-		z = le16_to_cpu(get_unaligned((__le16 *) (data + 4)));
+		z = get_unaligned_le16(data + 4);
 
 		if (dv) {
 		        /* If the selected tool changed, reset the old
@@ -757,7 +757,7 @@ static void aiptek_irq(struct urb *urb)
 	 * hat switches (which just so happen to be the macroKeys.)
 	 */
 	else if (data[0] == 6) {
-		macro = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
+		macro = get_unaligned_le16(data + 1);
 		if (macro > 0) {
 			input_report_key(inputdev, macroKeyEvents[macro - 1],
 					 0);
@@ -952,7 +952,7 @@ aiptek_query(struct aiptek *aiptek, unsi
 		    buf[0], buf[1], buf[2]);
 		ret = -EIO;
 	} else {
-		ret = le16_to_cpu(get_unaligned((__le16 *) (buf + 1)));
+		ret = get_unaligned_le16(buf + 1);
 	}
 	kfree(buf);
 	return ret;
diff -puN drivers/input/tablet/gtco.c~input-use-get_unaligned_-helpers drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c~input-use-get_unaligned_-helpers
+++ a/drivers/input/tablet/gtco.c
@@ -245,11 +245,11 @@ static void parse_hid_report_descriptor(
 			data = report[i];
 			break;
 		case 2:
-			data16 = le16_to_cpu(get_unaligned((__le16 *)&report[i]));
+			data16 = get_unaligned_le16(&report[i]);
 			break;
 		case 3:
 			size = 4;
-			data32 = le32_to_cpu(get_unaligned((__le32 *)&report[i]));
+			data32 = get_unaligned_le32(&report[i]);
 			break;
 		}
 
@@ -695,10 +695,10 @@ static void gtco_urb_callback(struct urb
 			/*  Fall thru */
 		case 1:
 			/* All reports have X and Y coords in the same place */
-			val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[1]));
+			val = get_unaligned_le16(&device->buffer[1]);
 			input_report_abs(inputdev, ABS_X, val);
 
-			val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[3]));
+			val = get_unaligned_le16(&device->buffer[3]);
 			input_report_abs(inputdev, ABS_Y, val);
 
 			/* Ditto for proximity bit */
@@ -762,7 +762,7 @@ static void gtco_urb_callback(struct urb
 				le_buffer[1]  = (u8)(device->buffer[4] >> 1);
 				le_buffer[1] |= (u8)((device->buffer[5] & 0x1) << 7);
 
-				val = le16_to_cpu(get_unaligned((__le16 *)le_buffer));
+				val = get_unaligned_le16(le_buffer);
 				input_report_abs(inputdev, ABS_Y, val);
 
 				/*
@@ -772,10 +772,10 @@ static void gtco_urb_callback(struct urb
 				buttonbyte = device->buffer[5] >> 1;
 			} else {
 
-				val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[1]));
+				val = get_unaligned_le16(&device->buffer[1]);
 				input_report_abs(inputdev, ABS_X, val);
 
-				val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[3]));
+				val = get_unaligned_le16(&device->buffer[3]);
 				input_report_abs(inputdev, ABS_Y, val);
 
 				buttonbyte = device->buffer[5];
diff -puN drivers/input/tablet/kbtab.c~input-use-get_unaligned_-helpers drivers/input/tablet/kbtab.c
--- a/drivers/input/tablet/kbtab.c~input-use-get_unaligned_-helpers
+++ a/drivers/input/tablet/kbtab.c
@@ -63,8 +63,8 @@ static void kbtab_irq(struct urb *urb)
 		goto exit;
 	}
 
-	kbtab->x = le16_to_cpu(get_unaligned((__le16 *) &data[1]));
-	kbtab->y = le16_to_cpu(get_unaligned((__le16 *) &data[3]));
+	kbtab->x = get_unaligned_le16(&data[1]);
+	kbtab->y = get_unaligned_le16(&data[3]);
 
 	kbtab->pressure = (data[5]);
 
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

