From: akpm@linux-foundation.org
Subject: - video-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:33 -0700
Message-ID: <200804300549.m3U5nXP9030011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905AbYD3FuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, adaplas@gmail.com, vandrove@vc.cvut.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     video: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     video-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_misc.c |   28 ++++++++++++-------------
 drivers/video/metronomefb.c          |    9 ++------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff -puN drivers/video/matrox/matroxfb_misc.c~video-use-get-put_unaligned_-helpers drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~video-use-get-put_unaligned_-helpers
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -522,8 +522,6 @@ static void parse_bios(unsigned char __i
 #endif
 }
 
-#define get_u16(x) (le16_to_cpu(get_unaligned((__u16*)(x))))
-#define get_u32(x) (le32_to_cpu(get_unaligned((__u32*)(x))))
 static int parse_pins1(WPMINFO const struct matrox_bios* bd) {
 	unsigned int maxdac;
 
@@ -532,11 +530,12 @@ static int parse_pins1(WPMINFO const str
 		case 1:		maxdac = 220000; break;
 		default:	maxdac = 240000; break;
 	}
-	if (get_u16(bd->pins + 24)) {
-		maxdac = get_u16(bd->pins + 24) * 10;
+	if (get_unaligned_le16(bd->pins + 24)) {
+		maxdac = get_unaligned_le16(bd->pins + 24) * 10;
 	}
 	MINFO->limits.pixel.vcomax = maxdac;
-	MINFO->values.pll.system = get_u16(bd->pins + 28) ? get_u16(bd->pins + 28) * 10 : 50000;
+	MINFO->values.pll.system = get_unaligned_le16(bd->pins + 28) ?
+		get_unaligned_le16(bd->pins + 28) * 10 : 50000;
 	/* ignore 4MB, 8MB, module clocks */
 	MINFO->features.pll.ref_freq = 14318;
 	MINFO->values.reg.mctlwtst	= 0x00030101;
@@ -575,7 +574,8 @@ static void default_pins2(WPMINFO2) {
 static int parse_pins3(WPMINFO const struct matrox_bios* bd) {
 	MINFO->limits.pixel.vcomax	=
 	MINFO->limits.system.vcomax	= (bd->pins[36] == 0xFF) ? 230000			: ((bd->pins[36] + 100) * 1000);
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins + 48) == 0xFFFFFFFF ? 0x01250A21	: get_u32(bd->pins + 48);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 48) == 0xFFFFFFFF ?
+		0x01250A21 : get_unaligned_le32(bd->pins + 48);
 	/* memory config */
 	MINFO->values.reg.memrdbk	= ((bd->pins[57] << 21) & 0x1E000000) |
 					  ((bd->pins[57] << 22) & 0x00C00000) |
@@ -601,7 +601,7 @@ static void default_pins3(WPMINFO2) {
 static int parse_pins4(WPMINFO const struct matrox_bios* bd) {
 	MINFO->limits.pixel.vcomax	= (bd->pins[ 39] == 0xFF) ? 230000			: bd->pins[ 39] * 4000;
 	MINFO->limits.system.vcomax	= (bd->pins[ 38] == 0xFF) ? MINFO->limits.pixel.vcomax	: bd->pins[ 38] * 4000;
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins + 71);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 71);
 	MINFO->values.reg.memrdbk	= ((bd->pins[87] << 21) & 0x1E000000) |
 					  ((bd->pins[87] << 22) & 0x00C00000) |
 					  ((bd->pins[86] <<  1) & 0x000001E0) |
@@ -609,7 +609,7 @@ static int parse_pins4(WPMINFO const str
 	MINFO->values.reg.opt		= ((bd->pins[53] << 15) & 0x00400000) |
 					  ((bd->pins[53] << 22) & 0x10000000) |
 					  ((bd->pins[53] <<  7) & 0x00001C00);
-	MINFO->values.reg.opt3		= get_u32(bd->pins + 67);
+	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 67);
 	MINFO->values.pll.system	= (bd->pins[ 65] == 0xFF) ? 200000 			: bd->pins[ 65] * 4000;
 	MINFO->features.pll.ref_freq	= (bd->pins[ 92] & 0x01) ? 14318 : 27000;
 	return 0;
@@ -640,12 +640,12 @@ static int parse_pins5(WPMINFO const str
 	MINFO->limits.video.vcomin	= (bd->pins[122] == 0xFF) ? MINFO->limits.system.vcomin	: bd->pins[122] * mult;
 	MINFO->values.pll.system	=
 	MINFO->values.pll.video		= (bd->pins[ 92] == 0xFF) ? 284000			: bd->pins[ 92] * 4000;
-	MINFO->values.reg.opt		= get_u32(bd->pins+ 48);
-	MINFO->values.reg.opt2		= get_u32(bd->pins+ 52);
-	MINFO->values.reg.opt3		= get_u32(bd->pins+ 94);
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins+ 98);
-	MINFO->values.reg.memmisc	= get_u32(bd->pins+102);
-	MINFO->values.reg.memrdbk	= get_u32(bd->pins+106);
+	MINFO->values.reg.opt		= get_unaligned_le32(bd->pins + 48);
+	MINFO->values.reg.opt2		= get_unaligned_le32(bd->pins + 52);
+	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 94);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 98);
+	MINFO->values.reg.memmisc	= get_unaligned_le32(bd->pins + 102);
+	MINFO->values.reg.memrdbk	= get_unaligned_le32(bd->pins + 106);
 	MINFO->features.pll.ref_freq	= (bd->pins[110] & 0x01) ? 14318 : 27000;
 	MINFO->values.memory.ddr	= (bd->pins[114] & 0x60) == 0x20;
 	MINFO->values.memory.dll	= (bd->pins[115] & 0x02) != 0;
diff -puN drivers/video/metronomefb.c~video-use-get-put_unaligned_-helpers drivers/video/metronomefb.c
--- a/drivers/video/metronomefb.c~video-use-get-put_unaligned_-helpers
+++ a/drivers/video/metronomefb.c
@@ -206,8 +206,7 @@ static int load_waveform(u8 *mem, size_t
 	}
 
 	/* check waveform mode table address checksum */
-	wmta = le32_to_cpu(get_unaligned((__le32 *) wfm_hdr->wmta));
-	wmta &= 0x00FFFFFF;
+	wmta = get_unaligned_le32(wfm_hdr->wmta) & 0x00FFFFFF;
 	cksum_idx = wmta + m*4 + 3;
 	if (cksum_idx > size)
 		return -EINVAL;
@@ -219,8 +218,7 @@ static int load_waveform(u8 *mem, size_t
 	}
 
 	/* check waveform temperature table address checksum */
-	tta = le32_to_cpu(get_unaligned((int *) (mem + wmta + m*4)));
-	tta &= 0x00FFFFFF;
+	tta = get_unaligned_le32(mem + wmta + m * 4) & 0x00FFFFFF;
 	cksum_idx = tta + trn*4 + 3;
 	if (cksum_idx > size)
 		return -EINVAL;
@@ -233,8 +231,7 @@ static int load_waveform(u8 *mem, size_t
 
 	/* here we do the real work of putting the waveform into the
 	metromem buffer. this does runlength decoding of the waveform */
-	wfm_idx = le32_to_cpu(get_unaligned((__le32 *) (mem + tta + trn*4)));
-	wfm_idx &= 0x00FFFFFF;
+	wfm_idx = get_unaligned_le32(mem + tta + trn * 4) & 0x00FFFFFF;
 	owfm_idx = wfm_idx;
 	if (wfm_idx > size)
 		return -EINVAL;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
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

