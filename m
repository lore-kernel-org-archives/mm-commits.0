From: akpm@linux-foundation.org
Subject: - uml-fix-linker-script-alignment-bugs.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:38 -0700
Message-ID: <200708311655.l7VGtcut017421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759050AbXHaQzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix linker script alignment bugs
has been removed from the -mm tree.  Its filename was
     uml-fix-linker-script-alignment-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix linker script alignment bugs
From: Jeff Dike <jdike@addtoit.com>

Fix a class of bugs in the UML linker scripts which caused section boundary
variables to sometimes not line up with their sections.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/dyn.lds.S    |   12 +--
 arch/um/kernel/uml.lds.S    |   11 +-
 include/asm-um/common.lds.S |  128 ++++++++++++++++++++--------------
 3 files changed, 92 insertions(+), 59 deletions(-)

diff -puN arch/um/kernel/dyn.lds.S~uml-fix-linker-script-alignment-bugs arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-fix-linker-script-alignment-bugs
+++ a/arch/um/kernel/dyn.lds.S
@@ -71,11 +71,13 @@ SECTIONS
     *(.gnu.warning)
 
     . = ALIGN(4096);
-    __syscall_stub_start = .;
-    *(.__syscall_stub*)
-    __syscall_stub_end = .;
-    . = ALIGN(4096);
   } =0x90909090
+  . = ALIGN(4096);
+  .syscall_stub : {
+	__syscall_stub_start = .;
+	*(.__syscall_stub*)
+	__syscall_stub_end = .;
+  }
   .fini           : {
     KEEP (*(.fini))
   } =0x90909090
@@ -138,8 +140,8 @@ SECTIONS
   .got            : { *(.got.plt) *(.got) }
   _edata = .;
   PROVIDE (edata = .);
-  __bss_start = .;
   .bss            : {
+   __bss_start = .;
    *(.dynbss)
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
diff -puN arch/um/kernel/uml.lds.S~uml-fix-linker-script-alignment-bugs arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-fix-linker-script-alignment-bugs
+++ a/arch/um/kernel/uml.lds.S
@@ -44,12 +44,13 @@ SECTIONS
     /* .gnu.warning sections are handled specially by elf32.em.  */
     *(.gnu.warning)
     *(.gnu.linkonce.t*)
+  }
 
-    . = ALIGN(4096);
-    __syscall_stub_start = .;
-    *(.__syscall_stub*)
-    __syscall_stub_end = .;
-    . = ALIGN(4096);
+  . = ALIGN(4096);
+  .syscall_stub : {
+	__syscall_stub_start = .;
+	*(.__syscall_stub*)
+	__syscall_stub_end = .;
   }
 
   #include "asm/common.lds.S"
diff -puN include/asm-um/common.lds.S~uml-fix-linker-script-alignment-bugs include/asm-um/common.lds.S
--- a/include/asm-um/common.lds.S~uml-fix-linker-script-alignment-bugs
+++ a/include/asm-um/common.lds.S
@@ -16,82 +16,112 @@
 
   . = ALIGN(4096);
   .note : { *(.note.*) }
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
+  __ex_table : {
+	__start___ex_table = .;
+	*(__ex_table)
+	__stop___ex_table = .;
+  }
 
   BUG_TABLE
 
-  __uml_setup_start = .;
-  .uml.setup.init : { *(.uml.setup.init) }
-  __uml_setup_end = .;
+  .uml.setup.init : {
+	__uml_setup_start = .;
+	*(.uml.setup.init)
+	__uml_setup_end = .;
+  }
 	
-  __uml_help_start = .;
-  .uml.help.init : { *(.uml.help.init) }
-  __uml_help_end = .;
+  .uml.help.init : {
+	__uml_help_start = .;
+	*(.uml.help.init)
+	__uml_help_end = .;
+  }
 	
-  __uml_postsetup_start = .;
-  .uml.postsetup.init : { *(.uml.postsetup.init) }
-  __uml_postsetup_end = .;
+  .uml.postsetup.init : {
+	__uml_postsetup_start = .;
+	*(.uml.postsetup.init)
+	__uml_postsetup_end = .;
+  }
 	
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
+  .init.setup : {
+	__setup_start = .;
+	*(.init.setup)
+	__setup_end = .;
+  }
 
   . = ALIGN(32);
-  __per_cpu_start = . ; 
-  .data.percpu : { *(.data.percpu) }
-  __per_cpu_end = . ;
+  .data.percpu : {
+	__per_cpu_start = . ;
+	*(.data.percpu)
+	__per_cpu_end = . ;
+  }
 	
-  __initcall_start = .;
   .initcall.init : {
+	__initcall_start = .;
 	INITCALLS
+	__initcall_end = .;
+  }
+
+  .con_initcall.init : {
+	__con_initcall_start = .;
+	*(.con_initcall.init)
+	__con_initcall_end = .;
   }
-  __initcall_end = .;
 
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-
-  __uml_initcall_start = .;
-  .uml.initcall.init : { *(.uml.initcall.init) }
-  __uml_initcall_end = .;
+  .uml.initcall.init : {
+	__uml_initcall_start = .;
+	*(.uml.initcall.init)
+	__uml_initcall_end = .;
+  }
   __init_end = .;
 
   SECURITY_INIT
 
-  __exitcall_begin = .;
-  .exitcall : { *(.exitcall.exit) }
-  __exitcall_end = .;
-
-  __uml_exitcall_begin = .;
-  .uml.exitcall : { *(.uml.exitcall.exit) }
-  __uml_exitcall_end = .;
+  .exitcall : {
+	__exitcall_begin = .;
+	*(.exitcall.exit)
+	__exitcall_end = .;
+  }
+
+  .uml.exitcall : {
+	__uml_exitcall_begin = .;
+	*(.uml.exitcall.exit)
+	__uml_exitcall_end = .;
+  }
 
   . = ALIGN(4);
-  __alt_instructions = .;
-  .altinstructions : { *(.altinstructions) }
-  __alt_instructions_end = .;
+  .altinstructions : {
+	__alt_instructions = .;
+	*(.altinstructions)
+	__alt_instructions_end = .;
+  }
   .altinstr_replacement : { *(.altinstr_replacement) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
   .exit.data : { *(.exit.data) }
 
-  __preinit_array_start = .;
-  .preinit_array : { *(.preinit_array) }
-  __preinit_array_end = .;
-  __init_array_start = .;
-  .init_array : { *(.init_array) }
-  __init_array_end = .;
-  __fini_array_start = .;
-  .fini_array : { *(.fini_array) }
-  __fini_array_end = .;
+  .preinit_array : {
+	__preinit_array_start = .;
+	*(.preinit_array)
+	__preinit_array_end = .;
+  }
+  .init_array : {
+	__init_array_start = .;
+	*(.init_array)
+	__init_array_end = .;
+  }
+  .fini_array : {
+	__fini_array_start = .;
+	*(.fini_array)
+	__fini_array_end = .;
+  }
 
    . = ALIGN(4096);
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
+  .init.ramfs : {
+	__initramfs_start = .;
+	*(.init.ramfs)
+	__initramfs_end = .;
+  }
 
   /* Sections to be discarded */
   /DISCARD/ : {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
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
