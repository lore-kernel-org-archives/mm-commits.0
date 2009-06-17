From: akpm@linux-foundation.org
Subject: [merged] mm-consolidate-init_mm-definition.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:27 -0700
Message-ID: <200906171832.n5HIWRvC030970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759761AbZFQSc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, vapier.adi@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: consolidate init_mm definition
has been removed from the -mm tree.  Its filename was
     mm-consolidate-init_mm-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: consolidate init_mm definition
From: Alexey Dobriyan <adobriyan@gmail.com>

* create mm/init-mm.c, move init_mm there
* remove INIT_MM, initialize init_mm with C99 initializer
* unexport init_mm on all arches:

  init_mm is already unexported on x86.

  One strange place is some OMAP driver (drivers/video/omap/) which
  won't build modular, but it's already wants get_vm_area() export.
  Somebody should look there.

[akpm@linux-foundation.org: add missing #includes]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/init_task.c     |    3 ---
 arch/arm/kernel/init_task.c       |    4 ----
 arch/avr32/kernel/init_task.c     |    4 ----
 arch/blackfin/kernel/init_task.c  |    4 ----
 arch/cris/kernel/process.c        |    4 ----
 arch/frv/kernel/init_task.c       |    4 ----
 arch/h8300/kernel/init_task.c     |    4 ----
 arch/ia64/kernel/init_task.c      |    4 ----
 arch/m32r/kernel/init_task.c      |    4 ----
 arch/m68k/kernel/process.c        |    4 ----
 arch/m68knommu/kernel/init_task.c |    4 ----
 arch/mips/kernel/init_task.c      |    4 ----
 arch/mn10300/kernel/init_task.c   |    3 ---
 arch/parisc/kernel/init_task.c    |    4 ----
 arch/powerpc/kernel/init_task.c   |    4 ----
 arch/s390/kernel/init_task.c      |    4 ----
 arch/sh/kernel/init_task.c        |    3 ---
 arch/sparc/kernel/init_task.c     |    3 ---
 arch/um/kernel/init_task.c        |    3 ---
 arch/x86/kernel/init_task.c       |    1 -
 arch/xtensa/kernel/init_task.c    |    4 ----
 include/linux/init_task.h         |   12 ------------
 mm/Makefile                       |    1 +
 mm/init-mm.c                      |   20 ++++++++++++++++++++
 24 files changed, 21 insertions(+), 88 deletions(-)

diff -puN arch/alpha/kernel/init_task.c~mm-consolidate-init_mm-definition arch/alpha/kernel/init_task.c
--- a/arch/alpha/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/alpha/kernel/init_task.c
@@ -10,10 +10,7 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
 union thread_union init_thread_union
diff -puN arch/arm/kernel/init_task.c~mm-consolidate-init_mm-definition arch/arm/kernel/init_task.c
--- a/arch/arm/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/arm/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/avr32/kernel/init_task.c~mm-consolidate-init_mm-definition arch/avr32/kernel/init_task.c
--- a/arch/avr32/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/avr32/kernel/init_task.c
@@ -15,10 +15,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
diff -puN arch/blackfin/kernel/init_task.c~mm-consolidate-init_mm-definition arch/blackfin/kernel/init_task.c
--- a/arch/blackfin/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/blackfin/kernel/init_task.c
@@ -35,10 +35,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/cris/kernel/process.c~mm-consolidate-init_mm-definition arch/cris/kernel/process.c
--- a/arch/cris/kernel/process.c~mm-consolidate-init_mm-definition
+++ a/arch/cris/kernel/process.c
@@ -38,10 +38,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/frv/kernel/init_task.c~mm-consolidate-init_mm-definition arch/frv/kernel/init_task.c
--- a/arch/frv/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/frv/kernel/init_task.c
@@ -12,10 +12,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/h8300/kernel/init_task.c~mm-consolidate-init_mm-definition arch/h8300/kernel/init_task.c
--- a/arch/h8300/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/h8300/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/ia64/kernel/init_task.c~mm-consolidate-init_mm-definition arch/ia64/kernel/init_task.c
--- a/arch/ia64/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/ia64/kernel/init_task.c
@@ -19,10 +19,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/m32r/kernel/init_task.c~mm-consolidate-init_mm-definition arch/m32r/kernel/init_task.c
--- a/arch/m32r/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/m32r/kernel/init_task.c
@@ -13,10 +13,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/m68k/kernel/process.c~mm-consolidate-init_mm-definition arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~mm-consolidate-init_mm-definition
+++ a/arch/m68k/kernel/process.c
@@ -42,10 +42,6 @@
  */
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 union thread_union init_thread_union
 __attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
diff -puN arch/m68knommu/kernel/init_task.c~mm-consolidate-init_mm-definition arch/m68knommu/kernel/init_task.c
--- a/arch/m68knommu/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/m68knommu/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/mips/kernel/init_task.c~mm-consolidate-init_mm-definition arch/mips/kernel/init_task.c
--- a/arch/mips/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/mips/kernel/init_task.c
@@ -11,10 +11,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/mn10300/kernel/init_task.c~mm-consolidate-init_mm-definition arch/mn10300/kernel/init_task.c
--- a/arch/mn10300/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/mn10300/kernel/init_task.c
@@ -20,9 +20,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/parisc/kernel/init_task.c~mm-consolidate-init_mm-definition arch/parisc/kernel/init_task.c
--- a/arch/parisc/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/parisc/kernel/init_task.c
@@ -36,10 +36,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/powerpc/kernel/init_task.c~mm-consolidate-init_mm-definition arch/powerpc/kernel/init_task.c
--- a/arch/powerpc/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/powerpc/kernel/init_task.c
@@ -9,10 +9,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/s390/kernel/init_task.c~mm-consolidate-init_mm-definition arch/s390/kernel/init_task.c
--- a/arch/s390/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/s390/kernel/init_task.c
@@ -18,10 +18,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/sh/kernel/init_task.c~mm-consolidate-init_mm-definition arch/sh/kernel/init_task.c
--- a/arch/sh/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/sh/kernel/init_task.c
@@ -10,9 +10,6 @@
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct pt_regs fake_swapper_regs;
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
diff -puN arch/sparc/kernel/init_task.c~mm-consolidate-init_mm-definition arch/sparc/kernel/init_task.c
--- a/arch/sparc/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/sparc/kernel/init_task.c
@@ -10,10 +10,7 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
 /* .text section in head.S is aligned at 8k boundary and this gets linked
diff -puN arch/um/kernel/init_task.c~mm-consolidate-init_mm-definition arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/um/kernel/init_task.c
@@ -10,11 +10,8 @@
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
 
-struct mm_struct init_mm = INIT_MM(init_mm);
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
diff -puN arch/x86/kernel/init_task.c~mm-consolidate-init_mm-definition arch/x86/kernel/init_task.c
--- a/arch/x86/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/x86/kernel/init_task.c
@@ -12,7 +12,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 
 /*
  * Initial thread structure.
diff -puN arch/xtensa/kernel/init_task.c~mm-consolidate-init_mm-definition arch/xtensa/kernel/init_task.c
--- a/arch/xtensa/kernel/init_task.c~mm-consolidate-init_mm-definition
+++ a/arch/xtensa/kernel/init_task.c
@@ -23,10 +23,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 union thread_union init_thread_union
 	__attribute__((__section__(".data.init_task"))) =
 { INIT_THREAD_INFO(init_task) };
diff -puN include/linux/init_task.h~mm-consolidate-init_mm-definition include/linux/init_task.h
--- a/include/linux/init_task.h~mm-consolidate-init_mm-definition
+++ a/include/linux/init_task.h
@@ -15,18 +15,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
-#define INIT_MM(name) \
-{			 					\
-	.mm_rb		= RB_ROOT,				\
-	.pgd		= swapper_pg_dir, 			\
-	.mm_users	= ATOMIC_INIT(2), 			\
-	.mm_count	= ATOMIC_INIT(1), 			\
-	.mmap_sem	= __RWSEM_INITIALIZER(name.mmap_sem),	\
-	.page_table_lock =  __SPIN_LOCK_UNLOCKED(name.page_table_lock),	\
-	.mmlist		= LIST_HEAD_INIT(name.mmlist),		\
-	.cpu_vm_mask	= CPU_MASK_ALL,				\
-}
-
 #define INIT_SIGNALS(sig) {						\
 	.count		= ATOMIC_INIT(1), 				\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
diff -puN mm/Makefile~mm-consolidate-init_mm-definition mm/Makefile
--- a/mm/Makefile~mm-consolidate-init_mm-definition
+++ a/mm/Makefile
@@ -12,6 +12,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
+obj-y += init-mm.o
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
diff -puN /dev/null mm/init-mm.c
--- /dev/null
+++ a/mm/init-mm.c
@@ -0,0 +1,20 @@
+#include <linux/mm_types.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/cpumask.h>
+
+#include <asm/atomic.h>
+#include <asm/pgtable.h>
+
+struct mm_struct init_mm = {
+	.mm_rb		= RB_ROOT,
+	.pgd		= swapper_pg_dir,
+	.mm_users	= ATOMIC_INIT(2),
+	.mm_count	= ATOMIC_INIT(1),
+	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
+	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
+	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
+	.cpu_vm_mask	= CPU_MASK_ALL,
+};
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-update.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
procfs-provide-stack-information-for-threads-v08.patch
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
nsproxy-extract-create_nsproxy.patch
ipcns-3-4-make-free_ipc_ns-static.patch
ipcns-move-free_ipcs-proto.patch

