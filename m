Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5B3C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08E06187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhKKCmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A70EB61872;
        Thu, 11 Nov 2021 02:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598384;
        bh=iX9DAo0X5JWBxzLuVg1AWMEbr14Rw5iMxoxFCdofRIM=;
        h=Date:From:To:Subject:From;
        b=FjxxA8DNN8UZP4RMGcqy9v7c+wjZkECI95KKAZz9xpIhYgj1LInTFFuN+4EIcWGrM
         QsXNmc+mkj1QGIywP1/FrfhHzbQJ6v90VYpwfn9u/l0S5FTihmzNXTG06dfsyEAZ1E
         J3TN5dBVQdLdpgtMvi6QAA2mO1F809Lw95kjmNkY=
Date:   Wed, 10 Nov 2021 18:39:44 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-move-kvmalloc-related-functions-to-slabh.patch removed from -mm tree
Message-ID: <20211111023944.83jaNQpEE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move kvmalloc-related functions to slab.h
has been removed from the -mm tree.  Its filename was
     mm-move-kvmalloc-related-functions-to-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move kvmalloc-related functions to slab.h

Not all files in the kernel should include mm.h.  Migrating callers from
kmalloc to kvmalloc is easier if the kvmalloc functions are in slab.h.

[akpm@linux-foundation.org: move the new kvrealloc() also]
[akpm@linux-foundation.org: drivers/hwmon/occ/p9_sbe.c needs slab.h]
Link: https://lkml.kernel.org/r/20210622215757.3525604-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/occ/p9_sbe.c |    1 +
 drivers/of/kexec.c         |    1 +
 include/linux/mm.h         |   34 ----------------------------------
 include/linux/slab.h       |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 34 deletions(-)

--- a/drivers/hwmon/occ/p9_sbe.c~mm-move-kvmalloc-related-functions-to-slabh
+++ a/drivers/hwmon/occ/p9_sbe.c
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/fsi-occ.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
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

Patches currently in -mm which might be from willy@infradead.org are

hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

