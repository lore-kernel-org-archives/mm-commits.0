From: akpm@linux-foundation.org
Subject: [alternative-merged] x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:42:36 -0700
Message-ID: <200910151842.n9FIgb7B021486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933348AbZJOSn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, hpa@zytor.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix kernel panic on i386 machine when booting with profile=2
has been removed from the -mm tree.  Its filename was
     x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch

This patch was dropped because an alternative patch was merged

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

origin.patch
x86-fix-kernel-panic-on-i386-machine-when-booting-with-profile=2.patch

