From: akpm@linux-foundation.org
Subject: + binfmt_elf-fix-pt_interp-bss-handling.patch added to -mm tree
Date: Wed, 09 Sep 2009 15:34:57 -0700
Message-ID: <200909092234.n89MYv58009040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbZIIWgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 18:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, dhowells@redhat.com, jmorris@namei.org, jreiser@bitwagon.com, viro@zeniv.linux.org.uk


The patch titled
     binfmt_elf: fix PT_INTERP bss handling
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-pt_interp-bss-handling.patch

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
Subject: binfmt_elf: fix PT_INTERP bss handling
From: Roland McGrath <roland@redhat.com>

In fs/binfmt_elf.c, load_elf_interp() calls padzero() for .bss even if the
PT_LOAD has no PROT_WRITE and no .bss.  This generates EFAULT.

Here is a small test case.  (Yes, there are other, useful PT_INTERP which
have only .text and no .data/.bss.)

	----- ptinterp.S
	_start: .globl _start
		 nop
		 int3
	-----
	$ gcc -m32 -nostartfiles -nostdlib -o ptinterp ptinterp.S
	$ gcc -m32 -Wl,--dynamic-linker=ptinterp -o hello hello.c
	$ ./hello
	Segmentation fault  # during execve() itself

	After applying the patch:
	$ ./hello
	Trace trap  # user-mode execution after execve() finishes

If the ELF headers are actually self-inconsistent, then dying is fine. 
But having no PROT_WRITE segment is perfectly normal and correct if there
is no segment with p_memsz > p_filesz (i.e.  bss).  John Reiser suggested
checking for PROT_WRITE in the bss logic.  I think it makes most sense to
simply apply the bss logic only when there is bss.

This patch looks less trivial than it is due to some reindentation.  It
just moves the "if (last_bss > elf_bss) {" test up to include the
partial-page bss logic as well as the more-pages bss logic.

Reported-by: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-pt_interp-bss-handling fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-pt_interp-bss-handling
+++ a/fs/binfmt_elf.c
@@ -501,22 +501,22 @@ static unsigned long load_elf_interp(str
 		}
 	}
 
-	/*
-	 * Now fill out the bss section.  First pad the last page up
-	 * to the page boundary, and then perform a mmap to make sure
-	 * that there are zero-mapped pages up to and including the 
-	 * last bss page.
-	 */
-	if (padzero(elf_bss)) {
-		error = -EFAULT;
-		goto out_close;
-	}
+	if (last_bss > elf_bss) {
+		/*
+		 * Now fill out the bss section.  First pad the last page up
+		 * to the page boundary, and then perform a mmap to make sure
+		 * that there are zero-mapped pages up to and including the
+		 * last bss page.
+		 */
+		if (padzero(elf_bss)) {
+			error = -EFAULT;
+			goto out_close;
+		}
 
-	/* What we have mapped so far */
-	elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
+		/* What we have mapped so far */
+		elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
 
-	/* Map the last of the bss segment */
-	if (last_bss > elf_bss) {
+		/* Map the last of the bss segment */
 		down_write(&current->mm->mmap_sem);
 		error = do_brk(elf_bss, last_bss - elf_bss);
 		up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
kconfig-cross_compile-option.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
binfmt_elf-fix-pt_interp-bss-handling.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

