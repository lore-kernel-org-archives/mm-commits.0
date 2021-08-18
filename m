Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E7CC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A477610CF
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbhHRXTo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 19:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234771AbhHRXTo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 19:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7CE8610CD;
        Wed, 18 Aug 2021 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629328749;
        bh=7elkcS9e7zrmuEKgz2Ng67CR52MHSKi0tHP4B7yUDiw=;
        h=Date:From:To:Subject:From;
        b=VrrHJQexh4oQ3jAQsFmGZjQO0hgK/qhs70kwS9xQjEsX1YPcEbuJyGvlExBc3RLTW
         A9TbrpSmDSeV/4ndJ3642TiyxHu5IBkR2wYBMf/oMdFTafCIqAlKzBJ/KFNgv14QR6
         AiRoty4RqLTQ4Za6KymXHPHvwTyQWsZ1LprWOm34=
Date:   Wed, 18 Aug 2021 16:19:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org,
        rientjes@google.com, penberg@kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org,
        lukas.bulwahn@gmail.com, joe@perches.com, iamjoonsoo.kim@lge.com,
        dwaipayanray1@gmail.com, dennis@kernel.org, danielmicay@gmail.com,
        cl@linux.com, apw@canonical.com, keescook@chromium.org
Subject:  +
 slab-add-__alloc_size-attributes-for-better-bounds-checking.patch added to
 -mm tree
Message-ID: <20210818231908.qLVHh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slab: add __alloc_size attributes for better bounds checking
has been added to the -mm tree.  Its filename is
     slab-add-__alloc_size-attributes-for-better-bounds-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slab-add-__alloc_size-attributes-for-better-bounds-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: slab: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for regular
kmalloc interfaces, to provide additional hinting for better bounds
checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210818214021.2476230-5-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
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
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/slab.h~slab-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/slab.h
@@ -181,7 +181,7 @@ int kmem_cache_shrink(struct kmem_cache
 /*
  * Common kmalloc functions provided by all allocators
  */
-__must_check
+__must_check __alloc_size(2)
 void *krealloc(const void *objp, size_t new_size, gfp_t flags);
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
@@ -426,6 +426,7 @@ static __always_inline unsigned int __km
 #define kmalloc_index(s) __kmalloc_index(s, true)
 #endif /* !CONFIG_SLOB */
 
+__alloc_size(1)
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_kmalloc_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *s, void *objp);
@@ -450,6 +451,7 @@ static __always_inline void kfree_bulk(s
 }
 
 #ifdef CONFIG_NUMA
+__alloc_size(1)
 void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_slab_alignment __malloc;
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t flags, int node)
 			    __assume_slab_alignment __malloc;
@@ -574,6 +576,7 @@ static __always_inline void *kmalloc_lar
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
+__alloc_size(1)
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
@@ -596,6 +599,7 @@ static __always_inline void *kmalloc(siz
 	return __kmalloc(size, flags);
 }
 
+__alloc_size(1)
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 #ifndef CONFIG_SLOB
@@ -620,6 +624,7 @@ static __always_inline void *kmalloc_nod
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
+__alloc_size(1, 2)
 static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	size_t bytes;
@@ -638,7 +643,7 @@ static inline void *kmalloc_array(size_t
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
  */
-__must_check
+__must_check __alloc_size(2, 3)
 static inline void *krealloc_array(void *p, size_t new_n, size_t new_size,
 				   gfp_t flags)
 {
@@ -656,6 +661,7 @@ static inline void *krealloc_array(void
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
+__alloc_size(1, 2)
 static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
 {
 	return kmalloc_array(n, size, flags | __GFP_ZERO);
@@ -685,6 +691,7 @@ static inline void *kmalloc_array_node(s
 	return __kmalloc_node(bytes, flags, node);
 }
 
+__alloc_size(1, 2)
 static inline void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
 {
 	return kmalloc_array_node(n, size, flags | __GFP_ZERO, node);
@@ -718,6 +725,7 @@ static inline void *kmem_cache_zalloc(st
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
+__alloc_size(1)
 static inline void *kzalloc(size_t size, gfp_t flags)
 {
 	return kmalloc(size, flags | __GFP_ZERO);
@@ -729,25 +737,31 @@ static inline void *kzalloc(size_t size,
  * @flags: the type of memory to allocate (see kmalloc).
  * @node: memory node from which to allocate
  */
+__alloc_size(1)
 static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 {
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+__alloc_size(1)
 extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
+__alloc_size(1)
 static inline void *kvmalloc(size_t size, gfp_t flags)
 {
 	return kvmalloc_node(size, flags, NUMA_NO_NODE);
 }
+__alloc_size(1)
 static inline void *kvzalloc_node(size_t size, gfp_t flags, int node)
 {
 	return kvmalloc_node(size, flags | __GFP_ZERO, node);
 }
+__alloc_size(1)
 static inline void *kvzalloc(size_t size, gfp_t flags)
 {
 	return kvmalloc(size, flags | __GFP_ZERO);
 }
 
+__alloc_size(1, 2)
 static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	size_t bytes;
@@ -758,11 +772,13 @@ static inline void *kvmalloc_array(size_
 	return kvmalloc(bytes, flags);
 }
 
+__alloc_size(1, 2)
 static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 {
 	return kvmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
+__alloc_size(3)
 extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
 		gfp_t flags);
 extern void kvfree(const void *addr);
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

