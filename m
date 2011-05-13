From: akpm@linux-foundation.org
Subject: + um-remove-sighup-handler.patch added to -mm tree
Date: Fri, 13 May 2011 10:55:25 -0700
Message-ID: <201105131747.p4DHlnfA030021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab1EMRs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 May 2011 13:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: remove SIGHUP handler
has been added to the -mm tree.  Its filename is
     um-remove-sighup-handler.patch

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
Subject: um: remove SIGHUP handler
From: Richard Weinberger <richard@nod.at>

The UML kernel ignores SIGHUP anyway.  This handler is in vain.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/os-Linux/main.c~um-remove-sighup-handler arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~um-remove-sighup-handler
+++ a/arch/um/os-Linux/main.c
@@ -142,7 +142,6 @@ int __init main(int argc, char **argv, c
 	 */
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
-	install_fatal_handler(SIGHUP);
 
 	scan_elf_aux(envp);
 
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

