From: akpm@linux-foundation.org
Subject: + syscall-define-fix-uml-compile-bug.patch added to -mm tree
Date: Sat, 07 Feb 2009 12:06:40 -0800
Message-ID: <200902072006.n17K6eL2029148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128AbZBGUHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Feb 2009 15:07:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, geert@linux-m68k.org, viro@zeniv.linux.org.uk


The patch titled
     syscall define: fix uml compile bug
has been added to the -mm tree.  Its filename is
     syscall-define-fix-uml-compile-bug.patch

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
Subject: syscall define: fix uml compile bug
From: Heiko Carstens <heiko.carstens@de.ibm.com>

With the new system call defines we get this on uml:

arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x308): undefined reference to `sys_sigprocmask'

Reason for this is that uml passes the preprocessor option
-Dsigprocmask=kernel_sigprocmask to gcc when compiling the kernel. 
This causes SYSCALL_DEFINE3(sigprocmask, ...) to be expanded to
SYSCALL_DEFINEx(3, kernel_sigprocmask, ...) and finally to a system
call named sys_kernel_sigprocmask.  However sys_sigprocmask is missing
because of this.

To avoid macro expansion for the system call name just concatenate the
name at first define instead of carrying it through severel levels. 
This was pointed out by Al Viro.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/syscalls.h~syscall-define-fix-uml-compile-bug include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscall-define-fix-uml-compile-bug
+++ a/include/linux/syscalls.h
@@ -95,13 +95,13 @@ struct old_linux_dirent;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#define SYSCALL_DEFINE0(name)   asmlinkage long sys_##name(void)
-#define SYSCALL_DEFINE1(...)    SYSCALL_DEFINEx(1, __VA_ARGS__)
-#define SYSCALL_DEFINE2(...)    SYSCALL_DEFINEx(2, __VA_ARGS__)
-#define SYSCALL_DEFINE3(...)    SYSCALL_DEFINEx(3, __VA_ARGS__)
-#define SYSCALL_DEFINE4(...)    SYSCALL_DEFINEx(4, __VA_ARGS__)
-#define SYSCALL_DEFINE5(...)    SYSCALL_DEFINEx(5, __VA_ARGS__)
-#define SYSCALL_DEFINE6(...)    SYSCALL_DEFINEx(6, __VA_ARGS__)
+#define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
+#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
@@ -121,21 +121,21 @@ struct old_linux_dirent;
 
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
 #define SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage long SyS_##name(__SC_LONG##x(__VA_ARGS__))		\
+	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
+	SYSCALL_ALIAS(sys##name, SyS##name);				\
+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
 #define SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
+	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch
linux-next.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch
syscall-define-fix-uml-compile-bug.patch

