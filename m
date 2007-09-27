From: akpm@linux-foundation.org
Subject: - ppp_mppe-dont-put-interimkey-on-the-stack.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:44:17 -0700
Message-ID: <200709270144.l8R1iH5k014031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbXI0Bvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mschmidt@redhat.com, Matt_Domsch@dell.com, davem@davemloft.net, fcusack@fcusack.com, mm-commits@vger.kernel.org


The patch titled
     ppp_mppe: don't put InterimKey on the stack
has been removed from the -mm tree.  Its filename was
     ppp_mppe-dont-put-interimkey-on-the-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppp_mppe: don't put InterimKey on the stack
From: Michal Schmidt <mschmidt@redhat.com>

The interrupt stack can be in the __START_KERNEL_map region in which
virt_to_page will not work.  This caused ppp_mppe to crash on CentOS 5 on
x86_64 (http://bugs.centos.org/view.php?id=2076).

The fix is to avoid copying the interim key.  We can simply use it in its
original place, which is kmalloc'd.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: Frank Cusack <fcusack@fcusack.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_mppe.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/net/ppp_mppe.c~ppp_mppe-dont-put-interimkey-on-the-stack drivers/net/ppp_mppe.c
--- a/drivers/net/ppp_mppe.c~ppp_mppe-dont-put-interimkey-on-the-stack
+++ a/drivers/net/ppp_mppe.c
@@ -136,7 +136,7 @@ struct ppp_mppe_state {
  * Key Derivation, from RFC 3078, RFC 3079.
  * Equivalent to Get_Key() for MS-CHAP as described in RFC 3079.
  */
-static void get_new_key_from_sha(struct ppp_mppe_state * state, unsigned char *InterimKey)
+static void get_new_key_from_sha(struct ppp_mppe_state *state)
 {
 	struct hash_desc desc;
 	struct scatterlist sg[4];
@@ -153,8 +153,6 @@ static void get_new_key_from_sha(struct 
 	desc.flags = 0;
 
 	crypto_hash_digest(&desc, sg, nbytes, state->sha1_digest);
-
-	memcpy(InterimKey, state->sha1_digest, state->keylen);
 }
 
 /*
@@ -163,21 +161,21 @@ static void get_new_key_from_sha(struct 
  */
 static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 {
-	unsigned char InterimKey[MPPE_MAX_KEY_LEN];
 	struct scatterlist sg_in[1], sg_out[1];
 	struct blkcipher_desc desc = { .tfm = state->arc4 };
 
-	get_new_key_from_sha(state, InterimKey);
+	get_new_key_from_sha(state);
 	if (!initial_key) {
-		crypto_blkcipher_setkey(state->arc4, InterimKey, state->keylen);
-		setup_sg(sg_in, InterimKey, state->keylen);
+		crypto_blkcipher_setkey(state->arc4, state->sha1_digest,
+					state->keylen);
+		setup_sg(sg_in, state->sha1_digest, state->keylen);
 		setup_sg(sg_out, state->session_key, state->keylen);
 		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
 					     state->keylen) != 0) {
     		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
 		}
 	} else {
-		memcpy(state->session_key, InterimKey, state->keylen);
+		memcpy(state->session_key, state->sha1_digest, state->keylen);
 	}
 	if (state->keylen == 8) {
 		/* See RFC 3078 */
_

Patches currently in -mm which might be from mschmidt@redhat.com are

origin.patch
