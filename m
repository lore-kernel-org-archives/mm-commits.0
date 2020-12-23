Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63BEC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BEF224F4
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgLWS3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbgLWS3B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E79222BB;
        Wed, 23 Dec 2020 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748100;
        bh=SQCID319sawefvkFbyLPaftA7cNLAb45zWOHJ/b1sgE=;
        h=Date:From:To:Subject:From;
        b=X2CEW0WFr4gznzorrrNjrvXYDpB6OGjfY6Lsr1TCrkgcHTohnpJL5LSEVuc4mTKEc
         mHf9vn3WX4u0+cgiDRvvWQIo2JXP97rVbF30bj/kXdB1Flhulhxv1XWSrZXpfXaAOM
         2MvbJc84rX4Ti+rMTm4Yl1YPIze095JMRli0rjoE=
Date:   Wed, 23 Dec 2020 10:28:19 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-shadow-declarations-only-for-software-modes.patch removed from -mm
 tree
Message-ID: <20201223182819.o5FMo1kd-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: shadow declarations only for software modes
has been removed from the -mm tree.  Its filename was
     kasan-shadow-declarations-only-for-software-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: shadow declarations only for software modes

This is a preparatory commit for the upcoming addition of a new hardware
tag-based (MTE-based) KASAN mode.

Group shadow-related KASAN function declarations and only define them for
the two existing software modes.

No functional changes for software modes.

Link: https://lkml.kernel.org/r/e88d94eff94db883a65dca52e1736d80d28dd9bc.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
[valdis.kletnieks@vt.edu: fix build issue with asmlinkage]
  Link: https://lkml.kernel.org/r/35126.1606402815@turing-police
  Link: https://lore.kernel.org/linux-arm-kernel/24105.1606397102@turing-police/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   48 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/include/linux/kasan.h~kasan-shadow-declarations-only-for-software-modes
+++ a/include/linux/kasan.h
@@ -11,7 +11,7 @@ struct task_struct;
 
 #ifdef CONFIG_KASAN
 
-#include <linux/pgtable.h>
+#include <linux/linkage.h>
 #include <asm/kasan.h>
 
 /* kasan_data struct is used in KUnit tests for KASAN expected failures */
@@ -20,6 +20,20 @@ struct kunit_kasan_expectation {
 	bool report_found;
 };
 
+#endif
+
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+
+#include <linux/pgtable.h>
+
+/* Software KASAN implementations use shadow memory. */
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define KASAN_SHADOW_INIT 0xFF
+#else
+#define KASAN_SHADOW_INIT 0
+#endif
+
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE];
 extern pmd_t kasan_early_shadow_pmd[PTRS_PER_PMD];
@@ -35,6 +49,23 @@ static inline void *kasan_mem_to_shadow(
 		+ KASAN_SHADOW_OFFSET;
 }
 
+int kasan_add_zero_shadow(void *start, unsigned long size);
+void kasan_remove_zero_shadow(void *start, unsigned long size);
+
+#else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
+
+static inline int kasan_add_zero_shadow(void *start, unsigned long size)
+{
+	return 0;
+}
+static inline void kasan_remove_zero_shadow(void *start,
+					unsigned long size)
+{}
+
+#endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
+
+#ifdef CONFIG_KASAN
+
 /* Enable reporting bugs after kasan_disable_current() */
 extern void kasan_enable_current(void);
 
@@ -75,9 +106,6 @@ struct kasan_cache {
 	int free_meta_offset;
 };
 
-int kasan_add_zero_shadow(void *start, unsigned long size);
-void kasan_remove_zero_shadow(void *start, unsigned long size);
-
 size_t __ksize(const void *);
 static inline void kasan_unpoison_slab(const void *ptr)
 {
@@ -143,14 +171,6 @@ static inline bool kasan_slab_free(struc
 	return false;
 }
 
-static inline int kasan_add_zero_shadow(void *start, unsigned long size)
-{
-	return 0;
-}
-static inline void kasan_remove_zero_shadow(void *start,
-					unsigned long size)
-{}
-
 static inline void kasan_unpoison_slab(const void *ptr) { }
 static inline size_t kasan_metadata_size(struct kmem_cache *cache) { return 0; }
 
@@ -158,8 +178,6 @@ static inline size_t kasan_metadata_size
 
 #ifdef CONFIG_KASAN_GENERIC
 
-#define KASAN_SHADOW_INIT 0
-
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
@@ -174,8 +192,6 @@ static inline void kasan_record_aux_stac
 
 #ifdef CONFIG_KASAN_SW_TAGS
 
-#define KASAN_SHADOW_INIT 0xFF
-
 void kasan_init_tags(void);
 
 void *kasan_reset_tag(const void *addr);
_

Patches currently in -mm which might be from andreyknvl@google.com are


