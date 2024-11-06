Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E52156962
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854724; cv=none; b=mK/LJX2G1mfFXnInQDD6Hyl3UToTpdB5fhuqCCMEAerDr/mblQqii8+0MxLd2vaC6dJSb0ry2PcJUrLUoDn5DwAQRH6kcTJT2FJu6W0gxo/iOdNHPQ+e8sg9NE4AqYl4Hhfx3f/oSs/eoVBF2ca3K8WmafztULKPADwAZbYUzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854724; c=relaxed/simple;
	bh=zFv5yNMDAI+fenxQ987ncHx9TXcQ7OLpI8BKbbFALuE=;
	h=Date:To:From:Subject:Message-Id; b=aYOERQsr/3wjdaXlTW5dyErBR7GOJ1B/LkeCILqoGMHZyR2j2bZmUt3shiyfldOZXmOtBoiKr3ufpb01Sd5zW08pD/NCjGCwFPoHmVUQnYiUuwvcXV2ua1IelFsorczOLH5DepGaO32UgNKQUZ+J6dTB/1/OpdDDEvvzGxgZVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tOgSnsbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tOgSnsbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74AEC4CECF;
	Wed,  6 Nov 2024 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854723;
	bh=zFv5yNMDAI+fenxQ987ncHx9TXcQ7OLpI8BKbbFALuE=;
	h=Date:To:From:Subject:From;
	b=tOgSnsbVH+x/QECgf7nilOGn08LJVtrPyf7dU5v22X2h88zIYn0vr3baBsjtpwPmY
	 k7gil8pJ8ezk72MWIntUgPvTpLsWpZUvCeM0PdEcTFwPNLP9vEDHK7+xjG7G79xdp8
	 3867JRJCem9ycUJ4aE8UnxQsuqbBg4/c8I30s4m8=
Date: Tue, 05 Nov 2024 16:58:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-mm-flags-to-mm_typesh.patch removed from -mm tree
Message-Id: <20241106005843.B74AEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move mm flags to mm_types.h
has been removed from the -mm tree.  Its filename was
     mm-move-mm-flags-to-mm_typesh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: mm: move mm flags to mm_types.h
Date: Thu, 26 Sep 2024 15:49:22 +0800

The types of mm flags are now far beyond the core dump related features. 
This patch moves mm flags from linux/sched/coredump.h to linux/mm_types.h.
The linux/sched/coredump.h has include the mm_types.h, so the C files
related to coredump does not need to change head file inclusion.  In
addition, the inclusion of sched/coredump.h now can be deleted from the C
files that irrelevant to core dump.

Link: https://lkml.kernel.org/r/20240926074922.2721274-1-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h        |    1 
 include/linux/khugepaged.h     |    2 
 include/linux/ksm.h            |    1 
 include/linux/mm_types.h       |   84 +++++++++++++++++++++++++++++++
 include/linux/oom.h            |    1 
 include/linux/sched/coredump.h |   82 ------------------------------
 kernel/events/uprobes.c        |    1 
 kernel/fork.c                  |    1 
 mm/huge_memory.c               |    1 
 mm/khugepaged.c                |    1 
 mm/ksm.c                       |    1 
 mm/memory.c                    |    1 
 mm/oom_kill.c                  |    1 
 13 files changed, 84 insertions(+), 94 deletions(-)

--- a/include/linux/huge_mm.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/huge_mm.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
-#include <linux/sched/coredump.h>
 #include <linux/mm_types.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
--- a/include/linux/khugepaged.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/khugepaged.h
@@ -2,8 +2,6 @@
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
 
-#include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
-
 extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
--- a/include/linux/ksm.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/ksm.h
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
-#include <linux/sched/coredump.h>
 
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
--- a/include/linux/mm_types.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/mm_types.h
@@ -1499,4 +1499,88 @@ enum {
 	/* See also internal only FOLL flags in mm/internal.h */
 };
 
