From: akpm@linux-foundation.org
Subject: + s390-reduce-elf_et_dyn_base.patch added to -mm tree
Date: Thu, 22 Jun 2017 12:49:55 -0700
Message-ID: <594c1f63.UzUPvR3YJ79+PF8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFVTt4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 15:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, benh@kernel.crashing.org, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, james.hogan@imgtec.com, linux@armlinux.org.uk, mingo@kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: reduce ELF_ET_DYN_BASE
has been added to the -mm tree.  Its filename is
     s390-reduce-elf_et_dyn_base.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-reduce-elf_et_dyn_base.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-reduce-elf_et_dyn_base.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: s390: reduce ELF_ET_DYN_BASE

Now that explicitly executed loaders are loaded in the mmap region,
position PIE binaries lower in the address space to avoid possible
collisions with mmap or stack regions.  For 64-bit, align to 4GB to allow
runtimes to use the entire 32-bit address space for 32-bit pointers.

Link: http://lkml.kernel.org/r/1498154792-49952-5-git-send-email-keescook@chromium.org
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/elf.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN arch/s390/include/asm/elf.h~s390-reduce-elf_et_dyn_base arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~s390-reduce-elf_et_dyn_base
+++ a/arch/s390/include/asm/elf.h
@@ -161,14 +161,13 @@ extern unsigned int vdso_enabled;
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk. 64-bit
-   tasks are aligned to 4GB. */
-#define ELF_ET_DYN_BASE (is_compat_task() ? \
-				(STACK_TOP / 3 * 2) : \
-				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1))
+/*
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
+ */
+#define ELF_ET_DYN_BASE		(is_compat_task() ? 0x000400000UL : \
+						    0x100000000UL)
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
_

Patches currently in -mm which might be from keescook@chromium.org are

binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-reduce-elf_et_dyn_base.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
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
x86-power-64-use-char-arrays-for-asm-function-names.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

