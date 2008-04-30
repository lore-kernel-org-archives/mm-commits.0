From: akpm@linux-foundation.org
Subject: + mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:51:13 -0700
Message-ID: <200804301851.m3UIpDOe029447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921AbYD3Swl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     mac80211: tkip.c use struct tkip_ctx in phase 2 key mixing
has been added to the -mm tree.  Its filename is
     mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch

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
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
frv-unbreak-misalignment-handling-changes.patch
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
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

