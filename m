From: akpm@linux-foundation.org
Subject: + uml-on-uml-fixed-it-did-not-start.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:18:20 -0700
Message-ID: <200903102218.n2AMILx5011678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbZCJWUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:20:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: renzo@cs.unibo.it, jdike@addtoit.com, xiyou.wangcong@gmail.com


The patch titled
     UML on UML fixed: it did not start
has been added to the -mm tree.  Its filename is
     uml-on-uml-fixed-it-did-not-start.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UML on UML fixed: it did not start
From: Renzo Davoli <renzo@cs.unibo.it>

It is currently impossible to run a user-mode linux machine inside another
user-mode linux (UML on UML).  It breaks after a few instructions.  When
it tries to check whether SYSEMU is installed (the inner) UML receives an
inconsistent result (from the outer UML).

This is the output of a broken attempt:
$ ./linux mem=256m ubd0=cow
Locating the bottom of the address space ... 0x0
Locating the top of the address space ... 0xc0000000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking ptrace new tags for syscall emulation...unsupported
Checking syscall emulation patch for ptrace...check_sysemu : expected SIGTRAP, got status = 256
$

The problem is the following:

PTRACE_SYSCALL/SINGLESTEP is currently managed inside arch_ptrace for ARCH=um.

PTRACE_SYSEMU/SUSEMU_SINGLESTEP is not captured in arch_ptrace's switch,
therefore it is erroneously passed back to ptrace_request (in
kernel/ptrace).

This simple patch simply forces ptrace to return an error on
PTRACE_SYSEMU/SUSEMU_SINGLESTEP as it is unsupported on ARCH=um, and fixes
the problem.

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/um/kernel/ptrace.c~uml-on-uml-fixed-it-did-not-start arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~uml-on-uml-fixed-it-did-not-start
+++ a/arch/um/kernel/ptrace.c
@@ -64,6 +64,11 @@ long arch_ptrace(struct task_struct *chi
 		ret = poke_user(child, addr, data);
 		break;
 
+	case PTRACE_SYSEMU:
+	case PTRACE_SYSEMU_SINGLESTEP:
+		ret=-EIO;
+		break;
+
 	/* continue and stop at next (return from) syscall */
 	case PTRACE_SYSCALL:
 	/* restart after signal. */
_

Patches currently in -mm which might be from renzo@cs.unibo.it are

uml-on-uml-fixed-it-did-not-start.patch

