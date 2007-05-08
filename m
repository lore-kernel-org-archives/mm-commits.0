From: akpm@linux-foundation.org
Subject: - array_size-check-for-type.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:13 -0700
Message-ID: <200705080006.l4806DGp009162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967384AbXEHAGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     ARRAY_SIZE: check for type
has been removed from the -mm tree.  Its filename was
     array_size-check-for-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARRAY_SIZE: check for type
From: Rusty Russell <rusty@rustcorp.com.au>

We can use a gcc extension to ensure that ARRAY_SIZE() is handed an array,
not a pointer.  This is especially important when code is changed from a
fixed array to a pointer.  I assume the Intel compiler doesn't support
__builtin_types_compatible_p.

[jdike@addtoit.com: uml: update UML definition of ARRAY_SIZE]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user_util.h    |   15 +++++++++++++--
 include/linux/compiler-gcc.h   |    3 +++
 include/linux/compiler-intel.h |    3 +++
 include/linux/kernel.h         |    3 ++-
 4 files changed, 21 insertions(+), 3 deletions(-)

diff -puN arch/um/include/user_util.h~array_size-check-for-type arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~array_size-check-for-type
+++ a/arch/um/include/user_util.h
@@ -8,8 +8,19 @@
 
 #include "sysdep/ptrace.h"
 
-/* Copied from kernel.h */
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+/* Copied from kernel.h and compiler-gcc.h */
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a) \
+  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 
diff -puN include/linux/compiler-gcc.h~array_size-check-for-type include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~array_size-check-for-type
+++ a/include/linux/compiler-gcc.h
@@ -22,6 +22,9 @@
     __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a) \
+  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
 #define inline		inline		__attribute__((always_inline))
 #define __inline__	__inline__	__attribute__((always_inline))
diff -puN include/linux/compiler-intel.h~array_size-check-for-type include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~array_size-check-for-type
+++ a/include/linux/compiler-intel.h
@@ -21,6 +21,9 @@
      __ptr = (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
+#define __must_be_array(a) 0
+
 #endif
 
 #define uninitialized_var(x) x
diff -puN include/linux/kernel.h~array_size-check-for-type include/linux/kernel.h
--- a/include/linux/kernel.h~array_size-check-for-type
+++ a/include/linux/kernel.h
@@ -35,7 +35,8 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
