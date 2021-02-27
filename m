Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D544C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7EA264F3A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhB0Ccm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhB0CcM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A31F164F43;
        Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393091;
        bh=Hre2ZPYg2GMJlDZl8bIaBSCTbUgFnBnRzvxi+liSGuI=;
        h=Date:From:To:Subject:From;
        b=SlPSZ+F4Hb81GQQjF70RUEgV66RfVGREjg6OGcb96Phg+u2xFyC4ulVyO7DxNttf/
         SAfshN/FBzOWChSCRfnhEWff63CbLVazTZKeBHFuekyvkDNi82w0nGCPYHUioGbxYQ
         /svAvjDpuYq3slslCCq/BGJxWNoua/Mtr0UQ3J2Y=
Date:   Fri, 26 Feb 2021 18:31:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 arm64-kasan-simplify-and-inline-mte-functions.patch removed from -mm tree
Message-ID: <20210227023130.M8Aksg5QJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: simplify and inline MTE functions
has been removed from the -mm tree.  Its filename was
     arm64-kasan-simplify-and-inline-mte-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: kasan: simplify and inline MTE functions

This change provides a simpler implementation of mte_get_mem_tag(),
mte_get_random_tag(), and mte_set_mem_tag_range().

Simplifications include removing system_supports_mte() checks as these
functions are onlye called from KASAN runtime that had already checked
system_supports_mte().  Besides that, size and address alignment checks
are removed from mte_set_mem_tag_range(), as KASAN now does those.

This change also moves these functions into the asm/mte-kasan.h header and
implements mte_set_mem_tag_range() via inline assembly to avoid
unnecessary functions calls.

[vincenzo.frascino@arm.com: fix warning in mte_get_random_tag()]
  Link: https://lkml.kernel.org/r/20210211152208.23811-1-vincenzo.frascino@arm.com
Link: https://lkml.kernel.org/r/a26121b294fdf76e369cb7a74351d1c03a908930.1612546384.git.andreyknvl@google.com
Co-developed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
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

 arch/arm64/include/asm/cache.h     |    1 
 arch/arm64/include/asm/kasan.h     |    1 
 arch/arm64/include/asm/mte-def.h   |    2 
 arch/arm64/include/asm/mte-kasan.h |   65 +++++++++++++++++++++++----
 arch/arm64/include/asm/mte.h       |    2 
 arch/arm64/kernel/mte.c            |   46 -------------------
 arch/arm64/lib/mte.S               |   16 ------
 7 files changed, 60 insertions(+), 73 deletions(-)

--- a/arch/arm64/include/asm/cache.h~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/include/asm/cache.h
@@ -6,7 +6,6 @@
 #define __ASM_CACHE_H
 
 #include <asm/cputype.h>
-#include <asm/mte-kasan.h>
 
 #define CTR_L1IP_SHIFT		14
 #define CTR_L1IP_MASK		3
--- a/arch/arm64/include/asm/kasan.h~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/include/asm/kasan.h
@@ -6,6 +6,7 @@
 
 #include <linux/linkage.h>
 #include <asm/memory.h>
+#include <asm/mte-kasan.h>
 #include <asm/pgtable-types.h>
 
 #define arch_kasan_set_tag(addr, tag)	__tag_set(addr, tag)
--- a/arch/arm64/include/asm/mte-def.h~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/include/asm/mte-def.h
@@ -11,4 +11,6 @@
 #define MTE_TAG_SIZE		4
 #define MTE_TAG_MASK		GENMASK((MTE_TAG_SHIFT + (MTE_TAG_SIZE - 1)), MTE_TAG_SHIFT)
 
+#define __MTE_PREAMBLE		ARM64_ASM_PREAMBLE ".arch_extension memtag\n"
+
 #endif /* __ASM_MTE_DEF_H  */
--- a/arch/arm64/include/asm/mte.h~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/include/asm/mte.h
@@ -8,8 +8,6 @@
 #include <asm/compiler.h>
 #include <asm/mte-def.h>
 
-#define __MTE_PREAMBLE		ARM64_ASM_PREAMBLE ".arch_extension memtag\n"
-
 #ifndef __ASSEMBLY__
 
 #include <linux/bitfield.h>
--- a/arch/arm64/include/asm/mte-kasan.h~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -11,11 +11,14 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_ARM64_MTE
+
 /*
- * The functions below are meant to be used only for the
- * KASAN_HW_TAGS interface defined in asm/memory.h.
+ * These functions are meant to be only used from KASAN runtime through
+ * the arch_*() interface defined in asm/memory.h.
+ * These functions don't include system_supports_mte() checks,
+ * as KASAN only calls them when MTE is supported and enabled.
  */
