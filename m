From: akpm@linux-foundation.org
Subject: - expose-range-checking-functions-from-arch-specific.patch removed from -mm tree
Date: Mon, 30 Apr 2007 20:19:54 -0700
Message-ID: <200705010319.l413JsN4021234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbXEADUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 23:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, linux-arch@vger.kernel.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Expose range-checking functions from arch-specific uaccess.h
has been removed from the -mm tree.  Its filename was
     expose-range-checking-functions-from-arch-specific.patch

This patch was dropped because we're not sure we want to do this

------------------------------------------------------
Subject: Expose range-checking functions from arch-specific uaccess.h
From: Rusty Russell <rusty@rustcorp.com.au>

There are some places where we want to check if a value + length is within
a range.  This can be tricky, so it's nice to have a single routine.

Also, this can be done more efficiently (with arch-dependent) carry bits,
as shown by the __range_ok() implementation on several archs.

This patch exposes arch-specific "val_outside(val, len, limit)" and a
generic "range_within(start, len, base, limit)" function.  As a
side-effect, it fixes the comment in i386/uaccess.h: __range_ok doesn't
test "(u33)addr + (u33)size >= (u33)current->addr_limit.seg", it tests
"(u33)addr + (u33)size > (u33)current->addr_limit.seg".

[akpm@linux-foundation.org: ugly build fix]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: <linux-arch@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/range.h     |    6 ++++++
 include/asm-arm/range.h       |    6 ++++++
 include/asm-arm26/range.h     |    6 ++++++
 include/asm-avr32/range.h     |    6 ++++++
 include/asm-blackfin/range.h  |    6 ++++++
 include/asm-cris/range.h      |    6 ++++++
 include/asm-frv/range.h       |    6 ++++++
 include/asm-generic/range.h   |   20 ++++++++++++++++++++
 include/asm-h8300/range.h     |    6 ++++++
 include/asm-i386/range.h      |   14 ++++++++++++++
 include/asm-i386/uaccess.h    |   16 ++++++----------
 include/asm-ia64/range.h      |    6 ++++++
 include/asm-m32r/range.h      |    6 ++++++
 include/asm-m68k/range.h      |    6 ++++++
 include/asm-m68knommu/range.h |    6 ++++++
 include/asm-mips/range.h      |    6 ++++++
 include/asm-parisc/range.h    |    6 ++++++
 include/asm-powerpc/range.h   |    6 ++++++
 include/asm-ppc/range.h       |    6 ++++++
 include/asm-s390/range.h      |    6 ++++++
 include/asm-sh/range.h        |    6 ++++++
 include/asm-sh64/range.h      |    6 ++++++
 include/asm-sparc/range.h     |    6 ++++++
 include/asm-sparc64/range.h   |    6 ++++++
 include/asm-um/range.h        |    6 ++++++
 include/asm-v850/range.h      |    6 ++++++
 include/asm-x86_64/range.h    |    6 ++++++
 include/asm-xtensa/range.h    |    6 ++++++
 include/linux/kernel.h        |    2 ++
 include/linux/range.h         |    6 ++++++
 30 files changed, 198 insertions(+), 10 deletions(-)

