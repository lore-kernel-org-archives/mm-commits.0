From: akpm@linux-foundation.org
Subject: - remove-__attribute_used__.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:03:43 -0800
Message-ID: <200801212303.m0LN3ivC024499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbYAUXER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, rientjes@google.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     remove __attribute_used__
has been removed from the -mm tree.  Its filename was
     remove-__attribute_used__.patch

This patch was dropped because Sam merged a patch which broke it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove __attribute_used__
From: Adrian Bunk <bunk@kernel.org>

Remove the deprecated __attribute_used__.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/dec_and_lock.c           |    3 +--
 arch/powerpc/boot/Makefile              |    2 +-
 arch/powerpc/kernel/sysfs.c             |    2 +-
 arch/powerpc/oprofile/op_model_power4.c |    6 +++---
 arch/sparc64/kernel/unaligned.c         |    2 +-
 arch/um/include/init.h                  |   18 +++++++++---------
 drivers/rapidio/rio.h                   |    2 +-
 fs/compat_ioctl.c                       |    2 +-
 include/asm-avr32/setup.h               |    2 +-
 include/asm-ia64/gcc_intrin.h           |    2 +-
 include/asm-sh/machvec.h                |    2 +-
 include/asm-sh/thread_info.h            |    2 +-
 include/asm-x86/thread_info_32.h        |    2 +-
 include/linux/compiler-gcc3.h           |    2 --
 include/linux/compiler-gcc4.h           |    1 -
 include/linux/compiler.h                |    4 ----
 include/linux/elfnote.h                 |    2 +-
 include/linux/init.h                    |   12 ++++++------
 include/linux/module.h                  |    4 ++--
 include/linux/moduleparam.h             |    4 ++--
 include/linux/pci.h                     |    2 +-
 scripts/mod/modpost.c                   |    4 ++--
 22 files changed, 37 insertions(+), 45 deletions(-)

diff -puN arch/alpha/lib/dec_and_lock.c~remove-__attribute_used__ arch/alpha/lib/dec_and_lock.c
--- a/arch/alpha/lib/dec_and_lock.c~remove-__attribute_used__
+++ a/arch/alpha/lib/dec_and_lock.c
@@ -30,8 +30,7 @@ _atomic_dec_and_lock:				\n\
 	.previous				\n\
 	.end _atomic_dec_and_lock");
 