+/* mm flags */
+
+/*
+ * The first two bits represent core dump modes for set-user-ID,
+ * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
+ */
+#define MMF_DUMPABLE_BITS 2
+#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
+/* coredump filter bits */
+#define MMF_DUMP_ANON_PRIVATE	2
+#define MMF_DUMP_ANON_SHARED	3
+#define MMF_DUMP_MAPPED_PRIVATE	4
+#define MMF_DUMP_MAPPED_SHARED	5
+#define MMF_DUMP_ELF_HEADERS	6
+#define MMF_DUMP_HUGETLB_PRIVATE 7
+#define MMF_DUMP_HUGETLB_SHARED  8
+#define MMF_DUMP_DAX_PRIVATE	9
+#define MMF_DUMP_DAX_SHARED	10
+
+#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
+#define MMF_DUMP_FILTER_BITS	9
+#define MMF_DUMP_FILTER_MASK \
+	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+#define MMF_DUMP_FILTER_DEFAULT \
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+
+#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
+# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
+#else
+# define MMF_DUMP_MASK_DEFAULT_ELF	0
+#endif
+					/* leave room for more dump flags */
+#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
+#define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
+
+/*
+ * This one-shot flag is dropped due to necessity of changing exe once again
+ * on NFS restore
+ */
+//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+
+#define MMF_HAS_UPROBES		19	/* has uprobes */
+#define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
+#define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
+#define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
+#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
+#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
+#define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
+#define MMF_MULTIPROCESS	26	/* mm is shared between processes */
+/*
+ * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
+ * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
+ * a counter on its own. We're aggresive on this bit for now: even if the
+ * pinned pages were unpinned later on, we'll still keep this bit set for the
+ * lifecycle of this mm, just for simplicity.
+ */
+#define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
+
+#define MMF_HAS_MDWE		28
+#define MMF_HAS_MDWE_MASK	(1 << MMF_HAS_MDWE)
+
+
+#define MMF_HAS_MDWE_NO_INHERIT	29
+
+#define MMF_VM_MERGE_ANY	30
+#define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
+
+#define MMF_TOPDOWN		31	/* mm searches top down by default */
+#define MMF_TOPDOWN_MASK	(1 << MMF_TOPDOWN)
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
+				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
+				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
+
+static inline unsigned long mmf_init_flags(unsigned long flags)
+{
+	if (flags & (1UL << MMF_HAS_MDWE_NO_INHERIT))
+		flags &= ~((1UL << MMF_HAS_MDWE) |
+			   (1UL << MMF_HAS_MDWE_NO_INHERIT));
+	return flags & MMF_INIT_MASK;
+}
+
 #endif /* _LINUX_MM_TYPES_H */
--- a/include/linux/oom.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/oom.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/nodemask.h>
 #include <uapi/linux/oom.h>
-#include <linux/sched/coredump.h> /* MMF_* */
 #include <linux/mm.h> /* VM_FAULT* */
 
 struct zonelist;
--- a/include/linux/sched/coredump.h~mm-move-mm-flags-to-mm_typesh
+++ a/include/linux/sched/coredump.h
@@ -8,12 +8,6 @@
 #define SUID_DUMP_USER		1	/* Dump as user of process */
 #define SUID_DUMP_ROOT		2	/* Dump as root */
 
