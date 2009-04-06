From: akpm@linux-foundation.org
Subject: [merged] uml-fix-warnings-in-kernel_execve.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:09 -0700
Message-ID: <200904061933.n36JX9l5011002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbZDFTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jdike@addtoit.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix warnings in kernel_execve
has been removed from the -mm tree.  Its filename was
     uml-fix-warnings-in-kernel_execve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

