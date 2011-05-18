From: akpm@linux-foundation.org
Subject: [merged] um-fix-abort.patch removed from -mm tree
Date: Wed, 18 May 2011 11:27:45 -0700
Message-ID: <201105181827.p4IIRDo6015175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933461Ab1ERSdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 14:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: fix abort
has been removed from the -mm tree.  Its filename was
     um-fix-abort.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix abort
From: Richard Weinberger <richard@nod.at>

os_dump_core() uses abort() to terminate UML in case of an fatal error.

glibc's abort() calls raise(SIGABRT) which makes use of tgkill(). 
tgkill() has no effect within UML's kernel threads because they are not
pthreads.  As fallback abort() executes an invalid instruction to
terminate the process.  Therefore UML gets killed by SIGSEGV and leaves a
ugly log entry in the host's kernel ring buffer.

To get rid of this we use our own abort routine.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/util.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/util.c~um-fix-abort arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~um-fix-abort
+++ a/arch/um/os-Linux/util.c
@@ -5,6 +5,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
 #include <signal.h>
 #include <string.h>
@@ -75,6 +76,26 @@ void setup_hostinfo(char *buf, int len)
 		 host.release, host.version, host.machine);
 }
 
+/*
+ * We cannot use glibc's abort(). It makes use of tgkill() which
+ * has no effect within UML's kernel threads.
+ * After that glibc would execute an invalid instruction to kill
+ * the calling process and UML crashes with SIGSEGV.
+ */
+static inline void __attribute__ ((noreturn)) uml_abort(void)
+{
+	sigset_t sig;
+
+	fflush(NULL);
+
+	if (!sigemptyset(&sig) && !sigaddset(&sig, SIGABRT))
+		sigprocmask(SIG_UNBLOCK, &sig, 0);
+
+	for (;;)
+		if (kill(getpid(), SIGABRT) < 0)
+			exit(127);
+}
+
 void os_dump_core(void)
 {
 	int pid;
@@ -116,5 +137,5 @@ void os_dump_core(void)
 	while ((pid = waitpid(-1, NULL, WNOHANG | __WALL)) > 0)
 		os_kill_ptraced_process(pid, 0);
 
-	abort();
+	uml_abort();
 }
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
linux-next.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
lib-consolidate-debug_stack_usage-option.patch

