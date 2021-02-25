Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56D4C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0C664F3F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhBYT1g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233286AbhBYTZf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C045F64F85;
        Thu, 25 Feb 2021 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280534;
        bh=Rvratj+HaAo2/znAzgIBkuI0wFsWAbvyeB01Sz3AGBc=;
        h=Date:From:To:Subject:From;
        b=PxaYiNbzohWBbCYEPuGO7eIy/bwuwvhrVI8EuF4n3iVvgzEFBDbrYAHlkigDbcSPZ
         mKFMrrC2/oOMQsBQqfyFtlWtdN/ch9fFK/KUHnv8cqdGFDxWrmo4xQBPZ3Wammusij
         Ii1qyke5z8CxA7cBGnetVQr+IJd5S7KI8YarJpiQ=
Date:   Thu, 25 Feb 2021 11:15:33 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch removed from
 -mm tree
Message-ID: <20210225191533.QMtLswKMs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: allow using KUnit tests with HW_TAGS mode
has been removed from the -mm tree.  Its filename was
     kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: allow using KUnit tests with HW_TAGS mode

On a high level, this patch allows running KUnit KASAN tests with the
hardware tag-based KASAN mode.

Internally, this change reenables tag checking at the end of each KASAN
test that triggers a tag fault and leads to tag checking being disabled.

Also simplify is_write calculation in report_tag_fault.

With this patch KASAN tests are still failing for the hardware tag-based
mode; fixes come in the next few patches.

[andreyknvl@google.com: export HW_TAGS symbols for KUnit tests]
  Link: https://lkml.kernel.org/r/e7eeb252da408b08f0c81b950a55fb852f92000b.1613155970.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Id94dc9eccd33b23cda4950be408c27f879e474c8
Link: https://lkml.kernel.org/r/51b23112cf3fd62b8f8e9df81026fa2b15870501.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h    |    1 
 arch/arm64/include/asm/mte-kasan.h |   12 +++++++
 arch/arm64/kernel/mte.c            |   12 +++++++
 arch/arm64/mm/fault.c              |   20 +++++++++---
 lib/Kconfig.kasan                  |    4 +-
 lib/test_kasan.c                   |   42 ++++++++++++++++++---------
 mm/kasan/hw_tags.c                 |   16 ++++++++++
 mm/kasan/kasan.h                   |   21 +++++++++++++
 8 files changed, 107 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/memory.h~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/arch/arm64/include/asm/memory.h
