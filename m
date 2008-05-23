From: akpm@linux-foundation.org
Subject: - mac80211-add-const-remove-unused-function-make-one-function-static.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:42 -0700
Message-ID: <200805231859.m4NIxgxS004261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYEWTAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: add const, remove unused function, make one function static
has been removed from the -mm tree.  Its filename was
     mac80211-add-const-remove-unused-function-make-one-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: add const, remove unused function, make one function static
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |    7 +++----
 net/mac80211/michael.h |    4 ++--
 net/mac80211/tkip.c    |   12 ++----------
 net/mac80211/tkip.h    |    4 ----
 4 files changed, 7 insertions(+), 20 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/michael.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <asm/unaligned.h>
@@ -28,7 +27,7 @@ static void michael_block(struct michael
 }
 
 static void michael_mic_hdr(struct michael_mic_ctx *mctx,
-			    u8 *key, u8 *da, u8 *sa, u8 priority)
+			const u8 *key, const u8 *da, const u8 *sa, u8 priority)
 {
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
@@ -44,8 +43,8 @@ static void michael_mic_hdr(struct micha
 	michael_block(mctx, priority);
 }
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic)
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic)
 {
 	u32 val;
 	size_t block, blocks, left;
diff -puN net/mac80211/michael.h~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/michael.h
--- a/net/mac80211/michael.h~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/michael.h
@@ -18,7 +18,7 @@ struct michael_mic_ctx {
 	u32 l, r;
 };
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic);
+void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+		 const u8 *data, size_t data_len, u8 *mic);
 
 #endif /* MICHAEL_H */
diff -puN net/mac80211/tkip.c~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/tkip.c
@@ -6,7 +6,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
@@ -132,7 +131,7 @@ static void tkip_mixing_phase2(const u16
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
-u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
+u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2)
 {
 	*pos++ = iv0;
@@ -143,14 +142,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 	return pos + 4;
 }
 
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key)
-{
-	tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv32, phase1key);
-}
-
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
+static void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
diff -puN net/mac80211/tkip.h~mac80211-add-const-remove-unused-function-make-one-function-static net/mac80211/tkip.h
--- a/net/mac80211/tkip.h~mac80211-add-const-remove-unused-function-make-one-function-static
+++ a/net/mac80211/tkip.h
@@ -15,10 +15,6 @@
 
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			  u8 iv0, u8 iv1, u8 iv2);
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
-void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
-			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

