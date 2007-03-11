From: akpm@linux-foundation.org
Subject: + array_size-check-for-type.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:16:29 -0800
Message-ID: <200703110816.l2B8GTxB007711@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbXCKIQf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     ARRAY_SIZE: check for type
has been added to the -mm tree.  Its filename is
     array_size-check-for-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARRAY_SIZE: check for type
From: Rusty Russell <rusty@rustcorp.com.au>

We can use a gcc extension to ensure that ARRAY_SIZE() is handed an array,
not a pointer.  This is especially important when code is changed from a
fixed array to a pointer.  I assume the Intel compiler doesn't support
__builtin_types_compatible_p.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h   |    3 +++
 include/linux/compiler-intel.h |    3 +++
 include/linux/kernel.h         |    3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

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
@@ -21,4 +21,7 @@
      __ptr = (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
+#define __must_be_array(a) 0
+
 #endif
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

futex-restartable-futex_wait.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
