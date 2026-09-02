Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE09C417BE2
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388246; cv=none; b=jVUXExrSm1lzbV8umwd3yS5nk7FsrGaby0wg4JKIfId0pnppB1CWcM8R2MW9KQHRCeuy1J10FR4XMbVe2+rvTjqfDQLAjPQXVAUFJKxfN0ik3WRFludeyN6YRY7yfIsEZnawKmhoJ+b/l8yGuyYLQYiaR/+xB4t9pks7+afx13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388246; c=relaxed/simple;
	bh=BLi2Xhz0d6OM1zuI/XI+/9Rkc/YFqGlBTB91GSHU0+E=;
	h=Date:To:From:Subject:Message-Id; b=e8w5fYDVwe7f6hu4zqtOT35Lt8VSRItGztYqgljkhoOd3U2Z2XG4dKzWoH4dH+g1TJ63ilyCdWmYihwi0nh2cF1fK1PCrmV4se+Q1ZoZrUy7RFXAIl9iR1nUOADpWWYq7k0RLRMfBItRBzUAxui5udeSMScRrnJoVE+JjY1V2KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uG3lwb/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uG3lwb/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB501F000E9;
	Wed,  2 Sep 2026 22:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388240;
	bh=HgthHTg9FF/dUJmwIpqtSuI3RjttfnintySdfOOxblo=;
	h=Date:To:From:Subject;
	b=uG3lwb/tfP1LW3vmeV6JYgbR2FFe693CdkLbarpImgNNStDQjkhS3zUR/kjJfbvW4
	 2G+RJei8pZldyEdfahOGTO2U27zdHANB2qziqFc3kfyFnFJVEOjJhblgaFZym4eV62
	 OROPK5HSUMvp0KPfIhTK5CojvpOG0DEO5xYMEP8s=
Date: Wed, 02 Sep 2026 15:30:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch added to mm-new branch
Message-Id: <20260902223040.ACB501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
has been added to the -mm mm-new branch.  Its filename is
     docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch

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
Subject: docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
Date: Wed, 02 Sep 2026 11:10:11 +0300

Patch series "docs/core-api: memory-allocation: add k[mz]alloc_obj() and
clarify kmalloc", v2.

Update the memory-allocation guide to describe k[mz]alloc_obj() and
clarify description of kmalloc() size limitations.

And when I realized that get_maintainers.pl does not list any of mm people
for that patch I added the MAINTAINERS update as well :)


This patch (of 2):

Since v7.0 the most used memory allocation function is kzalloc_obj().

Update the memory-allocation guide to describe k[mz]alloc_obj() family and
make kzalloc_obj() the first answer to "How should I allocate memory?"
question.

While on it, clarify description of kmalloc() size limitations.

Link: https://lore.kernel.org/20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org
Link: https://lore.kernel.org/20260902-docs-memalloc-guide-v2-1-218c1a4dcb80@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/memory-allocation.rst |   30 +++++++++++++----
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/Documentation/core-api/memory-allocation.rst~docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc
+++ a/Documentation/core-api/memory-allocation.rst
@@ -21,6 +21,12 @@ answer, although very likely you should
 
 ::
 
+  kzalloc_obj(<VAR_OR_TYPE>);
+
+or
+
+::
+
   kzalloc(<size>, GFP_KERNEL);
 
 Of course there are cases when other allocation APIs and different GFP
@@ -139,10 +145,13 @@ allocate memory for an array, there are
 helpers. The helpers struct_size(), array_size() and array3_size() can
 be used to safely calculate object sizes without overflowing.
 
-The maximal size of a chunk that can be allocated with `kmalloc` is
-limited. The actual limit depends on the hardware and the kernel
-configuration, but it is a good practice to use `kmalloc` for objects
-smaller than page size.
+Since 7.0 there are type aware kmalloc-family helpers that let you safely and
+conveniently allocate a single object or arrays of objects with kzalloc_obj()
+and kmalloc_obj() and their array versions kzalloc_objs() and
+kmalloc_objs(). These helpers only need the type of the object that should be
+allocated and the count of elements in the array for the array versions.
+
+As of v7.2, vast majority of the memory allocations use kzalloc_obj().
 
 The address of a chunk allocated with `kmalloc` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
@@ -154,9 +163,16 @@ Chunks allocated with kmalloc() can be r
 to kmalloc_array(): a helper for resizing arrays is provided in the form of
 krealloc_array().
 
-For large allocations you can use vmalloc() and vzalloc(), or directly
-request pages from the page allocator. The memory allocated by `vmalloc`
-and related functions is not physically contiguous.
+`kmalloc` always allocates physically contiguous memory and the maximal size of
+a chunk that can be allocated with `kmalloc` is limited by `KMALLOC_MAX_SIZE`,
+which matches the page allocator's MAX_PAGE_ORDER limit.
+
+Internally, the slab allocator differentiates allocations of different orders
+and delegates larger allocations to the page allocator, but for the users of
+`kmalloc` family it is entirely transparent.
+
+For large allocations that do not require physically contiguous memory you can
+use vmalloc() and vzalloc() family.
 
 If you are not sure whether the allocation size is too large for
 `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
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

