From: akpm@linux-foundation.org
Subject: [merged] x86-fix-the-x86_64-implementation-of-call_rwsem_wait.patch removed from -mm tree
Date: Thu, 06 May 2010 16:47:43 -0700
Message-ID: <201005062347.o46Nlhht022115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab0EFXs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 19:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix the x86_64 implementation of call_rwsem_wait()
has been removed from the -mm tree.  Its filename was
     x86-fix-the-x86_64-implementation-of-call_rwsem_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix the x86_64 implementation of call_rwsem_wait()
From: David Howells <dhowells@redhat.com>

The x86_64 call_rwsem_wait() treats the active state counter part of the
R/W semaphore state as being 16-bit when it's actually 32-bit (it's half
of the 64-bit state).  It should do "decl %edx" not "decw %dx".

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/rwsem_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/lib/rwsem_64.S~x86-fix-the-x86_64-implementation-of-call_rwsem_wait arch/x86/lib/rwsem_64.S
--- a/arch/x86/lib/rwsem_64.S~x86-fix-the-x86_64-implementation-of-call_rwsem_wait
+++ a/arch/x86/lib/rwsem_64.S
@@ -60,7 +60,7 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decw %dx    /* do nothing if still outstanding active readers */
+	decl %edx	/* do nothing if still outstanding active readers */
 	jnz 1f
 	save_common_regs
 	movq %rax,%rdi
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
x86-fix-the-x86_64-implementation-of-call_rwsem_wait.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
mn10300-use-generic-atomich.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

