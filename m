Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67416C49EA6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 22:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412686138C
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 22:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFXW6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 18:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhFXW6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 18:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC92E6023D;
        Thu, 24 Jun 2021 22:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624575371;
        bh=UUur6nBs9UiJUvPgxe3W/3Ez5nbuGMbEdGHYqAUl5A0=;
        h=Date:From:To:Subject:From;
        b=VnAwB6Nc275CzfvofaSwIWFXUi5qv5IWa8rZhtEXTN0EJ5Yy6Lb0qesZqxRguDKVz
         MYefj6Dv9zUQF5SIvi41O8u3FLFalJfsJ3XNFloRNhnVeflrTCSzggeSZ63WQvWMV8
         RrHYRXaW+7QLRDyrx7tG+2uJY7mP+BXHpPfGw9gA=
Date:   Thu, 24 Jun 2021 15:56:10 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  + kasan-use-max_ptrs_per_-for-early-shadow-tables.patch
 added to -mm tree
Message-ID: <20210624225610.owqrivniw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use MAX_PTRS_PER_* for early shadow tables
has been added to the -mm tree.  Its filename is
     kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-use-max_ptrs_per_-for-early-shadow-tables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan: use MAX_PTRS_PER_* for early shadow tables

powerpc has a variable number of PTRS_PER_*, set at runtime based on the
MMU that the kernel is booted under.

This means the PTRS_PER_* are no longer constants, and therefore breaks
the build.  Switch to using MAX_PTRS_PER_*, which are constant.

Link: https://lkml.kernel.org/r/20210624034050.511391-5-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Suggested-by: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 +++---
 mm/kasan/init.c       |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/kasan.h~kasan-use-max_ptrs_per_-for-early-shadow-tables
+++ a/include/linux/kasan.h
@@ -40,9 +40,9 @@ struct kunit_kasan_expectation {
 #endif
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE + PTE_HWTABLE_PTRS];
-extern pmd_t kasan_early_shadow_pmd[PTRS_PER_PMD];
-extern pud_t kasan_early_shadow_pud[PTRS_PER_PUD];
+extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
+extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
+extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
 
 int kasan_populate_early_shadow(const void *shadow_start,
--- a/mm/kasan/init.c~kasan-use-max_ptrs_per_-for-early-shadow-tables
+++ a/mm/kasan/init.c
@@ -41,7 +41,7 @@ static inline bool kasan_p4d_table(pgd_t
 }
 #endif
 #if CONFIG_PGTABLE_LEVELS > 3
-pud_t kasan_early_shadow_pud[PTRS_PER_PUD] __page_aligned_bss;
+pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD] __page_aligned_bss;
 static inline bool kasan_pud_table(p4d_t p4d)
 {
 	return p4d_page(p4d) == virt_to_page(lm_alias(kasan_early_shadow_pud));
@@ -53,7 +53,7 @@ static inline bool kasan_pud_table(p4d_t
 }
 #endif
 #if CONFIG_PGTABLE_LEVELS > 2
-pmd_t kasan_early_shadow_pmd[PTRS_PER_PMD] __page_aligned_bss;
+pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD] __page_aligned_bss;
 static inline bool kasan_pmd_table(pud_t pud)
 {
 	return pud_page(pud) == virt_to_page(lm_alias(kasan_early_shadow_pmd));
@@ -64,7 +64,7 @@ static inline bool kasan_pmd_table(pud_t
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
 	__page_aligned_bss;
 
 static inline bool kasan_pte_table(pmd_t pmd)
_

Patches currently in -mm which might be from dja@axtens.net are

mm-vmalloc-unbreak-kasan-vmalloc-support.patch
kasan-allow-an-architecture-to-disable-inline-instrumentation.patch
kasan-allow-architectures-to-provide-an-outline-readiness-check.patch
mm-define-default-max_ptrs_per_-in-include-pgtableh.patch
kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

