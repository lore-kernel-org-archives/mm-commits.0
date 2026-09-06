Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39EA3515EF;
	Sun,  6 Sep 2026 02:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660353; cv=none; b=hIwDkUCki2OiA2+vLZcq2iJog16a8jO0oRvvwd9HHJkPHo5nEfdnvRJV6UJj2gpF18L/SrFBb0GU9fKcJ6BpDe5GA95a01nlHSdZQZQmJkUD2j8EKxjM14vhzVv3wPFo5V7mPBI9s5qZVSQ0AhgEHU9TKD56E6AzMxGWda6e4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660353; c=relaxed/simple;
	bh=lprfz5f/ny4eZoFJut86cxjKFDgJwRHZywd9kCg4tbg=;
	h=Date:To:From:Subject:Message-Id; b=XpArZQHWYF5+LS6C3qGE+MoIoVve1kTFSIsaC3OtHeNWWJKtj97xcEt8UFbJz+aNKnM84Q2gIaDCG3VdY2gujYax84CKAzWiVn3S1BfH8HPSALhirCs6kWwloZxA6H8WjnsHJi+D7fGJHNTPpBMAjG7Jge7W5xYgjj8nmHxQixQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDgVc9e4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDgVc9e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E381F00A3A;
	Sun,  6 Sep 2026 02:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660351;
	bh=KoX+/OCCHHOvZYwkwWTyoLyhaRppa6tZFqQqcEXIack=;
	h=Date:To:From:Subject;
	b=IDgVc9e4mQ/fayp3j43nRxx15QzG1BnJoFk82JmTV7pNLISlVHRtA6pG/m9dywR9K
	 tDZ95BdvTT4LcE7PvmDJJD0KXDDHRtkWrk25bGLvHDtaOoKgPToJma0+WQPF45qn8P
	 y/VPPmHpRVCXZWib6fkYZWMTwqBSa/BNGOjyoynI=
Date: Sat, 05 Sep 2026 19:05:50 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch added to mm-new branch
Message-Id: <20260906020550.E3E381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: free ROX cache chunks only when they span an entire vm area
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: free ROX cache chunks only when they span an entire vm area
Date: Thu, 03 Sep 2026 18:49:58 +0300

Patch series "mm/execmem: fixes and cleanups for the ROX cache".

Sashiko review of the ROX cache refill path asked what happens when the
PMD_SIZE allocation fails there.  Pulling that thread uncovered a bit more
than the fallback.

Patch 1 fixes a real bug, although rare bug: execmem_cache_clean() can
free a chunk that is still partially in use, because a PMD sized and PMD
aligned free range in the middle of a larger chunk looks exactly like a
chunk that nobody uses.

Patch 2 handles maple tree allocation failures in the cache.  They are
unlikely, but silently dropping an area from the tree is not a great way
to deal with them.

Patch 3 deals with the fallback that started all this.  The cache exists
to keep the direct map free of unnecessary splits, and the fallback
happily filled it with base page mapped areas that could never be freed
from the cache again.  Ask vmalloc for a huge mapping or nothing, and
serve whatever does not fit outside the cache.

Patches 4 and 5 convert the ROX cache to scope based cleanup.

The series was tested on x86 with module load/unload cycles, with PTDUMP
confirming that the cache is using 2M mappings, and with nohugevmalloc to
exercise the uncached fallback.


This patch (of 5):

When execmem refills the ROX cache, it vmalloc()s multiples of PMD_SIZE
aligned to PMD_SIZE.  For every such allocation vmalloc creates a vm area.

The first part of the vmalloc()ed chunk is returned to the allocation that
triggered the cache refill and the remaining part is added to the cache
and handed out for subsequent allocations with execmem_alloc().

When only the first part is freed, the entire vm area remains in the ROX
cache and can be handed out again.

In the case when the first allocation is larger than PMD_SIZE and the
second allocation from the freed first part of the chunk is exactly
PMD_SIZE, execmem_cache_clean() will free the entire chunk while part of
it is still in use.

For example:

	/*
	 * vmalloc(4M), return p0 to the caller
	 * add [p0 + 3M, p0 + 4M) to the cache
	 */
	p0 = execmem_alloc(3M);

	/* return p0 + 3M from the cache to the caller */
	p1 = execmem_alloc(1M);

	/* put [p0, p0 + 3M) back into the cache */
	execmem_free(p0);

	/* return p0 from the cache to the caller */
	p2 = execmem_alloc(2M);

	/* return p0 + 2M from the cache to the caller */
	p3 = execmem_alloc(1M);

	/* bah! execmem_cache_clean() frees the entire 4M chunk */
	execmem_free(p2);

Make sure that the ranges that execmem_cache_clean() frees cover the
entire vm area.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org
Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-1-11beb2a3d249@kernel.org
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/execmem.c~mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area
+++ a/mm/execmem.c
@@ -143,9 +143,11 @@ static void execmem_cache_clean(struct w
 
 	mutex_lock(mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
+		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (IS_ALIGNED(size, PMD_SIZE) &&
+		if (vm && get_vm_area_size(vm) == size &&
+		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

