From: akpm@linux-foundation.org
Subject: [merged]
 treewide-remove-gfp_temporary-allocation-flag.patch removed from -mm tree
Date: Fri, 15 Sep 2017 10:51:28 -0700
Message-ID: <20170915175128.AyBRwNrY0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdIORv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, sfr@canb.auug.org.au, tytso@mit.edu, vbabka@suse.cz, willy@infradead.org


The patch titled
     Subject: mm: treewide: remove GFP_TEMPORARY allocation flag
has been removed from the -mm tree.  Its filename was
     treewide-remove-gfp_temporary-allocation-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: treewide: remove GFP_TEMPORARY allocation flag

GFP_TEMPORARY was been introduced by e12ba74d8ff3 ("Group short-lived and
reclaimable kernel allocations") along with __GFP_RECLAIMABLE.  It's
primary motivation was to allow users to tell that an allocation is short
lived and so the allocator can try to place such allocations close
together and prevent long term fragmentation.  As much as this sounds like
a reasonable semantic it becomes much less clear when to use the highlevel
GFP_TEMPORARY allocation flag.  How long is temporary?  Can the context
holding that memory sleep?  Can it take locks?  It seems there is no good
answer for those questions.

The current implementation of GFP_TEMPORARY is basically GFP_KERNEL |
__GFP_RECLAIMABLE which in itself is tricky because basically none of the
existing caller provide a way to reclaim the allocated memory.  So this is
rather misleading and hard to evaluate for any benefits.

I have checked some random users and none of them has added the flag with
a specific justification.  I suspect most of them just copied from other
existing users and others just thought it might be a good idea to use
without any measuring.  This suggests that GFP_TEMPORARY just motivates
for cargo cult usage without any reasoning.

I believe that our gfp flags are quite complex already and especially
those with highlevel semantic should be clearly defined to prevent from
confusion and abuse.  Therefore I propose dropping GFP_TEMPORARY and
replace all existing users to simply use GFP_KERNEL.  Please note that
SLAB users with shrinkers will still get __GFP_RECLAIMABLE heuristic and
so they will be placed properly for memory fragmentation prevention.

I can see reasons we might want some gfp flag to reflect shorterm
allocations but I propose starting from a clear semantic definition and
only then add users with proper justification.

This was been brought up before LSF this year by Matthew [1] and it turned
out that GFP_TEMPORARY really doesn't have a clear semantic.  It seems to
be a heuristic without any measured advantage for most (if not all) its
current users.  The follow up discussion has revealed that opinions on
what might be temporary allocation differ a lot between developers.  So
rather than trying to tweak existing users into a semantic which they
haven't expected I propose to simply remove the flag and start from
scratch if we really need a semantic for short term allocations.

[1] http://lkml.kernel.org/r/20170118054945.GD18349@bombadil.infradead.org

[akpm@linux-foundation.org: fix typo]
[akpm@linux-foundation.org: coding-style fixes]
[sfr@canb.auug.org.au: drm/i915: fix up]
  Link: http://lkml.kernel.org/r/20170816144703.378d4f4d@canb.auug.org.au
Link: http://lkml.kernel.org/r/20170728091904.14627-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/setup.c                            |    2 -
 arch/arc/kernel/troubleshoot.c                     |    2 -
 arch/powerpc/kernel/rtas.c                         |    4 +--
 arch/powerpc/platforms/pseries/suspend.c           |    2 -
 drivers/gpu/drm/drm_blend.c                        |    2 -
 drivers/gpu/drm/drm_dp_dual_mode_helper.c          |    2 -
 drivers/gpu/drm/drm_scdc_helper.c                  |    2 -
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |    2 -
 drivers/gpu/drm/i915/i915_gem.c                    |    2 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   12 +++++------
 drivers/gpu/drm/i915/i915_gem_gtt.c                |    2 -
 drivers/gpu/drm/i915/i915_gem_userptr.c            |    4 +--
 drivers/gpu/drm/i915/i915_gpu_error.c              |    6 ++---
 drivers/gpu/drm/i915/selftests/i915_random.c       |    2 -
 drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c |   10 ++++-----
 drivers/gpu/drm/i915/selftests/intel_uncore.c      |    2 -
 drivers/gpu/drm/lib/drm_random.c                   |    2 -
 drivers/gpu/drm/msm/msm_gem_submit.c               |    2 -
 drivers/gpu/drm/selftests/test-drm_mm.c            |    4 +--
 drivers/misc/cxl/pci.c                             |    2 -
 drivers/xen/gntalloc.c                             |    2 -
 fs/coredump.c                                      |    2 -
 fs/exec.c                                          |    4 +--
 fs/overlayfs/copy_up.c                             |    2 -
 fs/overlayfs/dir.c                                 |    2 -
 fs/overlayfs/namei.c                               |   12 +++++------
 fs/proc/base.c                                     |    8 +++----
 fs/proc/task_mmu.c                                 |    2 -
 include/linux/gfp.h                                |    2 -
 include/trace/events/mmflags.h                     |    1 
 kernel/locking/test-ww_mutex.c                     |    2 -
 kernel/trace/trace_events_filter.c                 |    2 -
 lib/string_helpers.c                               |    4 +--
 mm/shmem.c                                         |    2 -
 mm/slub.c                                          |    2 -
 tools/perf/builtin-kmem.c                          |    1 
 36 files changed, 57 insertions(+), 61 deletions(-)

diff -puN arch/arc/kernel/setup.c~treewide-remove-gfp_temporary-allocation-flag arch/arc/kernel/setup.c
--- a/arch/arc/kernel/setup.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/arch/arc/kernel/setup.c
@@ -510,7 +510,7 @@ static int show_cpuinfo(struct seq_file
 		goto done;
 	}
 
-	str = (char *)__get_free_page(GFP_TEMPORARY);
+	str = (char *)__get_free_page(GFP_KERNEL);
 	if (!str)
 		goto done;
 
diff -puN arch/arc/kernel/troubleshoot.c~treewide-remove-gfp_temporary-allocation-flag arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/arch/arc/kernel/troubleshoot.c
@@ -178,7 +178,7 @@ void show_regs(struct pt_regs *regs)
 	struct callee_regs *cregs;
 	char *buf;
 
-	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!buf)
 		return;
 
