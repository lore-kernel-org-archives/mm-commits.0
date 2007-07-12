From: akpm@linux-foundation.org
Subject: + x86_64-hide-cond_syscall-behind-__kernel__.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:16:15 -0700
Message-ID: <200707122316.l6CNGF10010444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483AbXGLXQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     x86_64: hide cond_syscall behind __KERNEL__
has been added to the -mm tree.  Its filename is
     x86_64-hide-cond_syscall-behind-__kernel__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: hide cond_syscall behind __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

This brings x86_64 into line with all other architectures by only defining
cond_syscall() when __KERNEL__ is defined.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/unistd.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/asm-x86_64/unistd.h~x86_64-hide-cond_syscall-behind-__kernel__ include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~x86_64-hide-cond_syscall-behind-__kernel__
+++ a/include/asm-x86_64/unistd.h
@@ -674,6 +674,7 @@ asmlinkage long sys_rt_sigaction(int sig
 #endif	/* __KERNEL__ */
 #endif	/* __NO_STUBS */
 
+#ifdef __KERNEL__
 /*
  * "Conditional" syscalls
  *
@@ -681,5 +682,6 @@ asmlinkage long sys_rt_sigaction(int sig
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_64_UNISTD_H_ */
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
x86_64-hide-cond_syscall-behind-__kernel__.patch
