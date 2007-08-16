From: akpm@linux-foundation.org
Subject: + uml-throw-out-config_mode_tt.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:11 -0700
Message-ID: <200708162114.l7GLEBwK007074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757149AbXHPVOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: throw out CONFIG_MODE_TT
has been added to the -mm tree.  Its filename is
     uml-throw-out-config_mode_tt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: throw out CONFIG_MODE_TT
From: Jeff Dike <jdike@addtoit.com>

This patchset throws out tt mode, which has been non-functional for a while.

This is done in phases, interspersed with code cleanups on the affected files.

The removal is done as follows:
	remove all code, config options, and files which depend on
CONFIG_MODE_TT
	get rid of the CHOOSE_MODE macro, which decided whether to
call tt-mode or skas-mode code, and replace invocations with their
skas portions
	replace all now-trivial procedures with their skas equivalents

There are now a bunch of now-redundant pieces of data structures, including
mode-specific pieces of the thread structure, pt_regs, and mm_context.  These
are all replaced with their skas-specific contents.

As part of the ongoing style compliance project, I made a style pass over all
files that were changed.  There are three such patches, one for each phase,
covering the files affected by that phase but no later ones.

I noticed that we weren't freeing the LDT state associated with a process when
it exited, so that's fixed in one of the later patches.

The last patch is a tidying patch which I've had for a while, but which caused
inexplicable crashes under tt mode.  Since that is no longer a problem, this
can now go in.


This patch:

Start getting rid of tt mode support.

This patch throws out CONFIG_MODE_TT and all config options, code, and files
which depend on it.

CONFIG_MODE_SKAS is gone and everything that depends on it is included
unconditionally.

The few changed lines are in re-written Kconfig help, lines which needed
something skas-related removed from them, and a few more which weren't
strictly deletions.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig                          |   64 --
 arch/um/Kconfig.char                     |    2 
 arch/um/Kconfig.debug                    |   23 -
 arch/um/Makefile                         |   26 -
 arch/um/Makefile-i386                    |    6 
 arch/um/defconfig                        |    2 
 arch/um/drivers/mconsole_kern.c          |   15 
 arch/um/include/as-layout.h              |    1 
 arch/um/include/choose-mode.h            |   18 
 arch/um/include/common-offsets.h         |    3 
 arch/um/include/irq_user.h               |    4 
 arch/um/include/kern_util.h              |    6 
 arch/um/include/mode.h                   |   19 
 arch/um/include/mode_kern.h              |    6 
 arch/um/include/os.h                     |   26 -
 arch/um/include/sysdep-i386/ptrace.h     |   23 -
 arch/um/include/sysdep-i386/sigcontext.h |    4 
 arch/um/include/sysdep-i386/thread.h     |    3 
 arch/um/include/sysdep-x86_64/ptrace.h   |   21 
 arch/um/include/sysdep-x86_64/thread.h   |    4 
 arch/um/include/tt/debug.h               |   18 
 arch/um/include/tt/mmu-tt.h              |   12 
 arch/um/include/tt/mode-tt.h             |   23 -
 arch/um/include/tt/mode_kern_tt.h        |   40 -
 arch/um/include/tt/tt.h                  |   37 -
 arch/um/include/tt/uaccess-tt.h          |   46 --
 arch/um/include/um_mmu.h                 |   23 -
 arch/um/include/um_uaccess.h             |    8 
 arch/um/kernel/Makefile                  |    5 
 arch/um/kernel/dyn.lds.S                 |    2 
 arch/um/kernel/exec.c                    |    1 
 arch/um/kernel/init_task.c               |    7 
 arch/um/kernel/irq.c                     |   24 -
 arch/um/kernel/ksyms.c                   |   10 
 arch/um/kernel/process.c                 |    7 
 arch/um/kernel/reboot.c                  |   19 
 arch/um/kernel/smp.c                     |    5 
 arch/um/kernel/trap.c                    |    2 
 arch/um/kernel/tt/Makefile               |   14 
 arch/um/kernel/tt/exec_kern.c            |   84 ---
 arch/um/kernel/tt/exec_user.c            |   56 --
 arch/um/kernel/tt/gdb.c                  |  280 ------------
 arch/um/kernel/tt/gdb_kern.c             |   40 -
 arch/um/kernel/tt/include/mode-tt.h      |   34 -
 arch/um/kernel/tt/ksyms.c                |   29 -
 arch/um/kernel/tt/mem.c                  |   34 -
 arch/um/kernel/tt/mem_user.c             |   49 --
 arch/um/kernel/tt/process_kern.c         |  461 ---------------------
 arch/um/kernel/tt/ptproxy/Makefile       |   10 
 arch/um/kernel/tt/ptproxy/proxy.c        |  377 -----------------
 arch/um/kernel/tt/ptproxy/ptproxy.h      |   61 --
 arch/um/kernel/tt/ptproxy/ptrace.c       |  237 ----------
 arch/um/kernel/tt/ptproxy/sysdep.c       |   70 ---
 arch/um/kernel/tt/ptproxy/sysdep.h       |   25 -
 arch/um/kernel/tt/ptproxy/wait.c         |   85 ---
 arch/um/kernel/tt/ptproxy/wait.h         |   15 
 arch/um/kernel/tt/syscall_kern.c         |   46 --
 arch/um/kernel/tt/syscall_user.c         |   60 --
 arch/um/kernel/tt/tlb.c                  |  120 -----
 arch/um/kernel/tt/tracer.c               |  461 ---------------------
 arch/um/kernel/tt/trap_user.c            |   70 ---
 arch/um/kernel/tt/uaccess.c              |   73 ---
 arch/um/kernel/tt/uaccess_user.c         |  105 ----
 arch/um/kernel/um_arch.c                 |  113 -----
 arch/um/kernel/uml.lds.S                 |    7 
 arch/um/os-Linux/Makefile                |    7 
 arch/um/os-Linux/main.c                  |   32 -
 arch/um/os-Linux/process.c               |   31 -
 arch/um/os-Linux/start_up.c              |   10 
 arch/um/os-Linux/sys-i386/Makefile       |    2 
 arch/um/os-Linux/sys-x86_64/Makefile     |    2 
 arch/um/os-Linux/time.c                  |   19 
 arch/um/os-Linux/tls.c                   |   36 -
 arch/um/scripts/Makefile.rules           |    2 
 arch/um/sys-i386/Makefile                |   10 
 arch/um/sys-i386/ldt.c                   |   67 ---
 arch/um/sys-i386/ptrace.c                |  120 -----
 arch/um/sys-i386/ptrace_user.c           |   86 ---
 arch/um/sys-i386/signal.c                |   58 --
 arch/um/sys-i386/tls.c                   |   16 
 arch/um/sys-i386/unmap.c                 |   25 -
 arch/um/sys-x86_64/Makefile              |    9 
 arch/um/sys-x86_64/signal.c              |   50 --
 arch/um/sys-x86_64/syscalls.c            |   31 -
 arch/um/sys-x86_64/unmap.c               |   25 -
 include/asm-um/mmu_context.h             |    6 
 include/asm-um/processor-generic.h       |   14 
 87 files changed, 35 insertions(+), 4204 deletions(-)

diff -puN arch/um/Kconfig~uml-throw-out-config_mode_tt arch/um/Kconfig
--- a/arch/um/Kconfig~uml-throw-out-config_mode_tt
+++ a/arch/um/Kconfig
@@ -62,55 +62,16 @@ config IRQ_RELEASE_METHOD
 
 menu "UML-specific options"
 
-config MODE_TT
-	bool "Tracing thread support (DEPRECATED)"
-	default n
-	depends on BROKEN
-	help
-	This option controls whether tracing thread support is compiled
-	into UML. This option is largely obsolete, given that skas0 provides
-	skas security and performance without needing to patch the host.
-	It is safe to say 'N' here; saying 'Y' may cause additional problems
-	with the resulting binary even if you run UML in SKAS mode, and running
-	in TT mode is strongly *NOT RECOMMENDED*.
-
 config STATIC_LINK
 	bool "Force a static link"
 	default n
-	depends on !MODE_TT
 	help
-	If CONFIG_MODE_TT is disabled, then this option gives you the ability
-	to force a static link of UML.  Normally, if only skas mode is built
-	in to UML, it will be linked as a shared binary.  This is inconvenient
-	for use in a chroot jail.  So, if you intend to run UML inside a
-	chroot, and you disable CONFIG_MODE_TT, you probably want to say Y
-	here.
+	This option gives you the ability to force a static link of UML.
+	Normally, UML is linked as a shared binary.  This is inconvenient for
+	use in a chroot jail.  So, if you intend to run UML inside a chroot,
+	you probably want to say Y here.
 	Additionally, this option enables using higher memory spaces (up to
-	2.75G) for UML - disabling CONFIG_MODE_TT and enabling this option leads
-	to best results for this.
-
-config KERNEL_HALF_GIGS
-	int "Kernel address space size (in .5G units)"
-	default "1"
-	depends on MODE_TT
-	help
-        This determines the amount of address space that UML will allocate for
-        its own, measured in half Gigabyte units.  The default is 1.
-        Change this only if you need to boot UML with an unusually large amount
-        of physical memory.
-
-config MODE_SKAS
-	bool "Separate Kernel Address Space support" if MODE_TT
-	default y
-	help
-	This option controls whether skas (separate kernel address space)
-	support is compiled in.
-	Unless you have specific needs to use TT mode (which applies almost only
-	to developers), you should say Y here.
-	SKAS mode will make use of the SKAS3 patch if it is applied on the host
-	(and your UML will run in SKAS3 mode), but if no SKAS patch is applied
-	on the host it will run in SKAS0 mode, which is anyway faster than TT
-	mode.
+	2.75G) for UML.
 
 source "arch/um/Kconfig.arch"
 source "mm/Kconfig"
@@ -118,7 +79,7 @@ source "mm/Kconfig"
 config LD_SCRIPT_STATIC
 	bool
 	default y
-	depends on MODE_TT || STATIC_LINK
+	depends on STATIC_LINK
 
 config LD_SCRIPT_DYN
 	bool
@@ -220,7 +181,7 @@ config SMP
 	bool "Symmetric multi-processing support (EXPERIMENTAL)"
 	default n
 	#SMP_BROKEN is for x86_64.
-	depends on MODE_TT && EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
+	depends on EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
 	help
 	This option enables UML SMP support.
 	It is NOT related to having a real SMP box. Not directly, at least.
@@ -258,11 +219,6 @@ config NEST_LEVEL
         inside another UML, set CONFIG_NEST_LEVEL to one more than the host
         UML.
 
-        Note that if the hosting UML has its CONFIG_KERNEL_HALF_GIGS set to
-        greater than one, then the guest UML should have its CONFIG_NEST_LEVEL
-        set to the host's CONFIG_NEST_LEVEL + CONFIG_KERNEL_HALF_GIGS.
-        Only change this if you are running nested UMLs.
-
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
 	depends on !64BIT && EXPERIMENTAL
@@ -271,9 +227,9 @@ config HIGHMEM
 	This was used to allow UML to run with big amounts of memory.
 	Currently it is unstable, so if unsure say N.
 
-	To use big amounts of memory, it is recommended to disable TT mode (i.e.
-	CONFIG_MODE_TT) and enable static linking (i.e. CONFIG_STATIC_LINK) -
-	this should allow the guest to use up to 2.75G of memory.
+	To use big amounts of memory, it is recommended enable static
+	linking (i.e. CONFIG_STATIC_LINK) - this should allow the
+	guest to use up to 2.75G of memory.
 
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
diff -puN arch/um/Kconfig.char~uml-throw-out-config_mode_tt arch/um/Kconfig.char
--- a/arch/um/Kconfig.char~uml-throw-out-config_mode_tt
+++ a/arch/um/Kconfig.char
@@ -65,8 +65,6 @@ config XTERM_CHAN
         This option enables support for attaching UML consoles and serial
         lines to xterms.  Each UML device so assigned will be brought up in
         its own xterm.
-        If you disable this option, then CONFIG_PT_PROXY will be disabled as
-        well, since UML's gdb currently requires an xterm.
         It is safe to say 'Y' here.
 
 config NOCONFIG_CHAN
diff -puN arch/um/Kconfig.debug~uml-throw-out-config_mode_tt arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-throw-out-config_mode_tt
+++ a/arch/um/Kconfig.debug
@@ -2,28 +2,9 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config CMDLINE_ON_HOST
-	bool "Show command line arguments on the host in TT mode"
-	depends on MODE_TT
-	default !DEBUG_INFO
-	help
-	This controls whether arguments in guest processes should be shown on
-	the host's ps output.
-	Enabling this option hinders debugging on some recent GDB versions
-	(because GDB gets "confused" when we do an execvp()). So probably you
-	should disable it.
-
-config PT_PROXY
-	bool "Enable ptrace proxy"
-	depends on XTERM_CHAN && DEBUG_INFO && MODE_TT
-	help
-	This option enables a debugging interface which allows gdb to debug
-	the kernel without needing to actually attach to kernel threads.
-	If you want to do kernel debugging, say Y here; otherwise say N.
-
 config GPROF
 	bool "Enable gprof support"
-	depends on DEBUG_INFO && MODE_SKAS && !MODE_TT
+	depends on DEBUG_INFO
 	help
         This allows profiling of a User-Mode Linux kernel with the gprof
         utility.
@@ -36,7 +17,7 @@ config GPROF
 
 config GCOV
 	bool "Enable gcov support"
-	depends on DEBUG_INFO && MODE_SKAS
+	depends on DEBUG_INFO
 	help
         This option allows developers to retrieve coverage data from a UML
         session.
