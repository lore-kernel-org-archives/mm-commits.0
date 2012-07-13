From: akpm@linux-foundation.org
Subject: + m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:35:47 -0700
Message-ID: <20120713213548.2A2BC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:49371 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2GMVft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:35:49 -0400
Received: by vcqp1 with SMTP id p1so137599vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:35:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, takata@linux-m32r.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: m32r: fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout
has been added to the -mm tree.  Its filename is
     m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout

a610d6e672d ("pull clearing RESTORE_SIGMASK into block_sigmask()") caused:

arch/m32r/kernel/signal.c: In function 'handle_signal':
arch/m32r/kernel/signal.c:289:6: warning: 'return' with a value, in function returning void [enabled by default]

Remove the return value it forgot to remove.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m32r/kernel/signal.c~m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout
+++ a/arch/m32r/kernel/signal.c
@@ -285,7 +285,7 @@ handle_signal(unsigned long sig, struct 
 			case -ERESTARTNOINTR:
 				regs->r0 = regs->orig_r0;
 				if (prev_insn(regs) < 0)
-					return -EFAULT;
+					return;
 		}
 	}
 
_
Subject: Subject: m32r: fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch
m32r-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch
m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch
m32r-consistently-use-suffix.patch
m32r-add-memcpy-for-config_kernel_gzip=y.patch
m32r-make-memset-global-for-config_kernel_bzip2=y.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

