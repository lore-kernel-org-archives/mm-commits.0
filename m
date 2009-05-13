From: akpm@linux-foundation.org
Subject: [merged] syscallsh-add-the-missing-sys_pipe2-declaration.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:43 -0700
Message-ID: <200905131831.n4DIVhnK018504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758764AbZEMSea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, drepper@redhat.com, mm-commits@vger.kernel.org


The patch titled
     syscalls.h add the missing sys_pipe2 declaration
has been removed from the -mm tree.  Its filename was
     syscallsh-add-the-missing-sys_pipe2-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: syscalls.h add the missing sys_pipe2 declaration
From: Arnd Bergmann <arnd@arndb.de>

In order to build the generic syscall table, we need a declaration for
every system call.  sys_pipe2 was added without a proper declaration, so
add this to syscalls.h now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/syscalls.h~syscallsh-add-the-missing-sys_pipe2-declaration include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscallsh-add-the-missing-sys_pipe2-declaration
+++ a/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int f
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
time-move-pit_tick_rate-to-linux-timexh.patch
mb862xxfb-use-config_of-instead-of-config_ppc_of.patch
ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch

