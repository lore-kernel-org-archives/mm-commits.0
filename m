From: akpm@linux-foundation.org
Subject: + mm-consolidate-init_mm-definition.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:09:49 -0700
Message-ID: <200904072109.n37L9nvr030352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbZDGVTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, vapier.adi@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     mm: consolidate init_mm definition
has been added to the -mm tree.  Its filename is
     mm-consolidate-init_mm-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/init-mm.c                      |   13 +++++++++++++
 24 files changed, 14 insertions(+), 88 deletions(-)

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
@@ -14,18 +14,6 @@
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
@@ -0,0 +1,13 @@
+#include <linux/mm_types.h>
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
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
aio-remove-init_kioctx.patch
mm-consolidate-init_mm-definition.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

