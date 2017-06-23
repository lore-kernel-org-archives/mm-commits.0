From: akpm@linux-foundation.org
Subject: [to-be-updated] arm64-reduce-elf_et_dyn_base.patch removed from
 -mm tree
Date: Fri, 23 Jun 2017 14:13:52 -0700
Message-ID: <594d8490.XHQ3Pw9R1bl/BT7P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWVNy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 17:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, benh@kernel.crashing.org, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, james.hogan@imgtec.com, linux@armlinux.org.uk, mingo@kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: reduce ELF_ET_DYN_BASE
has been removed from the -mm tree.  Its filename was
     arm64-reduce-elf_et_dyn_base.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: arm64: reduce ELF_ET_DYN_BASE

Now that explicitly executed loaders are loaded in the mmap region,
position PIE binaries lower in the address space to avoid possible
collisions with mmap or stack regions.  For 64-bit, align to 4GB to allow
runtimes to use the entire 32-bit address space for 32-bit pointers.

Link: http://lkml.kernel.org/r/1498154792-49952-3-git-send-email-keescook@chromium.org
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/arm64/include/asm/elf.h~arm64-reduce-elf_et_dyn_base arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~arm64-reduce-elf_et_dyn_base
+++ a/arch/arm64/include/asm/elf.h
@@ -113,12 +113,13 @@
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
- * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
- * use of this is to invoke "./ld.so someprog" to test out a new version of
- * the loader.  We need to make sure that it is out of the way of the program
- * that it will "exec", and that there is sufficient room for the brk.
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
  */
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
+#define ELF_ET_DYN_BASE		(test_thread_flag(TIF_32BIT) ?	\
+					0x000400000UL :		\
+					0x100000000UL)
 
 #ifndef __ASSEMBLY__
 
@@ -173,8 +174,6 @@ extern int arch_setup_additional_pages(s
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
-
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
 typedef unsigned int			compat_elf_greg_t;
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-account-for-argv-envp-pointers.patch
mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
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

