From: akpm@linux-foundation.org
Subject: [merged] arm-reduce-elf_et_dyn_base.patch removed from -mm
 tree
Date: Tue, 11 Jul 2017 12:27:17 -0700
Message-ID: <20170711192717.B2C4E7vZJ%akpm__34408.6528792561$1499801247$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdGKT1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, dsafonov@virtuozzo.com, grzegorz.andrejczuk@intel.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.hogan@imgtec.com, keescook@chromium.org, linux@armlinux.org.uk, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, qsa@qualys.com, riel@redhat.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, will.deacon@arm.com, yamada.masahiro@socionext.com


The patch titled
     Subject: arm: move ELF_ET_DYN_BASE to 4MB
has been removed from the -mm tree.  Its filename was
     arm-reduce-elf_et_dyn_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: arm: move ELF_ET_DYN_BASE to 4MB

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

4MB is chosen here mainly to have parity with x86, where this is the
traditional minimum load location, likely to avoid historically requiring
a 4MB page table entry when only a portion of the first 4MB would be used
(since the NULL address is avoided).  For ARM the position could be
0x8000, the standard ET_EXEC load address, but that is needlessly close to
the NULL address, and anyone running PIE on 32-bit ARM will have an MMU,
so the tight mapping is not needed.

Link: http://lkml.kernel.org/r/1498154792-49952-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Qualys Security Advisory <qsa@qualys.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/elf.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/arm/include/asm/elf.h~arm-reduce-elf_et_dyn_base arch/arm/include/asm/elf.h
--- a/arch/arm/include/asm/elf.h~arm-reduce-elf_et_dyn_base
+++ a/arch/arm/include/asm/elf.h
@@ -112,12 +112,8 @@ int dump_task_regs(struct task_struct *t
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-#define ELF_ET_DYN_BASE	(TASK_SIZE / 3 * 2)
+/* This is the base location for PIE (ET_DYN with INTERP) loads. */
+#define ELF_ET_DYN_BASE		0x400000UL
 
 /* When the program starts, a1 contains a pointer to a function to be 
    registered with atexit, as per the SVR4 ABI.  A value of 0 means we 
_

Patches currently in -mm which might be from keescook@chromium.org are

random-do-not-ignore-early-device-randomness.patch
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
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

