From: akpm@linux-foundation.org
Subject: [merged]
 signal-fix-information-leak-in-copy_siginfo_from_user32.patch removed from
 -mm tree
Date: Fri, 07 Aug 2015 12:03:04 -0700
Message-ID: <55c500e8.UJ3TBRmiBxLeZepS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946066AbbHGTDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amanieu@gmail.com, benh@kernel.crashing.org, cmetcalf@ezchip.com, mingo@kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: fix information leak in copy_siginfo_from_user32
has been removed from the -mm tree.  Its filename was
     signal-fix-information-leak-in-copy_siginfo_from_user32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Amanieu d'Antras <amanieu@gmail.com>
Subject: signal: fix information leak in copy_siginfo_from_user32

This function can leak kernel stack data when the user siginfo_t has a
positive si_code value.  The top 16 bits of si_code descibe which fields
in the siginfo_t union are active, but they are treated inconsistently
between copy_siginfo_from_user32, copy_siginfo_to_user32 and
copy_siginfo_to_user.

copy_siginfo_from_user32 is called from rt_sigqueueinfo and
rt_tgsigqueueinfo in which the user has full control overthe top 16 bits
of si_code.

This fixes the following information leaks:
x86:   8 bytes leaked when sending a signal from a 32-bit process to
       itself. This leak grows to 16 bytes if the process uses x32.
       (si_code = __SI_CHLD)
x86:   100 bytes leaked when sending a signal from a 32-bit process to
       a 64-bit process. (si_code = -1)
sparc: 4 bytes leaked when sending a signal from a 32-bit process to a
       64-bit process. (si_code = any)

parsic and s390 have similar bugs, but they are not vulnerable because
rt_[tg]sigqueueinfo have checks that prevent sending a positive si_code to
a different process.  These bugs are also fixed for consistency.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/signal32.c     |    2 --
 arch/mips/kernel/signal32.c      |    2 --
 arch/powerpc/kernel/signal_32.c  |    2 --
 arch/tile/kernel/compat_signal.c |    2 --
 kernel/signal.c                  |    4 ++--
 5 files changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/arm64/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_from_user32 arch/arm64/kernel/signal32.c
--- a/arch/arm64/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_from_user32
+++ a/arch/arm64/kernel/signal32.c
@@ -201,8 +201,6 @@ int copy_siginfo_to_user32(compat_siginf
 
 int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 {
-	memset(to, 0, sizeof *to);
-
 	if (copy_from_user(to, from, __ARCH_SI_PREAMBLE_SIZE) ||
 	    copy_from_user(to->_sifields._pad,
 			   from->_sifields._pad, SI_PAD_SIZE))
diff -puN arch/mips/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_from_user32 arch/mips/kernel/signal32.c
--- a/arch/mips/kernel/signal32.c~signal-fix-information-leak-in-copy_siginfo_from_user32
+++ a/arch/mips/kernel/signal32.c
@@ -409,8 +409,6 @@ int copy_siginfo_to_user32(compat_siginf
 
 int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 {
-	memset(to, 0, sizeof *to);
-
 	if (copy_from_user(to, from, 3*sizeof(int)) ||
 	    copy_from_user(to->_sifields._pad,
 			   from->_sifields._pad, SI_PAD_SIZE32))
diff -puN arch/powerpc/kernel/signal_32.c~signal-fix-information-leak-in-copy_siginfo_from_user32 arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~signal-fix-information-leak-in-copy_siginfo_from_user32
+++ a/arch/powerpc/kernel/signal_32.c
@@ -966,8 +966,6 @@ int copy_siginfo_to_user32(struct compat
 
 int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
 {
-	memset(to, 0, sizeof *to);
-
 	if (copy_from_user(to, from, 3*sizeof(int)) ||
 	    copy_from_user(to->_sifields._pad,
 			   from->_sifields._pad, SI_PAD_SIZE32))
diff -puN arch/tile/kernel/compat_signal.c~signal-fix-information-leak-in-copy_siginfo_from_user32 arch/tile/kernel/compat_signal.c
--- a/arch/tile/kernel/compat_signal.c~signal-fix-information-leak-in-copy_siginfo_from_user32
+++ a/arch/tile/kernel/compat_signal.c
@@ -113,8 +113,6 @@ int copy_siginfo_from_user32(siginfo_t *
 	if (!access_ok(VERIFY_READ, from, sizeof(struct compat_siginfo)))
 		return -EFAULT;
 
-	memset(to, 0, sizeof(*to));
-
 	err = __get_user(to->si_signo, &from->si_signo);
 	err |= __get_user(to->si_errno, &from->si_errno);
 	err |= __get_user(to->si_code, &from->si_code);
diff -puN kernel/signal.c~signal-fix-information-leak-in-copy_siginfo_from_user32 kernel/signal.c
--- a/kernel/signal.c~signal-fix-information-leak-in-copy_siginfo_from_user32
+++ a/kernel/signal.c
@@ -3017,7 +3017,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 			int, sig,
 			struct compat_siginfo __user *, uinfo)
 {
-	siginfo_t info;
+	siginfo_t info = {};
 	int ret = copy_siginfo_from_user32(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
@@ -3061,7 +3061,7 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo
 			int, sig,
 			struct compat_siginfo __user *, uinfo)
 {
-	siginfo_t info;
+	siginfo_t info = {};
 
 	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
_

Patches currently in -mm which might be from amanieu@gmail.com are

origin.patch

