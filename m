From: akpm@linux-foundation.org
Subject: - sys_futex64-allows-64bit-futexes-workaround-for-uml.patch removed from -mm tree
Date: Wed, 25 Apr 2007 02:23:11 -0700
Message-ID: <200704250923.l3P9NB99031712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992440AbXDYJX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 05:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, pierre.peiffer@bull.net, mm-commits@vger.kernel.org


The patch titled
     sys_futex64-allows-64bit-futexes-workaround for uml
has been removed from the -mm tree.  Its filename was
     sys_futex64-allows-64bit-futexes-workaround-for-uml.patch

This patch was dropped because it was folded into sys_futex64-allows-64bit-futexes.patch

------------------------------------------------------
Subject: sys_futex64-allows-64bit-futexes-workaround for uml
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

Copy sys_futex64-allows-64bit-futexes-workaround.patch to UML (to unbreak
the UML build).  Note however that in include/asm-generic/futex.h we have:

static inline int
futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
{
	return -ENOSYS;
}

Which is a better solution. Pierre Peiffer, please consider that.

Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/futex.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/asm-um/futex.h~sys_futex64-allows-64bit-futexes-workaround-for-uml include/asm-um/futex.h
--- a/include/asm-um/futex.h~sys_futex64-allows-64bit-futexes-workaround-for-uml
+++ a/include/asm-um/futex.h
@@ -3,4 +3,17 @@
 
 #include <asm-generic/futex.h>
 
+static inline u64
+futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
+{
+	return 0;
+}
+
+static inline int
+futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
+{
+	return 0;
+}
+
+
 #endif
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
uml-fix-umid-in-xterm-titles.patch
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
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
git-gccbug.patch
