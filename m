From: akpm@linux-foundation.org
Subject: - mac80211-michaelc-replace-macro-with-function.patch removed from -mm tree
Date: Fri, 18 Apr 2008 14:19:59 -0700
Message-ID: <200804182119.m3ILJx6Z016678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbYDRVU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 17:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jbenc@suse.cz, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: michael.c replace macro with function
has been removed from the -mm tree.  Its filename was
     mac80211-michaelc-replace-macro-with-function.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: michael.c replace macro with function
From: Harvey Harrison <harvey.harrison@gmail.com>

This series cuts the size of michael.o from 0x280 to 0x125 on X86_32
and cuts lines from michael.c.


This patch:

Make michael_block a function to avoid it being unrolled everywhere, cuts a
third off of the michael.o size.

Fold xswap into michael_block and remove xswap.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-replace-macro-with-function net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-replace-macro-with-function
+++ a/net/mac80211/michael.c
@@ -12,23 +12,18 @@
 
 #include "michael.h"
 
-static inline u32 xswap(u32 val)
+static void michael_block(u32 *l, u32 *r)
 {
-	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
+	*r ^= rol32(*l, 17);
+	*l += *r;
+	*r ^= ((*l & 0xff00ff00) >> 8) | ((*l & 0x00ff00ff) << 8);
+	*l += *r;
+	*r ^= rol32(*l, 3);
+	*l += *r;
+	*r ^= ror32(*l, 2);
+	*l += *r;
 }
 
-#define michael_block(l, r) \
-do { \
-	r ^= rol32(l, 17); \
-	l += r; \
-	r ^= xswap(l); \
-	l += r; \
-	r ^= rol32(l, 3); \
-	l += r; \
-	r ^= ror32(l, 2); \
-	l += r; \
-} while (0)
-
 
 static inline u32 michael_get32(u8 *data)
 {
@@ -57,13 +52,13 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
 	l ^= michael_get32(da);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= michael_get32(&sa[2]);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= priority;
-	michael_block(l, r);
+	michael_block(&l, &r);
 
 	/* Real data */
 	blocks = data_len / 4;
@@ -71,7 +66,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 
 	for (block = 0; block < blocks; block++) {
 		l ^= michael_get32(&data[block * 4]);
-		michael_block(l, r);
+		michael_block(&l, &r);
 	}
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
@@ -83,9 +78,9 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 		val |= data[blocks * 4 + left];
 	}
 	l ^= val;
-	michael_block(l, r);
+	michael_block(&l, &r);
 	/* last block is zero, so l ^ 0 = l */
-	michael_block(l, r);
+	michael_block(&l, &r);
 
 	michael_put32(l, mic);
 	michael_put32(r, mic + 4);
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

