From: akpm@linux-foundation.org
Subject: + aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:53:00 -0800
Message-ID: <200711152353.lAFNr050022349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092AbXKOXxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org


The patch titled
     AOUT: Remove unnecessary inclusions of {asm, linux}/a.out.h
has been added to the -mm tree.  Its filename is
     aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AOUT: Remove unnecessary inclusions of {asm, linux}/a.out.h
From: David Howells <dhowells@redhat.com>

Remove now unnecessary inclusions of {asm,linux}/a.out.h.

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
 fs/exec.c                           |    1 -
 fs/proc/kcore.c                     |    1 -
 include/asm-sparc/uaccess.h         |    1 -
 include/asm-sparc64/processor.h     |    1 -
 include/asm-sparc64/uaccess.h       |    1 -
 27 files changed, 28 deletions(-)

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
@@ -151,8 +151,6 @@ MODULE_AUTHOR("Eric Youngdale, David S. 
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
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/ptrace.h>
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
diff -puN fs/exec.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth fs/exec.c
--- a/fs/exec.c~aout-remove-unnecessary-inclusions-of-asm-linux-aouth
+++ a/fs/exec.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
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
git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mtd-add-support-for-the-sst-39vf1601-flash-chip.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-mtd-flash-support-for-the-asb2303-board.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mutex-subsystem-synchro-test-module.patch
