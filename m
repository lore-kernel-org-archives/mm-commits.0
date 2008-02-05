From: akpm@linux-foundation.org
Subject: - maps4-make-page-monitoring-proc-file-optional.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:25 -0800
Message-ID: <200802052231.m15MV6ga012134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760629AbYBEWmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     maps4: make page monitoring /proc file optional
has been removed from the -mm tree.  Its filename was
     maps4-make-page-monitoring-proc-file-optional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maps4: make page monitoring /proc file optional
From: Matt Mackall <mpm@selenic.com>

Make /proc/ page monitoring configurable

This puts the following files under an embedded config option:

/proc/pid/clear_refs
/proc/pid/smaps
/proc/pid/pagemap
/proc/kpagecount
/proc/kpageflags

[akpm@linux-foundation.org: Kconfig fix]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    4 ++--
 fs/proc/proc_misc.c |    4 ++++
 fs/proc/task_mmu.c  |    2 ++
 init/Kconfig        |   10 ++++++++++
 mm/Makefile         |    3 ++-
 5 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~maps4-make-page-monitoring-proc-file-optional fs/proc/base.c
--- a/fs/proc/base.c~maps4-make-page-monitoring-proc-file-optional
+++ a/fs/proc/base.c
@@ -2249,7 +2249,7 @@ static const struct pid_entry tgid_base_
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
-#ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
 	REG("pagemap",    S_IRUSR, pagemap),
@@ -2578,7 +2578,7 @@ static const struct pid_entry tid_base_s
 	LNK("root",      root),
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
-#ifdef CONFIG_MMU
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
 	REG("pagemap",    S_IRUSR, pagemap),
diff -puN fs/proc/proc_misc.c~maps4-make-page-monitoring-proc-file-optional fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps4-make-page-monitoring-proc-file-optional
+++ a/fs/proc/proc_misc.c
@@ -676,6 +676,7 @@ static const struct file_operations proc
 };
 #endif
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
 /* /proc/kpagecount - an array exposing page counts
@@ -804,6 +805,7 @@ static struct file_operations proc_kpage
 	.llseek = mem_lseek,
 	.read = kpageflags_read,
 };
+#endif /* CONFIG_PROC_PAGE_MONITOR */
 
 struct proc_dir_entry *proc_root_kcore;
 
@@ -885,8 +887,10 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
 	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
+#endif
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
diff -puN fs/proc/task_mmu.c~maps4-make-page-monitoring-proc-file-optional fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps4-make-page-monitoring-proc-file-optional
+++ a/fs/proc/task_mmu.c
@@ -337,6 +337,7 @@ const struct file_operations proc_maps_o
  */
 #define PSS_SHIFT 12
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats
 {
 	struct vm_area_struct *vma;
@@ -717,6 +718,7 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 };
+#endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
diff -puN init/Kconfig~maps4-make-page-monitoring-proc-file-optional init/Kconfig
--- a/init/Kconfig~maps4-make-page-monitoring-proc-file-optional
+++ a/init/Kconfig
@@ -678,6 +678,16 @@ config MARKERS
 
 source "arch/Kconfig"
 
+config PROC_PAGE_MONITOR
+ 	default y
+	depends on PROC_FS && MMU
+	bool "Enable /proc page monitoring" if EMBEDDED
+ 	help
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
+	  /proc/kpagecount, and /proc/kpageflags. Disabling these
+          interfaces will reduce the size of the kernel by approximately 4kb.
+
 endmenu		# General setup
 
 config SLABINFO
diff -puN mm/Makefile~maps4-make-page-monitoring-proc-file-optional mm/Makefile
--- a/mm/Makefile~maps4-make-page-monitoring-proc-file-optional
+++ a/mm/Makefile
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o
+			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
@@ -13,6 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
 
+obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
