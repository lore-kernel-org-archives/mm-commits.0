Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9338D3ED
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298392; cv=none; b=q8u+dgQ+ibCXJ8m+2PYnTrmoyZfipcQXCzTnhi6FoHO3KyN7oHUFGK7MElJ0gqT9Xwuda5UgkuP5jzu7rJz8uvE7B9UxhpeF4JVijNlDlop+u6MWjsXQKh7Gkf/7WrJY8BfEe0jXab6dfjDVTNzBLtcriRZEA/0vgQiPLyFi+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298392; c=relaxed/simple;
	bh=DOxEpx4ExIuOrlOgcE2hFTXMX/a4myWEhLtUtYZrvWI=;
	h=Date:To:From:Subject:Message-Id; b=BRDNAIIcUr7laLe+KB5DV7mU7SKKxN3F/al6fXkife4gT0bh/wmNBeqZx1zZxubTz1GA4Vdd48o26j1SYcLfdB7wwoVXcIAzNG1gvAZ49koQvwGQVPm1DxSWaob09VFaSmyJNLvj79x/8vON7h1Zr62ORJlgf1uzluuC3gI0WDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HDf1MlE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HDf1MlE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8F71F00A3A;
	Wed, 29 Jul 2026 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298390;
	bh=Z7FDFgTbCj07wH51nzUGqo4t3qih49Ise8GATb1v38c=;
	h=Date:To:From:Subject;
	b=HDf1MlE+zzDDx1LoPt03ZZbWP37NyGsXbcetjBKVu0CKqQ1Ml0Ih+f++ACLahkFam
	 V5ZkgjfZqKebL8vInxx7gZ8ns4HE8urlqH7gcEYnwfUEqoJoIJdmR2neJ9kEN4V020
	 8e+H87o62/wtl/xbaHy634ci3pd2HQ2SMXuK9NbQ=
Date: Tue, 28 Jul 2026 21:13:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,shivamkalra98@zohomail.in,pfalcato@suse.de,mhocko@suse.com,dennis@kernel.org,cl@gentwo.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch removed from -mm tree
Message-Id: <20260729041310.4B8F71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
Date: Thu, 18 Jun 2026 21:04:11 +0800

Patch series "mm/percpu: Fix possible NOFS/NOIO reclaim recursion", v4.

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
pcpu_alloc_mutex and the chunk creation slow path.  This restored the
allocation capability that was lost when those constrained allocations
were treated as atomic, but it also makes the percpu slow path visible to
callers from constrained reclaim contexts.

There are two related problems.

First, the create and populate slow paths do not fully preserve the
caller's allocation constraints.  pcpu_alloc_noprof() derives pcpu_gfp
from the caller supplied GFP mask and passes it down to the percpu backing
page allocator.  However, chunk creation calls pcpu_get_vm_areas(), and
chunk population can allocate temporary metadata or vmalloc page tables
while mapping backing pages.  Those internal allocations can still use
GFP_KERNEL, so a caller using GFP_NOFS or GFP_NOIO can enter unconstrained
FS or IO reclaim while holding pcpu_alloc_mutex.

One possible case is blk-cgroup after commit 5d726c4dbeed ("blk-cgroup:
fix possible deadlock while configuring policy").  blkg_conf_prep() now
serializes against blkcg_deactivate_policy() with q->blkcg_mutex, and
blkg_alloc() uses GFP_NOIO because queue freeze and IO reclaim
dependencies can otherwise deadlock.  If the percpu slow path loses that
GFP_NOIO context, direct reclaim or writeback can issue IO to a frozen
queue while q->blkcg_mutex is held.

Second, allowing sleepable GFP_NOFS/GFP_NOIO allocations to take
pcpu_alloc_mutex means that unconstrained backing allocations made under
the mutex can create an FS/IO reclaim dependency against a constrained
caller which already holds an FS or IO lock and then waits for
pcpu_alloc_mutex.

This series fixes those issues in three steps:

  - pass the caller supplied GFP mask into pcpu_get_vm_areas() and use it
    for vmalloc metadata and KASAN shadow allocations;
  - pass the GFP mask through the chunk population path, including the
    temporary pages array and vmalloc page table allocation scope;
  - restrict percpu backing allocations performed while holding
    pcpu_alloc_mutex to GFP_NOIO, so they cannot recurse into IO or FS
    reclaim.

This keeps sleepable GFP_NOFS/GFP_NOIO percpu allocations working, while
avoiding the reclaim recursion risks introduced by making those
allocations eligible for the mutex-protected slow path.


This patch (of 4):

pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
passes it down to the backing percpu allocator.  However, when the percpu
vmalloc allocator has to create a new chunk, pcpu_create_chunk() calls
pcpu_get_vm_areas() to allocate the corresponding vmalloc areas.

pcpu_get_vm_areas() currently performs its internal allocations with
GFP_KERNEL, including vmap area metadata, vm_struct metadata and KASAN
vmalloc shadow population.  This means that a caller which deliberately
uses GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while creating
the vmalloc areas for a new percpu chunk.

One possible case is blk-cgroup after commit 5d726c4dbeed ("blk-cgroup:
fix possible deadlock while configuring policy").  blkg_conf_prep() now
serializes against blkcg_deactivate_policy() with q->blkcg_mutex, and
blkg_alloc() was changed to GFP_NOIO for that reason:

  CPU0: blkg_conf_prep()
    mutex_lock(q->blkcg_mutex)
    blkg_alloc(..., GFP_NOIO)
      alloc_percpu_gfp(..., GFP_NOIO)
        pcpu_alloc_noprof(..., GFP_NOIO)
	  pcpu_create_chunk(GFP_NOIO)
	    pcpu_get_vm_areas()
              -> if percpu chunks are exhausted, chunk create may do
                 internal GFP_KERNEL allocations
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

Pass the caller supplied GFP mask from pcpu_create_chunk() to
pcpu_get_vm_areas(), and use it for the internal vmalloc metadata and
KASAN shadow allocations.

Link: https://lore.kernel.org/20260618130414.96383-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260618130414.96383-2-kaitao.cheng@linux.dev
Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Shivam Kalra <shivamkalra98@zohomail.in>
Acked-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 mm/percpu-vm.c          |    2 +-
 mm/vmalloc.c            |   23 ++++++++++++-----------
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas
+++ a/include/linux/vmalloc.h
@@ -310,14 +310,14 @@ static inline void set_vm_flush_reset_pe
 #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align);
+				     size_t align, gfp_t gfp);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
 # else
 static inline struct vm_struct **
 pcpu_get_vm_areas(const unsigned long *offsets,
 		const size_t *sizes, int nr_vms,
-		size_t align)
+		size_t align, gfp_t gfp)
 {
 	return NULL;
 }
