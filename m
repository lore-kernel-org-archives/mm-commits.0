From: akpm@linux-foundation.org
Subject: [merged]
 kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:35 -0700
Message-ID: <5407568f.yoxYddD7/tz1FyHU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbaICR5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, ebiederm@xmission.com, hpa@zytor.com, sruffell@digium.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: create a new config option CONFIG_KEXEC_FILE for new syscall
has been removed from the -mm tree.  Its filename was
     kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: create a new config option CONFIG_KEXEC_FILE for new syscall

Currently new system call kexec_file_load() and all the associated code
compiles if CONFIG_KEXEC=y.  But new syscall also compiles purgatory code
which currently uses gcc option -mcmodel=large.  This option seems to be
available only gcc 4.4 onwards.

Hiding new functionality behind a new config option will not break
existing users of old gcc.  Those who wish to enable new functionality
will require new gcc.  Having said that, I am trying to figure out how can
I move away from using -mcmodel=large but that can take a while.

I think there are other advantages of introducing this new config option. 
As this option will be enabled only on x86_64, other arches don't have to
compile generic kexec code which will never be used.  This new code
selects CRYPTO=y and CRYPTO_SHA256=y.  And all other arches had to do this
for CONFIG_KEXEC.  Now with introduction of new config option, we can
remove crypto dependency from other arches.

Now CONFIG_KEXEC_FILE is available only on x86_64.  So whereever I had
CONFIG_X86_64 defined, I got rid of that.

For CONFIG_KEXEC_FILE, instead of doing select CRYPTO=y, I changed it to
"depends on CRYPTO=y".  This should be safer as "select" is not recursive.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kbuild                    |    4 +---
 arch/x86/Kconfig                   |   18 ++++++++++++++----
 arch/x86/Makefile                  |    5 +----
 arch/x86/kernel/Makefile           |    2 +-
 arch/x86/kernel/crash.c            |    6 ++----
 arch/x86/kernel/machine_kexec_64.c |   11 +++++++++++
 arch/x86/purgatory/Makefile        |    5 +----
 kernel/kexec.c                     |   11 +++++++++++
 8 files changed, 42 insertions(+), 20 deletions(-)

diff -puN arch/x86/Kbuild~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/Kbuild
--- a/arch/x86/Kbuild~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/Kbuild
@@ -17,6 +17,4 @@ obj-$(CONFIG_IA32_EMULATION) += ia32/
 obj-y += platform/
 obj-y += net/
 
-ifeq ($(CONFIG_X86_64),y)
-obj-$(CONFIG_KEXEC) += purgatory/
-endif
+obj-$(CONFIG_KEXEC_FILE) += purgatory/
diff -puN arch/x86/Kconfig~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/Kconfig
@@ -1585,9 +1585,6 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
-	select BUILD_BIN2C
-	select CRYPTO
-	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
@@ -1602,9 +1599,22 @@ config KEXEC
 	  interface is strongly in flux, so no good recommendation can be
 	  made.
 
+config KEXEC_FILE
+	bool "kexec file based system call"
+	select BUILD_BIN2C
+	depends on KEXEC
+	depends on X86_64
+	depends on CRYPTO=y
+	depends on CRYPTO_SHA256=y
+	---help---
+	  This is new version of kexec system call. This system call is
+	  file based and takes file descriptors as system call argument
+	  for kernel and initramfs as opposed to list of segments as
+	  accepted by previous system call.
+
 config KEXEC_VERIFY_SIG
 	bool "Verify kernel signature during kexec_file_load() syscall"
-	depends on KEXEC
+	depends on KEXEC_FILE
 	---help---
 	  This option makes kernel signature verification mandatory for
 	  kexec_file_load() syscall. If kernel is signature can not be
diff -puN arch/x86/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/Makefile
--- a/arch/x86/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/Makefile
@@ -184,11 +184,8 @@ archheaders:
 	$(Q)$(MAKE) $(build)=arch/x86/syscalls all
 
 archprepare:
-ifeq ($(CONFIG_KEXEC),y)
-# Build only for 64bit. No loaders for 32bit yet.
- ifeq ($(CONFIG_X86_64),y)
+ifeq ($(CONFIG_KEXEC_FILE),y)
 	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
- endif
 endif
 
 ###
diff -puN arch/x86/kernel/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
+obj-$(CONFIG_KEXEC_FILE)	+= kexec-bzimage64.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
@@ -118,5 +119,4 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
-	obj-$(CONFIG_KEXEC)		+= kexec-bzimage64.o
 endif
