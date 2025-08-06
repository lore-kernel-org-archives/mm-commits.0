Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2293A145346
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754522049; cv=none; b=mRKQf+6v83Gn8m2S9jcp0IOA12yvVx9zWK3s4Ne+2KkIjYD+wAtOOVgO6kuiTzGsWWHyJwSMTH4c8dp4NIlAdp93tuZu7KEpnkSvmYAcyZmI6YMofYinHgkea22jcwJAo97w7CqYqURaUne8QRgE89SW3hTxCkemnbjksb+Sqp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754522049; c=relaxed/simple;
	bh=zkRRz/AZXewObbQtBuNk0JTsYGfKRO5EHis+s7A8ivY=;
	h=Date:To:From:Subject:Message-Id; b=kUCdMxj1RDo2HCLZdUb/AmTdn0sFGtQBBmH0P8RYsn2IxIzT/kCYDqZDq+1QMLIs4FfbP3QBXP4RYAQngIh59Bxbe5aDhD4JoSPQhff71ShP4UqNn2iXC1c01datJsD5Pao1X428gu4Wkz4y9uTHPzRu2ku2PFq2Q5rJrjmmAaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1hUzUpJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1hUzUpJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906BFC4CEE7;
	Wed,  6 Aug 2025 23:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754522048;
	bh=zkRRz/AZXewObbQtBuNk0JTsYGfKRO5EHis+s7A8ivY=;
	h=Date:To:From:Subject:From;
	b=1hUzUpJgOMpZZorh2YoZ1nsHgh55kZyFRF5WPrFTpFahFoRLJeRIBzccA9u9F1pF1
	 hGI/2sUl+8RCXUBP0u4h3mdq/6D9c/MsW8K1lNaHgig/w1IBwSooB1oJQUHCURh2Oz
	 9eg0zKp1MtqvYphaHf2ZljfedkLzghvUcoYeITms=
Date: Wed, 06 Aug 2025 16:14:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,jannh@google.com,herbert@gondor.apana.org.au,dakr@kernel.org,aliceryhl@google.com,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch added to mm-new branch
Message-Id: <20250806231408.906BFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: allow to set node and align in vrealloc
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.se>
Subject: mm/vmalloc: allow to set node and align in vrealloc
Date: Wed, 6 Aug 2025 14:41:08 +0200

Patch series "support large align and nid in Rust allocators", v15.

The series provides the ability for Rust allocators to set NUMA node and
large alignment.


This patch (of 4):

Reimplement vrealloc() to be able to set node and alignment should a user
need to do so.  Rename the function to vrealloc_node_align() to better
match what it actually does now and introduce macros for vrealloc() and
friends for backward compatibility.

With that change we also provide the ability for the Rust part of the
kernel to set node and alignment in its allocations.

Link: https://lkml.kernel.org/r/20250806124034.1724515-1-vitaly.wool@konsulko.se
Link: https://lkml.kernel.org/r/20250806124108.1724561-1-vitaly.wool@konsulko.se
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   12 +++++++++---
 mm/nommu.c              |    3 ++-
 mm/vmalloc.c            |   29 ++++++++++++++++++++++++-----
 3 files changed, 35 insertions(+), 9 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/include/linux/vmalloc.h
@@ -197,9 +197,15 @@ extern void *__vcalloc_noprof(size_t n,
 extern void *vcalloc_noprof(size_t n, size_t size) __alloc_size(1, 2);
 #define vcalloc(...)		alloc_hooks(vcalloc_noprof(__VA_ARGS__))
 
-void * __must_check vrealloc_noprof(const void *p, size_t size, gfp_t flags)
-		__realloc_size(2);
-#define vrealloc(...)		alloc_hooks(vrealloc_noprof(__VA_ARGS__))
+void *__must_check vrealloc_node_align_noprof(const void *p, size_t size,
+		unsigned long align, gfp_t flags, int nid) __realloc_size(2);
+#define vrealloc_node_noprof(_p, _s, _f, _nid)	\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, _nid)
+#define vrealloc_noprof(_p, _s, _f)		\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, NUMA_NO_NODE)
+#define vrealloc_node_align(...)		alloc_hooks(vrealloc_node_align_noprof(__VA_ARGS__))
+#define vrealloc_node(...)			alloc_hooks(vrealloc_node_noprof(__VA_ARGS__))
+#define vrealloc(...)				alloc_hooks(vrealloc_noprof(__VA_ARGS__))
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
--- a/mm/nommu.c~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/mm/nommu.c
@@ -119,7 +119,8 @@ void *__vmalloc_noprof(unsigned long siz
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int node)
 {
 	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
--- a/mm/vmalloc.c~mm-vmalloc-allow-to-set-node-and-align-in-vrealloc
+++ a/mm/vmalloc.c
@@ -4089,19 +4089,29 @@ void *vzalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc - reallocate virtually contiguous memory; contents remain unchanged
+ * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
+ * @align: requested alignment
  * @flags: the flags for the page level allocator
+ * @nid: node number of the target node
  *
- * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
- * @p is not a %NULL pointer, the object pointed to is freed.
+ * If @p is %NULL, vrealloc_XXX() behaves exactly like vmalloc_XXX(). If @size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
+ *
+ * If the caller wants the new memory to be on specific node *only*,
+ * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
+ * reallocation and possibly disregard the specified @nid.
  *
  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
  * initial memory allocation, every subsequent call to this API for the same
  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
  * __GFP_ZERO is not fully honored by this API.
  *
+ * Requesting an alignment that is bigger than the alignment of the existing
+ * allocation will fail.
+ *
  * In any case, the contents of the object pointed to are preserved up to the
  * lesser of the new and old sizes.
  *
@@ -4111,7 +4121,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int nid)
 {
 	struct vm_struct *vm = NULL;
 	size_t alloced_size = 0;
@@ -4135,6 +4146,12 @@ void *vrealloc_noprof(const void *p, siz
 		if (WARN(alloced_size < old_size,
 			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
 			return NULL;
+		if (WARN(!IS_ALIGNED((unsigned long)p, align),
+			 "will not reallocate with a bigger alignment (0x%lx)\n", align))
+			return NULL;
+		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+			     nid != page_to_nid(vmalloc_to_page(p)))
+			goto need_realloc;
 	}
 
 	/*
@@ -4165,8 +4182,10 @@ void *vrealloc_noprof(const void *p, siz
 		return (void *)p;
 	}
 
+need_realloc:
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
-	n = __vmalloc_noprof(size, flags);
+	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
+
 	if (!n)
 		return NULL;
 
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch
mm-slub-allow-to-set-node-and-align-in-krealloc.patch
rust-add-support-for-numa-ids-in-allocations.patch
rust-support-large-alignments-in-allocations.patch

