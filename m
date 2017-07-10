From: akpm@linux-foundation.org
Subject: [patch 111/115] powerpc: move ELF_ET_DYN_BASE to 4GB / 4MB
Date: Mon, 10 Jul 2017 15:52:47 -0700
Message-ID: <20170710225247.JLf3H5sSe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754960AbdGJWwt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, james.hogan@imgtec.com, keescook@chromium.org, linux@armlinux.org.uk, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, stable@vger.kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com

From: Kees Cook <keescook@chromium.org>
Subject: powerpc: move ELF_ET_DYN_BASE to 4GB / 4MB

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers.  On 32-bit use 4MB, which is the
traditional x86 minimum load location, likely to avoid historically
requiring a 4MB page table entry when only a portion of the first 4MB
would be used (since the NULL address is avoided).

Link: http://lkml.kernel.org/r/1498154792-49952-4-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/elf.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/include/asm/elf.h~powerpc-reduce-elf_et_dyn_base arch/powerpc/include/asm/elf.h
--- a/arch/powerpc/include/asm/elf.h~powerpc-reduce-elf_et_dyn_base
+++ a/arch/powerpc/include/asm/elf.h
@@ -23,12 +23,13 @@
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
