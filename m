From: akpm@linux-foundation.org
Subject: + uml-remove-include-of-asm-userh.patch added to -mm tree
Date: Thu, 12 Jun 2008 11:06:06 -0700
Message-ID: <200806121806.m5CI66Fd031824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbYFLSGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 14:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove include of asm/user.h
has been added to the -mm tree.  Its filename is
     uml-remove-include-of-asm-userh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove include of asm/user.h
From: Jeff Dike <jdike@addtoit.com>

I allowed an include of asm/user.h to sneak back in.  This patch replaces
it with sys/user.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-i386/registers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-remove-include-of-asm-userh arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-remove-include-of-asm-userh
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -6,7 +6,7 @@
 
 #include <errno.h>
 #include <sys/ptrace.h>
-#include <asm/user.h>
+#include <sys/user.h>
 #include "kern_constants.h"
 #include "longjmp.h"
 #include "user.h"
@@ -76,7 +76,7 @@ int put_fp_registers(int pid, unsigned l
 
 void arch_init_registers(int pid)
 {
-	struct user_fxsr_struct fpx_regs;
+	struct user_fpxregs_struct fpx_regs;
 	int err;
 
 	err = ptrace(PTRACE_GETFPXREGS, pid, 0, &fpx_regs);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-remove-include-of-asm-userh.patch
uml-work-around-broken-host-ptrace_sysemu.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch

