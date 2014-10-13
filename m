From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-vm_bug_on_mm.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:53 -0700
Message-ID: <543c1805.hGx5evugRT3Uc22o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJMSUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, Valdis.Kletnieks@vt.edu, davej@redhat.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_BUG_ON_MM
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_bug_on_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: introduce VM_BUG_ON_MM

Very similar to VM_BUG_ON_PAGE and VM_BUG_ON_VMA, dump struct_mm when the
bug is hit.

[akpm@linux-foundation.org: coding-style fixes]
[mhocko@suse.cz: fix build]
[mhocko@suse.cz: fix build some more]
[akpm@linux-foundation.org: do strange things to avoid doing strange things for the comma separators]
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   10 ++++
 mm/debug.c              |   78 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff -puN include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm
+++ a/include/linux/mmdebug.h
@@ -5,11 +5,13 @@
 
 struct page;
 struct vm_area_struct;
+struct mm_struct;
 
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
 void dump_vma(const struct vm_area_struct *vma);
+void dump_mm(const struct mm_struct *mm);
 
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
@@ -27,6 +29,13 @@ void dump_vma(const struct vm_area_struc
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_BUG_ON_MM(cond, mm)						\
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_mm(mm);					\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
@@ -34,6 +43,7 @@ void dump_vma(const struct vm_area_struc
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
 #define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
+#define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
diff -puN mm/debug.c~mm-introduce-vm_bug_on_mm mm/debug.c
--- a/mm/debug.c~mm-introduce-vm_bug_on_mm
+++ a/mm/debug.c
@@ -1,3 +1,10 @@
+/*
+ * mm/debug.c
+ *
+ * mm/ specific debug routines.
+ *
+ */
+
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/ftrace_event.h>
@@ -159,4 +166,75 @@ void dump_vma(const struct vm_area_struc
 }
 EXPORT_SYMBOL(dump_vma);
 
+void dump_mm(const struct mm_struct *mm)
+{
+	printk(KERN_ALERT
+		"mm %p mmap %p seqnum %d task_size %lu\n"
+#ifdef CONFIG_MMU
+		"get_unmapped_area %p\n"
+#endif
+		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
+		"pgd %p mm_users %d mm_count %d nr_ptes %lu map_count %d\n"
+		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
+		"pinned_vm %lx shared_vm %lx exec_vm %lx stack_vm %lx\n"
+		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
+		"start_brk %lx brk %lx start_stack %lx\n"
+		"arg_start %lx arg_end %lx env_start %lx env_end %lx\n"
+		"binfmt %p flags %lx core_state %p\n"
+#ifdef CONFIG_AIO
+		"ioctx_table %p\n"
+#endif
+#ifdef CONFIG_MEMCG
+		"owner %p "
+#endif
+		"exe_file %p\n"
+#ifdef CONFIG_MMU_NOTIFIER
+		"mmu_notifier_mm %p\n"
+#endif
+#ifdef CONFIG_NUMA_BALANCING
+		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
+#endif
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+		"tlb_flush_pending %d\n"
+#endif
+		"%s",	/* This is here to hold the comma */
+
+		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
+#ifdef CONFIG_MMU
+		mm->get_unmapped_area,
+#endif
+		mm->mmap_base, mm->mmap_legacy_base, mm->highest_vm_end,
+		mm->pgd, atomic_read(&mm->mm_users),
+		atomic_read(&mm->mm_count),
+		atomic_long_read((atomic_long_t *)&mm->nr_ptes),
+		mm->map_count,
+		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
+		mm->pinned_vm, mm->shared_vm, mm->exec_vm, mm->stack_vm,
+		mm->start_code, mm->end_code, mm->start_data, mm->end_data,
+		mm->start_brk, mm->brk, mm->start_stack,
+		mm->arg_start, mm->arg_end, mm->env_start, mm->env_end,
+		mm->binfmt, mm->flags, mm->core_state,
+#ifdef CONFIG_AIO
+		mm->ioctx_table,
+#endif
+#ifdef CONFIG_MEMCG
+		mm->owner,
+#endif
+		mm->exe_file,
+#ifdef CONFIG_MMU_NOTIFIER
+		mm->mmu_notifier_mm,
+#endif
+#ifdef CONFIG_NUMA_BALANCING
+		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
+#endif
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+		mm->tlb_flush_pending,
+#endif
+		""		/* This is here to not have a comma! */
+		);
+
+		dump_flags(mm->def_flags, vmaflags_names,
+				ARRAY_SIZE(vmaflags_names));
+}
+
 #endif		/* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
kernel-add-support-for-gcc-5.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

