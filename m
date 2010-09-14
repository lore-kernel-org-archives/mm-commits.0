From: akpm@linux-foundation.org
Subject: + uml-fix-compile-warning.patch added to -mm tree
Date: Tue, 14 Sep 2010 14:58:43 -0700
Message-ID: <201009142158.o8ELwhXX020780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab0INV7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 17:59:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, dhowells@redhat.com, jdike@addtoit.com


The patch titled
     uml: fix compile warning
has been added to the -mm tree.  Its filename is
     uml-fix-compile-warning.patch

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
Subject: uml: fix compile warning
From: Richard Weinberger <richard@nod.at>

This fixes:
incompatible pointer type:  => 89
       arch/um/kernel/exec.c: warning: passing argument 2 of 'execve1' from
incompatible pointer type:  => 69, 85
       arch/um/kernel/exec.c: warning: passing argument 3 of 'execve1' from
incompatible pointer type:  => 69, 85

which was introduced by d7627467b7a8d ("Make do_execve() take a const
filename pointer")

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/exec.c     |    6 +++---
 arch/um/kernel/internal.h |    2 +-
 arch/um/kernel/syscall.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/um/kernel/exec.c~uml-fix-compile-warning arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-fix-compile-warning
+++ a/arch/um/kernel/exec.c
@@ -62,7 +62,7 @@ static long execve1(const char *file,
 	return error;
 }
 
-long um_execve(const char *file, char __user *__user *argv, char __user *__user *env)
+long um_execve(const char *file, const char __user *const __user *argv, const char __user *const __user *env)
 {
 	long err;
 
@@ -72,8 +72,8 @@ long um_execve(const char *file, char __
 	return err;
 }
 
-long sys_execve(const char __user *file, char __user *__user *argv,
-		char __user *__user *env)
+long sys_execve(const char __user *file, const char __user *const __user *argv,
+		const char __user *const __user *env)
 {
 	long error;
 	char *filename;
diff -puN arch/um/kernel/internal.h~uml-fix-compile-warning arch/um/kernel/internal.h
--- a/arch/um/kernel/internal.h~uml-fix-compile-warning
+++ a/arch/um/kernel/internal.h
@@ -1 +1 @@
-extern long um_execve(const char *file, char __user *__user *argv, char __user *__user *env);
+extern long um_execve(const char *file, const char __user *const __user *argv, const char __user *const __user *env);
diff -puN arch/um/kernel/syscall.c~uml-fix-compile-warning arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-fix-compile-warning
+++ a/arch/um/kernel/syscall.c
@@ -60,8 +60,8 @@ int kernel_execve(const char *filename,
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = um_execve(filename, (char __user *__user *)argv,
-			(char __user *__user *) envp);
+	ret = um_execve(filename, (const char __user *const __user *)argv,
+			(const char __user *const __user *) envp);
 	set_fs(fs);
 
 	return ret;
_

Patches currently in -mm which might be from richard@nod.at are

uml-fix-compile-warning.patch

