From: akpm@linux-foundation.org
Subject: - x86_64-hide-cond_syscall-behind-__kernel__.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:54 -0700
Message-ID: <200708141913.l7EJDs2P016552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762791AbXHNTU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: hide cond_syscall behind __KERNEL__
has been removed from the -mm tree.  Its filename was
     x86_64-hide-cond_syscall-behind-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -676,6 +676,7 @@ asmlinkage long sys_rt_sigaction(int sig
 #endif	/* __KERNEL__ */
 #endif	/* __NO_STUBS */
 
+#ifdef __KERNEL__
 /*
  * "Conditional" syscalls
  *
@@ -683,5 +684,6 @@ asmlinkage long sys_rt_sigaction(int sig
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_64_UNISTD_H_ */
_

Patches currently in -mm which might be from vapier@gentoo.org are

clean-modulessymvers-in-external-module-dirs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
