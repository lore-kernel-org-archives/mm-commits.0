From: akpm@linux-foundation.org
Subject: - aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:00 -0800
Message-ID: <200802082014.m18KEf2Y010474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbYBHUxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:53:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     aout: remove unnecessary inclusions of {asm, linux}/a.out.h
has been removed from the -mm tree.  Its filename was
     aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aout: remove unnecessary inclusions of {asm, linux}/a.out.h
From: David Howells <dhowells@redhat.com>

Remove now unnecessary inclusions of {asm,linux}/a.out.h.

[akpm@linux-foundation.org: fix alpha build]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c         |    1 -
 arch/alpha/kernel/process.c         |    1 -
 arch/alpha/kernel/setup.c           |    1 -
 arch/arm/kernel/process.c           |    1 -
 arch/blackfin/kernel/process.c      |    1 -
 arch/m68k/kernel/process.c          |    1 -
 arch/m68k/kernel/traps.c            |    1 -
 arch/sparc/kernel/process.c         |    1 -
 arch/sparc/kernel/setup.c           |    1 -
 arch/sparc/kernel/sparc_ksyms.c     |    1 -
 arch/sparc/mm/loadmmu.c             |    1 -
 arch/sparc/mm/srmmu.c               |    1 -
 arch/sparc64/kernel/binfmt_elf32.c  |    2 --
 arch/sparc64/kernel/process.c       |    1 -
 arch/sparc64/kernel/setup.c         |    1 -
 arch/sparc64/kernel/sparc64_ksyms.c |    1 -
 arch/sparc64/kernel/sys_sparc.c     |    1 -
 arch/sparc64/kernel/sys_sparc32.c   |    1 -
 arch/um/kernel/ksyms.c              |    1 -
 arch/x86/kernel/process_32.c        |    1 -
 arch/x86/kernel/process_64.c        |    1 -
 arch/x86/kernel/setup_64.c          |    1 -
 drivers/ide/ppc/mpc8xx.c            |    1 -
 fs/binfmt_flat.c                    |    1 -
 fs/binfmt_som.c                     |    1 -
 fs/proc/kcore.c                     |    1 -
 fs/proc/vmcore.c                    |    1 -
 include/asm-sparc/uaccess.h         |    1 -
 include/asm-sparc64/processor.h     |    1 -
 include/asm-sparc64/uaccess.h       |    1 -
 30 files changed, 31 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/alpha/kernel/osf_sys.c
@@ -22,7 +22,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/timex.h>
diff -puN arch/alpha/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/alpha/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
diff -puN arch/alpha/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/alpha/kernel/setup.c
@@ -18,7 +18,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
diff -puN arch/arm/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/arm/kernel/process.c
@@ -18,7 +18,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
diff -puN arch/blackfin/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/blackfin/kernel/process.c
@@ -31,7 +31,6 @@
 #include <linux/smp_lock.h>
 #include <linux/unistd.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/err.h>
diff -puN arch/m68k/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/m68k/kernel/process.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
diff -puN arch/m68k/kernel/traps.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/m68k/kernel/traps.c
--- a/arch/m68k/kernel/traps.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/m68k/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/user.h>
 #include <linux/string.h>
 #include <linux/linkage.h>
diff -puN arch/sparc/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc/kernel/process.c
--- a/arch/sparc/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
diff -puN arch/sparc/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc/kernel/setup.c
--- a/arch/sparc/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc/kernel/setup.c
@@ -16,7 +16,6 @@
 #include <linux/initrd.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff -puN arch/sparc/kernel/sparc_ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc/kernel/sparc_ksyms.c
--- a/arch/sparc/kernel/sparc_ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc/kernel/sparc_ksyms.c
@@ -51,7 +51,6 @@
 #ifdef CONFIG_PCI
 #include <asm/ebus.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/io-unit.h>
 #include <asm/bug.h>
 
diff -puN arch/sparc/mm/loadmmu.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc/mm/loadmmu.c
--- a/arch/sparc/mm/loadmmu.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc/mm/loadmmu.c
@@ -14,7 +14,6 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/oplib.h>
 
diff -puN arch/sparc/mm/srmmu.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc/mm/srmmu.c
@@ -34,7 +34,6 @@
 #include <asm/sbus.h>
 #include <asm/asi.h>
 #include <asm/msi.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/io-unit.h>
 #include <asm/cacheflush.h>
