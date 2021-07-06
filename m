Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A119BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D62861C82
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhGFTLn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbhGFTLn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAFD261C87;
        Tue,  6 Jul 2021 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598544;
        bh=h1JGXbzSvWdIgwM3wrnTPPu8QGo4aT+dQly/fuY+Usc=;
        h=Date:From:To:Subject:From;
        b=KirjdZ48bbG+d7+ftI44pfgLGr9izotAhZEXBhLHpGpws+3G+VoSSUvkAD48eNCkt
         aMHh+H0DLvJCNcIU+n93P1TTjLnkfVOECq6/bF3705+JK5JiMB6tcaojQgu5zfFBDS
         8AN95p8P5laB3Ndwe+sj216YbJ59jYEKXKQKGIgA=
Date:   Tue, 06 Jul 2021 12:09:03 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, elver@google.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
 removed from -mm tree
Message-ID: <20210706190903.Fh8lHQsEa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time
has been removed from the -mm tree.  Its filename was
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: change run-time assertion in kmalloc_index() to compile-time

Currently when size is not supported by kmalloc_index, compiler will
generate a run-time BUG() while compile-time error is also possible, and
better.  So change BUG to BUILD_BUG_ON_MSG to make compile-time check
possible.

Also remove code that allocates more than 32MB because current
implementation supports only up to 32MB.

[42.hyeyoo@gmail.com: fix support for clang 10]
  Link: https://lkml.kernel.org/r/20210518181247.GA10062@hyeyoo
[vbabka@suse.cz: fix false-positive assert in kernel/bpf/local_storage.c]
  Link: https://lkml.kernel.org/r/bea97388-01df-8eac-091b-a3c89b4a4a09@suse.czLink: https://lkml.kernel.org/r/20210511173448.GA54466@hyeyoo
[elver@google.com: kfence fix]
  Link: https://lkml.kernel.org/r/20210512195227.245000695c9014242e9a00e5@linux-foundation.org
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h    |   17 ++++++++++++++---
 mm/kfence/kfence_test.c |    5 +++--
 mm/slab_common.c        |    7 +++----
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/include/linux/slab.h
@@ -346,8 +346,14 @@ static __always_inline enum kmalloc_cach
  * 1 =  65 .. 96 bytes
  * 2 = 129 .. 192 bytes
  * n = 2^(n-1)+1 .. 2^n
+ *
+ * Note: __kmalloc_index() is compile-time optimized, and not runtime optimized;
+ * typical usage is via kmalloc_index() and therefore evaluated at compile-time.
+ * Callers where !size_is_constant should only be test modules, where runtime
+ * overheads of __kmalloc_index() can be tolerated.  Also see kmalloc_slab().
  */
-static __always_inline unsigned int kmalloc_index(size_t size)
+static __always_inline unsigned int __kmalloc_index(size_t size,
+						    bool size_is_constant)
 {
 	if (!size)
 		return 0;
@@ -382,12 +388,17 @@ static __always_inline unsigned int kmal
 	if (size <=  8 * 1024 * 1024) return 23;
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
-	if (size <=  64 * 1024 * 1024) return 26;
-	BUG();
+
+	if ((IS_ENABLED(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 110000)
+	    && !IS_ENABLED(CONFIG_PROFILE_ALL_BRANCHES) && size_is_constant)
+		BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
+	else
+		BUG();
 
 	/* Will never be reached. Needed because the compiler may complain */
 	return -1;
 }
+#define kmalloc_index(s) __kmalloc_index(s, true)
 #endif /* !CONFIG_SLOB */
 
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
--- a/mm/kfence/kfence_test.c~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/mm/kfence/kfence_test.c
@@ -197,7 +197,7 @@ static void test_cache_destroy(void)
 
 static inline size_t kmalloc_cache_alignment(size_t size)
 {
-	return kmalloc_caches[kmalloc_type(GFP_KERNEL)][kmalloc_index(size)]->align;
+	return kmalloc_caches[kmalloc_type(GFP_KERNEL)][__kmalloc_index(size, false)]->align;
 }
 
 /* Must always inline to match stack trace against caller. */
@@ -267,7 +267,8 @@ static void *test_alloc(struct kunit *te
 
 		if (is_kfence_address(alloc)) {
 			struct page *page = virt_to_head_page(alloc);
-			struct kmem_cache *s = test_cache ?: kmalloc_caches[kmalloc_type(GFP_KERNEL)][kmalloc_index(size)];
+			struct kmem_cache *s = test_cache ?:
+					kmalloc_caches[kmalloc_type(GFP_KERNEL)][__kmalloc_index(size, false)];
 
 			/*
 			 * Verify that various helpers return the right values
--- a/mm/slab_common.c~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time
+++ a/mm/slab_common.c
@@ -754,8 +754,8 @@ struct kmem_cache *kmalloc_slab(size_t s
 
 /*
  * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
- * kmalloc_index() supports up to 2^26=64MB, so the final entry of the table is
- * kmalloc-67108864.
+ * kmalloc_index() supports up to 2^25=32MB, so the final entry of the table is
+ * kmalloc-32M.
  */
 const struct kmalloc_info_struct kmalloc_info[] __initconst = {
 	INIT_KMALLOC_INFO(0, 0),
@@ -783,8 +783,7 @@ const struct kmalloc_info_struct kmalloc
 	INIT_KMALLOC_INFO(4194304, 4M),
 	INIT_KMALLOC_INFO(8388608, 8M),
 	INIT_KMALLOC_INFO(16777216, 16M),
-	INIT_KMALLOC_INFO(33554432, 32M),
-	INIT_KMALLOC_INFO(67108864, 64M)
+	INIT_KMALLOC_INFO(33554432, 32M)
 };
 
 /*
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


