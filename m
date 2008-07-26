From: akpm@linux-foundation.org
Subject: - tracehook-tracehook_expect_breakpoints.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:49 -0700
Message-ID: <200807262116.m6QLGnTR019868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757912AbYGZVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: tracehook_expect_breakpoints
has been removed from the -mm tree.  Its filename was
     tracehook-tracehook_expect_breakpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: tracehook_expect_breakpoints
From: Roland McGrath <roland@redhat.com>

This adds tracehook_expect_breakpoints() as a formal hook for the nommu
code to use for its, "Is text-poking likely?" check at mmap time.  This
names the actual semantics the code means to test, and documents it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   15 +++++++++++++++
 mm/nommu.c                |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-tracehook_expect_breakpoints include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_expect_breakpoints
+++ a/include/linux/tracehook.h
@@ -52,6 +52,21 @@
 struct linux_binprm;
 
 /**
+ * tracehook_expect_breakpoints - guess if task memory might be touched
+ * @task:		current task, making a new mapping
+ *
+ * Return nonzero if @task is expected to want breakpoint insertion in
+ * its memory at some point.  A zero return is no guarantee it won't
+ * be done, but this is a hint that it's known to be likely.
+ *
+ * May be called with @task->mm->mmap_sem held for writing.
+ */
+static inline int tracehook_expect_breakpoints(struct task_struct *task)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
+/**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
  *
diff -puN mm/nommu.c~tracehook-tracehook_expect_breakpoints mm/nommu.c
--- a/mm/nommu.c~tracehook-tracehook_expect_breakpoints
+++ a/mm/nommu.c
@@ -22,7 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
@@ -745,7 +745,7 @@ static unsigned long determine_vm_flags(
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
-	if ((flags & MAP_PRIVATE) && (current->ptrace & PT_PTRACED))
+	if ((flags & MAP_PRIVATE) && tracehook_expect_breakpoints(current))
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

