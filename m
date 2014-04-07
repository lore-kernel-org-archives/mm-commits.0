From: akpm@linux-foundation.org
Subject: [folded-merged] mm-per-thread-vma-caching-fix-3.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:04:38 -0700
Message-ID: <534320f6.wBlWSuV/+wJkxSBf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaDGWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-per-thread-vma-caching-fix-3.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:38 -0700


The patch titled
     Subject: mm-per-thread-vma-caching-fix-3
has been removed from the -mm tree.  Its filename was
     mm-per-thread-vma-caching-fix-3.patch

This patch was dropped because it was folded into mm-per-thread-vma-caching.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-per-thread-vma-caching-fix-3

Attempt to untangle header files.

Prior to this patch:

mm.h does not require sched.h
sched.h does not require mm.h
sched.h requires vmacache.h
vmacache.h requires mm.h

After this patch:

mm.h still does not require sched.h
sched.h still does not require mm.h
sched.h does not require vmacache.h
mm.h does not require vmacache.h
vmacache.h requires (and includes) mm.h
vmacache.h requires (and includes) sched.h

To do all this, the three "#define VMACACHE_foo" lines were moved to
sched.h.

The inclusions of sched.h and mm.h into vmacache.h are actually unrequired
because the .c files include mm.h and sched.h directly, but I put them in
there for cargo-cult reasons.

vmacache_flush() no longer needs to be implemented in cpp - make it so.

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/mmu_context.h |    2 ++
 fs/exec.c                                |    1 +
 fs/proc/task_mmu.c                       |    1 +
 include/linux/sched.h                    |    5 ++++-
 include/linux/vmacache.h                 |   12 +++++-------
 kernel/debug/debug_core.c                |    1 +
 kernel/fork.c                            |    2 ++
 mm/mmap.c                                |    1 +
 mm/nommu.c                               |    1 +
 mm/vmacache.c                            |    1 +
 10 files changed, 19 insertions(+), 8 deletions(-)

diff -puN arch/unicore32/include/asm/mmu_context.h~mm-per-thread-vma-caching-fix-3 arch/unicore32/include/asm/mmu_context.h
--- a/arch/unicore32/include/asm/mmu_context.h~mm-per-thread-vma-caching-fix-3
+++ a/arch/unicore32/include/asm/mmu_context.h
@@ -14,6 +14,8 @@
 
 #include <linux/compiler.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
diff -puN fs/exec.c~mm-per-thread-vma-caching-fix-3 fs/exec.c
--- a/fs/exec.c~mm-per-thread-vma-caching-fix-3
+++ a/fs/exec.c
@@ -26,6 +26,7 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/swap.h>
diff -puN fs/proc/task_mmu.c~mm-per-thread-vma-caching-fix-3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-per-thread-vma-caching-fix-3
+++ a/fs/proc/task_mmu.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/hugetlb.h>
 #include <linux/huge_mm.h>
 #include <linux/mount.h>
diff -puN include/linux/sched.h~mm-per-thread-vma-caching-fix-3 include/linux/sched.h
--- a/include/linux/sched.h~mm-per-thread-vma-caching-fix-3
+++ a/include/linux/sched.h
@@ -23,7 +23,6 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
-#include <linux/vmacache.h>
 #include <linux/preempt_mask.h>
 
 #include <asm/page.h>
@@ -131,6 +130,10 @@ struct perf_event_context;
 struct blk_plug;
 struct filename;
 
+#define VMACACHE_BITS 2
+#define VMACACHE_SIZE (1U << VMACACHE_BITS)
+#define VMACACHE_MASK (VMACACHE_SIZE - 1)
+
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.
diff -puN include/linux/vmacache.h~mm-per-thread-vma-caching-fix-3 include/linux/vmacache.h
--- a/include/linux/vmacache.h~mm-per-thread-vma-caching-fix-3
+++ a/include/linux/vmacache.h
@@ -1,21 +1,19 @@
 #ifndef __LINUX_VMACACHE_H
 #define __LINUX_VMACACHE_H
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 
-#define VMACACHE_BITS 2
-#define VMACACHE_SIZE (1U << VMACACHE_BITS)
-#define VMACACHE_MASK (VMACACHE_SIZE - 1)
 /*
  * Hash based on the page number. Provides a good hit rate for
  * workloads with good locality and those with random accesses as well.
  */
 #define VMACACHE_HASH(addr) ((addr >> PAGE_SHIFT) & VMACACHE_MASK)
 
-#define vmacache_flush(tsk)					 \
-	do {							 \
-		memset(tsk->vmacache, 0, sizeof(tsk->vmacache)); \
-	} while (0)
+static inline void vmacache_flush(struct task_struct *tsk)
+{
+	memset(tsk->vmacache, 0, sizeof(tsk->vmacache));
+}
 
 extern void vmacache_flush_all(struct mm_struct *mm);
 extern void vmacache_update(unsigned long addr, struct vm_area_struct *newvma);
diff -puN kernel/debug/debug_core.c~mm-per-thread-vma-caching-fix-3 kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~mm-per-thread-vma-caching-fix-3
+++ a/kernel/debug/debug_core.c
@@ -49,6 +49,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 
 #include <asm/cacheflush.h>
diff -puN kernel/fork.c~mm-per-thread-vma-caching-fix-3 kernel/fork.c
--- a/kernel/fork.c~mm-per-thread-vma-caching-fix-3
+++ a/kernel/fork.c
@@ -28,6 +28,8 @@
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
diff -puN mm/mmap.c~mm-per-thread-vma-caching-fix-3 mm/mmap.c
--- a/mm/mmap.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/mmap.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/shm.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
diff -puN mm/nommu.c~mm-per-thread-vma-caching-fix-3 mm/nommu.c
--- a/mm/nommu.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/nommu.c
@@ -15,6 +15,7 @@
 
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/file.h>
diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-3 mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/vmacache.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2014 Davidlohr Bueso.
  */
 #include <linux/sched.h>
+#include <linux/mm.h>
 #include <linux/vmacache.h>
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

