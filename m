Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5371E48A
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854858; cv=none; b=RZxhPHXGF757dkdLCtrtxAlG5YqwuX9sut1/QYSnCc1LNjFKC282XJ2n918UurFWy/NP+4nBohAcbifuDHWb0Anc/L7j1Nsw3LPI+B4Wp/qQkX/HTESlL7xhuKJ35U9iA0qcslA14bTYCR+sXHVIQLvjt0OSv97k9Pmkgl/B6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854858; c=relaxed/simple;
	bh=LcsKL6niabQpzFXvcOZMwz2rX9ybY/7HRiZhupCiiKI=;
	h=Date:To:From:Subject:Message-Id; b=plVXj6YMMBKLJuYpWfKSpOrDEXIHOQx/IKSD9d09lrHKKICK0OQp9e8R7sGgq/D6hAXoZZHgNjP9D3W58Z6lZ6pYTR/Hnkt8tBN5y8eR9L/s6nfU1moDKwr2TF0DfoGtKXDH51Gx0DHhMZeFNMxlqCfIHztsE+ausFqpuP12n7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZeiYm0VP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZeiYm0VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5705AC4CECF;
	Wed,  6 Nov 2024 01:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854858;
	bh=LcsKL6niabQpzFXvcOZMwz2rX9ybY/7HRiZhupCiiKI=;
	h=Date:To:From:Subject:From;
	b=ZeiYm0VP8gka+e/hRENs2LHNi8lHwmNdLoRe7ZtMcePLSgvSQLYTbEFc0kdIaogF1
	 jpUfSDtYCsLWHgHDEAx3DqVxFVZ0ydYuwGWWLVywTcitQsY3uUJCwCERaJP94AzYRu
	 gb8n4+KxkvBaxAmw9GNVYoe5YFtRAerbXPVlhOME=
Date: Tue, 05 Nov 2024 17:00:57 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-populate-memory-for-module-tags-as-needed.patch removed from -mm tree
Message-Id: <20241106010058.5705AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: populate memory for module tags as needed
has been removed from the -mm tree.  Its filename was
     alloc_tag-populate-memory-for-module-tags-as-needed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: populate memory for module tags as needed
Date: Wed, 23 Oct 2024 10:07:57 -0700

The memory reserved for module tags does not need to be backed by physical
pages until there are tags to store there.  Change the way we reserve this
memory to allocate only virtual area for the tags and populate it with
physical pages as needed when we load a module.

[surenb@google.com: avoid execmem_vmap() when !MMU]
  Link: https://lkml.kernel.org/r/20241031233611.3833002-1-surenb@google.com
Link: https://lkml.kernel.org/r/20241023170759.999909-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiongwei Song <xiongwei.song@windriver.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/execmem.h |   12 ++++++
 include/linux/vmalloc.h |    3 +
 lib/Kconfig.debug       |    1 
 lib/alloc_tag.c         |   73 +++++++++++++++++++++++++++++++++-----
 mm/execmem.c            |   16 ++++++++
 mm/internal.h           |    6 +++
 mm/vmalloc.c            |    4 +-
 7 files changed, 104 insertions(+), 11 deletions(-)

--- a/include/linux/execmem.h~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/include/linux/execmem.h
@@ -139,6 +139,18 @@ void *execmem_alloc(enum execmem_type ty
  */
 void execmem_free(void *ptr);
 
+#ifdef CONFIG_MMU
+/**
+ * execmem_vmap - create virtual mapping for EXECMEM_MODULE_DATA memory
+ * @size: size of the virtual mapping in bytes
+ *
+ * Maps virtually contiguous area in the range suitable for EXECMEM_MODULE_DATA.
+ *
+ * Return: the area descriptor on success or %NULL on failure.
+ */
+struct vm_struct *execmem_vmap(size_t size);
+#endif
+
 /**
  * execmem_update_copy - copy an update to executable memory
  * @dst:  destination address to update
--- a/include/linux/vmalloc.h~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/include/linux/vmalloc.h
@@ -202,6 +202,9 @@ extern int remap_vmalloc_range_partial(s
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 
+int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
+		     struct page **pages, unsigned int page_shift);
+
 /*
  * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
  * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
--- a/lib/alloc_tag.c~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/lib/alloc_tag.c
@@ -8,14 +8,15 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
-static bool mem_profiling_support __meminitdata = true;
+static bool mem_profiling_support = true;
 #else
-static bool mem_profiling_support __meminitdata;
+static bool mem_profiling_support;
 #endif
 
 static struct codetag_type *alloc_tag_cttype;
@@ -154,7 +155,7 @@ size_t alloc_tag_top_users(struct codeta
 	return nr;
 }
 
-static void __init shutdown_mem_profiling(void)
+static void shutdown_mem_profiling(void)
 {
 	if (mem_alloc_profiling_enabled())
 		static_branch_disable(&mem_alloc_profiling_key);
@@ -179,6 +180,7 @@ static void __init procfs_init(void)
 #ifdef CONFIG_MODULES
 
 static struct maple_tree mod_area_mt = MTREE_INIT(mod_area_mt, MT_FLAGS_ALLOC_RANGE);
+static struct vm_struct *vm_module_tags;
 /* A dummy object used to indicate an unloaded module */
 static struct module unloaded_mod;
 /* A dummy object used to indicate a module prepended area */
@@ -252,6 +254,33 @@ repeat:
 	return false;
 }
 
