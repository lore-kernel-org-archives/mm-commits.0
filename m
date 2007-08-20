From: akpm@linux-foundation.org
Subject: + uml-fix-inlines.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:43:33 -0700
Message-ID: <200708201943.l7KJhYS8019629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760493AbXHTToC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, bunk@kernel.org, jdike@linux.intel.com


The patch titled
     uml: fix inlines
has been added to the -mm tree.  Its filename is
     uml-fix-inlines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix inlines
From: Jeff Dike <jdike@addtoit.com>

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgalloc.h          |    2 +-
 include/asm-um/pgtable-3level.h   |    2 +-
 include/asm-um/processor-x86_64.h |    2 +-
 include/asm-um/smp.h              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-um/pgalloc.h~uml-fix-inlines include/asm-um/pgalloc.h
--- a/include/asm-um/pgalloc.h~uml-fix-inlines
+++ a/include/asm-um/pgalloc.h
@@ -42,7 +42,7 @@ static inline void pte_free(struct page 
 
 #ifdef CONFIG_3_LEVEL_PGTABLES
 
-extern __inline__ void pmd_free(pmd_t *pmd)
+static inline void pmd_free(pmd_t *pmd)
 {
 	free_page((unsigned long)pmd);
 }
diff -puN include/asm-um/pgtable-3level.h~uml-fix-inlines include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-fix-inlines
+++ a/include/asm-um/pgtable-3level.h
@@ -69,7 +69,7 @@ static inline pmd_t *pmd_alloc_one(struc
         return pmd;
 }
 
-extern inline void pud_clear (pud_t *pud)
+static inline void pud_clear (pud_t *pud)
 {
         set_pud(pud, __pud(0));
 }
diff -puN include/asm-um/processor-x86_64.h~uml-fix-inlines include/asm-um/processor-x86_64.h
--- a/include/asm-um/processor-x86_64.h~uml-fix-inlines
+++ a/include/asm-um/processor-x86_64.h
@@ -18,7 +18,7 @@ struct arch_thread {
 };
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
-extern inline void rep_nop(void)
+static inline void rep_nop(void)
 {
 	__asm__ __volatile__("rep;nop": : :"memory");
 }
diff -puN include/asm-um/smp.h~uml-fix-inlines include/asm-um/smp.h
--- a/include/asm-um/smp.h~uml-fix-inlines
+++ a/include/asm-um/smp.h
@@ -18,7 +18,7 @@ extern int hard_smp_processor_id(void);
 extern int ncpus;
 
 
-extern inline void smp_cpus_done(unsigned int maxcpus)
+static inline void smp_cpus_done(unsigned int maxcpus)
 {
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
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
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
