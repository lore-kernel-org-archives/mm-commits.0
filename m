From: akpm@linux-foundation.org
Subject: [merged] add-compile-time-check-for-__arch_si_preamble_size.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:47 -0700
Message-ID: <56f2d597.XmQ1SbrXEcNQVubt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbcCWRms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, mpe@ellerman.id.au, oleg@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: add compile-time check for __ARCH_SI_PREAMBLE_SIZE
has been removed from the -mm tree.  Its filename was
     add-compile-time-check-for-__arch_si_preamble_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: kernel/signal.c: add compile-time check for __ARCH_SI_PREAMBLE_SIZE

The value of __ARCH_SI_PREAMBLE_SIZE defines the size (including padding)
of the part of the struct siginfo that is before the union, and it is then
used to calculate the needed padding (SI_PAD_SIZE) to make the size of
struct siginfo equal to 128 (SI_MAX_SIZE) bytes.

Depending on the target architecture and word width it equals to either 3
or 4 times sizeof int.

Since the very beginning we had __ARCH_SI_PREAMBLE_SIZE wrong on the
parisc architecture for the 64bit kernel build.  It's even more
frustrating, because it can easily be checked at compile time if the value
was defined correctly.

This patch adds such a check for the correctness of
__ARCH_SI_PREAMBLE_SIZE in the hope that it will prevent existing and
future architectures from running into the same problem.

I refrained from replacing __ARCH_SI_PREAMBLE_SIZE by offsetof() in
copy_siginfo() in include/asm-generic/siginfo.h, because a) it doesn't
make any difference and b) it's used in the Documentation/kmemcheck.txt
example.

I ran this patch through the 0-DAY kernel test infrastructure and only the
parisc architecture triggered as expected.  That means that this patch
should be OK for all major architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/signal.c~add-compile-time-check-for-__arch_si_preamble_size kernel/signal.c
--- a/kernel/signal.c~add-compile-time-check-for-__arch_si_preamble_size
+++ a/kernel/signal.c
@@ -3585,6 +3585,10 @@ __weak const char *arch_vma_name(struct
 
 void __init signals_init(void)
 {
+	/* If this check fails, the __ARCH_SI_PREAMBLE_SIZE value is wrong! */
+	BUILD_BUG_ON(__ARCH_SI_PREAMBLE_SIZE
+		!= offsetof(struct siginfo, _sifields._pad));
+
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
 
_

Patches currently in -mm which might be from deller@gmx.de are


