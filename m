From: akpm@linux-foundation.org
Subject: + array_size-check-for-type-uml-fix.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:36:16 -0700
Message-ID: <200703222136.l2MLaG8u030903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52765 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161049AbXCVVg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, rusty@rustcorp.com.au


The patch titled
     uml: update UML definition of ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     array_size-check-for-type-uml-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: update UML definition of ARRAY_SIZE
From: Jeff Dike <jdike@addtoit.com>

This is the minimal change needed to keep UML building with the new definition
of ARRAY_SIZE.  It is defined in user_util.h so that userspace files, which
can't include kernel.h, can still use ARRAY_SIZE.  However, since user_util.h
is included everywhere, including kernel files, the token sequence of the
expansion has to match.

This patch copies enough from the kernel headers to make that happen.

However, this is too gross to survive, and so is the entire header.  Future
patches will make this header disappear, but this is a quick and simple fix
for the problem in case there is a noticable lag between this patch and the
more extensive patches which tidy this mess.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user_util.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN arch/um/include/user_util.h~array_size-check-for-type-uml-fix arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~array_size-check-for-type-uml-fix
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
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
array_size-check-for-type-uml-fix.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
