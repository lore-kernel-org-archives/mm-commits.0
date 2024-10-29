Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE92119
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160202; cv=none; b=jMY6sIDXz8k5qE8DLzrIK4Gei5ejd2GFvAUkNzexD8S+ijOFjPWk3brDg2hJmwP6+hbPoWGZ0AboMEmSlitiZZEXBHqG7CdhMAVHXP3Dpfta62PrZE2hHlq+L+Oa3AOeY/CGiu+PXYeyS1aV5T1YMNZIdM1LfFrvzI4trnEsZDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160202; c=relaxed/simple;
	bh=gHHtzYC9w3wX4ur4wc+r55Rnn41YzgzT/PydTKwbENQ=;
	h=Date:To:From:Subject:Message-Id; b=NRtBmxiD2/Rwyk+TdmNo2UGwY2qoLM38zm452iClA/4fbizbHbqOfHf5MY10lj5Q4zZlZ9jewsai3z6yA7hQToNSfbeya4egYtMqIazFxEZ+ut2Ei+lvtsT/agrVdc5IRuir+7iKyKoiaWZ9bwhM/+LZd4d1+PjF2aSRCfZYwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1f/L9wn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1f/L9wn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B62C4CEC3;
	Tue, 29 Oct 2024 00:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730160202;
	bh=gHHtzYC9w3wX4ur4wc+r55Rnn41YzgzT/PydTKwbENQ=;
	h=Date:To:From:Subject:From;
	b=1f/L9wn52PyyNyZysBRfySeU0/EqUORr8YM1x0zntrKMxjOp/wpq9EljOvB+QQ9Jo
	 lNd8C+trAqSDZBS2rhQErkoJ5nHiwN65IprP/vWr7gQN/TyTKh8KmlRbIBkYG0nJYD
	 7OEUPVf5u3v7ccFobzBzfOg+Dep50u+zQfjVHyNw=
Date: Mon, 28 Oct 2024 17:03:21 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,mhiramat@kernel.org,mcgrof@kernel.org,lkp@intel.com,arnd@arndb.de,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch added to mm-unstable branch
Message-Id: <20241029000322.26B62C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: avoid execmem_vmap() when !MMU
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch
alloc_tag-introduce-pgtag_ref_handle-to-abstract-page-tag-references.patch
alloc_tag-support-for-page-allocation-tag-compression.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch
mm-codetag-uninline-and-move-pgalloc_tag_copy-and-pgalloc_tag_split.patch