+static int vm_module_tags_populate(void)
+{
+	unsigned long phys_size = vm_module_tags->nr_pages << PAGE_SHIFT;
+
+	if (phys_size < module_tags.size) {
+		struct page **next_page = vm_module_tags->pages + vm_module_tags->nr_pages;
+		unsigned long addr = module_tags.start_addr + phys_size;
+		unsigned long more_pages;
+		unsigned long nr;
+
+		more_pages = ALIGN(module_tags.size - phys_size, PAGE_SIZE) >> PAGE_SHIFT;
+		nr = alloc_pages_bulk_array_node(GFP_KERNEL | __GFP_NOWARN,
+						 NUMA_NO_NODE, more_pages, next_page);
+		if (nr < more_pages ||
+		    vmap_pages_range(addr, addr + (nr << PAGE_SHIFT), PAGE_KERNEL,
+				     next_page, PAGE_SHIFT) < 0) {
+			/* Clean up and error out */
+			for (int i = 0; i < nr; i++)
+				__free_page(next_page[i]);
+			return -ENOMEM;
+		}
+		vm_module_tags->nr_pages += nr;
+	}
+
+	return 0;
+}
+
 static void *reserve_module_tags(struct module *mod, unsigned long size,
 				 unsigned int prepend, unsigned long align)
 {
@@ -310,8 +339,18 @@ unlock:
 	if (IS_ERR(ret))
 		return ret;
 
-	if (module_tags.size < offset + size)
+	if (module_tags.size < offset + size) {
+		int grow_res;
+
 		module_tags.size = offset + size;
+		grow_res = vm_module_tags_populate();
+		if (grow_res) {
+			shutdown_mem_profiling();
+			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
+			       mod->name);
+			return ERR_PTR(grow_res);
+		}
+	}
 
 	return (struct alloc_tag *)(module_tags.start_addr + offset);
 }
@@ -372,12 +411,23 @@ static void replace_module(struct module
 
 static int __init alloc_mod_tags_mem(void)
 {
-	/* Allocate space to copy allocation tags */
-	module_tags.start_addr = (unsigned long)execmem_alloc(EXECMEM_MODULE_DATA,
-							      MODULE_ALLOC_TAG_VMAP_SIZE);
-	if (!module_tags.start_addr)
+	/* Map space to copy allocation tags */
+	vm_module_tags = execmem_vmap(MODULE_ALLOC_TAG_VMAP_SIZE);
+	if (!vm_module_tags) {
+		pr_err("Failed to map %lu bytes for module allocation tags\n",
+			MODULE_ALLOC_TAG_VMAP_SIZE);
+		module_tags.start_addr = 0;
+		return -ENOMEM;
+	}
+
+	vm_module_tags->pages = kmalloc_array(get_vm_area_size(vm_module_tags) >> PAGE_SHIFT,
+					sizeof(struct page *), GFP_KERNEL | __GFP_ZERO);
+	if (!vm_module_tags->pages) {
+		free_vm_area(vm_module_tags);
 		return -ENOMEM;
+	}
 
+	module_tags.start_addr = (unsigned long)vm_module_tags->addr;
 	module_tags.end_addr = module_tags.start_addr + MODULE_ALLOC_TAG_VMAP_SIZE;
 
 	return 0;
@@ -385,8 +435,13 @@ static int __init alloc_mod_tags_mem(voi
 
 static void __init free_mod_tags_mem(void)
 {
-	execmem_free((void *)module_tags.start_addr);
+	int i;
+
 	module_tags.start_addr = 0;
+	for (i = 0; i < vm_module_tags->nr_pages; i++)
+		__free_page(vm_module_tags->pages[i]);
+	kfree(vm_module_tags->pages);
+	free_vm_area(vm_module_tags);
 }
 
 #else /* CONFIG_MODULES */
--- a/lib/Kconfig.debug~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/lib/Kconfig.debug
@@ -993,6 +993,7 @@ config CODE_TAGGING
 config MEM_ALLOC_PROFILING
 	bool "Enable memory allocation profiling"
 	default n
+	depends on MMU
 	depends on PROC_FS
 	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
--- a/mm/execmem.c~alloc_tag-populate-memory-for-module-tags-as-needed
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
--- a/mm/internal.h~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/mm/internal.h
@@ -1263,6 +1263,12 @@ int numa_migrate_check(struct folio *fol
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_folio(struct folio *folio);
 
+struct vm_struct *__get_vm_area_node(unsigned long size,
+				     unsigned long align, unsigned long shift,
+				     unsigned long flags, unsigned long start,
+				     unsigned long end, int node, gfp_t gfp_mask,
+				     const void *caller);
+
 /*
  * mm/gup.c
  */
--- a/mm/vmalloc.c~alloc_tag-populate-memory-for-module-tags-as-needed
+++ a/mm/vmalloc.c
@@ -653,7 +653,7 @@ int vmap_pages_range_noflush(unsigned lo
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-static int vmap_pages_range(unsigned long addr, unsigned long end,
+int vmap_pages_range(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	int err;
@@ -3106,7 +3106,7 @@ static void clear_vm_uninitialized_flag(
 	vm->flags &= ~VM_UNINITIALIZED;
 }
 
-static struct vm_struct *__get_vm_area_node(unsigned long size,
+struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long shift, unsigned long flags,
 		unsigned long start, unsigned long end, int node,
 		gfp_t gfp_mask, const void *caller)
_

Patches currently in -mm which might be from surenb@google.com are

mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

