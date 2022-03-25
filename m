Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E87C4321E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357204AbiCYBNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357222AbiCYBND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8904BD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 617C961808
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9193C340EC;
        Fri, 25 Mar 2022 01:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170689;
        bh=BGQKIh1lBrcR7nCyFh3Oz52fFiEvIYA+zxKFPH8y99U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=YOp+bXGG5khbsN9mVzhFMcTy7sZ0G4sZYUb83q4zhh2qcH8WKINdDP+Y0R0iatbRu
         jAuwQjxYS7ll4ZKUbtPrVE+Aiqf7/YhZJEV8H0k8oWiUhxdSkTBnuKqypDJ71+zYcG
         uviiUyn9NR7VSlC5p+7OPp0HuPaTCGdgZ48dOTbE=
Date:   Thu, 24 Mar 2022 18:11:29 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 058/114] kasan, page_alloc: allow skipping memory init for HW_TAGS
Message-Id: <20220325011129.B9193C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: allow skipping memory init for HW_TAGS

Add a new GFP flag __GFP_SKIP_ZERO that allows to skip memory
initialization.  The flag is only effective with HW_TAGS KASAN.

This flag will be used by vmalloc code for page_alloc allocations backing
vmalloc() mappings in a following patch.  The reason to skip memory
initialization for these pages in page_alloc is because vmalloc code will
be initializing them instead.

With the current implementation, when __GFP_SKIP_ZERO is provided,
__GFP_ZEROTAGS is ignored.  This doesn't matter, as these two flags are
never provided at the same time.  However, if this is changed in the
future, this particular implementation detail can be changed as well.

Link: https://lkml.kernel.org/r/0d53efeff345de7d708e0baa0d8829167772521e.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |   18 +++++++++++-------
 include/trace/events/mmflags.h |    1 +
 mm/page_alloc.c                |   13 ++++++++++++-
 3 files changed, 24 insertions(+), 8 deletions(-)

--- a/include/linux/gfp.h~kasan-page_alloc-allow-skipping-memory-init-for-hw_tags
+++ a/include/linux/gfp.h
@@ -55,14 +55,16 @@ struct vm_area_struct;
 #define ___GFP_ACCOUNT		0x400000u
 #define ___GFP_ZEROTAGS		0x800000u
 #ifdef CONFIG_KASAN_HW_TAGS
-#define ___GFP_SKIP_KASAN_UNPOISON	0x1000000u
-#define ___GFP_SKIP_KASAN_POISON	0x2000000u
+#define ___GFP_SKIP_ZERO		0x1000000u
+#define ___GFP_SKIP_KASAN_UNPOISON	0x2000000u
+#define ___GFP_SKIP_KASAN_POISON	0x4000000u
 #else
+#define ___GFP_SKIP_ZERO		0
 #define ___GFP_SKIP_KASAN_UNPOISON	0
 #define ___GFP_SKIP_KASAN_POISON	0
 #endif
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x4000000u
+#define ___GFP_NOLOCKDEP	0x8000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
@@ -239,9 +241,10 @@ struct vm_area_struct;
  * %__GFP_ZERO returns a zeroed page on success.
  *
  * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
- * is being zeroed (either via __GFP_ZERO or via init_on_alloc). This flag is
- * intended for optimization: setting memory tags at the same time as zeroing
- * memory has minimal additional performace impact.
+ * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
+ * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
+ * memory tags at the same time as zeroing memory has minimal additional
+ * performace impact.
  *
  * %__GFP_SKIP_KASAN_UNPOISON makes KASAN skip unpoisoning on page allocation.
  * Only effective in HW_TAGS mode.
@@ -253,6 +256,7 @@ struct vm_area_struct;
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
 #define __GFP_ZEROTAGS	((__force gfp_t)___GFP_ZEROTAGS)
+#define __GFP_SKIP_ZERO ((__force gfp_t)___GFP_SKIP_ZERO)
 #define __GFP_SKIP_KASAN_UNPOISON ((__force gfp_t)___GFP_SKIP_KASAN_UNPOISON)
 #define __GFP_SKIP_KASAN_POISON   ((__force gfp_t)___GFP_SKIP_KASAN_POISON)
 
@@ -261,7 +265,7 @@ struct vm_area_struct;
 
 /* Room for N __GFP_FOO bits */
 #define __GFP_BITS_SHIFT (24 +						\
-			  2 * IS_ENABLED(CONFIG_KASAN_HW_TAGS) +	\
+			  3 * IS_ENABLED(CONFIG_KASAN_HW_TAGS) +	\
 			  IS_ENABLED(CONFIG_LOCKDEP))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
--- a/include/trace/events/mmflags.h~kasan-page_alloc-allow-skipping-memory-init-for-hw_tags
+++ a/include/trace/events/mmflags.h
@@ -53,6 +53,7 @@
 
 #ifdef CONFIG_KASAN_HW_TAGS
 #define __def_gfpflag_names_kasan ,					       \
+	{(unsigned long)__GFP_SKIP_ZERO,	   "__GFP_SKIP_ZERO"},	       \
 	{(unsigned long)__GFP_SKIP_KASAN_POISON,   "__GFP_SKIP_KASAN_POISON"}, \
 	{(unsigned long)__GFP_SKIP_KASAN_UNPOISON, "__GFP_SKIP_KASAN_UNPOISON"}
 #else
--- a/mm/page_alloc.c~kasan-page_alloc-allow-skipping-memory-init-for-hw_tags
+++ a/mm/page_alloc.c
@@ -2363,10 +2363,21 @@ static inline bool should_skip_kasan_unp
 	return init_tags || (flags & __GFP_SKIP_KASAN_UNPOISON);
 }
 
+static inline bool should_skip_init(gfp_t flags)
+{
+	/* Don't skip, if hardware tag-based KASAN is not enabled. */
+	if (!kasan_hw_tags_enabled())
+		return false;
+
+	/* For hardware tag-based KASAN, skip if requested. */
+	return (flags & __GFP_SKIP_ZERO);
+}
+
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
-	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
+			!should_skip_init(gfp_flags);
 	bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 
 	set_page_private(page, 0);
_
