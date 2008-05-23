From: akpm@linux-foundation.org
Subject: - mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:48 -0700
Message-ID: <200805231859.m4NIxmZ6004270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbYEWTAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: tkip.c use struct tkip_ctx in phase 2 key mixing
has been removed from the -mm tree.  Its filename was
     mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tkip.c use struct tkip_ctx in phase 2 key mixing
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing
+++ a/net/mac80211/tkip.c
@@ -95,10 +95,12 @@ static void tkip_mixing_phase1(struct ie
 	ctx->initialized = 1;
 }
 
-static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
-			       u8 *rc4key)
+static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
+			       u16 tsc_IV16, u8 *rc4key)
 {
 	u16 ppk[6];
+	const u16 *p1k = ctx->p1k;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	int i;
 
 	ppk[0] = p1k[0];
@@ -152,9 +154,7 @@ static void ieee80211_tkip_gen_rc4key(st
 	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
 		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.tx.iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -197,8 +197,7 @@ void ieee80211_get_tkip_key(struct ieee8
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
@@ -315,9 +314,7 @@ int ieee80211_tkip_decrypt_data(struct c
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.rx[queue], iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
 		int i;
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

