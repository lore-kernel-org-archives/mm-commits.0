From: akpm@linux-foundation.org
Subject: + syscallsh-add-the-missing-sys_pipe2-declaration.patch added to -mm tree
Date: Mon, 11 May 2009 17:05:14 -0700
Message-ID: <200905120005.n4C05Esr006644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbZELAHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 20:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, drepper@redhat.com


The patch titled
     syscalls.h add the missing sys_pipe2 declaration
has been added to the -mm tree.  Its filename is
     syscallsh-add-the-missing-sys_pipe2-declaration.patch

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

syscallsh-add-the-missing-sys_pipe2-declaration.patch
linux-next.patch
time-move-pit_tick_rate-to-linux-timexh.patch
mb862xxfb-use-config_of-instead-of-config_ppc_of.patch
ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch

