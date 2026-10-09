Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4E540F72D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525512; cv=none; b=e4C9CXhxdo43/FcUv97kFrxhlXKhKnPt6tjZ+5AUqJk2abl510VizAfhAOu37Sc480wnXhcAf3rrXUKv6ruaWFHT5F1cGQEekAXIoRWl3bJNSXsGCDVAEvSkuVosnPwEs1U7F94dYvGYVPdepScw5Pn612YXXrOowaBoawulv1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525512; c=relaxed/simple;
	bh=AaPqgq9hFnHieCbLCTvwatiaCGPmMzZGibEi9/foJ2g=;
	h=Date:To:From:Subject:Message-Id; b=gwhoxnPRP+GVEgeT3C7vamt8cQE+R/IBGqZOwpVYyfSauxhLj13suhDxTp7m1rsQC2d5zltWfeGIxTXKsl5XG0jt26j753PWG3ef7JUq3HBH0ACtWb/fhus9XgZ4lExqQDi6Dy0j0rTuFz+XWyNWu+IMi268ZgGh5b+U2E4gGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRCBTSnE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRCBTSnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937DB1F000FF;
	Fri,  9 Oct 2026 05:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525511;
	bh=/egNrlY+3S4fILWoYi664FZECG0uf2rqFpNRMrAbY3g=;
	h=Date:To:From:Subject;
	b=MRCBTSnEFoXW6k6cJX+9qYGnpSWssD9aStOmyMGIyE0rx+0I+eSGDhUCjMx6CZbPz
	 G8ho+PcIhheWECKu97+WqY5tMqt0RwdQ1Kz8faBl+Oli9fW4bqVS3KWX7wZvsLWAEs
	 jBxUGsykKz24yWAjdQL28+AyNxIRCnXFn1hwKh/4=
Date: Thu, 08 Oct 2026 22:58:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch removed from -mm tree
Message-Id: <20261009055831.937DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
has been removed from the -mm tree.  Its filename was
     docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
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