diff -puN /dev/null include/asm-alpha/range.h
--- /dev/null
+++ a/include/asm-alpha/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-arm/range.h
--- /dev/null
+++ a/include/asm-arm/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-arm26/range.h
--- /dev/null
+++ a/include/asm-arm26/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-avr32/range.h
--- /dev/null
+++ a/include/asm-avr32/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-blackfin/range.h
--- /dev/null
+++ a/include/asm-blackfin/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-cris/range.h
--- /dev/null
+++ a/include/asm-cris/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-frv/range.h
--- /dev/null
+++ a/include/asm-frv/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-generic/range.h
--- /dev/null
+++ a/include/asm-generic/range.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_GENERIC_RANGE_H
+#define _ASM_GENERIC_RANGE_H
+
+/**
+ * range_over_limit() - is a start and length past a limit?
+ * @start: the start value
+ * @len: the length from the start
+ * @limit: the first invalid value
+ *
+ * Like start + len > limit, except with overflow checking.
+ */
+static inline bool range_over_limit(unsigned long start, unsigned long len,
+				    unsigned long limit)
+
+{
+	return start + len > limit || start + len < start;
+}
+
+#endif	/* _ASM_GENERIC_RANGE_H */
+
diff -puN /dev/null include/asm-h8300/range.h
--- /dev/null
+++ a/include/asm-h8300/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-i386/range.h
--- /dev/null
+++ a/include/asm-i386/range.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+/* Is start + size > limit? This needs 33-bit arithmetic. We have a carry... */
+static inline bool range_over_limit(unsigned long start, unsigned long len,
+				    unsigned long limit)
+{
+	unsigned long flag, roksum;
+	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"
+		:"=&r" (flag), "=r" (roksum)
+		:"1" (start), "g" (len), "rm" (limit));
+	return flag;
+}
+#endif	/* __ASM_RANGE_H */
diff -puN include/asm-i386/uaccess.h~expose-range-checking-functions-from-arch-specific include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~expose-range-checking-functions-from-arch-specific
+++ a/include/asm-i386/uaccess.h
@@ -49,17 +49,13 @@ extern struct movsl_mask {
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg
- *
- * This needs 33-bit arithmetic. We have a carry...
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg
  */
-#define __range_ok(addr,size) ({ \
-	unsigned long flag,roksum; \
-	__chk_user_ptr(addr); \
-	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0" \
-		:"=&r" (flag), "=r" (roksum) \
-		:"1" (addr),"g" ((int)(size)),"rm" (current_thread_info()->addr_limit.seg)); \
-	flag; })
+#define __range_ok(addr, size) ({					\
+	__chk_user_ptr(addr);						\
+	range_over_limit((int)(addr), (size),				\
+			 current_thread_info()->addr_limit.seg);	\
+})
 
 /**
  * access_ok: - Checks if a user space pointer is valid
diff -puN /dev/null include/asm-ia64/range.h
--- /dev/null
+++ a/include/asm-ia64/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-m32r/range.h
--- /dev/null
+++ a/include/asm-m32r/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-m68k/range.h
--- /dev/null
+++ a/include/asm-m68k/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-m68knommu/range.h
--- /dev/null
+++ a/include/asm-m68knommu/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-mips/range.h
--- /dev/null
+++ a/include/asm-mips/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-parisc/range.h
--- /dev/null
+++ a/include/asm-parisc/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-powerpc/range.h
--- /dev/null
+++ a/include/asm-powerpc/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-ppc/range.h
--- /dev/null
+++ a/include/asm-ppc/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-s390/range.h
--- /dev/null
+++ a/include/asm-s390/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-sh/range.h
--- /dev/null
+++ a/include/asm-sh/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-sh64/range.h
--- /dev/null
+++ a/include/asm-sh64/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-sparc/range.h
--- /dev/null
+++ a/include/asm-sparc/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-sparc64/range.h
--- /dev/null
+++ a/include/asm-sparc64/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-um/range.h
--- /dev/null
+++ a/include/asm-um/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-v850/range.h
--- /dev/null
+++ a/include/asm-v850/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-x86_64/range.h
--- /dev/null
+++ a/include/asm-x86_64/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN /dev/null include/asm-xtensa/range.h
--- /dev/null
+++ a/include/asm-xtensa/range.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -puN include/linux/kernel.h~expose-range-checking-functions-from-arch-specific include/linux/kernel.h
--- a/include/linux/kernel.h~expose-range-checking-functions-from-arch-specific
+++ a/include/linux/kernel.h
@@ -14,6 +14,8 @@
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include <linux/log2.h>
+#include <linux/range.h>
+
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
diff -puN /dev/null include/linux/range.h
--- /dev/null
+++ a/include/linux/range.h
@@ -0,0 +1,6 @@
+#ifndef RANGE_H_INCLUDED
+#define RANGE_H_INCLUDED
+
+#include <asm/range.h>
+
+#endif		/* RANGE_H_INCLUDED */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
extend-print_symbol-capability.patch
git-kbuild.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
