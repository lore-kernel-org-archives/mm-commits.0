From: akpm@linux-foundation.org
Subject: + mac80211-add-a-struct-to-hold-tkip-context.patch added to -mm tree
Date: Wed, 30 Apr 2008 11:51:09 -0700
Message-ID: <200804301851.m3UIp9jV029438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbYD3Swi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 14:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     mac80211: add a struct to hold tkip context
has been added to the -mm tree.  Its filename is
     mac80211-add-a-struct-to-hold-tkip-context.patch

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
Subject: mac80211: add a struct to hold tkip context
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/cfg.c         |    4 +-
 net/mac80211/debugfs_key.c |    8 ++---
 net/mac80211/key.h         |   17 +++++------
 net/mac80211/tkip.c        |   54 +++++++++++++++++------------------
 net/mac80211/wpa.c         |   16 +++++-----
 5 files changed, 50 insertions(+), 49 deletions(-)

diff -puN net/mac80211/cfg.c~mac80211-add-a-struct-to-hold-tkip-context net/mac80211/cfg.c
--- a/net/mac80211/cfg.c~mac80211-add-a-struct-to-hold-tkip-context
+++ a/net/mac80211/cfg.c
@@ -256,8 +256,8 @@ static int ieee80211_get_key(struct wiph
 	case ALG_TKIP:
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
 
-		iv32 = key->u.tkip.iv32;
-		iv16 = key->u.tkip.iv16;
+		iv32 = key->u.tkip.tx.iv32;
+		iv16 = key->u.tkip.tx.iv16;
 
 		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 		    sdata->local->ops->get_tkip_seq)
diff -puN net/mac80211/debugfs_key.c~mac80211-add-a-struct-to-hold-tkip-context net/mac80211/debugfs_key.c
--- a/net/mac80211/debugfs_key.c~mac80211-add-a-struct-to-hold-tkip-context
+++ a/net/mac80211/debugfs_key.c
@@ -97,8 +97,8 @@ static ssize_t key_tx_spec_read(struct f
 		break;
 	case ALG_TKIP:
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
-				key->u.tkip.iv32,
-				key->u.tkip.iv16);
+				key->u.tkip.tx.iv32,
+				key->u.tkip.tx.iv16);
 		break;
 	case ALG_CCMP:
 		tpn = key->u.ccmp.tx_pn;
@@ -128,8 +128,8 @@ static ssize_t key_rx_spec_read(struct f
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%08x %04x\n",
-				       key->u.tkip.iv32_rx[i],
-				       key->u.tkip.iv16_rx[i]);
+				       key->u.tkip.rx[i].iv32,
+				       key->u.tkip.rx[i].iv16);
 		len = p - buf;
 		break;
 	case ALG_CCMP:
diff -puN net/mac80211/key.h~mac80211-add-a-struct-to-hold-tkip-context net/mac80211/key.h
--- a/net/mac80211/key.h~mac80211-add-a-struct-to-hold-tkip-context
+++ a/net/mac80211/key.h
@@ -69,6 +69,13 @@ enum ieee80211_internal_key_flags {
 	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
 };
 
