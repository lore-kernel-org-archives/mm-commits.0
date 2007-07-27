From: akpm@linux-foundation.org
Subject: + fib_trie-macro-cleanup.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:52:33 -0700
Message-ID: <200707270452.l6R4qXpP006122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbXG0Exh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, davem@davemloft.net


The patch titled
     fib_trie: macro cleanup
has been added to the -mm tree.  Its filename is
     fib_trie-macro-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fib_trie: macro cleanup
From: Stephen Hemminger <shemminger@linux-foundation.org>

This patch converts the messy macro for MASK_PFX to inline function
and expands TKEY_GET_MASK in the one place it is used.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/fib_trie.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN net/ipv4/fib_trie.c~fib_trie-macro-cleanup net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~fib_trie-macro-cleanup
+++ a/net/ipv4/fib_trie.c
@@ -85,8 +85,6 @@
 #define MAX_STAT_DEPTH 32
 
 #define KEYLENGTH (8*sizeof(t_key))
-#define MASK_PFX(k, l) (((l)==0)?0:(k >> (KEYLENGTH-l)) << (KEYLENGTH-l))
-#define TKEY_GET_MASK(offset, bits) (((bits)==0)?0:((t_key)(-1) << (KEYLENGTH - bits) >> offset))
 
 typedef unsigned int t_key;
 
@@ -192,6 +190,11 @@ static inline int tnode_child_length(con
 	return 1 << tn->bits;
 }
 
+static inline t_key mask_pfx(t_key k, unsigned short l)
+{
+	return (l == 0) ? 0 : k >> (KEYLENGTH-l) << (KEYLENGTH-l);
+}
+
 static inline t_key tkey_extract_bits(t_key a, int offset, int bits)
 {
 	if (offset < KEYLENGTH)
@@ -676,7 +679,7 @@ static struct tnode *inflate(struct trie
 		    inode->pos == oldtnode->pos + oldtnode->bits &&
 		    inode->bits > 1) {
 			struct tnode *left, *right;
-			t_key m = TKEY_GET_MASK(inode->pos, 1);
+			t_key m = ~0U << (KEYLENGTH - 1) >> inode->pos;
 
 			left = tnode_new(inode->key&(~m), inode->pos + 1,
 					 inode->bits - 1);
@@ -1364,7 +1367,8 @@ fn_trie_lookup(struct fib_table *tb, con
 		bits = pn->bits;
 
 		if (!chopped_off)
-			cindex = tkey_extract_bits(MASK_PFX(key, current_prefix_length), pos, bits);
+			cindex = tkey_extract_bits(mask_pfx(key, current_prefix_length),
+						   pos, bits);
 
 		n = tnode_get_child(pn, cindex);
 
@@ -1450,8 +1454,8 @@ fn_trie_lookup(struct fib_table *tb, con
 		 * to find a matching prefix.
 		 */
 
-		node_prefix = MASK_PFX(cn->key, cn->pos);
-		key_prefix = MASK_PFX(key, cn->pos);
+		node_prefix = mask_pfx(cn->key, cn->pos);
+		key_prefix = mask_pfx(key, cn->pos);
 		pref_mismatch = key_prefix^node_prefix;
 		mp = 0;
 
@@ -2327,7 +2331,7 @@ static int fib_trie_seq_show(struct seq_
 
 	if (IS_TNODE(n)) {
 		struct tnode *tn = (struct tnode *) n;
-		__be32 prf = htonl(MASK_PFX(tn->key, tn->pos));
+		__be32 prf = htonl(mask_pfx(tn->key, tn->pos));
 
 		seq_indent(seq, iter->depth-1);
 		seq_printf(seq, "  +-- %d.%d.%d.%d/%d %d %d %d\n",
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
fib_trie-cleanup.patch
fib_trie-macro-cleanup.patch
