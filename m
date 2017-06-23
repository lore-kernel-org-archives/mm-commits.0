From: akpm@linux-foundation.org
Subject: [merged]
 x86-power-64-use-char-arrays-for-asm-function-names.patch removed from -mm
 tree
Date: Fri, 23 Jun 2017 11:49:57 -0700
Message-ID: <20170623184957.lJPMgdRK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbdFWSuI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 14:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com


The patch titled
     Subject: x86/power/64: use char arrays for asm function names
has been removed from the -mm tree.  Its filename was
     x86-power-64-use-char-arrays-for-asm-function-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: x86/power/64: use char arrays for asm function names

This switches the hibernate_64.S function names into character arrays to
match other areas of the kernel where this is done (e.g., linker scripts).
Specifically this fixes a compile-time error noticed by the future
CONFIG_FORTIFY_SOURCE routines that complained about PAGE_SIZE being
copied out of the "single byte" core_restore_code variable.

Additionally drops the "acpi_save_state_mem" exern which does not appear
to be used anywhere else in the kernel.

Link: http://lkml.kernel.org/r/1497903987-21002-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/suspend_64.h |    5 ++---
 arch/x86/power/hibernate_64.c     |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/suspend_64.h~x86-power-64-use-char-arrays-for-asm-function-names arch/x86/include/asm/suspend_64.h
--- a/arch/x86/include/asm/suspend_64.h~x86-power-64-use-char-arrays-for-asm-function-names
+++ a/arch/x86/include/asm/suspend_64.h
@@ -42,8 +42,7 @@ struct saved_context {
 	set_debugreg((thread)->debugreg##register, register)
 
 /* routines for saving/restoring kernel state */
-extern int acpi_save_state_mem(void);
-extern char core_restore_code;
-extern char restore_registers;
+extern char core_restore_code[];
+extern char restore_registers[];
 
 #endif /* _ASM_X86_SUSPEND_64_H */
diff -puN arch/x86/power/hibernate_64.c~x86-power-64-use-char-arrays-for-asm-function-names arch/x86/power/hibernate_64.c
--- a/arch/x86/power/hibernate_64.c~x86-power-64-use-char-arrays-for-asm-function-names
+++ a/arch/x86/power/hibernate_64.c
@@ -147,7 +147,7 @@ static int relocate_restore_code(void)
 	if (!relocated_restore_code)
 		return -ENOMEM;
 
-	memcpy((void *)relocated_restore_code, &core_restore_code, PAGE_SIZE);
+	memcpy((void *)relocated_restore_code, core_restore_code, PAGE_SIZE);
 
 	/* Make the page containing the relocated code executable */
 	pgd = (pgd_t *)__va(read_cr3_pa()) +
@@ -293,8 +293,8 @@ int arch_hibernation_header_save(void *a
 
 	if (max_size < sizeof(struct restore_data_record))
 		return -EOVERFLOW;
-	rdr->jump_address = (unsigned long)&restore_registers;
-	rdr->jump_address_phys = __pa_symbol(&restore_registers);
+	rdr->jump_address = (unsigned long)restore_registers;
+	rdr->jump_address_phys = __pa_symbol(restore_registers);
 	rdr->cr3 = restore_cr3;
 	rdr->magic = RESTORE_MAGIC;
 
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-account-for-argv-envp-pointers.patch
mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-reduce-elf_et_dyn_base.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

