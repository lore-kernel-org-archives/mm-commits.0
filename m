From: akpm@linux-foundation.org
Subject: + parisc-switch-to-using-asm-generic-for-seccomph.patch added to
 -mm tree
Date: Wed, 11 Mar 2015 13:59:36 -0700
Message-ID: <5500acb8.KzdIU7zOlwbjV7rk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbbCKU7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: switch to using asm-generic for seccomp.h
has been added to the -mm tree.  Its filename is
     parisc-switch-to-using-asm-generic-for-seccomph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-switch-to-using-asm-generic-for-seccomph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-switch-to-using-asm-generic-for-seccomph.patch

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
Subject: parisc: switch to using asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions. Definitions were identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/Kbuild    |    1 +
 arch/parisc/include/asm/seccomp.h |   16 ----------------
 2 files changed, 1 insertion(+), 16 deletions(-)

diff -puN arch/parisc/include/asm/Kbuild~parisc-switch-to-using-asm-generic-for-seccomph arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~parisc-switch-to-using-asm-generic-for-seccomph
+++ a/arch/parisc/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += param.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += preempt.h
+generic-y += seccomp.h
 generic-y += segment.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff -puN arch/parisc/include/asm/seccomp.h~parisc-switch-to-using-asm-generic-for-seccomph /dev/null
--- a/arch/parisc/include/asm/seccomp.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_PARISC_SECCOMP_H
-#define _ASM_PARISC_SECCOMP_H
-
-#include <linux/unistd.h>
-
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_rt_sigreturn
-
-#define __NR_seccomp_read_32 __NR_read
-#define __NR_seccomp_write_32 __NR_write
-#define __NR_seccomp_exit_32 __NR_exit
-#define __NR_seccomp_sigreturn_32 __NR_rt_sigreturn
-
-#endif	/* _ASM_PARISC_SECCOMP_H */
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage-v4.patch
mips-extract-logic-for-mmap_rnd.patch
mips-extract-logic-for-mmap_rnd-v4.patch
powerpc-standardize-mmap_rnd-usage.patch
powerpc-standardize-mmap_rnd-usage-v4.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
seccomp-allow-compat-sigreturn-overrides.patch
arm-use-asm-generic-for-seccomph.patch
microblaze-use-asm-generic-for-seccomph.patch
mips-switch-to-using-asm-generic-for-seccomph.patch
parisc-switch-to-using-asm-generic-for-seccomph.patch
powerpc-switch-to-using-asm-generic-for-seccomph.patch
sparc-switch-to-using-asm-generic-for-seccomph.patch
x86-switch-to-using-asm-generic-for-seccomph.patch
linux-next.patch

