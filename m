From: akpm@linux-foundation.org
Subject: + um-print-info-about-fatal-segfaults.patch added to -mm tree
Date: Tue, 24 May 2011 12:34:55 -0700
Message-ID: <201105241934.p4OJYtpM010623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932953Ab1EXTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: print info about fatal segfaults
has been added to the -mm tree.  Its filename is
     um-print-info-about-fatal-segfaults.patch

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
Subject: um: print info about fatal segfaults
From: Richard Weinberger <richard@nod.at>

Print a short info about fatal segfaults like other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN arch/um/kernel/trap.c~um-print-info-about-fatal-segfaults arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~um-print-info-about-fatal-segfaults
+++ a/arch/um/kernel/trap.c
@@ -113,6 +113,27 @@ out_of_memory:
 	return 0;
 }
 
+static void show_segv_info(struct uml_pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct faultinfo *fi = UPT_FAULTINFO(regs);
+
+	if (!unhandled_signal(tsk, SIGSEGV))
+		return;
+
+	if (!printk_ratelimit())
+		return;
+
+	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %x",
+		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+		tsk->comm, task_pid_nr(tsk), FAULT_ADDRESS(*fi),
+		(void *)UPT_IP(regs), (void *)UPT_SP(regs),
+		fi->error_code);
+
+	print_vma_addr(KERN_CONT " in ", UPT_IP(regs));
+	printk(KERN_CONT "\n");
+}
+
 static void bad_segv(struct faultinfo fi, unsigned long ip)
 {
 	struct siginfo si;
@@ -141,6 +162,7 @@ void segv_handler(int sig, struct uml_pt
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
 	if (UPT_IS_USER(regs) && !SEGV_IS_FIXABLE(fi)) {
+		show_segv_info(regs);
 		bad_segv(*fi, UPT_IP(regs));
 		return;
 	}
@@ -202,6 +224,8 @@ unsigned long segv(struct faultinfo fi, 
 		      address, ip);
 	}
 
+	show_segv_info(regs);
+
 	if (err == -EACCES) {
 		si.si_signo = SIGBUS;
 		si.si_errno = 0;
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
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
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
um-add-earlyprintk-support.patch
um-add-ucast-ethernet-transport.patch
um-print-info-about-fatal-segfaults.patch
um-include-linux-prefetchh.patch
um-fix-crash-while-os_dump_core.patch
remove-unused-proc_change_penalty-constant.patch
lib-consolidate-debug_stack_usage-option.patch

