Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33B319AD97
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730419209; cv=none; b=gMxRCauXa5P+oxPlJ3hvqt2thvuFIlXY8eG8UPC35F4FJVmwjbyzfrLwO9dfXHzpGtRKVPFctxSc5OQPhOqGCt3fa1yCqxDbp/A1o+Gf6XlTt9tjBnuJeABLV9AcaZMZ5dY+1mjK305IvF8nEZcFF8V6HdAs8Wy4CljylFxUUY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730419209; c=relaxed/simple;
	bh=BC2VDi7HMf1u9DbGJJRp7OirKjZNcWLxPksbuFJZmv8=;
	h=Date:To:From:Subject:Message-Id; b=UkFjeg8BvvliYO7RI9SnzhOzT4has3hLUxy0SyqdF5PX/tnUJ5BpOPP1Hiz2saWcCtZsGh1dnqNdLR06e2c6aRiQiH5L6rZktlZM1z4kSHeNWwMYR98MMj1g84mZ6HYVew5bjJZCsccD9NdLC9U5xIL5fQoPvaec5izqymicOLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iGz5thwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iGz5thwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340A3C4CECF;
	Fri,  1 Nov 2024 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730419209;
	bh=BC2VDi7HMf1u9DbGJJRp7OirKjZNcWLxPksbuFJZmv8=;
	h=Date:To:From:Subject:From;
	b=iGz5thwdoU9CyxkSgLVaEfj2XW9NrxnNjLK2uo48w7Sd10ZSAEVha3AFpdCI1Ldq3
	 uoKGGnNjSjrpITrOa8g+KYZ2hw6G20e1ni77p7aon2Wr7ux3o00OeuSzZrZXrPwk3S
	 O1351NCxVLDuATbGVA2vxZDCjZh6FB0gBUGVxueQ=
Date: Thu, 31 Oct 2024 17:00:07 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,xiongwei.song@windriver.com,willy@infradead.org,vbabka@suse.cz,urezki@gmail.com,thuth@redhat.com,tglx@linutronix.de,souravpanda@google.com,samitolvanen@google.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,petr.pavlu@suse.com,paulmck@kernel.org,pasha.tatashin@soleen.com,minchan@google.com,mhocko@suse.com,mcgrof@kernel.org,lkp@intel.com,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,keescook@chromium.org,kaleshsingh@google.com,jhubbard@nvidia.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,dave@stgolabs.net,da.gomez@samsung.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-populate-memory-for-module-tags-as-needed-fix.patch added to mm-unstable branch
Message-Id: <20241101000009.340A3C4CECF@smtp.kernel.org>
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
Date: Thu, 31 Oct 2024 16:36:11 -0700

With CONFIG_MMU=n __get_vm_area_node() is not available. Add CONFIG_MMU
dependency for memory allocation tagging since it uses __get_vm_area_node()
via execmem_vmap().

Link: https://lkml.kernel.org/r/20241031233611.3833002-1-surenb@google.com
Fixes: 57bc3834fb6f ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410250808.dQGyYjlk-lkp@intel.com/
Closes: https://lore.kernel.org/oe-lkp/202410251525.9f85854d-oliver.sang@intel.com
Closes: https://lore.kernel.org/oe-kbuild-all/202410261016.IO7C6Cml-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202410270919.LebQlmxD-lkp@intel.com/
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
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
Cc: Minchan Kim <minchan@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
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

 include/linux/execmem.h |    2 ++
 lib/Kconfig.debug       |    1 +
 mm/execmem.c            |   32 ++++++++++++++++----------------
 3 files changed, 19 insertions(+), 16 deletions(-)

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
--- a/lib/Kconfig.debug~alloc_tag-populate-memory-for-module-tags-as-needed-fix
+++ a/lib/Kconfig.debug
@@ -993,6 +993,7 @@ config CODE_TAGGING
 config MEM_ALLOC_PROFILING
 	bool "Enable memory allocation profiling"
 	default n
+	depends on MMU
 	depends on PROC_FS
 	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
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

