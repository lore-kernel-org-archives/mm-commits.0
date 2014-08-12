From: akpm@linux-foundation.org
Subject: [merged] kexec-new-syscall-kexec_file_load-declaration.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:55 -0700
Message-ID: <53ea6e7b.9FggPoc3kvByxwqp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:59410 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaHLTn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:56 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so1311472qgd.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: new syscall kexec_file_load() declaration
has been removed from the -mm tree.  Its filename was
     kexec-new-syscall-kexec_file_load-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: new syscall kexec_file_load() declaration

This is the new syscall kexec_file_load() declaration/interface.  I have
reserved the syscall number only for x86_64 so far.  Other architectures
(including i386) can reserve syscall number when they enable the support
for this new syscall.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    4 ++++
 kernel/kexec.c                   |    7 +++++++
 kernel/sys_ni.c                  |    1 +
 4 files changed, 13 insertions(+)

diff -puN arch/x86/syscalls/syscall_64.tbl~kexec-new-syscall-kexec_file_load-declaration arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~kexec-new-syscall-kexec_file_load-declaration
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -326,6 +326,7 @@
 317	common	seccomp			sys_seccomp
 318	common	getrandom		sys_getrandom
 319	common	memfd_create		sys_memfd_create
+320	common	kexec_file_load		sys_kexec_file_load
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~kexec-new-syscall-kexec_file_load-declaration include/linux/syscalls.h
--- a/include/linux/syscalls.h~kexec-new-syscall-kexec_file_load-declaration
+++ a/include/linux/syscalls.h
@@ -317,6 +317,10 @@ asmlinkage long sys_restart_syscall(void
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
 				unsigned long flags);
+asmlinkage long sys_kexec_file_load(int kernel_fd, int initrd_fd,
+				    unsigned long cmdline_len,
+				    const char __user *cmdline_ptr,
+				    unsigned long flags);
 
 asmlinkage long sys_exit(int error_code);
 asmlinkage long sys_exit_group(int error_code);
diff -puN kernel/kexec.c~kexec-new-syscall-kexec_file_load-declaration kernel/kexec.c
--- a/kernel/kexec.c~kexec-new-syscall-kexec_file_load-declaration
+++ a/kernel/kexec.c
@@ -1058,6 +1058,13 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 }
 #endif
 
+SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
+		unsigned long, cmdline_len, const char __user *, cmdline_ptr,
+		unsigned long, flags)
+{
+	return -ENOSYS;
+}
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
diff -puN kernel/sys_ni.c~kexec-new-syscall-kexec_file_load-declaration kernel/sys_ni.c
--- a/kernel/sys_ni.c~kexec-new-syscall-kexec_file_load-declaration
+++ a/kernel/sys_ni.c
@@ -25,6 +25,7 @@ cond_syscall(sys_swapon);
 cond_syscall(sys_swapoff);
 cond_syscall(sys_kexec_load);
 cond_syscall(compat_sys_kexec_load);
+cond_syscall(sys_kexec_file_load);
 cond_syscall(sys_init_module);
 cond_syscall(sys_finit_module);
 cond_syscall(sys_delete_module);
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

