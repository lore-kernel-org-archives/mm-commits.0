Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48BE3FF1CB;
	Fri,  9 Oct 2026 05:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525429; cv=none; b=dePwB22GkfTU6Uiy0J/tgrQums/WyLglkOkoatiPJ2GxxwPTN4sbp7gMwAYulnSVd95v38jfhjtkmhZn3hkmokfHFqC+neFYz/Uc/jPYAfZcqa13vLWzvO2JGcfUsQU9NcfohGEH+J26eE45fzrxYYzrjQ7bhW4qrrGetllvod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525429; c=relaxed/simple;
	bh=WQfgo7xvahlP5zHOef95dF8h4LTIIbsG7ffSUeramBg=;
	h=Date:To:From:Subject:Message-Id; b=mcZDTaM+52WbY8aZUeES6mceM+99ixMLRWlL0gJBWW1qQVV4eZwAwAoI8ovOcWMDkBu0y7mah0ImJa4KFRHcP8lWI9ws13owlb5lbxntE+mHS1OvhE8nne71TZD7eW8nyafO+v5Ox5HqLiFO9jmzaNWYEDNPz1KMdOJmloRdhXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJ3HcaQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJ3HcaQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CE91F000FF;
	Fri,  9 Oct 2026 05:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525428;
	bh=BROih2aIjdLs6DZQOyP2A0pWrukGn7hPgR1yyPLidQE=;
	h=Date:To:From:Subject;
	b=FJ3HcaQroYtbVNZWpttrMtKpyg5trom+jsLkl9vraOb0u5kC+nDpYSkyyyQNQ1PlP
	 RX/OEDX/T9o7fJu17eiFrPAs7hEiJRfSlZAbonVu/ILsSxlkjr9aGEu9M/oXoKkeIC
	 AxzqFd9LwQtZVzHe05FZNGO92L8ap2h4ClemHuCk=
Date: Thu, 08 Oct 2026 22:57:08 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch removed from -mm tree
Message-Id: <20261009055708.70CE91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: free ROX cache chunks only when they span an entire vm area
has been removed from the -mm tree.  Its filename was
     mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
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

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
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

