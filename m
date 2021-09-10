Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723F0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E59610C8
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhIJDLa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4C5600CC;
        Fri, 10 Sep 2021 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243420;
        bh=hPD1l1wUuvNnQPDgwGPphhegJoVpEj3nxxZk0beiLsE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OFUZcj1Bkkfgz7vXX3nRnhFISWzKVnkv5hCaFn1BejTsJNqvNeSnr2Fib3kvKOibs
         RcBpZvnkZAYqljf9Eb+ryLAGyy7bKd0JrRez0nOvqDf+H/TeSlGZF3OF3KTOhZhu2L
         PbskLR5Ne75Wr+hxV/wSsuDfyrOm4LIicS4k5M0M=
Date:   Thu, 09 Sep 2021 20:10:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org
Subject:  [patch 1/9] mm: move kvmalloc-related functions to slab.h
Message-ID: <20210910031019.juzhhYhMP%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move kvmalloc-related functions to slab.h

Not all files in the kernel should include mm.h.  Migrating callers from
kmalloc to kvmalloc is easier if the kvmalloc functions are in slab.h.

[akpm@linux-foundation.org: move the new kvrealloc() also]
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
 include/linux/mm.h   |   34 ----------------------------------
 include/linux/slab.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 34 deletions(-)

--- a/drivers/of/kexec.c~mm-move-kvmalloc-related-functions-to-slabh
+++ a/drivers/of/kexec.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #define RNG_SEED_SIZE		128
--- a/include/linux/mm.h~mm-move-kvmalloc-related-functions-to-slabh
+++ a/include/linux/mm.h
@@ -799,40 +799,6 @@ static inline int is_vmalloc_or_module_a
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
-extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
-		gfp_t flags);
-extern void kvfree(const void *addr);
-extern void kvfree_sensitive(const void *addr, size_t len);
-
 static inline int head_compound_mapcount(struct page *head)
 {
 	return atomic_read(compound_mapcount_ptr(head)) + 1;
--- a/include/linux/slab.h~mm-move-kvmalloc-related-functions-to-slabh
+++ a/include/linux/slab.h
@@ -732,6 +732,40 @@ static inline void *kzalloc_node(size_t
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
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
+extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
+		gfp_t flags);
+extern void kvfree(const void *addr);
+extern void kvfree_sensitive(const void *addr, size_t len);
+
 unsigned int kmem_cache_size(struct kmem_cache *s);
 void __init kmem_cache_init_late(void);
 
_
