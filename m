From: akpm@linux-foundation.org
Subject: + uml-free-ldt-state-on-process-exit.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:34 -0700
Message-ID: <200708162114.l7GLEYMc007110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759481AbXHPVOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: free LDT state on process exit
has been added to the -mm tree.  Its filename is
     uml-free-ldt-state-on-process-exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: free LDT state on process exit
From: Jeff Dike <jdike@addtoit.com>

The space allocated for a process LDT wasn't being freed when the process
exited.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/mmu.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/um/kernel/skas/mmu.c~uml-free-ldt-state-on-process-exit arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-free-ldt-state-on-process-exit
+++ a/arch/um/kernel/skas/mmu.c
@@ -149,4 +149,6 @@ void destroy_context(struct mm_struct *m
 		pmd_free((pmd_t *) mmu->last_pmd);
 #endif
 	}
+
+	free_ldt(mmu);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
