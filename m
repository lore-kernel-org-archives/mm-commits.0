Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DAE13AE2
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5hD/fbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2B6C433C7;
	Fri, 29 Dec 2023 20:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880069;
	bh=n33SqwEbOP/ZzkmEPHNyEewMeFcRdHtyFNUVTBokCWY=;
	h=Date:To:From:Subject:From;
	b=r5hD/fbGDfGbC5c93WQZ8UKro9VjJsaG/oW9V+s2wYBo3t6vjtkDH7G6eH4MKrKxr
	 e8KreTPrRWaL1jk5OboFU0uaGIi6+ul5PcSR8UQ+hjFiPlMJChkrvOdIRcZ4vKCs2U
	 c5HaGcxW9U5smodafXX2D47/eFzl1aVMxRDZ5bh8=
Date: Fri, 29 Dec 2023 12:01:08 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-arm64-improve-comments-for-kasan_shadow_start-end.patch removed from -mm tree
Message-Id: <20231229200109.1F2B6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan/arm64: improve comments for KASAN_SHADOW_START/END
has been removed from the -mm tree.  Its filename was
     kasan-arm64-improve-comments-for-kasan_shadow_start-end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan/arm64: improve comments for KASAN_SHADOW_START/END
Date: Thu, 21 Dec 2023 21:04:43 +0100

Patch series "kasan: assorted clean-ups".

Code clean-ups, nothing worthy of being backported to stable.


This patch (of 11):

Unify and improve the comments for KASAN_SHADOW_START/END definitions from
include/asm/kasan.h and include/asm/memory.h.

Also put both definitions together in include/asm/memory.h.

Also clarify the related BUILD_BUG_ON checks in mm/kasan_init.c.

Link: https://lkml.kernel.org/r/cover.1703188911.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/140108ca0b164648c395a41fbeecb0601b1ae9e1.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kasan.h  |   22 -----------------
 arch/arm64/include/asm/memory.h |   38 +++++++++++++++++++++++++-----
 arch/arm64/mm/kasan_init.c      |    5 +++
 3 files changed, 38 insertions(+), 27 deletions(-)

--- a/arch/arm64/include/asm/kasan.h~kasan-arm64-improve-comments-for-kasan_shadow_start-end
+++ a/arch/arm64/include/asm/kasan.h
@@ -15,29 +15,9 @@
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
+asmlinkage void kasan_early_init(void);
 void kasan_init(void);
-
-/*
- * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
- * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/N of kernel virtual addresses,
- * where N = (1 << KASAN_SHADOW_SCALE_SHIFT).
- *
- * KASAN_SHADOW_OFFSET:
- * This value is used to map an address to the corresponding shadow
- * address by the following formula:
- *     shadow_addr = (address >> KASAN_SHADOW_SCALE_SHIFT) + KASAN_SHADOW_OFFSET
- *
- * (1 << (64 - KASAN_SHADOW_SCALE_SHIFT)) shadow addresses that lie in range
- * [KASAN_SHADOW_OFFSET, KASAN_SHADOW_END) cover all 64-bits of virtual
- * addresses. So KASAN_SHADOW_OFFSET should satisfy the following equation:
- *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END -
- *				(1ULL << (64 - KASAN_SHADOW_SCALE_SHIFT))
- */
-#define _KASAN_SHADOW_START(va)	(KASAN_SHADOW_END - (1UL << ((va) - KASAN_SHADOW_SCALE_SHIFT)))
-#define KASAN_SHADOW_START      _KASAN_SHADOW_START(vabits_actual)
-
 void kasan_copy_shadow(pgd_t *pgdir);
-asmlinkage void kasan_early_init(void);
 
 #else
 static inline void kasan_init(void) { }
--- a/arch/arm64/include/asm/memory.h~kasan-arm64-improve-comments-for-kasan_shadow_start-end
+++ a/arch/arm64/include/asm/memory.h
@@ -65,15 +65,41 @@
 #define KERNEL_END		_end
 
 /*
- * Generic and tag-based KASAN require 1/8th and 1/16th of the kernel virtual
- * address space for the shadow region respectively. They can bloat the stack
- * significantly, so double the (minimum) stack size when they are in use.
+ * Generic and Software Tag-Based KASAN modes require 1/8th and 1/16th of the
+ * kernel virtual address space for storing the shadow memory respectively.
+ *
+ * The mapping between a virtual memory address and its corresponding shadow
+ * memory address is defined based on the formula:
+ *
+ *     shadow_addr = (addr >> KASAN_SHADOW_SCALE_SHIFT) + KASAN_SHADOW_OFFSET
+ *
+ * where KASAN_SHADOW_SCALE_SHIFT is the order of the number of bits that map
+ * to a single shadow byte and KASAN_SHADOW_OFFSET is a constant that offsets
+ * the mapping. Note that KASAN_SHADOW_OFFSET does not point to the start of
+ * the shadow memory region.
+ *
+ * Based on this mapping, we define two constants:
+ *
+ *     KASAN_SHADOW_START: the start of the shadow memory region;
+ *     KASAN_SHADOW_END: the end of the shadow memory region.
+ *
+ * KASAN_SHADOW_END is defined first as the shadow address that corresponds to
+ * the upper bound of possible virtual kernel memory addresses UL(1) << 64
+ * according to the mapping formula.
+ *
+ * KASAN_SHADOW_START is defined second based on KASAN_SHADOW_END. The shadow
+ * memory start must map to the lowest possible kernel virtual memory address
+ * and thus it depends on the actual bitness of the address space.
+ *
+ * As KASAN inserts redzones between stack variables, this increases the stack
+ * memory usage significantly. Thus, we double the (minimum) stack size.
  */
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_SHADOW_OFFSET	_AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
-#define KASAN_SHADOW_END	((UL(1) << (64 - KASAN_SHADOW_SCALE_SHIFT)) \
-					+ KASAN_SHADOW_OFFSET)
-#define PAGE_END		(KASAN_SHADOW_END - (1UL << (vabits_actual - KASAN_SHADOW_SCALE_SHIFT)))
+#define KASAN_SHADOW_END	((UL(1) << (64 - KASAN_SHADOW_SCALE_SHIFT)) + KASAN_SHADOW_OFFSET)
+#define _KASAN_SHADOW_START(va)	(KASAN_SHADOW_END - (UL(1) << ((va) - KASAN_SHADOW_SCALE_SHIFT)))
+#define KASAN_SHADOW_START	_KASAN_SHADOW_START(vabits_actual)
+#define PAGE_END		KASAN_SHADOW_START
 #define KASAN_THREAD_SHIFT	1
 #else
 #define KASAN_THREAD_SHIFT	0
--- a/arch/arm64/mm/kasan_init.c~kasan-arm64-improve-comments-for-kasan_shadow_start-end
+++ a/arch/arm64/mm/kasan_init.c
@@ -170,6 +170,11 @@ asmlinkage void __init kasan_early_init(
 {
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=
 		KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
+	/*
+	 * We cannot check the actual value of KASAN_SHADOW_START during build,
+	 * as it depends on vabits_actual. As a best-effort approach, check
+	 * potential values calculated based on VA_BITS and VA_BITS_MIN.
+	 */
 	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS), PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_MIN), PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

