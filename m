From: akpm@linux-foundation.org
Subject: + x86-avoid-constant_test_bit-misoptimization-due-to-cast-to-non-volatile.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:51:54 -0700
Message-ID: <201009232351.o8NNpsxB026809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838Ab0IWXxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:53:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: led@altlinux.ru, gcosta@redhat.com, hpa@zytor.com, ledest@gmail.com, mike@osdn.org.ua, mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org, volodymyrgl@gmail.com


The patch titled
     x86: avoid 'constant_test_bit()' misoptimization due to cast to non-volatile
has been added to the -mm tree.  Its filename is
     x86-avoid-constant_test_bit-misoptimization-due-to-cast-to-non-volatile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: avoid 'constant_test_bit()' misoptimization due to cast to non-volatile
From: Led <led@altlinux.ru>

While debugging bit_spin_lock() hang, it was tracked down to gcc-4.4
misoptimization of constant_test_bit() when 'const volatile unsigned long *addr'
cast to 'unsigned long *' with subsequent unconditional jump to pause
(and not to the test) leading to hang.

Compiling with gcc-4.3 or disabling CONFIG_OPTIMIZE_INLINING yields inlined
constant_test_bit() and correct jump.

Other arches than asm-x86 may implement this slightly differently; 2.6.29
mitigates the misoptimization by changing the function prototype in commit
c4295fbb6048 ("x86: make 'constant_test_bit()' take an unsigned bit
number") but probably fixing the issue itself is better.

Cc: Michael Shigorin <mike@osdn.org.ua>
Cc: Volodymyr G. Lukiianyk <volodymyrgl@gmail.com>
Cc: Alexander Chumachenko <ledest@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bitops.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/include/asm/bitops.h~x86-avoid-constant_test_bit-misoptimization-due-to-cast-to-non-volatile arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~x86-avoid-constant_test_bit-misoptimization-due-to-cast-to-non-volatile
+++ a/arch/x86/include/asm/bitops.h
@@ -308,8 +308,7 @@ static inline int test_and_change_bit(in
 
 static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & addr[nr / BITS_PER_LONG]) != 0;
 }
 
 static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
_

Patches currently in -mm which might be from led@altlinux.ru are

x86-avoid-constant_test_bit-misoptimization-due-to-cast-to-non-volatile.patch

