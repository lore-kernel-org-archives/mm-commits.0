From: akpm@linux-foundation.org
Subject: - array_size-check-for-type-uml-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:17:02 -0700
Message-ID: <200704301917.l3UJH2e4012638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946702AbXD3TR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     uml: update UML definition of ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     array_size-check-for-type-uml-fix.patch

This patch was dropped because it was folded into array_size-check-for-type.patch

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

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
