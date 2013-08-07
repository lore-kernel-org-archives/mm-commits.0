From: akpm@linux-foundation.org
Subject: + microblaze-fix-clone-syscall.patch added to -mm tree
Date: Wed, 07 Aug 2013 13:50:27 -0700
Message-ID: <5202b313.CYFSY4RWml/E9pjN%akpm__40845.9985549145$1375908637$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3HGUu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, michal.simek@xilinx.com

Subject: + microblaze-fix-clone-syscall.patch added to -mm tree
To: michal.simek@xilinx.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:50:27 -0700


The patch titled
     Subject: microblaze: fix clone syscall
has been added to the -mm tree.  Its filename is
     microblaze-fix-clone-syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-fix-clone-syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-fix-clone-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: microblaze: fix clone syscall

Fix inadvertent breakage in the clone syscall ABI for Microblaze that was
introduced in f3268edb ("microblaze: switch to generic fork/vfork/clone").

The Microblaze syscall ABI for clone takes the parent tid address in the
4th argument; the third argument slot is used for the stack size.  The
incorrectly-used CLONE_BACKWARDS type assigned parent tid to the 3rd slot.

This commit restores the original ABI so that existing userspace libc
code will work correctly.

All kernel versions from v3.8-rc1 were affected.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig             |    6 ++++++
 arch/microblaze/Kconfig  |    2 +-
 include/linux/syscalls.h |    5 +++++
 kernel/fork.c            |    6 ++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff -puN arch/Kconfig~microblaze-fix-clone-syscall arch/Kconfig
--- a/arch/Kconfig~microblaze-fix-clone-syscall
+++ a/arch/Kconfig
@@ -407,6 +407,12 @@ config CLONE_BACKWARDS2
 	help
 	  Architecture has the first two arguments of clone(2) swapped.
 
+config CLONE_BACKWARDS3
+	bool
+	help
+	  Architecture has tls passed as the 3rd argument of clone(2),
+	  not the 5th one.
+
 config ODD_RT_SIGACTION
 	bool
 	help
diff -puN arch/microblaze/Kconfig~microblaze-fix-clone-syscall arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~microblaze-fix-clone-syscall
+++ a/arch/microblaze/Kconfig
@@ -28,7 +28,7 @@ config MICROBLAZE
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
-	select CLONE_BACKWARDS
+	select CLONE_BACKWARDS3
 
 config SWAP
 	def_bool n
diff -puN include/linux/syscalls.h~microblaze-fix-clone-syscall include/linux/syscalls.h
--- a/include/linux/syscalls.h~microblaze-fix-clone-syscall
+++ a/include/linux/syscalls.h
@@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
 	       int __user *);
 #else
+#ifdef CONFIG_CLONE_BACKWARDS3
+asmlinkage long sys_clone(unsigned long, unsigned long, int, int __user *,
+			  int __user *, int);
+#else
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
 	       int __user *, int);
 #endif
+#endif
 
 asmlinkage long sys_execve(const char __user *filename,
 		const char __user *const __user *argv,
diff -puN kernel/fork.c~microblaze-fix-clone-syscall kernel/fork.c
--- a/kernel/fork.c~microblaze-fix-clone-syscall
+++ a/kernel/fork.c
@@ -1679,6 +1679,12 @@ SYSCALL_DEFINE5(clone, unsigned long, ne
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
 		 int, tls_val)
+#elif defined(CONFIG_CLONE_BACKWARDS3)
+SYSCALL_DEFINE6(clone, unsigned long, clone_flags, unsigned long, newsp,
+		int, stack_size,
+		int __user *, parent_tidptr,
+		int __user *, child_tidptr,
+		int, tls_val)
 #else
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

microblaze-fix-clone-syscall.patch
linux-next.patch

