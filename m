Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7B2C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6635F6117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGFTQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhGFTQ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F5A960C3D;
        Tue,  6 Jul 2021 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598828;
        bh=WrPXOoQSIdTLrc+5H4hdau8wi9E0LHvlnmWNpAhp9DY=;
        h=Date:From:To:Subject:From;
        b=2iPr4uLBhX0YW5gjrn8OniK7jlUquxXGIGRKiXZu2QttRp9qwTVOKewbglqMVbcWf
         3fw3ylDQDTmjcejjqMGZBHIvdaar/2A9KGGZWBRHrm3+/K6cDewOzTzbxekWaMF6tO
         oi+kwrFZWUrEMIO4lBmc/dccgdXUCyXKgME+Vzbo=
Date:   Tue, 06 Jul 2021 12:13:48 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-use-max_ptrs_per_-for-early-shadow-tables.patch removed from -mm tree
Message-ID: <20210706191348.uhscC9Rf-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use MAX_PTRS_PER_* for early shadow tables
has been removed from the -mm tree.  Its filename was
     kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


