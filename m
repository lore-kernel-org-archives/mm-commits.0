From: akpm@linux-foundation.org
Subject: + m68k-correct-setting-of-struct-useru_ar0.patch added to -mm tree
Date: Thu, 07 Feb 2008 14:24:40 -0800
Message-ID: <200802072224.m17MOesB025772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760321AbYBGWYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 17:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: correct setting of struct user.u_ar0
has been added to the -mm tree.  Its filename is
     m68k-correct-setting-of-struct-useru_ar0.patch

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
add-cmpxchg_local-to-m86k.patch
m68k-kill-page-walker-compile-warning.patch
m68k-correct-setting-of-struct-useru_ar0.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
