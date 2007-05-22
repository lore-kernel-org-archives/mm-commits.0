From: akpm@linux-foundation.org
Subject: + delete-every-useless-reference-to-noret_type-in-the-tree.patch added to -mm tree
Date: Tue, 22 May 2007 11:25:01 -0700
Message-ID: <200705221825.l4MIP1th007275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185AbXEVS0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 14:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Delete every useless reference to NORET_TYPE in the tree
has been added to the -mm tree.  Its filename is
     delete-every-useless-reference-to-noret_type-in-the-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Delete every useless reference to NORET_TYPE in the tree
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete every reference to NORET_TYPE in the tree, based on the
explanation found here:

  http://www.ussg.iu.edu/hypermail/linux/kernel/9605/1957.html

which shows that that macro hasn't had a value since gcc-2.2.5, when
it was defined to equal "__volatile__".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c                |    2 +-
 arch/arm26/kernel/traps.c              |    2 +-
 arch/avr32/kernel/traps.c              |    2 +-
 arch/i386/kernel/machine_kexec.c       |    2 +-
 arch/ia64/kernel/machine_kexec.c       |    2 +-
 arch/m68k/amiga/config.c               |    2 +-
 arch/mips/kernel/traps.c               |    2 +-
 arch/powerpc/kernel/machine_kexec.c    |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 arch/ppc/amiga/config.c                |    2 +-
 arch/ppc/kernel/machine_kexec.c        |    4 ++--
 arch/sh/kernel/machine_kexec.c         |    4 ++--
 arch/x86_64/kernel/machine_kexec.c     |    2 +-
 drivers/s390/s390mach.c                |    2 +-
 include/asm-avr32/system.h             |    2 +-
 include/asm-i386/kexec.h               |    2 +-
 include/asm-mips/ptrace.h              |    2 +-
 include/asm-x86_64/kexec.h             |    2 +-
 include/linux/ext3_fs.h                |    1 -
 include/linux/ext4_fs.h                |    1 -
 include/linux/kernel.h                 |    6 +++---
 include/linux/kexec.h                  |    2 +-
 include/linux/linkage.h                |    1 -
 include/linux/sched.h                  |    2 +-
 kernel/exit.c                          |    6 +++---
 kernel/panic.c                         |    2 +-
 27 files changed, 30 insertions(+), 33 deletions(-)

diff -puN arch/arm/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/arm/kernel/traps.c
@@ -228,7 +228,7 @@ DEFINE_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();
 
diff -puN arch/arm26/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/arm26/kernel/traps.c
--- a/arch/arm26/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/arm26/kernel/traps.c
@@ -175,7 +175,7 @@ DEFINE_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct task_struct *tsk = current;
 
diff -puN arch/avr32/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/avr32/kernel/traps.c
@@ -22,7 +22,7 @@
 
 static DEFINE_SPINLOCK(die_lock);
 
-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
+void die(const char *str, struct pt_regs *regs, long err)
 {
 	static int die_counter;
 
diff -puN arch/i386/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/i386/kernel/machine_kexec.c
@@ -101,7 +101,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
diff -puN arch/ia64/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -20,7 +20,7 @@
 #include <asm/delay.h>
 #include <asm/meminit.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
 					unsigned long start_address,
 					struct ia64_boot_param *boot_param,
diff -puN arch/m68k/amiga/config.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/m68k/amiga/config.c
@@ -674,7 +674,7 @@ static unsigned int amiga_get_ss(void)
 	return s;
 }
 
-static NORET_TYPE void amiga_reset(void)
+static void amiga_reset(void)
     ATTRIB_NORET;
 
 static void amiga_reset(void)