-/* mm flags */
-
-/* for SUID_DUMP_* above */
-#define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK ((1 << MMF_DUMPABLE_BITS) - 1)
-
 extern void set_dumpable(struct mm_struct *mm, int value);
 /*
  * This returns the actual value of the suid_dumpable flag. For things
@@ -31,80 +25,4 @@ static inline int get_dumpable(struct mm
 	return __get_dumpable(mm->flags);
 }
 
-/* coredump filter bits */
-#define MMF_DUMP_ANON_PRIVATE	2
-#define MMF_DUMP_ANON_SHARED	3
-#define MMF_DUMP_MAPPED_PRIVATE	4
-#define MMF_DUMP_MAPPED_SHARED	5
-#define MMF_DUMP_ELF_HEADERS	6
-#define MMF_DUMP_HUGETLB_PRIVATE 7
-#define MMF_DUMP_HUGETLB_SHARED  8
-#define MMF_DUMP_DAX_PRIVATE	9
-#define MMF_DUMP_DAX_SHARED	10
-
-#define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	9
-#define MMF_DUMP_FILTER_MASK \
-	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
-#define MMF_DUMP_FILTER_DEFAULT \
-	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
-	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
-
-#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
-# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
-#else
-# define MMF_DUMP_MASK_DEFAULT_ELF	0
-#endif
-					/* leave room for more dump flags */
-#define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
-#define MMF_VM_HUGEPAGE		17	/* set when mm is available for
-					   khugepaged */
-/*
- * This one-shot flag is dropped due to necessity of changing exe once again
- * on NFS restore
- */
-//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
-
-#define MMF_HAS_UPROBES		19	/* has uprobes */
-#define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
-#define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
-#define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
-#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
-#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
-#define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
-#define MMF_MULTIPROCESS	26	/* mm is shared between processes */
-/*
- * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
- * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
- * a counter on its own. We're aggresive on this bit for now: even if the
- * pinned pages were unpinned later on, we'll still keep this bit set for the
- * lifecycle of this mm, just for simplicity.
- */
-#define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
-
-#define MMF_HAS_MDWE		28
-#define MMF_HAS_MDWE_MASK	(1 << MMF_HAS_MDWE)
-
-
-#define MMF_HAS_MDWE_NO_INHERIT	29
-
-#define MMF_VM_MERGE_ANY	30
-#define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
-
-#define MMF_TOPDOWN		31	/* mm searches top down by default */
-#define MMF_TOPDOWN_MASK	(1 << MMF_TOPDOWN)
-
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
-				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
-				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
-
-static inline unsigned long mmf_init_flags(unsigned long flags)
-{
-	if (flags & (1UL << MMF_HAS_MDWE_NO_INHERIT))
-		flags &= ~((1UL << MMF_HAS_MDWE) |
-			   (1UL << MMF_HAS_MDWE_NO_INHERIT));
-	return flags & MMF_INIT_MASK;
-}
-
 #endif /* _LINUX_SCHED_COREDUMP_H */
--- a/kernel/events/uprobes.c~mm-move-mm-flags-to-mm_typesh
+++ a/kernel/events/uprobes.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/export.h>
 #include <linux/rmap.h>		/* anon_vma_prepare */
 #include <linux/mmu_notifier.h>
--- a/kernel/fork.c~mm-move-mm-flags-to-mm_typesh
+++ a/kernel/fork.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/sched/user.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/stat.h>
--- a/mm/huge_memory.c~mm-move-mm-flags-to-mm_typesh
+++ a/mm/huge_memory.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
--- a/mm/khugepaged.c~mm-move-mm-flags-to-mm_typesh
+++ a/mm/khugepaged.c
@@ -4,7 +4,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/mmu_notifier.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
--- a/mm/ksm.c~mm-move-mm-flags-to-mm_typesh
+++ a/mm/ksm.c
@@ -20,7 +20,6 @@
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/sched/cputime.h>
 #include <linux/rwsem.h>
 #include <linux/pagemap.h>
--- a/mm/memory.c~mm-move-mm-flags-to-mm_typesh
+++ a/mm/memory.c
@@ -44,7 +44,6 @@
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/task.h>
 #include <linux/hugetlb.h>
--- a/mm/oom_kill.c~mm-move-mm-flags-to-mm_typesh
+++ a/mm/oom_kill.c
@@ -24,7 +24,6 @@
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/coredump.h>
 #include <linux/sched/task.h>
 #include <linux/sched/debug.h>
 #include <linux/swap.h>
_

Patches currently in -mm which might be from sunnanyong@huawei.com are


