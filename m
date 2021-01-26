Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C599EC4332B
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B07F206C3
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhA0Csm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbhAZU6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 15:58:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEAF0221ED;
        Tue, 26 Jan 2021 20:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611694663;
        bh=smFPW8iwBk9eV3SxvpJeL4oWf3klGrzuhBiV+LxtIyA=;
        h=Date:From:To:Subject:From;
        b=VttdHDf0PUdMyyTNHl13ErmDkH/HSJ5cHde92sEih3Zm3/G5rvrKU9QR8EsRaNymY
         HGIhXHfIA05UWMEGL/XKUKWRRGJBleWn1/GeLXKQbobgHYdqWr+F9O+uiPRcPppuHe
         QIdFmbfERgznM56aJnmPsgXaSACBG40ijVs5xGa4=
Date:   Tue, 26 Jan 2021 12:57:42 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, nborisov@suse.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-remove-ctor-argument-from-kmem_cache_flags.patch
 added to -mm tree
Message-ID: <20210126205742.4VdQFuAEL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sl?b.c: remove ctor argument from kmem_cache_flags
has been added to the -mm tree.  Its filename is
     mm-remove-ctor-argument-from-kmem_cache_flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-ctor-argument-from-kmem_cache_flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-ctor-argument-from-kmem_cache_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: mm/sl?b.c: remove ctor argument from kmem_cache_flags

This argument hasn't been used since e153362a50a3 ("slub: Remove objsize
check in kmem_cache_flags()") so simply remove it.

Link: https://lkml.kernel.org/r/20210126095733.974665-1-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    3 +--
 mm/slab.h        |    6 ++----
 mm/slab_common.c |    2 +-
 mm/slub.c        |    9 +++------
 4 files changed, 7 insertions(+), 13 deletions(-)

--- a/mm/slab.c~mm-remove-ctor-argument-from-kmem_cache_flags
+++ a/mm/slab.c
@@ -1790,8 +1790,7 @@ static int __ref setup_cpu_cache(struct
 }
 
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
--- a/mm/slab_common.c~mm-remove-ctor-argument-from-kmem_cache_flags
+++ a/mm/slab_common.c
@@ -197,7 +197,7 @@ struct kmem_cache *find_mergeable(unsign
 	size = ALIGN(size, sizeof(void *));
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
-	flags = kmem_cache_flags(size, flags, name, NULL);
+	flags = kmem_cache_flags(size, flags, name);
 
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
--- a/mm/slab.h~mm-remove-ctor-argument-from-kmem_cache_flags
+++ a/mm/slab.h
@@ -110,8 +110,7 @@ __kmem_cache_alias(const char *name, uns
 		   slab_flags_t flags, void (*ctor)(void *));
 
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *));
+	slab_flags_t flags, const char *name);
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
@@ -119,8 +118,7 @@ __kmem_cache_alias(const char *name, uns
 { return NULL; }
 
 static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
--- a/mm/slub.c~mm-remove-ctor-argument-from-kmem_cache_flags
+++ a/mm/slub.c
@@ -1400,7 +1400,6 @@ __setup("slub_debug", setup_slub_debug);
  * @object_size:	the size of an object without meta data
  * @flags:		flags to set
  * @name:		name of the cache
- * @ctor:		constructor function
  *
  * Debug option(s) are applied to @flags. In addition to the debug
  * option(s), if a slab name (or multiple) is specified i.e.
@@ -1408,8 +1407,7 @@ __setup("slub_debug", setup_slub_debug);
  * then only the select slabs will receive the debug option(s).
  */
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	char *iter;
 	size_t len;
@@ -1474,8 +1472,7 @@ static inline void add_full(struct kmem_
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct page *page) {}
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
@@ -3783,7 +3780,7 @@ static int calculate_sizes(struct kmem_c
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
-	s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
+	s->flags = kmem_cache_flags(s->size, flags, s->name);
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	s->random = get_random_long();
 #endif
_

Patches currently in -mm which might be from nborisov@suse.com are

mm-remove-ctor-argument-from-kmem_cache_flags.patch

