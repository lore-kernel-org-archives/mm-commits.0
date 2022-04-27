Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40B1C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 20:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiD0UdU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbiD0Uc7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 16:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA065B3C45
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 13:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D1A61D1D
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 20:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B9FC385AA;
        Wed, 27 Apr 2022 20:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651091384;
        bh=fOH9DilZ8jS73ym0EDEns2xVCNaBBs3YB0YnA9eilM4=;
        h=Date:To:From:Subject:From;
        b=giYjwqLDeDFL2RCJkP8k2IdK2AnC8rVjgd/nM0sK2gVL/7tydX6hR1kRJf9SLjIf3
         n+/HP0DpSu2sD1ygfMaOMHuW5vCR7FgHO7Oi7d5CsEVog+a1CWabzJpIwaEK26LRc+
         AQLU5mIP60mxJbgzIvwYcqTD8Jl9RtmMQqh7CRIg=
Date:   Wed, 27 Apr 2022 13:29:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, ryabinin.a.a@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        keescook@chromium.org, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, glider@google.com,
        ebiederm@xmission.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-minimum-slab-alignment-a-runtime-property.patch added to -mm tree
Message-Id: <20220427202944.95B9FC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make minimum slab alignment a runtime property
has been added to the -mm tree.  Its filename is
     mm-make-minimum-slab-alignment-a-runtime-property.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-minimum-slab-alignment-a-runtime-property.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-minimum-slab-alignment-a-runtime-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: make minimum slab alignment a runtime property

When CONFIG_KASAN_HW_TAGS is enabled we currently increase the minimum
slab alignment to 16.  This happens even if MTE is not supported in
hardware or disabled via kasan=off, which creates an unnecessary memory
overhead in those cases.  Eliminate this overhead by making the minimum
slab alignment a runtime property and only aligning to 16 if KASAN is
enabled at runtime.

On a DragonBoard 845c (non-MTE hardware) with a kernel built with
CONFIG_KASAN_HW_TAGS, waiting for quiescence after a full Android boot I
see the following Slab measurements in /proc/meminfo (median of 3
reboots):

Before: 169020 kB
After:  167304 kB

Link: https://linux-review.googlesource.com/id/I752e725179b43b144153f4b6f584ceb646473ead
Link: https://lkml.kernel.org/r/20220427195820.1716975-2-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cache.h |   17 ++++++++++++-----
 include/linux/slab.h           |   12 ++++++++++++
 mm/slab.c                      |    7 +++----
 mm/slab_common.c               |    3 +--
 mm/slob.c                      |    6 +++---
 5 files changed, 31 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/cache.h~mm-make-minimum-slab-alignment-a-runtime-property
+++ a/arch/arm64/include/asm/cache.h
@@ -6,6 +6,7 @@
 #define __ASM_CACHE_H
 
 #include <asm/cputype.h>
+#include <asm/mte-def.h>
 
 #define CTR_L1IP_SHIFT		14
 #define CTR_L1IP_MASK		3
@@ -49,16 +50,22 @@
  */
 #define ARCH_DMA_MINALIGN	(128)
 
+#ifndef __ASSEMBLY__
+
+#include <linux/bitops.h>
+#include <linux/kasan-enabled.h>
+
 #ifdef CONFIG_KASAN_SW_TAGS
 #define ARCH_SLAB_MINALIGN	(1ULL << KASAN_SHADOW_SCALE_SHIFT)
 #elif defined(CONFIG_KASAN_HW_TAGS)
-#define ARCH_SLAB_MINALIGN	MTE_GRANULE_SIZE
+static inline size_t arch_slab_minalign(void)
+{
+	return kasan_hw_tags_enabled() ? MTE_GRANULE_SIZE :
+					 __alignof__(unsigned long long);
+}
+#define arch_slab_minalign() arch_slab_minalign()
 #endif
 
-#ifndef __ASSEMBLY__
-
-#include <linux/bitops.h>
-
 #define ICACHEF_ALIASING	0
 #define ICACHEF_VPIPT		1
 extern unsigned long __icache_flags;
--- a/include/linux/slab.h~mm-make-minimum-slab-alignment-a-runtime-property
+++ a/include/linux/slab.h
@@ -210,6 +210,18 @@ void kmem_dump_obj(void *object);
 #endif
 
 /*
+ * Arches can define this function if they want to decide the minimum slab
+ * alignment at runtime. The value returned by the function must be a power
+ * of two and >= ARCH_SLAB_MINALIGN.
+ */
+#ifndef arch_slab_minalign
+static inline size_t arch_slab_minalign(void)
+{
+	return ARCH_SLAB_MINALIGN;
+}
+#endif
+
+/*
  * kmalloc and friends return ARCH_KMALLOC_MINALIGN aligned
  * pointers. kmem_cache_alloc and friends return ARCH_SLAB_MINALIGN
  * aligned pointers.
--- a/mm/slab.c~mm-make-minimum-slab-alignment-a-runtime-property
+++ a/mm/slab.c
@@ -3009,10 +3009,9 @@ static void *cache_alloc_debugcheck_afte
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
-	if (ARCH_SLAB_MINALIGN &&
-	    ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1))) {
-		pr_err("0x%px: not aligned to ARCH_SLAB_MINALIGN=%d\n",
-		       objp, (int)ARCH_SLAB_MINALIGN);
+	if ((unsigned long)objp & (arch_slab_minalign() - 1)) {
+		pr_err("0x%px: not aligned to arch_slab_minalign()=%d\n", objp,
+		       (int)arch_slab_minalign());
 	}
 	return objp;
 }
--- a/mm/slab_common.c~mm-make-minimum-slab-alignment-a-runtime-property
+++ a/mm/slab_common.c
@@ -154,8 +154,7 @@ static unsigned int calculate_alignment(
 		align = max(align, ralign);
 	}
 
-	if (align < ARCH_SLAB_MINALIGN)
-		align = ARCH_SLAB_MINALIGN;
+	align = max_t(size_t, align, arch_slab_minalign());
 
 	return ALIGN(align, sizeof(void *));
 }
--- a/mm/slob.c~mm-make-minimum-slab-alignment-a-runtime-property
+++ a/mm/slob.c
@@ -478,7 +478,7 @@ static __always_inline void *
 __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 {
 	unsigned int *m;
-	int minalign = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	int minalign = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
 	void *ret;
 
 	gfp &= gfp_allowed_mask;
@@ -555,7 +555,7 @@ void kfree(const void *block)
 
 	sp = virt_to_folio(block);
 	if (folio_test_slab(sp)) {
-		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
 	} else {
@@ -584,7 +584,7 @@ size_t __ksize(const void *block)
 	if (unlikely(!folio_test_slab(folio)))
 		return folio_size(folio);
 
-	align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	align = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
 	m = (unsigned int *)(block - align);
 	return SLOB_UNITS(*m) * SLOB_UNIT;
 }
_

Patches currently in -mm which might be from pcc@google.com are

printk-stop-including-cacheh-from-printkh.patch
mm-make-minimum-slab-alignment-a-runtime-property.patch

