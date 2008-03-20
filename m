From: akpm@linux-foundation.org
Subject: + mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch added to -mm tree
Date: Thu, 20 Mar 2008 13:37:42 -0700
Message-ID: <200803202037.m2KKbhUZ023206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735AbYCTUkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 16:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     mac80211: tkipc.c michael.c use kernel bit rotation helpers
has been added to the -mm tree.  Its filename is
     mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch

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
Subject: mac80211: tkipc.c michael.c use kernel bit rotation helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Use ror16, ror32, rol32 instead of a private helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   20 ++++----------------
 net/mac80211/tkip.c    |   20 +++++++-------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers
+++ a/net/mac80211/michael.c
@@ -8,36 +8,24 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #include "michael.h"
 
-static inline u32 rotr(u32 val, int bits)
-{
-	return (val >> bits) | (val << (32 - bits));
-}
-
-
-static inline u32 rotl(u32 val, int bits)
-{
-	return (val << bits) | (val >> (32 - bits));
-}
-
-
 static inline u32 xswap(u32 val)
 {
 	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
 }
 
-
 #define michael_block(l, r) \
 do { \
-	r ^= rotl(l, 17); \
+	r ^= rol32(l, 17); \
 	l += r; \
 	r ^= xswap(l); \
 	l += r; \
-	r ^= rotl(l, 3); \
+	r ^= rol32(l, 3); \
 	l += r; \
-	r ^= rotr(l, 2); \
+	r ^= ror32(l, 2); \
 	l += r; \
 } while (0)
 
diff -puN net/mac80211/tkip.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers
+++ a/net/mac80211/tkip.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 
@@ -91,13 +92,6 @@ static inline u16 Lo16(u32 v)
 	return v & 0xffff;
 }
 
-
-static inline u16 RotR1(u16 v)
-{
-	return (v >> 1) | ((v & 0x0001) << 15);
-}
-
-
 static inline u16 tkip_S(u16 val)
 {
 	u16 a = tkip_sbox[Hi8(val)];
@@ -154,12 +148,12 @@ static void tkip_mixing_phase2(const u16
 	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
 	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
 	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  RotR1(ppk[5] ^ Mk16(tk[13], tk[12]));
-	ppk[1] +=  RotR1(ppk[0] ^ Mk16(tk[15], tk[14]));
-	ppk[2] +=  RotR1(ppk[1]);
-	ppk[3] +=  RotR1(ppk[2]);
-	ppk[4] +=  RotR1(ppk[3]);
-	ppk[5] +=  RotR1(ppk[4]);
+	ppk[0] +=  ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
+	ppk[1] +=  ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[2] +=  ror16(ppk[1], 1);
+	ppk[3] +=  ror16(ppk[2], 1);
+	ppk[4] +=  ror16(ppk[3], 1);
+	ppk[5] +=  ror16(ppk[4], 1);
 
 	rc4key[0] = Hi8(tsc_IV16);
 	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
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
serial-remove-double-initializer.patch
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
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
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
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-unused-function-make-function-static.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

