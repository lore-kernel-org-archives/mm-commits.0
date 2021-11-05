Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED649C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D733261252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhKEUjE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE399611C0;
        Fri,  5 Nov 2021 20:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144584;
        bh=ar8dKobxy8HRi6pY7W2uldNAH6IQmSYxxrtr3Y0BwT8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=efn4Kzo3CIcZWxzANExckdbfzmWZCxga+S6AxvDyZsyYWnrC6CRxe79orfa1sSFka
         Ges9r0aoQWou4/0LSekFqwNjodIzdg8hedgJjB7R7yjMP9KAe7TqTbJ6DR5rhc2VNy
         3b0Jibstdo1R3VOnw0JqwxuC4lI6fIw4AGu9+uCQ=
Date:   Fri, 05 Nov 2021 13:36:23 -0700
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
Subject:  [patch 034/262] slab: clean up function prototypes
Message-ID: <20211105203623.pP9FyETfE%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: slab: clean up function prototypes

Based on feedback from Joe Perches and Linus Torvalds, regularize the slab
function prototypes before making attribute changes.

Link: https://lkml.kernel.org/r/20210930222704.2631604-4-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   68 ++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

--- a/include/linux/slab.h~slab-clean-up-function-prototypes
+++ a/include/linux/slab.h
@@ -152,8 +152,8 @@ struct kmem_cache *kmem_cache_create_use
 			slab_flags_t flags,
 			unsigned int useroffset, unsigned int usersize,
 			void (*ctor)(void *));
-void kmem_cache_destroy(struct kmem_cache *);
-int kmem_cache_shrink(struct kmem_cache *);
+void kmem_cache_destroy(struct kmem_cache *s);
+int kmem_cache_shrink(struct kmem_cache *s);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
@@ -181,11 +181,11 @@ int kmem_cache_shrink(struct kmem_cache
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc(const void *, size_t, gfp_t);
-void kfree(const void *);
-void kfree_sensitive(const void *);
-size_t __ksize(const void *);
-size_t ksize(const void *);
+void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags);
+void kfree(const void *objp);
+void kfree_sensitive(const void *objp);
+size_t __ksize(const void *objp);
+size_t ksize(const void *objp);
 #ifdef CONFIG_PRINTK
 bool kmem_valid_obj(void *object);
 void kmem_dump_obj(void *object);
@@ -426,8 +426,8 @@ static __always_inline unsigned int __km
 #endif /* !CONFIG_SLOB */
 
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
-void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment __malloc;
-void kmem_cache_free(struct kmem_cache *, void *);
+void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_slab_alignment __malloc;
+void kmem_cache_free(struct kmem_cache *s, void *objp);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
@@ -436,8 +436,8 @@ void kmem_cache_free(struct kmem_cache *
  *
  * Note that interrupts must be enabled when calling these functions.
  */
-void kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
-int kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
+int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size, void **p);
 
 /*
  * Caller must not use kfree_bulk() on memory not originally allocated
@@ -450,7 +450,8 @@ static __always_inline void kfree_bulk(s
 
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment __malloc;
-void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment __malloc;
+void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t flags, int node) __assume_slab_alignment
+									 __malloc;
 #else
 static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -464,25 +465,24 @@ static __always_inline void *kmem_cache_
 #endif
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t) __assume_slab_alignment __malloc;
+extern void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t flags, size_t size)
+				   __assume_slab_alignment __malloc;
 
 #ifdef CONFIG_NUMA
-extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
-					   gfp_t gfpflags,
-					   int node, size_t size) __assume_slab_alignment __malloc;
+extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s, gfp_t gfpflags,
+					 int node, size_t size) __assume_slab_alignment __malloc;
 #else
-static __always_inline void *
-kmem_cache_alloc_node_trace(struct kmem_cache *s,
-			      gfp_t gfpflags,
-			      int node, size_t size)
+static __always_inline void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
+							 gfp_t gfpflags, int node,
+							 size_t size)
 {
 	return kmem_cache_alloc_trace(s, gfpflags, size);
 }
 #endif /* CONFIG_NUMA */
 
 #else /* CONFIG_TRACING */
-static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s,
-		gfp_t flags, size_t size)
+static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t flags,
+						    size_t size)
 {
 	void *ret = kmem_cache_alloc(s, flags);
 
@@ -490,10 +490,8 @@ static __always_inline void *kmem_cache_
 	return ret;
 }
 
-static __always_inline void *
-kmem_cache_alloc_node_trace(struct kmem_cache *s,
-			      gfp_t gfpflags,
-			      int node, size_t size)
+static __always_inline void *kmem_cache_alloc_node_trace(struct kmem_cache *s, gfp_t gfpflags,
+							 int node, size_t size)
 {
 	void *ret = kmem_cache_alloc_node(s, gfpflags, node);
 
@@ -502,13 +500,14 @@ kmem_cache_alloc_node_trace(struct kmem_
 }
 #endif /* CONFIG_TRACING */
 
-extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment
+									 __malloc;
 
 #ifdef CONFIG_TRACING
-extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
+				__assume_page_alignment __malloc;
 #else
-static __always_inline void *
-kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
+static __always_inline void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 {
 	return kmalloc_order(size, flags, order);
 }
@@ -638,8 +637,8 @@ static inline void *kmalloc_array(size_t
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
  */
-static __must_check inline void *
-krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags)
+static inline void * __must_check krealloc_array(void *p, size_t new_n, size_t new_size,
+						 gfp_t flags)
 {
 	size_t bytes;
 
@@ -668,7 +667,7 @@ static inline void *kcalloc(size_t n, si
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
+extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 
@@ -691,7 +690,8 @@ static inline void *kcalloc_node(size_t
 
 
 #ifdef CONFIG_NUMA
-extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
+extern void *__kmalloc_node_track_caller(size_t size, gfp_t flags, int node,
+					 unsigned long caller);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			_RET_IP_)
_
