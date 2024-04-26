Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C119833EA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100886; cv=none; b=YwtqSbiliAlX6zfn423n44ut6gfz+n7s2EaE9Zh09dBhbjZfe5bD0IIXXY8WQNecFFSvomnwPkkgjxDnUu6FOzfSBikZkiJMig7FU3jRaEowQYFiDsVAw6Ig/TRPkanp/CiSHia8/ErjEXb19fxZwqf0QRv4RvSHqt9s7jxPAdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100886; c=relaxed/simple;
	bh=XH9qrQUETN/rk5xeqMSOekzG0mlnNKHyOv5O1axWXek=;
	h=Date:To:From:Subject:Message-Id; b=tDZVMFkvA4Jg4F4EG6MA6UCa0lksEzOR0ZTkjQi1I2asWUA8ptTJdw8n49Hsxc7teVDuk8QKKDsOUWKuIO0mXfgdUuYZLKVJrZJShkqM74Nx3LQIDQ0aCuSAG1KHbQkOiEF500jmnsMVOL1H+xD6hvHT6iNAp7bPxLnayTXdCyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XTv1kTfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XTv1kTfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946A4C113CC;
	Fri, 26 Apr 2024 03:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100886;
	bh=XH9qrQUETN/rk5xeqMSOekzG0mlnNKHyOv5O1axWXek=;
	h=Date:To:From:Subject:From;
	b=XTv1kTfypeEpEDJleGFnzI0xjGIV306/DSRI2uhRuJfDyofzOaBX6MF0vLYav5ng5
	 37tVISaua8cq2gvaMyQZ4L9E/dlNz5Jstj0EEpg1/wMEKfkO+IU4hVGOyNqTDd2SiS
	 4wytvnuBLc4KSopxX39I494+FwjpdrN4EzZ8/P4A=
Date: Thu, 25 Apr 2024 20:08:06 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch removed from -mm tree
Message-Id: <20240426030806.946A4C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: do limited memory accounting for modules with ARCH_NEEDS_WEAK_PER_CPU
has been removed from the -mm tree.  Its filename was
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch

This patch was dropped because it was folded into lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: do limited memory accounting for modules with ARCH_NEEDS_WEAK_PER_CPU
Date: Tue, 2 Apr 2024 11:09:33 -0700

ARCH_NEEDS_WEAK_PER_CPU does not allow percpu variable definitions inside
a function, therefore memory allocation profiling can't use it.  This
definition is used only for modules, so we still can account core kernel
allocations and for modules we can do limited allocation accounting by
charging all of them to a single counter.  This is not ideal but better
than no accounting at all.

Link: https://lkml.kernel.org/r/20240402180933.1663992-2-surenb@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290334.USWrYrMw-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   14 ++++++++++++--
 lib/alloc_tag.c           |    3 +++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/alloc_tag.h~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2
+++ a/include/linux/alloc_tag.h
@@ -39,9 +39,17 @@ static inline struct alloc_tag *ct_to_al
 /*
  * When percpu variables are required to be defined as weak, static percpu
  * variables can't be used inside a function (see comments for DECLARE_PER_CPU_SECTION).
+ * Instead we will accound all module allocations to a single counter.
  */
-#error "Memory allocation profiling is incompatible with ARCH_NEEDS_WEAK_PER_CPU"
-#endif
+DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
+
+#define DEFINE_ALLOC_TAG(_alloc_tag)						\
+	static struct alloc_tag _alloc_tag __used __aligned(8)			\
+	__section("alloc_tags") = {						\
+		.ct = CODE_TAG_INIT,						\
+		.counters = &_shared_alloc_tag };
+
+#else /* ARCH_NEEDS_WEAK_PER_CPU */
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static DEFINE_PER_CPU(struct alloc_tag_counters, _alloc_tag_cntr);	\
@@ -50,6 +58,8 @@ static inline struct alloc_tag *ct_to_al
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_alloc_tag_cntr };
 
+#endif /* ARCH_NEEDS_WEAK_PER_CPU */
+
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
--- a/lib/alloc_tag.c~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2
+++ a/lib/alloc_tag.c
@@ -9,6 +9,9 @@
 
 static struct codetag_type *alloc_tag_cttype;
 
+DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
+EXPORT_SYMBOL(_shared_alloc_tag);
+
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-4.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags-fix.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-enable-page-allocation-tagging-fix.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix-2.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

