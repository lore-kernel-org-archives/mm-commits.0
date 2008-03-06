From: akpm@linux-foundation.org
Subject: - netfilter-replace-horrible-hack-with-ksize.patch removed from -mm tree
Date: Thu, 06 Mar 2008 15:32:41 -0800
Message-ID: <200803062332.m26NWfMj024123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757389AbYCFXdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 18:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: replace horrible hack with ksize()
has been removed from the -mm tree.  Its filename was
     netfilter-replace-horrible-hack-with-ksize.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: replace horrible hack with ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>

There's a horrible slab abuse in net/netfilter/nf_conntrack_extend.c that can
be replaced with a call to ksize().

Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netfilter/nf_conntrack_extend.h |    1 
 net/netfilter/nf_conntrack_extend.c         |   19 ++----------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff -puN include/net/netfilter/nf_conntrack_extend.h~netfilter-replace-horrible-hack-with-ksize include/net/netfilter/nf_conntrack_extend.h
--- a/include/net/netfilter/nf_conntrack_extend.h~netfilter-replace-horrible-hack-with-ksize
+++ a/include/net/netfilter/nf_conntrack_extend.h
@@ -17,7 +17,6 @@ enum nf_ct_ext_id
 struct nf_ct_ext {
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
-	u8 real_len;
 	char data[0];
 };
 
diff -puN net/netfilter/nf_conntrack_extend.c~netfilter-replace-horrible-hack-with-ksize net/netfilter/nf_conntrack_extend.c
--- a/net/netfilter/nf_conntrack_extend.c~netfilter-replace-horrible-hack-with-ksize
+++ a/net/netfilter/nf_conntrack_extend.c
@@ -19,14 +19,6 @@
 static struct nf_ct_ext_type *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 
-/* Horrible trick to figure out smallest amount worth kmallocing. */
-#define CACHE(x) (x) + 0 *
-enum {
-	NF_CT_EXT_MIN_SIZE =
-#include <linux/kmalloc_sizes.h>
-	1 };
-#undef CACHE
-
 void __nf_ct_ext_destroy(struct nf_conn *ct)
 {
 	unsigned int i;
@@ -53,7 +45,7 @@ EXPORT_SYMBOL(__nf_ct_ext_destroy);
 static void *
 nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 {
-	unsigned int off, len, real_len;
+	unsigned int off, len;
 	struct nf_ct_ext_type *t;
 
 	rcu_read_lock();
@@ -61,16 +53,14 @@ nf_ct_ext_create(struct nf_ct_ext **ext,
 	BUG_ON(t == NULL);
 	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
 	len = off + t->len;
-	real_len = t->alloc_size;
 	rcu_read_unlock();
 
-	*ext = kzalloc(real_len, gfp);
+	*ext = kzalloc(t->alloc_size, gfp);
 	if (!*ext)
 		return NULL;
 
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
-	(*ext)->real_len = real_len;
 
 	return (void *)(*ext) + off;
 }
@@ -95,7 +85,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	if (newlen >= ct->ext->real_len) {
+	if (newlen >= ksize(ct->ext)) {
 		new = kmalloc(newlen, gfp);
 		if (!new)
 			return NULL;
@@ -114,7 +104,6 @@ void *__nf_ct_ext_add(struct nf_conn *ct
 			rcu_read_unlock();
 		}
 		kfree(ct->ext);
-		new->real_len = newlen;
 		ct->ext = new;
 	}
 
@@ -156,8 +145,6 @@ static void update_alloc_size(struct nf_
 			t1->alloc_size = ALIGN(t1->alloc_size, t2->align)
 					 + t2->len;
 		}
-		if (t1->alloc_size < NF_CT_EXT_MIN_SIZE)
-			t1->alloc_size = NF_CT_EXT_MIN_SIZE;
 	}
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

netfilter-replace-horrible-hack-with-ksize.patch
git-unionfs.patch
git-slub.patch
slab-pass-correct-flags-to-kmem_getpages.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
mm-move-cache_line_size-to-linux-cacheh.patch
numa-slab-allocator-migration-bugfix.patch
fs-coda-remove-static-inline-forward-declarations.patch
documentation-patch-tags-one-more-time.patch
slab-leaks3-default-y.patch

