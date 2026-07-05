Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CADB264612
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783279309; cv=none; b=HutC+hTt9jwuAkU5OmG/ce9GeS4KTPTqYEJFVlx8RiqHZg+siaua4mDBX3fadtRHuliRNsuNCWvpq65YPx0/rn+MSVHBp4jYCAlfEcfEezvjPSHzZEdc1cIxcuDFVzvF8HqbO3CKmtQceRyssbBOSEnNTMWD7ugAzodmD7gefPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783279309; c=relaxed/simple;
	bh=gzLSyIZ525FkG1PasTFglSD9hantkzUlqifqzP+nLN4=;
	h=Date:To:From:Subject:Message-Id; b=WqNRV2wqsPfVH/GHO+svvmP4f4RYovYtxqkcQKuZBE8JFUbE3cUW6Di8sXme8OJ6a7peXT9VUei1ubCHDCqJaGZENJX5N3mEP+a29t6JLfWpiF9wIikDQzoWpf5EPSUKbimSp0ILm0H28KTd38E4LPfTm/e2keEQ2Rv2BbFOY0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CY2d4cna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CY2d4cna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD561F000E9;
	Sun,  5 Jul 2026 19:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783279308;
	bh=9tZEay7KpUqNzvF1CSYmYRhzv3IzLNetiUme7zHvH0I=;
	h=Date:To:From:Subject;
	b=CY2d4cnaYHMzLHQnu3tTrPSH6slLTIx+6uoKMWHxvtMW1mIRauFPYFSoWGInW30pn
	 2Z3KyL5Ur0SQSsqcvvVL8xTmO8GS5nAaKo9q2r9bdWHEMN+Tmx7BX7tOoX+yaW/gIJ
	 UcEFLXs/S5mKiO8nN25lCJcfccA6aACuhMLeIhIs=
Date: Sun, 05 Jul 2026 12:21:47 -0700
To: mm-commits@vger.kernel.org,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch added to mm-new branch
Message-Id: <20260705192147.EDD561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: colocate page-cluster sysctl with swap readahead
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm/swap: colocate page-cluster sysctl with swap readahead
Date: Sun, 05 Jul 2026 22:12:31 +0800

Patch series "mm: clean up folio LRU and swap declarations", v7.

This series splits folio LRU and swap cleanup into three steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio.c after the swap-specific bits move out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in
mm/swap_state.c, folio LRU helpers live in mm/folio.c, and MM-internal
reclaim/workingset declarations move from include/linux/swap.h to
mm/internal.h (public LRU helpers used outside mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code.  The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.


This patch (of 3):

page_cluster and the vm.page-cluster sysctl are only used by swap-in
readahead in swap_state.c.  Move them out of swap.c together with
swap_readahead_setup(), and make page_cluster static to that file.

Rename swap_setup() while moving it as well.  The helper is internal to MM
and now only sets up swap readahead defaults and its sysctl hook, so the
more specific name matches its reduced scope.

swap_setup() previously lived in mm/swap.c, which is built
unconditionally, so the vm.page-cluster sysctl was registered also on
CONFIG_SWAP=n kernels.  swap_readahead_setup() is now a no-op stub when
CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered there.
The knob only tunes swap-in readahead and had no effect without swap.

Link: https://lore.kernel.org/20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com
Link: https://lore.kernel.org/20260705-ch-swap-series-plus-folio-lru-cleanup-v7-1-a028e8b5fc3d@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swap.c            |   36 ------------------------------------
 mm/swap.h            |    9 +++++++--
 mm/swap_state.c      |   37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |    2 +-
 5 files changed, 45 insertions(+), 40 deletions(-)

--- a/include/linux/swap.h~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/include/linux/swap.h
@@ -340,7 +340,6 @@ extern void lru_add_drain_cpu_zone(struc
 extern void lru_add_drain_all(void);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
-extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
--- a/mm/swap.c~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/mm/swap.c
@@ -44,10 +44,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
-/* How many pages do we try to swap or page in/out together? As a power of 2 */
-int page_cluster;
-static const int page_cluster_max = 31;
-
 struct cpu_fbatches {
 	/*
 	 * The following folio batches are grouped together because they are protected
@@ -1177,35 +1173,3 @@ void lru_reparent_memcg(struct mem_cgrou
 		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
 }
 #endif
-
-static const struct ctl_table swap_sysctl_table[] = {
-	{
-		.procname	= "page-cluster",
-		.data		= &page_cluster,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&page_cluster_max,
-	}
-};
-
-/*
- * Perform any setup for the swap system
- */
-void __init swap_setup(void)
-{
-	unsigned long megs = PAGES_TO_MB(totalram_pages());
-
-	/* Use a smaller cluster for small-memory machines */
-	if (megs < 16)
-		page_cluster = 2;
-	else
-		page_cluster = 3;
-	/*
-	 * Right now other parts of the system means that we
-	 * _really_ don't want to cluster much more
-	 */
-
-	register_sysctl_init("vm", swap_sysctl_table);
-}
--- a/mm/swap.h~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/mm/swap.h
@@ -8,8 +8,6 @@ struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
 
-extern int page_cluster;
-
 #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
 #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 #elif defined(MAX_PHYSMEM_BITS)
@@ -79,6 +77,8 @@ enum swap_cluster_flags {
 };
 
 #ifdef CONFIG_SWAP
+void swap_readahead_setup(void);
+
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
@@ -336,6 +336,11 @@ static inline unsigned int folio_swap_fl
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
+
+static inline void swap_readahead_setup(void)
+{
+}
+
 static inline struct swap_cluster_info *swap_cluster_lock(
 	struct swap_info_struct *si, pgoff_t offset, bool irq)
 {
--- a/mm/swap_state.c~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/mm/swap_state.c
@@ -22,10 +22,15 @@
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
 
+/* Swap readahead cluster size, as a power of 2 pages. */
+static int page_cluster;
+static const int page_cluster_max = 31;
+
 /*
  * swapper_space is a fiction, retained to simplify the path through
  * vmscan's shrink_folio_list.
@@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry
 	return folio;
 }
 
+static const struct ctl_table swap_readahead_sysctl_table[] = {
+	{
+		.procname	= "page-cluster",
+		.data		= &page_cluster,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= (void *)&page_cluster_max,
+	}
+};
+
+/**
+ * swap_readahead_setup - defaults and sysctl for swap cache readahead clustering
+ */
+void __init swap_readahead_setup(void)
+{
+	unsigned long megs = PAGES_TO_MB(totalram_pages());
+
+	/* Use a smaller cluster for small-memory machines */
+	if (megs < 16)
+		page_cluster = 2;
+	else
+		page_cluster = 3;
+	/*
+	 * Right now other parts of the system means that we
+	 * _really_ don't want to cluster much more
+	 */
+
+	register_sysctl_init("vm", swap_readahead_sysctl_table);
+}
+
 #ifdef CONFIG_SYSFS
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
--- a/mm/vmscan.c~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/mm/vmscan.c
@@ -7647,7 +7647,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
+	swap_readahead_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
_

Patches currently in -mm which might be from wujianyue000@gmail.com are

mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch
mm-rename-swapc-to-folioc.patch
mm-move-reclaim-internal-declarations-out-of-swaph.patch

