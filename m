Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ACC3A7F60
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353449; cv=none; b=ChTjDbVseyp6LmThUNNzXxUhYWmU/vHtyyBkeTPaFjvEQWVL8wxH3epMxxjF3vH9GY4cRcNskFHPJjqnmvUBVhXw9jBQUSF1iR4XJeRzeMXhLAI2hOEtgSFo+y7q0dsBx6gL3xGFB3VKVDLsHMBNYeJreCtGea4FKIfya71bG6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353449; c=relaxed/simple;
	bh=ShgJtmp/MaL5BgJD+X2+BSjHl9gmDX12AhKw4OjIZAU=;
	h=Date:To:From:Subject:Message-Id; b=nwWD51YfR5cmGQfUStXYuX9mhgSwwvxKr8XUffA9vHvMn3HLSdJFjjYiPRCWHPRZ0APDGOlKLyljtFVaul1+zygK6X3QQADZzR04XRUuaCsNQVVa2ogLWD5Rvd2MZkCf36j8eobT/belptNcw8j0QLRAwtrEuEmuPsoYSc1yZ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LwCIssOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LwCIssOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD321F000E9;
	Thu, 25 Jun 2026 02:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353447;
	bh=vD2Ls5Ywn202u84eJkNVcYr5xCwRmwXrx5LqkkKhbNI=;
	h=Date:To:From:Subject;
	b=LwCIssOqe4bvxYxT/luB1ZrjMMJvdEqdBP8aVFdutkz2pCp3vriyJ2ZB+Lx8p5/+n
	 Tq9xEx6PmALPCsI9y5ivAOqg4eGT9vJDREpGGze0xn7GfxzS/TON/qIQH/WNq/DSQ4
	 Bo3QcVCeHudIBb/c9WGVVFqlgkxRlk27pztTqEwk=
Date: Wed, 24 Jun 2026 19:10:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-honor-gfp-constraints-when-populating-chunks.patch added to mm-new branch
Message-Id: <20260625021047.CDD321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: honor GFP constraints when populating chunks
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-honor-gfp-constraints-when-populating-chunks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-honor-gfp-constraints-when-populating-chunks.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/percpu: honor GFP constraints when populating chunks
Date: Thu, 18 Jun 2026 21:04:12 +0800

pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
passes it down to pcpu_populate_chunk().  pcpu_alloc_pages() already uses
that mask for backing page allocation.

However, the populate slow path still has internal allocations and page
table allocations which can lose the caller's allocation context.  The
temporary pages array is allocated by pcpu_get_pages() with GFP_KERNEL,
and pcpu_map_pages() maps the backing pages through
vmap_pages_range_noflush() using GFP_KERNEL.  The latter can allocate
vmalloc page tables implicitly, so a caller which deliberately uses
GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while populating a
percpu chunk.

This has the same concern as chunk creation: callers such as blk-cgroup
may use GFP_NOIO because they hold locks which can be involved in queue
freeze or IO reclaim dependencies.  If an allocation reaches the percpu
slow path and needs to populate previously unbacked pages, the internal
GFP_KERNEL allocations can defeat that context.

One possible case is blk-cgroup after commit 5d726c4dbeed ("blk-cgroup:
fix possible deadlock while configuring policy").  blkg_conf_prep() now
serializes against blkcg_deactivate_policy() with q->blkcg_mutex, and
blkg_alloc() was changed to GFP_NOIO for that reason:

  CPU0: blkg_conf_prep()
    mutex_lock(q->blkcg_mutex)
    blkg_alloc(..., GFP_NOIO)
      alloc_percpu_gfp(..., GFP_NOIO)
        pcpu_alloc_noprof(..., GFP_NOIO)
          pcpu_populate_chunk(GFP_NOIO)
            pcpu_get_pages()
	    pcpu_map_pages()
              -> if the selected percpu chunk has unpopulated pages,
	         chunk population may do internal GFP_KERNEL allocations
              -> direct reclaim / writeback can issue IO to this queue
              -> IO waits because the queue is frozen

  CPU1: blkcg_deactivate_policy()
    blk_mq_freeze_queue(q)
    mutex_lock(q->blkcg_mutex)
      -> waits for CPU0
    ... unfreeze only happens after q->blkcg_mutex is acquired/released

So the concern is that the caller deliberately uses GFP_NOIO because it
may hold a lock which can be acquired after queue freeze, but the percpu
slow path can temporarily lose that allocation context.

Pass pcpu_gfp through pcpu_get_pages(), pcpu_map_pages() and
__pcpu_map_pages().  Apply the corresponding memalloc scope around
vmap_pages_range_noflush(), because vmalloc page table allocation does not
pass the GFP mask down explicitly.  Keep the first chunk setup path using
GFP_KERNEL, matching the previous early-init behavior.

Link: https://lore.kernel.org/20260618130414.96383-3-kaitao.cheng@linux.dev
Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |   38 ++++++++++++++++++++++++++------------
 mm/percpu.c    |    2 +-
 2 files changed, 27 insertions(+), 13 deletions(-)

--- a/mm/percpu.c~mm-percpu-honor-gfp-constraints-when-populating-chunks
+++ a/mm/percpu.c
@@ -3256,7 +3256,7 @@ int __init pcpu_page_first_chunk(size_t
 
 		/* pte already populated, the following shouldn't fail */
 		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
-				      unit_pages);
+				      unit_pages, GFP_KERNEL);
 		if (rc < 0)
 			panic("failed to map percpu area, err=%d\n", rc);
 