-#ifdef CONFIG_ARM64_MTE
 
 static inline u8 mte_get_ptr_tag(void *ptr)
 {
@@ -25,9 +28,54 @@ static inline u8 mte_get_ptr_tag(void *p
 	return tag;
 }
 
-u8 mte_get_mem_tag(void *addr);
-u8 mte_get_random_tag(void);
-void *mte_set_mem_tag_range(void *addr, size_t size, u8 tag);
+/* Get allocation tag for the address. */
+static inline u8 mte_get_mem_tag(void *addr)
+{
+	asm(__MTE_PREAMBLE "ldg %0, [%0]"
+		: "+r" (addr));
+
+	return mte_get_ptr_tag(addr);
+}
+
+/* Generate a random tag. */
+static inline u8 mte_get_random_tag(void)
+{
+	void *addr;
+
+	asm(__MTE_PREAMBLE "irg %0, %0"
+		: "=r" (addr));
+
+	return mte_get_ptr_tag(addr);
+}
+
+/*
+ * Assign allocation tags for a region of memory based on the pointer tag.
+ * Note: The address must be non-NULL and MTE_GRANULE_SIZE aligned and
+ * size must be non-zero and MTE_GRANULE_SIZE aligned.
+ */
+static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
+{
+	u64 curr, end;
+
+	if (!size)
+		return;
+
+	curr = (u64)__tag_set(addr, tag);
+	end = curr + size;
+
+	do {
+		/*
+		 * 'asm volatile' is required to prevent the compiler to move
+		 * the statement outside of the loop.
+		 */
+		asm volatile(__MTE_PREAMBLE "stg %0, [%0]"
+			     :
+			     : "r" (curr)
+			     : "memory");
+
+		curr += MTE_GRANULE_SIZE;
+	} while (curr != end);
+}
 
 void mte_enable_kernel(void);
 void mte_init_tags(u64 max_tag);
@@ -46,13 +94,14 @@ static inline u8 mte_get_mem_tag(void *a
 {
 	return 0xFF;
 }
+
 static inline u8 mte_get_random_tag(void)
 {
 	return 0xFF;
 }
-static inline void *mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
+
+static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
 {
-	return addr;
 }
 
 static inline void mte_enable_kernel(void)
--- a/arch/arm64/kernel/mte.c~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/kernel/mte.c
@@ -19,7 +19,6 @@
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/mte.h>
-#include <asm/mte-kasan.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
 
@@ -88,51 +87,6 @@ int memcmp_pages(struct page *page1, str
 	return ret;
 }
 
-u8 mte_get_mem_tag(void *addr)
-{
-	if (!system_supports_mte())
-		return 0xFF;
-
-	asm(__MTE_PREAMBLE "ldg %0, [%0]"
-	    : "+r" (addr));
-
-	return mte_get_ptr_tag(addr);
-}
-
-u8 mte_get_random_tag(void)
-{
-	void *addr;
-
-	if (!system_supports_mte())
-		return 0xFF;
-
-	asm(__MTE_PREAMBLE "irg %0, %0"
-	    : "+r" (addr));
-
-	return mte_get_ptr_tag(addr);
-}
-
-void *mte_set_mem_tag_range(void *addr, size_t size, u8 tag)
-{
-	void *ptr = addr;
-
-	if ((!system_supports_mte()) || (size == 0))
-		return addr;
-
-	/* Make sure that size is MTE granule aligned. */
-	WARN_ON(size & (MTE_GRANULE_SIZE - 1));
-
-	/* Make sure that the address is MTE granule aligned. */
-	WARN_ON((u64)addr & (MTE_GRANULE_SIZE - 1));
-
-	tag = 0xF0 | tag;
-	ptr = (void *)__tag_set(ptr, tag);
-
-	mte_assign_mem_tag_range(ptr, size);
-
-	return ptr;
-}
-
 void mte_init_tags(u64 max_tag)
 {
 	static bool gcr_kernel_excl_initialized;
--- a/arch/arm64/lib/mte.S~arm64-kasan-simplify-and-inline-mte-functions
+++ a/arch/arm64/lib/mte.S
@@ -149,19 +149,3 @@ SYM_FUNC_START(mte_restore_page_tags)
 
 	ret
 SYM_FUNC_END(mte_restore_page_tags)
-
-/*
- * Assign allocation tags for a region of memory based on the pointer tag
- *   x0 - source pointer
- *   x1 - size
- *
- * Note: The address must be non-NULL and MTE_GRANULE_SIZE aligned and
- * size must be non-zero and MTE_GRANULE_SIZE aligned.
- */
-SYM_FUNC_START(mte_assign_mem_tag_range)
-1:	stg	x0, [x0]
-	add	x0, x0, #MTE_GRANULE_SIZE
-	subs	x1, x1, #MTE_GRANULE_SIZE
-	b.gt	1b
-	ret
-SYM_FUNC_END(mte_assign_mem_tag_range)
_

Patches currently in -mm which might be from andreyknvl@google.com are


