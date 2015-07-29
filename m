From: akpm@linux-foundation.org
Subject: + mm-mlock-add-new-mlock-system-call.patch added to -mm tree
Date: Wed, 29 Jul 2015 11:21:12 -0700
Message-ID: <55b91998.68BOGFMQP7S/BNLc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbG2SVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: add new mlock system call
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-system-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-system-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-system-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: add new mlock system call

With the refactored mlock code, introduce a new system call for mlock. 
The new call will allow the user to specify what lock states are being
added.  mlock2 is trivial at the moment, but a follow on patch will add a
new mlock state making it useful.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
 mm/mlock.c                             |    9 +++++++++
 6 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-system-call arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-system-call
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -366,3 +366,4 @@
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
 359	i386	userfaultfd		sys_userfaultfd
+360	i386	mlock2			sys_mlock2
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-system-call arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-system-call
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -330,6 +330,7 @@
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
+324	common	mlock2			sys_mlock2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~mm-mlock-add-new-mlock-system-call include/linux/syscalls.h
--- a/include/linux/syscalls.h~mm-mlock-add-new-mlock-system-call
+++ a/include/linux/syscalls.h
@@ -885,4 +885,6 @@ asmlinkage long sys_execveat(int dfd, co
 			const char __user *const __user *argv,
 			const char __user *const __user *envp, int flags);
 
+asmlinkage long sys_mlock2(unsigned long start, size_t len, int flags);
+
 #endif
diff -puN include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-system-call include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-system-call
+++ a/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_c
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_mlock2 282
+__SYSCALL(__NR_mlock2, sys_mlock2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff -puN kernel/sys_ni.c~mm-mlock-add-new-mlock-system-call kernel/sys_ni.c
--- a/kernel/sys_ni.c~mm-mlock-add-new-mlock-system-call
+++ a/kernel/sys_ni.c
@@ -193,6 +193,7 @@ cond_syscall(sys_mlock);
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
@@ -643,6 +643,15 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	return do_mlock(start, len, VM_LOCKED);
 }
 
+SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
+{
+	vm_flags_t vm_flags = VM_LOCKED;
+	if (flags)
+		return -EINVAL;
+
+	return do_mlock(start, len, vm_flags);
+}
+
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
 	int ret;
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

