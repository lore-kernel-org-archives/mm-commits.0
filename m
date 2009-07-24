From: akpm@linux-foundation.org
Subject: + ia32-use-generic-sys_pipe.patch added to -mm tree
Date: Fri, 24 Jul 2009 14:28:30 -0700
Message-ID: <200907242128.n6OLSUIf022861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbZGXV3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     ia32: use generic sys_pipe()
has been added to the -mm tree.  Its filename is
     ia32-use-generic-sys_pipe.patch

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
Subject: ia32: use generic sys_pipe()
From: Amerigo Wang <amwang@redhat.com>

As suggested by Al, it's better to use the generic sys_pipe() for ia32.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S |    2 +-
 arch/x86/ia32/sys_ia32.c  |   14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~ia32-use-generic-sys_pipe arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~ia32-use-generic-sys_pipe
+++ a/arch/x86/ia32/ia32entry.S
@@ -537,7 +537,7 @@ ia32_sys_call_table:
 	.quad sys_mkdir
 	.quad sys_rmdir		/* 40 */
 	.quad sys_dup
-	.quad sys32_pipe
+	.quad sys_pipe
 	.quad compat_sys_times
 	.quad quiet_ni_syscall			/* old prof syscall holder */
 	.quad sys_brk		/* 45 */
diff -puN arch/x86/ia32/sys_ia32.c~ia32-use-generic-sys_pipe arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~ia32-use-generic-sys_pipe
+++ a/arch/x86/ia32/sys_ia32.c
@@ -189,20 +189,6 @@ asmlinkage long sys32_mprotect(unsigned 
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_pipe(int __user *fd)
-{
-	int retval;
-	int fds[2];
-
-	retval = do_pipe_flags(fds, 0);
-	if (retval)
-		goto out;
-	if (copy_to_user(fd, fds, sizeof(fds)))
-		retval = -EFAULT;
-out:
-	return retval;
-}
