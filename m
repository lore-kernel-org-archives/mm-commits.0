From: akpm@linux-foundation.org
Subject: + m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:35:50 -0700
Message-ID: <20120713213551.42738100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58162 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2GMVfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:35:52 -0400
Received: by yenl3 with SMTP id l3so386770yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:35:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, hch@lst.de, takata@linux-m32r.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: m32r: fix 'fix breakage from "m32r: use generic ptrace_resume code"' fallout
has been added to the -mm tree.  Its filename is
     m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch

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
Subject: m32r: fix 'fix breakage from "m32r: use generic ptrace_resume code"' fallout

acdc0d5ef9dd ('m32r: fix breakage from "m32r: use generic ptrace_resume
code"') tried to fix e34112e3966fc ("m32r: use generic ptrace_resume
code") by returning values in a function returning void, causing:

arch/m32r/kernel/ptrace.c: In function 'user_enable_single_step':
arch/m32r/kernel/ptrace.c:594:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:598:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:601:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:604:2: warning: 'return' with a value, in function returning void [enabled by default]

Remove the unneeded return values.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/ptrace.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/m32r/kernel/ptrace.c~m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout
+++ a/arch/m32r/kernel/ptrace.c
@@ -591,17 +591,16 @@ void user_enable_single_step(struct task
 
 	if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
 	    != sizeof(insn))
-		return -EIO;
+		return;
 
 	compute_next_pc(insn, pc, &next_pc, child);
 	if (next_pc & 0x80000000)
-		return -EIO;
+		return;
 
 	if (embed_debug_trap(child, next_pc))
-		return -EIO;
+		return;
 
 	invalidate_cache();
-	return 0;
 }
 
 void user_disable_single_step(struct task_struct *child)
_
Subject: Subject: m32r: fix 'fix breakage from "m32r: use generic ptrace_resume code"' fallout

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

