Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75C13A868
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 23:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730419074; cv=none; b=pKThWS1KMV+a3JGgib2mxsA63vz+HJaJZXDRQYpAFf3178RIWVHm3RXts2bhgDWv+h1YhbHuVW5Y0wRoP522rBhniPoQ5wioqY4mqwO+RsSD0WzwxjhLYGncETRhxnpumOyBLccpBITPzOhW6SRsFkmaOYl73toSSbtmWdZBZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730419074; c=relaxed/simple;
	bh=NQ7HBMqCXFvI67bLYgosavE3zI3XtVNUcGrPxndz31U=;
	h=Date:To:From:Subject:Message-Id; b=u8PNi35dLDDgcn7f53apXbScb6a8+rbRJ4s4/IoItAvfPm2eCOseSxXTC6SHMopEiS8OP8iU2w6sYrrIwi3FJ3P4ckjk0O+a3Iu5U93vqvBjbISyDjhVn64GUKQjs00bPkSAPzGgvHfXoZF7DfAwFgEMXxBnrvssqglPEIXpFYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zm4I0cSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zm4I0cSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C4CC4CEC3;
	Thu, 31 Oct 2024 23:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730419074;
	bh=NQ7HBMqCXFvI67bLYgosavE3zI3XtVNUcGrPxndz31U=;
	h=Date:To:From:Subject:From;
	b=Zm4I0cSRDfFQbxalzgI/1pweNQuzoCv73QsoIq9ZQo6j/vRwKumBYKze+ff9WCFwm
	 1SxWEdSZ6fVmbZ17sSozGronbibuwdCl4Gm1dACaxUbXySieVsS1lHku7lRE7yBGO8
	 Rs1uswWCnBn+byHdyYqvBV+2qqoQUG6G5dH2LlGE=
Date: Thu, 31 Oct 2024 16:57:53 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,mhiramat@kernel.org,mcgrof@kernel.org,lkp@intel.com,arnd@arndb.de,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch removed from -mm tree
Message-Id: <20241031235754.12C4CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: avoid execmem_vmap() when !MMU
has been removed from the -mm tree.  Its filename was
     alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: avoid execmem_vmap() when !MMU
Date: Mon, 28 Oct 2024 13:29:35 -0700

With CONFIG_MMU=n __get_vm_area_node() is not available and memory for the
allocation tags cannot be populated as needed.  For this case, populate
the required memory at initialization time.

Link: https://lkml.kernel.org/r/20241028202935.1047017-1-surenb@google.com
Fixes: 57bc3834fb6f ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410250808.dQGyYjlk-lkp@intel.com/
Closes: https://lore.kernel.org/oe-lkp/202410251525.9f85854d-oliver.sang@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202410261016.IO7C6Cml-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202410270919.LebQlmxD-lkp@intel.com/
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/execmem.h |    2 ++
 lib/alloc_tag.c         |   23 ++++++++++++++++++++++-
 mm/execmem.c            |   32 ++++++++++++++++----------------
 3 files changed, 40 insertions(+), 17 deletions(-)

--- a/include/linux/execmem.h~alloc_tag-populate-memory-for-module-tags-as-needed-fix
+++ a/include/linux/execmem.h
@@ -139,6 +139,7 @@ void *execmem_alloc(enum execmem_type ty
  */
 void execmem_free(void *ptr);
 
+#ifdef CONFIG_MMU
 /**
  * execmem_vmap - create virtual mapping for EXECMEM_MODULE_DATA memory
  * @size: size of the virtual mapping in bytes
@@ -148,6 +149,7 @@ void execmem_free(void *ptr);
  * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *execmem_vmap(size_t size);
+#endif
 
 /**
  * execmem_update_copy - copy an update to executable memory
--- a/lib/alloc_tag.c~alloc_tag-populate-memory-for-module-tags-as-needed-fix
+++ a/lib/alloc_tag.c
@@ -180,7 +180,6 @@ static void __init procfs_init(void)
 #ifdef CONFIG_MODULES
 
 static struct maple_tree mod_area_mt = MTREE_INIT(mod_area_mt, MT_FLAGS_ALLOC_RANGE);
-static struct vm_struct *vm_module_tags;
 /* A dummy object used to indicate an unloaded module */
 static struct module unloaded_mod;
 /* A dummy object used to indicate a module prepended area */
@@ -254,6 +253,9 @@ repeat:
 	return false;
 }
 
