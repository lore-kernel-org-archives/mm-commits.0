From: akpm@linux-foundation.org
Subject: + expose-range-checking-functions-from-arch-specific.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:27:22 -0700
Message-ID: <200704062127.l36LRMA7019394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXDFV1e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, linux-arch@vger.kernel.org, randy.dunlap@oracle.com


The patch titled
     Expose range-checking functions from arch-specific uaccess.h
has been added to the -mm tree.  Its filename is
     expose-range-checking-functions-from-arch-specific.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 include/linux/kernel.h        |   21 +++++++++++++++++++++
 29 files changed, 211 insertions(+), 10 deletions(-)

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
+ * val_outside - is a value and length past a limit?
+ * @val: the start value
+ * @len: the length from the start
+ * @limit: the first invalid value
+ *
+ * Like val + len > limit, except with overflow checking.
+ */
+static inline bool val_outside(unsigned long val, unsigned long len,
+			       unsigned long limit)
+
+{
+	return val + len > limit || val + len < val;
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
+/* Is val + size > limit? This needs 33-bit arithmetic. We have a carry... */
+static inline bool val_outside(unsigned long val, unsigned long len,
+			       unsigned long limit)
+{
+	unsigned long flag, roksum;
+	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"
+		:"=&r" (flag), "=r" (roksum)
+		:"1" (val), "g" (len), "rm" (limit));
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
+#define __range_ok(addr, size) ({				\
+	__chk_user_ptr(addr);					\
+	val_outside((int)(addr), (size),			\
+		    current_thread_info()->addr_limit.seg);	\
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
@@ -16,6 +16,7 @@
 #include <linux/log2.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
+#include <asm/range.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -311,6 +312,26 @@ static inline int __attribute__ ((format
 	(void)__tmp; \
 })
 
+/**
+ * range_within - is one range within another?
+ * @start: the start value
+ * @len: the length from the start
+ * @base: the first valid value
+ * @limit: the first invalid value
+ *
+ * This is usually used for memory range testing.  The common cases of
+ * constant 0 start and constant 0 len cases are optimized out.
+ */
+static inline bool range_within(unsigned long start, unsigned long len,
+				unsigned long base, unsigned long limit)
+{
+	if (start < base)
+		return false;
+	if (__builtin_constant_p(len) && len == 0)
+		return start - base <= limit - base;
+	return !val_outside(limit, start, len);
+}
+
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

vmi-paravirt-ops-bugfix-for-2621.patch
git-kbuild.patch
git-net.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
____call_usermodehelper-dont-flush_signals.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
