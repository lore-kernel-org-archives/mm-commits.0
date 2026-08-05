Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF443BD649
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896609; cv=none; b=soumdH/NYHbAzWO6ryYsY7lWrY1YSW4OEXHGY2WMEvM0V29Du2ZE/21iEEkYTJX3bcM3YWn6UkySwOUgd3zw+XEg9gPLXlYIRJJjaVCWMgjBZWePG3ZkK41fnqc4k/lkq9elmbn3c+G+PVSm/hanloqosnkhuqk0anpsHTpCYbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896609; c=relaxed/simple;
	bh=2pXCYQLCNzBwKzxxyQn/EYVxbn9WbAlCmqRJX2G3mHc=;
	h=Date:To:From:Subject:Message-Id; b=AkGCQAR69txCWFnmhvoJSTxkDH7MXFHD7lXpwgrB5nm9cUL3+bK44BKWWbT6hTLy2cAHcikW5GY28q46ATec+mbJhkiD/eQdSphhkCQTQPCsnZF6NbpYJXFphpt476a2SRHCf1x2BoUQ8py0SEYHq5Ia7s4Pn+n4Rd9Ky/MpeMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j5sbKoI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j5sbKoI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB431F000E9;
	Wed,  5 Aug 2026 02:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896607;
	bh=vX61IDf31eZ42f2a1+fuV7GC4cSVqDWLKigY6+bSAuE=;
	h=Date:To:From:Subject;
	b=j5sbKoI1cqciCy0tzsv8fDQlwza3H6nT1/2QUkZPOUBti+e+4tIEaL0scgQwXnDyn
	 8WHbt867tZhAIQNvNWTWyikywhaBIoM1yrPplo3ylnCAabCAxBsXPaML7Gnota54Y4
	 fkX7dODUQ1uj0+IZvsYLJNeqoQzKoYO9TtDEqVNY=
Date: Tue, 04 Aug 2026 19:23:26 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch removed from -mm tree
Message-Id: <20260805022327.5DB431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: colocate page-cluster sysctl with swap readahead
has been removed from the -mm tree.  Its filename was
     mm-swap-colocate-page-cluster-sysctl-with-swap-readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm/swap: colocate page-cluster sysctl with swap readahead
Date: Wed, 08 Jul 2026 19:35:43 +0800

Patch series "mm: clean up folio LRU and swap declarations", v9.

This series splits folio LRU and swap cleanup into three steps:

  - move the page-cluster sysctl next to swap readahead in
    mm/swap_state.c
  - rename mm/swap.c to mm/folio.c after the swap-specific code
    moves out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in
mm/swap_state.c.  Folio LRU helpers live in mm/folio.c, and MM-internal
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

Call swap_readahead_setup() from swap_init() after moving it, keeping the
readahead defaults and sysctl registration with swap_state.c
initialization.

swap_setup() previously lived in mm/swap.c, which is built
unconditionally, so the vm.page-cluster sysctl was registered also on
CONFIG_SWAP=n kernels.  After moving the setup into swap_state.c, which is
built only when CONFIG_SWAP is enabled, vm.page-cluster is no longer
registered there.  The knob only tunes swap-in readahead and had no effect
without swap.

Link: https://lore.kernel.org/20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com
Link: https://lore.kernel.org/20260708-ch-swap-series-plus-folio-lru-cleanup-v9-1-2bc72b4f8730@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

 include/linux/swap.h |    1 
 mm/swap.c            |   36 -----------------------------
 mm/swap.h            |    2 -
 mm/swap_state.c      |   50 +++++++++++++++++++++++++++++++++++++++--
 mm/vmscan.c          |    1 
 5 files changed, 48 insertions(+), 42 deletions(-)

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
@@ -985,6 +990,35 @@ struct folio *swapin_readahead(swp_entry
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
+static void __init swap_readahead_setup(void)
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
@@ -1014,7 +1048,7 @@ static const struct attribute_group swap
 	.attrs = swap_attrs,
 };
 
-static int __init swap_init(void)
+static int __init swap_sysfs_init(void)
 {
 	int err;
 	struct kobject *swap_kobj;
@@ -1037,5 +1071,17 @@ delete_obj:
 	kobject_put(swap_kobj);
 	return err;
 }
-subsys_initcall(swap_init);
+#else
+static int __init swap_sysfs_init(void)
+{
+	return 0;
+}
 #endif
+
+static int __init swap_init(void)
+{
+	swap_readahead_setup();
+
+	return swap_sysfs_init();
+}
+subsys_initcall(swap_init);
--- a/mm/vmscan.c~mm-swap-colocate-page-cluster-sysctl-with-swap-readahead
+++ a/mm/vmscan.c
@@ -7647,7 +7647,6 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	swap_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
_

Patches currently in -mm which might be from wujianyue000@gmail.com are


