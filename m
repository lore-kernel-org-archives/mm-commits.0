From: akpm@linux-foundation.org
Subject: - m68k-correct-setting-of-struct-useru_ar0.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:18 -0800
Message-ID: <200802080809.m1889xWK014891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYBHISz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: correct setting of struct user.u_ar0
has been removed from the -mm tree.  Its filename was
     m68k-correct-setting-of-struct-useru_ar0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: correct setting of struct user.u_ar0
From: Geert Uytterhoeven <geert@linux-m68k.org>

Commit 6e16d89bcd668a95eb22add24c02d80890232b66

    Sanitize the type of struct user.u_ar0

    struct user.u_ar0 is defined to contain a pointer offset on all
    architectures in which it is defined (all architectures which define an
    a.out format except SPARC.) However, it has a pointer type in the headers,
    which is pointless -- <asm/user.h> is not exported to userspace, and it
    just makes the code messy.

    Redefine the field as "unsigned long" (which is the same size as a pointer
    on all Linux architectures) and change the setting code to user offsetof()
    instead of hand-coded arithmetic.

forgot to change the m68k setting code, causing the following compiler warning:

    arch/m68k/kernel/process.c:338: warning: assignment makes integer from pointer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/kernel/process.c~m68k-correct-setting-of-struct-useru_ar0 arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~m68k-correct-setting-of-struct-useru_ar0
+++ a/arch/m68k/kernel/process.c
@@ -335,7 +335,7 @@ void dump_thread(struct pt_regs * regs, 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
 
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	dump->u_ar0 = offsetof(struct user, regs);
 	sw = ((struct switch_stack *)regs) - 1;
 	dump->regs.d1 = regs->d1;
 	dump->regs.d2 = regs->d2;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
