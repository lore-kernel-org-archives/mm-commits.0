From: akpm@linux-foundation.org
Subject: [patch 112/115] s390: reduce ELF_ET_DYN_BASE
Date: Mon, 10 Jul 2017 15:52:51 -0700
Message-ID: <20170710225251.wxkh07pJh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754977AbdGJWww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, james.hogan@imgtec.com, keescook@chromium.org, linux@armlinux.org.uk, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, stable@vger.kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com

From: Kees Cook <keescook@chromium.org>
Subject: s390: reduce ELF_ET_DYN_BASE

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers.  On 32-bit use 4MB, which is the
traditional x86 minimum load location, likely to avoid historically
requiring a 4MB page table entry when only a portion of the first 4MB
would be used (since the NULL address is avoided).  For s390 the position
could be 0x10000, but that is needlessly close to the NULL address.

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/elf.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN arch/s390/include/asm/elf.h~s390-reduce-elf_et_dyn_base arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~s390-reduce-elf_et_dyn_base
+++ a/arch/s390/include/asm/elf.h
@@ -193,14 +193,13 @@ struct arch_elf_state {
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
