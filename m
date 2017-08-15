From: akpm@linux-foundation.org
Subject: + add-proc-pid-smaps_rollup.patch added to -mm tree
Date: Tue, 15 Aug 2017 15:35:45 -0700
Message-ID: <59937741.TM19GoAeZ6/AtGG7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdHOWfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 18:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dancol@google.com, joelaf@google.com, mhocko@kernel.org, minchan@kernel.org, rdunlap@infradead.org, sonnyrao@chromium.org, timmurray@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add /proc/pid/smaps_rollup
has been added to the -mm tree.  Its filename is
     add-proc-pid-smaps_rollup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-proc-pid-smaps_rollup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-proc-pid-smaps_rollup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Colascione <dancol@google.com>
Subject: mm: add /proc/pid/smaps_rollup

/proc/pid/smaps_rollup is a new proc file that improves the performance of
user programs that determine aggregate memory statistics (e.g., total PSS)
of a process.

Android regularly "samples" the memory usage of various processes in order
to balance its memory pool sizes.  This sampling process involves opening
/proc/pid/smaps and summing certain fields.  For very large processes,
sampling memory use this way can take several hundred milliseconds, due
mostly to the overhead of the seq_printf calls in task_mmu.c.

smaps_rollup improves the situation.  It contains most of the fields of
/proc/pid/smaps, but instead of a set of fields for each VMA, smaps_rollup
instead contains one synthetic smaps-format entry representing the whole
process.  In the single smaps_rollup synthetic entry, each field is the
summation of the corresponding field in all of the real-smaps VMAs.  Using
a common format for smaps_rollup and smaps allows userspace parsers to
repurpose parsers meant for use with non-rollup smaps for smaps_rollup,
and it allows userspace to switch between smaps_rollup and smaps at
runtime (say, based on the availability of smaps_rollup in a given kernel)
with minimal fuss.

By using smaps_rollup instead of smaps, a caller can avoid the significant
overhead of formatting, reading, and parsing each of a large process's
potentially very numerous memory mappings.  For sampling system_server's
PSS in Android, we measured a 12x speedup, representing a savings of
several hundred milliseconds.

One alternative to a new per-process proc file would have been including
PSS information in /proc/pid/status.  We considered this option but
thought that PSS would be too expensive (by a few orders of magnitude) to
collect relative to what's already emitted as part of /proc/pid/status,
and slowing every user of /proc/pid/status for the sake of readers that
happen to want PSS feels wrong.

The code itself works by reusing the existing VMA-walking framework we use
for regular smaps generation and keeping the mem_size_stats structure
around between VMA walks instead of using a fresh one for each VMA.  In
this way, summation happens automatically.  We let seq_file walk over the
VMAs just as it does for regular smaps and just emit nothing to the
seq_file until we hit the last VMA.

Benchmarks:

    using smaps:
    iterations:1000 pid:1163 pss:220023808
    0m29.46s real 0m08.28s user 0m20.98s system

    using smaps_rollup:
    iterations:1000 pid:1163 pss:220702720
    0m04.39s real 0m00.03s user 0m04.31s system

Link: http://lkml.kernel.org/r/20170812022148.178293-1-dancol@google.com
Signed-off-by: Daniel Colascione <dancol@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/procfs-smaps_rollup |   34 ++
 fs/proc/base.c                                |    2 
 fs/proc/internal.h                            |    3 
 fs/proc/task_mmu.c                            |  196 ++++++++++------
 4 files changed, 173 insertions(+), 62 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/procfs-smaps_rollup
