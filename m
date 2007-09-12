From: akpm@linux-foundation.org
Subject: - uml-use-64-bits-for-block-size-on-x86_64.patch removed from -mm tree
Date: Wed, 12 Sep 2007 14:42:57 -0700
Message-ID: <200709122142.l8CLgvaG020668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbXILVnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 17:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, nicolas.george@normalesup.org, mm-commits@vger.kernel.org


The patch titled
     uml: use 64-bits for block size on x86_64
has been removed from the -mm tree.  Its filename was
     uml-use-64-bits-for-block-size-on-x86_64.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: uml: use 64-bits for block size on x86_64
From: Jeff Dike <jdike@addtoit.com>

The BLKGETSIZE ioctl expects a pointer to a long, os_file_size was providing
an int. Therefore, ubd access to host block devices caused a segmentation
fault on 64 bits systems.

Signed-off-by: Nicolas George <nicolas.george@normalesup.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/file.c~uml-use-64-bits-for-block-size-on-x86_64 arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-use-64-bits-for-block-size-on-x86_64
+++ a/arch/um/os-Linux/file.c
@@ -296,7 +296,8 @@ int os_file_size(char *file, unsigned lo
 	}
 
 	if(S_ISBLK(buf.ust_mode)){
-		int fd, blocks;
+		int fd;
+		long blocks;
 
 		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
 		if(fd < 0){
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-use-correct-type-in-blkgetsize-ioctl.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
bitops-introduce-lock-ops.patch
