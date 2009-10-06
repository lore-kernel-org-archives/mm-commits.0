From: akpm@linux-foundation.org
Subject: + x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:09:19 -0700
Message-ID: <200910062109.n96L9Jcg015955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932816AbZJFVKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, hpa@zytor.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de, tim.c.chen@intel.com


The patch titled
     x86: fix kernel panic on i386 machine when booting with profile=2
has been added to the -mm tree.  Its filename is
     x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch

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
Subject: x86: fix kernel panic on i386 machine when booting with profile=2
From: "Shi, Alex" <alex.shi@intel.com>

Latest kernel has a kernel panic in booting on i386 machine when profile=2
setting in cmdline.  It is due to 'sp' being incorrect in profile_pc().

BUG: unable to handle kernel NULL pointer dereference at 00000246
IP: [<c01288b6>] profile_pc+0x2a/0x48
*pde = 00000000
Oops: 0000 [#1] SMP

Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/time.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/kernel/time.c~x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2 arch/x86/kernel/time.c
--- a/arch/x86/kernel/time.c~x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2
+++ a/arch/x86/kernel/time.c
@@ -38,7 +38,12 @@ unsigned long profile_pc(struct pt_regs 
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
+#ifdef CONFIG_X86_32
+		unsigned long *sp = (unsigned long *)&regs->sp;
+#else
 		unsigned long *sp = (unsigned long *)regs->sp;
+
+#endif
 		/*
 		 * Return address is either directly at stack pointer
 		 * or above a saved flags. Eflags has bits 22-31 zero,
_

Patches currently in -mm which might be from alex.shi@intel.com are

x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch

