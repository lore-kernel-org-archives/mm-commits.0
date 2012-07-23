From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:50 -0700
Message-ID: <20120723213050.B8CA2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44753 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2GWVav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:51 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so783980vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout
has been removed from the -mm tree.  Its filename was
     m32r-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -286,7 +286,7 @@ handle_signal(unsigned long sig, struct 
 			case -ERESTARTNOINTR:
 				regs->r0 = regs->orig_r0;
 				if (prev_insn(regs) < 0)
-					return -EFAULT;
+					return;
 		}
 	}
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

