From: akpm@linux-foundation.org
Subject: - mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch removed from -mm tree
Date: Fri, 18 Apr 2008 14:19:52 -0700
Message-ID: <200804182119.m3ILJqqI016667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbYDRVWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 17:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: tkip.c remove opencoded swab16 in tkip_S
has been removed from the -mm tree.  Its filename was
     mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tkip.c remove opencoded swab16 in tkip_S
From: Harvey Harrison <harvey.harrison@gmail.com>

Opencode the Hi8/Lo8 and eliminate the temporary variable in tkip_S().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-remove-opencoded-swab16-in-tkip_s net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-remove-opencoded-swab16-in-tkip_s
+++ a/net/mac80211/tkip.c
@@ -94,13 +94,9 @@ static inline u16 Lo16(u32 v)
 
 static inline u16 tkip_S(u16 val)
 {
-	u16 a = tkip_sbox[Hi8(val)];
-
-	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
+	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 
-
-
 /* P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
  * TK = dot11DefaultKeyValue or dot11KeyMappingValue (128 bits)
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
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
git-xfs.patch
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
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

