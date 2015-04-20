From: akpm@linux-foundation.org
Subject: [merged] seccomp-allow-compat-sigreturn-overrides.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:20:26 -0700
Message-ID: <5535517a.cU5vKw/bbu/LjYs5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbDTTOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, dborkman@redhat.com, deller@gmx.de, fweisbec@gmail.com, hpa@zytor.com, james.hogan@imgtec.com, jejb@parisc-linux.org, lauraa@codeaurora.org, linux@arm.linux.org.uk, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: allow COMPAT sigreturn overrides
has been removed from the -mm tree.  Its filename was
     seccomp-allow-compat-sigreturn-overrides.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: seccomp: allow COMPAT sigreturn overrides

Most architectures don't need to do much special for the strict-mode
seccomp syscall entries.  Remove the redundant headers and reduce the
others.

This patch (of 8):

Some architectures may need to override the compat sigreturn definition,
as is already possible in the non-compat case.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/seccomp.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-generic/seccomp.h~seccomp-allow-compat-sigreturn-overrides include/asm-generic/seccomp.h
--- a/include/asm-generic/seccomp.h~seccomp-allow-compat-sigreturn-overrides
+++ a/include/asm-generic/seccomp.h
@@ -17,7 +17,9 @@
 #define __NR_seccomp_read_32		__NR_read
 #define __NR_seccomp_write_32		__NR_write
 #define __NR_seccomp_exit_32		__NR_exit
+#ifndef __NR_seccomp_sigreturn_32
 #define __NR_seccomp_sigreturn_32	__NR_rt_sigreturn
+#endif
 #endif /* CONFIG_COMPAT && ! already defined */
 
 #define __NR_seccomp_read		__NR_read
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch

