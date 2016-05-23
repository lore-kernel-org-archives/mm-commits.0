From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-print-name-of-mem-caller-in-report.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:47:27 -0700
Message-ID: <57435e4f.iXq9O2hdDtwCqTKX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbcEWTr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: print name of mem[set,cpy,move]() caller in report
has been removed from the -mm tree.  Its filename was
     mm-kasan-print-name-of-mem-caller-in-report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: print name of mem[set,cpy,move]() caller in report

When bogus memory access happens in mem[set,cpy,move]() it's usually
caller's fault.  So don't blame mem[set,cpy,move]() in bug report, blame
the caller instead.

Before:
BUG: KASAN: out-of-bounds access in memset+0x23/0x40 at <address>
After:
BUG: KASAN: out-of-bounds access in <memset_caller> at <address>

Link: http://lkml.kernel.org/r/1462538722-1574-2-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   64 +++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-print-name-of-mem-caller-in-report mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-print-name-of-mem-caller-in-report
+++ a/mm/kasan/kasan.c
@@ -273,32 +273,36 @@ static __always_inline bool memory_is_po
 	return memory_is_poisoned_n(addr, size);
 }
 
-
-static __always_inline void check_memory_region(unsigned long addr,
-						size_t size, bool write)
+static __always_inline void check_memory_region_inline(unsigned long addr,
+						size_t size, bool write,
+						unsigned long ret_ip)
 {
 	if (unlikely(size == 0))
 		return;
 
 	if (unlikely((void *)addr <
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START))) {
-		kasan_report(addr, size, write, _RET_IP_);
+		kasan_report(addr, size, write, ret_ip);
 		return;
 	}
 
 	if (likely(!memory_is_poisoned(addr, size)))
 		return;
 
-	kasan_report(addr, size, write, _RET_IP_);
+	kasan_report(addr, size, write, ret_ip);
 }
 
-void __asan_loadN(unsigned long addr, size_t size);
-void __asan_storeN(unsigned long addr, size_t size);
+static void check_memory_region(unsigned long addr,
+				size_t size, bool write,
+				unsigned long ret_ip)
+{
+	check_memory_region_inline(addr, size, write, ret_ip);
+}
 
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
-	__asan_storeN((unsigned long)addr, len);
+	check_memory_region((unsigned long)addr, len, true, _RET_IP_);
 
 	return __memset(addr, c, len);
 }
@@ -306,8 +310,8 @@ void *memset(void *addr, int c, size_t l
 #undef memmove
 void *memmove(void *dest, const void *src, size_t len)
 {
-	__asan_loadN((unsigned long)src, len);
-	__asan_storeN((unsigned long)dest, len);
+	check_memory_region((unsigned long)src, len, false, _RET_IP_);
+	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
 
 	return __memmove(dest, src, len);
 }
@@ -315,8 +319,8 @@ void *memmove(void *dest, const void *sr
 #undef memcpy
 void *memcpy(void *dest, const void *src, size_t len)
 {
-	__asan_loadN((unsigned long)src, len);
-	__asan_storeN((unsigned long)dest, len);
+	check_memory_region((unsigned long)src, len, false, _RET_IP_);
+	check_memory_region((unsigned long)dest, len, true, _RET_IP_);
 
 	return __memcpy(dest, src, len);
 }
@@ -690,22 +694,22 @@ void __asan_unregister_globals(struct ka
 }
 EXPORT_SYMBOL(__asan_unregister_globals);
 
-#define DEFINE_ASAN_LOAD_STORE(size)				\
-	void __asan_load##size(unsigned long addr)		\
-	{							\
-		check_memory_region(addr, size, false);		\
-	}							\
-	EXPORT_SYMBOL(__asan_load##size);			\
-	__alias(__asan_load##size)				\
-	void __asan_load##size##_noabort(unsigned long);	\
-	EXPORT_SYMBOL(__asan_load##size##_noabort);		\
-	void __asan_store##size(unsigned long addr)		\
-	{							\
-		check_memory_region(addr, size, true);		\
-	}							\
-	EXPORT_SYMBOL(__asan_store##size);			\
-	__alias(__asan_store##size)				\
-	void __asan_store##size##_noabort(unsigned long);	\
+#define DEFINE_ASAN_LOAD_STORE(size)					\
+	void __asan_load##size(unsigned long addr)			\
+	{								\
+		check_memory_region_inline(addr, size, false, _RET_IP_);\
+	}								\
+	EXPORT_SYMBOL(__asan_load##size);				\
+	__alias(__asan_load##size)					\
+	void __asan_load##size##_noabort(unsigned long);		\
+	EXPORT_SYMBOL(__asan_load##size##_noabort);			\
+	void __asan_store##size(unsigned long addr)			\
+	{								\
+		check_memory_region_inline(addr, size, true, _RET_IP_);	\
+	}								\
+	EXPORT_SYMBOL(__asan_store##size);				\
+	__alias(__asan_store##size)					\
+	void __asan_store##size##_noabort(unsigned long);		\
 	EXPORT_SYMBOL(__asan_store##size##_noabort)
 
 DEFINE_ASAN_LOAD_STORE(1);
@@ -716,7 +720,7 @@ DEFINE_ASAN_LOAD_STORE(16);
 
 void __asan_loadN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, false);
+	check_memory_region(addr, size, false, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_loadN);
 
@@ -726,7 +730,7 @@ EXPORT_SYMBOL(__asan_loadN_noabort);
 
 void __asan_storeN(unsigned long addr, size_t size)
 {
-	check_memory_region(addr, size, true);
+	check_memory_region(addr, size, true, _RET_IP_);
 }
 EXPORT_SYMBOL(__asan_storeN);
 
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-add-api-to-check-memory-regions.patch
x86-kasan-instrument-user-memory-access-api.patch
kasan-tests-add-tests-for-user-memory-access-functions.patch

