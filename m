From: akpm@linux-foundation.org
Subject: [merged]
 kasan-added-functions-for-unpoisoning-stack-variables.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:55:19 -0800
Message-ID: <20180207195519.pZoOO5s_N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754303AbeBGTzU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, fengguang.wu@intel.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, yamada.masahiro@socionext.com


The patch titled
     Subject: kasan: add functions for unpoisoning stack variables
has been removed from the -mm tree.  Its filename was
     kasan-added-functions-for-unpoisoning-stack-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: add functions for unpoisoning stack variables

As a code-size optimization, LLVM builds since r279383 may bulk-manipulate
the shadow region when (un)poisoning large memory blocks.  This requires
new callbacks that simply do an uninstrumented memset().

This fixes linking the Clang-built kernel when using KASAN.

[arnd@arndb.de: add declarations for internal functions]
  Link: http://lkml.kernel.org/r/20180105094112.2690475-1-arnd@arndb.de
[fengguang.wu@intel.com: __asan_set_shadow_00 can be static]
  Link: http://lkml.kernel.org/r/20171223125943.GA74341@lkp-ib03
[ghackmann@google.com: fix memset() parameters, and tweak commit message to describe new callbacks]
Link: http://lkml.kernel.org/r/20171204191735.132544-6-paullawrence@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   15 +++++++++++++++
 mm/kasan/kasan.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff -puN mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables
+++ a/mm/kasan/kasan.c
@@ -770,6 +770,21 @@ void __asan_allocas_unpoison(const void
 }
 EXPORT_SYMBOL(__asan_allocas_unpoison);
 
+/* Emitted by the compiler to [un]poison local variables. */
+#define DEFINE_ASAN_SET_SHADOW(byte) \
+	void __asan_set_shadow_##byte(const void *addr, size_t size)	\
+	{								\
+		__memset((void *)addr, 0x##byte, size);			\
+	}								\
+	EXPORT_SYMBOL(__asan_set_shadow_##byte)
+
+DEFINE_ASAN_SET_SHADOW(00);
+DEFINE_ASAN_SET_SHADOW(f1);
+DEFINE_ASAN_SET_SHADOW(f2);
+DEFINE_ASAN_SET_SHADOW(f3);
+DEFINE_ASAN_SET_SHADOW(f5);
+DEFINE_ASAN_SET_SHADOW(f8);
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
diff -puN mm/kasan/kasan.h~kasan-added-functions-for-unpoisoning-stack-variables mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-added-functions-for-unpoisoning-stack-variables
+++ a/mm/kasan/kasan.h
@@ -121,4 +121,48 @@ static inline void quarantine_reduce(voi
 static inline void quarantine_remove_cache(struct kmem_cache *cache) { }
 #endif
 
+/*
+ * Exported functions for interfaces called from assembly or from generated
+ * code. Declarations here to avoid warning about missing declarations.
+ */
+asmlinkage void kasan_unpoison_task_stack_below(const void *watermark);
+void __asan_register_globals(struct kasan_global *globals, size_t size);
+void __asan_unregister_globals(struct kasan_global *globals, size_t size);
+void __asan_loadN(unsigned long addr, size_t size);
+void __asan_storeN(unsigned long addr, size_t size);
+void __asan_handle_no_return(void);
+void __asan_poison_stack_memory(const void *addr, size_t size);
+void __asan_unpoison_stack_memory(const void *addr, size_t size);
+void __asan_alloca_poison(unsigned long addr, size_t size);
+void __asan_allocas_unpoison(const void *stack_top, const void *stack_bottom);
+
+void __asan_load1(unsigned long addr);
+void __asan_store1(unsigned long addr);
+void __asan_load2(unsigned long addr);
+void __asan_store2(unsigned long addr);
+void __asan_load4(unsigned long addr);
+void __asan_store4(unsigned long addr);
+void __asan_load8(unsigned long addr);
+void __asan_store8(unsigned long addr);
+void __asan_load16(unsigned long addr);
+void __asan_store16(unsigned long addr);
+
+void __asan_load1_noabort(unsigned long addr);
+void __asan_store1_noabort(unsigned long addr);
+void __asan_load2_noabort(unsigned long addr);
+void __asan_store2_noabort(unsigned long addr);
+void __asan_load4_noabort(unsigned long addr);
+void __asan_store4_noabort(unsigned long addr);
+void __asan_load8_noabort(unsigned long addr);
+void __asan_store8_noabort(unsigned long addr);
+void __asan_load16_noabort(unsigned long addr);
+void __asan_store16_noabort(unsigned long addr);
+
+void __asan_set_shadow_00(const void *addr, size_t size);
+void __asan_set_shadow_f1(const void *addr, size_t size);
+void __asan_set_shadow_f2(const void *addr, size_t size);
+void __asan_set_shadow_f3(const void *addr, size_t size);
+void __asan_set_shadow_f5(const void *addr, size_t size);
+void __asan_set_shadow_f8(const void *addr, size_t size);
+
 #endif
_

Patches currently in -mm which might be from glider@google.com are


