From: akpm@linux-foundation.org
Subject: + mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization.patch added to -mm tree
Date: Mon, 01 Jun 2009 19:31:41 -0700
Message-ID: <200906020231.n522VfHr017018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbZFBCcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 22:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: research@subreption.com, davem@davemloft.net, johannes@sipsolutions.net, linville@tuxdriver.com, riel@redhat.com


The patch titled
     mac80211: use kzfree in key handling to enforce data sanitization
has been added to the -mm tree.  Its filename is
     mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: use kzfree in key handling to enforce data sanitization
From: Larry Highsmith <research@subreption.com>

Replace the kfree() calls within the mac80211 WEP RC4 key handling and
ieee80211 management APIs with kzfree(), to enforce sanitization of the
key buffer contents.

This prevents the keys from persisting on memory, potentially leaking to
other kernel users after re-allocation of the memory by the LIFO
allocators, or in coldboot attack scenarios.  Information can be leaked as
well due to use of uninitialized variables, or other bugs.

This patch doesn't affect fastpaths.

Signed-off-by: Larry Highsmith <research@subreption.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/key.c |    6 +++---
 net/mac80211/wep.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN net/mac80211/key.c~mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization net/mac80211/key.c
--- a/net/mac80211/key.c~mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization
+++ a/net/mac80211/key.c
@@ -358,7 +358,7 @@ struct ieee80211_key *ieee80211_key_allo
 		 */
 		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
 		if (!key->u.ccmp.tfm) {
-			kfree(key);
+			kzfree(key);
 			return NULL;
 		}
 	}
@@ -471,7 +471,7 @@ void ieee80211_key_free(struct ieee80211
 		 * and don't Oops */
 		if (key->conf.alg == ALG_CCMP)
 			ieee80211_aes_key_free(key->u.ccmp.tfm);
-		kfree(key);
+		kzfree(key);
 		return;
 	}
 
@@ -533,7 +533,7 @@ static void __ieee80211_key_destroy(stru
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	ieee80211_debugfs_key_remove(key);
 
-	kfree(key);
+	kzfree(key);
 }
 
 static void __ieee80211_key_todo(void)
diff -puN net/mac80211/wep.c~mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization net/mac80211/wep.c
--- a/net/mac80211/wep.c~mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization
+++ a/net/mac80211/wep.c
@@ -161,7 +161,7 @@ int ieee80211_wep_encrypt(struct ieee802
 
 	iv = ieee80211_wep_add_iv(local, skb, key);
 	if (!iv) {
-		kfree(rc4key);
+		kzfree(rc4key);
 		return -1;
 	}
 
@@ -179,7 +179,7 @@ int ieee80211_wep_encrypt(struct ieee802
 	ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, klen,
 				   iv + WEP_IV_LEN, len);
 
-	kfree(rc4key);
+	kzfree(rc4key);
 
 	return 0;
 }
@@ -258,7 +258,7 @@ int ieee80211_wep_decrypt(struct ieee802
 				       len))
 		ret = -1;
 
-	kfree(rc4key);
+	kzfree(rc4key);
 
 	/* Trim ICV */
 	skb_trim(skb, skb->len - WEP_ICV_LEN);
_

Patches currently in -mm which might be from research@subreption.com are

mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization.patch