--- a/mm/percpu-vm.c~mm-percpu-honor-gfp-constraints-when-populating-chunks
+++ a/mm/percpu-vm.c
@@ -21,6 +21,7 @@ static struct page *pcpu_chunk_page(stru
 
 /**
  * pcpu_get_pages - get temp pages array
+ * @gfp: allocation flags passed to the underlying allocator
  *
  * Returns pointer to array of pointers to struct page which can be indexed
  * with pcpu_page_idx().  Note that there is only one array and accesses
@@ -29,7 +30,7 @@ static struct page *pcpu_chunk_page(stru
  * RETURNS:
  * Pointer to temp pages array on success.
  */
-static struct page **pcpu_get_pages(void)
+static struct page **pcpu_get_pages(gfp_t gfp)
 {
 	static struct page **pages;
 	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
@@ -37,7 +38,7 @@ static struct page **pcpu_get_pages(void
 	lockdep_assert_held(&pcpu_alloc_mutex);
 
 	if (!pages)
-		pages = pcpu_mem_zalloc(pages_size, GFP_KERNEL);
+		pages = pcpu_mem_zalloc(pages_size, gfp);
 	return pages;
 }
 
@@ -191,10 +192,22 @@ static void pcpu_post_unmap_tlb_flush(st
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
-			    int nr_pages)
+			    int nr_pages, gfp_t gfp)
 {
-	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
+	unsigned int flags;
+	int ret;
+
+	/*
+	 * The vmalloc page table allocation path does not pass @gfp down
+	 * explicitly.  Apply the corresponding memalloc scope so implicit
+	 * page table allocations preserve NOFS/NOIO constraints.
+	 */
+	flags = memalloc_apply_gfp_scope(gfp);
+	ret = vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
+				       PAGE_KERNEL, pages, PAGE_SHIFT, gfp);
+	memalloc_restore_scope(flags);
+
+	return ret;
 }
 
 /**
@@ -203,6 +216,7 @@ static int __pcpu_map_pages(unsigned lon
  * @pages: pages array containing pages to be mapped
  * @page_start: page index of the first page to map
  * @page_end: page index of the last page to map + 1
+ * @gfp: allocation flags passed to the underlying allocator
  *
  * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
  * caller is responsible for calling pcpu_post_map_flush() after all
@@ -211,8 +225,8 @@ static int __pcpu_map_pages(unsigned lon
  * This function is responsible for setting up whatever is necessary for
  * reverse lookup (addr -> chunk).
  */
-static int pcpu_map_pages(struct pcpu_chunk *chunk,
-			  struct page **pages, int page_start, int page_end)
+static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
+			  int page_start, int page_end, gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
 	int i, err;
@@ -220,7 +234,7 @@ static int pcpu_map_pages(struct pcpu_ch
 	for_each_possible_cpu(cpu) {
 		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				       &pages[pcpu_page_idx(cpu, page_start)],
-				       page_end - page_start);
+				       page_end - page_start, gfp);
 		if (err < 0)
 			goto err;
 
@@ -271,21 +285,21 @@ static void pcpu_post_map_flush(struct p
  * @chunk.
  *
  * CONTEXT:
- * pcpu_alloc_mutex, does GFP_KERNEL allocation.
+ * pcpu_alloc_mutex, does @gfp allocation.
  */
 static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
 			       int page_start, int page_end, gfp_t gfp)
 {
 	struct page **pages;
 
-	pages = pcpu_get_pages();
+	pages = pcpu_get_pages(gfp);
 	if (!pages)
 		return -ENOMEM;
 
 	if (pcpu_alloc_pages(chunk, pages, page_start, page_end, gfp))
 		return -ENOMEM;
 
-	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
+	if (pcpu_map_pages(chunk, pages, page_start, page_end, gfp)) {
 		pcpu_free_pages(chunk, pages, page_start, page_end);
 		return -ENOMEM;
 	}
@@ -319,7 +333,7 @@ static void pcpu_depopulate_chunk(struct
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages();
+	pages = pcpu_get_pages(GFP_KERNEL);
 	BUG_ON(!pages);
 
 	/* unmap and free */
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch
mm-percpu-honor-gfp-constraints-when-populating-chunks.patch
mm-percpu-make-cached-pages-lookup-explicit.patch
mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch

