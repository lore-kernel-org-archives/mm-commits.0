From: akpm@linux-foundation.org
Subject: [patch 109/115] arm: move ELF_ET_DYN_BASE to 4MB
Date: Mon, 10 Jul 2017 15:52:40 -0700
Message-ID: <20170710225240.ndFozk1tK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbdGJWwm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, dsafonov@virtuozzo.com, grzegorz.andrejczuk@intel.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.hogan@imgtec.com, keescook@chromium.org, linux@armlinux.org.uk, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, panand@redhat.com, paulus@samba.org, qsa@qualys.com, riel@redhat.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, will.deacon@arm.com, yamada.masahiro@socionext.com

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
