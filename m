From: akpm@linux-foundation.org
Subject: +
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch added to
 -mm tree
Date: Tue, 07 Jul 2015 14:16:37 -0700
Message-ID: <559c41b5.2aOONCOhQJFM4Chl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbbGGVQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: add new mlock, munlock, and munlockall system calls
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: add new mlock, munlock, and munlockall system calls

With the refactored mlock code, introduce new system calls for mlock,
munlock, and munlockall.  The new calls will allow the user to specify
what lock states are being added or cleared.  mlock2 and munlock2 are
trivial at the moment, but a follow on patch will add a new mlock state
making them useful.

munlock2 addresses a limitation of the current implementation.  If a user
calls mlockall(MCL_CURRENT | MCL_FUTURE) and then later decides that
MCL_FUTURE should be removed, they would have to call munlockall()
followed by mlockall(MCL_CURRENT) which could potentially be very
expensive.  The new munlockall2 system call allows a user to simply clear
the MCL_FUTURE flag.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/unistd.h        |    2 -
 arch/alpha/include/uapi/asm/mman.h     |    2 +
 arch/alpha/kernel/systbls.S            |    3 ++
 arch/arm/kernel/calls.S                |    3 ++
 arch/arm64/include/asm/unistd32.h      |    6 ++++
 arch/avr32/kernel/syscall_table.S      |    3 ++
 arch/blackfin/mach-common/entry.S      |    3 ++
 arch/cris/arch-v10/kernel/entry.S      |    3 ++
 arch/cris/arch-v32/kernel/entry.S      |    3 ++
 arch/frv/kernel/entry.S                |    3 ++
 arch/ia64/kernel/entry.S               |    3 ++
 arch/m32r/kernel/entry.S               |    3 ++
 arch/m32r/kernel/syscall_table.S       |    3 ++
 arch/m68k/kernel/syscalltable.S        |    3 ++
 arch/microblaze/kernel/syscall_table.S |    3 ++
 arch/mips/include/uapi/asm/mman.h      |    5 ++++
 arch/mips/kernel/scall32-o32.S         |    3 ++
 arch/mips/kernel/scall64-64.S          |    3 ++
 arch/mips/kernel/scall64-n32.S         |    3 ++
 arch/mips/kernel/scall64-o32.S         |    3 ++
 arch/mn10300/kernel/entry.S            |    3 ++
 arch/parisc/include/uapi/asm/mman.h    |    2 +
 arch/powerpc/include/uapi/asm/mman.h   |    2 +
 arch/s390/kernel/syscalls.S            |    3 ++
 arch/sh/kernel/syscalls_32.S           |    3 ++
 arch/sparc/include/uapi/asm/mman.h     |    2 +
 arch/sparc/kernel/systbls_32.S         |    2 -
 arch/sparc/kernel/systbls_64.S         |    4 +--
 arch/tile/include/uapi/asm/mman.h      |    5 ++++
 arch/x86/entry/syscalls/syscall_32.tbl |    3 ++
 arch/x86/entry/syscalls/syscall_64.tbl |    3 ++
 arch/xtensa/include/uapi/asm/mman.h    |    5 ++++
 arch/xtensa/include/uapi/asm/unistd.h  |    8 +++++-
 include/linux/syscalls.h               |    4 +++
 include/uapi/asm-generic/mman.h        |    2 +
 include/uapi/asm-generic/unistd.h      |    8 +++++-
 kernel/sys_ni.c                        |    3 ++
 mm/mlock.c                             |   28 +++++++++++++++++++++++
 38 files changed, 147 insertions(+), 6 deletions(-)