diff -puN arch/sparc64/kernel/binfmt_elf32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/binfmt_elf32.c
--- a/arch/sparc64/kernel/binfmt_elf32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/binfmt_elf32.c
@@ -128,8 +128,6 @@ MODULE_AUTHOR("Eric Youngdale, David S. 
 #undef MODULE_DESCRIPTION
 #undef MODULE_AUTHOR
 
-#include <asm/a.out.h>
-
 #undef TASK_SIZE
 #define TASK_SIZE STACK_TOP32
 
diff -puN arch/sparc64/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/process.c
--- a/arch/sparc64/kernel/process.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/process.c
@@ -24,7 +24,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/compat.h>
diff -puN arch/sparc64/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/setup.c
--- a/arch/sparc64/kernel/setup.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/setup.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff -puN arch/sparc64/kernel/sparc64_ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/sparc64_ksyms.c
--- a/arch/sparc64/kernel/sparc64_ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,7 +53,6 @@
 #include <asm/ebus.h>
 #include <asm/isa.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
diff -puN arch/sparc64/kernel/sys_sparc.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/sys_sparc.c
--- a/arch/sparc64/kernel/sys_sparc.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/sys_sparc.c
@@ -28,7 +28,6 @@
 #include <asm/uaccess.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
-#include <asm/a.out.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff -puN arch/sparc64/kernel/sys_sparc32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -57,7 +57,6 @@
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
 #include <asm/mmu_context.h>
-#include <asm/a.out.h>
 #include <asm/compat_signal.h>
 
 asmlinkage long sys32_chown16(const char __user * filename, u16 user, u16 group)
diff -puN arch/um/kernel/ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/um/kernel/ksyms.c
@@ -5,7 +5,6 @@
 
 #include "linux/module.h"
 #include "linux/syscalls.h"
-#include "asm/a.out.h"
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
 #include "as-layout.h"
diff -puN arch/x86/kernel/process_32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/x86/kernel/process_32.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
 #include <linux/delay.h>
diff -puN arch/x86/kernel/process_64.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/x86/kernel/process_64.c
@@ -26,7 +26,6 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
 #include <linux/delay.h>
diff -puN arch/x86/kernel/setup_64.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/arch/x86/kernel/setup_64.c
@@ -15,7 +15,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff -puN drivers/ide/ppc/mpc8xx.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth drivers/ide/ppc/mpc8xx.c
--- a/drivers/ide/ppc/mpc8xx.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/drivers/ide/ppc/mpc8xx.c
@@ -17,7 +17,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/major.h>
 #include <linux/interrupt.h>
diff -puN fs/binfmt_flat.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/fs/binfmt_flat.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/string.h>
diff -puN fs/binfmt_som.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth fs/binfmt_som.c
--- a/fs/binfmt_som.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/fs/binfmt_som.c
@@ -29,7 +29,6 @@
 #include <linux/personality.h>
 #include <linux/init.h>
 
-#include <asm/a.out.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
diff -puN fs/proc/kcore.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth fs/proc/kcore.c
--- a/fs/proc/kcore.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/fs/proc/kcore.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/capability.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
diff -puN fs/proc/vmcore.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/fs/proc/vmcore.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
 #include <linux/highmem.h>
diff -puN include/asm-sparc/uaccess.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth include/asm-sparc/uaccess.h
--- a/include/asm-sparc/uaccess.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/include/asm-sparc/uaccess.h
@@ -13,7 +13,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <asm/vac-ops.h>
-#include <asm/a.out.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff -puN include/asm-sparc64/processor.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth include/asm-sparc64/processor.h
--- a/include/asm-sparc64/processor.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/include/asm-sparc64/processor.h
@@ -14,7 +14,6 @@
 #define current_text_addr() ({ void *pc; __asm__("rd %%pc, %0" : "=r" (pc)); pc; })
 
 #include <asm/asi.h>
-#include <asm/a.out.h>
 #include <asm/pstate.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
diff -puN include/asm-sparc64/uaccess.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth include/asm-sparc64/uaccess.h
--- a/include/asm-sparc64/uaccess.h~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/include/asm-sparc64/uaccess.h
@@ -10,7 +10,6 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/a.out.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
