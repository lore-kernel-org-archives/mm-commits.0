From: akpm@linux-foundation.org
Subject: [merged]
 x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:22 -0800
Message-ID: <54e2508e.T+iikSwgt8djE8ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbBPUS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86_64: kasan: add interceptors for memset/memmove/memcpy functions
has been removed from the -mm tree.  Its filename was
     x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: x86_64: kasan: add interceptors for memset/memmove/memcpy functions

Recently instrumentation of builtin functions calls was removed from GCC
5.0.  To check the memory accessed by such functions, userspace asan
always uses interceptors for them.

So now we should do this as well.  This patch declares
memset/memmove/memcpy as weak symbols.  In mm/kasan/kasan.c we have our
own implementation of those functions which checks memory before accessing
it.

Default memset/memmove/memcpy now now always have aliases with '__'
prefix.  For files that built without kasan instrumentation (e.g. 
mm/slub.c) original mem* replaced (via #define) with prefixed variants,
cause we don't want to check memory accesses there.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/eboot.c       |    3 --
 arch/x86/boot/compressed/misc.h        |    1 
 arch/x86/include/asm/string_64.h       |   18 +++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c       |   10 ++++++-
 arch/x86/lib/memcpy_64.S               |    6 +++-
 arch/x86/lib/memmove_64.S              |    4 +++
 arch/x86/lib/memset_64.S               |   10 ++++---
 drivers/firmware/efi/libstub/efistub.h |    4 +++
 mm/kasan/kasan.c                       |   29 +++++++++++++++++++++++
 9 files changed, 74 insertions(+), 11 deletions(-)

diff -puN arch/x86/boot/compressed/eboot.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/boot/compressed/eboot.c
--- a/arch/x86/boot/compressed/eboot.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/boot/compressed/eboot.c
@@ -13,8 +13,7 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 
-#undef memcpy			/* Use memcpy from misc.c */
-
+#include "../string.h"
 #include "eboot.h"
 
 static efi_system_table_t *sys_table;
diff -puN arch/x86/boot/compressed/misc.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/boot/compressed/misc.h
--- a/arch/x86/boot/compressed/misc.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/boot/compressed/misc.h
@@ -7,6 +7,7 @@
  * we just keep it from happening
  */
 #undef CONFIG_PARAVIRT
+#undef CONFIG_KASAN
 #ifdef CONFIG_X86_32
 #define _ASM_X86_DESC_H 1
 #endif
diff -puN arch/x86/include/asm/string_64.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/include/asm/string_64.h
--- a/arch/x86/include/asm/string_64.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/include/asm/string_64.h
@@ -27,11 +27,12 @@ static __always_inline void *__inline_me
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
+extern void *__memcpy(void *to, const void *from, size_t len);
+
 #ifndef CONFIG_KMEMCHECK
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
 extern void *memcpy(void *to, const void *from, size_t len);
 #else
-extern void *__memcpy(void *to, const void *from, size_t len);
 #define memcpy(dst, src, len)					\
 ({								\
 	size_t __len = (len);					\
@@ -53,9 +54,11 @@ extern void *__memcpy(void *to, const vo
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
+void *__memmove(void *dest, const void *src, size_t count);
 
 int memcmp(const void *cs, const void *ct, size_t count);
 size_t strlen(const char *s);
@@ -63,6 +66,19 @@ char *strcpy(char *dest, const char *src
 char *strcat(char *dest, const char *src);
 int strcmp(const char *cs, const char *ct);
 
+#if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
+
+/*
+ * For files that not instrumented (e.g. mm/slub.c) we
+ * should use not instrumented version of mem* functions.
+ */
+
+#undef memcpy
+#define memcpy(dst, src, len) __memcpy(dst, src, len)
+#define memmove(dst, src, len) __memmove(dst, src, len)
+#define memset(s, c, n) __memset(s, c, n)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_64_H */
diff -puN arch/x86/kernel/x8664_ksyms_64.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/kernel/x8664_ksyms_64.c
--- a/arch/x86/kernel/x8664_ksyms_64.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/kernel/x8664_ksyms_64.c
@@ -50,13 +50,19 @@ EXPORT_SYMBOL(csum_partial);
 #undef memset
 #undef memmove
 
+extern void *__memset(void *, int, __kernel_size_t);
+extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *__memmove(void *, const void *, __kernel_size_t);
 extern void *memset(void *, int, __kernel_size_t);
 extern void *memcpy(void *, const void *, __kernel_size_t);
-extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+EXPORT_SYMBOL(__memset);
+EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(__memmove);
 
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
-EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(memmove);
 
 #ifndef CONFIG_DEBUG_VIRTUAL
diff -puN arch/x86/lib/memcpy_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/lib/memcpy_64.S
--- a/arch/x86/lib/memcpy_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/lib/memcpy_64.S
@@ -53,6 +53,8 @@
 .Lmemcpy_e_e:
 	.previous
 
+.weak memcpy
+
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
@@ -199,8 +201,8 @@ ENDPROC(__memcpy)
 	 * only outcome...
 	 */
 	.section .altinstructions, "a"
-	altinstruction_entry memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
+	altinstruction_entry __memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
 			     .Lmemcpy_e-.Lmemcpy_c,.Lmemcpy_e-.Lmemcpy_c
-	altinstruction_entry memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
+	altinstruction_entry __memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
 			     .Lmemcpy_e_e-.Lmemcpy_c_e,.Lmemcpy_e_e-.Lmemcpy_c_e
 	.previous
diff -puN arch/x86/lib/memmove_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/lib/memmove_64.S
--- a/arch/x86/lib/memmove_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/lib/memmove_64.S
@@ -24,7 +24,10 @@
  * Output:
  * rax: dest
  */
+.weak memmove
+
 ENTRY(memmove)
+ENTRY(__memmove)
 	CFI_STARTPROC
 
 	/* Handle more 32 bytes in loop */
@@ -220,4 +223,5 @@ ENTRY(memmove)
 		.Lmemmove_end_forward-.Lmemmove_begin_forward,	\
 		.Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
 	.previous
+ENDPROC(__memmove)
 ENDPROC(memmove)
diff -puN arch/x86/lib/memset_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions arch/x86/lib/memset_64.S
--- a/arch/x86/lib/memset_64.S~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/arch/x86/lib/memset_64.S
@@ -56,6 +56,8 @@
 .Lmemset_e_e:
 	.previous
 
+.weak memset
+
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
@@ -147,8 +149,8 @@ ENDPROC(__memset)
          * feature to implement the right patch order.
 	 */
 	.section .altinstructions,"a"
-	altinstruction_entry memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
-			     .Lfinal-memset,.Lmemset_e-.Lmemset_c
-	altinstruction_entry memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
-			     .Lfinal-memset,.Lmemset_e_e-.Lmemset_c_e
+	altinstruction_entry __memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
+			     .Lfinal-__memset,.Lmemset_e-.Lmemset_c
+	altinstruction_entry __memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
+			     .Lfinal-__memset,.Lmemset_e_e-.Lmemset_c_e
 	.previous
diff -puN drivers/firmware/efi/libstub/efistub.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions drivers/firmware/efi/libstub/efistub.h
--- a/drivers/firmware/efi/libstub/efistub.h~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/drivers/firmware/efi/libstub/efistub.h
@@ -5,6 +5,10 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
+#undef memcpy
+#undef memset
+#undef memmove
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff -puN mm/kasan/kasan.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions
+++ a/mm/kasan/kasan.c
@@ -255,6 +255,35 @@ static __always_inline void check_memory
 	kasan_report(addr, size, write, _RET_IP_);
 }
 
+void __asan_loadN(unsigned long addr, size_t size);
+void __asan_storeN(unsigned long addr, size_t size);
+
+#undef memset
+void *memset(void *addr, int c, size_t len)
+{
+	__asan_storeN((unsigned long)addr, len);
+
+	return __memset(addr, c, len);
+}
+
+#undef memmove
+void *memmove(void *dest, const void *src, size_t len)
+{
+	__asan_loadN((unsigned long)src, len);
+	__asan_storeN((unsigned long)dest, len);
+
+	return __memmove(dest, src, len);
+}
+
+#undef memcpy
+void *memcpy(void *dest, const void *src, size_t len)
+{
+	__asan_loadN((unsigned long)src, len);
+	__asan_storeN((unsigned long)dest, len);
+
+	return __memcpy(dest, src, len);
+}
+
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