--- /dev/null
+++ a/Documentation/ABI/testing/procfs-smaps_rollup
@@ -0,0 +1,34 @@
+What:		/proc/pid/smaps_rollup
+Date:		August 2017
+Contact:	Daniel Colascione <dancol@google.com>
+Description:
+		This file provides pre-summed memory information for a
+		process.  The format is identical to /proc/pid/smaps,
+		except instead of an entry for each VMA in a process,
+		smaps_rollup has a single entry (tagged "[rollup]")
+		for which each field is the sum of the corresponding
+		fields from all the maps in /proc/pid/smaps.
+		For more details, see the procfs man page.
+
+		Typical output looks like this:
+
+		00100000-ff709000 ---p 00000000 00:00 0		 [rollup]
+		Rss:		     884 kB
+		Pss:		     385 kB
+		Shared_Clean:	     696 kB
+		Shared_Dirty:	       0 kB
+		Private_Clean:	     120 kB
+		Private_Dirty:	      68 kB
+		Referenced:	     884 kB
+		Anonymous:	      68 kB
+		LazyFree:	       0 kB
+		AnonHugePages:	       0 kB
+		ShmemPmdMapped:	       0 kB
+		Shared_Hugetlb:	       0 kB
+		Private_Hugetlb:       0 kB
+		Swap:		       0 kB
+		SwapPss:	       0 kB
+		Locked:		     385 kB
+
+
+		
diff -puN fs/proc/base.c~add-proc-pid-smaps_rollup fs/proc/base.c
--- a/fs/proc/base.c~add-proc-pid-smaps_rollup
+++ a/fs/proc/base.c
@@ -2930,6 +2930,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
+	REG("smaps_rollup", S_IRUGO, proc_pid_smaps_rollup_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
@@ -3323,6 +3324,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
+	REG("smaps_rollup", S_IRUGO, proc_pid_smaps_rollup_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
diff -puN fs/proc/internal.h~add-proc-pid-smaps_rollup fs/proc/internal.h
--- a/fs/proc/internal.h~add-proc-pid-smaps_rollup
+++ a/fs/proc/internal.h
@@ -269,10 +269,12 @@ extern int proc_remount(struct super_blo
 /*
  * task_[no]mmu.c
  */
+struct mem_size_stats;
 struct proc_maps_private {
 	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
+	struct mem_size_stats *rollup;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
 #endif
@@ -288,6 +290,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_pid_numa_maps_operations;
 extern const struct file_operations proc_tid_numa_maps_operations;
 extern const struct file_operations proc_pid_smaps_operations;
+extern const struct file_operations proc_pid_smaps_rollup_operations;
 extern const struct file_operations proc_tid_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
diff -puN fs/proc/task_mmu.c~add-proc-pid-smaps_rollup fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~add-proc-pid-smaps_rollup
+++ a/fs/proc/task_mmu.c
@@ -253,6 +253,7 @@ static int proc_map_release(struct inode
 	if (priv->mm)
 		mmdrop(priv->mm);
 
+	kfree(priv->rollup);
 	return seq_release_private(inode, file);
 }
 
@@ -279,6 +280,23 @@ static int is_stack(struct proc_maps_pri
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
+static void show_vma_header_prefix(struct seq_file *m,
+				   unsigned long start, unsigned long end,
+				   vm_flags_t flags, unsigned long long pgoff,
+				   dev_t dev, unsigned long ino)
+{
+	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
+	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
+		   start,
+		   end,
+		   flags & VM_READ ? 'r' : '-',
+		   flags & VM_WRITE ? 'w' : '-',
+		   flags & VM_EXEC ? 'x' : '-',
+		   flags & VM_MAYSHARE ? 's' : 'p',
+		   pgoff,
+		   MAJOR(dev), MINOR(dev), ino);
+}
+
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
@@ -301,17 +319,7 @@ show_map_vma(struct seq_file *m, struct
 
 	start = vma->vm_start;
 	end = vma->vm_end;
-
-	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
-			start,
-			end,
-			flags & VM_READ ? 'r' : '-',
-			flags & VM_WRITE ? 'w' : '-',
-			flags & VM_EXEC ? 'x' : '-',
-			flags & VM_MAYSHARE ? 's' : 'p',
-			pgoff,
-			MAJOR(dev), MINOR(dev), ino);
+	show_vma_header_prefix(m, start, end, flags, pgoff, dev, ino);
 
 	/*
 	 * Print the dentry name for named mappings, and a
@@ -430,6 +438,7 @@ const struct file_operations proc_tid_ma
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
+	bool first;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -443,7 +452,9 @@ struct mem_size_stats {
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
+	unsigned long first_vma_start;
 	u64 pss;
+	u64 pss_locked;
 	u64 swap_pss;
 	bool check_shmem_swap;
 };
@@ -720,18 +731,36 @@ void __weak arch_show_smap(struct seq_fi
 
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
+	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
-	struct mem_size_stats mss;
+	struct mem_size_stats mss_stack;
+	struct mem_size_stats *mss;
 	struct mm_walk smaps_walk = {
 		.pmd_entry = smaps_pte_range,
 #ifdef CONFIG_HUGETLB_PAGE
 		.hugetlb_entry = smaps_hugetlb_range,
 #endif
 		.mm = vma->vm_mm,
-		.private = &mss,
 	};
+	int ret = 0;
+	bool rollup_mode;
+	bool last_vma;
+
+	if (priv->rollup) {
+		rollup_mode = true;
+		mss = priv->rollup;
+		if (mss->first) {
+			mss->first_vma_start = vma->vm_start;
+			mss->first = false;
+		}
+		last_vma = !m_next_vma(priv, vma);
+	} else {
+		rollup_mode = false;
+		memset(&mss_stack, 0, sizeof(mss_stack));
+		mss = &mss_stack;
+	}
 
-	memset(&mss, 0, sizeof mss);
+	smaps_walk.private = mss;
 
 #ifdef CONFIG_SHMEM
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
@@ -749,9 +778,9 @@ static int show_smap(struct seq_file *m,
 
 		if (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
 					!(vma->vm_flags & VM_WRITE)) {
-			mss.swap = shmem_swapped;
+			mss->swap = shmem_swapped;
 		} else {
-			mss.check_shmem_swap = true;
+			mss->check_shmem_swap = true;
 			smaps_walk.pte_hole = smaps_pte_hole;
 		}
 	}
@@ -759,54 +788,71 @@ static int show_smap(struct seq_file *m,
 
 	/* mmap_sem is held in m_start */
 	walk_page_vma(vma, &smaps_walk);
+	if (vma->vm_flags & VM_LOCKED)
+		mss->pss_locked += mss->pss;
 
-	show_map_vma(m, vma, is_pid);
-
-	seq_printf(m,
-		   "Size:           %8lu kB\n"
-		   "Rss:            %8lu kB\n"
-		   "Pss:            %8lu kB\n"
-		   "Shared_Clean:   %8lu kB\n"
-		   "Shared_Dirty:   %8lu kB\n"
-		   "Private_Clean:  %8lu kB\n"
-		   "Private_Dirty:  %8lu kB\n"
-		   "Referenced:     %8lu kB\n"
-		   "Anonymous:      %8lu kB\n"
-		   "LazyFree:       %8lu kB\n"
-		   "AnonHugePages:  %8lu kB\n"
-		   "ShmemPmdMapped: %8lu kB\n"
-		   "Shared_Hugetlb: %8lu kB\n"
-		   "Private_Hugetlb: %7lu kB\n"
-		   "Swap:           %8lu kB\n"
-		   "SwapPss:        %8lu kB\n"
-		   "KernelPageSize: %8lu kB\n"
-		   "MMUPageSize:    %8lu kB\n"
-		   "Locked:         %8lu kB\n",
-		   (vma->vm_end - vma->vm_start) >> 10,
-		   mss.resident >> 10,
-		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
-		   mss.shared_clean  >> 10,
-		   mss.shared_dirty  >> 10,
-		   mss.private_clean >> 10,
-		   mss.private_dirty >> 10,
-		   mss.referenced >> 10,
-		   mss.anonymous >> 10,
-		   mss.lazyfree >> 10,
-		   mss.anonymous_thp >> 10,
-		   mss.shmem_thp >> 10,
-		   mss.shared_hugetlb >> 10,
-		   mss.private_hugetlb >> 10,
-		   mss.swap >> 10,
-		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
-		   vma_kernel_pagesize(vma) >> 10,
-		   vma_mmu_pagesize(vma) >> 10,
-		   (vma->vm_flags & VM_LOCKED) ?
-			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
-
-	arch_show_smap(m, vma);
-	show_smap_vma_flags(m, vma);
+	if (!rollup_mode) {
+		show_map_vma(m, vma, is_pid);
+	} else if (last_vma) {
+		show_vma_header_prefix(
+			m, mss->first_vma_start, vma->vm_end, 0, 0, 0, 0);
+		seq_pad(m, ' ');
+		seq_puts(m, "[rollup]\n");
+	} else {
+		ret = SEQ_SKIP;
+	}
+
+	if (!rollup_mode)
+		seq_printf(m,
+			   "Size:           %8lu kB\n"
+			   "KernelPageSize: %8lu kB\n"
+			   "MMUPageSize:    %8lu kB\n",
+			   (vma->vm_end - vma->vm_start) >> 10,
+			   vma_kernel_pagesize(vma) >> 10,
+			   vma_mmu_pagesize(vma) >> 10);
+
+
+	if (!rollup_mode || last_vma)
+		seq_printf(m,
+			   "Rss:            %8lu kB\n"
+			   "Pss:            %8lu kB\n"
+			   "Shared_Clean:   %8lu kB\n"
+			   "Shared_Dirty:   %8lu kB\n"
+			   "Private_Clean:  %8lu kB\n"
+			   "Private_Dirty:  %8lu kB\n"
+			   "Referenced:     %8lu kB\n"
+			   "Anonymous:      %8lu kB\n"
+			   "LazyFree:       %8lu kB\n"
+			   "AnonHugePages:  %8lu kB\n"
+			   "ShmemPmdMapped: %8lu kB\n"
+			   "Shared_Hugetlb: %8lu kB\n"
+			   "Private_Hugetlb: %7lu kB\n"
+			   "Swap:           %8lu kB\n"
+			   "SwapPss:        %8lu kB\n"
+			   "Locked:         %8lu kB\n",
+			   mss->resident >> 10,
+			   (unsigned long)(mss->pss >> (10 + PSS_SHIFT)),
+			   mss->shared_clean  >> 10,
+			   mss->shared_dirty  >> 10,
+			   mss->private_clean >> 10,
+			   mss->private_dirty >> 10,
+			   mss->referenced >> 10,
+			   mss->anonymous >> 10,
+			   mss->lazyfree >> 10,
+			   mss->anonymous_thp >> 10,
+			   mss->shmem_thp >> 10,
+			   mss->shared_hugetlb >> 10,
+			   mss->private_hugetlb >> 10,
+			   mss->swap >> 10,
+			   (unsigned long)(mss->swap_pss >> (10 + PSS_SHIFT)),
+			   (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));
+
+	if (!rollup_mode) {
+		arch_show_smap(m, vma);
+		show_smap_vma_flags(m, vma);
+	}
 	m_cache_vma(m, vma);
-	return 0;
+	return ret;
 }
 
 static int show_pid_smap(struct seq_file *m, void *v)
@@ -838,6 +884,25 @@ static int pid_smaps_open(struct inode *
 	return do_maps_open(inode, file, &proc_pid_smaps_op);
 }
 
+static int pid_smaps_rollup_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+	struct proc_maps_private *priv;
+	int ret = do_maps_open(inode, file, &proc_pid_smaps_op);
+
+	if (ret < 0)
+		return ret;
+	seq = file->private_data;
+	priv = seq->private;
+	priv->rollup = kzalloc(sizeof(*priv->rollup), GFP_KERNEL);
+	if (!priv->rollup) {
+		proc_map_release(inode, file);
+		return -ENOMEM;
+	}
+	priv->rollup->first = true;
+	return 0;
+}
+
 static int tid_smaps_open(struct inode *inode, struct file *file)
 {
 	return do_maps_open(inode, file, &proc_tid_smaps_op);
@@ -848,6 +913,13 @@ const struct file_operations proc_pid_sm
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= proc_map_release,
+};
+
+const struct file_operations proc_pid_smaps_rollup_operations = {
+	.open		= pid_smaps_rollup_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_map_release,
 };
 
 const struct file_operations proc_tid_smaps_operations = {
_

Patches currently in -mm which might be from dancol@google.com are

add-proc-pid-smaps_rollup.patch

