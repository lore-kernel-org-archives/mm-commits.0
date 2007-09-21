From: akpm@linux-foundation.org
Subject: + ppp_mppe-dont-put-interimkey-on-the-stack.patch added to -mm tree
Date: Fri, 21 Sep 2007 11:57:09 -0700
Message-ID: <200709211857.l8LIv9d2017716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbXIUS6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 14:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mschmidt@redhat.com, Matt_Domsch@dell.com, davem@davemloft.net, fcusack@fcusack.com


The patch titled
     ppp_mppe: don't put InterimKey on the stack
has been added to the -mm tree.  Its filename is
     ppp_mppe-dont-put-interimkey-on-the-stack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ppp_mppe-dont-put-interimkey-on-the-stack.patch
