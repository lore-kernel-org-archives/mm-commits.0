From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-activate-syscall.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:41 -0700
Message-ID: <55ef2339.JnHMyhGo+lvTwFhS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbIHSEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, sfr@canb.auug.org.au, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: activate syscall
has been removed from the -mm tree.  Its filename was
     userfaultfd-activate-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: activate syscall

This activates the userfaultfd syscall.

[sfr@canb.auug.org.au: activate syscall fix]
[akpm@linux-foundation.org: don't enable userfaultfd on powerpc]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 kernel/sys_ni.c                        |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/x86/entry/syscalls/syscall_32.tbl~userfaultfd-activate-syscall arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~userfaultfd-activate-syscall
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -380,3 +380,4 @@
 371	i386	recvfrom		sys_recvfrom			compat_sys_recvfrom
 372	i386	recvmsg			sys_recvmsg			compat_sys_recvmsg
 373	i386	shutdown		sys_shutdown
+374	i386	userfaultfd		sys_userfaultfd
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~userfaultfd-activate-syscall arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~userfaultfd-activate-syscall
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	userfaultfd		sys_userfaultfd
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~userfaultfd-activate-syscall include/linux/syscalls.h
--- a/include/linux/syscalls.h~userfaultfd-activate-syscall
+++ a/include/linux/syscalls.h
@@ -810,6 +810,7 @@ asmlinkage long sys_timerfd_gettime(int
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
+asmlinkage long sys_userfaultfd(int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
 asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
diff -puN kernel/sys_ni.c~userfaultfd-activate-syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~userfaultfd-activate-syscall
+++ a/kernel/sys_ni.c
@@ -219,6 +219,7 @@ cond_syscall(compat_sys_timerfd_gettime)
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
 cond_syscall(sys_memfd_create);
+cond_syscall(sys_userfaultfd);
 
 /* performance counters: */
 cond_syscall(sys_perf_event_open);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