+struct tkip_ctx {
+	u32 iv32;
+	u16 iv16;
+	u16 p1k[5];
+	int initialized;
+};
+
 struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -85,16 +92,10 @@ struct ieee80211_key {
 	union {
 		struct {
 			/* last used TSC */
-			u32 iv32;
-			u16 iv16;
-			u16 p1k[5];
-			int tx_initialized;
+			struct tkip_ctx tx;
 
 			/* last received RSC */
-			u32 iv32_rx[NUM_RX_DATA_QUEUES];
-			u16 iv16_rx[NUM_RX_DATA_QUEUES];
-			u16 p1k_rx[NUM_RX_DATA_QUEUES][5];
-			int rx_initialized[NUM_RX_DATA_QUEUES];
+			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
 		} tkip;
 		struct {
 			u8 tx_pn[6];
diff -puN net/mac80211/tkip.c~mac80211-add-a-struct-to-hold-tkip-context net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-add-a-struct-to-hold-tkip-context
+++ a/net/mac80211/tkip.c
@@ -138,7 +138,7 @@ u8 *ieee80211_tkip_add_iv(u8 *pos, struc
 	*pos++ = iv1;
 	*pos++ = iv2;
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	put_unaligned_le32(key->u.tkip.iv32, pos);
+	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
 }
 
@@ -146,16 +146,16 @@ static void ieee80211_tkip_gen_rc4key(st
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
-	if (key->u.tkip.iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   key->u.tkip.iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+				   key->u.tkip.tx.iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv16, rc4key);
+			   key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -179,9 +179,9 @@ void ieee80211_get_tkip_key(struct ieee8
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
 			iv16, iv32);
 
-	if (iv32 != key->u.tkip.iv32) {
+	if (iv32 != key->u.tkip.tx.iv32) {
 		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
-			iv32, key->u.tkip.iv32);
+			iv32, key->u.tkip.tx.iv32);
 		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
 			"fragmented packet\n");
 	}
@@ -190,19 +190,19 @@ void ieee80211_get_tkip_key(struct ieee8
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+			iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
-		memcpy(outkey, key->u.tkip.p1k, sizeof(u16) * 5);
+		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
@@ -263,33 +263,33 @@ int ieee80211_tkip_decrypt_data(struct c
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
-	if (key->u.tkip.rx_initialized[queue] &&
-	    (iv32 < key->u.tkip.iv32_rx[queue] ||
-	     (iv32 == key->u.tkip.iv32_rx[queue] &&
-	      iv16 <= key->u.tkip.iv16_rx[queue]))) {
+	if (key->u.tkip.rx[queue].initialized &&
+	    (iv32 < key->u.tkip.rx[queue].iv32 ||
+	     (iv32 == key->u.tkip.rx[queue].iv32 &&
+	      iv16 <= key->u.tkip.rx[queue].iv16))) {
 #ifdef CONFIG_TKIP_DEBUG
 		DECLARE_MAC_BUF(mac);
 		printk(KERN_DEBUG "TKIP replay detected for RX frame from "
 		       "%s (RX IV (%04x,%02x) <= prev. IV (%04x,%02x)\n",
 		       print_mac(mac, ta),
-		       iv32, iv16, key->u.tkip.iv32_rx[queue],
-		       key->u.tkip.iv16_rx[queue]);
+		       iv32, iv16, key->u.tkip.rx[queue].iv32,
+		       key->u.tkip.rx[queue].iv16);
 #endif /* CONFIG_TKIP_DEBUG */
 		return TKIP_DECRYPT_REPLAY;
 	}
 
 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx_initialized[queue] = 1;
+		key->u.tkip.rx[queue].initialized = 1;
 		goto done;
 	}
 
-	if (!key->u.tkip.rx_initialized[queue] ||
-	    key->u.tkip.iv32_rx[queue] != iv32) {
-		key->u.tkip.rx_initialized[queue] = 1;
+	if (!key->u.tkip.rx[queue].initialized ||
+	    key->u.tkip.rx[queue].iv32 != iv32) {
+		key->u.tkip.rx[queue].initialized = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   iv32, key->u.tkip.p1k_rx[queue]);
+				   iv32, key->u.tkip.rx[queue].p1k);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -303,7 +303,7 @@ int ieee80211_tkip_decrypt_data(struct c
 			printk("\n");
 			printk(KERN_DEBUG "TKIP decrypt: P1K=");
 			for (i = 0; i < 5; i++)
-				printk("%04x ", key->u.tkip.p1k_rx[queue][i]);
+				printk("%04x ", key->u.tkip.rx[queue].p1k[i]);
 			printk("\n");
 		}
 #endif /* CONFIG_TKIP_DEBUG */
@@ -318,11 +318,11 @@ int ieee80211_tkip_decrypt_data(struct c
 
 			key->local->ops->update_tkip_key(
 				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.p1k_rx[queue]);
+				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
+	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
diff -puN net/mac80211/wpa.c~mac80211-add-a-struct-to-hold-tkip-context net/mac80211/wpa.c
--- a/net/mac80211/wpa.c~mac80211-add-a-struct-to-hold-tkip-context
+++ a/net/mac80211/wpa.c
@@ -176,8 +176,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.iv32_rx[rx->queue] = rx->tkip_iv32;
-	rx->key->u.tkip.iv16_rx[rx->queue] = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 }
@@ -214,19 +214,19 @@ static int tkip_encrypt_skb(struct ieee8
 	pos += hdrlen;
 
 	/* Increase IV for the frame */
-	key->u.tkip.iv16++;
-	if (key->u.tkip.iv16 == 0)
-		key->u.tkip.iv32++;
+	key->u.tkip.tx.iv16++;
+	if (key->u.tkip.tx.iv16 == 0)
+		key->u.tkip.tx.iv32++;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/* hwaccel - with preallocated room for IV */
 		ieee80211_tkip_add_iv(pos, key,
-				      (u8) (key->u.tkip.iv16 >> 8),
-				      (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
+				      (u8) (key->u.tkip.tx.iv16 >> 8),
+				      (u8) (((key->u.tkip.tx.iv16 >> 8) | 0x20) &
 					    0x7f),
-				      (u8) key->u.tkip.iv16);
+				      (u8) key->u.tkip.tx.iv16);
 
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
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

