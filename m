Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD28C47096
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCA7613EA
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhFDDFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhFDDFW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 23:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7ECB6140C;
        Fri,  4 Jun 2021 03:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622775806;
        bh=WnFxLgkSvHFsO/mbHnLRlIBFdwCee0Gif+bN9AMGvjs=;
        h=Date:From:To:Subject:From;
        b=Xbder+GyDrPFXU1d5kdN/kWC0sfZeMac87UmZ08SUdKeIIl30w12fHcmn72VX36x6
         hJp9BDfuwNQjjlqv5tuJG1zP+sECWws4GffafAdJn0K00cUZ776H296CyClfIYrZ0R
         YYavIwm364c/tcZjZ05sDREo9uL077t9hjG2hAPY=
Date:   Thu, 03 Jun 2021 20:03:25 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, eugenis@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        pcc@google.com, vincenzo.frascino@arm.com
Subject:  +
 kasan-disable-freed-user-page-poisoning-with-hw-tags.patch added to -mm
 tree
Message-ID: <20210604030325.c-HYevwmm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: disable freed user page poisoning with HW tags
has been added to the -mm tree.  Its filename is
     kasan-disable-freed-user-page-poisoning-with-hw-tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-disable-freed-user-page-poisoning-with-hw-tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-disable-freed-user-page-poisoning-with-hw-tags.patch

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
Subject: kasan: disable freed user page poisoning with HW tags

Poisoning freed pages protects against kernel use-after-free.  The
likelihood of such a bug involving kernel pages is significantly higher
than that for user pages.  At the same time, poisoning freed pages can
impose a significant performance cost, which cannot always be justified
for user pages given the lower probability of finding a bug.  Therefore,
disable freed user page poisoning when using HW tags.  We identify "user"
pages via the flag set GFP_HIGHUSER_MOVABLE, which indicates a strong
likelihood of not being directly accessible to the kernel.

Link: https://lkml.kernel.org/r/20210602235230.3928842-5-pcc@google.com
Link: https://linux-review.googlesource.com/id/I716846e2de8ef179f44e835770df7e6307be96c9
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |   13 ++++++++++---
 include/linux/page-flags.h     |    9 +++++++++
 include/trace/events/mmflags.h |    9 ++++++++-
 mm/kasan/hw_tags.c             |    3 +++
 mm/page_alloc.c                |   12 +++++++-----
 5 files changed, 37 insertions(+), 9 deletions(-)

--- a/include/linux/gfp.h~kasan-disable-freed-user-page-poisoning-with-hw-tags
+++ a/include/linux/gfp.h
@@ -54,8 +54,9 @@ struct vm_area_struct;
 #define ___GFP_THISNODE		0x200000u
 #define ___GFP_ACCOUNT		0x400000u
 #define ___GFP_ZEROTAGS		0x800000u
+#define ___GFP_SKIP_KASAN_POISON	0x1000000u
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x1000000u
+#define ___GFP_NOLOCKDEP	0x2000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
@@ -233,17 +234,22 @@ struct vm_area_struct;
  *
  * %__GFP_ZEROTAGS returns a page with zeroed memory tags on success, if
  * __GFP_ZERO is set.
+ *
+ * %__GFP_SKIP_KASAN_POISON returns a page which does not need to be poisoned
+ * on deallocation. Typically used for userspace pages. Currently only has an
+ * effect in HW tags mode.
  */
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
 #define __GFP_ZEROTAGS	((__force gfp_t)___GFP_ZEROTAGS)
+#define __GFP_SKIP_KASAN_POISON	((__force gfp_t)___GFP_SKIP_KASAN_POISON)
 
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (25 + IS_ENABLED(CONFIG_LOCKDEP))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
@@ -324,7 +330,8 @@ struct vm_area_struct;
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | \
+			 __GFP_SKIP_KASAN_POISON)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
--- a/include/linux/page-flags.h~kasan-disable-freed-user-page-poisoning-with-hw-tags
+++ a/include/linux/page-flags.h
@@ -138,6 +138,9 @@ enum pageflags {
 #ifdef CONFIG_64BIT
 	PG_arch_2,
 #endif
+#ifdef CONFIG_KASAN_HW_TAGS
+	PG_skip_kasan_poison,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -443,6 +446,12 @@ TESTCLEARFLAG(Young, young, PF_ANY)
 PAGEFLAG(Idle, idle, PF_ANY)
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+PAGEFLAG(SkipKASanPoison, skip_kasan_poison, PF_HEAD)
+#else
+PAGEFLAG_FALSE(SkipKASanPoison)
+#endif
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
--- a/include/trace/events/mmflags.h~kasan-disable-freed-user-page-poisoning-with-hw-tags
+++ a/include/trace/events/mmflags.h
@@ -85,6 +85,12 @@
 #define IF_HAVE_PG_ARCH_2(flag,string)
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+#define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string) ,{1UL << flag, string}
+#else
+#define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string)
+#endif
+
 #define __def_pageflag_names						\
 	{1UL << PG_locked,		"locked"	},		\
 	{1UL << PG_waiters,		"waiters"	},		\
@@ -112,7 +118,8 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncach
 IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)
+IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
--- a/mm/kasan/hw_tags.c~kasan-disable-freed-user-page-poisoning-with-hw-tags
+++ a/mm/kasan/hw_tags.c
@@ -246,6 +246,9 @@ void kasan_alloc_pages(struct page *page
 	 */
 	bool init = !want_init_on_free() && want_init_on_alloc(flags);
 
+	if (flags & __GFP_SKIP_KASAN_POISON)
+		SetPageSkipKASanPoison(page);
+
 	if (flags & __GFP_ZEROTAGS) {
 		int i;
 
--- a/mm/page_alloc.c~kasan-disable-freed-user-page-poisoning-with-hw-tags
+++ a/mm/page_alloc.c
@@ -412,11 +412,12 @@ static DEFINE_STATIC_KEY_TRUE(deferred_p
  * on-demand allocation and then freed again before the deferred pages
  * initialization is done, but this is not likely to happen.
  */
-static inline bool should_skip_kasan_poison(fpi_t fpi_flags)
+static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
 {
 	return static_branch_unlikely(&deferred_pages) ||
 	       (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON));
+		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
+	       PageSkipKASanPoison(page);
 }
 
 /* Returns true if the struct page for the pfn is uninitialised */
@@ -467,10 +468,11 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 #else
-static inline bool should_skip_kasan_poison(fpi_t fpi_flags)
+static inline bool should_skip_kasan_poison(struct page *page, fpi_t fpi_flags)
 {
 	return (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-		(fpi_flags & FPI_SKIP_KASAN_POISON));
+		(fpi_flags & FPI_SKIP_KASAN_POISON)) ||
+	       PageSkipKASanPoison(page);
 }
 
 static inline bool early_page_uninitialised(unsigned long pfn)
@@ -1313,7 +1315,7 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(fpi_flags);
+	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch
kasan-use-separate-unpoison-implementation-for-integrated-init.patch
arm64-mte-handle-tags-zeroing-at-page-allocation-time.patch
kasan-disable-freed-user-page-poisoning-with-hw-tags.patch