diff -puN arch/mips/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/mips/kernel/traps.c
@@ -310,7 +310,7 @@ void show_registers(struct pt_regs *regs
 
 static DEFINE_SPINLOCK(die_lock);
 
-NORET_TYPE void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
+void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
 {
 	static int die_counter;
 #ifdef CONFIG_MIPS_MT_SMTC
diff -puN arch/powerpc/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/powerpc/kernel/machine_kexec.c
--- a/arch/powerpc/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/powerpc/kernel/machine_kexec.c
@@ -47,7 +47,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
diff -puN arch/powerpc/kernel/machine_kexec_32.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/powerpc/kernel/machine_kexec_32.c
--- a/arch/powerpc/kernel/machine_kexec_32.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/powerpc/kernel/machine_kexec_32.c
@@ -16,7 +16,7 @@
 #include <asm/hw_irq.h>
 #include <asm/io.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address) ATTRIB_NORET;
diff -puN arch/powerpc/kernel/machine_kexec_64.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -253,7 +253,7 @@ union thread_union kexec_stack
 	__attribute__((__section__(".data.init_task"))) = { };
 
 /* Our assembly helper, in kexec_stub.S */
-extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
+extern void kexec_sequence(void *newstack, unsigned long start,
 					void *image, void *control,
 					void (*clear_all)(void)) ATTRIB_NORET;
 
diff -puN arch/ppc/amiga/config.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/ppc/amiga/config.c
--- a/arch/ppc/amiga/config.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/ppc/amiga/config.c
@@ -694,7 +694,7 @@ static int amiga_set_clock_mmss (unsigne
 	return 0;
 }
 
-static NORET_TYPE void amiga_reset( void )
+static void amiga_reset( void )
     ATTRIB_NORET;
 
 static void amiga_reset (void)
diff -puN arch/ppc/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/ppc/kernel/machine_kexec.c
--- a/arch/ppc/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/ppc/kernel/machine_kexec.c
@@ -20,7 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address) ATTRIB_NORET;
@@ -66,7 +66,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
diff -puN arch/sh/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/sh/kernel/machine_kexec.c
--- a/arch/sh/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/sh/kernel/machine_kexec.c
@@ -19,7 +19,7 @@
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 
-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address,
@@ -70,7 +70,7 @@ static void kexec_info(struct kimage *im
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 
 	unsigned long page_list;
diff -puN arch/x86_64/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/arch/x86_64/kernel/machine_kexec.c
@@ -178,7 +178,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
diff -puN drivers/s390/s390mach.c~delete-every-useless-reference-to-noret_type-in-the-tree drivers/s390/s390mach.c
--- a/drivers/s390/s390mach.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/drivers/s390/s390mach.c
@@ -26,7 +26,7 @@
 
 static struct semaphore m_sem;
 
-static NORET_TYPE void
+static void
 s390_handle_damage(char *msg)
 {
 #ifdef CONFIG_SMP
diff -puN include/asm-avr32/system.h~delete-every-useless-reference-to-noret_type-in-the-tree include/asm-avr32/system.h
--- a/include/asm-avr32/system.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/asm-avr32/system.h
@@ -141,7 +141,7 @@ static inline unsigned long __cmpxchg(vo
 				   sizeof(*(ptr))))
 
 struct pt_regs;
-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err);
+void die(const char *str, struct pt_regs *regs, long err);
 void _exception(long signr, struct pt_regs *regs, int code,
 		unsigned long addr);
 
diff -puN include/asm-i386/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree include/asm-i386/kexec.h
--- a/include/asm-i386/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/asm-i386/kexec.h
@@ -88,7 +88,7 @@ static inline void crash_setup_regs(stru
                newregs->eip = (unsigned long)current_text_addr();
        }
 }