diff -puN arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/arch/powerpc/kernel/rtas.c
@@ -914,7 +914,7 @@ int rtas_online_cpus_mask(cpumask_var_t
 	if (ret) {
 		cpumask_var_t tmp_mask;
 
-		if (!alloc_cpumask_var(&tmp_mask, GFP_TEMPORARY))
+		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
 			return ret;
 
 		/* Use tmp_mask to preserve cpus mask from first failure */
@@ -962,7 +962,7 @@ int rtas_ibm_suspend_me(u64 handle)
 		return -EIO;
 	}
 
-	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+	if (!alloc_cpumask_var(&offline_mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	atomic_set(&data.working, 0);
diff -puN arch/powerpc/platforms/pseries/suspend.c~treewide-remove-gfp_temporary-allocation-flag arch/powerpc/platforms/pseries/suspend.c
--- a/arch/powerpc/platforms/pseries/suspend.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/arch/powerpc/platforms/pseries/suspend.c
@@ -151,7 +151,7 @@ static ssize_t store_hibernate(struct de
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+	if (!alloc_cpumask_var(&offline_mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	stream_id = simple_strtoul(buf, NULL, 16);
diff -puN drivers/gpu/drm/drm_blend.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/drm_blend.c
--- a/drivers/gpu/drm/drm_blend.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/drm_blend.c
@@ -319,7 +319,7 @@ static int drm_atomic_helper_crtc_normal
 	DRM_DEBUG_ATOMIC("[CRTC:%d:%s] calculating normalized zpos values\n",
 			 crtc->base.id, crtc->name);
 
-	states = kmalloc_array(total_planes, sizeof(*states), GFP_TEMPORARY);
+	states = kmalloc_array(total_planes, sizeof(*states), GFP_KERNEL);
 	if (!states)
 		return -ENOMEM;
 
diff -puN drivers/gpu/drm/drm_dp_dual_mode_helper.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/drm_dp_dual_mode_helper.c
--- a/drivers/gpu/drm/drm_dp_dual_mode_helper.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/drm_dp_dual_mode_helper.c
@@ -111,7 +111,7 @@ ssize_t drm_dp_dual_mode_write(struct i2
 	void *data;
 	int ret;
 
-	data = kmalloc(msg.len, GFP_TEMPORARY);
+	data = kmalloc(msg.len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
diff -puN drivers/gpu/drm/drm_scdc_helper.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/drm_scdc_helper.c
--- a/drivers/gpu/drm/drm_scdc_helper.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/drm_scdc_helper.c
@@ -102,7 +102,7 @@ ssize_t drm_scdc_write(struct i2c_adapte
 	void *data;
 	int err;
 
-	data = kmalloc(1 + size, GFP_TEMPORARY);
+	data = kmalloc(1 + size, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
diff -puN drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -37,7 +37,7 @@ static struct etnaviv_gem_submit *submit
 	struct etnaviv_gem_submit *submit;
 	size_t sz = size_vstruct(nr, sizeof(submit->bos[0]), sizeof(*submit));
 
-	submit = kmalloc(sz, GFP_TEMPORARY | __GFP_NOWARN | __GFP_NORETRY);
+	submit = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (submit) {
 		submit->dev = dev;
 		submit->gpu = gpu;
diff -puN drivers/gpu/drm/i915/i915_gem.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2540,7 +2540,7 @@ static void *i915_gem_object_map(const s
 
 	if (n_pages > ARRAY_SIZE(stack_pages)) {
 		/* Too big for stack -- allocate temporary array instead */
-		pages = kvmalloc_array(n_pages, sizeof(*pages), GFP_TEMPORARY);
+		pages = kvmalloc_array(n_pages, sizeof(*pages), GFP_KERNEL);
 		if (!pages)
 			return NULL;
 	}
diff -puN drivers/gpu/drm/i915/i915_gem_execbuffer.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/i915_gem_execbuffer.c
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -293,7 +293,7 @@ static int eb_create(struct i915_execbuf
 			 * as possible to perform the allocation and warn
 			 * if it fails.
 			 */
-			flags = GFP_TEMPORARY;
+			flags = GFP_KERNEL;
 			if (size > 1)
 				flags |= __GFP_NORETRY | __GFP_NOWARN;
 
@@ -1515,7 +1515,7 @@ static int eb_copy_relocations(const str
 		urelocs = u64_to_user_ptr(eb->exec[i].relocs_ptr);
 		size = nreloc * sizeof(*relocs);
 
-		relocs = kvmalloc_array(size, 1, GFP_TEMPORARY);
+		relocs = kvmalloc_array(size, 1, GFP_KERNEL);
 		if (!relocs) {
 			kvfree(relocs);
 			err = -ENOMEM;
@@ -2077,7 +2077,7 @@ get_fence_array(struct drm_i915_gem_exec
 		return ERR_PTR(-EFAULT);
 
 	fences = kvmalloc_array(args->num_cliprects, sizeof(*fences),
-				__GFP_NOWARN | GFP_TEMPORARY);
+				__GFP_NOWARN | GFP_KERNEL);
 	if (!fences)
 		return ERR_PTR(-ENOMEM);
 
@@ -2463,9 +2463,9 @@ i915_gem_execbuffer(struct drm_device *d
 
 	/* Copy in the exec list from userland */
 	exec_list = kvmalloc_array(args->buffer_count, sizeof(*exec_list),
-				   __GFP_NOWARN | GFP_TEMPORARY);
+				   __GFP_NOWARN | GFP_KERNEL);
 	exec2_list = kvmalloc_array(args->buffer_count + 1, sz,
-				    __GFP_NOWARN | GFP_TEMPORARY);
+				    __GFP_NOWARN | GFP_KERNEL);
 	if (exec_list == NULL || exec2_list == NULL) {
 		DRM_DEBUG("Failed to allocate exec list for %d buffers\n",
 			  args->buffer_count);
@@ -2543,7 +2543,7 @@ i915_gem_execbuffer2(struct drm_device *
 
 	/* Allocate an extra slot for use by the command parser */
 	exec2_list = kvmalloc_array(args->buffer_count + 1, sz,
-				    __GFP_NOWARN | GFP_TEMPORARY);
+				    __GFP_NOWARN | GFP_KERNEL);
 	if (exec2_list == NULL) {
 		DRM_DEBUG("Failed to allocate exec list for %d buffers\n",
 			  args->buffer_count);
diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -3231,7 +3231,7 @@ intel_rotate_pages(struct intel_rotation
 	/* Allocate a temporary list of source pages for random access. */
 	page_addr_list = kvmalloc_array(n_pages,
 					sizeof(dma_addr_t),
-					GFP_TEMPORARY);
+					GFP_KERNEL);
 	if (!page_addr_list)
 		return ERR_PTR(ret);
 
diff -puN drivers/gpu/drm/i915/i915_gem_userptr.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/i915_gem_userptr.c
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -507,7 +507,7 @@ __i915_gem_userptr_get_pages_worker(stru
 	ret = -ENOMEM;
 	pinned = 0;
 
-	pvec = kvmalloc_array(npages, sizeof(struct page *), GFP_TEMPORARY);
+	pvec = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
 	if (pvec != NULL) {
 		struct mm_struct *mm = obj->userptr.mm->mm;
 		unsigned int flags = 0;
@@ -643,7 +643,7 @@ i915_gem_userptr_get_pages(struct drm_i9
 
 	if (mm == current->mm) {
 		pvec = kvmalloc_array(num_pages, sizeof(struct page *),
-				      GFP_TEMPORARY |
+				      GFP_KERNEL |
 				      __GFP_NORETRY |
 				      __GFP_NOWARN);
 		if (pvec) /* defer to worker if malloc fails */
diff -puN drivers/gpu/drm/i915/i915_gpu_error.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/i915_gpu_error.c
--- a/drivers/gpu/drm/i915/i915_gpu_error.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -787,16 +787,16 @@ int i915_error_state_buf_init(struct drm
 	 */
 	ebuf->size = count + 1 > PAGE_SIZE ? count + 1 : PAGE_SIZE;
 	ebuf->buf = kmalloc(ebuf->size,
-				GFP_TEMPORARY | __GFP_NORETRY | __GFP_NOWARN);
+				GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 
 	if (ebuf->buf == NULL) {
 		ebuf->size = PAGE_SIZE;
-		ebuf->buf = kmalloc(ebuf->size, GFP_TEMPORARY);
+		ebuf->buf = kmalloc(ebuf->size, GFP_KERNEL);
 	}
 
 	if (ebuf->buf == NULL) {
 		ebuf->size = 128;
-		ebuf->buf = kmalloc(ebuf->size, GFP_TEMPORARY);
+		ebuf->buf = kmalloc(ebuf->size, GFP_KERNEL);
 	}
 
 	if (ebuf->buf == NULL)
diff -puN drivers/gpu/drm/i915/selftests/i915_random.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/selftests/i915_random.c
--- a/drivers/gpu/drm/i915/selftests/i915_random.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/selftests/i915_random.c
@@ -62,7 +62,7 @@ unsigned int *i915_random_order(unsigned
 {
 	unsigned int *order, i;
 
-	order = kmalloc_array(count, sizeof(*order), GFP_TEMPORARY);
+	order = kmalloc_array(count, sizeof(*order), GFP_KERNEL);
 	if (!order)
 		return order;
 
diff -puN drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c
--- a/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c
@@ -117,12 +117,12 @@ static int igt_random_insert_remove(void
 
 	mock_engine_reset(engine);
 
-	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_TEMPORARY);
+	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_KERNEL);
 	if (!waiters)
 		goto out_engines;
 
 	bitmap = kcalloc(DIV_ROUND_UP(count, BITS_PER_LONG), sizeof(*bitmap),
-			 GFP_TEMPORARY);
+			 GFP_KERNEL);
 	if (!bitmap)
 		goto out_waiters;
 
@@ -187,12 +187,12 @@ static int igt_insert_complete(void *arg
 
 	mock_engine_reset(engine);
 
-	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_TEMPORARY);
+	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_KERNEL);
 	if (!waiters)
 		goto out_engines;
 
 	bitmap = kcalloc(DIV_ROUND_UP(count, BITS_PER_LONG), sizeof(*bitmap),
-			 GFP_TEMPORARY);
+			 GFP_KERNEL);
 	if (!bitmap)
 		goto out_waiters;
 
@@ -368,7 +368,7 @@ static int igt_wakeup(void *arg)
 
 	mock_engine_reset(engine);
 
-	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_TEMPORARY);
+	waiters = kvmalloc_array(count, sizeof(*waiters), GFP_KERNEL);
 	if (!waiters)
 		goto out_engines;
 
diff -puN drivers/gpu/drm/i915/selftests/intel_uncore.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/i915/selftests/intel_uncore.c
--- a/drivers/gpu/drm/i915/selftests/intel_uncore.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/i915/selftests/intel_uncore.c
@@ -127,7 +127,7 @@ static int intel_uncore_check_forcewake_
 		return 0;
 
 	valid = kzalloc(BITS_TO_LONGS(FW_RANGE) * sizeof(*valid),
-			GFP_TEMPORARY);
+			GFP_KERNEL);
 	if (!valid)
 		return -ENOMEM;
 
diff -puN drivers/gpu/drm/lib/drm_random.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/lib/drm_random.c
--- a/drivers/gpu/drm/lib/drm_random.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/lib/drm_random.c
@@ -28,7 +28,7 @@ unsigned int *drm_random_order(unsigned
 {
 	unsigned int *order, i;
 
-	order = kmalloc_array(count, sizeof(*order), GFP_TEMPORARY);
+	order = kmalloc_array(count, sizeof(*order), GFP_KERNEL);
 	if (!order)
 		return order;
 
diff -puN drivers/gpu/drm/msm/msm_gem_submit.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/msm/msm_gem_submit.c
--- a/drivers/gpu/drm/msm/msm_gem_submit.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -40,7 +40,7 @@ static struct msm_gem_submit *submit_cre
 	if (sz > SIZE_MAX)
 		return NULL;
 
-	submit = kmalloc(sz, GFP_TEMPORARY | __GFP_NOWARN | __GFP_NORETRY);
+	submit = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (!submit)
 		return NULL;
 
diff -puN drivers/gpu/drm/selftests/test-drm_mm.c~treewide-remove-gfp_temporary-allocation-flag drivers/gpu/drm/selftests/test-drm_mm.c
--- a/drivers/gpu/drm/selftests/test-drm_mm.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/gpu/drm/selftests/test-drm_mm.c
@@ -1627,7 +1627,7 @@ static int igt_topdown(void *ignored)
 		goto err;
 
 	bitmap = kzalloc(count / BITS_PER_LONG * sizeof(unsigned long),
-			 GFP_TEMPORARY);
+			 GFP_KERNEL);
 	if (!bitmap)
 		goto err_nodes;
 
@@ -1741,7 +1741,7 @@ static int igt_bottomup(void *ignored)
 		goto err;
 
 	bitmap = kzalloc(count / BITS_PER_LONG * sizeof(unsigned long),
-			 GFP_TEMPORARY);
+			 GFP_KERNEL);
 	if (!bitmap)
 		goto err_nodes;
 
diff -puN drivers/misc/cxl/pci.c~treewide-remove-gfp_temporary-allocation-flag drivers/misc/cxl/pci.c
--- a/drivers/misc/cxl/pci.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/misc/cxl/pci.c
@@ -1279,7 +1279,7 @@ ssize_t cxl_pci_afu_read_err_buffer(stru
 	}
 
 	/* use bounce buffer for copy */
-	tbuf = (void *)__get_free_page(GFP_TEMPORARY);
+	tbuf = (void *)__get_free_page(GFP_KERNEL);
 	if (!tbuf)
 		return -ENOMEM;
 
diff -puN drivers/xen/gntalloc.c~treewide-remove-gfp_temporary-allocation-flag drivers/xen/gntalloc.c
--- a/drivers/xen/gntalloc.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/drivers/xen/gntalloc.c
@@ -294,7 +294,7 @@ static long gntalloc_ioctl_alloc(struct
 		goto out;
 	}
 
-	gref_ids = kcalloc(op.count, sizeof(gref_ids[0]), GFP_TEMPORARY);
+	gref_ids = kcalloc(op.count, sizeof(gref_ids[0]), GFP_KERNEL);
 	if (!gref_ids) {
 		rc = -ENOMEM;
 		goto out;
diff -puN fs/coredump.c~treewide-remove-gfp_temporary-allocation-flag fs/coredump.c
--- a/fs/coredump.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/coredump.c
@@ -161,7 +161,7 @@ static int cn_print_exe_file(struct core
 	if (!exe_file)
 		return cn_esc_printf(cn, "%s (path unknown)", current->comm);
 
-	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
+	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!pathbuf) {
 		ret = -ENOMEM;
 		goto put_exe_file;
diff -puN fs/exec.c~treewide-remove-gfp_temporary-allocation-flag fs/exec.c
--- a/fs/exec.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/exec.c
@@ -1763,9 +1763,9 @@ static int do_execveat_common(int fd, st
 		bprm->filename = filename->name;
 	} else {
 		if (filename->name[0] == '\0')
-			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d", fd);
+			pathbuf = kasprintf(GFP_KERNEL, "/dev/fd/%d", fd);
 		else
-			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d/%s",
+			pathbuf = kasprintf(GFP_KERNEL, "/dev/fd/%d/%s",
 					    fd, filename->name);
 		if (!pathbuf) {
 			retval = -ENOMEM;
diff -puN fs/overlayfs/copy_up.c~treewide-remove-gfp_temporary-allocation-flag fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/overlayfs/copy_up.c
@@ -241,7 +241,7 @@ struct ovl_fh *ovl_encode_fh(struct dent
 	int buflen = MAX_HANDLE_SZ;
 	uuid_t *uuid = &lower->d_sb->s_uuid;
 
-	buf = kmalloc(buflen, GFP_TEMPORARY);
+	buf = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
diff -puN fs/overlayfs/dir.c~treewide-remove-gfp_temporary-allocation-flag fs/overlayfs/dir.c
--- a/fs/overlayfs/dir.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/overlayfs/dir.c
@@ -833,7 +833,7 @@ static char *ovl_get_redirect(struct den
 		goto out;
 	}
 
-	buf = ret = kmalloc(buflen, GFP_TEMPORARY);
+	buf = ret = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
diff -puN fs/overlayfs/namei.c~treewide-remove-gfp_temporary-allocation-flag fs/overlayfs/namei.c
--- a/fs/overlayfs/namei.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/overlayfs/namei.c
@@ -38,7 +38,7 @@ static int ovl_check_redirect(struct den
 			return 0;
 		goto fail;
 	}
-	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_TEMPORARY);
+	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -103,7 +103,7 @@ static struct ovl_fh *ovl_get_origin_fh(
 	if (res == 0)
 		return NULL;
 
-	fh = kzalloc(res, GFP_TEMPORARY);
+	fh  = kzalloc(res, GFP_KERNEL);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -309,7 +309,7 @@ static int ovl_check_origin(struct dentr
 
 	BUG_ON(*ctrp);
 	if (!*stackp)
-		*stackp = kmalloc(sizeof(struct path), GFP_TEMPORARY);
+		*stackp = kmalloc(sizeof(struct path), GFP_KERNEL);
 	if (!*stackp) {
 		dput(origin);
 		return -ENOMEM;
@@ -418,7 +418,7 @@ int ovl_verify_index(struct dentry *inde
 
 	err = -ENOMEM;
 	len = index->d_name.len / 2;
-	fh = kzalloc(len, GFP_TEMPORARY);
+	fh = kzalloc(len, GFP_KERNEL);
 	if (!fh)
 		goto fail;
 
@@ -478,7 +478,7 @@ int ovl_get_index_name(struct dentry *or
 		return PTR_ERR(fh);
 
 	err = -ENOMEM;
-	n = kzalloc(fh->len * 2, GFP_TEMPORARY);
+	n = kzalloc(fh->len * 2, GFP_KERNEL);
 	if (n) {
 		s  = bin2hex(n, fh, fh->len);
 		*name = (struct qstr) QSTR_INIT(n, s - n);
@@ -646,7 +646,7 @@ struct dentry *ovl_lookup(struct inode *
 	if (!d.stop && poe->numlower) {
 		err = -ENOMEM;
 		stack = kcalloc(ofs->numlower, sizeof(struct path),
-				GFP_TEMPORARY);
+				GFP_KERNEL);
 		if (!stack)
 			goto out_put_upper;
 	}
diff -puN fs/proc/base.c~treewide-remove-gfp_temporary-allocation-flag fs/proc/base.c
--- a/fs/proc/base.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/proc/base.c
@@ -232,7 +232,7 @@ static ssize_t proc_pid_cmdline_read(str
 		goto out_mmput;
 	}
 
-	page = (char *)__get_free_page(GFP_TEMPORARY);
+	page = (char *)__get_free_page(GFP_KERNEL);
 	if (!page) {
 		rv = -ENOMEM;
 		goto out_mmput;
@@ -813,7 +813,7 @@ static ssize_t mem_rw(struct file *file,
 	if (!mm)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_TEMPORARY);
+	page = (char *)__get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -918,7 +918,7 @@ static ssize_t environ_read(struct file
 	if (!mm || !mm->env_end)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_TEMPORARY);
+	page = (char *)__get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1630,7 +1630,7 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
+	char *tmp = (char *)__get_free_page(GFP_KERNEL);
 	char *pathname;
 	int len;
 
diff -puN fs/proc/task_mmu.c~treewide-remove-gfp_temporary-allocation-flag fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/fs/proc/task_mmu.c
@@ -1474,7 +1474,7 @@ static ssize_t pagemap_read(struct file
 	pm.show_pfn = file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN);
 
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_KERNEL);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_mm;
diff -puN include/linux/gfp.h~treewide-remove-gfp_temporary-allocation-flag include/linux/gfp.h
--- a/include/linux/gfp.h~treewide-remove-gfp_temporary-allocation-flag
+++ a/include/linux/gfp.h
@@ -288,8 +288,6 @@ struct vm_area_struct;
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
-#define GFP_TEMPORARY	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | \
-			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
diff -puN include/trace/events/mmflags.h~treewide-remove-gfp_temporary-allocation-flag include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~treewide-remove-gfp_temporary-allocation-flag
+++ a/include/trace/events/mmflags.h
@@ -18,7 +18,6 @@
 	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
 	{(unsigned long)GFP_USER,		"GFP_USER"},		\
-	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
 	{(unsigned long)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},	\
 	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
 	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
diff -puN kernel/locking/test-ww_mutex.c~treewide-remove-gfp_temporary-allocation-flag kernel/locking/test-ww_mutex.c
--- a/kernel/locking/test-ww_mutex.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/kernel/locking/test-ww_mutex.c
@@ -362,7 +362,7 @@ static int *get_random_order(int count)
 	int *order;
 	int n, r, tmp;
 
-	order = kmalloc_array(count, sizeof(*order), GFP_TEMPORARY);
+	order = kmalloc_array(count, sizeof(*order), GFP_KERNEL);
 	if (!order)
 		return order;
 
diff -puN kernel/trace/trace_events_filter.c~treewide-remove-gfp_temporary-allocation-flag kernel/trace/trace_events_filter.c
--- a/kernel/trace/trace_events_filter.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/kernel/trace/trace_events_filter.c
@@ -702,7 +702,7 @@ static void append_filter_err(struct fil
 	int pos = ps->lasterr_pos;
 	char *buf, *pbuf;
 
-	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	buf = (char *)__get_free_page(GFP_KERNEL);
 	if (!buf)
 		return;
 
diff -puN lib/string_helpers.c~treewide-remove-gfp_temporary-allocation-flag lib/string_helpers.c
--- a/lib/string_helpers.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/lib/string_helpers.c
@@ -576,7 +576,7 @@ char *kstrdup_quotable_cmdline(struct ta
 	char *buffer, *quoted;
 	int i, res;
 
-	buffer = kmalloc(PAGE_SIZE, GFP_TEMPORARY);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return NULL;
 
@@ -612,7 +612,7 @@ char *kstrdup_quotable_file(struct file
 		return kstrdup("<unknown>", gfp);
 
 	/* We add 11 spaces for ' (deleted)' to be appended */
-	temp = kmalloc(PATH_MAX + 11, GFP_TEMPORARY);
+	temp = kmalloc(PATH_MAX + 11, GFP_KERNEL);
 	if (!temp)
 		return kstrdup("<no_memory>", gfp);
 
diff -puN mm/shmem.c~treewide-remove-gfp_temporary-allocation-flag mm/shmem.c
--- a/mm/shmem.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/mm/shmem.c
@@ -3685,7 +3685,7 @@ SYSCALL_DEFINE2(memfd_create,
 	if (len > MFD_NAME_MAX_LEN + 1)
 		return -EINVAL;
 
-	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_TEMPORARY);
+	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
diff -puN mm/slub.c~treewide-remove-gfp_temporary-allocation-flag mm/slub.c
--- a/mm/slub.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/mm/slub.c
@@ -4597,7 +4597,7 @@ static int list_locations(struct kmem_ca
 	struct kmem_cache_node *n;
 
 	if (!map || !alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
-				     GFP_TEMPORARY)) {
+				     GFP_KERNEL)) {
 		kfree(map);
 		return sprintf(buf, "Out of memory\n");
 	}
diff -puN tools/perf/builtin-kmem.c~treewide-remove-gfp_temporary-allocation-flag tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~treewide-remove-gfp_temporary-allocation-flag
+++ a/tools/perf/builtin-kmem.c
@@ -627,7 +627,6 @@ static const struct {
 	{ "GFP_HIGHUSER_MOVABLE",	"HUM" },
 	{ "GFP_HIGHUSER",		"HU" },
 	{ "GFP_USER",			"U" },
-	{ "GFP_TEMPORARY",		"TMP" },
 	{ "GFP_KERNEL_ACCOUNT",		"KAC" },
 	{ "GFP_KERNEL",			"K" },
 	{ "GFP_NOFS",			"NF" },
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
mm-memcg-remove-hotplug-locking-from-try_charge.patch
mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch

