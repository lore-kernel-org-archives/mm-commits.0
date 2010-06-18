From: akpm@linux-foundation.org
Subject: + gcc-46-kgdb-remove-set-but-unused-newpc.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:25 -0700
Message-ID: <201006182331.o5INVP6t029531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab0FRXbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, jason.wessel@windriver.com


The patch titled
     gcc-4.6: kgdb: remove set but unused newPC
has been added to the -mm tree.  Its filename is
     gcc-46-kgdb-remove-set-but-unused-newpc.patch

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
Subject: gcc-4.6: kgdb: remove set but unused newPC
From: Andi Kleen <andi@firstfloor.org>

I'm not fully sure this is the correct fix, maybe this was a bug and newPC
should really have a side effect.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kgdb.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86/kernel/kgdb.c~gcc-46-kgdb-remove-set-but-unused-newpc arch/x86/kernel/kgdb.c
--- a/arch/x86/kernel/kgdb.c~gcc-46-kgdb-remove-set-but-unused-newpc
+++ a/arch/x86/kernel/kgdb.c
@@ -458,7 +458,6 @@ int kgdb_arch_handle_exception(int e_vec
 {
 	unsigned long addr;
 	char *ptr;
-	int newPC;
 
 	switch (remcomInBuffer[0]) {
 	case 'c':
@@ -469,8 +468,6 @@ int kgdb_arch_handle_exception(int e_vec
 			linux_regs->ip = addr;
 	case 'D':
 	case 'k':
-		newPC = linux_regs->ip;
-
 		/* clear the trace bit */
 		linux_regs->flags &= ~X86_EFLAGS_TF;
 		atomic_set(&kgdb_cpu_doing_single_step, -1);
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