+#ifdef CONFIG_MMU
+static struct vm_struct *vm_module_tags;
+
 static int vm_module_tags_populate(void)
 {
 	unsigned long phys_size = vm_module_tags->nr_pages << PAGE_SHIFT;
@@ -280,6 +282,13 @@ static int vm_module_tags_populate(void)
 
 	return 0;
 }
+#else
+static int vm_module_tags_populate(void)
+{
+	/* Memory was already allocated */
+	return 0;
+}
+#endif
 
 static void *reserve_module_tags(struct module *mod, unsigned long size,
 				 unsigned int prepend, unsigned long align)
@@ -411,6 +420,7 @@ static void replace_module(struct module
 
 static int __init alloc_mod_tags_mem(void)
 {
+#ifdef CONFIG_MMU
 	/* Map space to copy allocation tags */
 	vm_module_tags = execmem_vmap(MODULE_ALLOC_TAG_VMAP_SIZE);
 	if (!vm_module_tags) {
@@ -428,6 +438,13 @@ static int __init alloc_mod_tags_mem(voi
 	}
 
 	module_tags.start_addr = (unsigned long)vm_module_tags->addr;
+#else
+	/* Allocate space to copy allocation tags */
+	module_tags.start_addr = (unsigned long)execmem_alloc(EXECMEM_MODULE_DATA,
+							      MODULE_ALLOC_TAG_VMAP_SIZE);
+	if (!module_tags.start_addr)
+		return -ENOMEM;
+#endif
 	module_tags.end_addr = module_tags.start_addr + MODULE_ALLOC_TAG_VMAP_SIZE;
 
 	return 0;
@@ -435,6 +452,7 @@ static int __init alloc_mod_tags_mem(voi
 
 static void __init free_mod_tags_mem(void)
 {
+#ifdef CONFIG_MMU
 	int i;
 
 	module_tags.start_addr = 0;
@@ -442,6 +460,9 @@ static void __init free_mod_tags_mem(voi
 		__free_page(vm_module_tags->pages[i]);
 	kfree(vm_module_tags->pages);
 	free_vm_area(vm_module_tags);
+#else
+	execmem_free((void *)module_tags.start_addr);
+#endif
 }
 
 #else /* CONFIG_MODULES */
--- a/mm/execmem.c~alloc_tag-populate-memory-for-module-tags-as-needed-fix
+++ a/mm/execmem.c
@@ -64,6 +64,22 @@ static void *execmem_vmalloc(struct exec
 
 	return p;
 }
+
+struct vm_struct *execmem_vmap(size_t size)
+{
+	struct execmem_range *range = &execmem_info->ranges[EXECMEM_MODULE_DATA];
+	struct vm_struct *area;
+
+	area = __get_vm_area_node(size, range->alignment, PAGE_SHIFT, VM_ALLOC,
+				  range->start, range->end, NUMA_NO_NODE,
+				  GFP_KERNEL, __builtin_return_address(0));
+	if (!area && range->fallback_start)
+		area = __get_vm_area_node(size, range->alignment, PAGE_SHIFT, VM_ALLOC,
+					  range->fallback_start, range->fallback_end,
+					  NUMA_NO_NODE, GFP_KERNEL, __builtin_return_address(0));
+
+	return area;
+}
 #else
 static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 			     pgprot_t pgprot, unsigned long vm_flags)
@@ -368,22 +384,6 @@ void execmem_free(void *ptr)
 		vfree(ptr);
 }
 
-struct vm_struct *execmem_vmap(size_t size)
-{
-	struct execmem_range *range = &execmem_info->ranges[EXECMEM_MODULE_DATA];
-	struct vm_struct *area;
-
-	area = __get_vm_area_node(size, range->alignment, PAGE_SHIFT, VM_ALLOC,
-				  range->start, range->end, NUMA_NO_NODE,
-				  GFP_KERNEL, __builtin_return_address(0));
-	if (!area && range->fallback_start)
-		area = __get_vm_area_node(size, range->alignment, PAGE_SHIFT, VM_ALLOC,
-					  range->fallback_start, range->fallback_end,
-					  NUMA_NO_NODE, GFP_KERNEL, __builtin_return_address(0));
-
-	return area;
-}
-
 void *execmem_update_copy(void *dst, const void *src, size_t size)
 {
 	return text_poke_copy(dst, src, size);
_

Patches currently in -mm which might be from surenb@google.com are

maple_tree-add-mas_for_each_rev-helper.patch
alloc_tag-introduce-shutdown_mem_profiling-helper-function.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory.patch
alloc_tag-populate-memory-for-module-tags-as-needed.patch
alloc_tag-populate-memory-for-module-tags-as-needed-fix-2.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch
mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

