From: akpm@linux-foundation.org
Subject: [merged] signal-refactor-copy_siginfo_to_user32.patch
 removed from -mm tree
Date: Thu, 07 May 2020 09:55:36 -0700
Message-ID: <20200507165536.jcuZXuQ1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgEGQzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 12:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: signal: refactor copy_siginfo_to_user32
has been removed from the -mm tree.  Its filename was
     signal-refactor-copy_siginfo_to_user32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: signal: refactor copy_siginfo_to_user32

Factor out a copy_siginfo_to_external32 helper from copy_siginfo_to_user32
that fills out the compat_siginfo, but does so on a kernel space data
structure.  With that we can let architectures override
copy_siginfo_to_user32 with their own implementations using
copy_siginfo_to_external32.  That allows moving the x32 SIGCHLD purely to
x86 architecture code.

As a nice side effect copy_siginfo_to_external32 also comes in handy for
avoiding a set_fs() call in the coredump code later on.

Contains improvements from Eric W. Biederman and Arnd Bergmann.

Link: http://lkml.kernel.org/r/20200505101256.3121270-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_signal.c   |    2 
 arch/x86/include/asm/compat.h |    8 +-
 arch/x86/kernel/signal.c      |   28 ++++++++
 include/linux/compat.h        |   11 ++-
 kernel/signal.c               |  106 ++++++++++++++++----------------
 5 files changed, 96 insertions(+), 59 deletions(-)

--- a/arch/x86/ia32/ia32_signal.c~signal-refactor-copy_siginfo_to_user32
+++ a/arch/x86/ia32/ia32_signal.c
@@ -350,7 +350,7 @@ int ia32_setup_rt_frame(int sig, struct
 	unsafe_put_user(*(__u64 *)set, (__u64 *)&frame->uc.uc_sigmask, Efault);
 	user_access_end();
 
-	if (__copy_siginfo_to_user32(&frame->info, &ksig->info, false))
+	if (__copy_siginfo_to_user32(&frame->info, &ksig->info))
 		return -EFAULT;
 
 	/* Set up registers for signal handler */
--- a/arch/x86/include/asm/compat.h~signal-refactor-copy_siginfo_to_user32
+++ a/arch/x86/include/asm/compat.h
@@ -214,7 +214,11 @@ static inline bool in_compat_syscall(voi
 #endif
 
 struct compat_siginfo;
-int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
-		const kernel_siginfo_t *from, bool x32_ABI);
+
+#ifdef CONFIG_X86_X32_ABI
+int copy_siginfo_to_user32(struct compat_siginfo __user *to,
+		const kernel_siginfo_t *from);
+#define copy_siginfo_to_user32 copy_siginfo_to_user32
+#endif /* CONFIG_X86_X32_ABI */
 
 #endif /* _ASM_X86_COMPAT_H */
--- a/arch/x86/kernel/signal.c~signal-refactor-copy_siginfo_to_user32
+++ a/arch/x86/kernel/signal.c
@@ -37,6 +37,7 @@
 #include <asm/vm86.h>
 
 #ifdef CONFIG_X86_64
+#include <linux/compat.h>
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #endif /* CONFIG_X86_64 */
@@ -511,6 +512,31 @@ Efault:
 }
 #endif /* CONFIG_X86_32 */
 
+#ifdef CONFIG_X86_X32_ABI
+static int x32_copy_siginfo_to_user(struct compat_siginfo __user *to,
+		const struct kernel_siginfo *from)
+{
+	struct compat_siginfo new;
+
+	copy_siginfo_to_external32(&new, from);
+	if (from->si_signo == SIGCHLD) {
+		new._sifields._sigchld_x32._utime = from->si_utime;
+		new._sifields._sigchld_x32._stime = from->si_stime;
+	}
+	if (copy_to_user(to, &new, sizeof(struct compat_siginfo)))
+		return -EFAULT;
+	return 0;
+}
+
+int copy_siginfo_to_user32(struct compat_siginfo __user *to,
+			   const struct kernel_siginfo *from)
+{
+	if (in_x32_syscall())
+		return x32_copy_siginfo_to_user(to, from);
+	return __copy_siginfo_to_user32(to, from);
+}
+#endif /* CONFIG_X86_X32_ABI */
+
 static int x32_setup_rt_frame(struct ksignal *ksig,
 			      compat_sigset_t *set,
 			      struct pt_regs *regs)
@@ -543,7 +569,7 @@ static int x32_setup_rt_frame(struct ksi
 	user_access_end();
 
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
-		if (__copy_siginfo_to_user32(&frame->info, &ksig->info, true))
+		if (x32_copy_siginfo_to_user(&frame->info, &ksig->info))
 			return -EFAULT;
 	}
 
--- a/include/linux/compat.h~signal-refactor-copy_siginfo_to_user32
+++ a/include/linux/compat.h
@@ -402,8 +402,15 @@ long compat_get_bitmap(unsigned long *ma
 		       unsigned long bitmap_size);
 long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
 		       unsigned long bitmap_size);
-int copy_siginfo_from_user32(kernel_siginfo_t *to, const struct compat_siginfo __user *from);
-int copy_siginfo_to_user32(struct compat_siginfo __user *to, const kernel_siginfo_t *from);
+void copy_siginfo_to_external32(struct compat_siginfo *to,
+		const struct kernel_siginfo *from);
+int copy_siginfo_from_user32(kernel_siginfo_t *to,
+		const struct compat_siginfo __user *from);
+int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
+		const kernel_siginfo_t *from);
+#ifndef copy_siginfo_to_user32
+#define copy_siginfo_to_user32 __copy_siginfo_to_user32
+#endif
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
 