diff -puN arch/alpha/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/alpha/include/asm/unistd.h
--- a/arch/alpha/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/alpha/include/asm/unistd.h
@@ -3,7 +3,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define NR_SYSCALLS			514
+#define NR_SYSCALLS			517
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
diff -puN arch/alpha/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -38,6 +38,8 @@
 #define MCL_CURRENT	 8192		/* lock all currently mapped pages */
 #define MCL_FUTURE	16384		/* lock all additions to address space */
 
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
diff -puN arch/alpha/kernel/systbls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/alpha/kernel/systbls.S
@@ -532,6 +532,9 @@ sys_call_table:
 	.quad sys_getrandom
 	.quad sys_memfd_create
 	.quad sys_execveat
+	.quad sys_mlock2
+	.quad sys_munlock2			/* 515 */
+	.quad sys_munlockall2
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
diff -puN arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/arm/kernel/calls.S
@@ -397,6 +397,9 @@
 /* 385 */	CALL(sys_memfd_create)
 		CALL(sys_bpf)
 		CALL(sys_execveat)
+		CALL(sys_mlock2)
+		CALL(sys_munlock2)
+/* 400 */	CALL(sys_munlockall2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff -puN arch/arm64/include/asm/unistd32.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/arm64/include/asm/unistd32.h
--- a/arch/arm64/include/asm/unistd32.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/arm64/include/asm/unistd32.h
@@ -797,3 +797,9 @@ __SYSCALL(__NR_memfd_create, sys_memfd_c
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 387
 __SYSCALL(__NR_execveat, compat_sys_execveat)
+#define __NR_mlock2 388
+__SYSCALL(__NR_mlock2, sys_mlock2)
+#define __NR_munlock2 389
+__SYSCALL(__NR_munlock2, sys_munlock2)
+#define __NR_munlockall2 390
+__SYSCALL(__NR_munlockall2, sys_munlockall2)
diff -puN arch/avr32/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/avr32/kernel/syscall_table.S
--- a/arch/avr32/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/avr32/kernel/syscall_table.S
@@ -334,4 +334,7 @@ sys_call_table:
 	.long	sys_memfd_create
 	.long	sys_bpf
 	.long	sys_execveat		/* 320 */
+	.long   sys_mlock2
+	.long   sys_munlock2
+	.long   sys_munlockall2
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff -puN arch/blackfin/mach-common/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/blackfin/mach-common/entry.S
--- a/arch/blackfin/mach-common/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/blackfin/mach-common/entry.S
@@ -1704,6 +1704,9 @@ ENTRY(_sys_call_table)
 	.long _sys_memfd_create		/* 390 */
 	.long _sys_bpf
 	.long _sys_execveat
+	.long _sys_mlock2
+	.long _sys_munlock2
+	.long _sys_munlockall2		/* 395 */
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
diff -puN arch/cris/arch-v10/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -955,6 +955,9 @@ sys_call_table:
 	.long sys_process_vm_writev
 	.long sys_kcmp			/* 350 */
 	.long sys_finit_module
+	.long sys_mlock2
+	.long sys_munlock2
+	.long sys_munlockall2
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff -puN arch/cris/arch-v32/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/cris/arch-v32/kernel/entry.S
--- a/arch/cris/arch-v32/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/cris/arch-v32/kernel/entry.S
@@ -875,6 +875,9 @@ sys_call_table:
 	.long sys_process_vm_writev
 	.long sys_kcmp			/* 350 */
 	.long sys_finit_module
+	.long sys_mlock2
+	.long sys_munlock2
+	.long sys_munlockall2
 
 	/*
 	 * NOTE!! This doesn't have to be exact - we just have
diff -puN arch/frv/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/frv/kernel/entry.S
@@ -1515,5 +1515,8 @@ sys_call_table:
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_setns
+	.long sys_mlock2
+	.long sys_munlock2
+	.long sys_munlockall2		/* 340 */
 
 syscall_table_size = (. - sys_call_table)
diff -puN arch/ia64/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/ia64/kernel/entry.S
--- a/arch/ia64/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/ia64/kernel/entry.S
@@ -1768,5 +1768,8 @@ sys_call_table:
 	data8 sys_memfd_create			// 1340
 	data8 sys_bpf
 	data8 sys_execveat
+	data8 sys_mlock2
+	data8 sys_munlock2
+	data8 sys_munlockall2			// 1345
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
diff -puN arch/m32r/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/m32r/kernel/entry.S
--- a/arch/m32r/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/m32r/kernel/entry.S
@@ -76,6 +76,9 @@
 #define sys_munlock		sys_ni_syscall
 #define sys_mlockall		sys_ni_syscall
 #define sys_munlockall		sys_ni_syscall
+#define sys_mlock2		sys_ni_syscall
+#define sys_munlock2		sys_ni_syscall
+#define sys_munlockall2		sys_ni_syscall
 #define sys_mremap		sys_ni_syscall
 #define sys_mincore		sys_ni_syscall
 #define sys_remap_file_pages	sys_ni_syscall
diff -puN arch/m32r/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/m32r/kernel/syscall_table.S
--- a/arch/m32r/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/m32r/kernel/syscall_table.S
@@ -325,3 +325,6 @@ ENTRY(sys_call_table)
 	.long sys_eventfd
 	.long sys_fallocate
 	.long sys_setns			/* 325 */
+	.long sys_mlock2
+	.long sys_munlock2
+	.long sys_munlockall2
diff -puN arch/m68k/kernel/syscalltable.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/m68k/kernel/syscalltable.S
--- a/arch/m68k/kernel/syscalltable.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/m68k/kernel/syscalltable.S
@@ -376,4 +376,7 @@ ENTRY(sys_call_table)
 	.long sys_memfd_create
 	.long sys_bpf
 	.long sys_execveat		/* 355 */
+	.long sys_mlock2
+	.long sys_munlock2
+	.long sys_munlockall2
 
diff -puN arch/microblaze/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/microblaze/kernel/syscall_table.S
--- a/arch/microblaze/kernel/syscall_table.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/microblaze/kernel/syscall_table.S
@@ -389,3 +389,6 @@ ENTRY(sys_call_table)
 	.long sys_memfd_create
 	.long sys_bpf
 	.long sys_execveat
+	.long sys_mlock2
+	.long sys_munlock2		/* 390 */
+	.long sys_munlockall2
diff -puN arch/mips/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -62,6 +62,11 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
+/*
+ * Flags for mlock
+ */
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
diff -puN arch/mips/kernel/scall32-o32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mips/kernel/scall32-o32.S
--- a/arch/mips/kernel/scall32-o32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mips/kernel/scall32-o32.S
@@ -582,3 +582,6 @@ EXPORT(sys_call_table)
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 4355 */
 	PTR	sys_execveat
+	PTR	sys_mlock2
+	PTR	sys_munlock2
+	PTR	sys_munlockall2
diff -puN arch/mips/kernel/scall64-64.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mips/kernel/scall64-64.S
--- a/arch/mips/kernel/scall64-64.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mips/kernel/scall64-64.S
@@ -436,4 +436,7 @@ EXPORT(sys_call_table)
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 5315 */
 	PTR	sys_execveat
+	PTR	sys_mlock2
+	PTR	sys_munlock2
+	PTR	sys_munlockall2
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/mips/kernel/scall64-n32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mips/kernel/scall64-n32.S
@@ -429,4 +429,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_memfd_create
 	PTR	sys_bpf
 	PTR	compat_sys_execveat		/* 6320 */
+	PTR	sys_mlock2
+	PTR	sys_munlock2
+	PTR	sys_munlockall2
 	.size	sysn32_call_table,.-sysn32_call_table
diff -puN arch/mips/kernel/scall64-o32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mips/kernel/scall64-o32.S
@@ -567,4 +567,7 @@ EXPORT(sys32_call_table)
 	PTR	sys_memfd_create
 	PTR	sys_bpf				/* 4355 */
 	PTR	compat_sys_execveat
+	PTR	sys_mlock2
+	PTR	sys_munlock2
+	PTR	sys_munlockall2
 	.size	sys32_call_table,.-sys32_call_table
diff -puN arch/mn10300/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/mn10300/kernel/entry.S
--- a/arch/mn10300/kernel/entry.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/mn10300/kernel/entry.S
@@ -767,6 +767,9 @@ ENTRY(sys_call_table)
 	.long sys_perf_event_open
 	.long sys_recvmmsg
 	.long sys_setns
+	.long sys_mlock2		/* 340 */
+	.long sys_munlock2
+	.long sys_munlockall2
 
 
 nr_syscalls=(.-sys_call_table)/4
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -32,6 +32,8 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MADV_NORMAL     0               /* no further special treatment */
 #define MADV_RANDOM     1               /* expect random page references */
 #define MADV_SEQUENTIAL 2               /* expect sequential page references */
diff -puN arch/powerpc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/powerpc/include/uapi/asm/mman.h
--- a/arch/powerpc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/powerpc/include/uapi/asm/mman.h
@@ -23,6 +23,8 @@
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
 
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
diff -puN arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/s390/kernel/syscalls.S
@@ -363,3 +363,6 @@ SYSCALL(sys_bpf,compat_sys_bpf)
 SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
 SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
 SYSCALL(sys_execveat,compat_sys_execveat)
+SYSCALL(sys_mlock2,compat_sys_mlock2)			/* 355 */
+SYSCALL(sys_munlock2,compat_sys_munlock2)
+SYSCALL(sys_munlockall2,compat_sys_munlockall2)
diff -puN arch/sh/kernel/syscalls_32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/sh/kernel/syscalls_32.S
--- a/arch/sh/kernel/syscalls_32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/sh/kernel/syscalls_32.S
@@ -386,3 +386,6 @@ ENTRY(sys_call_table)
 	.long sys_process_vm_writev
 	.long sys_kcmp
 	.long sys_finit_module
+	.long sys_mlock2
+	.long sys_munlock2		/* 370 */
+	.long sys_munlockall2
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -18,6 +18,8 @@
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
 
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
diff -puN arch/sparc/kernel/systbls_32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/sparc/kernel/systbls_32.S
--- a/arch/sparc/kernel/systbls_32.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/sparc/kernel/systbls_32.S
@@ -87,4 +87,4 @@ sys_call_table:
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 /*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.long sys_execveat
+/*350*/	.long sys_execveat, sys_mlock2, sys_munlock2, sys_munlockall2
diff -puN arch/sparc/kernel/systbls_64.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/sparc/kernel/systbls_64.S
@@ -88,7 +88,7 @@ sys_call_table32:
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys32_execveat
+/*350*/	.word sys32_execveat, sys_mlock2, sys_munlock2, sys_munlockall2
 
 #endif /* CONFIG_COMPAT */
 
@@ -168,4 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys64_execveat
+/*350*/	.word sys64_execveat, sys_mlock2, sys_munlock2, sys_munlockall2
diff -puN arch/tile/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/tile/include/uapi/asm/mman.h
--- a/arch/tile/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/tile/include/uapi/asm/mman.h
@@ -37,5 +37,10 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
+/*
+ * Flags for mlock
+ */
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 
 #endif /* _ASM_TILE_MMAN_H */
diff -puN arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -365,3 +365,6 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	mlock2			sys_mlock2
+360	i386	munlock2		sys_munlock2
+361	i386	munlockall2		sys_munlockall2
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -329,6 +329,9 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	mlock2			sys_mlock2
+324	common	munlock2		sys_munlock2
+325	common	munlockall2		sys_munlockall2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -75,6 +75,11 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
+/*
+ * Flags for mlock
+ */
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
diff -puN arch/xtensa/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls arch/xtensa/include/uapi/asm/unistd.h
--- a/arch/xtensa/include/uapi/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/arch/xtensa/include/uapi/asm/unistd.h
@@ -753,8 +753,14 @@ __SYSCALL(339, sys_memfd_create, 2)
 __SYSCALL(340, sys_bpf, 3)
 #define __NR_execveat				341
 __SYSCALL(341, sys_execveat, 5)
+#define __NR_mlock2				342
+__SYSCALL(342, sys_mlock2, 3)
+#define __NR_munlock2				343
+__SYSCALL(342, sys_munlock2, 3)
+#define __NR_munlockall2			344
+__SYSCALL(342, sys_munlock2, 1)
 
-#define __NR_syscall_count			342
+#define __NR_syscall_count			345
 
 /*
  * sysxtensa syscall handler
diff -puN include/linux/syscalls.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls include/linux/syscalls.h
--- a/include/linux/syscalls.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/include/linux/syscalls.h
@@ -884,4 +884,8 @@ asmlinkage long sys_execveat(int dfd, co
 			const char __user *const __user *argv,
 			const char __user *const __user *envp, int flags);
 
+asmlinkage long sys_mlock2(unsigned long start, size_t len, int flags);
+asmlinkage long sys_munlock2(unsigned long start, size_t len, int flags);
+asmlinkage long sys_munlockall2(int flags);
+
 #endif
diff -puN include/uapi/asm-generic/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/include/uapi/asm-generic/mman.h
@@ -18,4 +18,6 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
+#define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+
 #endif /* __ASM_GENERIC_MMAN_H */
diff -puN include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,15 @@ __SYSCALL(__NR_memfd_create, sys_memfd_c
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_mlock2 282
+__SYSCALL(__NR_mlock2, sys_mlock2)
+#define __NR_munlock2 283
+__SYSCALL(__NR_munlock2, sys_munlock2)
+#define __NR_munlockall2 284
+__SYSCALL(__NR_munlockall2, sys_munlockall2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 285
 
 /*
  * All syscalls below here should go away really,
diff -puN kernel/sys_ni.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls kernel/sys_ni.c
--- a/kernel/sys_ni.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/kernel/sys_ni.c
@@ -193,6 +193,9 @@ cond_syscall(sys_mlock);
 cond_syscall(sys_munlock);
 cond_syscall(sys_mlockall);
 cond_syscall(sys_munlockall);
+cond_syscall(sys_mlock2);
+cond_syscall(sys_munlock2);
+cond_syscall(sys_munlockall2);
 cond_syscall(sys_mincore);
 cond_syscall(sys_madvise);
 cond_syscall(sys_mremap);
diff -puN mm/mlock.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls
+++ a/mm/mlock.c
@@ -648,6 +648,14 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	return do_mlock(start, len, VM_LOCKED);
 }
 
+SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
+{
+	if (!flags || flags & ~MLOCK_LOCKED)
+		return -EINVAL;
+
+	return do_mlock(start, len, VM_LOCKED);
+}
+
 static int do_munlock(unsigned long start, size_t len, vm_flags_t flags)
 {
 	int ret;
@@ -667,6 +675,13 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	return do_munlock(start, len, VM_LOCKED);
 }
 
+SYSCALL_DEFINE3(munlock2, unsigned long, start, size_t, len, int, flags)
+{
+	if (!flags || flags & ~MLOCK_LOCKED)
+		return -EINVAL;
+	return do_munlock(start, len, VM_LOCKED);
+}
+
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
@@ -755,6 +770,19 @@ SYSCALL_DEFINE0(munlockall)
 	up_write(&current->mm->mmap_sem);
 	return ret;
 }
+
+SYSCALL_DEFINE1(munlockall2, int, flags)
+{
+	int ret = -EINVAL;
+
+	if (!flags || flags & ~(MCL_CURRENT | MCL_FUTURE))
+		return ret;
+
+	down_write(&current->mm->mmap_sem);
+	ret = do_munlockall(flags);
+	up_write(&current->mm->mmap_sem);
+	return ret;
+}
 
 /*
  * Objects with different lifetime than processes (SHM_LOCK and SHM_HUGETLB
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch

