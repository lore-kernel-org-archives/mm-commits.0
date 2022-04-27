Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FEEC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 20:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiD0UdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbiD0UdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 16:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A66B3DD0
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 13:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C2FF61D1D
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 20:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9D3C385A7;
        Wed, 27 Apr 2022 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651091387;
        bh=dJ/jzWy3o733tHR0ZImR0KhnShrT/UCDvd3RjIAjWrA=;
        h=Date:To:From:Subject:From;
        b=kWnKZxcflIay/o7ftNLoK9fbtiAzl2WyE5ZQMigg5+6NrcO1ecXuC1ob610E0nx3m
         2h5QGgL7pHWlkFQocW9ItVUIZtLiNZfirhegm1CtNsl1A3KJ15S0MRpVTIa/t14u9j
         npsdB46NFlPLZlNRkUmgRHKNY4P1Ik4LrS1k1vtA=
Date:   Wed, 27 Apr 2022 13:29:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, ryabinin.a.a@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        pcc@google.com, keescook@chromium.org, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, glider@google.com,
        ebiederm@xmission.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-minimum-slab-alignment-a-runtime-property-fix.patch added to -mm tree
Message-Id: <20220427202947.BF9D3C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-minimum-slab-alignment-a-runtime-property-fix
has been added to the -mm tree.  Its filename is
     mm-make-minimum-slab-alignment-a-runtime-property-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-minimum-slab-alignment-a-runtime-property-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-minimum-slab-alignment-a-runtime-property-fix

make slab alignment type `unsigned int' to avoid casting

Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cache.h |    2 +-
 include/linux/slab.h           |    2 +-
 mm/slab.c                      |    4 ++--
 mm/slab_common.c               |    2 +-
 mm/slob.c                      |   16 +++++++++++-----
 5 files changed, 16 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/cache.h~mm-make-minimum-slab-alignment-a-runtime-property-fix
+++ a/arch/arm64/include/asm/cache.h
@@ -58,7 +58,7 @@
 #ifdef CONFIG_KASAN_SW_TAGS
 #define ARCH_SLAB_MINALIGN	(1ULL << KASAN_SHADOW_SCALE_SHIFT)
 #elif defined(CONFIG_KASAN_HW_TAGS)
-static inline size_t arch_slab_minalign(void)
+static inline unsigned int arch_slab_minalign(void)
 {
 	return kasan_hw_tags_enabled() ? MTE_GRANULE_SIZE :
 					 __alignof__(unsigned long long);
--- a/include/linux/slab.h~mm-make-minimum-slab-alignment-a-runtime-property-fix
+++ a/include/linux/slab.h
@@ -215,7 +215,7 @@ void kmem_dump_obj(void *object);
  * of two and >= ARCH_SLAB_MINALIGN.
  */
 #ifndef arch_slab_minalign
-static inline size_t arch_slab_minalign(void)
+static inline unsigned int arch_slab_minalign(void)
 {
 	return ARCH_SLAB_MINALIGN;
 }
--- a/mm/slab.c~mm-make-minimum-slab-alignment-a-runtime-property-fix
+++ a/mm/slab.c
@@ -3010,8 +3010,8 @@ static void *cache_alloc_debugcheck_afte
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
 	if ((unsigned long)objp & (arch_slab_minalign() - 1)) {
-		pr_err("0x%px: not aligned to arch_slab_minalign()=%d\n", objp,
-		       (int)arch_slab_minalign());
+		pr_err("0x%px: not aligned to arch_slab_minalign()=%u\n", objp,
+		       arch_slab_minalign());
 	}
 	return objp;
 }
--- a/mm/slab_common.c~mm-make-minimum-slab-alignment-a-runtime-property-fix
+++ a/mm/slab_common.c
@@ -154,7 +154,7 @@ static unsigned int calculate_alignment(
 		align = max(align, ralign);
 	}
 
-	align = max_t(size_t, align, arch_slab_minalign());
+	align = max(align, arch_slab_minalign());
 
 	return ALIGN(align, sizeof(void *));
 }
--- a/mm/slob.c~mm-make-minimum-slab-alignment-a-runtime-property-fix
+++ a/mm/slob.c
@@ -478,9 +478,11 @@ static __always_inline void *
 __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 {
 	unsigned int *m;
-	int minalign = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
+	unsigned int minalign;
 	void *ret;
 
+	minalign = max_t(unsigned int, ARCH_KMALLOC_MINALIGN,
+			 arch_slab_minalign());
 	gfp &= gfp_allowed_mask;
 
 	might_alloc(gfp);
@@ -493,7 +495,7 @@ __do_kmalloc_node(size_t size, gfp_t gfp
 		 * kmalloc()'d objects.
 		 */
 		if (is_power_of_2(size))
-			align = max(minalign, (int) size);
+			align = max_t(unsigned int, minalign, size);
 
 		if (!size)
 			return ZERO_SIZE_PTR;
@@ -555,8 +557,11 @@ void kfree(const void *block)
 
 	sp = virt_to_folio(block);
 	if (folio_test_slab(sp)) {
-		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
+		unsigned int align = max_t(unsigned int,
+					   ARCH_KMALLOC_MINALIGN,
+					   arch_slab_minalign());
 		unsigned int *m = (unsigned int *)(block - align);
+
 		slob_free(m, *m + align);
 	} else {
 		unsigned int order = folio_order(sp);
@@ -573,7 +578,7 @@ EXPORT_SYMBOL(kfree);
 size_t __ksize(const void *block)
 {
 	struct folio *folio;
-	int align;
+	unsigned int align;
 	unsigned int *m;
 
 	BUG_ON(!block);
@@ -584,7 +589,8 @@ size_t __ksize(const void *block)
 	if (unlikely(!folio_test_slab(folio)))
 		return folio_size(folio);
 
-	align = max_t(size_t, ARCH_KMALLOC_MINALIGN, arch_slab_minalign());
+	align = max_t(unsigned int, ARCH_KMALLOC_MINALIGN,
+		      arch_slab_minalign());
 	m = (unsigned int *)(block - align);
 	return SLOB_UNITS(*m) * SLOB_UNIT;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mapletree-vs-khugepaged.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

