From: akpm@linux-foundation.org
Subject: - mac80211-tkipc-use-kernel-provided-infrastructure.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:18 -0700
Message-ID: <200805162254.m4GMsIAr003226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962AbYEPWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: tkip.c use kernel-provided infrastructure
has been removed from the -mm tree.  Its filename was
     mac80211-tkipc-use-kernel-provided-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tkip.c use kernel-provided infrastructure
From: Harvey Harrison <harvey.harrison@gmail.com>

Use kernel-provided bit rotation and unaligned access infrastructure rather
than opencoding it.

Some minor spacing adjustments as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |  145 +++++++++++++-----------------------------
 1 file changed, 46 insertions(+), 99 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-use-kernel-provided-infrastructure net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-use-kernel-provided-infrastructure
+++ a/net/mac80211/tkip.c
@@ -8,23 +8,22 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <asm/unaligned.h>
 
 #include <net/mac80211.h>
 #include "key.h"
 #include "tkip.h"
 #include "wep.h"
 
-
-/* TKIP key mixing functions */
-
-
 #define PHASE1_LOOP_COUNT 8
 
-
-/* 2-byte by 2-byte subset of the full AES S-box table; second part of this
- * table is identical to first part but byte-swapped */
+/*
+ * 2-byte by 2-byte subset of the full AES S-box table; second part of this
+ * table is identical to first part but byte-swapped
+ */
 static const u16 tkip_sbox[256] =
 {
 	0xC6A5, 0xF884, 0xEE99, 0xF68D, 0xFF0D, 0xD6BD, 0xDEB1, 0x9154,
@@ -61,53 +60,13 @@ static const u16 tkip_sbox[256] =
 	0x82C3, 0x29B0, 0x5A77, 0x1E11, 0x7BCB, 0xA8FC, 0x6DD6, 0x2C3A,
 };
 
