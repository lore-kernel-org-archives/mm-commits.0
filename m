From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:53 -0700
Message-ID: <20120723213054.30C7720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47473 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2GWVa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:56 -0400
Received: by wibhr14 with SMTP id hr14so178372wib.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, hch@lst.de, takata@linux-m32r.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix 'fix breakage from "m32r: use generic ptrace_resume code"' fallout
has been removed from the -mm tree.  Its filename was
     m32r-fix-fix-breakage-from-m32r-use-generic-ptrace_resume-code-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