-static int __attribute_used__
-atomic_dec_and_lock_1(atomic_t *atomic, spinlock_t *lock)
+static int __used atomic_dec_and_lock_1(atomic_t *atomic, spinlock_t *lock)
 {
 	/* Slow path */
 	spin_lock(lock);
diff -puN arch/powerpc/boot/Makefile~remove-__attribute_used__ arch/powerpc/boot/Makefile
--- a/arch/powerpc/boot/Makefile~remove-__attribute_used__
+++ a/arch/powerpc/boot/Makefile
@@ -71,7 +71,7 @@ obj-wlib := $(addsuffix .o, $(basename $
 obj-plat := $(addsuffix .o, $(basename $(addprefix $(obj)/, $(src-plat))))
 
 quiet_cmd_copy_zlib = COPY    $@
-      cmd_copy_zlib = sed "s@__attribute_used__@@;s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
+      cmd_copy_zlib = sed "s@__used@@;s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
 
 quiet_cmd_copy_zlibheader = COPY    $@
       cmd_copy_zlibheader = sed "s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
diff -puN arch/powerpc/kernel/sysfs.c~remove-__attribute_used__ arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c~remove-__attribute_used__
+++ a/arch/powerpc/kernel/sysfs.c
@@ -158,7 +158,7 @@ static ssize_t show_##NAME(struct sys_de
 	unsigned long val = run_on_cpu(cpu->sysdev.id, read_##NAME, 0); \
 	return sprintf(buf, "%lx\n", val); \
 } \
-static ssize_t __attribute_used__ \
+static ssize_t __used \
 	store_##NAME(struct sys_device *dev, const char *buf, size_t count) \
 { \
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev); \
diff -puN arch/powerpc/oprofile/op_model_power4.c~remove-__attribute_used__ arch/powerpc/oprofile/op_model_power4.c
--- a/arch/powerpc/oprofile/op_model_power4.c~remove-__attribute_used__
+++ a/arch/powerpc/oprofile/op_model_power4.c
@@ -172,15 +172,15 @@ static void power4_stop(void)
 }
 
 /* Fake functions used by canonicalize_pc */
-static void __attribute_used__ hypervisor_bucket(void)
+static void __used hypervisor_bucket(void)
 {
 }
 
-static void __attribute_used__ rtas_bucket(void)
+static void __used rtas_bucket(void)
 {
 }
 
-static void __attribute_used__ kernel_unknown_bucket(void)
+static void __used kernel_unknown_bucket(void)
 {
 }
 
diff -puN arch/sparc64/kernel/unaligned.c~remove-__attribute_used__ arch/sparc64/kernel/unaligned.c
--- a/arch/sparc64/kernel/unaligned.c~remove-__attribute_used__
+++ a/arch/sparc64/kernel/unaligned.c
@@ -175,7 +175,7 @@ unsigned long compute_effective_address(
 }
 
 /* This is just to make gcc think die_if_kernel does return... */
-static void __attribute_used__ unaligned_panic(char *str, struct pt_regs *regs)
+static void __used unaligned_panic(char *str, struct pt_regs *regs)
 {
 	die_if_kernel(str, regs);
 }
diff -puN arch/um/include/init.h~remove-__attribute_used__ arch/um/include/init.h
--- a/arch/um/include/init.h~remove-__attribute_used__
+++ a/arch/um/include/init.h
@@ -54,12 +54,12 @@ typedef void (*exitcall_t)(void);
 #define __init		__attribute__ ((__section__ (".init.text")))
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __exit_call	__used __attribute__ ((__section__ (".exitcall.exit")))
 
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
+#define __exit		__used __attribute__ ((__section__(".exit.text")))
 #endif
 
 #endif
@@ -112,16 +112,16 @@ extern struct uml_param __uml_setup_star
  * Mark functions and data as being only used at initialization
  * or exit time.
  */
-#define __uml_init_setup	__attribute_used__ __attribute__ ((__section__ (".uml.setup.init")))
-#define __uml_setup_help	__attribute_used__ __attribute__ ((__section__ (".uml.help.init")))
-#define __uml_init_call		__attribute_used__ __attribute__ ((__section__ (".uml.initcall.init")))
-#define __uml_postsetup_call	__attribute_used__ __attribute__ ((__section__ (".uml.postsetup.init")))
-#define __uml_exit_call		__attribute_used__ __attribute__ ((__section__ (".uml.exitcall.exit")))
+#define __uml_init_setup	__used __attribute__ ((__section__ (".uml.setup.init")))
+#define __uml_setup_help	__used __attribute__ ((__section__ (".uml.help.init")))
+#define __uml_init_call		__used __attribute__ ((__section__ (".uml.initcall.init")))
+#define __uml_postsetup_call	__used __attribute__ ((__section__ (".uml.postsetup.init")))
+#define __uml_exit_call		__used __attribute__ ((__section__ (".uml.exitcall.exit")))
 
 #ifndef __KERNEL__
 
 #define __define_initcall(level,fn) \
-	static initcall_t __initcall_##fn __attribute_used__ \
+	static initcall_t __initcall_##fn __used \
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /* Userspace initcalls shouldn't depend on anything in the kernel, so we'll
@@ -131,7 +131,7 @@ extern struct uml_param __uml_setup_star
 
 #define __exitcall(fn) static exitcall_t __exitcall_##fn __exit_call = fn
 
-#define __init_call	__attribute_used__ __attribute__ ((__section__ (".initcall.init")))
+#define __init_call	__used __attribute__ ((__section__ (".initcall.init")))
 
 #endif
 
diff -puN drivers/rapidio/rio.h~remove-__attribute_used__ drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~remove-__attribute_used__
+++ a/drivers/rapidio/rio.h
@@ -31,7 +31,7 @@ extern struct rio_route_ops __end_rio_ro
 
 /* Helpers internal to the RIO core code */
 #define DECLARE_RIO_ROUTE_SECTION(section, vid, did, add_hook, get_hook)  \
-        static struct rio_route_ops __rio_route_ops __attribute_used__   \
+        static struct rio_route_ops __rio_route_ops __used   \
 	        __attribute__((__section__(#section))) = { vid, did, add_hook, get_hook };
 
 /**
diff -puN fs/compat_ioctl.c~remove-__attribute_used__ fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~remove-__attribute_used__
+++ a/fs/compat_ioctl.c
@@ -1375,7 +1375,7 @@ static int do_atm_ioctl(unsigned int fd,
         return -EINVAL;
 }
 
-static __attribute_used__ int 
+static __used int
 ret_einval(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	return -EINVAL;
diff -puN include/asm-avr32/setup.h~remove-__attribute_used__ include/asm-avr32/setup.h
--- a/include/asm-avr32/setup.h~remove-__attribute_used__
+++ a/include/asm-avr32/setup.h
@@ -110,7 +110,7 @@ struct tagtable {
 	int	(*parse)(struct tag *);
 };
 
-#define __tag __attribute_used__ __attribute__((__section__(".taglist.init")))
+#define __tag __used __attribute__((__section__(".taglist.init")))
 #define __tagtable(tag, fn)						\
 	static struct tagtable __tagtable_##fn __tag = { tag, fn }
 
diff -puN include/asm-ia64/gcc_intrin.h~remove-__attribute_used__ include/asm-ia64/gcc_intrin.h
--- a/include/asm-ia64/gcc_intrin.h~remove-__attribute_used__
+++ a/include/asm-ia64/gcc_intrin.h
@@ -24,7 +24,7 @@
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
-register unsigned long ia64_r13 asm ("r13") __attribute_used__;
+register unsigned long ia64_r13 asm ("r13") __used;
 
 #define ia64_setreg(regnum, val)						\
 ({										\
diff -puN include/asm-sh/machvec.h~remove-__attribute_used__ include/asm-sh/machvec.h
--- a/include/asm-sh/machvec.h~remove-__attribute_used__
+++ a/include/asm-sh/machvec.h
@@ -68,6 +68,6 @@ extern struct sh_machine_vector sh_mv;
 #define get_system_type()	sh_mv.mv_name
 
 #define __initmv \
-	__attribute_used__ __attribute__((__section__ (".machvec.init")))
+	__used __attribute__((__section__ (".machvec.init")))
 
 #endif /* _ASM_SH_MACHVEC_H */
diff -puN include/asm-sh/thread_info.h~remove-__attribute_used__ include/asm-sh/thread_info.h
--- a/include/asm-sh/thread_info.h~remove-__attribute_used__
+++ a/include/asm-sh/thread_info.h
@@ -68,7 +68,7 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 /* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("r15") __attribute_used__;
+register unsigned long current_stack_pointer asm("r15") __used;
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
diff -puN include/asm-x86/thread_info_32.h~remove-__attribute_used__ include/asm-x86/thread_info_32.h
--- a/include/asm-x86/thread_info_32.h~remove-__attribute_used__
+++ a/include/asm-x86/thread_info_32.h
@@ -85,7 +85,7 @@ struct thread_info {
 
 
 /* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __attribute_used__;
+register unsigned long current_stack_pointer asm("esp") __used;
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
diff -puN include/linux/compiler-gcc3.h~remove-__attribute_used__ include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~remove-__attribute_used__
+++ a/include/linux/compiler-gcc3.h
@@ -7,10 +7,8 @@
 
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
-# define __attribute_used__	__used				/* deprecated */
 #else
 # define __used			__attribute__((__unused__))
-# define __attribute_used__	__used				/* deprecated */
 #endif
 
 #if __GNUC_MINOR__ >= 4
diff -puN include/linux/compiler-gcc4.h~remove-__attribute_used__ include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~remove-__attribute_used__
+++ a/include/linux/compiler-gcc4.h
@@ -15,7 +15,6 @@
 #endif
 
 #define __used			__attribute__((__used__))
-#define __attribute_used__	__used			/* deprecated */
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler.h~remove-__attribute_used__ include/linux/compiler.h
--- a/include/linux/compiler.h~remove-__attribute_used__
+++ a/include/linux/compiler.h
@@ -126,10 +126,6 @@ extern void __chk_io_ptr(const volatile 
  * Mark functions that are referenced only in inline assembly as __used so
  * the code is emitted even though it appears to be unreferenced.
  */
-#ifndef __attribute_used__
-# define __attribute_used__	/* deprecated */
-#endif
-
 #ifndef __used
 # define __used			/* unimplemented */
 #endif
diff -puN include/linux/elfnote.h~remove-__attribute_used__ include/linux/elfnote.h
--- a/include/linux/elfnote.h~remove-__attribute_used__
+++ a/include/linux/elfnote.h
@@ -76,7 +76,7 @@
 		typeof(desc) _desc					\
 			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
 	} _ELFNOTE_PASTE(_note_, unique)				\
-		__attribute_used__					\
+		__used							\
 		__attribute__((section(".note." name),			\
 			       aligned(sizeof(Elf##size##_Word)),	\
 			       unused)) = {				\
diff -puN include/linux/init.h~remove-__attribute_used__ include/linux/init.h
--- a/include/linux/init.h~remove-__attribute_used__
+++ a/include/linux/init.h
@@ -43,7 +43,7 @@
 #define __init		__attribute__ ((__section__ (".init.text"))) __cold
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __exit_call	__used __attribute__ ((__section__ (".exitcall.exit")))
 
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -62,7 +62,7 @@
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text"))) __cold
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text"))) __cold
+#define __exit		__used __attribute__ ((__section__(".exit.text"))) __cold
 #endif
 
 /* For assembly routines */
@@ -109,7 +109,7 @@ void prepare_namespace(void);
  */
 
 #define __define_initcall(level,fn,id) \
-	static initcall_t __initcall_##fn##id __attribute_used__ \
+	static initcall_t __initcall_##fn##id __used \
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /*
@@ -143,11 +143,11 @@ void prepare_namespace(void);
 
 #define console_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".con_initcall.init")))=fn
+	__used __attribute__((__section__(".con_initcall.init")))=fn
 
 #define security_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".security_initcall.init"))) = fn
+	__used __attribute__((__section__(".security_initcall.init"))) = fn
 
 struct obs_kernel_param {
 	const char *str;
@@ -164,7 +164,7 @@ struct obs_kernel_param {
 #define __setup_param(str, unique_id, fn, early)			\
 	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
-		__attribute_used__				\
+		__used						\
 		__attribute__((__section__(".init.setup")))	\
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
diff -puN include/linux/module.h~remove-__attribute_used__ include/linux/module.h
--- a/include/linux/module.h~remove-__attribute_used__
+++ a/include/linux/module.h
@@ -178,7 +178,7 @@ void *__symbol_get_gpl(const char *symbo
 #define __CRC_SYMBOL(sym, sec)					\
 	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
-	__attribute_used__					\
+	__used							\
 	__attribute__((section("__kcrctab" sec), unused))	\
 	= (unsigned long) &__crc_##sym;
 #else
@@ -193,7 +193,7 @@ void *__symbol_get_gpl(const char *symbo
 	__attribute__((section("__ksymtab_strings")))		\
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
-	__attribute_used__					\
+	__used							\
 	__attribute__((section("__ksymtab" sec), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
diff -puN include/linux/moduleparam.h~remove-__attribute_used__ include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~remove-__attribute_used__
+++ a/include/linux/moduleparam.h
@@ -18,7 +18,7 @@
 #define __module_cat(a,b) ___module_cat(a,b)
 #define __MODULE_INFO(tag, name, info)					  \
 static const char __module_cat(name,__LINE__)[]				  \
-  __attribute_used__							  \
+  __used								  \
   __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
@@ -72,7 +72,7 @@ struct kparam_array
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
-	__attribute_used__						\
+	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
 
diff -puN include/linux/pci.h~remove-__attribute_used__ include/linux/pci.h
--- a/include/linux/pci.h~remove-__attribute_used__
+++ a/include/linux/pci.h
@@ -906,7 +906,7 @@ enum pci_fixup_pass {
 
 /* Anonymous variables would be nice... */
 #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, hook)	\
-	static const struct pci_fixup __pci_fixup_##name __attribute_used__ \
+	static const struct pci_fixup __pci_fixup_##name __used		\
 	__attribute__((__section__(#section))) = { vendor, device, hook };
 #define DECLARE_PCI_FIXUP_EARLY(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,			\
diff -puN scripts/mod/modpost.c~remove-__attribute_used__ scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~remove-__attribute_used__
+++ a/scripts/mod/modpost.c
@@ -1451,7 +1451,7 @@ static int add_versions(struct buffer *b
 
 	buf_printf(b, "\n");
 	buf_printf(b, "static const struct modversion_info ____versions[]\n");
-	buf_printf(b, "__attribute_used__\n");
+	buf_printf(b, "__used\n");
 	buf_printf(b, "__attribute__((section(\"__versions\"))) = {\n");
 
 	for (s = mod->unres; s; s = s->next) {
@@ -1482,7 +1482,7 @@ static void add_depends(struct buffer *b
 
 	buf_printf(b, "\n");
 	buf_printf(b, "static const char __module_depends[]\n");
-	buf_printf(b, "__attribute_used__\n");
+	buf_printf(b, "__used\n");
 	buf_printf(b, "__attribute__((section(\".modinfo\"))) =\n");
 	buf_printf(b, "\"depends=");
 	for (s = mod->unres; s; s = s->next) {
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-infiniband.patch
git-kbuild.patch
git-mtd.patch
git-net.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
xen-fiddle_vdso-must-be-__init.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
reiser4.patch
