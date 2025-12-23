Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF31E4AB
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455293; cv=none; b=Aiq1dYn52SuvZqcPR1fmvf2UNWYt570GUbwm+Mgsmo/0QD0V8aIk096KeWpAeaXNSOE1MbyhSs2wsET1VfqEOTihkYq+iyo9ZXDB56osY2Ed6D3dG8tEd9LPYvvrFWxR7amR8kbTv45/swwcAJX4VMkqjbcvlz1Laf6RZLKDZ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455293; c=relaxed/simple;
	bh=WHKO2c3ZWDRDtfGgk63Bys8DT+38/bqzlXluyuZOnmE=;
	h=Date:To:From:Subject:Message-Id; b=Ql3bd2coGhp1KzM0jQGSxndpCOkQisAkuh+NQwRMXYCQQvoT4zHlvdBmwEqoR0NvDSiTkqf9NKUcR5HOQUw1STNYVG6OM+ugLCD0tMt/Jibfcr2rV9z1EOp5FkKAZBfsewn+psEy0VmEy4a+ozgrnvV1haOqakwTCNv8b4Q5Sxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vmBoMOiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vmBoMOiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7339C4CEF1;
	Tue, 23 Dec 2025 02:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455293;
	bh=WHKO2c3ZWDRDtfGgk63Bys8DT+38/bqzlXluyuZOnmE=;
	h=Date:To:From:Subject:From;
	b=vmBoMOiN2yxq9/QcVvG4TmrJWB4IWcRbe+RkSLJ+FEh4nzH1o++BhBJaYgkOM7foT
	 J8pJCWoeSIj/if0PqL9XDhuaoTbP05eMb4gbeoXEkLOZLMBZyG55HLkdDTLp5pTNwu
	 maSnNZNo5//aWa+p1kInj5uZ++iSx5tGp85Bbn60=
Date: Mon, 22 Dec 2025 18:01:32 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,broonie@kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch added to mm-new branch
Message-Id: <20251223020132.E7339C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: take into account hierarchical percpu tree items for static mm_struct definitions
has been added to the -mm mm-new branch.  Its filename is
     mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: take into account hierarchical percpu tree items for static mm_struct definitions
Date: Sun, 21 Dec 2025 18:29:25 -0500

Both init_mm and efi_mm static definitions need to make room for the
hierarchical percpu counters items.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Link: https://lkml.kernel.org/r/20251221232926.450602-5-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h            |    6 +--
 include/linux/percpu_counter_tree.h |   51 ++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions
+++ a/include/linux/mm_types.h
@@ -1366,9 +1366,9 @@ static inline void __mm_flags_set_mask_b
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
-#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
-{								\
-	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
+{													\
+	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE - 1] = 0	\
 }
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
--- a/include/linux/percpu_counter_tree.h~mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions
+++ a/include/linux/percpu_counter_tree.h
@@ -10,6 +10,52 @@
 
 #ifdef CONFIG_SMP
 
+#if NR_CPUS == (1U << 0)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	0
+#elif NR_CPUS <= (1U << 1)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1
+#elif NR_CPUS <= (1U << 2)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	3
+#elif NR_CPUS <= (1U << 3)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 4)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 5)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	11
+#elif NR_CPUS <= (1U << 6)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 7)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 8)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	37
+#elif NR_CPUS <= (1U << 9)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	73
+#elif NR_CPUS <= (1U << 10)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	149
+#elif NR_CPUS <= (1U << 11)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	293
+#elif NR_CPUS <= (1U << 12)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	585
+#elif NR_CPUS <= (1U << 13)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1173
+#elif NR_CPUS <= (1U << 14)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	2341
+#elif NR_CPUS <= (1U << 15)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 16)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 17)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	8777
+#elif NR_CPUS <= (1U << 18)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	17481
+#elif NR_CPUS <= (1U << 19)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	34953
+#elif NR_CPUS <= (1U << 20)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	69905
+#else
+# error "Unsupported number of CPUs."
+#endif
+
 struct percpu_counter_tree_level_item {
 	atomic_t count;			/*
 					 * Count the number of carry fort this tree item.
@@ -18,6 +64,9 @@ struct percpu_counter_tree_level_item {
 					 */
 } ____cacheline_aligned_in_smp;
 
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	\
+	(PERCPU_COUNTER_TREE_STATIC_NR_ITEMS * sizeof(struct percpu_counter_tree_level_item))
+
 struct percpu_counter_tree {
 	/* Fast-path fields. */
 	unsigned int __percpu *level0;	/* Pointer to per-CPU split counters (tree level 0). */
@@ -92,6 +141,8 @@ int percpu_counter_tree_approximate_sum(
 
 #else	/* !CONFIG_SMP */
 
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	0
+
 struct percpu_counter_tree_level_item;
 
 struct percpu_counter_tree {
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch
mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch
tsacct-skip-all-kernel-threads.patch

