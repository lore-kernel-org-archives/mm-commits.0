From: akpm@linux-foundation.org
Subject: + expose-range-checking-functions-from-arch-specific-update.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:44:28 -0700
Message-ID: <200704131844.l3DIiSiH006678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbXDMSol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, linux-arch@vger.kernel.org, randy.dunlap@oracle.com


The patch titled
     expose-range-checking-functions-from-arch-specific update
has been added to the -mm tree.  Its filename is
     expose-range-checking-functions-from-arch-specific-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: expose-range-checking-functions-from-arch-specific update
From: Rusty Russell <rusty@rustcorp.com.au>

range_within() was too ambitious: it started inspiring people.  Remove it.

val_outside() was a terrible name, too.  Try range_over_limit().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: <linux-arch@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/range.h |   12 ++++++------
 include/asm-i386/range.h    |    8 ++++----
 include/asm-i386/uaccess.h  |    8 ++++----
 include/linux/kernel.h      |   21 ---------------------
 4 files changed, 14 insertions(+), 35 deletions(-)

diff -puN include/asm-generic/range.h~expose-range-checking-functions-from-arch-specific-update include/asm-generic/range.h
--- a/include/asm-generic/range.h~expose-range-checking-functions-from-arch-specific-update
+++ a/include/asm-generic/range.h
@@ -2,18 +2,18 @@
 #define _ASM_GENERIC_RANGE_H
 
 /**
- * val_outside - is a value and length past a limit?
- * @val: the start value
+ * range_over_limit() - is a start and length past a limit?
+ * @start: the start value
  * @len: the length from the start
  * @limit: the first invalid value
  *
- * Like val + len > limit, except with overflow checking.
+ * Like start + len > limit, except with overflow checking.
  */
-static inline bool val_outside(unsigned long val, unsigned long len,
-			       unsigned long limit)
+static inline bool range_over_limit(unsigned long start, unsigned long len,
+				    unsigned long limit)
 
 {
-	return val + len > limit || val + len < val;
+	return start + len > limit || start + len < start;
 }
 
 #endif	/* _ASM_GENERIC_RANGE_H */
diff -puN include/asm-i386/range.h~expose-range-checking-functions-from-arch-specific-update include/asm-i386/range.h
--- a/include/asm-i386/range.h~expose-range-checking-functions-from-arch-specific-update
+++ a/include/asm-i386/range.h
@@ -1,14 +1,14 @@
 #ifndef __ASM_RANGE_H
 #define __ASM_RANGE_H
 
-/* Is val + size > limit? This needs 33-bit arithmetic. We have a carry... */
-static inline bool val_outside(unsigned long val, unsigned long len,
-			       unsigned long limit)
+/* Is start + size > limit? This needs 33-bit arithmetic. We have a carry... */
+static inline bool range_over_limit(unsigned long start, unsigned long len,
+				    unsigned long limit)
 {
 	unsigned long flag, roksum;
 	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"
 		:"=&r" (flag), "=r" (roksum)
-		:"1" (val), "g" (len), "rm" (limit));
+		:"1" (start), "g" (len), "rm" (limit));
 	return flag;
 }
 #endif	/* __ASM_RANGE_H */
diff -puN include/asm-i386/uaccess.h~expose-range-checking-functions-from-arch-specific-update include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~expose-range-checking-functions-from-arch-specific-update
+++ a/include/asm-i386/uaccess.h
@@ -51,10 +51,10 @@ extern struct movsl_mask {
  * This is equivalent to the following test:
  * (u33)addr + (u33)size > (u33)current->addr_limit.seg
  */
-#define __range_ok(addr, size) ({				\
-	__chk_user_ptr(addr);					\
-	val_outside((int)(addr), (size),			\
-		    current_thread_info()->addr_limit.seg);	\
+#define __range_ok(addr, size) ({					\
+	__chk_user_ptr(addr);						\
+	range_over_limit((int)(addr), (size),				\
+			 current_thread_info()->addr_limit.seg);	\
 })
 
 /**
diff -puN include/linux/kernel.h~expose-range-checking-functions-from-arch-specific-update include/linux/kernel.h
--- a/include/linux/kernel.h~expose-range-checking-functions-from-arch-specific-update
+++ a/include/linux/kernel.h
@@ -16,7 +16,6 @@
 #include <linux/log2.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
-#include <asm/range.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -312,26 +311,6 @@ static inline int __attribute__ ((format
 	(void)__tmp; \
 })
 
-/**
- * range_within - is one range within another?
- * @start: the start value
- * @len: the length from the start
- * @base: the first valid value
- * @limit: the first invalid value
- *
- * This is usually used for memory range testing.  The common cases of
- * constant 0 start and constant 0 len cases are optimized out.
- */
-static inline bool range_within(unsigned long start, unsigned long len,
-				unsigned long base, unsigned long limit)
-{
-	if (start < base)
-		return false;
-	if (__builtin_constant_p(len) && len == 0)
-		return start - base <= limit - base;
-	return !val_outside(limit, start, len);
-}
-
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-kernel-oops-with-badly-formatted-module-option.patch
git-kbuild.patch
git-net.patch
account-for-module-percpu-space-separately-from-kernel.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
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
expose-range-checking-functions-from-arch-specific-update.patch
____call_usermodehelper-dont-flush_signals.patch
futex-new-private-futexes.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
