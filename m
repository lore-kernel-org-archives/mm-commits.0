Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0791DFCB
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755039421; cv=none; b=qWwxAJf47Ud+zGrJ73diMfXC3Gly1ea/cVhayu9EPbcTZNszBpdWccCcaotZ/sLo/YkCevgcGm3/7X894JA/LLYrvXKfmFmVY/Ya/XshXgktZMsvzXYf66JKmwwlELl4yn7fRFAwCmdP4X5Cru1uihDEhDcuBykDM1EQf0n9ZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755039421; c=relaxed/simple;
	bh=qr2SYffedTCBqFDRFPYL7t2Sozqs8wJslT9r9KpHcVs=;
	h=Date:To:From:Subject:Message-Id; b=dkE8SsQW6RmBbYFhCDoMEIbQPkqYtSvT98NWd54o/vRCTJ9Fq497xhwcfsIyVTVfRqr8b9WGv4UFfl0C1eVDu9be2roMemUYYkFl3ey+c+F60Ccy4mgpzuffYtC46eBrDAbJAenoU+D5O4vu0sWILNANin++4uiQOEpVtvPKErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ps922+6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ps922+6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC62C4CEF0;
	Tue, 12 Aug 2025 22:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755039420;
	bh=qr2SYffedTCBqFDRFPYL7t2Sozqs8wJslT9r9KpHcVs=;
	h=Date:To:From:Subject:From;
	b=Ps922+6HVOwxdI2mpnH5e7nx+3CFZgP18CkIyWPf3V1mtvSGp8lY/6MtkVHEQhjWS
	 knD93nlwDJMF4ApsdLitjLQ54e1lHkl8GkBeQi1ntocgT4w37U1IWYQccT8pEKf2PX
	 KtL6flJNDBADiTG94h4PaIPPqBPLgT9hnkjHGMbs=
Date: Tue, 12 Aug 2025 15:56:59 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sj@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-__gfp_nowarn.patch added to mm-new branch
Message-Id: <20250812225700.0AC62C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove redundant __GFP_NOWARN
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-redundant-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-__gfp_nowarn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: mm: remove redundant __GFP_NOWARN
Date: Tue, 12 Aug 2025 21:52:25 +0800

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250812135225.274316-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 mm/filemap.c          |    2 +-
 mm/mmu_gather.c       |    4 ++--
 mm/rmap.c             |    2 +-
 mm/vmalloc.c          |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/damon/ops-common.c~mm-remove-redundant-__gfp_nowarn
+++ a/mm/damon/ops-common.c
@@ -303,7 +303,7 @@ static unsigned int __damon_migrate_foli
 		 * instead of migrated.
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOWARN | __GFP_NOMEMALLOC | GFP_NOWAIT,
+			__GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
 	};
 
--- a/mm/filemap.c~mm-remove-redundant-__gfp_nowarn
+++ a/mm/filemap.c
@@ -1961,7 +1961,7 @@ no_page:
 			gfp &= ~__GFP_FS;
 		if (fgp_flags & FGP_NOWAIT) {
 			gfp &= ~GFP_KERNEL;
-			gfp |= GFP_NOWAIT | __GFP_NOWARN;
+			gfp |= GFP_NOWAIT;
 		}
 		if (WARN_ON_ONCE(!(fgp_flags & (FGP_LOCK | FGP_FOR_MMAP))))
 			fgp_flags |= FGP_LOCK;
--- a/mm/mmu_gather.c~mm-remove-redundant-__gfp_nowarn
+++ a/mm/mmu_gather.c
@@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_ga
 	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
 		return false;
 
-	batch = (void *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+	batch = (void *)__get_free_page(GFP_NOWAIT);
 	if (!batch)
 		return false;
 
@@ -364,7 +364,7 @@ void tlb_remove_table(struct mmu_gather
 	struct mmu_table_batch **batch = &tlb->batch;
 
 	if (*batch == NULL) {
-		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
+		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
 		if (*batch == NULL) {
 			tlb_table_invalidate(tlb);
 			tlb_remove_table_one(table);
--- a/mm/rmap.c~mm-remove-redundant-__gfp_nowarn
+++ a/mm/rmap.c
@@ -285,7 +285,7 @@ int anon_vma_clone(struct vm_area_struct
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
-		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
+		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
 			unlock_anon_vma_root(root);
 			root = NULL;
--- a/mm/vmalloc.c~mm-remove-redundant-__gfp_nowarn
+++ a/mm/vmalloc.c
@@ -5196,7 +5196,7 @@ static void vmap_init_nodes(void)
 	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
-		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
+		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT);
 		if (vn) {
 			/* Node partition is 16 pages. */
 			vmap_zone_size = (1 << 4) * PAGE_SIZE;
_

Patches currently in -mm which might be from rongqianfeng@vivo.com are

xarray-remove-redundant-__gfp_nowarn.patch
maple_tree-remove-redundant-__gfp_nowarn.patch
mm-remove-redundant-__gfp_nowarn.patch
ref_tracker-remove-redundant-__gfp_nowarn.patch