--- a/kernel/signal.c~signal-refactor-copy_siginfo_to_user32
+++ a/kernel/signal.c
@@ -3235,94 +3235,94 @@ int copy_siginfo_from_user(kernel_siginf
 }
 
 #ifdef CONFIG_COMPAT
-int copy_siginfo_to_user32(struct compat_siginfo __user *to,
-			   const struct kernel_siginfo *from)
-#if defined(CONFIG_X86_X32_ABI) || defined(CONFIG_IA32_EMULATION)
+/**
+ * copy_siginfo_to_external32 - copy a kernel siginfo into a compat user siginfo
+ * @to: compat siginfo destination
+ * @from: kernel siginfo source
+ *
+ * Note: This function does not work properly for the SIGCHLD on x32, but
+ * fortunately it doesn't have to.  The only valid callers for this function are
+ * copy_siginfo_to_user32, which is overriden for x32 and the coredump code.
+ * The latter does not care because SIGCHLD will never cause a coredump.
+ */
+void copy_siginfo_to_external32(struct compat_siginfo *to,
+		const struct kernel_siginfo *from)
 {
-	return __copy_siginfo_to_user32(to, from, in_x32_syscall());
-}
-int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
-			     const struct kernel_siginfo *from, bool x32_ABI)
-#endif
-{
-	struct compat_siginfo new;
-	memset(&new, 0, sizeof(new));
+	memset(to, 0, sizeof(*to));
 
-	new.si_signo = from->si_signo;
-	new.si_errno = from->si_errno;
-	new.si_code  = from->si_code;
+	to->si_signo = from->si_signo;
+	to->si_errno = from->si_errno;
+	to->si_code  = from->si_code;
 	switch(siginfo_layout(from->si_signo, from->si_code)) {
 	case SIL_KILL:
-		new.si_pid = from->si_pid;
-		new.si_uid = from->si_uid;
+		to->si_pid = from->si_pid;
+		to->si_uid = from->si_uid;
 		break;
 	case SIL_TIMER:
-		new.si_tid     = from->si_tid;
-		new.si_overrun = from->si_overrun;
-		new.si_int     = from->si_int;
+		to->si_tid     = from->si_tid;
+		to->si_overrun = from->si_overrun;
+		to->si_int     = from->si_int;
 		break;
 	case SIL_POLL:
-		new.si_band = from->si_band;
-		new.si_fd   = from->si_fd;
+		to->si_band = from->si_band;
+		to->si_fd   = from->si_fd;
 		break;
 	case SIL_FAULT:
-		new.si_addr = ptr_to_compat(from->si_addr);
+		to->si_addr = ptr_to_compat(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		new.si_trapno = from->si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
 		break;
 	case SIL_FAULT_MCEERR:
-		new.si_addr = ptr_to_compat(from->si_addr);
+		to->si_addr = ptr_to_compat(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		new.si_trapno = from->si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		new.si_addr_lsb = from->si_addr_lsb;
+		to->si_addr_lsb = from->si_addr_lsb;
 		break;
 	case SIL_FAULT_BNDERR:
-		new.si_addr = ptr_to_compat(from->si_addr);
+		to->si_addr = ptr_to_compat(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		new.si_trapno = from->si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		new.si_lower = ptr_to_compat(from->si_lower);
-		new.si_upper = ptr_to_compat(from->si_upper);
+		to->si_lower = ptr_to_compat(from->si_lower);
+		to->si_upper = ptr_to_compat(from->si_upper);
 		break;
 	case SIL_FAULT_PKUERR:
-		new.si_addr = ptr_to_compat(from->si_addr);
+		to->si_addr = ptr_to_compat(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		new.si_trapno = from->si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		new.si_pkey = from->si_pkey;
+		to->si_pkey = from->si_pkey;
 		break;
 	case SIL_CHLD:
-		new.si_pid    = from->si_pid;
-		new.si_uid    = from->si_uid;
-		new.si_status = from->si_status;
-#ifdef CONFIG_X86_X32_ABI
-		if (x32_ABI) {
-			new._sifields._sigchld_x32._utime = from->si_utime;
-			new._sifields._sigchld_x32._stime = from->si_stime;
-		} else
-#endif
-		{
-			new.si_utime = from->si_utime;
-			new.si_stime = from->si_stime;
-		}
+		to->si_pid = from->si_pid;
+		to->si_uid = from->si_uid;
+		to->si_status = from->si_status;
+		to->si_utime = from->si_utime;
+		to->si_stime = from->si_stime;
 		break;
 	case SIL_RT:
-		new.si_pid = from->si_pid;
-		new.si_uid = from->si_uid;
-		new.si_int = from->si_int;
+		to->si_pid = from->si_pid;
+		to->si_uid = from->si_uid;
+		to->si_int = from->si_int;
 		break;
 	case SIL_SYS:
-		new.si_call_addr = ptr_to_compat(from->si_call_addr);
-		new.si_syscall   = from->si_syscall;
-		new.si_arch      = from->si_arch;
+		to->si_call_addr = ptr_to_compat(from->si_call_addr);
+		to->si_syscall   = from->si_syscall;
+		to->si_arch      = from->si_arch;
 		break;
 	}
+}
 
+int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
+			   const struct kernel_siginfo *from)
+{
+	struct compat_siginfo new;
+
+	copy_siginfo_to_external32(&new, from);
 	if (copy_to_user(to, &new, sizeof(struct compat_siginfo)))
 		return -EFAULT;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
