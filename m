From: akpm@linux-foundation.org
Subject: + uml-fix-warnings-in-kernel_execve.patch added to -mm tree
Date: Wed, 01 Apr 2009 15:34:27 -0700
Message-ID: <200904012234.n31MYRl1011634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZDAWh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 18:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jdike@addtoit.com, xiyou.wangcong@gmail.com


The patch titled
     uml: fix warnings in kernel_execve
has been added to the -mm tree.  Its filename is
     uml-fix-warnings-in-kernel_execve.patch

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
Subject: uml: fix warnings in kernel_execve
From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following warnings:

arch/um/kernel/syscall.c: In function 'kernel_execve':
arch/um/kernel/syscall.c:130: warning: passing argument 1 of 'um_execve' discards qualifiers from pointer target type
arch/um/kernel/syscall.c:130: warning: passing argument 2 of 'um_execve' discards qualifiers from pointer target type
arch/um/kernel/syscall.c:130: warning: passing argument 3 of 'um_execve' discards qualifiers from pointer target type

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/syscall.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/syscall.c~uml-fix-warnings-in-kernel_execve arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-fix-warnings-in-kernel_execve
+++ a/arch/um/kernel/syscall.c
@@ -127,7 +127,8 @@ int kernel_execve(const char *filename, 
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = um_execve(filename, argv, envp);
+	ret = um_execve((char *)filename, (char __user *__user *)argv,
+			(char __user *__user *) envp);
 	set_fs(fs);
 
 	return ret;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
uml-fix-compile-error-from-net_device_ops-conversion.patch
uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch
uml-fix-warnings-in-kernel_execve.patch

