From: akpm@linux-foundation.org
Subject: + use-get_random_long.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:20:21 -0800
Message-ID: <56b3dcb5.aFUJZe48/U7lsE/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbcBDXUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:20:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, davem@davemloft.net, gregkh@linuxfoundation.org, hpa@zytor.com, jeffv@google.com, keescook@chromium.org, mingo@redhat.com, mpe@ellerman.id.au, nnk@google.com, paulus@samba.org, ralf@linux-mips.org, salyzyn@android.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ASLR: use get_random_long()
has been added to the -mm tree.  Its filename is
     use-get_random_long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/use-get_random_long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/use-get_random_long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: mm: ASLR: use get_random_long()

Replace calls to get_random_int() followed by a cast to (unsigned long)
with calls to get_random_long().  Also address shifting bug which, in case
of x86 removed entropy mask for mmap_rnd_bits values > 31 bits.

Signed-off-by: Daniel Cashman <dcashman@android.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Kralevich <nnk@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Mark Salyzyn <salyzyn@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c               |    2 +-
 arch/arm64/mm/mmap.c             |    4 ++--
 arch/mips/mm/mmap.c              |    4 ++--
 arch/powerpc/kernel/process.c    |    4 ++--
 arch/powerpc/mm/mmap.c           |    4 ++--
 arch/sparc/kernel/sys_sparc_64.c |    2 +-
 arch/x86/mm/mmap.c               |    6 +++---
 fs/binfmt_elf.c                  |    2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/arm/mm/mmap.c~use-get_random_long arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~use-get_random_long
+++ a/arch/arm/mm/mmap.c
@@ -173,7 +173,7 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
+	rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
 
 	return rnd << PAGE_SHIFT;
 }
diff -puN arch/arm64/mm/mmap.c~use-get_random_long arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~use-get_random_long
+++ a/arch/arm64/mm/mmap.c
@@ -53,10 +53,10 @@ unsigned long arch_mmap_rnd(void)
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT))
-		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_compat_bits) - 1);
+		rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
 	else
 #endif
-		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
+		rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
 	return rnd << PAGE_SHIFT;
 }
 
diff -puN arch/mips/mm/mmap.c~use-get_random_long arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~use-get_random_long
+++ a/arch/mips/mm/mmap.c
@@ -146,7 +146,7 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	rnd = (unsigned long)get_random_int();
+	rnd = get_random_long();
 	rnd <<= PAGE_SHIFT;
 	if (TASK_IS_32BIT_ADDR)
 		rnd &= 0xfffffful;
@@ -174,7 +174,7 @@ void arch_pick_mmap_layout(struct mm_str
 
 static inline unsigned long brk_rnd(void)
 {
-	unsigned long rnd = get_random_int();
+	unsigned long rnd = get_random_long();
 
 	rnd = rnd << PAGE_SHIFT;
 	/* 8MB for 32bit, 256MB for 64bit */
diff -puN arch/powerpc/kernel/process.c~use-get_random_long arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~use-get_random_long
+++ a/arch/powerpc/kernel/process.c
@@ -1768,9 +1768,9 @@ static inline unsigned long brk_rnd(void
 
 	/* 8MB for 32bit, 1GB for 64bit */
 	if (is_32bit_task())
-		rnd = (long)(get_random_int() % (1<<(23-PAGE_SHIFT)));
+		rnd = (get_random_long() % (1UL<<(23-PAGE_SHIFT)));
 	else
-		rnd = (long)(get_random_int() % (1<<(30-PAGE_SHIFT)));
+		rnd = (get_random_long() % (1UL<<(30-PAGE_SHIFT)));
 
 	return rnd << PAGE_SHIFT;
 }
diff -puN arch/powerpc/mm/mmap.c~use-get_random_long arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~use-get_random_long
+++ a/arch/powerpc/mm/mmap.c
@@ -59,9 +59,9 @@ unsigned long arch_mmap_rnd(void)
 
 	/* 8MB for 32bit, 1GB for 64bit */
 	if (is_32bit_task())
-		rnd = (unsigned long)get_random_int() % (1<<(23-PAGE_SHIFT));
+		rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
 	else
-		rnd = (unsigned long)get_random_int() % (1<<(30-PAGE_SHIFT));
+		rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
 
 	return rnd << PAGE_SHIFT;
 }
diff -puN arch/sparc/kernel/sys_sparc_64.c~use-get_random_long arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~use-get_random_long
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -264,7 +264,7 @@ static unsigned long mmap_rnd(void)
 	unsigned long rnd = 0UL;
 
 	if (current->flags & PF_RANDOMIZE) {
-		unsigned long val = get_random_int();
+		unsigned long val = get_random_long();
 		if (test_thread_flag(TIF_32BIT))
 			rnd = (val % (1UL << (23UL-PAGE_SHIFT)));
 		else
diff -puN arch/x86/mm/mmap.c~use-get_random_long arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~use-get_random_long
+++ a/arch/x86/mm/mmap.c
@@ -71,12 +71,12 @@ unsigned long arch_mmap_rnd(void)
 
 	if (mmap_is_ia32())
 #ifdef CONFIG_COMPAT
-		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_compat_bits) - 1);
+		rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
 #else
-		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
+		rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
 #endif
 	else
-		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
+		rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
 
 	return rnd << PAGE_SHIFT;
 }
diff -puN fs/binfmt_elf.c~use-get_random_long fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~use-get_random_long
+++ a/fs/binfmt_elf.c
@@ -653,7 +653,7 @@ static unsigned long randomize_stack_top
 
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		random_variable = (unsigned long) get_random_int();
+		random_variable = get_random_long();
 		random_variable &= STACK_RND_MASK;
 		random_variable <<= PAGE_SHIFT;
 	}
_

Patches currently in -mm which might be from dcashman@android.com are

drivers-char-random-add-get_random_long.patch
use-get_random_long.patch

