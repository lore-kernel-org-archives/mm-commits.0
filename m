Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700ADC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54AB5611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhEEBlK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBlJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BF1D61029;
        Wed,  5 May 2021 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178813;
        bh=5qrngxIcIvt52OhLjQMF97txiZKS2ZhMH2EfQoU5/NQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KTKs67PwYy+i+MX1qU+UKV3M6pRpSE3xnoZq/0XyRpQK1P1P6dFnO2U6pD4sz2eTq
         k8bxaQTZBcWRVCTbvIGFLrgbGjPIOepgEf8o+Oyr6zIz/oHnV3CQdPzYn+3PrP/InH
         aJi/7zNEJ2/dtBRt/dSU3weuOI2nkiQinNqX53Sw=
Date:   Tue, 04 May 2021 18:40:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 138/143] mm/mempool: minor coding style tweaks
Message-ID: <20210505014012.xBjap7uSP%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/mempool: minor coding style tweaks

Various coding style tweaks to various files under mm/

[daizhiyuan@phytium.com.cn: mm/swapfile: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614223624-16055-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/sparse: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614227288-19363-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/vmscan: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614227649-19853-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/compaction: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614228218-20770-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/oom_kill: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614228360-21168-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/shmem: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614228504-21491-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/page_alloc: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614228613-21754-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/filemap: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1614228936-22337-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/mlock: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1613956588-2453-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/frontswap: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1613962668-15045-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/vmalloc: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1613963379-15988-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/memory_hotplug: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1613971784-24878-1-git-send-email-daizhiyuan@phytium.com.cn
[daizhiyuan@phytium.com.cn: mm/mempolicy: minor coding style tweaks]
  Link: https://lkml.kernel.org/r/1613972228-25501-1-git-send-email-daizhiyuan@phytium.com.cn
Link: https://lkml.kernel.org/r/1614222374-13805-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    2 +-
 mm/filemap.c        |    8 ++++----
 mm/frontswap.c      |   12 ++++++++----
 mm/memory_hotplug.c |    2 +-
 mm/mempolicy.c      |    4 ++--
 mm/mempool.c        |    2 +-
 mm/mlock.c          |    4 ++--
 mm/oom_kill.c       |    2 +-
 mm/page_alloc.c     |    2 +-
 mm/shmem.c          |    2 +-
 mm/sparse.c         |    2 +-
 mm/swapfile.c       |    4 ++--
 mm/vmalloc.c        |    2 +-
 mm/vmscan.c         |    2 +-
 14 files changed, 27 insertions(+), 23 deletions(-)

--- a/mm/compaction.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/compaction.c
@@ -2885,7 +2885,7 @@ void wakeup_kcompactd(pg_data_t *pgdat,
  */
 static int kcompactd(void *p)
 {
-	pg_data_t *pgdat = (pg_data_t*)p;
+	pg_data_t *pgdat = (pg_data_t *)p;
 	struct task_struct *tsk = current;
 	unsigned int proactive_defer = 0;
 
--- a/mm/filemap.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/filemap.c
@@ -3267,7 +3267,7 @@ const struct vm_operations_struct generi
 
 /* This is used for a general mmap of a disk file */
 
-int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct address_space *mapping = file->f_mapping;
 
@@ -3292,11 +3292,11 @@ vm_fault_t filemap_page_mkwrite(struct v
 {
 	return VM_FAULT_SIGBUS;
 }
-int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -ENOSYS;
 }
-int generic_file_readonly_mmap(struct file * file, struct vm_area_struct * vma)
+int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -ENOSYS;
 }
@@ -3724,7 +3724,7 @@ EXPORT_SYMBOL(generic_perform_write);
 ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space * mapping = file->f_mapping;
+	struct address_space *mapping = file->f_mapping;
 	struct inode 	*inode = mapping->host;
 	ssize_t		written = 0;
 	ssize_t		err;
--- a/mm/frontswap.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/frontswap.c
@@ -60,16 +60,20 @@ static u64 frontswap_succ_stores;
 static u64 frontswap_failed_stores;
 static u64 frontswap_invalidates;
 
-static inline void inc_frontswap_loads(void) {
+static inline void inc_frontswap_loads(void)
+{
 	data_race(frontswap_loads++);
 }
-static inline void inc_frontswap_succ_stores(void) {
+static inline void inc_frontswap_succ_stores(void)
+{
 	data_race(frontswap_succ_stores++);
 }
-static inline void inc_frontswap_failed_stores(void) {
+static inline void inc_frontswap_failed_stores(void)
+{
 	data_race(frontswap_failed_stores++);
 }
-static inline void inc_frontswap_invalidates(void) {
+static inline void inc_frontswap_invalidates(void)
+{
 	data_race(frontswap_invalidates++);
 }
 #else
--- a/mm/memory_hotplug.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/memory_hotplug.c
@@ -834,7 +834,7 @@ static inline struct zone *default_zone_
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone * zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
+struct zone *zone_for_pfn_range(int online_type, int nid, unsigned start_pfn,
 		unsigned long nr_pages)
 {
 	if (online_type == MMOP_ONLINE_KERNEL)
--- a/mm/mempolicy.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/mempolicy.c
@@ -330,7 +330,7 @@ static void mpol_rebind_nodemask(struct
 	else if (pol->flags & MPOL_F_RELATIVE_NODES)
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 	else {
-		nodes_remap(tmp, pol->v.nodes,pol->w.cpuset_mems_allowed,
+		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
 								*nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
@@ -1161,7 +1161,7 @@ int do_migrate_pages(struct mm_struct *m
 
 	tmp = *from;
 	while (!nodes_empty(tmp)) {
-		int s,d;
+		int s, d;
 		int source = NUMA_NO_NODE;
 		int dest = 0;
 
--- a/mm/mempool.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/mempool.c
@@ -251,7 +251,7 @@ EXPORT_SYMBOL(mempool_init);
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,
+	return mempool_create_node(min_nr, alloc_fn, free_fn, pool_data,
 				   GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
--- a/mm/mlock.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/mlock.c
@@ -559,7 +559,7 @@ static int apply_vma_lock_flags(unsigned
 				vm_flags_t flags)
 {
 	unsigned long nstart, end, tmp;
-	struct vm_area_struct * vma, * prev;
+	struct vm_area_struct *vma, *prev;
 	int error;
 
 	VM_BUG_ON(offset_in_page(start));
@@ -737,7 +737,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
-	struct vm_area_struct * vma, * prev = NULL;
+	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
 	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
--- a/mm/oom_kill.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/oom_kill.c
@@ -993,7 +993,7 @@ static void oom_kill_process(struct oom_
 	if (oom_group) {
 		mem_cgroup_print_oom_group(oom_group);
 		mem_cgroup_scan_tasks(oom_group, oom_kill_memcg_member,
-				      (void*)message);
+				      (void *)message);
 		mem_cgroup_put(oom_group);
 	}
 }
--- a/mm/page_alloc.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/page_alloc.c
@@ -8808,7 +8808,7 @@ int alloc_contig_range(unsigned long sta
 	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret && ret != -EBUSY)
 		goto done;
-	ret =0;
+	ret = 0;
 
 	/*
 	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
--- a/mm/shmem.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/shmem.c
@@ -3508,7 +3508,7 @@ static int shmem_parse_options(struct fs
 			}
 		}
 		if (*this_char) {
-			char *value = strchr(this_char,'=');
+			char *value = strchr(this_char, '=');
 			size_t len = 0;
 			int err;
 
--- a/mm/sparse.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/sparse.c
@@ -257,7 +257,7 @@ static void __init memory_present(int ni
 	if (unlikely(!mem_section)) {
 		unsigned long size, align;
 
-		size = sizeof(struct mem_section*) * NR_SECTION_ROOTS;
+		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
 		mem_section = memblock_alloc(size, align);
 		if (!mem_section)
--- a/mm/swapfile.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/swapfile.c
@@ -2780,7 +2780,7 @@ static int swap_show(struct seq_file *sw
 	unsigned int bytes, inuse;
 
 	if (si == SEQ_START_TOKEN) {
-		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
+		seq_puts(swap, "Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
 		return 0;
 	}
 
@@ -3284,7 +3284,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 					 sizeof(long),
 					 GFP_KERNEL);
 
-	if (p->bdev &&(swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
+	if (p->bdev && (swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 		/*
 		 * When discard is enabled for swap with no particular
 		 * policy flagged, we set all swap discard flags here in
--- a/mm/vmalloc.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/vmalloc.c
@@ -3083,7 +3083,7 @@ EXPORT_SYMBOL(vzalloc_node);
  * 64b systems should always have either DMA or DMA32 zones. For others
  * GFP_DMA32 should do the right thing and use the normal zone.
  */
-#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
+#define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)
 #endif
 
 /**
--- a/mm/vmscan.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/vmscan.c
@@ -4059,7 +4059,7 @@ static int kswapd(void *p)
 {
 	unsigned int alloc_order, reclaim_order;
 	unsigned int highest_zoneidx = MAX_NR_ZONES - 1;
-	pg_data_t *pgdat = (pg_data_t*)p;
+	pg_data_t *pgdat = (pg_data_t *)p;
 	struct task_struct *tsk = current;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
_
