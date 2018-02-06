From: akpm@linux-foundation.org
Subject: [patch 013/114] kasan: clean up KASAN_SHADOW_SCALE_SHIFT
 usage
Date: Tue, 06 Feb 2018 15:36:44 -0800
Message-ID: <20180206233644.hGhEn4Oh4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54264 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbeBFXgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up KASAN_SHADOW_SCALE_SHIFT usage

Right now the fact that KASAN uses a single shadow byte for 8 bytes of
memory is scattered all over the code.

This change defines KASAN_SHADOW_SCALE_SHIFT early in asm include files
and makes use of this constant where necessary.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/34937ca3b90736eaad91b568edf5684091f662e3.1515775666.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kasan.h  |   17 ++++++++++-------
 arch/arm64/include/asm/memory.h |    3 ++-
 arch/arm64/mm/kasan_init.c      |    3 ++-
 arch/x86/include/asm/kasan.h    |   12 ++++++++----
 include/linux/kasan.h           |    2 --
 5 files changed, 22 insertions(+), 15 deletions(-)

diff -puN arch/arm64/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage arch/arm64/include/asm/kasan.h
--- a/arch/arm64/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage
+++ a/arch/arm64/include/asm/kasan.h
@@ -12,7 +12,8 @@
 
 /*
  * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
- * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
+ * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/N of kernel virtual addresses,
+ * where N = (1 << KASAN_SHADOW_SCALE_SHIFT).
  */
 #define KASAN_SHADOW_START      (VA_START)
 #define KASAN_SHADOW_END        (KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
@@ -20,14 +21,16 @@
 /*
  * This value is used to map an address to the corresponding shadow
  * address by the following formula:
- *     shadow_addr = (address >> 3) + KASAN_SHADOW_OFFSET;
+ *     shadow_addr = (address >> KASAN_SHADOW_SCALE_SHIFT) + KASAN_SHADOW_OFFSET
  *
- * (1 << 61) shadow addresses - [KASAN_SHADOW_OFFSET,KASAN_SHADOW_END]
- * cover all 64-bits of virtual addresses. So KASAN_SHADOW_OFFSET
- * should satisfy the following equation:
- *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END - (1ULL << 61)
+ * (1 << (64 - KASAN_SHADOW_SCALE_SHIFT)) shadow addresses that lie in range
+ * [KASAN_SHADOW_OFFSET, KASAN_SHADOW_END) cover all 64-bits of virtual
+ * addresses. So KASAN_SHADOW_OFFSET should satisfy the following equation:
+ *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END -
+ *				(1ULL << (64 - KASAN_SHADOW_SCALE_SHIFT))
  */
-#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << (64 - 3)))
+#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << \
+					(64 - KASAN_SHADOW_SCALE_SHIFT)))
 
 void kasan_init(void);
 void kasan_copy_shadow(pgd_t *pgdir);
diff -puN arch/arm64/include/asm/memory.h~kasan-clean-up-kasan_shadow_scale_shift-usage arch/arm64/include/asm/memory.h
--- a/arch/arm64/include/asm/memory.h~kasan-clean-up-kasan_shadow_scale_shift-usage
+++ a/arch/arm64/include/asm/memory.h
@@ -85,7 +85,8 @@
  * stack size when KASAN is in use.
  */
 #ifdef CONFIG_KASAN
-#define KASAN_SHADOW_SIZE	(UL(1) << (VA_BITS - 3))
+#define KASAN_SHADOW_SCALE_SHIFT 3
+#define KASAN_SHADOW_SIZE	(UL(1) << (VA_BITS - KASAN_SHADOW_SCALE_SHIFT))
 #define KASAN_THREAD_SHIFT	1
 #else
 #define KASAN_SHADOW_SIZE	(0)
diff -puN arch/arm64/mm/kasan_init.c~kasan-clean-up-kasan_shadow_scale_shift-usage arch/arm64/mm/kasan_init.c
--- a/arch/arm64/mm/kasan_init.c~kasan-clean-up-kasan_shadow_scale_shift-usage
+++ a/arch/arm64/mm/kasan_init.c
@@ -135,7 +135,8 @@ static void __init kasan_pgd_populate(un
 /* The early shadow maps everything to a single page of zeroes */
 asmlinkage void __init kasan_early_init(void)
 {
-	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_END - (1UL << 61));
+	BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=
+		KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_START, PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
 	kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE,
diff -puN arch/x86/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage arch/x86/include/asm/kasan.h
--- a/arch/x86/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage
+++ a/arch/x86/include/asm/kasan.h
@@ -4,6 +4,7 @@
 
 #include <linux/const.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
+#define KASAN_SHADOW_SCALE_SHIFT 3
 
 /*
  * Compiler uses shadow offset assuming that addresses start
@@ -12,12 +13,15 @@
  * 'kernel address space start' >> KASAN_SHADOW_SCALE_SHIFT
  */
 #define KASAN_SHADOW_START      (KASAN_SHADOW_OFFSET + \
-					((-1UL << __VIRTUAL_MASK_SHIFT) >> 3))
+					((-1UL << __VIRTUAL_MASK_SHIFT) >> \
+						KASAN_SHADOW_SCALE_SHIFT))
 /*
- * 47 bits for kernel address -> (47 - 3) bits for shadow
- * 56 bits for kernel address -> (56 - 3) bits for shadow
+ * 47 bits for kernel address -> (47 - KASAN_SHADOW_SCALE_SHIFT) bits for shadow
+ * 56 bits for kernel address -> (56 - KASAN_SHADOW_SCALE_SHIFT) bits for shadow
  */
-#define KASAN_SHADOW_END        (KASAN_SHADOW_START + (1ULL << (__VIRTUAL_MASK_SHIFT - 3)))
+#define KASAN_SHADOW_END        (KASAN_SHADOW_START + \
+					(1ULL << (__VIRTUAL_MASK_SHIFT - \
+						  KASAN_SHADOW_SCALE_SHIFT)))
 
 #ifndef __ASSEMBLY__
 
diff -puN include/linux/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage
+++ a/include/linux/kasan.h
@@ -11,8 +11,6 @@ struct task_struct;
 
 #ifdef CONFIG_KASAN
 
-#define KASAN_SHADOW_SCALE_SHIFT 3
