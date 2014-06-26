From: akpm@linux-foundation.org
Subject: + kexec-new-syscall-kexec_file_load-declaration.patch added to
 -mm tree
Date: Thu, 26 Jun 2014 14:08:54 -0700
Message-ID: <53ac8be6.GE/WhxalVpxVSMMH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaFZVIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: new syscall kexec_file_load() declaration
has been added to the -mm tree.  Its filename is
     kexec-new-syscall-kexec_file_load-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-new-syscall-kexec_file_load-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-new-syscall-kexec_file_load-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	kexec_file_load		sys_kexec_file_load
 
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
@@ -1057,6 +1057,13 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
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
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
linux-next.patch

