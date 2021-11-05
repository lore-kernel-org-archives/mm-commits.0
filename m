Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F2AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E4E61252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhKEUjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUjI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46F961262;
        Fri,  5 Nov 2021 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144588;
        bh=akYYhH0iJKPVWEkI9sNv9gAHAI6WfT9k0FloR+hb1yM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nocvR7TCxybtWS0lBGkBE4jGuDdrHA6OfJyh4MznRQF7PBJxokVSHgqV8IsFjbM1s
         jsVsKWkBFf9cFTuYDEhUSdLZN9RU4cPBCbLJWoHxFuRAy8KQhvsXx1NOIC6ALV1Euf
         s9zfsrWTQQTaZvthrkjBkwc3diAYVT5zVrHqg1Io=
Date:   Fri, 05 Nov 2021 13:36:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com, apw@canonical.com,
        cl@linux.com, danielmicay@gmail.com, dennis@kernel.org,
        dwaipayanray1@gmail.com, gustavoars@kernel.org,
        iamjoonsoo.kim@lge.com, ira.weiny@intel.com, jhubbard@nvidia.com,
        jingxiangfeng@huawei.com, joe@perches.com, jrdr.linux@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org, lkp@intel.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 035/262] slab: add __alloc_size attributes for
 better bounds checking
Message-ID: <20211105203627.piXTTUwEo%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: slab: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for regular
kmalloc interfaces, to provide additional hinting for better bounds
checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210930222704.2631604-5-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   61 ++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

--- a/include/linux/slab.h~slab-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/slab.h
@@ -181,7 +181,7 @@ int kmem_cache_shrink(struct kmem_cache
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags);
+void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
@@ -425,7 +425,7 @@ static __always_inline unsigned int __km
 #define kmalloc_index(s) __kmalloc_index(s, true)
 #endif /* !CONFIG_SLOB */
 
-void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
+void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __alloc_size(1);
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_slab_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
@@ -449,11 +449,12 @@ static __always_inline void kfree_bulk(s
 }
 
 #ifdef CONFIG_NUMA
-void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment __malloc;
+void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment
+							 __alloc_size(1);
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t flags, int node) __assume_slab_alignment
 									 __malloc;
 #else
-static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline __alloc_size(1) void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __kmalloc(size, flags);
 }
@@ -466,23 +467,23 @@ static __always_inline void *kmem_cache_
 
 #ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t flags, size_t size)
-				   __assume_slab_alignment __malloc;
+				   __assume_slab_alignment __alloc_size(3);
 
 #ifdef CONFIG_NUMA
 extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s, gfp_t gfpflags,
-					 int node, size_t size) __assume_slab_alignment __malloc;
+					 int node, size_t size) __assume_slab_alignment
+								__alloc_size(4);
 #else
-static __always_inline void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
-							 gfp_t gfpflags, int node,
-							 size_t size)
+static __always_inline __alloc_size(4) void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
+						 gfp_t gfpflags, int node, size_t size)
 {
 	return kmem_cache_alloc_trace(s, gfpflags, size);
 }
 #endif /* CONFIG_NUMA */
 
 #else /* CONFIG_TRACING */
-static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t flags,
-						    size_t size)
+static __always_inline __alloc_size(3) void *kmem_cache_alloc_trace(struct kmem_cache *s,
+								    gfp_t flags, size_t size)
 {
 	void *ret = kmem_cache_alloc(s, flags);
 
@@ -501,19 +502,20 @@ static __always_inline void *kmem_cache_
 #endif /* CONFIG_TRACING */
 
 extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment
-									 __malloc;
+									 __alloc_size(1);
 
 #ifdef CONFIG_TRACING
 extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
-				__assume_page_alignment __malloc;
+				__assume_page_alignment __alloc_size(1);
 #else
-static __always_inline void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
+static __always_inline __alloc_size(1) void *kmalloc_order_trace(size_t size, gfp_t flags,
+								 unsigned int order)
 {
 	return kmalloc_order(size, flags, order);
 }
 #endif
 
-static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *kmalloc_large(size_t size, gfp_t flags)
 {
 	unsigned int order = get_order(size);
 	return kmalloc_order_trace(size, flags, order);
@@ -573,7 +575,7 @@ static __always_inline void *kmalloc_lar
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
-static __always_inline void *kmalloc(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
 #ifndef CONFIG_SLOB
@@ -595,7 +597,7 @@ static __always_inline void *kmalloc(siz
 	return __kmalloc(size, flags);
 }
 
-static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline __alloc_size(1) void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 #ifndef CONFIG_SLOB
 	if (__builtin_constant_p(size) &&
@@ -619,7 +621,7 @@ static __always_inline void *kmalloc_nod
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	size_t bytes;
 
@@ -637,8 +639,10 @@ static inline void *kmalloc_array(size_t
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
  */
-static inline void * __must_check krealloc_array(void *p, size_t new_n, size_t new_size,
-						 gfp_t flags)
+static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
+								    size_t new_n,
+								    size_t new_size,
+								    gfp_t flags)
 {
 	size_t bytes;
 
@@ -654,7 +658,7 @@ static inline void * __must_check kreall
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flags)
 {
 	return kmalloc_array(n, size, flags | __GFP_ZERO);
 }
@@ -667,12 +671,13 @@ static inline void *kcalloc(size_t n, si
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
+extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
+				   __alloc_size(1);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 
-static inline void *kmalloc_array_node(size_t n, size_t size, gfp_t flags,
-				       int node)
+static inline __alloc_size(1, 2) void *kmalloc_array_node(size_t n, size_t size, gfp_t flags,
+							  int node)
 {
 	size_t bytes;
 
@@ -683,7 +688,7 @@ static inline void *kmalloc_array_node(s
 	return __kmalloc_node(bytes, flags, node);
 }
 
-static inline void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
+static inline __alloc_size(1, 2) void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
 {
 	return kmalloc_array_node(n, size, flags | __GFP_ZERO, node);
 }
@@ -691,7 +696,7 @@ static inline void *kcalloc_node(size_t
 
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
-					 unsigned long caller);
+					 unsigned long caller) __alloc_size(1);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			_RET_IP_)
@@ -716,7 +721,7 @@ static inline void *kmem_cache_zalloc(st
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline void *kzalloc(size_t size, gfp_t flags)
+static inline __alloc_size(1) void *kzalloc(size_t size, gfp_t flags)
 {
 	return kmalloc(size, flags | __GFP_ZERO);
 }
@@ -727,7 +732,7 @@ static inline void *kzalloc(size_t size,
  * @flags: the type of memory to allocate (see kmalloc).
  * @node: memory node from which to allocate
  */
-static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
+static inline __alloc_size(1) void *kzalloc_node(size_t size, gfp_t flags, int node)
 {
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
_
