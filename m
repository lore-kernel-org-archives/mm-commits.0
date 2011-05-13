From: akpm@linux-foundation.org
Subject: + um-os_dump_core-cleanup.patch added to -mm tree
Date: Fri, 13 May 2011 10:55:26 -0700
Message-ID: <201105131747.p4DHlo75030024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098Ab1EMRsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 May 2011 13:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: os_dump_core() cleanup
has been added to the -mm tree.  Its filename is
     um-os_dump_core-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: os_dump_core() cleanup
From: Richard Weinberger <richard@nod.at>

When os_dump_core() raises SIGTERM to bring down all UML processes this
would also trigger the quite complex do_uml_exitcalls() routine.  This is
why UML crashed often while panicking.

Let's make os_dump_core() short and painless by killing all UML processes
with SIGHUP and calling the only sane exit call in this context
(remove_umid_dir()) by hand.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/shared/os.h |    1 +
 arch/um/os-Linux/umid.c     |    2 +-
 arch/um/os-Linux/util.c     |   22 +++++++---------------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff -puN arch/um/include/shared/os.h~um-os_dump_core-cleanup arch/um/include/shared/os.h
--- a/arch/um/include/shared/os.h~um-os_dump_core-cleanup
+++ a/arch/um/include/shared/os.h
@@ -226,6 +226,7 @@ extern int os_get_thread_area(user_desc_
 extern int umid_file_name(char *name, char *buf, int len);
 extern int set_umid(char *name);
 extern char *get_umid(void);
+extern void remove_umid_dir(void);
 
 /* signal.c */
 extern void timer_init(void);
diff -puN arch/um/os-Linux/umid.c~um-os_dump_core-cleanup arch/um/os-Linux/umid.c
--- a/arch/um/os-Linux/umid.c~um-os_dump_core-cleanup
+++ a/arch/um/os-Linux/umid.c
@@ -382,7 +382,7 @@ __uml_setup("uml_dir=", set_uml_dir,
 "    The location to place the pid and umid files.\n\n"
 );
 
-static void remove_umid_dir(void)
+void remove_umid_dir(void)
 {
 	char dir[strlen(uml_dir) + UMID_LEN + 1], err;
 
diff -puN arch/um/os-Linux/util.c~um-os_dump_core-cleanup arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~um-os_dump_core-cleanup
+++ a/arch/um/os-Linux/util.c
@@ -103,30 +103,21 @@ void os_dump_core(void)
 	signal(SIGSEGV, SIG_DFL);
 
 	/*
-	 * We are about to SIGTERM this entire process group to ensure that
-	 * nothing is around to run after the kernel exits.  The
-	 * kernel wants to abort, not die through SIGTERM, so we
-	 * ignore it here.
+	 * Send SIGHUP to kill non-kernel processes, kernel processes
+	 * ignore SIGHUP.
+	 * We are using SIGHUP because it has the same effect as SIGTERM
+	 * but it does not trigger other signal handlers.
 	 */
+	kill(0, SIGHUP);
 
-	signal(SIGTERM, SIG_IGN);
-	kill(0, SIGTERM);
 	/*
 	 * Most of the other processes associated with this UML are
 	 * likely sTopped, so give them a SIGCONT so they see the
-	 * SIGTERM.
+	 * SIGHUP.
 	 */
 	kill(0, SIGCONT);
 
 	/*
-	 * Now, having sent signals to everyone but us, make sure they
-	 * die by ptrace.  Processes can survive what's been done to
-	 * them so far - the mechanism I understand is receiving a
-	 * SIGSEGV and segfaulting immediately upon return.  There is
-	 * always a SIGSEGV pending, and (I'm guessing) signals are
-	 * processed in numeric order so the SIGTERM (signal 15 vs
-	 * SIGSEGV being signal 11) is never handled.
-	 *
 	 * Run a waitpid loop until we get some kind of error.
 	 * Hopefully, it's ECHILD, but there's not a lot we can do if
 	 * it's something else.  Tell os_kill_ptraced_process not to
@@ -137,5 +128,6 @@ void os_dump_core(void)
 	while ((pid = waitpid(-1, NULL, WNOHANG | __WALL)) > 0)
 		os_kill_ptraced_process(pid, 0);
 
+	remove_umid_dir();
 	uml_abort();
 }
_

Patches currently in -mm which might be from richard@nod.at are

x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch
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
um-fix-uml_lib_path.patch
um-fix-abort.patch
um-remove-sighup-handler.patch
um-os_dump_core-cleanup.patch
lib-consolidate-debug_stack_usage-option.patch

