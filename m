From: akpm@linux-foundation.org
Subject: + asm-generic-syscallsh-fix-the-declaration-of-sys_execve.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:44:40 -0700
Message-ID: <201008182044.o7IKieeI011276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab0HRUpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, tony.luck@intel.com


The patch titled
     asm-generic/syscalls.h: fix the declaration of sys_execve()
has been added to the -mm tree.  Its filename is
     asm-generic-syscallsh-fix-the-declaration-of-sys_execve.patch

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
Subject: asm-generic/syscalls.h: fix the declaration of sys_execve()
From: David Howells <dhowells@redhat.com>

Fix the declaration of sys_execve() in asm-generic/syscalls.h to have
various consts applied to its pointers.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/syscalls.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/syscalls.h~asm-generic-syscallsh-fix-the-declaration-of-sys_execve include/asm-generic/syscalls.h
--- a/include/asm-generic/syscalls.h~asm-generic-syscallsh-fix-the-declaration-of-sys_execve
+++ a/include/asm-generic/syscalls.h
@@ -23,8 +23,10 @@ asmlinkage long sys_vfork(struct pt_regs
 #endif
 
 #ifndef sys_execve
-asmlinkage long sys_execve(char __user *filename, char __user * __user *argv,
-			char __user * __user *envp, struct pt_regs *regs);
+asmlinkage long sys_execve(const char __user *filename,
+			   const char __user *const __user *argv,
+			   const char __user *const __user *envp,
+			   struct pt_regs *regs);
 #endif
 
 #ifndef sys_mmap2
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
asm-generic-syscallsh-fix-the-declaration-of-sys_execve.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

