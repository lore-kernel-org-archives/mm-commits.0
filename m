From: akpm@linux-foundation.org
Subject: [merged] expert-kconfig-menu-fix-broken-expert-menu.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:27:19 -0800
Message-ID: <20171120212719.kj6_3a1nv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbdKTV1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ast@kernel.org, daniel@iogearbox.net, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: EXPERT Kconfig menu: fix broken EXPERT menu
has been removed from the -mm tree.  Its filename was
     expert-kconfig-menu-fix-broken-expert-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: EXPERT Kconfig menu: fix broken EXPERT menu

Clean up the EXPERT menu (yet again).

Move FHANDLE and CHECKPOINT_RESTORE into the primary EXPERT menu since
they already depend on EXPERT.

Move BPF_SYSCALL and USERFAULTFD out of the EXPERT Kconfig symbols menu
list since they do not depend on EXPERT and were breaking the continuity
of that menu list.

Move all of the KALLSYMS Kconfig symbols to the end of the EXPERT menu. 
This separates the kernel services from the build options.

This patch depends on [PATCH] pci: move PCI_QUIRKS to the PCI bus menu
(https://lkml.org/lkml/2017/11/2/907).

Link: http://lkml.kernel.org/r/72e4465a-a5ff-cb3c-1a90-11aa4861b161@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>	[BPF]
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |  184 ++++++++++++++++++++++++-------------------------
 1 file changed, 93 insertions(+), 91 deletions(-)

diff -puN init/Kconfig~expert-kconfig-menu-fix-broken-expert-menu init/Kconfig
--- a/init/Kconfig~expert-kconfig-menu-fix-broken-expert-menu
+++ a/init/Kconfig
@@ -283,19 +283,6 @@ config CROSS_MEMORY_ATTACH
 	  to directly read from or write to another process' address space.
 	  See the man page for more details.
 
-config FHANDLE
-	bool "open by fhandle syscalls" if EXPERT
-	select EXPORTFS
-	default y
-	help
-	  If you say Y here, a user level program will be able to map
-	  file names to handle and then later use the handle for
-	  different file system operations. This is useful in implementing
-	  userspace file servers, which now track files using handles instead
-	  of names. The handle would remain the same even if file names
-	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
-	  syscalls.
-
 config USELIB
 	bool "uselib syscall"
 	def_bool ALPHA || M68K || SPARC || X86_32 || IA32_EMULATION
@@ -883,18 +870,6 @@ config SOCK_CGROUP_DATA
 
 endif # CGROUPS
 
-config CHECKPOINT_RESTORE
-	bool "Checkpoint/restore support" if EXPERT
-	select PROC_CHILDREN
-	default n
-	help
-	  Enables additional kernel features in a sake of checkpoint/restore.
-	  In particular it adds auxiliary prctl codes to setup process text,
-	  data and heap segment sizes, and a few additional /proc filesystem
-	  entries.
-
-	  If unsure, say N here.
-
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
 	depends on MULTIUSER
@@ -1163,6 +1138,19 @@ config SYSCTL_SYSCALL
 
 	  If unsure say N here.
 
+config FHANDLE
+	bool "open by fhandle syscalls" if EXPERT
+	select EXPORTFS
+	default y
+	help
+	  If you say Y here, a user level program will be able to map
+	  file names to handle and then later use the handle for
+	  different file system operations. This is useful in implementing
+	  userspace file servers, which now track files using handles instead
+	  of names. The handle would remain the same even if file names
+	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
+	  syscalls.
+
 config POSIX_TIMERS
 	bool "Posix Clocks & timers" if EXPERT
 	default y
@@ -1180,54 +1168,6 @@ config POSIX_TIMERS
 
 	  If unsure say y.
 
-config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EXPERT
-	 default y
-	 help
-	   Say Y here to let the kernel print out symbolic crash information and
-	   symbolic stack backtraces. This increases the size of the kernel
-	   somewhat, as all symbols have to be loaded into the kernel image.
-
-config KALLSYMS_ALL
-	bool "Include all symbols in kallsyms"
-	depends on DEBUG_KERNEL && KALLSYMS
-	help
-	   Normally kallsyms only contains the symbols of functions for nicer
-	   OOPS messages and backtraces (i.e., symbols from the text and inittext
-	   sections). This is sufficient for most cases. And only in very rare
-	   cases (e.g., when a debugger is used) all symbols are required (e.g.,
-	   names of variables from the data sections, etc).
-
-	   This option makes sure that all symbols are loaded into the kernel
-	   image (i.e., symbols from all sections) in cost of increased kernel
-	   size (depending on the kernel configuration, it may be 300KiB or
-	   something like this).
-
-	   Say N unless you really need all symbols.
-
-config KALLSYMS_ABSOLUTE_PERCPU
-	bool
-	depends on KALLSYMS
-	default X86_64 && SMP
-
-config KALLSYMS_BASE_RELATIVE
-	bool
-	depends on KALLSYMS
-	default !IA64 && !(TILE && 64BIT)
-	help
-	  Instead of emitting them as absolute values in the native word size,
-	  emit the symbol references in the kallsyms table as 32-bit entries,
-	  each containing a relative value in the range [base, base + U32_MAX]
-	  or, when KALLSYMS_ABSOLUTE_PERCPU is in effect, each containing either
-	  an absolute value in the range [0, S32_MAX] or a relative value in the
-	  range [base, base + S32_MAX], where base is the lowest relative symbol
-	  address encountered in the image.
-
-	  On 64-bit builds, this reduces the size of the address table by 50%,
-	  but more importantly, it results in entries whose values are build
-	  time constants, and no relocation pass is required at runtime to fix
-	  up the entries based on the runtime load address of the kernel.
-
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
@@ -1339,16 +1279,6 @@ config EVENTFD
 
 	  If unsure, say Y.
 
-# syscall, maps, verifier
-config BPF_SYSCALL
-	bool "Enable bpf() system call"
-	select ANON_INODES
-	select BPF
-	default n
-	help
-	  Enable the bpf() system call that allows to manipulate eBPF
-	  programs and maps via file descriptors.
-
 config SHMEM
 	bool "Use full shmem filesystem" if EXPERT
 	default y
@@ -1378,14 +1308,6 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
-config USERFAULTFD
-	bool "Enable userfaultfd() system call"
-	select ANON_INODES
-	depends on MMU
-	help
-	  Enable the userfaultfd() system call that allows to intercept and
-	  handle page faults in userland.
-
 config MEMBARRIER
 	bool "Enable membarrier() system call" if EXPERT
 	default y
@@ -1398,6 +1320,86 @@ config MEMBARRIER
 
 	  If unsure, say Y.
 
+config CHECKPOINT_RESTORE
+	bool "Checkpoint/restore support" if EXPERT
+	select PROC_CHILDREN
+	default n
+	help
+	  Enables additional kernel features in a sake of checkpoint/restore.
+	  In particular it adds auxiliary prctl codes to setup process text,
+	  data and heap segment sizes, and a few additional /proc filesystem
+	  entries.
+
+	  If unsure, say N here.
+
+config KALLSYMS
+	 bool "Load all symbols for debugging/ksymoops" if EXPERT
+	 default y
+	 help
+	   Say Y here to let the kernel print out symbolic crash information and
+	   symbolic stack backtraces. This increases the size of the kernel
+	   somewhat, as all symbols have to be loaded into the kernel image.
+
+config KALLSYMS_ALL
+	bool "Include all symbols in kallsyms"
+	depends on DEBUG_KERNEL && KALLSYMS
+	help
+	   Normally kallsyms only contains the symbols of functions for nicer
+	   OOPS messages and backtraces (i.e., symbols from the text and inittext
+	   sections). This is sufficient for most cases. And only in very rare
+	   cases (e.g., when a debugger is used) all symbols are required (e.g.,
+	   names of variables from the data sections, etc).
+
+	   This option makes sure that all symbols are loaded into the kernel
+	   image (i.e., symbols from all sections) in cost of increased kernel
+	   size (depending on the kernel configuration, it may be 300KiB or
+	   something like this).
+
+	   Say N unless you really need all symbols.
+
+config KALLSYMS_ABSOLUTE_PERCPU
+	bool
+	depends on KALLSYMS
+	default X86_64 && SMP
+
+config KALLSYMS_BASE_RELATIVE
+	bool
+	depends on KALLSYMS
+	default !IA64 && !(TILE && 64BIT)
+	help
+	  Instead of emitting them as absolute values in the native word size,
+	  emit the symbol references in the kallsyms table as 32-bit entries,
+	  each containing a relative value in the range [base, base + U32_MAX]
+	  or, when KALLSYMS_ABSOLUTE_PERCPU is in effect, each containing either
+	  an absolute value in the range [0, S32_MAX] or a relative value in the
+	  range [base, base + S32_MAX], where base is the lowest relative symbol
+	  address encountered in the image.
+
+	  On 64-bit builds, this reduces the size of the address table by 50%,
+	  but more importantly, it results in entries whose values are build
+	  time constants, and no relocation pass is required at runtime to fix
+	  up the entries based on the runtime load address of the kernel.
+
+# end of the "standard kernel features (expert users)" menu
+
+# syscall, maps, verifier
+config BPF_SYSCALL
+	bool "Enable bpf() system call"
+	select ANON_INODES
+	select BPF
+	default n
+	help
+	  Enable the bpf() system call that allows to manipulate eBPF
+	  programs and maps via file descriptors.
+
+config USERFAULTFD
+	bool "Enable userfaultfd() system call"
+	select ANON_INODES
+	depends on MMU
+	help
+	  Enable the userfaultfd() system call that allows to intercept and
+	  handle page faults in userland.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
_

Patches currently in -mm which might be from rdunlap@infradead.org are


