Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1020FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiCYWoK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbiCYWn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FE20A97C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85C8614A8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EAFC340F0;
        Fri, 25 Mar 2022 22:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248134;
        bh=v66pMIo1P5BDMWOlwfTM9HOb6OiR7Igp0iIvVYaRs0c=;
        h=Date:To:From:Subject:From;
        b=Uobv5QbNV/t1vrtmLNRmlx3YWNFa6f+9bFud43UAxeeknYSpzJAeAr/EkQEgki2nh
         NXVuY3XZoeV33FB0yxRF/i7DkEIOxtCy224apHUs0ZFz/LIAuKGCKiVbPHLKnm1Nho
         1r8uqLYwMa6/MvEdBE1UsP+Ga55Wtn45OHthtbKg=
Date:   Fri, 25 Mar 2022 15:42:13 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-reorder-vmalloc-hooks.patch removed from -mm tree
Message-Id: <20220325224214.38EAFC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: reorder vmalloc hooks
has been removed from the -mm tree.  Its filename was
     kasan-reorder-vmalloc-hooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: reorder vmalloc hooks

Group functions that [de]populate shadow memory for vmalloc.  Group
functions that [un]poison memory for vmalloc.

This patch does no functional changes but prepares KASAN code for adding
vmalloc support to HW_TAGS KASAN.

Link: https://lkml.kernel.org/r/aeef49eb249c206c4c9acce2437728068da74c28.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
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

 include/linux/kasan.h |   20 ++++++++----------
 mm/kasan/shadow.c     |   43 ++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 32 deletions(-)

--- a/include/linux/kasan.h~kasan-reorder-vmalloc-hooks
+++ a/include/linux/kasan.h
@@ -397,34 +397,32 @@ static inline void kasan_init_hw_tags(vo
 
 #ifdef CONFIG_KASAN_VMALLOC
 
+void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
 int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
-void kasan_poison_vmalloc(const void *start, unsigned long size);
-void kasan_unpoison_vmalloc(const void *start, unsigned long size);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end);
 
-void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
+void kasan_unpoison_vmalloc(const void *start, unsigned long size);
+void kasan_poison_vmalloc(const void *start, unsigned long size);
 
 #else /* CONFIG_KASAN_VMALLOC */
 
+static inline void kasan_populate_early_vm_area_shadow(void *start,
+						       unsigned long size) { }
 static inline int kasan_populate_vmalloc(unsigned long start,
 					unsigned long size)
 {
 	return 0;
 }
-
-static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
-{ }
-static inline void kasan_unpoison_vmalloc(const void *start, unsigned long size)
-{ }
 static inline void kasan_release_vmalloc(unsigned long start,
 					 unsigned long end,
 					 unsigned long free_region_start,
-					 unsigned long free_region_end) {}
+					 unsigned long free_region_end) { }
 
-static inline void kasan_populate_early_vm_area_shadow(void *start,
-						       unsigned long size)
+static inline void kasan_unpoison_vmalloc(const void *start, unsigned long size)
+{ }
+static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
 { }
 
 #endif /* CONFIG_KASAN_VMALLOC */
--- a/mm/kasan/shadow.c~kasan-reorder-vmalloc-hooks
+++ a/mm/kasan/shadow.c
@@ -345,27 +345,6 @@ int kasan_populate_vmalloc(unsigned long
 	return 0;
 }
 
-/*
- * Poison the shadow for a vmalloc region. Called as part of the
- * freeing process at the time the region is freed.
- */
-void kasan_poison_vmalloc(const void *start, unsigned long size)
-{
-	if (!is_vmalloc_or_module_addr(start))
-		return;
-
-	size = round_up(size, KASAN_GRANULE_SIZE);
-	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
-}
-
-void kasan_unpoison_vmalloc(const void *start, unsigned long size)
-{
-	if (!is_vmalloc_or_module_addr(start))
-		return;
-
-	kasan_unpoison(start, size, false);
-}
-
 static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 					void *unused)
 {
@@ -496,6 +475,28 @@ void kasan_release_vmalloc(unsigned long
 	}
 }
 
+
+void kasan_unpoison_vmalloc(const void *start, unsigned long size)
+{
+	if (!is_vmalloc_or_module_addr(start))
+		return;
+
+	kasan_unpoison(start, size, false);
+}
+
+/*
+ * Poison the shadow for a vmalloc region. Called as part of the
+ * freeing process at the time the region is freed.
+ */
+void kasan_poison_vmalloc(const void *start, unsigned long size)
+{
+	if (!is_vmalloc_or_module_addr(start))
+		return;
+
+	size = round_up(size, KASAN_GRANULE_SIZE);
+	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

