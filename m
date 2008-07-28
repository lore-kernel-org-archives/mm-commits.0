From: akpm@linux-foundation.org
Subject: - slab-add-__krealloc-for-netfilter.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:15 -0700
Message-ID: <200807282111.m6SLBFxv027660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760333AbYG1VSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, cl@linux-foundation.org, davem@davemloft.net, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     slab: add __krealloc() for netfilter
has been removed from the -mm tree.  Its filename was
     slab-add-__krealloc-for-netfilter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: add __krealloc() for netfilter
From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix a double-free and use-after-free in netfilter

As suggested by Patrick McHardy, introduce a __krealloc() that doesn't
free the original buffer to fix a double-free and use-after-free bug
introduced by me in netfilter that uses RCU.

Reviewed-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h                |    1 
 mm/util.c                           |   44 ++++++++++++++++++++------
 net/netfilter/nf_conntrack_extend.c |    2 -
 3 files changed, 36 insertions(+), 11 deletions(-)

diff -puN include/linux/slab.h~slab-add-__krealloc-for-netfilter include/linux/slab.h
--- a/include/linux/slab.h~slab-add-__krealloc-for-netfilter
+++ a/include/linux/slab.h
@@ -96,6 +96,7 @@ int kmem_ptr_validate(struct kmem_cache 
 /*
  * Common kmalloc functions provided by all allocators
  */
+void * __must_check __krealloc(const void *, size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 size_t ksize(const void *);
diff -puN mm/util.c~slab-add-__krealloc-for-netfilter mm/util.c
--- a/mm/util.c~slab-add-__krealloc-for-netfilter
+++ a/mm/util.c
@@ -68,25 +68,22 @@ void *kmemdup(const void *src, size_t le
 EXPORT_SYMBOL(kmemdup);
 
 /**
- * krealloc - reallocate memory. The contents will remain unchanged.
+ * __krealloc - like krealloc() but don't free @p.
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
  *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
+ * This function is like krealloc() except it never frees the originally
+ * allocated buffer. Use this if you don't want to free the buffer immediately
+ * like, for example, with RCU.
  */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
+void *__krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
 	size_t ks = 0;
 
-	if (unlikely(!new_size)) {
-		kfree(p);
+	if (unlikely(!new_size))
 		return ZERO_SIZE_PTR;
-	}
 
 	if (p)
 		ks = ksize(p);
@@ -95,10 +92,37 @@ void *krealloc(const void *p, size_t new
 		return (void *)p;
 
 	ret = kmalloc_track_caller(new_size, flags);
-	if (ret && p) {
+	if (ret && p)
 		memcpy(ret, p, ks);
+
+	return ret;
+}
+EXPORT_SYMBOL(__krealloc);
+
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!new_size)) {
 		kfree(p);
+		return ZERO_SIZE_PTR;
 	}
+
+	ret = __krealloc(p, new_size, flags);
+	if (ret && p != ret)
+		kfree(p);
+
 	return ret;
 }
 EXPORT_SYMBOL(krealloc);
diff -puN net/netfilter/nf_conntrack_extend.c~slab-add-__krealloc-for-netfilter net/netfilter/nf_conntrack_extend.c
--- a/net/netfilter/nf_conntrack_extend.c~slab-add-__krealloc-for-netfilter
+++ a/net/netfilter/nf_conntrack_extend.c
@@ -95,7 +95,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	new = krealloc(ct->ext, newlen, gfp);
+	new = __krealloc(ct->ext, newlen, gfp);
 	if (!new)
 		return NULL;
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
git-unionfs.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slab-leaks3-default-y.patch