-
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
-{
-	return v & 0xff;
-}
-
-
-static inline u16 Hi16(u32 v)
-{
-	return v >> 16;
-}
-
-
-static inline u16 Lo16(u32 v)
-{
-	return v & 0xffff;
-}
-
-
-static inline u16 RotR1(u16 v)
-{
-	return (v >> 1) | ((v & 0x0001) << 15);
-}
-
-
-static inline u16 tkip_S(u16 val)
+static u16 tkipS(u16 val)
 {
-	u16 a = tkip_sbox[Hi8(val)];
-
-	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
+	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 
-
-
-/* P1K := Phase1(TA, TK, TSC)
+/*
+ * P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
  * TK = dot11DefaultKeyValue or dot11KeyMappingValue (128 bits)
  * TSC = TKIP sequence counter (48 bits, only 32 msb bits used)
@@ -118,23 +77,22 @@ static void tkip_mixing_phase1(const u8 
 {
 	int i, j;
 
-	p1k[0] = Lo16(tsc_IV32);
-	p1k[1] = Hi16(tsc_IV32);
-	p1k[2] = Mk16(ta[1], ta[0]);
-	p1k[3] = Mk16(ta[3], ta[2]);
-	p1k[4] = Mk16(ta[5], ta[4]);
+	p1k[0] = tsc_IV32 & 0xFFFF;
+	p1k[1] = tsc_IV32 >> 16;
+	p1k[2] = get_unaligned_le16(ta + 0);
+	p1k[3] = get_unaligned_le16(ta + 2);
+	p1k[4] = get_unaligned_le16(ta + 4);
 
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
 		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ Mk16(tk[ 1 + j], tk[ 0 + j]));
-		p1k[1] += tkip_S(p1k[0] ^ Mk16(tk[ 5 + j], tk[ 4 + j]));
-		p1k[2] += tkip_S(p1k[1] ^ Mk16(tk[ 9 + j], tk[ 8 + j]));
-		p1k[3] += tkip_S(p1k[2] ^ Mk16(tk[13 + j], tk[12 + j]));
-		p1k[4] += tkip_S(p1k[3] ^ Mk16(tk[ 1 + j], tk[ 0 + j])) + i;
+		p1k[0] += tkipS(p1k[4] ^ get_unaligned_le16(tk + 0 + j));
+		p1k[1] += tkipS(p1k[0] ^ get_unaligned_le16(tk + 4 + j));
+		p1k[2] += tkipS(p1k[1] ^ get_unaligned_le16(tk + 8 + j));
+		p1k[3] += tkipS(p1k[2] ^ get_unaligned_le16(tk + 12 + j));
+		p1k[4] += tkipS(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
 }
 
-
 static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 			       u8 *rc4key)
 {
@@ -148,31 +106,29 @@ static void tkip_mixing_phase2(const u16
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ Mk16(tk[ 1], tk[ 0]));
-	ppk[1] += tkip_S(ppk[0] ^ Mk16(tk[ 3], tk[ 2]));
-	ppk[2] += tkip_S(ppk[1] ^ Mk16(tk[ 5], tk[ 4]));
-	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
-	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
-	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  RotR1(ppk[5] ^ Mk16(tk[13], tk[12]));
-	ppk[1] +=  RotR1(ppk[0] ^ Mk16(tk[15], tk[14]));
-	ppk[2] +=  RotR1(ppk[1]);
-	ppk[3] +=  RotR1(ppk[2]);
-	ppk[4] +=  RotR1(ppk[3]);
-	ppk[5] +=  RotR1(ppk[4]);
-
-	rc4key[0] = Hi8(tsc_IV16);
-	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ Mk16(tk[1], tk[0])) >> 1);
-
-	for (i = 0; i < 6; i++) {
-		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-		rc4key[5 + 2 * i] = Hi8(ppk[i]);
-	}
+	ppk[0] += tkipS(ppk[5] ^ get_unaligned_le16(tk + 0));
+	ppk[1] += tkipS(ppk[0] ^ get_unaligned_le16(tk + 2));
+	ppk[2] += tkipS(ppk[1] ^ get_unaligned_le16(tk + 4));
+	ppk[3] += tkipS(ppk[2] ^ get_unaligned_le16(tk + 6));
+	ppk[4] += tkipS(ppk[3] ^ get_unaligned_le16(tk + 8));
+	ppk[5] += tkipS(ppk[4] ^ get_unaligned_le16(tk + 10));
+	ppk[0] += ror16(ppk[5] ^ get_unaligned_le16(tk + 12), 1);
+	ppk[1] += ror16(ppk[0] ^ get_unaligned_le16(tk + 14), 1);
+	ppk[2] += ror16(ppk[1], 1);
+	ppk[3] += ror16(ppk[2], 1);
+	ppk[4] += ror16(ppk[3], 1);
+	ppk[5] += ror16(ppk[4], 1);
+
+	rc4key[0] = tsc_IV16 >> 8;
+	rc4key[1] = ((tsc_IV16 >> 8) | 0x20) & 0x7f;
+	rc4key[2] = tsc_IV16 & 0xFF;
+	rc4key[3] = ((ppk[5] ^ get_unaligned_le16(tk)) >> 1) & 0xFF;
+
+	rc4key += 4;
+	for (i = 0; i < 6; i++)
+		put_unaligned_le16(ppk[i], rc4key + 2 * i);
 }
 
-
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
@@ -183,14 +139,10 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 	*pos++ = iv1;
 	*pos++ = iv2;
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	*pos++ = key->u.tkip.iv32 & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 8) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 16) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 24) & 0xff;
-	return pos;
+	put_unaligned_le32(key->u.tkip.iv32, pos);
+	return pos + 4;
 }
 
-
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
 				  u16 *phase1key)
 {
@@ -228,10 +180,8 @@ void ieee80211_get_tkip_key(struct ieee8
 	u16 iv16;
 	u32 iv32;
 
-	iv16 = data[hdr_len] << 8;
-	iv16 += data[hdr_len + 2];
-	iv32 = data[hdr_len + 4] | (data[hdr_len + 5] << 8) |
-	       (data[hdr_len + 6] << 16) | (data[hdr_len + 7] << 24);
+	iv16 = data[hdr_len + 2] | (data[hdr_len] << 8);
+	iv32 = get_unaligned_le32(data + hdr_len + 4);
 
 #ifdef CONFIG_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
@@ -281,7 +231,6 @@ void ieee80211_tkip_encrypt_data(struct 
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
-
 /* Decrypt packet payload with TKIP using @key. @pos is a pointer to the
  * beginning of the buffer containing IEEE 802.11 header payload, i.e.,
  * including IV, Ext. IV, real data, Michael MIC, ICV. @payload_len is the
@@ -302,7 +251,7 @@ int ieee80211_tkip_decrypt_data(struct c
 
 	iv16 = (pos[0] << 8) | pos[2];
 	keyid = pos[3];
-	iv32 = pos[4] | (pos[5] << 8) | (pos[6] << 16) | (pos[7] << 24);
+	iv32 = get_unaligned_le32(pos + 4);
 	pos += 8;
 #ifdef CONFIG_TKIP_DEBUG
 	{
@@ -409,5 +358,3 @@ int ieee80211_tkip_decrypt_data(struct c
 
 	return res;
 }
-
-
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
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
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
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

