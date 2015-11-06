From: akpm@linux-foundation.org
Subject: [merged] mm-mlock-add-new-mlock-system-call.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:18:01 -0800
Message-ID: <563d0af9.dyvS5pJsK5fhWAUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163022AbbKFUSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.com, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: add new mlock system call
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-new-mlock-system-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: add new mlock system call

With the refactored mlock code, introduce a new system call for mlock. 
The new call will allow the user to specify what lock states are being
added.  mlock2 is trivial at the moment, but a follow on patch will add a
new mlock state making it useful.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    2 ++
 include/uapi/asm-generic/unistd.h      |    4 +++-
 kernel/sys_ni.c                        |    1 +
 mm/mlock.c                             |    8 ++++++++
 6 files changed, 16 insertions(+), 1 deletion(-)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-system-call arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-system-call
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -382,3 +382,4 @@
 373	i386	shutdown		sys_shutdown
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
+376	i386	mlock2			sys_mlock2
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-system-call arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-system-call
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -331,6 +331,7 @@
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
+325	common	mlock2			sys_mlock2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~mm-mlock-add-new-mlock-system-call include/linux/syscalls.h
--- a/include/linux/syscalls.h~mm-mlock-add-new-mlock-system-call
+++ a/include/linux/syscalls.h
@@ -887,4 +887,6 @@ asmlinkage long sys_execveat(int dfd, co
 
 asmlinkage long sys_membarrier(int cmd, int flags);
 
+asmlinkage long sys_mlock2(unsigned long start, size_t len, int flags);
+
 #endif
diff -puN include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-system-call include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-system-call
+++ a/include/uapi/asm-generic/unistd.h
@@ -713,9 +713,11 @@ __SC_COMP(__NR_execveat, sys_execveat, c
 __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
 #define __NR_membarrier 283
 __SYSCALL(__NR_membarrier, sys_membarrier)
+#define __NR_mlock2 284
+__SYSCALL(__NR_mlock2, sys_mlock2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 284
+#define __NR_syscalls 285
 
 /*
  * All syscalls below here should go away really,
diff -puN kernel/sys_ni.c~mm-mlock-add-new-mlock-system-call kernel/sys_ni.c
--- a/kernel/sys_ni.c~mm-mlock-add-new-mlock-system-call
+++ a/kernel/sys_ni.c
@@ -194,6 +194,7 @@ cond_syscall(sys_mlock);
 cond_syscall(sys_munlock);
 cond_syscall(sys_mlockall);
 cond_syscall(sys_munlockall);
+cond_syscall(sys_mlock2);
 cond_syscall(sys_mincore);
 cond_syscall(sys_madvise);
 cond_syscall(sys_mremap);
diff -puN mm/mlock.c~mm-mlock-add-new-mlock-system-call mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-new-mlock-system-call
+++ a/mm/mlock.c
@@ -644,6 +644,14 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	return do_mlock(start, len, VM_LOCKED);
 }
 
+SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
+{
+	if (flags)
+		return -EINVAL;
+
+	return do_mlock(start, len, VM_LOCKED);
+}
+
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
 	int ret;
_

Patches currently in -mm which might be from emunson@akamai.com are

mips-add-entry-for-new-mlock2-syscall.patch