@@ -244,6 +244,7 @@ static inline const void *__tag_set(cons
 
 #ifdef CONFIG_KASAN_HW_TAGS
 #define arch_enable_tagging()			mte_enable_kernel()
+#define arch_set_tagging_report_once(state)	mte_set_report_once(state)
 #define arch_init_tags(max_tag)			mte_init_tags(max_tag)
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
--- a/arch/arm64/include/asm/mte-kasan.h~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -32,6 +32,9 @@ void *mte_set_mem_tag_range(void *addr,
 void mte_enable_kernel(void);
 void mte_init_tags(u64 max_tag);
 
+void mte_set_report_once(bool state);
+bool mte_report_once(void);
+
 #else /* CONFIG_ARM64_MTE */
 
 static inline u8 mte_get_ptr_tag(void *ptr)
@@ -60,6 +63,15 @@ static inline void mte_init_tags(u64 max
 {
 }
 
+static inline void mte_set_report_once(bool state)
+{
+}
+
+static inline bool mte_report_once(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
--- a/arch/arm64/kernel/mte.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/arch/arm64/kernel/mte.c
@@ -25,6 +25,8 @@
 
 u64 gcr_kernel_excl __ro_after_init;
 
+static bool report_fault_once = true;
+
 static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
 {
 	pte_t old_pte = READ_ONCE(*ptep);
@@ -158,6 +160,16 @@ void mte_enable_kernel(void)
 	isb();
 }
 
+void mte_set_report_once(bool state)
+{
+	WRITE_ONCE(report_fault_once, state);
+}
+
+bool mte_report_once(void)
+{
+	return READ_ONCE(report_fault_once);
+}
+
 static void update_sctlr_el1_tcf0(u64 tcf0)
 {
 	/* ISB required for the kernel uaccess routines */
--- a/arch/arm64/mm/fault.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/arch/arm64/mm/fault.c
@@ -302,12 +302,24 @@ static void die_kernel_fault(const char
 static void report_tag_fault(unsigned long addr, unsigned int esr,
 			     struct pt_regs *regs)
 {
-	bool is_write  = ((esr & ESR_ELx_WNR) >> ESR_ELx_WNR_SHIFT) != 0;
+	static bool reported;
+	bool is_write;
+
+	if (READ_ONCE(reported))
+		return;
+
+	/*
+	 * This is used for KASAN tests and assumes that no MTE faults
+	 * happened before running the tests.
+	 */
+	if (mte_report_once())
+		WRITE_ONCE(reported, true);
 
 	/*
 	 * SAS bits aren't set for all faults reported in EL1, so we can't
 	 * find out access size.
 	 */
+	is_write = !!(esr & ESR_ELx_WNR);
 	kasan_report(addr, 0, is_write, regs->pc);
 }
 #else
@@ -319,12 +331,8 @@ static inline void report_tag_fault(unsi
 static void do_tag_recovery(unsigned long addr, unsigned int esr,
 			   struct pt_regs *regs)
 {
-	static bool reported;
 
-	if (!READ_ONCE(reported)) {
-		report_tag_fault(addr, esr, regs);
-		WRITE_ONCE(reported, true);
-	}
+	report_tag_fault(addr, esr, regs);
 
 	/*
 	 * Disable MTE Tag Checking on the local CPU for the current EL.
--- a/lib/Kconfig.kasan~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/lib/Kconfig.kasan
@@ -190,11 +190,11 @@ config KASAN_KUNIT_TEST
 	  kernel debugging features like KASAN.
 
 	  For more information on KUnit and unit tests in general, please refer
-	  to the KUnit documentation in Documentation/dev-tools/kunit
+	  to the KUnit documentation in Documentation/dev-tools/kunit.
 
 config TEST_KASAN_MODULE
 	tristate "KUnit-incompatible tests of KASAN bug detection capabilities"
-	depends on m && KASAN
+	depends on m && KASAN && !KASAN_HW_TAGS
 	help
 	  This is a part of the KASAN test suite that is incompatible with
 	  KUnit. Currently includes tests that do bad copy_from/to_user
--- a/lib/test_kasan.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/lib/test_kasan.c
@@ -41,16 +41,20 @@ static bool multishot;
 
 /*
  * Temporarily enable multi-shot mode. Otherwise, KASAN would only report the
- * first detected bug and panic the kernel if panic_on_warn is enabled.
+ * first detected bug and panic the kernel if panic_on_warn is enabled. For
+ * hardware tag-based KASAN also allow tag checking to be reenabled for each
+ * test, see the comment for KUNIT_EXPECT_KASAN_FAIL().
  */
 static int kasan_test_init(struct kunit *test)
 {
 	multishot = kasan_save_enable_multi_shot();
+	kasan_set_tagging_report_once(false);
 	return 0;
 }
 
 static void kasan_test_exit(struct kunit *test)
 {
+	kasan_set_tagging_report_once(true);
 	kasan_restore_multi_shot(multishot);
 }
 
@@ -59,19 +63,31 @@ static void kasan_test_exit(struct kunit
  * KASAN report; causes a test failure otherwise. This relies on a KUnit
  * resource named "kasan_data". Do not use this name for KUnit resources
  * outside of KASAN tests.
+ *
+ * For hardware tag-based KASAN, when a tag fault happens, tag checking is
+ * normally auto-disabled. When this happens, this test handler reenables
+ * tag checking. As tag checking can be only disabled or enabled per CPU, this
+ * handler disables migration (preemption).
  */
-#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do { \
-	fail_data.report_expected = true; \
-	fail_data.report_found = false; \
-	kunit_add_named_resource(test, \
-				NULL, \
-				NULL, \
-				&resource, \
-				"kasan_data", &fail_data); \
-	expression; \
-	KUNIT_EXPECT_EQ(test, \
-			fail_data.report_expected, \
-			fail_data.report_found); \
+#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {		\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))			\
+		migrate_disable();				\
+	fail_data.report_expected = true;			\
+	fail_data.report_found = false;				\
+	kunit_add_named_resource(test,				\
+				NULL,				\
+				NULL,				\
+				&resource,			\
+				"kasan_data", &fail_data);	\
+	expression;						\
+	KUNIT_EXPECT_EQ(test,					\
+			fail_data.report_expected,		\
+			fail_data.report_found);		\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {			\
+		if (fail_data.report_found)			\
+			kasan_enable_tagging();			\
+		migrate_enable();				\
+	}							\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
--- a/mm/kasan/hw_tags.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/mm/kasan/hw_tags.c
@@ -185,3 +185,19 @@ struct kasan_track *kasan_get_free_track
 
 	return &alloc_meta->free_track[0];
 }
+
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+void kasan_set_tagging_report_once(bool state)
+{
+	hw_set_tagging_report_once(state);
+}
+EXPORT_SYMBOL_GPL(kasan_set_tagging_report_once);
+
+void kasan_enable_tagging(void)
+{
+	hw_enable_tagging();
+}
+EXPORT_SYMBOL_GPL(kasan_enable_tagging);
+
+#endif
--- a/mm/kasan/kasan.h~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode
+++ a/mm/kasan/kasan.h
@@ -280,6 +280,9 @@ static inline const void *arch_kasan_set
 #ifndef arch_init_tags
 #define arch_init_tags(max_tag)
 #endif
+#ifndef arch_set_tagging_report_once
+#define arch_set_tagging_report_once(state)
+#endif
 #ifndef arch_get_random_tag
 #define arch_get_random_tag()	(0xFF)
 #endif
@@ -292,12 +295,30 @@ static inline const void *arch_kasan_set
 
 #define hw_enable_tagging()			arch_enable_tagging()
 #define hw_init_tags(max_tag)			arch_init_tags(max_tag)
+#define hw_set_tagging_report_once(state)	arch_set_tagging_report_once(state)
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
 #define hw_set_mem_tag_range(addr, size, tag)	arch_set_mem_tag_range((addr), (size), (tag))
 
+#else /* CONFIG_KASAN_HW_TAGS */
+
+#define hw_enable_tagging()
+#define hw_set_tagging_report_once(state)
+
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+void kasan_set_tagging_report_once(bool state);
+void kasan_enable_tagging(void);
+
+#else /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+
+static inline void kasan_set_tagging_report_once(bool state) { }
+static inline void kasan_enable_tagging(void) { }
+
+#endif /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+
 #ifdef CONFIG_KASAN_SW_TAGS
 u8 kasan_random_tag(void);
 #elif defined(CONFIG_KASAN_HW_TAGS)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

