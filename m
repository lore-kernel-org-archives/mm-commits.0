From: akpm@linux-foundation.org
Subject: - mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch removed from -mm tree
Date: Fri, 18 Apr 2008 14:19:56 -0700
Message-ID: <200804182119.m3ILJuln016675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbYDRVWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 17:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: tkip.c remove Mk16, Hi8, Lo8 helpers
has been removed from the -mm tree.  Its filename was
     mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tkip.c remove Mk16, Hi8, Lo8 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Create a new getle16 helper to replace Mk16 that deals with unaligned access. 
Also, use put_unaligned when writing out the rc4key result.  Opencode the few
remaining Hi8/Lo8 calls and remove the helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |   70 ++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-remove-mk16-hi8-lo8-helpers net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-remove-mk16-hi8-lo8-helpers
+++ a/net/mac80211/tkip.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <asm/unaligned.h>
 
 #include <net/mac80211.h>
 #include "key.h"
@@ -63,21 +64,13 @@ static const u16 tkip_sbox[256] =
 };
 
 
-static inline u16 Mk16(u8 x, u8 y)
-{
-	return ((u16) x << 8) | (u16) y;
-}
-
-
-static inline u8 Hi8(u16 v)
-{
-	return v >> 8;
-}
-
-
-static inline u8 Lo8(u16 v)
+/*
+ * Get a cpu-byteorder u16 from a u8 pointer fixing up possible unaligned
+ * accesses.
+ */
+static inline u16 getle16(const u8 *x)
 {
-	return v & 0xff;
+	return le16_to_cpu(get_unaligned((__le16 *)x));
 }
 
 static inline u16 tkip_S(u16 val)
@@ -98,17 +91,17 @@ static void tkip_mixing_phase1(const u8 
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
 	p1k[1] = tsc_IV32 >> 16;
-	p1k[2] = Mk16(ta[1], ta[0]);
-	p1k[3] = Mk16(ta[3], ta[2]);
-	p1k[4] = Mk16(ta[5], ta[4]);
+	p1k[2] = getle16(ta + 0);
+	p1k[3] = getle16(ta + 2);
+	p1k[4] = getle16(ta + 4);
 
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
 		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ Mk16(tk[ 1 + j], tk[ 0 + j]));
-		p1k[1] += tkip_S(p1k[0] ^ Mk16(tk[ 5 + j], tk[ 4 + j]));
-		p1k[2] += tkip_S(p1k[1] ^ Mk16(tk[ 9 + j], tk[ 8 + j]));
-		p1k[3] += tkip_S(p1k[2] ^ Mk16(tk[13 + j], tk[12 + j]));
-		p1k[4] += tkip_S(p1k[3] ^ Mk16(tk[ 1 + j], tk[ 0 + j])) + i;
+		p1k[0] += tkip_S(p1k[4] ^ getle16(tk + 0 + j));
+		p1k[1] += tkip_S(p1k[0] ^ getle16(tk + 4 + j));
+		p1k[2] += tkip_S(p1k[1] ^ getle16(tk + 8 + j));
+		p1k[3] += tkip_S(p1k[2] ^ getle16(tk + 12 + j));
+		p1k[4] += tkip_S(p1k[3] ^ getle16(tk + 0 + j)) + i;
 	}
 }
 
@@ -126,28 +119,27 @@ static void tkip_mixing_phase2(const u16
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ Mk16(tk[ 1], tk[ 0]));
-	ppk[1] += tkip_S(ppk[0] ^ Mk16(tk[ 3], tk[ 2]));
-	ppk[2] += tkip_S(ppk[1] ^ Mk16(tk[ 5], tk[ 4]));
-	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
-	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
-	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
-	ppk[1] +=  ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[0] += tkip_S(ppk[5] ^ getle16(tk + 0));
+	ppk[1] += tkip_S(ppk[0] ^ getle16(tk + 2));
+	ppk[2] += tkip_S(ppk[1] ^ getle16(tk + 4));
+	ppk[3] += tkip_S(ppk[2] ^ getle16(tk + 6));
+	ppk[4] += tkip_S(ppk[3] ^ getle16(tk + 8));
+	ppk[5] += tkip_S(ppk[4] ^ getle16(tk + 10));
+	ppk[0] +=  ror16(ppk[5] ^ getle16(tk + 12), 1);
+	ppk[1] +=  ror16(ppk[0] ^ getle16(tk + 14), 1);
 	ppk[2] +=  ror16(ppk[1], 1);
 	ppk[3] +=  ror16(ppk[2], 1);
 	ppk[4] +=  ror16(ppk[3], 1);
 	ppk[5] +=  ror16(ppk[4], 1);
 
-	rc4key[0] = Hi8(tsc_IV16);
-	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ Mk16(tk[1], tk[0])) >> 1);
-
-	for (i = 0; i < 6; i++) {
-		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-		rc4key[5 + 2 * i] = Hi8(ppk[i]);
-	}
+	rc4key[0] = tsc_IV16 >> 8;
+	rc4key[1] = ((tsc_IV16 >> 8) | 0x20) & 0x7f;
+	rc4key[2] = tsc_IV16 & 0xFF;
+	rc4key[3] = ((ppk[5] ^ getle16(tk)) >> 1) & 0xFF;
+
+	rc4key += 4;
+	for (i = 0; i < 6; i++)
+		put_unaligned(cpu_to_le16(ppk[i]), (__le16 *)rc4key + i);
 }
 
 
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