--- a/mm/percpu-vm.c~mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas
+++ a/mm/percpu-vm.c
@@ -340,7 +340,7 @@ static struct pcpu_chunk *pcpu_create_ch
 		return NULL;
 
 	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				pcpu_nr_groups, pcpu_atom_size);
+				pcpu_nr_groups, pcpu_atom_size, gfp);
 	if (!vms) {
 		pcpu_free_chunk(chunk);
 		return NULL;
--- a/mm/vmalloc.c~mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -4946,16 +4946,17 @@ pvm_determine_end_from_reverse(struct vm
  * @sizes: array containing size of each area
  * @nr_vms: the number of areas to allocate
  * @align: alignment, all entries in @offsets and @sizes must be aligned to this
+ * @gfp: allocation flags passed to the underlying memory allocator
  *
  * Returns: kmalloc'd vm_struct pointer array pointing to allocated
  *	    vm_structs on success, %NULL on failure
  *
  * Percpu allocator wants to use congruent vm areas so that it can
  * maintain the offsets among percpu areas.  This function allocates
- * congruent vmalloc areas for it with GFP_KERNEL.  These areas tend to
- * be scattered pretty far, distance between two areas easily going up
- * to gigabytes.  To avoid interacting with regular vmallocs, these
- * areas are allocated from top.
+ * congruent vmalloc areas for it. These areas tend to be scattered
+ * pretty far, distance between two areas easily going up to gigabytes.
+ * To avoid interacting with regular vmallocs, these areas are allocated
+ * from top.
  *
  * Despite its complicated look, this allocator is rather simple. It
  * does everything top-down and scans free blocks from the end looking
@@ -4966,7 +4967,7 @@ pvm_determine_end_from_reverse(struct vm
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align)
+				     size_t align, gfp_t gfp)
 {
 	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
 	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
@@ -5004,14 +5005,14 @@ struct vm_struct **pcpu_get_vm_areas(con
 		return NULL;
 	}
 
-	vms = kzalloc_objs(vms[0], nr_vms);
-	vas = kzalloc_objs(vas[0], nr_vms);
+	vms = kzalloc_objs(vms[0], nr_vms, gfp);
+	vas = kzalloc_objs(vas[0], nr_vms, gfp);
 	if (!vas || !vms)
 		goto err_free2;
 
 	for (area = 0; area < nr_vms; area++) {
-		vas[area] = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
-		vms[area] = kzalloc_obj(struct vm_struct);
+		vas[area] = kmem_cache_zalloc(vmap_area_cachep, gfp);
+		vms[area] = kzalloc_obj(struct vm_struct, gfp);
 		if (!vas[area] || !vms[area])
 			goto err_free;
 	}
@@ -5101,7 +5102,7 @@ retry:
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], gfp))
 			goto err_free_shadow;
 	}
 
@@ -5158,7 +5159,7 @@ overflow:
 				continue;
 
 			vas[area] = kmem_cache_zalloc(
-				vmap_area_cachep, GFP_KERNEL);
+				vmap_area_cachep, gfp);
 			if (!vas[area])
 				goto err_free;
 		}
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch
mm-kconfig-drop-redundant-dependency-wrappers.patch