diff -puN arch/x86/kernel/crash.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/kernel/crash.c
@@ -182,8 +182,7 @@ void native_machine_crash_shutdown(struc
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
 
-#ifdef CONFIG_X86_64
-
+#ifdef CONFIG_KEXEC_FILE
 static int get_nr_ram_ranges_callback(unsigned long start_pfn,
 				unsigned long nr_pfn, void *arg)
 {
@@ -696,5 +695,4 @@ int crash_load_segments(struct kimage *i
 
 	return ret;
 }
-
-#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_KEXEC_FILE */
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -25,9 +25,11 @@
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage64.h>
 
+#ifdef CONFIG_KEXEC_FILE
 static struct kexec_file_ops *kexec_file_loaders[] = {
 		&kexec_bzImage64_ops,
 };
+#endif
 
 static void free_transition_pgtable(struct kimage *image)
 {
@@ -178,6 +180,7 @@ static void load_segments(void)
 		);
 }
 
+#ifdef CONFIG_KEXEC_FILE
 /* Update purgatory as needed after various image segments have been prepared */
 static int arch_update_purgatory(struct kimage *image)
 {
@@ -209,6 +212,12 @@ static int arch_update_purgatory(struct
 
 	return ret;
 }
+#else /* !CONFIG_KEXEC_FILE */
+static inline int arch_update_purgatory(struct kimage *image)
+{
+	return 0;
+}
+#endif /* CONFIG_KEXEC_FILE */
 
 int machine_kexec_prepare(struct kimage *image)
 {
@@ -329,6 +338,7 @@ void arch_crash_save_vmcoreinfo(void)
 
 /* arch-dependent functionality related to kexec file-based syscall */
 
+#ifdef CONFIG_KEXEC_FILE
 int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 				  unsigned long buf_len)
 {
@@ -522,3 +532,4 @@ overflow:
 	       (int)ELF64_R_TYPE(rel[i].r_info), value);
 	return -ENOEXEC;
 }
+#endif /* CONFIG_KEXEC_FILE */
diff -puN arch/x86/purgatory/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/arch/x86/purgatory/Makefile
@@ -24,7 +24,4 @@ $(obj)/kexec-purgatory.c: $(obj)/purgato
 	$(call if_changed,bin2c)
 
 
-# No loaders for 32bits yet.
-ifeq ($(CONFIG_X86_64),y)
- obj-$(CONFIG_KEXEC)		+= kexec-purgatory.o
-endif
+obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
diff -puN kernel/kexec.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall kernel/kexec.c
--- a/kernel/kexec.c~kexec-create-a-new-config-option-config_kexec_file-for-new-syscall
+++ a/kernel/kexec.c
@@ -64,7 +64,9 @@ bool kexec_in_progress = false;
 char __weak kexec_purgatory[0];
 size_t __weak kexec_purgatory_size = 0;
 
+#ifdef CONFIG_KEXEC_FILE
 static int kexec_calculate_store_digests(struct kimage *image);
+#endif
 
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
@@ -341,6 +343,7 @@ out_free_image:
 	return ret;
 }
 
+#ifdef CONFIG_KEXEC_FILE
 static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
 {
 	struct fd f = fdget(fd);
@@ -612,6 +615,9 @@ out_free_image:
 	kfree(image);
 	return ret;
 }
+#else /* CONFIG_KEXEC_FILE */
+static inline void kimage_file_post_load_cleanup(struct kimage *image) { }
+#endif /* CONFIG_KEXEC_FILE */
 
 static int kimage_is_destination_range(struct kimage *image,
 					unsigned long start,
@@ -1375,6 +1381,7 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compa
 }
 #endif
 
+#ifdef CONFIG_KEXEC_FILE
 SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 		unsigned long, cmdline_len, const char __user *, cmdline_ptr,
 		unsigned long, flags)
@@ -1451,6 +1458,8 @@ out:
 	return ret;
 }
 
+#endif /* CONFIG_KEXEC_FILE */
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
@@ -2006,6 +2015,7 @@ static int __init crash_save_vmcoreinfo_
 
 subsys_initcall(crash_save_vmcoreinfo_init);
 
+#ifdef CONFIG_KEXEC_FILE
 static int __kexec_add_segment(struct kimage *image, char *buf,
 			       unsigned long bufsz, unsigned long mem,
 			       unsigned long memsz)
@@ -2682,6 +2692,7 @@ int kexec_purgatory_get_set_symbol(struc
 
 	return 0;
 }
+#endif /* CONFIG_KEXEC_FILE */
 
 /*
  * Move into place and start executing a preloaded standalone
_

Patches currently in -mm which might be from vgoyal@redhat.com are

try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
linux-next.patch