-asmlinkage NORET_TYPE void
+asmlinkage void
 relocate_kernel(unsigned long indirection_page,
 		unsigned long control_page,
 		unsigned long start_address,
diff -puN include/asm-mips/ptrace.h~delete-every-useless-reference-to-noret_type-in-the-tree include/asm-mips/ptrace.h
--- a/include/asm-mips/ptrace.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/asm-mips/ptrace.h
@@ -86,7 +86,7 @@ struct pt_regs {
 
 extern asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit);
 
-extern NORET_TYPE void die(const char *, struct pt_regs *);
+extern void die(const char *, struct pt_regs *);
 
 static inline void die_if_kernel(const char *str, struct pt_regs *regs)
 {
diff -puN include/asm-x86_64/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree include/asm-x86_64/kexec.h
--- a/include/asm-x86_64/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/asm-x86_64/kexec.h
@@ -84,7 +84,7 @@ static inline void crash_setup_regs(stru
 	}
 }
 
-NORET_TYPE void
+void
 relocate_kernel(unsigned long indirection_page,
 		unsigned long page_list,
 		unsigned long start_address) ATTRIB_NORET;
diff -puN include/linux/ext3_fs.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/ext3_fs.h
@@ -753,7 +753,6 @@ ext3_group_first_block_no(struct super_b
  * Ok, these declarations are also in <linux/kernel.h> but none of the
  * ext3 source programs needs to include it so they are duplicated here.
  */
-# define NORET_TYPE    /**/
 # define ATTRIB_NORET  __attribute__((noreturn))
 # define NORET_AND     noreturn,
 
diff -puN include/linux/ext4_fs.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/ext4_fs.h
@@ -780,7 +780,6 @@ void ext4_get_group_no_and_offset(struct
  * Ok, these declarations are also in <linux/kernel.h> but none of the
  * ext4 source programs needs to include it so they are duplicated here.
  */
-# define NORET_TYPE    /**/
 # define ATTRIB_NORET  __attribute__((noreturn))
 # define NORET_AND     noreturn,
 
diff -puN include/linux/kernel.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/kernel.h
--- a/include/linux/kernel.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/kernel.h
@@ -105,14 +105,14 @@ extern int cond_resched(void);
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2)));
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-fastcall NORET_TYPE void do_exit(long error_code)
+fastcall void do_exit(long error_code)
 	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
+void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
diff -puN include/linux/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/kexec.h
--- a/include/linux/kexec.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/kexec.h
@@ -103,7 +103,7 @@ struct kimage {
 
 
 /* kexec interface functions */
-extern NORET_TYPE void machine_kexec(struct kimage *image) ATTRIB_NORET;
+extern void machine_kexec(struct kimage *image) ATTRIB_NORET;
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
diff -puN include/linux/linkage.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/linkage.h
--- a/include/linux/linkage.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/linkage.h
@@ -55,7 +55,6 @@
 
 #endif
 
-#define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
 #define NORET_AND     noreturn,
 
diff -puN include/linux/sched.h~delete-every-useless-reference-to-noret_type-in-the-tree include/linux/sched.h
--- a/include/linux/sched.h~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/include/linux/sched.h
@@ -1423,7 +1423,7 @@ extern void __cleanup_signal(struct sign
 extern void __cleanup_sighand(struct sighand_struct *);
 extern void exit_itimers(struct signal_struct *);
 
-extern NORET_TYPE void do_group_exit(int);
+extern void do_group_exit(int);
 
 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
diff -puN kernel/exit.c~delete-every-useless-reference-to-noret_type-in-the-tree kernel/exit.c
--- a/kernel/exit.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/kernel/exit.c
@@ -859,7 +859,7 @@ static void exit_notify(struct task_stru
 		release_task(tsk);
 }
 
-fastcall NORET_TYPE void do_exit(long code)
+fastcall void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
@@ -985,7 +985,7 @@ fastcall NORET_TYPE void do_exit(long co
 
 EXPORT_SYMBOL_GPL(do_exit);
 
-NORET_TYPE void complete_and_exit(struct completion *comp, long code)
+void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
 		complete(comp);
@@ -1004,7 +1004,7 @@ asmlinkage long sys_exit(int error_code)
  * Take down every thread in the group.  This is called by fatal signals
  * as well as by sys_exit_group (below).
  */
-NORET_TYPE void
+void
 do_group_exit(int exit_code)
 {
 	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
diff -puN kernel/panic.c~delete-every-useless-reference-to-noret_type-in-the-tree kernel/panic.c
--- a/kernel/panic.c~delete-every-useless-reference-to-noret_type-in-the-tree
+++ a/kernel/panic.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(panic_blink);
  *	This function never returns.
  */
  
-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char * fmt, ...)
 {
 	long i;
 	static char buf[1024];
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
documentation-fix-the-explanation-of-kconfig-files.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
delete-every-useless-reference-to-noret_type-in-the-tree.patch
