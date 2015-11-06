From: akpm@linux-foundation.org
Subject: [merged]
 compilerh-add-support-for-function-attribute-assume_aligned.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:06:30 -0800
Message-ID: <563d0846.aVB9A4C+HGg8LmD+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031366AbbKFUGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: add support for function attribute assume_aligned
has been removed from the -mm tree.  Its filename was
     compilerh-add-support-for-function-attribute-assume_aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: compiler.h: add support for function attribute assume_aligned

gcc 4.9 added the function attribute assume_aligned, indicating to the
caller that the returned pointer may be assumed to have a certain minimal
alignment.  This is useful if, for example, the return value is passed to
memset().  Add a shorthand macro for that.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   17 +++++++++++++++++
 include/linux/compiler.h     |    8 ++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/compiler-gcc.h~compilerh-add-support-for-function-attribute-assume_aligned include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compilerh-add-support-for-function-attribute-assume_aligned
+++ a/include/linux/compiler-gcc.h
@@ -210,6 +210,23 @@
 #define __visible	__attribute__((externally_visible))
 #endif
 
+
+#if GCC_VERSION >= 40900
+/*
+ * __assume_aligned(n, k): Tell the optimizer that the returned
+ * pointer can be assumed to be k modulo n. The second argument is
+ * optional (default 0), so we use a variadic macro to make the
+ * shorthand.
+ *
+ * Beware: Do not apply this to functions which may return
+ * ERR_PTRs. Also, it is probably unwise to apply it to functions
+ * returning extra information in the low bits (but in that case the
+ * compiler should see some alignment anyway, when the return value is
+ * massaged by 'flags = ptr & 3; ptr &= ~3;').
+ */
+#define __assume_aligned(a, ...) __attribute__((__assume_aligned__(a, ## __VA_ARGS__)))
+#endif
+
 /*
  * GCC 'asm goto' miscompiles certain code sequences:
  *
diff -puN include/linux/compiler.h~compilerh-add-support-for-function-attribute-assume_aligned include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-add-support-for-function-attribute-assume_aligned
+++ a/include/linux/compiler.h
@@ -417,6 +417,14 @@ static __always_inline void __write_once
 #define __visible
 #endif
 
+/*
+ * Assume alignment of return value.
+ */
+#ifndef __assume_aligned
+#define __assume_aligned(a, ...)
+#endif
+
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #ifndef __same_type
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-maccessc-actually-return-efault-from-strncpy_from_unsafe.patch
slabh-sprinkle-__assume_aligned-attributes.patch
lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-vsprintfc-update-documentation.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

