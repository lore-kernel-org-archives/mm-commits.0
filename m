Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3D3C07E95
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4069613DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhGPEXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 00:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhGPEXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 00:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979766128C;
        Fri, 16 Jul 2021 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626409206;
        bh=7uVrSb5zeY0IEEx0sBuXHTRkVooH7aYSplp1y6miPCk=;
        h=Date:From:To:Subject:From;
        b=oNWSTYxzjF/W2CJKCEgQGpAAFbElH36P5+8TpDl6BhkUDNjZldosHXpGcUugTKZqe
         0xx10GrqDjxU9wkPXw004+8oda8mFf3E+gMB72s2q+qaP+hQ7JkwsbUUSv3J520BF5
         +FiU5v0WZKlnzNBNzLUI/DANXVfpaX8VQbh6QQY4=
Date:   Thu, 15 Jul 2021 21:20:06 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        willy@infradead.org
Subject:  + mm-move-kvmalloc-related-functions-to-slabh.patch added
 to -mm tree
Message-ID: <20210716042006.mfTg_KFmP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move kvmalloc-related functions to slab.h
has been added to the -mm tree.  Its filename is
     mm-move-kvmalloc-related-functions-to-slabh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-kvmalloc-related-functions-to-slabh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-kvmalloc-related-functions-to-slabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move kvmalloc-related functions to slab.h

Not all files in the kernel should include mm.h.  Migrating callers from
kmalloc to kvmalloc is easier if the kvmalloc functions are in slab.h.

Link: https://lkml.kernel.org/r/20210622215757.3525604-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/kexec.c   |    1 +
 include/linux/mm.h   |   32 --------------------------------
 include/linux/slab.h |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 32 deletions(-)

--- a/drivers/of/kexec.c~mm-move-kvmalloc-related-functions-to-slabh
+++ a/drivers/of/kexec.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 /* relevant device tree properties */
--- a/include/linux/mm.h~mm-move-kvmalloc-related-functions-to-slabh
+++ a/include/linux/mm.h
@@ -800,38 +800,6 @@ static inline int is_vmalloc_or_module_a
 }
 #endif
 
-extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
-static inline void *kvmalloc(size_t size, gfp_t flags)
-{
-	return kvmalloc_node(size, flags, NUMA_NO_NODE);
-}
-static inline void *kvzalloc_node(size_t size, gfp_t flags, int node)
-{
-	return kvmalloc_node(size, flags | __GFP_ZERO, node);
-}
-static inline void *kvzalloc(size_t size, gfp_t flags)
-{
-	return kvmalloc(size, flags | __GFP_ZERO);
-}
-
-static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
-{
-	size_t bytes;
-
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
-		return NULL;
-
-	return kvmalloc(bytes, flags);
-}
-
-static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
-{
-	return kvmalloc_array(n, size, flags | __GFP_ZERO);
-}
-
-extern void kvfree(const void *addr);
-extern void kvfree_sensitive(const void *addr, size_t len);
-
 static inline int head_compound_mapcount(struct page *head)
 {
 	return atomic_read(compound_mapcount_ptr(head)) + 1;
--- a/include/linux/slab.h~mm-move-kvmalloc-related-functions-to-slabh
+++ a/include/linux/slab.h
@@ -732,6 +732,38 @@ static inline void *kzalloc_node(size_t
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+void *kvmalloc_node(size_t size, gfp_t flags, int node);
+static inline void *kvmalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc_node(size, flags, NUMA_NO_NODE);
+}
+static inline void *kvzalloc_node(size_t size, gfp_t flags, int node)
+{
+	return kvmalloc_node(size, flags | __GFP_ZERO, node);
+}
+static inline void *kvzalloc(size_t size, gfp_t flags)
+{
+	return kvmalloc(size, flags | __GFP_ZERO);
+}
+
+static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+
+	return kvmalloc(bytes, flags);
+}
+
+static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kvmalloc_array(n, size, flags | __GFP_ZERO);
+}
+
+void kvfree(const void *addr);
+void kvfree_sensitive(const void *addr, size_t len);
+
 unsigned int kmem_cache_size(struct kmem_cache *s);
 void __init kmem_cache_init_late(void);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-mark-idle-page-tracking-as-broken.patch
avoid-a-warning-in-sparse-memory-support.patch