diff -puN arch/um/Makefile~uml-throw-out-config_mode_tt arch/um/Makefile
--- a/arch/um/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/Makefile
@@ -31,18 +31,9 @@ SYMLINK_HEADERS := $(foreach header,$(SY
 ARCH_SYMLINKS = include/asm-um/arch $(ARCH_DIR)/include/sysdep $(ARCH_DIR)/os \
 	$(SYMLINK_HEADERS) $(ARCH_DIR)/include/uml-config.h
 
-um-modes-$(CONFIG_MODE_TT) += tt
-um-modes-$(CONFIG_MODE_SKAS) += skas
+MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/skas
 
-MODE_INCLUDE	+= $(foreach mode,$(um-modes-y),\
-		   -I$(srctree)/$(ARCH_DIR)/include/$(mode))
-
-MAKEFILES-INCL	+= $(foreach mode,$(um-modes-y),\
-		   $(srctree)/$(ARCH_DIR)/Makefile-$(mode))
-
-ifneq ($(MAKEFILES-INCL),)
-  include $(MAKEFILES-INCL)
-endif
+include $(srctree)/$(ARCH_DIR)/Makefile-skas
 
 ARCH_INCLUDE	:= -I$(ARCH_DIR)/include
 ifneq ($(KBUILD_SRC),)
@@ -59,7 +50,7 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 # These apply to USER_CFLAGS to.
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
-	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
+	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap \
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any
 
@@ -89,9 +80,8 @@ CFLAGS += $(call cc-option,-fno-unit-at-
 # included; the values here are meaningless
 
 CONFIG_NEST_LEVEL ?= 0
-CONFIG_KERNEL_HALF_GIGS ?= 0
 
-SIZE = (($(CONFIG_NEST_LEVEL) + $(CONFIG_KERNEL_HALF_GIGS)) * 0x20000000)
+SIZE = ($(CONFIG_NEST_LEVEL) * 0x20000000)
 
 PHONY += linux
 
@@ -124,7 +114,6 @@ CFLAGS_NO_HARDENING := $(call cc-option,
 	$(call cc-option, -fno-stack-protector,) \
 	$(call cc-option, -fno-stack-protector-all,)
 
-CPP_MODE-$(CONFIG_MODE_TT) := -DMODE_TT
 CONFIG_KERNEL_STACK_ORDER ?= 2
 STACK_SIZE := $(shell echo $$[ 4096 * (1 << $(CONFIG_KERNEL_STACK_ORDER)) ] )
 
@@ -132,11 +121,8 @@ ifndef START
   START = $(shell echo $$[ $(TOP_ADDR) - $(SIZE) ] )
 endif
 
-CPPFLAGS_vmlinux.lds = -U$(SUBARCH) \
-	-DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
-	-DELF_FORMAT="$(ELF_FORMAT)" $(CPP_MODE-y) \
-	-DKERNEL_STACK_SIZE=$(STACK_SIZE) \
-	-DUNMAP_PATH=arch/um/sys-$(SUBARCH)/unmap.o
+CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
+	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
 
 #The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
diff -puN arch/um/Makefile-i386~uml-throw-out-config_mode_tt arch/um/Makefile-i386
--- a/arch/um/Makefile-i386~uml-throw-out-config_mode_tt
+++ a/arch/um/Makefile-i386
@@ -2,11 +2,7 @@ core-y += arch/um/sys-i386/ arch/i386/cr
 
 TOP_ADDR := $(CONFIG_TOP_ADDR)
 
-ifeq ($(CONFIG_MODE_SKAS),y)
-  ifneq ($(CONFIG_MODE_TT),y)
-     START := 0x8048000
-  endif
-endif
+START := 0x8048000
 
 LDFLAGS			+= -m elf_i386
 ELF_ARCH		:= $(SUBARCH)
diff -puN arch/um/defconfig~uml-throw-out-config_mode_tt arch/um/defconfig
--- a/arch/um/defconfig~uml-throw-out-config_mode_tt
+++ a/arch/um/defconfig
@@ -12,9 +12,7 @@ CONFIG_IRQ_RELEASE_METHOD=y
 #
 # UML-specific options
 #
-# CONFIG_MODE_TT is not set
 # CONFIG_STATIC_LINK is not set
-CONFIG_MODE_SKAS=y
 
 #
 # Host processor type and features
diff -puN arch/um/drivers/mconsole_kern.c~uml-throw-out-config_mode_tt arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-throw-out-config_mode_tt
+++ a/arch/um/drivers/mconsole_kern.c
@@ -735,8 +735,6 @@ void mconsole_sysrq(struct mc_request *r
 }
 #endif
 
-#ifdef CONFIG_MODE_SKAS
-
 static void stack_proc(void *arg)
 {
 	struct task_struct *from = current, *to = arg;
@@ -750,7 +748,7 @@ static void stack_proc(void *arg)
  *  Dumps a stacks registers to the linux console.
  *  Usage stack <pid>.
  */
-static void do_stack_trace(struct mc_request *req)
+void mconsole_stack(struct mc_request *req)
 {
 	char *ptr = req->request.data;
 	int pid_requested= -1;
@@ -781,17 +779,6 @@ static void do_stack_trace(struct mc_req
 	}
 	with_console(req, stack_proc, to);
 }
-#endif /* CONFIG_MODE_SKAS */
-
-void mconsole_stack(struct mc_request *req)
-{
-	/* This command doesn't work in TT mode, so let's check and then
-	 * get out of here
-	 */
-	CHOOSE_MODE(mconsole_reply(req, "Sorry, this doesn't work in TT mode",
-				   1, 0),
-		    do_stack_trace(req));
-}
 
 /* Changed by mconsole_setup, which is __setup, and called before SMP is
  * active.
diff -puN arch/um/include/as-layout.h~uml-throw-out-config_mode_tt arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/as-layout.h
@@ -28,7 +28,6 @@ extern unsigned long _unprotected_end;
 extern unsigned long brk_start;
 
 extern int linux_main(int argc, char **argv);
-extern void set_cmdline(char *cmd);
 
 extern void (*sig_info[])(int, union uml_pt_regs *);
 
diff -puN arch/um/include/choose-mode.h~uml-throw-out-config_mode_tt arch/um/include/choose-mode.h
--- a/arch/um/include/choose-mode.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/choose-mode.h
@@ -8,26 +8,8 @@
 
 #include "uml-config.h"
 
-#if defined(UML_CONFIG_MODE_TT) && defined(UML_CONFIG_MODE_SKAS)
-#define CHOOSE_MODE(tt, skas) (mode_tt ? (tt) : (skas))
-
-extern int mode_tt;
-static inline void *__choose_mode(void *tt, void *skas) {
-	return mode_tt ? tt : skas;
-}
-
-#define __CHOOSE_MODE(tt, skas) (*( (typeof(tt) *) __choose_mode(&(tt), &(skas))))
-
-#elif defined(UML_CONFIG_MODE_SKAS)
 #define CHOOSE_MODE(tt, skas) (skas)
 
-#elif defined(UML_CONFIG_MODE_TT)
-#define CHOOSE_MODE(tt, skas) (tt)
-
-#else
-#error CONFIG_MODE_SKAS and CONFIG_MODE_TT are both disabled
-#endif
-
 #define CHOOSE_MODE_PROC(tt, skas, args...) \
 	CHOOSE_MODE(tt(args), skas(args))
 
diff -puN arch/um/include/common-offsets.h~uml-throw-out-config_mode_tt arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/common-offsets.h
@@ -1,9 +1,6 @@
 /* for use by sys-$SUBARCH/kernel-offsets.c */
 
 DEFINE(KERNEL_MADV_REMOVE, MADV_REMOVE);
-#ifdef CONFIG_MODE_TT
-OFFSET(HOST_TASK_EXTERN_PID, task_struct, thread.mode.tt.extern_pid);
-#endif
 
 OFFSET(HOST_TASK_REGS, task_struct, thread.regs);
 OFFSET(HOST_TASK_PID, task_struct, pid);
diff -puN arch/um/include/irq_user.h~uml-throw-out-config_mode_tt arch/um/include/irq_user.h
--- a/arch/um/include/irq_user.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/irq_user.h
@@ -30,8 +30,4 @@ extern void deactivate_fd(int fd, int ir
 extern int deactivate_all_fds(void);
 extern int activate_ipi(int fd, int pid);
 
-#ifdef CONFIG_MODE_TT
-extern void forward_interrupts(int pid);
-#endif
-
 #endif
diff -puN arch/um/include/kern_util.h~uml-throw-out-config_mode_tt arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/kern_util.h
@@ -34,9 +34,6 @@ extern int nsyscalls;
 	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
 
 extern int kernel_fork(unsigned long flags, int (*fn)(void *), void * arg);
-#ifdef UML_CONFIG_MODE_TT
-extern unsigned long stack_sp(unsigned long page);
-#endif
 extern int kernel_thread_proc(void *data);
 extern void syscall_segv(int sig);
 extern int current_pid(void);
@@ -82,9 +79,6 @@ extern void check_stack_overflow(void *p
 extern void relay_signal(int sig, union uml_pt_regs *regs);
 extern int user_context(unsigned long sp);
 extern void timer_irq(union uml_pt_regs *regs);
-#ifdef CONFIG_MODE_TT
-extern void unprotect_stack(unsigned long stack);
-#endif
 extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
diff -puN arch/um/include/mode.h~uml-throw-out-config_mode_tt arch/um/include/mode.h
--- a/arch/um/include/mode.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/mode.h
@@ -6,25 +6,6 @@
 #ifndef __MODE_H__
 #define __MODE_H__
 
-#include "uml-config.h"
-
-#ifdef UML_CONFIG_MODE_TT
-#include "mode-tt.h"
-#endif
-
-#ifdef UML_CONFIG_MODE_SKAS
 #include "mode-skas.h"
-#endif
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/mode_kern.h~uml-throw-out-config_mode_tt arch/um/include/mode_kern.h
--- a/arch/um/include/mode_kern.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/mode_kern.h
@@ -6,12 +6,6 @@
 #ifndef __MODE_KERN_H__
 #define __MODE_KERN_H__
 
-#ifdef CONFIG_MODE_TT
-#include "mode_kern_tt.h"
-#endif
-
-#ifdef CONFIG_MODE_SKAS
 #include "mode_kern_skas.h"
-#endif
 
 #endif
diff -puN arch/um/include/os.h~uml-throw-out-config_mode_tt arch/um/include/os.h
--- a/arch/um/include/os.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/os.h
@@ -178,11 +178,7 @@ extern void check_host_supports_tls(int 
 
 /* Make sure they are clear when running in TT mode. Required by
  * SEGV_MAYBE_FIXABLE */
-#ifdef UML_CONFIG_MODE_SKAS
 #define clear_can_do_skas() do { ptrace_faultinfo = proc_mm = 0; } while (0)
-#else
-#define clear_can_do_skas() do {} while (0)
-#endif
 
 /* mem.c */
 extern int create_mem_file(unsigned long long len);
@@ -193,18 +189,11 @@ extern int os_process_parent(int pid);
 extern void os_stop_process(int pid);
 extern void os_kill_process(int pid, int reap_child);
 extern void os_kill_ptraced_process(int pid, int reap_child);
-#ifdef UML_CONFIG_MODE_TT
-extern void os_usr1_process(int pid);
-#endif
 extern long os_ptrace_ldt(long pid, long addr, long data);
 
 extern int os_getpid(void);
 extern int os_getpgrp(void);
 
-#ifdef UML_CONFIG_MODE_TT
-extern void init_new_thread_stack(void *sig_stack, void (*usr1_handler)(int));
-extern void stop(void);
-#endif
 extern void init_new_thread_signals(void);
 extern int run_kernel_thread(int (*fn)(void *), void *arg, void **jmp_ptr);
 
@@ -217,18 +206,6 @@ extern int os_drop_memory(void *addr, in
 extern int can_drop_memory(void);
 extern void os_flush_stdout(void);
 
-/* tt.c
- * for tt mode only (will be deleted in future...)
- */
-extern void forward_ipi(int fd, int pid);
-extern void kill_child_dead(int pid);
-extern int wait_for_stop(int pid, int sig, int cont_type, void *relay);
-extern int protect_memory(unsigned long addr, unsigned long len,
-			  int r, int w, int x, int must_succeed);
-extern void forward_pending_sigio(int target);
-extern int start_fork_tramp(void *arg, unsigned long temp_stack,
-			    int clone_flags, int (*tramp)(void *));
-
 /* uaccess.c */
 extern unsigned long __do_user_copy(void *to, const void *from, int n,
 				    void **fault_addr, void **fault_catcher,
@@ -281,9 +258,6 @@ extern void os_dump_core(void);
 extern void switch_timers(int to_real);
 extern void idle_sleep(int secs);
 extern int set_interval(int is_virtual);
-#ifdef CONFIG_MODE_TT
-extern void enable_timer(void);
-#endif
 extern void disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-throw-out-config_mode_tt arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -14,12 +14,7 @@
 #define MAX_REG_NR (UM_FRAME_SIZE / sizeof(unsigned long))
 #define MAX_REG_OFFSET (UM_FRAME_SIZE)
 
-#ifdef UML_CONFIG_PT_PROXY
-extern void update_debugregs(int seq);
-#else
 static inline void update_debugregs(int seq) {}
-#endif
-
 
 /* syscall emulation path in ptrace */
 
@@ -31,12 +26,6 @@ void set_using_sysemu(int value);
 int get_using_sysemu(void);
 extern int sysemu_supported;
 
-#ifdef UML_CONFIG_MODE_TT
-#include "sysdep/sc.h"
-#endif
-
-#ifdef UML_CONFIG_MODE_SKAS
-
 #include "skas_ptregs.h"
 
 #define REGS_IP(r) ((r)[HOST_IP])
@@ -60,20 +49,11 @@ extern int sysemu_supported;
 
 #define REGS_RESTART_SYSCALL(r) IP_RESTART_SYSCALL(REGS_IP(r))
 
-#endif
 #ifndef PTRACE_SYSEMU_SINGLESTEP
 #define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
 union uml_pt_regs {
-#ifdef UML_CONFIG_MODE_TT
-	struct tt_regs {
-		long syscall;
-		void *sc;
-                struct faultinfo faultinfo;
-	} tt;
-#endif
-#ifdef UML_CONFIG_MODE_SKAS
 	struct skas_regs {
 		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
@@ -82,13 +62,10 @@ union uml_pt_regs {
 		long syscall;
 		int is_user;
 	} skas;
-#endif
 };
 
 #define EMPTY_UML_PT_REGS { }
 
-extern int mode_tt;
-
 #define UPT_SC(r) ((r)->tt.sc)
 #define UPT_IP(r) \
 	__CHOOSE_MODE(SC_IP(UPT_SC(r)), REGS_IP((r)->skas.regs))
diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-throw-out-config_mode_tt arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -30,11 +30,7 @@
 #define SEGV_IS_FIXABLE(fi)	((fi)->trap_no == 14)
 
 /* SKAS3 has no trap_no on i386, but get_skas_faultinfo() sets it to 0. */
-#ifdef UML_CONFIG_MODE_SKAS
 #define SEGV_MAYBE_FIXABLE(fi)	((fi)->trap_no == 0 && ptrace_faultinfo)
-#else
-#define SEGV_MAYBE_FIXABLE(fi)	0
-#endif
 
 extern unsigned long *sc_sigmask(void *sc_ptr);
 extern int sc_get_fpregs(unsigned long buf, void *sc_ptr);
diff -puN arch/um/include/sysdep-i386/thread.h~uml-throw-out-config_mode_tt arch/um/include/sysdep-i386/thread.h
--- a/arch/um/include/sysdep-i386/thread.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/sysdep-i386/thread.h
@@ -4,8 +4,5 @@
 #include <kern_constants.h>
 
 #define TASK_DEBUGREGS(task) ((unsigned long *) &(((char *) (task))[HOST_TASK_DEBUGREGS]))
-#ifdef UML_CONFIG_MODE_TT
-#define TASK_EXTERN_PID(task) *((int *) &(((char *) (task))[HOST_TASK_EXTERN_PID]))
-#endif
 
 #endif
diff -puN arch/um/include/sysdep-x86_64/ptrace.h~uml-throw-out-config_mode_tt arch/um/include/sysdep-x86_64/ptrace.h
--- a/arch/um/include/sysdep-x86_64/ptrace.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/sysdep-x86_64/ptrace.h
@@ -1,5 +1,6 @@
 /*
  * Copyright 2003 PathScale, Inc.
+ * Copyright (C) 2003 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * Licensed under the GPL
  */
@@ -14,11 +15,6 @@
 #define MAX_REG_OFFSET (UM_FRAME_SIZE)
 #define MAX_REG_NR ((MAX_REG_OFFSET) / sizeof(unsigned long))
 
-#ifdef UML_CONFIG_MODE_TT
-#include "sysdep/sc.h"
-#endif
-
-#ifdef UML_CONFIG_MODE_SKAS
 #include "skas_ptregs.h"
 
 #define REGS_IP(r) ((r)[HOST_IP])
@@ -88,21 +84,10 @@
 
 #define REGS_ERR(r) ((r)->fault_type)
 
-#endif
-
 #include "choose-mode.h"
 
 /* XXX */
 union uml_pt_regs {
-#ifdef UML_CONFIG_MODE_TT
-	struct tt_regs {
-		long syscall;
-		unsigned long orig_rax;
-		void *sc;
-                struct faultinfo faultinfo;
-	} tt;
-#endif
-#ifdef UML_CONFIG_MODE_SKAS
 	struct skas_regs {
 		unsigned long regs[MAX_REG_NR];
 		unsigned long fp[HOST_FP_SIZE];
@@ -110,14 +95,10 @@ union uml_pt_regs {
 		long syscall;
 		int is_user;
 	} skas;
-#endif
 };
 
 #define EMPTY_UML_PT_REGS { }
 
-/* XXX */
-extern int mode_tt;
-
 #define UPT_RBX(r) __CHOOSE_MODE(SC_RBX(UPT_SC(r)), REGS_RBX((r)->skas.regs))
 #define UPT_RCX(r) __CHOOSE_MODE(SC_RCX(UPT_SC(r)), REGS_RCX((r)->skas.regs))
 #define UPT_RDX(r) __CHOOSE_MODE(SC_RDX(UPT_SC(r)), REGS_RDX((r)->skas.regs))
diff -puN arch/um/include/sysdep-x86_64/thread.h~uml-throw-out-config_mode_tt arch/um/include/sysdep-x86_64/thread.h
--- a/arch/um/include/sysdep-x86_64/thread.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/sysdep-x86_64/thread.h
@@ -3,8 +3,4 @@
 
 #include <kern_constants.h>
 
-#ifdef UML_CONFIG_MODE_TT
-#define TASK_EXTERN_PID(task) *((int *) &(((char *) (task))[HOST_TASK_EXTERN_PID]))
-#endif
-
 #endif
diff -puN arch/um/include/tt/debug.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/debug.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002  Jeff Dike (jdike@karaya.com) and
- * Lars Brinkhoff.
- * Licensed under the GPL
- */
-
-#ifndef __UML_TT_DEBUG_H
-#define __UML_TT_DEBUG_H
-
-extern int debugger_proxy(int status, pid_t pid);
-extern void child_proxy(pid_t pid, int status);
-extern void init_proxy (pid_t pid, int waiting, int status);
-extern int start_debugger(char *prog, int startup, int stop, int *debugger_fd);
-extern void fake_child_exit(void);
-extern int gdb_config(char *str);
-extern int gdb_remove(int unused);
-
-#endif
diff -puN arch/um/include/tt/mmu-tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/mmu-tt.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_MMU_H
-#define __TT_MMU_H
-
-struct mmu_context_tt {
-};
-
-#endif
diff -puN arch/um/include/tt/mode-tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/mode-tt.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_TT_H__
-#define __MODE_TT_H__
-
-#include "sysdep/ptrace.h"
-
-enum { OP_NONE, OP_EXEC, OP_FORK, OP_TRACE_ON, OP_REBOOT, OP_HALT, OP_CB };
-
-extern int tracing_pid;
-
-extern int tracer(int (*init_proc)(void *), void *sp);
-extern void sig_handler_common_tt(int sig, void *sc);
-extern void syscall_handler_tt(int sig, union uml_pt_regs *regs);
-extern void reboot_tt(void);
-extern void halt_tt(void);
-extern int is_tracer_winch(int pid, int fd, void *data);
-extern void kill_off_processes_tt(void);
-
-#endif
diff -puN arch/um/include/tt/mode_kern_tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/mode_kern_tt.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_MODE_KERN_H__
-#define __TT_MODE_KERN_H__
-
-#include "linux/sched.h"
-#include "asm/page.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-
-extern void switch_to_tt(void *prev, void *next);
-extern void flush_thread_tt(void);
-extern void start_thread_tt(struct pt_regs *regs, unsigned long eip,
-			   unsigned long esp);
-extern int copy_thread_tt(int nr, unsigned long clone_flags, unsigned long sp,
-			  unsigned long stack_top, struct task_struct *p,
-			  struct pt_regs *regs);
-extern void release_thread_tt(struct task_struct *task);
-extern void initial_thread_cb_tt(void (*proc)(void *), void *arg);
-extern void init_idle_tt(void);
-extern void flush_tlb_kernel_range_tt(unsigned long start, unsigned long end);
-extern void flush_tlb_kernel_vm_tt(void);
-extern void __flush_tlb_one_tt(unsigned long addr);
-extern void flush_tlb_range_tt(struct vm_area_struct *vma,
-			       unsigned long start, unsigned long end);
-extern void flush_tlb_mm_tt(struct mm_struct *mm);
-extern void force_flush_all_tt(void);
-extern long execute_syscall_tt(void *r);
-extern void before_mem_tt(unsigned long brk_start);
-extern unsigned long set_task_sizes_tt(unsigned long *task_size_out);
-extern int start_uml_tt(void);
-extern int external_pid_tt(struct task_struct *task);
-extern int thread_pid_tt(struct task_struct *task);
-
-#define kmem_end_tt (host_task_size - ABOVE_KMEM)
-
-#endif
diff -puN arch/um/include/tt/tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/tt.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_H__
-#define __TT_H__
-
-#include "sysdep/ptrace.h"
-
-extern int gdb_pid;
-extern int debug;
-extern int debug_stop;
-extern int debug_trace;
-
-extern int honeypot;
-
-extern int fork_tramp(void *sig_stack);
-extern int do_proc_op(void *t, int proc_id);
-extern int tracer(int (*init_proc)(void *), void *sp);
-extern void attach_process(int pid);
-extern void tracer_panic(char *format, ...)
-	__attribute__ ((format (printf, 1, 2)));
-extern void set_init_pid(int pid);
-extern int set_user_mode(void *task);
-extern void set_tracing(void *t, int tracing);
-extern int is_tracing(void *task);
-extern void syscall_handler(int sig, union uml_pt_regs *regs);
-extern void exit_kernel(int pid, void *task);
-extern void do_syscall(void *task, int pid, int local_using_sysemu);
-extern void do_sigtrap(void *task);
-extern int is_valid_pid(int pid);
-extern void remap_data(void *segment_start, void *segment_end, int w);
-extern long execute_syscall_tt(void *r);
-
-#endif
-
diff -puN arch/um/include/tt/uaccess-tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/include/tt/uaccess-tt.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_UACCESS_H
-#define __TT_UACCESS_H
-
-#include "linux/string.h"
-#include "linux/sched.h"
-#include "asm/processor.h"
-#include "asm/errno.h"
-#include "asm/current.h"
-#include "asm/a.out.h"
-#include "uml_uaccess.h"
-
-#define ABOVE_KMEM (16 * 1024 * 1024)
-
-extern unsigned long end_vm;
-extern unsigned long uml_physmem;
-
-#define is_stack(addr, size) \
-	(((unsigned long) (addr) < STACK_TOP) && \
-	 ((unsigned long) (addr) >= STACK_TOP - ABOVE_KMEM) && \
-	 (((unsigned long) (addr) + (size)) <= STACK_TOP))
-
-#define access_ok_tt(type, addr, size) \
-	(is_stack(addr, size))
-
-extern int __do_copy_from_user(void *to, const void *from, int n,
-			       void **fault_addr, void **fault_catcher);
-extern int __do_strncpy_from_user(char *dst, const char *src, size_t n,
-				  void **fault_addr, void **fault_catcher);
-extern int __do_clear_user(void *mem, size_t len, void **fault_addr,
-			   void **fault_catcher);
-extern int __do_strnlen_user(const char *str, unsigned long n,
-			     void **fault_addr, void **fault_catcher);
-
-extern int copy_from_user_tt(void *to, const void __user *from, int n);
-extern int copy_to_user_tt(void __user *to, const void *from, int n);
-extern int strncpy_from_user_tt(char *dst, const char __user *src, int count);
-extern int __clear_user_tt(void __user *mem, int len);
-extern int clear_user_tt(void __user *mem, int len);
-extern int strnlen_user_tt(const void __user *str, int len);
-
-#endif
diff -puN arch/um/include/um_mmu.h~uml-throw-out-config_mode_tt arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/um_mmu.h
@@ -8,33 +8,10 @@
 
 #include "uml-config.h"
 #include "choose-mode.h"
-
-#ifdef UML_CONFIG_MODE_TT
-#include "mmu-tt.h"
-#endif
-
-#ifdef UML_CONFIG_MODE_SKAS
 #include "mmu-skas.h"
-#endif
 
 typedef union mm_context {
-#ifdef UML_CONFIG_MODE_TT
-	struct mmu_context_tt tt;
-#endif
-#ifdef UML_CONFIG_MODE_SKAS
 	struct mmu_context_skas skas;
-#endif
 } mm_context_t;
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/um_uaccess.h~uml-throw-out-config_mode_tt arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-throw-out-config_mode_tt
+++ a/arch/um/include/um_uaccess.h
@@ -7,15 +7,7 @@
 #define __ARCH_UM_UACCESS_H
 
 #include "choose-mode.h"
-
-#ifdef CONFIG_MODE_TT
-#include "uaccess-tt.h"
-#endif
-
-#ifdef CONFIG_MODE_SKAS
 #include "uaccess-skas.h"
-#endif
-
 #include "asm/fixmap.h"
 
 #define __under_task_size(addr, size) \
diff -puN arch/um/kernel/Makefile~uml-throw-out-config_mode_tt arch/um/kernel/Makefile
--- a/arch/um/kernel/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/Makefile
@@ -9,15 +9,12 @@ clean-files :=
 obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o uaccess.o \
-	um_arch.o umid.o
+	um_arch.o umid.o skas/
 
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
 obj-$(CONFIG_GPROF)	+= gprof_syms.o
 obj-$(CONFIG_GCOV)	+= gmon_syms.o
 
-obj-$(CONFIG_MODE_TT) += tt/
-obj-$(CONFIG_MODE_SKAS) += skas/
-
 USER_OBJS := config.o
 
 include arch/um/scripts/Makefile.rules
diff -puN arch/um/kernel/dyn.lds.S~uml-throw-out-config_mode_tt arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/dyn.lds.S
@@ -10,8 +10,6 @@ SECTIONS
   PROVIDE (__executable_start = START);
   . = START + SIZEOF_HEADERS;
   .interp         : { *(.interp) }
-  /* Used in arch/um/kernel/mem.c. Any memory between START and __binary_start
-   * is remapped.*/
   __binary_start = .;
   . = ALIGN(4096);		/* Init code and data */
   _text = .;
diff -puN arch/um/kernel/exec.c~uml-throw-out-config_mode_tt arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/exec.c
@@ -57,7 +57,6 @@ static long execve1(char *file, char __u
 		SUBARCH_EXECVE1(&current->thread.regs.regs);
 #endif
 		task_unlock(current);
-                set_cmdline(current_cmd());
         }
         return(error);
 }
diff -puN arch/um/kernel/init_task.c~uml-throw-out-config_mode_tt arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/init_task.c
@@ -46,10 +46,3 @@ union thread_union init_thread_union
 union thread_union cpu0_irqstack
 	__attribute__((__section__(".data.init_irqstack"))) =
 		{ INIT_THREAD_INFO(init_task) };
-
-#ifdef CONFIG_MODE_TT
-void unprotect_stack(unsigned long stack)
-{
-	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
-}
-#endif
diff -puN arch/um/kernel/irq.c~uml-throw-out-config_mode_tt arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/irq.c
@@ -339,30 +339,6 @@ int deactivate_all_fds(void)
 	return 0;
 }
 
-#ifdef CONFIG_MODE_TT
-void forward_interrupts(int pid)
-{
-	struct irq_fd *irq;
-	unsigned long flags;
-	int err;
-
-	spin_lock_irqsave(&irq_lock, flags);
-	for (irq = active_fds; irq != NULL; irq = irq->next) {
-		err = os_set_owner(irq->fd, pid);
-		if (err < 0) {
-			/* XXX Just remove the irq rather than
-			 * print out an infinite stream of these
-			 */
-			printk("Failed to forward %d to pid %d, err = %d\n",
-			       irq->fd, pid, -err);
-		}
-
-		irq->pid = pid;
-	}
-	spin_unlock_irqrestore(&irq_lock, flags);
-}
-#endif
-
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
diff -puN arch/um/kernel/ksyms.c~uml-throw-out-config_mode_tt arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/ksyms.c
@@ -34,24 +34,14 @@ EXPORT_SYMBOL(get_kmem_end);
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(um_virt_to_phys);
-EXPORT_SYMBOL(mode_tt);
 EXPORT_SYMBOL(handle_page_fault);
 EXPORT_SYMBOL(find_iomem);
 
-#ifdef CONFIG_MODE_TT
-EXPORT_SYMBOL(stop);
-EXPORT_SYMBOL(strncpy_from_user_tt);
-EXPORT_SYMBOL(copy_from_user_tt);
-EXPORT_SYMBOL(copy_to_user_tt);
-#endif
-
-#ifdef CONFIG_MODE_SKAS
 EXPORT_SYMBOL(strnlen_user_skas);
 EXPORT_SYMBOL(strncpy_from_user_skas);
 EXPORT_SYMBOL(copy_to_user_skas);
 EXPORT_SYMBOL(copy_from_user_skas);
 EXPORT_SYMBOL(clear_user_skas);
-#endif
 EXPORT_SYMBOL(uml_strdup);
 
 EXPORT_SYMBOL(os_stat_fd);
diff -puN arch/um/kernel/process.c~uml-throw-out-config_mode_tt arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/process.c
@@ -183,13 +183,6 @@ void initial_thread_cb(void (*proc)(void
 	kmalloc_ok = save_kmalloc_ok;
 }
 
-#ifdef CONFIG_MODE_TT
-unsigned long stack_sp(unsigned long page)
-{
-	return page + PAGE_SIZE - sizeof(void *);
-}
-#endif
-
 void default_idle(void)
 {
 	CHOOSE_MODE(uml_idle_timer(), (void) 0);
diff -puN arch/um/kernel/reboot.c~uml-throw-out-config_mode_tt arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/reboot.c
@@ -14,28 +14,9 @@
 
 void (*pm_power_off)(void);
 
-#ifdef CONFIG_SMP
-static void kill_idlers(int me)
-{
-#ifdef CONFIG_MODE_TT
-	struct task_struct *p;
-	int i;
-
-	for(i = 0; i < ARRAY_SIZE(idle_threads); i++){
-		p = idle_threads[i];
-		if((p != NULL) && (p->thread.mode.tt.extern_pid != me))
-			os_kill_process(p->thread.mode.tt.extern_pid, 0);
-	}
-#endif
-}
-#endif
-
 static void kill_off_processes(void)
 {
 	CHOOSE_MODE(kill_off_processes_tt(), kill_off_processes_skas());
-#ifdef CONFIG_SMP
-	kill_idlers(os_getpid());
-#endif
 }
 
 void uml_cleanup(void)
diff -puN arch/um/kernel/smp.c~uml-throw-out-config_mode_tt arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/smp.c
@@ -95,7 +95,6 @@ static int idle_proc(void *cpup)
 static struct task_struct *idle_thread(int cpu)
 {
 	struct task_struct *new_task;
-	unsigned char c;
 
 	current->thread.request.u.thread.proc = idle_proc;
 	current->thread.request.u.thread.arg = (void *) cpu;
@@ -108,9 +107,7 @@ static struct task_struct *idle_thread(i
 		          { .pid = 	new_task->thread.mode.tt.extern_pid,
 			    .task = 	new_task } );
 	idle_threads[cpu] = new_task;
-	CHOOSE_MODE(os_write_file(new_task->thread.mode.tt.switch_pipe[1], &c,
-				  sizeof(c)),
-		    ({ panic("skas mode doesn't support SMP"); }));
+	panic("skas mode doesn't support SMP");
 	return new_task;
 }
 
diff -puN arch/um/kernel/trap.c~uml-throw-out-config_mode_tt arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/trap.c
@@ -29,9 +29,7 @@
 #include "sysdep/sigcontext.h"
 #include "sysdep/ptrace.h"
 #include "os.h"
-#ifdef CONFIG_MODE_SKAS
 #include "skas.h"
-#endif
 #include "os.h"
 
 /* Note this is constrained to return 0, -EFAULT, -EACCESS, -ENOMEM by segv(). */
diff -puN arch/um/kernel/tt/Makefile~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/Makefile
+++ /dev/null
@@ -1,14 +0,0 @@
-# 
-# Copyright (C) 2002 - 2003 Jeff Dike (jdike@addtoit.com)
-# Licensed under the GPL
-#
-
-obj-y = exec_kern.o exec_user.o gdb.o ksyms.o mem.o mem_user.o process_kern.o \
-	syscall_kern.o syscall_user.o tlb.o tracer.o trap_user.o \
-	uaccess.o uaccess_user.o
-
-obj-$(CONFIG_PT_PROXY) += gdb_kern.o ptproxy/
-
-USER_OBJS := gdb.o tracer.o
-
-include arch/um/scripts/Makefile.rules
diff -puN arch/um/kernel/tt/exec_kern.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/exec_kern.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/kernel.h"
-#include "linux/mm.h"
-#include "asm/signal.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-#include "asm/pgalloc.h"
-#include "asm/tlbflush.h"
-#include "kern_util.h"
-#include "irq_user.h"
-#include "mem_user.h"
-#include "os.h"
-#include "tlb.h"
-#include "mode.h"
-
-static int exec_tramp(void *sig_stack)
-{
-	init_new_thread_stack(sig_stack, NULL);
-	init_new_thread_signals();
-	os_stop_process(os_getpid());
-	return(0);
-}
-
-void flush_thread_tt(void)
-{
-	unsigned long stack;
-	int new_pid;
-
-	stack = alloc_stack(0, 0);
-	if(stack == 0){
-		printk(KERN_ERR 
-		       "flush_thread : failed to allocate temporary stack\n");
-		do_exit(SIGKILL);
-	}
-		
-	new_pid = start_fork_tramp(task_stack_page(current), stack, 0, exec_tramp);
-	if(new_pid < 0){
-		printk(KERN_ERR 
-		       "flush_thread : new thread failed, errno = %d\n",
-		       -new_pid);
-		do_exit(SIGKILL);
-	}
-
-	if(current_thread->cpu == 0)
-		forward_interrupts(new_pid);
-	current->thread.request.op = OP_EXEC;
-	current->thread.request.u.exec.pid = new_pid;
-	unprotect_stack((unsigned long) current_thread);
-	os_usr1_process(os_getpid());
-	change_sig(SIGUSR1, 1);
-
-	change_sig(SIGUSR1, 0);
-	enable_timer();
-	free_page(stack);
-	protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 1, 0, 1);
-	stack_protections((unsigned long) current_thread);
-	force_flush_all();
-	unblock_signals();
-}
-
-void start_thread_tt(struct pt_regs *regs, unsigned long eip, 
-		     unsigned long esp)
-{
-	set_fs(USER_DS);
-	flush_tlb_mm(current->mm);
-	PT_REGS_IP(regs) = eip;
-	PT_REGS_SP(regs) = esp;
-	PT_FIX_EXEC_STACK(esp);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/exec_user.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/exec_user.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdio.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <sched.h>
-#include <errno.h>
-#include <sys/wait.h>
-#include <signal.h>
-#include "kern_util.h"
-#include "user.h"
-#include "ptrace_user.h"
-#include "os.h"
-
-void do_exec(int old_pid, int new_pid)
-{
-	unsigned long regs[FRAME_SIZE];
-	int err;
-
-	if((ptrace(PTRACE_ATTACH, new_pid, 0, 0) < 0) ||
-	   (ptrace(PTRACE_CONT, new_pid, 0, 0) < 0))
-		tracer_panic("do_exec failed to attach proc - errno = %d",
-			     errno);
-
-	CATCH_EINTR(err = waitpid(new_pid, 0, WUNTRACED));
-	if (err < 0)
-		tracer_panic("do_exec failed to attach proc in waitpid - errno = %d",
-			     errno);
-
-	if(ptrace_getregs(old_pid, regs) < 0)
-		tracer_panic("do_exec failed to get registers - errno = %d",
-			     errno);
-
-	os_kill_ptraced_process(old_pid, 0);
-
-	if (ptrace(PTRACE_OLDSETOPTIONS, new_pid, 0, (void *)PTRACE_O_TRACESYSGOOD) < 0)
-		tracer_panic("do_exec: PTRACE_SETOPTIONS failed, errno = %d", errno);
-
-	if(ptrace_setregs(new_pid, regs) < 0)
-		tracer_panic("do_exec failed to start new proc - errno = %d",
-			     errno);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/gdb.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/gdb.c
+++ /dev/null
@@ -1,280 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <errno.h>
-#include <string.h>
-#include <signal.h>
-#include <sys/types.h>
-#include "ptrace_user.h"
-#include "uml-config.h"
-#include "kern_constants.h"
-#include "chan_user.h"
-#include "init.h"
-#include "user.h"
-#include "debug.h"
-#include "kern_util.h"
-#include "tt.h"
-#include "sysdep/thread.h"
-#include "os.h"
-
-extern int debugger_pid;
-extern int debugger_fd;
-extern int debugger_parent;
-
-int detach(int pid, int sig)
-{
-	return(ptrace(PTRACE_DETACH, pid, 0, sig));
-}
-
-int attach(int pid)
-{
-	int err;
-
-	err = ptrace(PTRACE_ATTACH, pid, 0, 0);
-	if(err < 0) return(-errno);
-	else return(err);
-}
-
-int cont(int pid)
-{
-	return(ptrace(PTRACE_CONT, pid, 0, 0));
-}
-
-#ifdef UML_CONFIG_PT_PROXY
-
-int debugger_signal(int status, pid_t pid)
-{
-	return(debugger_proxy(status, pid));
-}
-
-void child_signal(pid_t pid, int status)
-{
-	child_proxy(pid, status);
-}
-
-static void gdb_announce(char *dev_name, int dev)
-{
-	printf("gdb assigned device '%s'\n", dev_name);
-}
-
-static struct chan_opts opts = {
-	.announce  	= gdb_announce,
-	.xterm_title 	= "UML kernel debugger",
-	.raw 		= 0,
-	.tramp_stack 	= 0,
-	.in_kernel  	= 0,
-};
-
-/* Accessed by the tracing thread, which automatically serializes access */
-static void *xterm_data;
-static int xterm_fd;
-
-extern void *xterm_init(char *, int, struct chan_opts *);
-extern int xterm_open(int, int, int, void *, char **);
-extern void xterm_close(int, void *);
-
-int open_gdb_chan(void)
-{
-	char stack[UM_KERN_PAGE_SIZE], *dummy;
-
-	opts.tramp_stack = (unsigned long) stack;
-	xterm_data = xterm_init("", 0, &opts);
-	xterm_fd = xterm_open(1, 1, 1, xterm_data, &dummy);
-	return(xterm_fd);
-}
-
-static void exit_debugger_cb(void *unused)
-{
-	if(debugger_pid != -1){
-		if(gdb_pid != -1){
-			fake_child_exit();
-			gdb_pid = -1;
-		}
-		else kill_child_dead(debugger_pid);
-		debugger_pid = -1;
-		if(debugger_parent != -1)
-			detach(debugger_parent, SIGINT);
-	}
-	if(xterm_data != NULL) xterm_close(xterm_fd, xterm_data);
-}
-
-static void exit_debugger(void)
-{
-	initial_thread_cb(exit_debugger_cb, NULL);
-}
-
-__uml_exitcall(exit_debugger);
-
-struct gdb_data {
-	char *str;
-	int err;
-};
-
-extern char *linux_prog;
-
-static void config_gdb_cb(void *arg)
-{
-	struct gdb_data *data = arg;
-	void *task;
-	int pid;
-
-	data->err = -1;
-	if(debugger_pid != -1) exit_debugger_cb(NULL);
-	if(!strncmp(data->str, "pid,", strlen("pid,"))){
-		data->str += strlen("pid,");
-		pid = strtoul(data->str, NULL, 0);
-		task = cpu_tasks[0].task;
-		debugger_pid = attach_debugger(TASK_EXTERN_PID(task), pid, 0);
-		if(debugger_pid != -1){
-			data->err = 0;
-			gdb_pid = pid;
-		}
-		return;
-	}
-	data->err = 0;
-	debugger_pid = start_debugger(linux_prog, 0, 0, &debugger_fd);
-	init_proxy(debugger_pid, 0, 0);
-}
-
-int gdb_config(char *str, char **error_out)
-{
-	struct gdb_data data;
-
-	if(*str++ != '=') return(-1);
-	data.str = str;
-	initial_thread_cb(config_gdb_cb, &data);
-	return(data.err);
-}
-
-void remove_gdb_cb(void *unused)
-{
-	exit_debugger_cb(NULL);
-}
-
-int gdb_remove(int unused, char **error_out)
-{
-	initial_thread_cb(remove_gdb_cb, NULL);
-        return 0;
-}
-
-void signal_usr1(int sig)
-{
-	if(debugger_pid != -1){
-		printf("The debugger is already running\n");
-		return;
-	}
-	debugger_pid = start_debugger(linux_prog, 0, 0, &debugger_fd);
-	init_proxy(debugger_pid, 0, 0);
-}
-
-int init_ptrace_proxy(int idle_pid, int startup, int stop)
-{
-	int pid, status;
-
-	pid = start_debugger(linux_prog, startup, stop, &debugger_fd);
-	status = wait_for_stop(idle_pid, SIGSTOP, PTRACE_CONT, NULL);
- 	if(pid < 0){
-		cont(idle_pid);
-		return(-1);
-	}
-	init_proxy(pid, 1, status);
-	return(pid);
-}
-
-int attach_debugger(int idle_pid, int pid, int stop)
-{
-	int status = 0, err;
-
-	err = attach(pid);
-	if(err < 0){
-		printf("Failed to attach pid %d, errno = %d\n", pid, -err);
-		return(-1);
-	}
-	if(stop) status = wait_for_stop(idle_pid, SIGSTOP, PTRACE_CONT, NULL);
-	init_proxy(pid, 1, status);
-	return(pid);
-}
-
-#ifdef notdef /* Put this back in when it does something useful */
-static int __init uml_gdb_init_setup(char *line, int *add)
-{
-	gdb_init = uml_strdup(line);
-	return 0;
-}
-
-__uml_setup("gdb=", uml_gdb_init_setup, 
-"gdb=<channel description>\n\n"
-);
-#endif
-
-static int __init uml_gdb_pid_setup(char *line, int *add)
-{
-	gdb_pid = strtoul(line, NULL, 0);
-	*add = 0;
-	return 0;
-}
-
-__uml_setup("gdb-pid=", uml_gdb_pid_setup, 
-"gdb-pid=<pid>\n"
-"    gdb-pid is used to attach an external debugger to UML.  This may be\n"
-"    an already-running gdb or a debugger-like process like strace.\n\n"
-);
-
-#else
-
-int debugger_signal(int status, pid_t pid){ return(0); }
-void child_signal(pid_t pid, int status){ }
-int init_ptrace_proxy(int idle_pid, int startup, int stop)
-{
-	printf("debug requested when CONFIG_PT_PROXY is off\n");
-	kill_child_dead(idle_pid);
-	exit(1);
-}
-
-void signal_usr1(int sig)
-{
-	printf("debug requested when CONFIG_PT_PROXY is off\n");
-}
-
-int attach_debugger(int idle_pid, int pid, int stop)
-{
-	printf("attach_debugger called when CONFIG_PT_PROXY "
-	       "is off\n");
-	return(-1);
-}
-
-int config_gdb(char *str)
-{
-	return(-1);
-}
-
-int remove_gdb(void)
-{
-	return(-1);
-}
-
-int init_parent_proxy(int pid)
-{
-	return(-1);
-}
-
-void debugger_parent_signal(int status, int pid)
-{
-}
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/gdb_kern.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/gdb_kern.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/init.h"
-#include "mconsole_kern.h"
-
-#ifdef CONFIG_MCONSOLE
-
-extern int gdb_config(char *str, char **error_out);
-extern int gdb_remove(int n, char **error_out);
-
-static struct mc_device gdb_mc = {
-	.list		= INIT_LIST_HEAD(gdb_mc.list),
-	.name		= "gdb",
-	.config		= gdb_config,
-	.remove		= gdb_remove,
-};
-
-int gdb_mc_init(void)
-{
-	mconsole_register_dev(&gdb_mc);
-	return(0);
-}
-
-__initcall(gdb_mc_init);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/include/mode-tt.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/include/mode-tt.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_TT_H__
-#define __MODE_TT_H__
-
-#include "sysdep/ptrace.h"
-
-enum { OP_NONE, OP_EXEC, OP_FORK, OP_TRACE_ON, OP_REBOOT, OP_HALT, OP_CB };
-
-extern int tracing_pid;
-
-extern int tracer(int (*init_proc)(void *), void *sp);
-extern void sig_handler_common_tt(int sig, void *sc);
-extern void syscall_handler_tt(int sig, union uml_pt_regs *regs);
-extern void reboot_tt(void);
-extern void halt_tt(void);
-extern int is_tracer_winch(int pid, int fd, void *data);
-extern void kill_off_processes_tt(void);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ksyms.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ksyms.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/module.h"
-#include "asm/uaccess.h"
-#include "mode.h"
-
-EXPORT_SYMBOL(__do_copy_from_user);
-EXPORT_SYMBOL(__do_copy_to_user);
-EXPORT_SYMBOL(__do_strncpy_from_user);
-EXPORT_SYMBOL(__do_strnlen_user); 
-EXPORT_SYMBOL(__do_clear_user);
-EXPORT_SYMBOL(clear_user_tt);
-
-EXPORT_SYMBOL(tracing_pid);
-EXPORT_SYMBOL(honeypot);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/mem.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/mem.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/stddef.h"
-#include "linux/mm.h"
-#include "asm/uaccess.h"
-#include "mem_user.h"
-#include "kern_util.h"
-#include "kern.h"
-#include "tt.h"
-
-void before_mem_tt(unsigned long brk_start)
-{
-	if(debug)
-		remap_data(UML_ROUND_DOWN(&_stext), UML_ROUND_UP(&_etext), 1);
-	remap_data(UML_ROUND_DOWN(&_sdata), UML_ROUND_UP(&_edata), 1);
-	remap_data(UML_ROUND_DOWN(&__bss_start), UML_ROUND_UP(&_end), 1);
-}
-
-#define SIZE ((CONFIG_NEST_LEVEL + CONFIG_KERNEL_HALF_GIGS) * 0x20000000)
-#define START (CONFIG_TOP_ADDR - SIZE)
-
-unsigned long set_task_sizes_tt(unsigned long *task_size_out)
-{
-	unsigned long host_task_size;
-
-	/* Round up to the nearest 4M */
-	host_task_size = ROUND_4M((unsigned long) &host_task_size);
-	*task_size_out = START;
-
-	return host_task_size;
-}
diff -puN arch/um/kernel/tt/mem_user.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/mem_user.c
+++ /dev/null
@@ -1,49 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <string.h>
-#include <errno.h>
-#include <sys/mman.h>
-#include "tt.h"
-#include "mem_user.h"
-#include "os.h"
-
-void remap_data(void *segment_start, void *segment_end, int w)
-{
-	void *addr;
-	unsigned long size;
-	int data, prot;
-
-	if(w) prot = PROT_WRITE;
-	else prot = 0;
-	prot |= PROT_READ | PROT_EXEC;
-	size = (unsigned long) segment_end - 
-		(unsigned long) segment_start;
-	data = create_mem_file(size);
-	addr = mmap(NULL, size, PROT_WRITE | PROT_READ, MAP_SHARED, data, 0);
-	if(addr == MAP_FAILED){
-		perror("mapping new data segment");
-		exit(1);
-	}
-	memcpy(addr, segment_start, size);
-	if(switcheroo(data, prot, addr, segment_start, size) < 0){
-		printf("switcheroo failed\n");
-		exit(1);
-	}
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/process_kern.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/process_kern.c
+++ /dev/null
@@ -1,461 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/sched.h"
-#include "linux/signal.h"
-#include "linux/kernel.h"
-#include "linux/interrupt.h"
-#include "linux/ptrace.h"
-#include "asm/system.h"
-#include "asm/pgalloc.h"
-#include "asm/ptrace.h"
-#include "asm/tlbflush.h"
-#include "irq_user.h"
-#include "kern_util.h"
-#include "os.h"
-#include "kern.h"
-#include "sigcontext.h"
-#include "mem_user.h"
-#include "tlb.h"
-#include "mode.h"
-#include "mode_kern.h"
-#include "init.h"
-#include "tt.h"
-
-void switch_to_tt(void *prev, void *next)
-{
-	struct task_struct *from, *to, *prev_sched;
-	unsigned long flags;
-	int err, vtalrm, alrm, prof, cpu;
-	char c;
-
-	from = prev;
-	to = next;
-
-	cpu = task_thread_info(from)->cpu;
-	if(cpu == 0)
-		forward_interrupts(to->thread.mode.tt.extern_pid);
-#ifdef CONFIG_SMP
-	forward_ipi(cpu_data[cpu].ipi_pipe[0], to->thread.mode.tt.extern_pid);
-#endif
-	local_irq_save(flags);
-
-	vtalrm = change_sig(SIGVTALRM, 0);
-	alrm = change_sig(SIGALRM, 0);
-	prof = change_sig(SIGPROF, 0);
-
-	forward_pending_sigio(to->thread.mode.tt.extern_pid);
-
-	c = 0;
-
-	/* Notice that here we "up" the semaphore on which "to" is waiting, and
-	 * below (the read) we wait on this semaphore (which is implemented by
-	 * switch_pipe) and go sleeping. Thus, after that, we have resumed in
-	 * "to", and can't use any more the value of "from" (which is outdated),
-	 * nor the value in "to" (since it was the task which stole us the CPU,
-	 * which we don't care about). */
-
-	err = os_write_file(to->thread.mode.tt.switch_pipe[1], &c, sizeof(c));
-	if(err != sizeof(c))
-		panic("write of switch_pipe failed, err = %d", -err);
-
-	if(from->thread.mode.tt.switch_pipe[0] == -1)
-		os_kill_process(os_getpid(), 0);
-
-	err = os_read_file(from->thread.mode.tt.switch_pipe[0], &c,
-			     sizeof(c));
-	if(err != sizeof(c))
-		panic("read of switch_pipe failed, errno = %d", -err);
-
-	/* If the process that we have just scheduled away from has exited,
-	 * then it needs to be killed here.  The reason is that, even though
-	 * it will kill itself when it next runs, that may be too late.  Its
-	 * stack will be freed, possibly before then, and if that happens,
-	 * we have a use-after-free situation.  So, it gets killed here
-	 * in case it has not already killed itself.
-	 */
-	prev_sched = current->thread.prev_sched;
-        if(prev_sched->thread.mode.tt.switch_pipe[0] == -1)
-		os_kill_process(prev_sched->thread.mode.tt.extern_pid, 1);
-
-	change_sig(SIGVTALRM, vtalrm);
-	change_sig(SIGALRM, alrm);
-	change_sig(SIGPROF, prof);
-
-	arch_switch_to_tt(prev_sched, current);
-
-	flush_tlb_all();
-	local_irq_restore(flags);
-}
-
-void release_thread_tt(struct task_struct *task)
-{
-	int pid = task->thread.mode.tt.extern_pid;
-
-	/*
-         * We first have to kill the other process, before
-         * closing its switch_pipe. Else it might wake up
-         * and receive "EOF" before we could kill it.
-         */
-	if(os_getpid() != pid)
-		os_kill_process(pid, 0);
-
-        os_close_file(task->thread.mode.tt.switch_pipe[0]);
-        os_close_file(task->thread.mode.tt.switch_pipe[1]);
-	/* use switch_pipe as flag: thread is released */
-        task->thread.mode.tt.switch_pipe[0] = -1;
-}
-
-void suspend_new_thread(int fd)
-{
-	int err;
-	char c;
-
-	os_stop_process(os_getpid());
-	err = os_read_file(fd, &c, sizeof(c));
-	if(err != sizeof(c))
-		panic("read failed in suspend_new_thread, err = %d", -err);
-}
-
-void schedule_tail(struct task_struct *prev);
-
-static void new_thread_handler(int sig)
-{
-	unsigned long disable;
-	int (*fn)(void *);
-	void *arg;
-
-	fn = current->thread.request.u.thread.proc;
-	arg = current->thread.request.u.thread.arg;
-
-	UPT_SC(&current->thread.regs.regs) = (void *) (&sig + 1);
-	disable = (1 << (SIGVTALRM - 1)) | (1 << (SIGALRM - 1)) |
-		(1 << (SIGIO - 1)) | (1 << (SIGPROF - 1));
-	SC_SIGMASK(UPT_SC(&current->thread.regs.regs)) &= ~disable;
-
-	suspend_new_thread(current->thread.mode.tt.switch_pipe[0]);
-
-	force_flush_all();
-	if(current->thread.prev_sched != NULL)
-		schedule_tail(current->thread.prev_sched);
-	current->thread.prev_sched = NULL;
-
-	init_new_thread_signals();
-	enable_timer();
-	free_page(current->thread.temp_stack);
-	set_cmdline("(kernel thread)");
-
-	change_sig(SIGUSR1, 1);
-	change_sig(SIGPROF, 1);
-	local_irq_enable();
-	if(!run_kernel_thread(fn, arg, &current->thread.exec_buf))
-		do_exit(0);
-
-	/* XXX No set_user_mode here because a newly execed process will
-	 * immediately segfault on its non-existent IP, coming straight back
-	 * to the signal handler, which will call set_user_mode on its way
-	 * out.  This should probably change since it's confusing.
-	 */
-}
-
-static int new_thread_proc(void *stack)
-{
-	/* local_irq_disable is needed to block out signals until this thread is
-	 * properly scheduled.  Otherwise, the tracing thread will get mighty
-	 * upset about any signals that arrive before that.
-	 * This has the complication that it sets the saved signal mask in
-	 * the sigcontext to block signals.  This gets restored when this
-	 * thread (or a descendant, since they get a copy of this sigcontext)
-	 * returns to userspace.
-	 * So, this is compensated for elsewhere.
-	 * XXX There is still a small window until local_irq_disable() actually
-	 * finishes where signals are possible - shouldn't be a problem in
-	 * practice since SIGIO hasn't been forwarded here yet, and the
-	 * local_irq_disable should finish before a SIGVTALRM has time to be
-	 * delivered.
-	 */
-
-	local_irq_disable();
-	init_new_thread_stack(stack, new_thread_handler);
-	os_usr1_process(os_getpid());
-	change_sig(SIGUSR1, 1);
-	return(0);
-}
-
-/* Signal masking - signals are blocked at the start of fork_tramp.  They
- * are re-enabled when finish_fork_handler is entered by fork_tramp hitting
- * itself with a SIGUSR1.  set_user_mode has to be run with SIGUSR1 off,
- * so it is blocked before it's called.  They are re-enabled on sigreturn
- * despite the fact that they were blocked when the SIGUSR1 was issued because
- * copy_thread copies the parent's sigcontext, including the signal mask
- * onto the signal frame.
- */
-
-void finish_fork_handler(int sig)
-{
- 	UPT_SC(&current->thread.regs.regs) = (void *) (&sig + 1);
-	suspend_new_thread(current->thread.mode.tt.switch_pipe[0]);
-
-	force_flush_all();
-	if(current->thread.prev_sched != NULL)
-		schedule_tail(current->thread.prev_sched);
-	current->thread.prev_sched = NULL;
-
-	enable_timer();
-	change_sig(SIGVTALRM, 1);
-	local_irq_enable();
-	if(current->mm != current->parent->mm)
-		protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 
-			       1, 0, 1);
-	stack_protections((unsigned long) current_thread);
-
-	free_page(current->thread.temp_stack);
-	local_irq_disable();
-	change_sig(SIGUSR1, 0);
-	set_user_mode(current);
-}
-
-int fork_tramp(void *stack)
-{
-	local_irq_disable();
-	arch_init_thread();
-	init_new_thread_stack(stack, finish_fork_handler);
-
-	os_usr1_process(os_getpid());
-	change_sig(SIGUSR1, 1);
-	return(0);
-}
-
-int copy_thread_tt(int nr, unsigned long clone_flags, unsigned long sp,
-		   unsigned long stack_top, struct task_struct * p, 
-		   struct pt_regs *regs)
-{
-	int (*tramp)(void *);
-	int new_pid, err;
-	unsigned long stack;
-	
-	if(current->thread.forking)
-		tramp = fork_tramp;
-	else {
-		tramp = new_thread_proc;
-		p->thread.request.u.thread = current->thread.request.u.thread;
-	}
-
-	err = os_pipe(p->thread.mode.tt.switch_pipe, 1, 1);
-	if(err < 0){
-		printk("copy_thread : pipe failed, err = %d\n", -err);
-		return(err);
-	}
-
-	stack = alloc_stack(0, 0);
-	if(stack == 0){
-		printk(KERN_ERR "copy_thread : failed to allocate "
-		       "temporary stack\n");
-		return(-ENOMEM);
-	}
-
-	clone_flags &= CLONE_VM;
-	p->thread.temp_stack = stack;
-	new_pid = start_fork_tramp(task_stack_page(p), stack, clone_flags, tramp);
-	if(new_pid < 0){
-		printk(KERN_ERR "copy_thread : clone failed - errno = %d\n", 
-		       -new_pid);
-		return(new_pid);
-	}
-
-	if(current->thread.forking){
-		sc_to_sc(UPT_SC(&p->thread.regs.regs), UPT_SC(&regs->regs));
-		SC_SET_SYSCALL_RETURN(UPT_SC(&p->thread.regs.regs), 0);
-		if(sp != 0)
-			SC_SP(UPT_SC(&p->thread.regs.regs)) = sp;
-	}
-	p->thread.mode.tt.extern_pid = new_pid;
-
-	current->thread.request.op = OP_FORK;
-	current->thread.request.u.fork.pid = new_pid;
-	os_usr1_process(os_getpid());
-
-	/* Enable the signal and then disable it to ensure that it is handled
-	 * here, and nowhere else.
-	 */
-	change_sig(SIGUSR1, 1);
-
-	change_sig(SIGUSR1, 0);
-	err = 0;
-	return(err);
-}
-
-void reboot_tt(void)
-{
-	current->thread.request.op = OP_REBOOT;
-	os_usr1_process(os_getpid());
-	change_sig(SIGUSR1, 1);
-}
-
-void halt_tt(void)
-{
-	current->thread.request.op = OP_HALT;
-	os_usr1_process(os_getpid());
-	change_sig(SIGUSR1, 1);
-}
-
-void kill_off_processes_tt(void)
-{
-	struct task_struct *p;
-	int me;
-
-	me = os_getpid();
-        for_each_process(p){
-		if(p->thread.mode.tt.extern_pid != me) 
-			os_kill_process(p->thread.mode.tt.extern_pid, 0);
-	}
-	if(init_task.thread.mode.tt.extern_pid != me) 
-		os_kill_process(init_task.thread.mode.tt.extern_pid, 0);
-}
-
-void initial_thread_cb_tt(void (*proc)(void *), void *arg)
-{
-	if(os_getpid() == tracing_pid){
-		(*proc)(arg);
-	}
-	else {
-		current->thread.request.op = OP_CB;
-		current->thread.request.u.cb.proc = proc;
-		current->thread.request.u.cb.arg = arg;
-		os_usr1_process(os_getpid());
-		change_sig(SIGUSR1, 1);
-
-		change_sig(SIGUSR1, 0);
-	}
-}
-
-int do_proc_op(void *t, int proc_id)
-{
-	struct task_struct *task;
-	struct thread_struct *thread;
-	int op, pid;
-
-	task = t;
-	thread = &task->thread;
-	op = thread->request.op;
-	switch(op){
-	case OP_NONE:
-	case OP_TRACE_ON:
-		break;
-	case OP_EXEC:
-		pid = thread->request.u.exec.pid;
-		do_exec(thread->mode.tt.extern_pid, pid);
-		thread->mode.tt.extern_pid = pid;
-		cpu_tasks[task_thread_info(task)->cpu].pid = pid;
-		break;
-	case OP_FORK:
-		attach_process(thread->request.u.fork.pid);
-		break;
-	case OP_CB:
-		(*thread->request.u.cb.proc)(thread->request.u.cb.arg);
-		break;
-	case OP_REBOOT:
-	case OP_HALT:
-		break;
-	default:
-		tracer_panic("Bad op in do_proc_op");
-		break;
-	}
-	thread->request.op = OP_NONE;
-	return(op);
-}
-
-void init_idle_tt(void)
-{
-	default_idle();
-}
-
-extern void start_kernel(void);
-
-static int start_kernel_proc(void *unused)
-{
-	int pid;
-
-	block_signals();
-	pid = os_getpid();
-
-	cpu_tasks[0].pid = pid;
-	cpu_tasks[0].task = current;
-#ifdef CONFIG_SMP
- 	cpu_online_map = cpumask_of_cpu(0);
-#endif
-	if(debug) os_stop_process(pid);
-	start_kernel();
-	return(0);
-}
-
-void set_tracing(void *task, int tracing)
-{
-	((struct task_struct *) task)->thread.mode.tt.tracing = tracing;
-}
-
-int is_tracing(void *t)
-{
-	return (((struct task_struct *) t)->thread.mode.tt.tracing);
-}
-
-int set_user_mode(void *t)
-{
-	struct task_struct *task;
-
-	task = t ? t : current;
-	if(task->thread.mode.tt.tracing) 
-		return(1);
-	task->thread.request.op = OP_TRACE_ON;
-	os_usr1_process(os_getpid());
-	return(0);
-}
-
-void set_init_pid(int pid)
-{
-	int err;
-
-	init_task.thread.mode.tt.extern_pid = pid;
-	err = os_pipe(init_task.thread.mode.tt.switch_pipe, 1, 1);
-	if(err)
-		panic("Can't create switch pipe for init_task, errno = %d",
-		      -err);
-}
-
-int start_uml_tt(void)
-{
-	void *sp;
-	int pages;
-
-	pages = (1 << CONFIG_KERNEL_STACK_ORDER);
-	sp = task_stack_page(&init_task) +
-		pages * PAGE_SIZE - sizeof(unsigned long);
-	return(tracer(start_kernel_proc, sp));
-}
-
-int external_pid_tt(struct task_struct *task)
-{
-	return(task->thread.mode.tt.extern_pid);
-}
-
-int thread_pid_tt(struct task_struct *task)
-{
-	return(task->thread.mode.tt.extern_pid);
-}
-
-int is_valid_pid(int pid)
-{
-	struct task_struct *task;
-
-        read_lock(&tasklist_lock);
-        for_each_process(task){
-                if(task->thread.mode.tt.extern_pid == pid){
-			read_unlock(&tasklist_lock);
-			return(1);
-                }
-        }
-	read_unlock(&tasklist_lock);
-	return(0);
-}
diff -puN arch/um/kernel/tt/ptproxy/Makefile~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# 
-# Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
-# Licensed under the GPL
-#
-
-obj-y = proxy.o ptrace.o sysdep.o wait.o
-
-USER_OBJS := $(obj-y)
-
-include arch/um/scripts/Makefile.rules
diff -puN arch/um/kernel/tt/ptproxy/proxy.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/proxy.c
+++ /dev/null
@@ -1,377 +0,0 @@
-/**********************************************************************
-proxy.c
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-
-Jeff Dike (jdike@karaya.com) : Modified for integration into uml
-**********************************************************************/
-
-/* XXX This file shouldn't refer to CONFIG_* */
-
-#include <errno.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <signal.h>
-#include <string.h>
-#include <termios.h>
-#include <sys/wait.h>
-#include <sys/types.h>
-#include <sys/ioctl.h>
-#include <asm/unistd.h>
-#include "ptrace_user.h"
-
-#include "ptproxy.h"
-#include "sysdep.h"
-#include "wait.h"
-
-#include "user.h"
-#include "os.h"
-#include "tempfile.h"
-
-static int debugger_wait(debugger_state *debugger, int *status, int options,
-			 int (*syscall)(debugger_state *debugger, pid_t child),
-			 int (*normal_return)(debugger_state *debugger, 
-					      pid_t unused),
-			 int (*wait_return)(debugger_state *debugger, 
-					    pid_t unused))
-{
-	if(debugger->real_wait){
-		debugger->handle_trace = normal_return;
-		syscall_continue(debugger->pid);
-		debugger->real_wait = 0;
-		return(1);
-	}
-	debugger->wait_status_ptr = status;
-	debugger->wait_options = options;
-	if((debugger->debugee != NULL) && debugger->debugee->event){
-		syscall_continue(debugger->pid);
-		wait_for_stop(debugger->pid, SIGTRAP, PTRACE_SYSCALL,
-			      NULL);
-		(*wait_return)(debugger, -1);
-		return(0);
-	}
-	else if(debugger->wait_options & WNOHANG){
-		syscall_cancel(debugger->pid, 0);
-		debugger->handle_trace = syscall;
-		return(0);
-	}
-	else {
-		syscall_pause(debugger->pid);
-		debugger->handle_trace = wait_return;
-		debugger->waiting = 1;
-	}
-	return(1);
-}
-
-/*
- * Handle debugger trap, i.e. syscall.
- */
-
-int debugger_syscall(debugger_state *debugger, pid_t child)
-{
-	long arg1, arg2, arg3, arg4, arg5, result;
-	int syscall, ret = 0;
-
-	syscall = get_syscall(debugger->pid, &arg1, &arg2, &arg3, &arg4, 
-			      &arg5);
-
-	switch(syscall){
-	case __NR_execve:
-		/* execve never returns */
-		debugger->handle_trace = debugger_syscall; 
-		break;
-
-	case __NR_ptrace:
-		if(debugger->debugee->pid != 0) arg2 = debugger->debugee->pid;
-		if(!debugger->debugee->in_context) 
-			child = debugger->debugee->pid;
-		result = proxy_ptrace(debugger, arg1, arg2, arg3, arg4, child,
-				      &ret);
-		syscall_cancel(debugger->pid, result);
-		debugger->handle_trace = debugger_syscall;
-		return(ret);
-
-#ifdef __NR_waitpid
-	case __NR_waitpid:
-#endif
-	case __NR_wait4:
-		if(!debugger_wait(debugger, (int *) arg2, arg3, 
-				  debugger_syscall, debugger_normal_return, 
-				  proxy_wait_return))
-			return(0);
-		break;
-
-	case __NR_kill:
-		if(!debugger->debugee->in_context) 
-			child = debugger->debugee->pid;
-		if(arg1 == debugger->debugee->pid){
-			result = kill(child, arg2);
-			syscall_cancel(debugger->pid, result);
-			debugger->handle_trace = debugger_syscall;
-			return(0);
-		}
-		else debugger->handle_trace = debugger_normal_return;
-		break;
-
-	default:
-		debugger->handle_trace = debugger_normal_return;
-	}
-
-	syscall_continue(debugger->pid);
-	return(0);
-}
-
-/* Used by the tracing thread */
-static debugger_state parent;
-static int parent_syscall(debugger_state *debugger, int pid);
-
-int init_parent_proxy(int pid)
-{
-	parent = ((debugger_state) { .pid 		= pid,
-				     .wait_options 	= 0,
-				     .wait_status_ptr 	= NULL,
-				     .waiting 		= 0,
-				     .real_wait 	= 0,
-				     .expecting_child 	= 0,
-				     .handle_trace  	= parent_syscall,
-				     .debugee 		= NULL } );
-	return(0);
-}
-
-int parent_normal_return(debugger_state *debugger, pid_t unused)
-{
-	debugger->handle_trace = parent_syscall;
-	syscall_continue(debugger->pid);
-	return(0);
-}
-
-static int parent_syscall(debugger_state *debugger, int pid)
-{
-	long arg1, arg2, arg3, arg4, arg5;
-	int syscall;
-
-	syscall = get_syscall(pid, &arg1, &arg2, &arg3, &arg4, &arg5);
-		
-	if((syscall == __NR_wait4)
-#ifdef __NR_waitpid
-	   || (syscall == __NR_waitpid)
-#endif
-	){
-		debugger_wait(&parent, (int *) arg2, arg3, parent_syscall,
-			      parent_normal_return, parent_wait_return);
-	}
-	else ptrace(PTRACE_SYSCALL, pid, 0, 0);
-	return(0);
-}
-
-int debugger_normal_return(debugger_state *debugger, pid_t unused)
-{
-	debugger->handle_trace = debugger_syscall;
-	syscall_continue(debugger->pid);
-	return(0);
-}
-
-void debugger_cancelled_return(debugger_state *debugger, int result)
-{
-	debugger->handle_trace = debugger_syscall;
-	syscall_set_result(debugger->pid, result);
-	syscall_continue(debugger->pid);
-}
-
-/* Used by the tracing thread */
-static debugger_state debugger;
-static debugee_state debugee;
-
-void init_proxy (pid_t debugger_pid, int stopped, int status)
-{
-	debugger.pid = debugger_pid;
-	debugger.handle_trace = debugger_syscall;
-	debugger.debugee = &debugee;
-	debugger.waiting = 0;
-	debugger.real_wait = 0;
-	debugger.expecting_child = 0;
-
-	debugee.pid = 0;
-	debugee.traced = 0;
-	debugee.stopped = stopped;
-	debugee.event = 0;
-	debugee.zombie = 0;
-	debugee.died = 0;
-	debugee.wait_status = status;
-	debugee.in_context = 1;
-}
-
-int debugger_proxy(int status, int pid)
-{
-	int ret = 0, sig;
-
-	if(WIFSTOPPED(status)){
-		sig = WSTOPSIG(status);
-		if (sig == SIGTRAP)
-			ret = (*debugger.handle_trace)(&debugger, pid);
-						       
-		else if(sig == SIGCHLD){
-			if(debugger.expecting_child){
-				ptrace(PTRACE_SYSCALL, debugger.pid, 0, sig);
-				debugger.expecting_child = 0;
-			}
-			else if(debugger.waiting)
-				real_wait_return(&debugger);
-			else {
-				ptrace(PTRACE_SYSCALL, debugger.pid, 0, sig);
-				debugger.real_wait = 1;
-			}
-		}
-		else ptrace(PTRACE_SYSCALL, debugger.pid, 0, sig);
-	}
-	else if(WIFEXITED(status)){
-		tracer_panic("debugger (pid %d) exited with status %d", 
-			     debugger.pid, WEXITSTATUS(status));
-	}
-	else if(WIFSIGNALED(status)){
-		tracer_panic("debugger (pid %d) exited with signal %d", 
-			     debugger.pid, WTERMSIG(status));
-	}
-	else {
-		tracer_panic("proxy got unknown status (0x%x) on debugger "
-			     "(pid %d)", status, debugger.pid);
-	}
-	return(ret);
-}
-
-void child_proxy(pid_t pid, int status)
-{
-	debugee.event = 1;
-	debugee.wait_status = status;
-
-	if(WIFSTOPPED(status)){
-		debugee.stopped = 1;
-		debugger.expecting_child = 1;
-		kill(debugger.pid, SIGCHLD);
-	}
-	else if(WIFEXITED(status) || WIFSIGNALED(status)){
-		debugee.zombie = 1;
-		debugger.expecting_child = 1;
-		kill(debugger.pid, SIGCHLD);
-	}
-	else panic("proxy got unknown status (0x%x) on child (pid %d)", 
-		   status, pid);
-}
-
-void debugger_parent_signal(int status, int pid)
-{
-	int sig;
-
-	if(WIFSTOPPED(status)){
-		sig = WSTOPSIG(status);
-		if(sig == SIGTRAP) (*parent.handle_trace)(&parent, pid);
-		else ptrace(PTRACE_SYSCALL, pid, 0, sig);
-	}
-}
-
-void fake_child_exit(void)
-{
-	int status, pid;
-
-	child_proxy(1, W_EXITCODE(0, 0));
-	while(debugger.waiting == 1){
-		CATCH_EINTR(pid = waitpid(debugger.pid, &status, WUNTRACED));
-		if(pid != debugger.pid){
-			printk("fake_child_exit - waitpid failed, "
-			       "errno = %d\n", errno);
-			return;
-		}
-		debugger_proxy(status, debugger.pid);
-	}
-	CATCH_EINTR(pid = waitpid(debugger.pid, &status, WUNTRACED));
-	if(pid != debugger.pid){
-		printk("fake_child_exit - waitpid failed, "
-		       "errno = %d\n", errno);
-		return;
-	}
-	if(ptrace(PTRACE_DETACH, debugger.pid, 0, SIGCONT) < 0)
-		printk("fake_child_exit - PTRACE_DETACH failed, errno = %d\n",
-		       errno);
-}
-
-char gdb_init_string[] = 
-"att 1 \n\
-b panic \n\
-b stop \n\
-handle SIGWINCH nostop noprint pass \n\
-";
-
-int start_debugger(char *prog, int startup, int stop, int *fd_out)
-{
-	int slave, child;
-
-	slave = open_gdb_chan();
-	child = fork();
-	if(child == 0){
-		char *tempname = NULL;
-		int fd;
-
-	        if(setsid() < 0) perror("setsid");
-		if((dup2(slave, 0) < 0) || (dup2(slave, 1) < 0) || 
-		   (dup2(slave, 2) < 0)){
-			printk("start_debugger : dup2 failed, errno = %d\n",
-			       errno);
-			exit(1);
-		}
-		if(ioctl(0, TIOCSCTTY, 0) < 0){
-			printk("start_debugger : TIOCSCTTY failed, "
-			       "errno = %d\n", errno);
-			exit(1);
-		}
-		if(tcsetpgrp (1, os_getpid()) < 0){
-			printk("start_debugger : tcsetpgrp failed, "
-			       "errno = %d\n", errno);
-#ifdef notdef
-			exit(1);
-#endif
-		}
-		fd = make_tempfile("/tmp/gdb_init-XXXXXX", &tempname, 0);
-		if(fd < 0){
-			printk("start_debugger : make_tempfile failed,"
-			       "err = %d\n", -fd);
-			exit(1);
-		}
-		os_write_file(fd, gdb_init_string,
-			      sizeof(gdb_init_string) - 1);
-		if(startup){
-			if(stop){
-				os_write_file(fd, "b start_kernel\n",
-						strlen("b start_kernel\n"));
-			}
-			os_write_file(fd, "c\n", strlen("c\n"));
-		}
-		if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
-			printk("start_debugger :  PTRACE_TRACEME failed, "
-			       "errno = %d\n", errno);
-			exit(1);
-		}
-		execlp("gdb", "gdb", "--command", tempname, prog, NULL);
-		printk("start_debugger : exec of gdb failed, errno = %d\n",
-		       errno);
-	}
-	if(child < 0){
-		printk("start_debugger : fork for gdb failed, errno = %d\n",
-		       errno);
-		return(-1);
-	}
-	*fd_out = slave;
-	return(child);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/ptproxy.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/ptproxy.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/**********************************************************************
-ptproxy.h
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-**********************************************************************/
-
-#ifndef __PTPROXY_H
-#define __PTPROXY_H
-
-#include <sys/types.h>
-
-typedef struct debugger debugger_state;
-typedef struct debugee debugee_state;
-
-struct debugger
-{
-	pid_t pid;
-	int wait_options;
-	int *wait_status_ptr;
-	unsigned int waiting : 1;
-	unsigned int real_wait : 1;
-	unsigned int expecting_child : 1;
-	int (*handle_trace) (debugger_state *, pid_t);
-
-	debugee_state *debugee;
-};
-
-struct debugee
-{
-	pid_t pid;
-	int wait_status;
-	unsigned int died : 1;
-	unsigned int event : 1;
-	unsigned int stopped : 1;
-	unsigned int trace_singlestep : 1;
-	unsigned int trace_syscall : 1;
-	unsigned int traced : 1;
-	unsigned int zombie : 1;
-	unsigned int in_context : 1;
-};
-
-extern int debugger_syscall(debugger_state *debugger, pid_t pid);
-extern int debugger_normal_return (debugger_state *debugger, pid_t unused);
-
-extern long proxy_ptrace (struct debugger *, int, pid_t, long, long, pid_t,
-			  int *strace_out);
-extern void debugger_cancelled_return(debugger_state *debugger, int result);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/ptrace.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/ptrace.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/**********************************************************************
-ptrace.c
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-
-Jeff Dike (jdike@karaya.com) : Modified for integration into uml
-**********************************************************************/
-
-#include <errno.h>
-#include <unistd.h>
-#include <signal.h>
-#include <sys/types.h>
-#include <sys/time.h>
-#include <sys/wait.h>
-
-#include "ptproxy.h"
-#include "debug.h"
-#include "kern_util.h"
-#include "ptrace_user.h"
-#include "tt.h"
-#include "os.h"
-
-long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
-		  long arg3, long arg4, pid_t child, int *ret)
-{
-	sigset_t relay;
-	long result;
-	int status;
-
-	*ret = 0;
-	if(debugger->debugee->died) return(-ESRCH);
-
-	switch(arg1){
-	case PTRACE_ATTACH:
-		if(debugger->debugee->traced) return(-EPERM);
-
-		debugger->debugee->pid = arg2;
-		debugger->debugee->traced = 1;
-
-		if(is_valid_pid(arg2) && (arg2 != child)){
-			debugger->debugee->in_context = 0;
-			kill(arg2, SIGSTOP);
-			debugger->debugee->event = 1;
-			debugger->debugee->wait_status = W_STOPCODE(SIGSTOP);
-		}
-		else {
-			debugger->debugee->in_context = 1;
-			if(debugger->debugee->stopped) 
-				child_proxy(child, W_STOPCODE(SIGSTOP));
-			else kill(child, SIGSTOP);
-		}
-
-		return(0);
-
-	case PTRACE_DETACH:
-		if(!debugger->debugee->traced) return(-EPERM);
-		
-		debugger->debugee->traced = 0;
-		debugger->debugee->pid = 0;
-		if(!debugger->debugee->in_context)
-			kill(child, SIGCONT);
-
-		return(0);
-
-	case PTRACE_CONT:
-		if(!debugger->debugee->in_context) return(-EPERM);
-		*ret = PTRACE_CONT;
-		return(ptrace(PTRACE_CONT, child, arg3, arg4));
-
-#ifdef UM_HAVE_GETFPREGS
-	case PTRACE_GETFPREGS:
-	{
-		long regs[FP_FRAME_SIZE];
-		int i, result;
-
-		result = ptrace(PTRACE_GETFPREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-		
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			ptrace(PTRACE_POKEDATA, debugger->pid, arg4 + 4 * i,
-			       regs[i]);
-		return(result);
-	}
-#endif
-
-#ifdef UM_HAVE_GETFPXREGS
-	case PTRACE_GETFPXREGS:
-	{
-		long regs[FPX_FRAME_SIZE];
-		int i, result;
-
-		result = ptrace(PTRACE_GETFPXREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-		
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			ptrace(PTRACE_POKEDATA, debugger->pid, arg4 + 4 * i,
-			       regs[i]);
-		return(result);
-	}
-#endif
-
-#ifdef UM_HAVE_GETREGS
-	case PTRACE_GETREGS:
-	{
-		long regs[FRAME_SIZE];
-		int i, result;
-
-		result = ptrace(PTRACE_GETREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			ptrace (PTRACE_POKEDATA, debugger->pid,
-				arg4 + 4 * i, regs[i]);
-		return(result);
-	}
-	break;
-#endif
-
-	case PTRACE_KILL:
-		result = ptrace(PTRACE_KILL, child, arg3, arg4);
-		if(result == -1) return(-errno);
-
-		return(result);
-
-	case PTRACE_PEEKDATA:
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKUSR:
-		/* The value being read out could be -1, so we have to 
-		 * check errno to see if there's an error, and zero it
-		 * beforehand so we're not faked out by an old error
-		 */
-
-		errno = 0;
-		result = ptrace(arg1, child, arg3, 0);
-		if((result == -1) && (errno != 0)) return(-errno);
-
-		result = ptrace(PTRACE_POKEDATA, debugger->pid, arg4, result);
-		if(result == -1) return(-errno);
-			
-		return(result);
-
-	case PTRACE_POKEDATA:
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEUSR:
-		result = ptrace(arg1, child, arg3, arg4);
-		if(result == -1) return(-errno);
-
-		if(arg1 == PTRACE_POKEUSR) ptrace_pokeuser(arg3, arg4);
-		return(result);
-
-#ifdef UM_HAVE_SETFPREGS
-	case PTRACE_SETFPREGS:
-	{
-		long regs[FP_FRAME_SIZE];
-		int i;
-
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			regs[i] = ptrace (PTRACE_PEEKDATA, debugger->pid,
-					  arg4 + 4 * i, 0);
-		result = ptrace(PTRACE_SETFPREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-
-		return(result);
-	}
-#endif
-
-#ifdef UM_HAVE_SETFPXREGS
-	case PTRACE_SETFPXREGS:
-	{
-		long regs[FPX_FRAME_SIZE];
-		int i;
-
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			regs[i] = ptrace (PTRACE_PEEKDATA, debugger->pid,
-					  arg4 + 4 * i, 0);
-		result = ptrace(PTRACE_SETFPXREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-
-		return(result);
-	}
-#endif
-
-#ifdef UM_HAVE_SETREGS
-	case PTRACE_SETREGS:
-	{
-		long regs[FRAME_SIZE];
-		int i;
-
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
-			regs[i] = ptrace(PTRACE_PEEKDATA, debugger->pid,
-					 arg4 + 4 * i, 0);
-		result = ptrace(PTRACE_SETREGS, child, 0, regs);
-		if(result == -1) return(-errno);
-
-		return(result);
-	}
-#endif
-
-	case PTRACE_SINGLESTEP:
-		if(!debugger->debugee->in_context) return(-EPERM);
-		sigemptyset(&relay);
-		sigaddset(&relay, SIGSEGV);
-		sigaddset(&relay, SIGILL);
-		sigaddset(&relay, SIGBUS);
-		result = ptrace(PTRACE_SINGLESTEP, child, arg3, arg4);
-		if(result == -1) return(-errno);
-		
-		status = wait_for_stop(child, SIGTRAP, PTRACE_SINGLESTEP,
-				       &relay);
-		child_proxy(child, status);
-		return(result);
-
-	case PTRACE_SYSCALL:
-		if(!debugger->debugee->in_context) return(-EPERM);
-		result = ptrace(PTRACE_SYSCALL, child, arg3, arg4);
-		if(result == -1) return(-errno);
-
-		*ret = PTRACE_SYSCALL;
-		return(result);
-
-	case PTRACE_TRACEME:
-	default:
-		return(-EINVAL);
-	}
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/sysdep.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/sysdep.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/**********************************************************************
-sysdep.c
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-**********************************************************************/
-
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <signal.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <linux/unistd.h>
-#include "ptrace_user.h"
-#include "user.h"
-#include "os.h"
-
-int get_syscall(pid_t pid, long *arg1, long *arg2, long *arg3, long *arg4, 
-		long *arg5)
-{
-	*arg1 = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_ARG1_OFFSET, 0);
-	*arg2 = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_ARG2_OFFSET, 0);
-	*arg3 = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_ARG3_OFFSET, 0);
-	*arg4 = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_ARG4_OFFSET, 0);
-	*arg5 = ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_ARG5_OFFSET, 0);
-	return(ptrace(PTRACE_PEEKUSR, pid, PT_SYSCALL_NR_OFFSET, 0));
-}
-
-void syscall_cancel(pid_t pid, int result)
-{
-	if((ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
-		   __NR_getpid) < 0) ||
-	   (ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0) ||
-	   (wait_for_stop(pid, SIGTRAP, PTRACE_SYSCALL, NULL) < 0) ||
-	   (ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, result) < 0) ||
-	   (ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0))
-		printk("ptproxy: couldn't cancel syscall: errno = %d\n", 
-		       errno);
-}
-
-void syscall_set_result(pid_t pid, long result)
-{
-	ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, result);
-}
-
-void syscall_continue(pid_t pid)
-{
-	ptrace(PTRACE_SYSCALL, pid, 0, 0);
-}
-
-int syscall_pause(pid_t pid) 
-{
-	if(ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET, __NR_pause) < 0){
-		printk("syscall_change - ptrace failed, errno = %d\n", errno);
-		return(-1);
-	}
-	return(0);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/sysdep.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/sysdep.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/**********************************************************************
-sysdep.h
-
-Copyright (C) 1999 Lars Brinkhoff.
-Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
-See the file COPYING for licensing terms and conditions.
-**********************************************************************/
-
-extern int get_syscall(pid_t pid, long *arg1, long *arg2, long *arg3, 
-		       long *arg4, long *arg5);
-extern void syscall_cancel (pid_t pid, long result);
-extern void syscall_set_result (pid_t pid, long result);
-extern void syscall_continue (pid_t pid);
-extern int syscall_pause(pid_t pid);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/wait.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/wait.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/**********************************************************************
-wait.c
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-
-**********************************************************************/
-
-#include <errno.h>
-#include <signal.h>
-#include <sys/wait.h>
-
-#include "ptproxy.h"
-#include "sysdep.h"
-#include "wait.h"
-#include "ptrace_user.h"
-#include "sysdep/ptrace.h"
-#include "sysdep/sigcontext.h"
-
-int proxy_wait_return(struct debugger *debugger, pid_t unused)
-{
-	debugger->waiting = 0;
-
-	if(debugger->debugee->died || (debugger->wait_options & __WCLONE)){
-		debugger_cancelled_return(debugger, -ECHILD);
-		return(0);
-	}
-
-	if(debugger->debugee->zombie && debugger->debugee->event)
-		debugger->debugee->died = 1;
-
-	if(debugger->debugee->event){
-		debugger->debugee->event = 0;
-		ptrace(PTRACE_POKEDATA, debugger->pid,
-		       debugger->wait_status_ptr, 
-		       debugger->debugee->wait_status);
-		/* if (wait4)
-		   ptrace (PTRACE_POKEDATA, pid, rusage_ptr, ...); */
-		debugger_cancelled_return(debugger, debugger->debugee->pid);
-		return(0);
-	}
-
-	/* pause will return -EINTR, which happens to be right for wait */
-	debugger_normal_return(debugger, -1);
-	return(0);
-}
-
-int parent_wait_return(struct debugger *debugger, pid_t unused)
-{
-	return(debugger_normal_return(debugger, -1));
-}
-
-int real_wait_return(struct debugger *debugger)
-{
-	unsigned long ip;
-	int pid;
-
-	pid = debugger->pid;
-
-	ip = ptrace(PTRACE_PEEKUSR, pid, PT_IP_OFFSET, 0);
-	IP_RESTART_SYSCALL(ip);
-
-	if(ptrace(PTRACE_POKEUSR, pid, PT_IP_OFFSET, ip) < 0)
-		tracer_panic("real_wait_return : Failed to restart system "
-			     "call, errno = %d\n", errno);
-
-	if((ptrace(PTRACE_SYSCALL, debugger->pid, 0, SIGCHLD) < 0) ||
-	   (ptrace(PTRACE_SYSCALL, debugger->pid, 0, 0) < 0) ||
-	   (ptrace(PTRACE_SYSCALL, debugger->pid, 0, 0) < 0) ||
-	   debugger_normal_return(debugger, -1))
-		tracer_panic("real_wait_return : gdb failed to wait, "
-			     "errno = %d\n", errno);
-	return(0);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/ptproxy/wait.h~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/ptproxy/wait.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/**********************************************************************
-wait.h
-
-Copyright (C) 1999 Lars Brinkhoff.  See the file COPYING for licensing
-terms and conditions.
-**********************************************************************/
-
-#ifndef __PTPROXY_WAIT_H
-#define __PTPROXY_WAIT_H
-
-extern int proxy_wait_return(struct debugger *debugger, pid_t unused);
-extern int real_wait_return(struct debugger *debugger);
-extern int parent_wait_return(struct debugger *debugger, pid_t unused);
-
-#endif
diff -puN arch/um/kernel/tt/syscall_kern.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/syscall_kern.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/* 
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL
- */
-
-#include "linux/types.h"
-#include "linux/utime.h"
-#include "linux/sys.h"
-#include "linux/ptrace.h"
-#include "asm/unistd.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-#include "asm/stat.h"
-#include "sysdep/syscalls.h"
-#include "sysdep/sigcontext.h"
-#include "kern_util.h"
-#include "syscall.h"
-
-void syscall_handler_tt(int sig, struct pt_regs *regs)
-{
-	void *sc;
-	long result;
-	int syscall;
-
-	sc = UPT_SC(&regs->regs);
-	SC_START_SYSCALL(sc);
-
-	syscall = UPT_SYSCALL_NR(&regs->regs);
-	syscall_trace(&regs->regs, 0);
-
-	current->thread.nsyscalls++;
-	nsyscalls++;
-
-	if((syscall >= NR_syscalls) || (syscall < 0))
-		result = -ENOSYS;
-	else result = EXECUTE_SYSCALL(syscall, regs);
-
-	/* regs->sc may have changed while the system call ran (there may
-	 * have been an interrupt or segfault), so it needs to be refreshed.
-	 */
-	UPT_SC(&regs->regs) = sc;
-
-	SC_SET_SYSCALL_RETURN(sc, result);
-
-	syscall_trace(&regs->regs, 1);
-}
diff -puN arch/um/kernel/tt/syscall_user.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/syscall_user.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <unistd.h>
-#include <signal.h>
-#include <errno.h>
-#include <asm/unistd.h>
-#include "sysdep/ptrace.h"
-#include "sigcontext.h"
-#include "ptrace_user.h"
-#include "task.h"
-#include "kern_util.h"
-#include "syscall.h"
-#include "tt.h"
-
-void do_sigtrap(void *task)
-{
-	UPT_SYSCALL_NR(TASK_REGS(task)) = -1;
-}
-
-void do_syscall(void *task, int pid, int local_using_sysemu)
-{
-	unsigned long proc_regs[FRAME_SIZE];
-
-	if(ptrace_getregs(pid, proc_regs) < 0)
-		tracer_panic("Couldn't read registers");
-
-	UPT_SYSCALL_NR(TASK_REGS(task)) = PT_SYSCALL_NR(proc_regs);
-
-#ifdef UPT_ORIGGPR2
-        UPT_ORIGGPR2(TASK_REGS(task)) = REGS_ORIGGPR2(proc_regs);
-#endif
-
-	if(((unsigned long *) PT_IP(proc_regs) >= &_stext) &&
-	   ((unsigned long *) PT_IP(proc_regs) <= &_etext))
-		tracer_panic("I'm tracing myself and I can't get out");
-
-	/* advanced sysemu mode set syscall number to -1 automatically */
-	if (local_using_sysemu==2)
-		return;
-
-	/* syscall number -1 in sysemu skips syscall restarting in host */
-	if(ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_NR_OFFSET,
-		  local_using_sysemu ? -1 : __NR_getpid) < 0)
-		tracer_panic("do_syscall : Nullifying syscall failed, "
-			     "errno = %d", errno);
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/tlb.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/tlb.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Copyright 2003 PathScale, Inc.
- * Licensed under the GPL
- */
-
-#include "linux/stddef.h"
-#include "linux/kernel.h"
-#include "linux/sched.h"
-#include "linux/mm.h"
-#include "asm/page.h"
-#include "asm/pgtable.h"
-#include "asm/uaccess.h"
-#include "asm/tlbflush.h"
-#include "mem_user.h"
-#include "os.h"
-#include "tlb.h"
-
-static int do_ops(union mm_context *mmu, struct host_vm_op *ops, int last,
-		    int finished, void **flush)
-{
-	struct host_vm_op *op;
-        int i, ret=0;
-
-        for(i = 0; i <= last && !ret; i++){
-		op = &ops[i];
-		switch(op->type){
-		case MMAP:
-                        ret = os_map_memory((void *) op->u.mmap.addr,
-                                            op->u.mmap.fd, op->u.mmap.offset,
-                                            op->u.mmap.len, op->u.mmap.r,
-                                            op->u.mmap.w, op->u.mmap.x);
-			break;
-		case MUNMAP:
-                        ret = os_unmap_memory((void *) op->u.munmap.addr,
-                                              op->u.munmap.len);
-			break;
-		case MPROTECT:
-                        ret = protect_memory(op->u.mprotect.addr,
-                                             op->u.munmap.len,
-                                             op->u.mprotect.r,
-                                             op->u.mprotect.w,
-                                             op->u.mprotect.x, 1);
-			protect_memory(op->u.mprotect.addr, op->u.munmap.len,
-				       op->u.mprotect.r, op->u.mprotect.w,
-				       op->u.mprotect.x, 1);
-			break;
-		default:
-			printk("Unknown op type %d in do_ops\n", op->type);
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static void fix_range(struct mm_struct *mm, unsigned long start_addr, 
-		      unsigned long end_addr, int force)
-{
-        if((current->thread.mode.tt.extern_pid != -1) &&
-           (current->thread.mode.tt.extern_pid != os_getpid()))
-                panic("fix_range fixing wrong address space, current = 0x%p",
-                      current);
-
-        fix_range_common(mm, start_addr, end_addr, force, do_ops);
-}
-
-atomic_t vmchange_seq = ATOMIC_INIT(1);
-
-void flush_tlb_kernel_range_tt(unsigned long start, unsigned long end)
-{
-        if(flush_tlb_kernel_range_common(start, end))
-                atomic_inc(&vmchange_seq);
-}
-
-void flush_tlb_kernel_vm_tt(void)
-{
-        flush_tlb_kernel_range(start_vm, end_vm);
-}
-
-void __flush_tlb_one_tt(unsigned long addr)
-{
-        flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-}
-  
-void flush_tlb_range_tt(struct vm_area_struct *vma, unsigned long start, 
-		     unsigned long end)
-{
-	if(vma->vm_mm != current->mm) return;
-
-	/* Assumes that the range start ... end is entirely within
-	 * either process memory or kernel vm
-	 */
-	if((start >= start_vm) && (start < end_vm)){
-		if(flush_tlb_kernel_range_common(start, end))
-			atomic_inc(&vmchange_seq);
-	}
-	else fix_range(vma->vm_mm, start, end, 0);
-}
-
-void flush_tlb_mm_tt(struct mm_struct *mm)
-{
-	unsigned long seq;
-
-	if(mm != current->mm) return;
-
-	fix_range(mm, 0, STACK_TOP, 0);
-
-	seq = atomic_read(&vmchange_seq);
-	if(current->thread.mode.tt.vm_seq == seq)
-		return;
-	current->thread.mode.tt.vm_seq = seq;
-	flush_tlb_kernel_range_common(start_vm, end_vm);
-}
-
-void force_flush_all_tt(void)
-{
-	fix_range(current->mm, 0, STACK_TOP, 1);
-	flush_tlb_kernel_range_common(start_vm, end_vm);
-}
diff -puN arch/um/kernel/tt/tracer.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/tracer.c
+++ /dev/null
@@ -1,461 +0,0 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <unistd.h>
-#include <signal.h>
-#include <errno.h>
-#include <sched.h>
-#include <string.h>
-#include <sys/mman.h>
-#include <sys/time.h>
-#include <sys/wait.h>
-#include "user.h"
-#include "sysdep/ptrace.h"
-#include "sigcontext.h"
-#include "sysdep/sigcontext.h"
-#include "os.h"
-#include "mem_user.h"
-#include "process.h"
-#include "kern_util.h"
-#include "chan_user.h"
-#include "ptrace_user.h"
-#include "irq_user.h"
-#include "mode.h"
-#include "tt.h"
-
-static int tracer_winch[2];
-
-int is_tracer_winch(int pid, int fd, void *data)
-{
-	if(pid != os_getpgrp())
-		return(0);
-
-	register_winch_irq(tracer_winch[0], fd, -1, data);
-	return(1);
-}
-
-static void tracer_winch_handler(int sig)
-{
-	int n;
-	char c = 1;
-
-	n = os_write_file(tracer_winch[1], &c, sizeof(c));
-	if(n != sizeof(c))
-		printk("tracer_winch_handler - write failed, err = %d\n", -n);
-}
-
-/* Called only by the tracing thread during initialization */
-
-static void setup_tracer_winch(void)
-{
-	int err;
-
-	err = os_pipe(tracer_winch, 1, 1);
-	if(err < 0){
-		printk("setup_tracer_winch : os_pipe failed, err = %d\n", -err);
-		return;
-	}
-	signal(SIGWINCH, tracer_winch_handler);
-}
-
-void attach_process(int pid)
-{
-	if((ptrace(PTRACE_ATTACH, pid, 0, 0) < 0) ||
-	   (ptrace(PTRACE_CONT, pid, 0, 0) < 0))
-		tracer_panic("OP_FORK failed to attach pid");
-	wait_for_stop(pid, SIGSTOP, PTRACE_CONT, NULL);
-	if (ptrace(PTRACE_OLDSETOPTIONS, pid, 0, (void *)PTRACE_O_TRACESYSGOOD) < 0)
-		tracer_panic("OP_FORK: PTRACE_SETOPTIONS failed, errno = %d", errno);
-	if(ptrace(PTRACE_CONT, pid, 0, 0) < 0)
-		tracer_panic("OP_FORK failed to continue process");
-}
-
-void tracer_panic(char *format, ...)
-{
-	va_list ap;
-
-	va_start(ap, format);
-	vprintf(format, ap);
-	va_end(ap);
-	printf("\n");
-	while(1) pause();
-}
-
-static void tracer_segv(int sig, struct sigcontext sc)
-{
-        struct faultinfo fi;
-        GET_FAULTINFO_FROM_SC(fi, &sc);
-	printf("Tracing thread segfault at address 0x%lx, ip 0x%lx\n",
-               FAULT_ADDRESS(fi), SC_IP(&sc));
-	while(1)
-		pause();
-}
-
-/* Changed early in boot, and then only read */
-int debug = 0;
-int debug_stop = 1;
-int debug_parent = 0;
-int honeypot = 0;
-
-static int signal_tramp(void *arg)
-{
-	int (*proc)(void *);
-
-	if(honeypot && munmap((void *) (host_task_size - 0x10000000),
-			      0x10000000)) 
-		panic("Unmapping stack failed");
-	if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0)
-		panic("ptrace PTRACE_TRACEME failed");
-	os_stop_process(os_getpid());
-	change_sig(SIGWINCH, 0);
-	signal(SIGUSR1, SIG_IGN);
-	change_sig(SIGCHLD, 0);
-	signal(SIGSEGV, (__sighandler_t) sig_handler);
-	set_cmdline("(idle thread)");
-	set_init_pid(os_getpid());
-	init_irq_signals(0);
-	proc = arg;
-	return((*proc)(NULL));
-}
-
-static void sleeping_process_signal(int pid, int sig)
-{
-	switch(sig){
-	/* These two result from UML being ^Z-ed and bg-ed.  PTRACE_CONT is
-	 * right because the process must be in the kernel already.
-	 */
-	case SIGCONT:
-	case SIGTSTP:
-		if(ptrace(PTRACE_CONT, pid, 0, sig) < 0)
-			tracer_panic("sleeping_process_signal : Failed to "
-				     "continue pid %d, signal = %d, "
-				     "errno = %d\n", pid, sig, errno);
-		break;
-
-	/* This happens when the debugger (e.g. strace) is doing system call 
-	 * tracing on the kernel.  During a context switch, the current task
-	 * will be set to the incoming process and the outgoing process will
-	 * hop into write and then read.  Since it's not the current process
-	 * any more, the trace of those will land here.  So, we need to just 
-	 * PTRACE_SYSCALL it.
-	 */
-	case (SIGTRAP + 0x80):
-		if(ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
-			tracer_panic("sleeping_process_signal : Failed to "
-				     "PTRACE_SYSCALL pid %d, errno = %d\n",
-				     pid, errno);
-		break;
-	case SIGSTOP:
-		break;
-	default:
-		tracer_panic("sleeping process %d got unexpected "
-			     "signal : %d\n", pid, sig);
-		break;
-	}
-}
-
-/* Accessed only by the tracing thread */
-int debugger_pid = -1;
-int debugger_parent = -1;
-int debugger_fd = -1;
-int gdb_pid = -1;
-
-struct {
-	int pid;
-	int signal;
-	unsigned long addr;
-	struct timeval time;
-} signal_record[1024][32];
-
-int signal_index[32];
-int nsignals = 0;
-int debug_trace = 0;
-
-extern void signal_usr1(int sig);
-
-int tracing_pid = -1;
-
-int tracer(int (*init_proc)(void *), void *sp)
-{
-	void *task = NULL;
-	int status, pid = 0, sig = 0, cont_type, tracing = 0, op = 0;
-	int proc_id = 0, n, err, old_tracing = 0, strace = 0;
-	int local_using_sysemu = 0;
-
-	signal(SIGPIPE, SIG_IGN);
-	setup_tracer_winch();
-	tracing_pid = os_getpid();
-	printf("tracing thread pid = %d\n", tracing_pid);
-
-	pid = clone(signal_tramp, sp, CLONE_FILES | SIGCHLD, init_proc);
-	CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-	if(n < 0){
-		printf("waitpid on idle thread failed, errno = %d\n", errno);
-		exit(1);
-	}
-	if (ptrace(PTRACE_OLDSETOPTIONS, pid, 0, (void *)PTRACE_O_TRACESYSGOOD) < 0) {
-		printf("Failed to PTRACE_SETOPTIONS for idle thread, errno = %d\n", errno);
-		exit(1);
-	}
-	if((ptrace(PTRACE_CONT, pid, 0, 0) < 0)){
-		printf("Failed to continue idle thread, errno = %d\n", errno);
-		exit(1);
-	}
-
-	signal(SIGSEGV, (sighandler_t) tracer_segv);
-	signal(SIGUSR1, signal_usr1);
-	if(debug_trace){
-		printf("Tracing thread pausing to be attached\n");
-		stop();
-	}
-	if(debug){
-		if(gdb_pid != -1) 
-			debugger_pid = attach_debugger(pid, gdb_pid, 1);
-		else debugger_pid = init_ptrace_proxy(pid, 1, debug_stop);
-		if(debug_parent){
-			debugger_parent = os_process_parent(debugger_pid);
-			init_parent_proxy(debugger_parent);
-			err = attach(debugger_parent);
-			if(err){
-				printf("Failed to attach debugger parent %d, "
-				       "errno = %d\n", debugger_parent, -err);
-				debugger_parent = -1;
-			}
-			else {
-				if(ptrace(PTRACE_SYSCALL, debugger_parent, 
-					  0, 0) < 0){
-					printf("Failed to continue debugger "
-					       "parent, errno = %d\n", errno);
-					debugger_parent = -1;
-				}
-			}
-		}
-	}
-	set_cmdline("(tracing thread)");
-	while(1){
-		CATCH_EINTR(pid = waitpid(-1, &status, WUNTRACED));
-		if(pid <= 0){
-			if(errno != ECHILD){
-				printf("wait failed - errno = %d\n", errno);
-			}
-			continue;
-		}
-		if(pid == debugger_pid){
-			int cont = 0;
-
-			if(WIFEXITED(status) || WIFSIGNALED(status))
-				debugger_pid = -1;
-			/* XXX Figure out how to deal with gdb and SMP */
-			else cont = debugger_signal(status, cpu_tasks[0].pid);
-			if(cont == PTRACE_SYSCALL) strace = 1;
-			continue;
-		}
-		else if(pid == debugger_parent){
-			debugger_parent_signal(status, pid);
-			continue;
-		}
-		nsignals++;
-		if(WIFEXITED(status)) ;
-#ifdef notdef
-		{
-			printf("Child %d exited with status %d\n", pid, 
-			       WEXITSTATUS(status));
-		}
-#endif
-		else if(WIFSIGNALED(status)){
-			sig = WTERMSIG(status);
-			if(sig != 9){
-				printf("Child %d exited with signal %d\n", pid,
-				       sig);
-			}
-		}
-		else if(WIFSTOPPED(status)){
-			proc_id = pid_to_processor_id(pid);
-			sig = WSTOPSIG(status);
-			if(proc_id == -1){
-				sleeping_process_signal(pid, sig);
-				continue;
-			}
-
-			task = cpu_tasks[proc_id].task;
-			tracing = is_tracing(task);
-			old_tracing = tracing;
-
-			/* Assume: no syscall, when coming from user */
-			if ( tracing )
-				do_sigtrap(task);
-
-			switch(sig){
-			case SIGUSR1:
-				sig = 0;
-				op = do_proc_op(task, proc_id);
-				switch(op){
-				/*
-				 * This is called when entering user mode; after
-				 * this, we start intercepting syscalls.
-				 *
-				 * In fact, a process is started in kernel mode,
-				 * so with is_tracing() == 0 (and that is reset
-				 * when executing syscalls, since UML kernel has
-				 * the right to do syscalls);
-				 */
-				case OP_TRACE_ON:
-					arch_leave_kernel(task, pid);
-					tracing = 1;
-					break;
-				case OP_REBOOT:
-				case OP_HALT:
-					unmap_physmem();
-					kmalloc_ok = 0;
-					os_kill_ptraced_process(pid, 0);
-					/* Now let's reap remaining zombies */
-					errno = 0;
-					do {
-						waitpid(-1, &status,
-							WUNTRACED);
-					} while (errno != ECHILD);
-					return(op == OP_REBOOT);
-				case OP_NONE:
-					printf("Detaching pid %d\n", pid);
-					detach(pid, SIGSTOP);
-					continue;
-				default:
-					break;
-				}
-				/* OP_EXEC switches host processes on us,
-				 * we want to continue the new one.
-				 */
-				pid = cpu_tasks[proc_id].pid;
-				break;
-			case (SIGTRAP + 0x80):
-				if(!tracing && (debugger_pid != -1)){
-					child_signal(pid, status & 0x7fff);
-					continue;
-				}
-				tracing = 0;
-				/* local_using_sysemu has been already set
-				 * below, since if we are here, is_tracing() on
-				 * the traced task was 1, i.e. the process had
-				 * already run through one iteration of the
-				 * loop which executed a OP_TRACE_ON request.*/
-				do_syscall(task, pid, local_using_sysemu);
-				sig = SIGUSR2;
-				break;
-			case SIGTRAP:
-				if(!tracing && (debugger_pid != -1)){
-					child_signal(pid, status);
-					continue;
-				}
-				tracing = 0;
-				break;
-			case SIGPROF:
-				if(tracing) sig = 0;
-				break;
-			case SIGCHLD:
-			case SIGHUP:
-				sig = 0;
-				break;
-			case SIGSEGV:
-			case SIGIO:
-			case SIGALRM:
-			case SIGVTALRM:
-			case SIGFPE:
-			case SIGBUS:
-			case SIGILL:
-			case SIGWINCH:
-
-			default:
-				tracing = 0;
-				break;
-			}
-			set_tracing(task, tracing);
-
-			if(!tracing && old_tracing)
-				arch_enter_kernel(task, pid);
-
-			if(!tracing && (debugger_pid != -1) && (sig != 0) &&
-				(sig != SIGALRM) && (sig != SIGVTALRM) &&
-				(sig != SIGSEGV) && (sig != SIGTRAP) &&
-				(sig != SIGUSR2) && (sig != SIGIO) &&
-				(sig != SIGFPE)){
-				child_signal(pid, status);
-				continue;
-			}
-
-			local_using_sysemu = get_using_sysemu();
-
-			if(tracing)
-				cont_type = SELECT_PTRACE_OPERATION(local_using_sysemu,
-				                                    singlestepping(task));
-			else if((debugger_pid != -1) && strace)
-				cont_type = PTRACE_SYSCALL;
-			else
-				cont_type = PTRACE_CONT;
-
-			if(ptrace(cont_type, pid, 0, sig) != 0){
-				tracer_panic("ptrace failed to continue "
-					     "process - errno = %d\n", 
-					     errno);
-			}
-		}
-	}
-	return(0);
-}
-
-static int __init uml_debug_setup(char *line, int *add)
-{
-	char *next;
-
-	debug = 1;
-	*add = 0;
-	if(*line != '=') return(0);
-	line++;
-
-	while(line != NULL){
-		next = strchr(line, ',');
-		if(next) *next++ = '\0';
-		
-		if(!strcmp(line, "go"))	debug_stop = 0;
-		else if(!strcmp(line, "parent")) debug_parent = 1;
-		else printf("Unknown debug option : '%s'\n", line);
-
-		line = next;
-	}
-	return(0);
-}
-
-__uml_setup("debug", uml_debug_setup,
-"debug\n"
-"    Starts up the kernel under the control of gdb. See the \n"
-"    kernel debugging tutorial and the debugging session pages\n"
-"    at http://user-mode-linux.sourceforge.net/ for more information.\n\n"
-);
-
-static int __init uml_debugtrace_setup(char *line, int *add)
-{
-	debug_trace = 1;
-	return 0;
-}
-__uml_setup("debugtrace", uml_debugtrace_setup,
-"debugtrace\n"
-"    Causes the tracing thread to pause until it is attached by a\n"
-"    debugger and continued.  This is mostly for debugging crashes\n"
-"    early during boot, and should be pretty much obsoleted by\n"
-"    the debug switch.\n\n"
-);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/trap_user.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/trap_user.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <stdlib.h>
-#include <errno.h>
-#include <signal.h>
-#include "sysdep/ptrace.h"
-#include "sysdep/sigcontext.h"
-#include "kern_util.h"
-#include "task.h"
-#include "tt.h"
-#include "os.h"
-
-void sig_handler_common_tt(int sig, void *sc_ptr)
-{
-	struct sigcontext *sc = sc_ptr;
-	struct tt_regs save_regs, *r;
-	int save_errno = errno, is_user = 0;
-	void (*handler)(int, union uml_pt_regs *);
-
-	/* This is done because to allow SIGSEGV to be delivered inside a SEGV
-	 * handler.  This can happen in copy_user, and if SEGV is disabled,
-	 * the process will die.
-	 */
-	if(sig == SIGSEGV)
-		change_sig(SIGSEGV, 1);
-
-	r = &TASK_REGS(get_current())->tt;
-        if ( sig == SIGFPE || sig == SIGSEGV ||
-             sig == SIGBUS || sig == SIGILL ||
-             sig == SIGTRAP ) {
-                GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
-        }
-	save_regs = *r;
-	if (sc)
-		is_user = user_context(SC_SP(sc));
-	r->sc = sc;
-	if(sig != SIGUSR2) 
-		r->syscall = -1;
-
-	handler = sig_info[sig];
-
-	/* unblock SIGALRM, SIGVTALRM, SIGIO if sig isn't IRQ signal */
-	if (sig != SIGIO && sig != SIGWINCH &&
-	    sig != SIGVTALRM && sig != SIGALRM)
-		unblock_signals();
-
-	handler(sig, (union uml_pt_regs *) r);
-
-	if(is_user){
-		interrupt_end();
-		block_signals();
-		set_user_mode(NULL);
-	}
-	*r = save_regs;
-	errno = save_errno;
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/uaccess.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/uaccess.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
- * Licensed under the GPL
- */
-
-#include "linux/sched.h"
-#include "asm/uaccess.h"
-
-int copy_from_user_tt(void *to, const void __user *from, int n)
-{
-	if(!access_ok(VERIFY_READ, from, n))
-		return(n);
-
-	return(__do_copy_from_user(to, from, n, &current->thread.fault_addr,
-				   &current->thread.fault_catcher));
-}
-
-int copy_to_user_tt(void __user *to, const void *from, int n)
-{
-	if(!access_ok(VERIFY_WRITE, to, n))
-		return(n);
-
-	return(__do_copy_to_user(to, from, n, &current->thread.fault_addr,
-				 &current->thread.fault_catcher));
-}
-
-int strncpy_from_user_tt(char *dst, const char __user *src, int count)
-{
-	int n;
-
-	if(!access_ok(VERIFY_READ, src, 1))
-		return(-EFAULT);
-
-	n = __do_strncpy_from_user(dst, src, count,
-				   &current->thread.fault_addr,
-				   &current->thread.fault_catcher);
-	if(n < 0) return(-EFAULT);
-	return(n);
-}
-
-int __clear_user_tt(void __user *mem, int len)
-{
-	return(__do_clear_user(mem, len,
-			       &current->thread.fault_addr,
-			       &current->thread.fault_catcher));
-}
-
-int clear_user_tt(void __user *mem, int len)
-{
-	if(!access_ok(VERIFY_WRITE, mem, len))
-		return(len);
-
-	return(__do_clear_user(mem, len, &current->thread.fault_addr,
-			       &current->thread.fault_catcher));
-}
-
-int strnlen_user_tt(const void __user *str, int len)
-{
-	return(__do_strnlen_user(str, len,
-				 &current->thread.fault_addr,
-				 &current->thread.fault_catcher));
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/tt/uaccess_user.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/kernel/tt/uaccess_user.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/* 
- * Copyright (C) 2001 Chris Emerson (cemerson@chiark.greenend.org.uk)
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <string.h>
-#include "uml_uaccess.h"
-#include "task.h"
-#include "kern_util.h"
-#include "os.h"
-#include "longjmp.h"
-
-int __do_copy_from_user(void *to, const void *from, int n,
-			void **fault_addr, void **fault_catcher)
-{
-	struct tt_regs save = TASK_REGS(get_current())->tt;
-	unsigned long fault;
-	int faulted;
-
-	fault = __do_user_copy(to, from, n, fault_addr, fault_catcher,
-			       __do_copy, &faulted);
-	TASK_REGS(get_current())->tt = save;
-
-	if(!faulted)
-		return 0;
-	else if (fault)
-		return n - (fault - (unsigned long) from);
-	else
-		/* In case of a general protection fault, we don't have the
-		 * fault address, so NULL is used instead. Pretend we didn't
-		 * copy anything. */
-		return n;
-}
-
-static void __do_strncpy(void *dst, const void *src, int count)
-{
-	strncpy(dst, src, count);
-}	
-
-int __do_strncpy_from_user(char *dst, const char *src, unsigned long count,
-			   void **fault_addr, void **fault_catcher)
-{
-	struct tt_regs save = TASK_REGS(get_current())->tt;
-	unsigned long fault;
-	int faulted;
-
-	fault = __do_user_copy(dst, src, count, fault_addr, fault_catcher,
-			       __do_strncpy, &faulted);
-	TASK_REGS(get_current())->tt = save;
-
-	if(!faulted) return(strlen(dst));
-	else return(-1);
-}
-
-static void __do_clear(void *to, const void *from, int n)
-{
-	memset(to, 0, n);
-}	
-
-int __do_clear_user(void *mem, unsigned long len,
-		    void **fault_addr, void **fault_catcher)
-{
-	struct tt_regs save = TASK_REGS(get_current())->tt;
-	unsigned long fault;
-	int faulted;
-
-	fault = __do_user_copy(mem, NULL, len, fault_addr, fault_catcher,
-			       __do_clear, &faulted);
-	TASK_REGS(get_current())->tt = save;
-
-	if(!faulted) return(0);
-	else return(len - (fault - (unsigned long) mem));
-}
-
-int __do_strnlen_user(const char *str, unsigned long n,
-		      void **fault_addr, void **fault_catcher)
-{
-	struct tt_regs save = TASK_REGS(get_current())->tt;
-	int ret;
-	unsigned long *faddrp = (unsigned long *)fault_addr;
-	jmp_buf jbuf;
-
-	*fault_catcher = &jbuf;
-	if(UML_SETJMP(&jbuf) == 0)
-		ret = strlen(str) + 1;
-	else ret = *faddrp - (unsigned long) str;
-
-	*fault_addr = NULL;
-	*fault_catcher = NULL;
-
-	TASK_REGS(get_current())->tt = save;
-	return ret;
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/um_arch.c~uml-throw-out-config_mode_tt arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/um_arch.c
@@ -38,9 +38,7 @@
 #include "choose-mode.h"
 #include "mode_kern.h"
 #include "mode.h"
-#ifdef UML_CONFIG_MODE_SKAS
 #include "skas.h"
-#endif
 
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
@@ -132,43 +130,12 @@ unsigned long end_vm;
 /* Set in uml_ncpus_setup */
 int ncpus = 1;
 
-#ifdef CONFIG_CMDLINE_ON_HOST
-/* Pointer set in linux_main, the array itself is private to each thread,
- * and changed at address space creation time so this poses no concurrency
- * problems.
- */
-static char *argv1_begin = NULL;
-static char *argv1_end = NULL;
-#endif
-
 /* Set in early boot */
 static int have_root __initdata = 0;
 
 /* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
-void set_cmdline(char *cmd)
-{
-#ifdef CONFIG_CMDLINE_ON_HOST
-	char *umid, *ptr;
-
-	if(CHOOSE_MODE(honeypot, 0)) return;
-
-	umid = get_umid();
-	if(*umid != '\0'){
-		snprintf(argv1_begin, 
-			 (argv1_end - argv1_begin) * sizeof(*ptr), 
-			 "(%s) ", umid);
-		ptr = &argv1_begin[strlen(argv1_begin)];
-	}
-	else ptr = argv1_begin;
-
-	snprintf(ptr, (argv1_end - ptr) * sizeof(*ptr), "[%s]", cmd);
-	memset(argv1_begin + strlen(argv1_begin), '\0', 
-	       argv1_end - argv1_begin - strlen(argv1_begin));
-#endif
-}
-
 static char *usage_string = 
 "User Mode Linux v%s\n"
 "	available at http://user-mode-linux.sourceforge.net/\n\n";
@@ -201,13 +168,10 @@ __uml_setup("root=", uml_root_setup,
 "        root=/dev/ubd5\n\n"
 );
 
-#ifndef CONFIG_MODE_TT
-
 static int __init no_skas_debug_setup(char *line, int *add)
 {
 	printf("'debug' is not necessary to gdb UML in skas mode - run \n");
-	printf("'gdb linux' and disable CONFIG_CMDLINE_ON_HOST if gdb \n");
-	printf("doesn't work as expected\n");
+	printf("'gdb linux'");
 
 	return 0;
 }
@@ -217,8 +181,6 @@ __uml_setup("debug", no_skas_debug_setup
 "    this flag is not needed to run gdb on UML in skas mode\n\n"
 );
 
-#endif
-
 #ifdef CONFIG_SMP
 static int __init uml_ncpus_setup(char *line, int *add)
 {
@@ -236,52 +198,6 @@ __uml_setup("ncpus=", uml_ncpus_setup,
 );
 #endif
 
-static int force_tt = 0;
-
-#if defined(CONFIG_MODE_TT) && defined(CONFIG_MODE_SKAS)
-#define DEFAULT_TT 0
-
-static int __init mode_tt_setup(char *line, int *add)
-{
-	force_tt = 1;
-	return 0;
-}
-
-#else
-#ifdef CONFIG_MODE_SKAS
-
-#define DEFAULT_TT 0
-
-static int __init mode_tt_setup(char *line, int *add)
-{
-	printf("CONFIG_MODE_TT disabled - 'mode=tt' ignored\n");
-	return 0;
-}
-
-#else
-#ifdef CONFIG_MODE_TT
-
-#define DEFAULT_TT 1
-
-static int __init mode_tt_setup(char *line, int *add)
-{
-	printf("CONFIG_MODE_SKAS disabled - 'mode=tt' redundant\n");
-	return 0;
-}
-
-#endif
-#endif
-#endif
-
-__uml_setup("mode=tt", mode_tt_setup,
-"mode=tt\n"
-"    When both CONFIG_MODE_TT and CONFIG_MODE_SKAS are enabled, this option\n"
-"    forces UML to run in tt (tracing thread) mode.  It is not the default\n"
-"    because it's slower and less secure than skas mode.\n\n"
-);
-
-int mode_tt = DEFAULT_TT;
-
 static int __init Usage(char *line, int *add)
 {
 	const char **p;
@@ -357,29 +273,13 @@ int __init linux_main(int argc, char **a
 		add_arg(DEFAULT_COMMAND_LINE);
 
 	os_early_checks();
-	if (force_tt)
-		clear_can_do_skas();
-	mode_tt = force_tt ? 1 : !can_do_skas();
-#ifndef CONFIG_MODE_TT
-	if (mode_tt) {
-		/*Since CONFIG_MODE_TT is #undef'ed, force_tt cannot be 1. So,
-		 * can_do_skas() returned 0, and the message is correct. */
-		printf("Support for TT mode is disabled, and no SKAS support is present on the host.\n");
-		exit(1);
-	}
-#endif
 
-#ifndef CONFIG_MODE_SKAS
-	mode = "TT";
-#else
-	/* Show to the user the result of selection */
-	if (mode_tt)
-		mode = "TT";
-	else if (proc_mm && ptrace_faultinfo)
+	can_do_skas();
+
+	if (proc_mm && ptrace_faultinfo)
 		mode = "SKAS3";
 	else
 		mode = "SKAS0";
-#endif
 
 	printf("UML running in %s mode\n", mode);
 
@@ -411,11 +311,6 @@ int __init linux_main(int argc, char **a
 
 	setup_machinename(init_utsname()->machine);
 
-#ifdef CONFIG_CMDLINE_ON_HOST
-	argv1_begin = argv[1];
-	argv1_end = &argv[1][strlen(argv[1])];
-#endif
-
 	highmem = 0;
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
 	max_physmem = get_kmem_end() - uml_physmem - iomem_size - MIN_VMALLOC;
diff -puN arch/um/kernel/uml.lds.S~uml-throw-out-config_mode_tt arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-throw-out-config_mode_tt
+++ a/arch/um/kernel/uml.lds.S
@@ -18,13 +18,6 @@ SECTIONS
 
   . = START + SIZEOF_HEADERS;
 
-#ifdef MODE_TT
-  .remap_data : { UNMAP_PATH (.data .bss) }
-  .remap : { UNMAP_PATH (.text) }
-
-  . = ALIGN(4096);		/* Init code and data */
-#endif
-
   _text = .;
   _stext = .;
   __init_begin = .;
diff -puN arch/um/os-Linux/Makefile~uml-throw-out-config_mode_tt arch/um/os-Linux/Makefile
--- a/arch/um/os-Linux/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/Makefile
@@ -5,12 +5,7 @@
 
 obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o trap.o tty.o uaccess.o \
-	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/
-
-obj-$(CONFIG_MODE_SKAS) += skas/
-
-obj-$(CONFIG_MODE_TT) += tt.o
-user-objs-$(CONFIG_MODE_TT) += tt.o
+	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
 obj-$(CONFIG_TTY_LOG) += tty_log.o
 user-objs-$(CONFIG_TTY_LOG) += tty_log.o
diff -puN arch/um/os-Linux/main.c~uml-throw-out-config_mode_tt arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/main.c
@@ -25,9 +25,6 @@
 #include "um_malloc.h"
 #include "kern_constants.h"
 
-/* Set in main, unchanged thereafter */
-char *linux_prog;
-
 #define PGD_BOUND (4 * 1024 * 1024)
 #define STACKSIZE (8 * 1024 * 1024)
 #define THREAD_NAME_LEN (256)
@@ -125,35 +122,6 @@ int __init main(int argc, char **argv, c
 	char **new_argv;
 	int ret, i, err;
 
-#ifdef UML_CONFIG_CMDLINE_ON_HOST
-	/* Allocate memory for thread command lines */
-	if(argc < 2 || strlen(argv[1]) < THREAD_NAME_LEN - 1){
-
-		char padding[THREAD_NAME_LEN] = {
-			[ 0 ...  THREAD_NAME_LEN - 2] = ' ', '\0'
-		};
-
-		new_argv = malloc((argc + 2) * sizeof(char*));
-		if(!new_argv) {
-			perror("Allocating extended argv");
-			exit(1);
-		}
-
-		new_argv[0] = argv[0];
-		new_argv[1] = padding;
-
-		for(i = 2; i <= argc; i++)
-			new_argv[i] = argv[i - 1];
-		new_argv[argc + 1] = NULL;
-
-		execvp(new_argv[0], new_argv);
-		perror("execing with extended args");
-		exit(1);
-	}
-#endif
-
-	linux_prog = argv[0];
-
 	set_stklim();
 
 	setup_env_path();
diff -puN arch/um/os-Linux/process.c~uml-throw-out-config_mode_tt arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/process.c
@@ -133,13 +133,6 @@ void os_kill_ptraced_process(int pid, in
 		CATCH_EINTR(waitpid(pid, NULL, 0));
 }
 
-#ifdef UML_CONFIG_MODE_TT
-void os_usr1_process(int pid)
-{
-	kill(pid, SIGUSR1);
-}
-#endif
-
 /* Don't use the glibc version, which caches the result in TLS. It misses some
  * syscalls, and also breaks with clone(), which does not unshare the TLS.
  */
@@ -239,30 +232,6 @@ out:
 	return ok;
 }
 
-#ifdef UML_CONFIG_MODE_TT
-void init_new_thread_stack(void *sig_stack, void (*usr1_handler)(int))
-{
-	int flags = 0, pages;
-
-	if(sig_stack != NULL){
-		pages = (1 << UML_CONFIG_KERNEL_STACK_ORDER);
-		set_sigstack(sig_stack, pages * UM_KERN_PAGE_SIZE);
-		flags = SA_ONSTACK;
-	}
-	if(usr1_handler){
-		struct sigaction sa;
-
-		sa.sa_handler = usr1_handler;
-		sigemptyset(&sa.sa_mask);
-		sa.sa_flags = flags;
-		sa.sa_restorer = NULL;
-		if(sigaction(SIGUSR1, &sa, NULL) < 0)
-			panic("init_new_thread_stack - sigaction failed - "
-			      "errno = %d\n", errno);
-	}
-}
-#endif
-
 void init_new_thread_signals(void)
 {
 	set_handler(SIGSEGV, (__sighandler_t) sig_handler, SA_ONSTACK,
diff -puN arch/um/os-Linux/start_up.c~uml-throw-out-config_mode_tt arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/start_up.c
@@ -35,12 +35,9 @@
 #include "mode.h"
 #include "tempfile.h"
 #include "kern_constants.h"
-
-#ifdef UML_CONFIG_MODE_SKAS
 #include "skas.h"
 #include "skas_ptrace.h"
 #include "registers.h"
-#endif
 
 static int ptrace_child(void *arg)
 {
@@ -407,7 +404,6 @@ __uml_setup("noptraceldt", noptraceldt_c
 "    To support PTRACE_LDT, the host needs to be patched using\n"
 "    the current skas3 patch.\n\n");
 
-#ifdef UML_CONFIG_MODE_SKAS
 static inline void check_skas3_ptrace_faultinfo(void)
 {
 	struct ptrace_faultinfo fi;
@@ -504,12 +500,6 @@ int can_do_skas(void)
 
 	return 1;
 }
-#else
-int can_do_skas(void)
-{
-	return 0;
-}
-#endif
 
 int __init parse_iomem(char *str, int *add)
 {
diff -puN arch/um/os-Linux/sys-i386/Makefile~uml-throw-out-config_mode_tt arch/um/os-Linux/sys-i386/Makefile
--- a/arch/um/os-Linux/sys-i386/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/sys-i386/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-$(CONFIG_MODE_SKAS) = registers.o signal.o tls.o
+obj-y = registers.o signal.o tls.o
 
 USER_OBJS := $(obj-y)
 
diff -puN arch/um/os-Linux/sys-x86_64/Makefile~uml-throw-out-config_mode_tt arch/um/os-Linux/sys-x86_64/Makefile
--- a/arch/um/os-Linux/sys-x86_64/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/sys-x86_64/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-obj-$(CONFIG_MODE_SKAS) = registers.o prctl.o signal.o
+obj-y = registers.o prctl.o signal.o
 
 USER_OBJS := $(obj-y)
 
diff -puN arch/um/os-Linux/time.c~uml-throw-out-config_mode_tt arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/time.c
@@ -30,13 +30,6 @@ int set_interval(int is_virtual)
 	return 0;
 }
 
-#ifdef UML_CONFIG_MODE_TT
-void enable_timer(void)
-{
-	set_interval(1);
-}
-#endif
-
 void disable_timer(void)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
@@ -71,18 +64,6 @@ void switch_timers(int to_real)
 		       errno);
 }
 
-#ifdef UML_CONFIG_MODE_TT
-void uml_idle_timer(void)
-{
-	if(signal(SIGVTALRM, SIG_IGN) == SIG_ERR)
-		panic("Couldn't unset SIGVTALRM handler");
-
-	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
-		    SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
-	set_interval(0);
-}
-#endif
-
 unsigned long long os_nsecs(void)
 {
 	struct timeval tv;
diff -puN arch/um/os-Linux/tls.c~uml-throw-out-config_mode_tt arch/um/os-Linux/tls.c
--- a/arch/um/os-Linux/tls.c~uml-throw-out-config_mode_tt
+++ a/arch/um/os-Linux/tls.c
@@ -8,11 +8,6 @@
 
 /* TLS support - we basically rely on the host's one.*/
 
-/* In TT mode, this should be called only by the tracing thread, and makes sense
- * only for PTRACE_SET_THREAD_AREA. In SKAS mode, it's used normally.
- *
- */
-
 #ifndef PTRACE_GET_THREAD_AREA
 #define PTRACE_GET_THREAD_AREA 25
 #endif
@@ -32,8 +27,6 @@ int os_set_thread_area(user_desc_t *info
 	return ret;
 }
 
-#ifdef UML_CONFIG_MODE_SKAS
-
 int os_get_thread_area(user_desc_t *info, int pid)
 {
 	int ret;
@@ -44,32 +37,3 @@ int os_get_thread_area(user_desc_t *info
 		ret = -errno;
 	return ret;
 }
-
-#endif
-
-#ifdef UML_CONFIG_MODE_TT
-#include "linux/unistd.h"
-
-int do_set_thread_area_tt(user_desc_t *info)
-{
-	int ret;
-
-	ret = syscall(__NR_set_thread_area,info);
-	if (ret < 0) {
-		ret = -errno;
-	}
-	return ret;
-}
-
-int do_get_thread_area_tt(user_desc_t *info)
-{
-	int ret;
-
-	ret = syscall(__NR_get_thread_area,info);
-	if (ret < 0) {
-		ret = -errno;
-	}
-	return ret;
-}
-
-#endif /* UML_CONFIG_MODE_TT */
diff -puN arch/um/scripts/Makefile.rules~uml-throw-out-config_mode_tt arch/um/scripts/Makefile.rules
--- a/arch/um/scripts/Makefile.rules~uml-throw-out-config_mode_tt
+++ a/arch/um/scripts/Makefile.rules
@@ -21,7 +21,7 @@ $(UNPROFILE_OBJS:.o=.%): \
 $(UNPROFILE_OBJS) : CHECKFLAGS := -D__linux__ -Dlinux -D__STDC__ \
 	-Dunix -D__unix__ -D__$(SUBARCH)__ $(CF)
 
-# The stubs and unmap.o can't try to call mcount or update basic block data
+# The stubs can't try to call mcount or update basic block data
 define unprofile
 	$(patsubst -pg,,$(patsubst -fprofile-arcs -ftest-coverage,,$(1)))
 endef
diff -puN arch/um/sys-i386/Makefile~uml-throw-out-config_mode_tt arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/Makefile
@@ -1,8 +1,6 @@
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
-	ptrace_user.o setjmp.o signal.o sigcontext.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o
-
-obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
+	ptrace_user.o setjmp.o signal.o sigcontext.o stub.o stub_segv.o \
+	syscalls.o sysrq.o sys_call_table.o tls.o
 
 subarch-obj-y = lib/bitops.o lib/semaphore.o lib/string.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem.o
@@ -13,11 +11,7 @@ USER_OBJS := bugs.o ptrace_user.o sigcon
 USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
 
-extra-$(CONFIG_MODE_TT) += unmap.o
-
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
 
 include arch/um/scripts/Makefile.rules
-
-$(obj)/unmap.%: _c_flags = $(call unprofile,$(CFLAGS))
diff -puN arch/um/sys-i386/ldt.c~uml-throw-out-config_mode_tt arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/ldt.c
@@ -19,72 +19,6 @@
 
 extern int modify_ldt(int func, void *ptr, unsigned long bytecount);
 
-#ifdef CONFIG_MODE_TT
-
-static long do_modify_ldt_tt(int func, void __user *ptr,
-			      unsigned long bytecount)
-{
-	struct user_desc info;
-	int res = 0;
-	void *buf = NULL;
-	void *p = NULL; /* What we pass to host. */
-
-	switch(func){
-	case 1:
-	case 0x11: /* write_ldt */
-		/* Do this check now to avoid overflows. */
-		if (bytecount != sizeof(struct user_desc)) {
-			res = -EINVAL;
-			goto out;
-		}
-
-		if(copy_from_user(&info, ptr, sizeof(info))) {
-			res = -EFAULT;
-			goto out;
-		}
-
-		p = &info;
-		break;
-	case 0:
-	case 2: /* read_ldt */
-
-		/* The use of info avoids kmalloc on the write case, not on the
-		 * read one. */
-		buf = kmalloc(bytecount, GFP_KERNEL);
-		if (!buf) {
-			res = -ENOMEM;
-			goto out;
-		}
-		p = buf;
-		break;
-	default:
-		res = -ENOSYS;
-		goto out;
-	}
-
-	res = modify_ldt(func, p, bytecount);
-	if(res < 0)
-		goto out;
-
-	switch(func){
-	case 0:
-	case 2:
-		/* Modify_ldt was for reading and returned the number of read
-		 * bytes.*/
-		if(copy_to_user(ptr, p, res))
-			res = -EFAULT;
-		break;
-	}
-
-out:
-	kfree(buf);
-	return res;
-}
-
-#endif
-
-#ifdef CONFIG_MODE_SKAS
-
 #include "skas.h"
 #include "skas_ptrace.h"
 #include "asm/mmu_context.h"
@@ -569,7 +503,6 @@ void free_ldt(struct mmu_context_skas * 
 	}
 	mm->ldt.entry_count = 0;
 }
-#endif
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
 {
diff -puN arch/um/sys-i386/ptrace.c~uml-throw-out-config_mode_tt arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/ptrace.c
@@ -14,12 +14,6 @@
 #include "sysdep/sigcontext.h"
 #include "sysdep/sc.h"
 
-void arch_switch_to_tt(struct task_struct *from, struct task_struct *to)
-{
-	update_debugregs(to->thread.arch.debugregs_seq);
-	arch_switch_tls_tt(from, to);
-}
-
 void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
 {
 	int err = arch_switch_tls_skas(from, to);
@@ -233,79 +227,12 @@ static inline unsigned long twd_fxsr_to_
 	return ret;
 }
 
-/*
- * FXSR floating point environment conversions.
- */
-
-#ifdef CONFIG_MODE_TT
-static inline int convert_fxsr_to_user_tt(struct _fpstate __user *buf,
-					  struct pt_regs *regs)
-{
-	struct i387_fxsave_struct *fxsave = SC_FXSR_ENV(PT_REGS_SC(regs));
-	unsigned long env[7];
-	struct _fpreg __user *to;
-	struct _fpxreg *from;
-	int i;
-
-	env[0] = (unsigned long)fxsave->cwd | 0xffff0000;
-	env[1] = (unsigned long)fxsave->swd | 0xffff0000;
-	env[2] = twd_fxsr_to_i387(fxsave);
-	env[3] = fxsave->fip;
-	env[4] = fxsave->fcs | ((unsigned long)fxsave->fop << 16);
-	env[5] = fxsave->foo;
-	env[6] = fxsave->fos;
-
-	if ( __copy_to_user( buf, env, 7 * sizeof(unsigned long) ) )
-		return 1;
-
-	to = &buf->_st[0];
-	from = (struct _fpxreg *) &fxsave->st_space[0];
-	for ( i = 0 ; i < 8 ; i++, to++, from++ ) {
-		if ( __copy_to_user( to, from, sizeof(*to) ) )
-			return 1;
-	}
-	return 0;
-}
-#endif
-
 static inline int convert_fxsr_to_user(struct _fpstate __user *buf,
 				       struct pt_regs *regs)
 {
 	return(CHOOSE_MODE(convert_fxsr_to_user_tt(buf, regs), 0));
 }
 
-#ifdef CONFIG_MODE_TT
-static inline int convert_fxsr_from_user_tt(struct pt_regs *regs,
-					    struct _fpstate __user *buf)
-{
-	struct i387_fxsave_struct *fxsave = SC_FXSR_ENV(PT_REGS_SC(regs));
-	unsigned long env[7];
-	struct _fpxreg *to;
-	struct _fpreg __user *from;
-	int i;
-
-	if ( __copy_from_user( env, buf, 7 * sizeof(long) ) )
-		return 1;
-
-	fxsave->cwd = (unsigned short)(env[0] & 0xffff);
-	fxsave->swd = (unsigned short)(env[1] & 0xffff);
-	fxsave->twd = twd_i387_to_fxsr((unsigned short)(env[2] & 0xffff));
-	fxsave->fip = env[3];
-	fxsave->fop = (unsigned short)((env[4] & 0xffff0000) >> 16);
-	fxsave->fcs = (env[4] & 0xffff);
-	fxsave->foo = env[5];
-	fxsave->fos = env[6];
-
-	to = (struct _fpxreg *) &fxsave->st_space[0];
-	from = &buf->_st[0];
-	for ( i = 0 ; i < 8 ; i++, to++, from++ ) {
-		if ( __copy_from_user( to, from, sizeof(*from) ) )
-			return 1;
-	}
-	return 0;
-}
-#endif
-
 static inline int convert_fxsr_from_user(struct pt_regs *regs, 
 					 struct _fpstate __user *buf)
 {
@@ -332,39 +259,11 @@ int set_fpregs(unsigned long buf, struct
 	else return(0);
 }
 
-#ifdef CONFIG_MODE_TT
-int get_fpxregs_tt(unsigned long buf, struct task_struct *tsk)
-{
-	struct pt_regs *regs = &tsk->thread.regs;
-	struct i387_fxsave_struct *fxsave = SC_FXSR_ENV(PT_REGS_SC(regs));
-	int err;
-
-	err = __copy_to_user((void __user *) buf, fxsave,
-			     sizeof(struct user_fxsr_struct));
-	if(err) return -EFAULT;
-	else return 0;
-}
-#endif
-
 int get_fpxregs(unsigned long buf, struct task_struct *tsk)
 {
 	return(CHOOSE_MODE(get_fpxregs_tt(buf, tsk), 0));
 }
 
-#ifdef CONFIG_MODE_TT
-int set_fpxregs_tt(unsigned long buf, struct task_struct *tsk)
-{
-	struct pt_regs *regs = &tsk->thread.regs;
-	struct i387_fxsave_struct *fxsave = SC_FXSR_ENV(PT_REGS_SC(regs));
-	int err;
-
-	err = __copy_from_user(fxsave, (void __user *) buf,
-			       sizeof(struct user_fxsr_struct) );
-	if(err) return -EFAULT;
-	else return 0;
-}
-#endif
-
 int set_fpxregs(unsigned long buf, struct task_struct *tsk)
 {
 	return(CHOOSE_MODE(set_fpxregs_tt(buf, tsk), 0));
@@ -387,25 +286,6 @@ int dump_fpu(struct pt_regs *regs, elf_f
 }
 #endif
 
-#ifdef CONFIG_MODE_TT
-static inline void copy_fpu_fxsave_tt(struct pt_regs *regs,
-				      struct user_i387_struct *buf)
-{
-	struct i387_fxsave_struct *fpu = SC_FXSR_ENV(PT_REGS_SC(regs));
-	unsigned short *to;
-	unsigned short *from;
-	int i;
-
-	memcpy( buf, fpu, 7 * sizeof(long) );
-
-	to = (unsigned short *) &buf->st_space[0];
-	from = (unsigned short *) &fpu->st_space[0];
-	for ( i = 0 ; i < 8 ; i++, to += 5, from += 8 ) {
-		memcpy( to, from, 5 * sizeof(unsigned short) );
-	}
-}
-#endif
-
 static inline void copy_fpu_fxsave(struct pt_regs *regs,
 				   struct user_i387_struct *buf)
 {
diff -puN arch/um/sys-i386/ptrace_user.c~uml-throw-out-config_mode_tt arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -43,89 +43,3 @@ int ptrace_setfpregs(long pid, unsigned 
 		return -errno;
 	return 0;
 }
-
-#ifdef UML_CONFIG_MODE_TT
-
-static void write_debugregs(int pid, unsigned long *regs)
-{
-	struct user *dummy;
-	int nregs, i;
-
-	dummy = NULL;
-	nregs = ARRAY_SIZE(dummy->u_debugreg);
-	for(i = 0; i < nregs; i++){
-		if((i == 4) || (i == 5)) continue;
-		if(ptrace(PTRACE_POKEUSR, pid, &dummy->u_debugreg[i],
-			  regs[i]) < 0)
-			printk("write_debugregs - ptrace failed on "
-			       "register %d, value = 0x%lx, errno = %d\n", i,
-			       regs[i], errno);
-	}
-}
-
-static void read_debugregs(int pid, unsigned long *regs)
-{
-	struct user *dummy;
-	int nregs, i;
-
-	dummy = NULL;
-	nregs = ARRAY_SIZE(dummy->u_debugreg);
-	for(i = 0; i < nregs; i++){
-		regs[i] = ptrace(PTRACE_PEEKUSR, pid,
-				 &dummy->u_debugreg[i], 0);
-	}
-}
-
-/* Accessed only by the tracing thread */
-static unsigned long kernel_debugregs[8] = { [ 0 ... 7 ] = 0 };
-
-void arch_enter_kernel(void *task, int pid)
-{
-	read_debugregs(pid, TASK_DEBUGREGS(task));
-	write_debugregs(pid, kernel_debugregs);
-}
-
-void arch_leave_kernel(void *task, int pid)
-{
-	read_debugregs(pid, kernel_debugregs);
-	write_debugregs(pid, TASK_DEBUGREGS(task));
-}
-
-#ifdef UML_CONFIG_PT_PROXY
-/* Accessed only by the tracing thread */
-static int debugregs_seq;
-
-/* Only called by the ptrace proxy */
-void ptrace_pokeuser(unsigned long addr, unsigned long data)
-{
-	if((addr < offsetof(struct user, u_debugreg[0])) ||
-	   (addr > offsetof(struct user, u_debugreg[7])))
-		return;
-	addr -= offsetof(struct user, u_debugreg[0]);
-	addr = addr >> 2;
-	if(kernel_debugregs[addr] == data) return;
-
-	kernel_debugregs[addr] = data;
-	debugregs_seq++;
-}
-
-static void update_debugregs_cb(void *arg)
-{
-	int pid = *((int *) arg);
-
-	write_debugregs(pid, kernel_debugregs);
-}
-
-/* Optimized out in its header when not defined */
-void update_debugregs(int seq)
-{
-	int me;
-
-	if(seq == debugregs_seq) return;
-
-	me = os_getpid();
-	initial_thread_cb(update_debugregs_cb, &me);
-}
-#endif
-
-#endif
diff -puN arch/um/sys-i386/signal.c~uml-throw-out-config_mode_tt arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/signal.c
@@ -13,9 +13,6 @@
 #include "sigcontext.h"
 #include "registers.h"
 #include "mode.h"
-
-#ifdef CONFIG_MODE_SKAS
-
 #include "skas.h"
 
 void copy_sc(union uml_pt_regs *regs, void *from)
@@ -108,61 +105,6 @@ int copy_sc_to_user_skas(struct sigconte
 	return copy_to_user(to, &sc, sizeof(sc)) ||
 	       copy_to_user(to_fp, fpregs, sizeof(fpregs));
 }
-#endif
-
-#ifdef CONFIG_MODE_TT
-
-/* These copy a sigcontext to/from userspace.  They copy the fpstate pointer,
- * blowing away the old, good one.  So, that value is saved, and then restored
- * after the sigcontext copy.  In copy_from, the variable holding the saved
- * fpstate pointer, and the sigcontext that it should be restored to are both
- * in the kernel, so we can just restore using an assignment.  In copy_to, the
- * saved pointer is in the kernel, but the sigcontext is in userspace, so we
- * copy_to_user it.
- */
-int copy_sc_from_user_tt(struct sigcontext *to, struct sigcontext __user *from,
-			 int fpsize)
-{
-	struct _fpstate *to_fp;
-	struct _fpstate __user *from_fp;
-	unsigned long sigs;
-	int err;
-
-	to_fp = to->fpstate;
-	sigs = to->oldmask;
-	err = copy_from_user(to, from, sizeof(*to));
-	from_fp = to->fpstate;
-	to->oldmask = sigs;
-	to->fpstate = to_fp;
-	if(to_fp != NULL)
-		err |= copy_from_user(to_fp, from_fp, fpsize);
-	return err;
-}
-
-int copy_sc_to_user_tt(struct sigcontext __user *to, struct _fpstate __user *fp,
-		       struct sigcontext *from, int fpsize, unsigned long sp)
-{
-	struct _fpstate __user *to_fp;
-	struct _fpstate *from_fp;
-	int err;
-
-	to_fp =	(fp ? fp : (struct _fpstate __user *) (to + 1));
-	from_fp = from->fpstate;
-	err = copy_to_user(to, from, sizeof(*to));
-
-	/* The SP in the sigcontext is the updated one for the signal
-	 * delivery.  The sp passed in is the original, and this needs
-	 * to be restored, so we stick it in separately.
-	 */
-	err |= copy_to_user(&SC_SP(to), &sp, sizeof(sp));
-
-	if(from_fp != NULL){
-		err |= copy_to_user(&to->fpstate, &to_fp, sizeof(to->fpstate));
-		err |= copy_to_user(to_fp, from_fp, fpsize);
-	}
-	return err;
-}
-#endif
 
 static int copy_sc_from_user(struct pt_regs *to, void __user *from)
 {
diff -puN arch/um/sys-i386/tls.c~uml-throw-out-config_mode_tt arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-i386/tls.c
@@ -18,10 +18,7 @@
 #include "mode_kern.h"
 #include "os.h"
 #include "mode.h"
-
-#ifdef CONFIG_MODE_SKAS
 #include "skas.h"
-#endif
 
 /*
  * If needed we can detect when it's uninitialized.
@@ -31,7 +28,6 @@
 static int host_supports_tls = -1;
 int host_gdt_entry_tls_min;
 
-#ifdef CONFIG_MODE_SKAS
 int do_set_thread_area_skas(struct user_desc *info)
 {
 	int ret;
@@ -53,7 +49,6 @@ int do_get_thread_area_skas(struct user_
 	put_cpu();
 	return ret;
 }
-#endif
 
 /*
  * sys_get_thread_area: get a yet unused TLS descriptor index.
@@ -187,17 +182,6 @@ int arch_switch_tls_skas(struct task_str
 	return 0;
 }
 
-int arch_switch_tls_tt(struct task_struct *from, struct task_struct *to)
-{
-	if (!host_supports_tls)
-		return 0;
-
-	if (needs_TLS_update(to))
-		return load_TLS(0, to);
-
-	return 0;
-}
-
 static int set_tls_entry(struct task_struct* task, struct user_desc *info,
 			 int idx, int flushed)
 {
diff -puN arch/um/sys-i386/unmap.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/sys-i386/unmap.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <linux/mman.h>
-#include <asm/unistd.h>
-
-static int errno;
-
-static inline _syscall2(int,munmap,void *,start,size_t,len)
-static inline _syscall6(void *,mmap2,void *,addr,size_t,len,int,prot,int,flags,int,fd,off_t,offset)
-int switcheroo(int fd, int prot, void *from, void *to, int size)
-{
-	if(munmap(to, size) < 0){
-		return(-1);
-	}
-	if(mmap2(to, size, prot, MAP_SHARED | MAP_FIXED, fd, 0) == (void*) -1 ){
-		return(-1);
-	}
-	if(munmap(from, size) < 0){
-		return(-1);
-	}
-	return(0);
-}
diff -puN arch/um/sys-x86_64/Makefile~uml-throw-out-config_mode_tt arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-x86_64/Makefile
@@ -5,10 +5,9 @@
 #
 
 obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
-	setjmp.o sigcontext.o signal.o syscalls.o syscall_table.o sysrq.o \
-	ksyms.o tls.o
+	setjmp.o sigcontext.o signal.o stub.o stub_segv.o syscalls.o \
+	syscall_table.o sysrq.o ksyms.o tls.o
 
-obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
 obj-$(CONFIG_MODULES) += um_module.o
 
 subarch-obj-y = lib/bitops.o lib/csum-partial.o lib/memcpy.o lib/thunk.o
@@ -21,11 +20,7 @@ USER_OBJS := ptrace_user.o sigcontext.o
 USER_OBJS += user-offsets.s
 extra-y += user-offsets.s
 
-extra-$(CONFIG_MODE_TT) += unmap.o
-
 UNPROFILE_OBJS := stub_segv.o
 CFLAGS_stub_segv.o := $(CFLAGS_NO_HARDENING)
 
 include arch/um/scripts/Makefile.rules
-
-$(obj)/unmap.%: _c_flags = $(call unprofile,$(CFLAGS))
diff -puN arch/um/sys-x86_64/signal.c~uml-throw-out-config_mode_tt arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-x86_64/signal.c
@@ -15,9 +15,6 @@
 #include "choose-mode.h"
 #include "sysdep/ptrace.h"
 #include "frame_kern.h"
-
-#ifdef CONFIG_MODE_SKAS
-
 #include "skas.h"
 
 void copy_sc(union uml_pt_regs *regs, void *from)
@@ -134,53 +131,6 @@ int copy_sc_to_user_skas(struct sigconte
 	return(err);
 }
 
-#endif
-
-#ifdef CONFIG_MODE_TT
-int copy_sc_from_user_tt(struct sigcontext *to, struct sigcontext __user *from,
-			 int fpsize)
-{
-	struct _fpstate *to_fp;
-	struct _fpstate __user *from_fp;
-	unsigned long sigs;
-	int err;
-
-	to_fp = to->fpstate;
-	sigs = to->oldmask;
-	err = copy_from_user(to, from, sizeof(*to));
-	from_fp = to->fpstate;
-	to->fpstate = to_fp;
-	to->oldmask = sigs;
-	if(to_fp != NULL)
-		err |= copy_from_user(to_fp, from_fp, fpsize);
-	return(err);
-}
-
-int copy_sc_to_user_tt(struct sigcontext __user *to, struct _fpstate __user *fp,
-		       struct sigcontext *from, int fpsize, unsigned long sp)
-{
-	struct _fpstate __user *to_fp;
-	struct _fpstate *from_fp;
-	int err;
-
-	to_fp = (fp ? fp : (struct _fpstate __user *) (to + 1));
-	from_fp = from->fpstate;
-	err = copy_to_user(to, from, sizeof(*to));
-	/* The SP in the sigcontext is the updated one for the signal
-	 * delivery.  The sp passed in is the original, and this needs
-	 * to be restored, so we stick it in separately.
-	 */
-	err |= copy_to_user(&SC_SP(to), &sp, sizeof(sp));
-
-	if(from_fp != NULL){
-		err |= copy_to_user(&to->fpstate, &to_fp, sizeof(to->fpstate));
-		err |= copy_to_user(to_fp, from_fp, fpsize);
-	}
-	return err;
-}
-
-#endif
-
 static int copy_sc_from_user(struct pt_regs *to, void __user *from)
 {
        int ret;
diff -puN arch/um/sys-x86_64/syscalls.c~uml-throw-out-config_mode_tt arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-throw-out-config_mode_tt
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -29,36 +29,6 @@ asmlinkage long sys_uname64(struct new_u
 	return err ? -EFAULT : 0;
 }
 
-#ifdef CONFIG_MODE_TT
-extern long arch_prctl(int code, unsigned long addr);
-
-static long arch_prctl_tt(int code, unsigned long addr)
-{
-	unsigned long tmp;
-	long ret;
-
-	switch(code){
-	case ARCH_SET_GS:
-	case ARCH_SET_FS:
-		ret = arch_prctl(code, addr);
-		break;
-	case ARCH_GET_FS:
-	case ARCH_GET_GS:
-		ret = arch_prctl(code, (unsigned long) &tmp);
-		if(!ret)
-			ret = put_user(tmp, (long __user *)addr);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return(ret);
-}
-#endif
-
-#ifdef CONFIG_MODE_SKAS
-
 long arch_prctl_skas(struct task_struct *task, int code,
                      unsigned long __user *addr)
 {
@@ -119,7 +89,6 @@ long arch_prctl_skas(struct task_struct 
 
 	return ret;
 }
-#endif
 
 long sys_arch_prctl(int code, unsigned long addr)
 {
diff -puN arch/um/sys-x86_64/unmap.c~uml-throw-out-config_mode_tt /dev/null
--- a/arch/um/sys-x86_64/unmap.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include <linux/mman.h>
-#include <asm/unistd.h>
-
-static int errno;
-
-static inline _syscall2(int,munmap,void *,start,size_t,len)
-static inline _syscall6(void *,mmap,void *,addr,size_t,len,int,prot,int,flags,int,fd,off_t,offset)
-int switcheroo(int fd, int prot, void *from, void *to, int size)
-{
-	if(munmap(to, size) < 0){
-		return(-1);
-	}
-	if(mmap(to, size, prot, MAP_SHARED | MAP_FIXED, fd, 0) == (void*) -1){
-		return(-1);
-	}
-	if(munmap(from, size) < 0){
-		return(-1);
-	}
-	return(0);
-}
diff -puN include/asm-um/mmu_context.h~uml-throw-out-config_mode_tt include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-throw-out-config_mode_tt
+++ a/include/asm-um/mmu_context.h
@@ -56,12 +56,6 @@ static inline void enter_lazy_tlb(struct
 extern int init_new_context_skas(struct task_struct *task, 
 				 struct mm_struct *mm);
 
-static inline int init_new_context_tt(struct task_struct *task, 
-				      struct mm_struct *mm)
-{
-	return(0);
-}
-
 static inline int init_new_context(struct task_struct *task, 
 				   struct mm_struct *mm)
 {
diff -puN include/asm-um/processor-generic.h~uml-throw-out-config_mode_tt include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-throw-out-config_mode_tt
+++ a/include/asm-um/processor-generic.h
@@ -34,20 +34,10 @@ struct thread_struct {
 	void *exec_buf;
 	struct arch_thread arch;
 	union {
-#ifdef CONFIG_MODE_TT
-		struct {
-			int extern_pid;
-			int tracing;
-			int switch_pipe[2];
-			int vm_seq;
-		} tt;
-#endif
-#ifdef CONFIG_MODE_SKAS
 		struct {
 			jmp_buf switch_buf;
 			int mm_count;
 		} skas;
-#endif
 	} mode;
 	struct {
 		int op;
@@ -136,12 +126,8 @@ extern struct cpuinfo_um cpu_data[];
 #endif
 
 
-#ifdef CONFIG_MODE_SKAS
 #define KSTK_REG(tsk, reg) \
 	get_thread_reg(reg, &tsk->thread.mode.skas.switch_buf)
-#else
-#define KSTK_REG(tsk, reg) (0xbadbabe)
-#endif
 #define get_wchan(p) (0)
 
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
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
