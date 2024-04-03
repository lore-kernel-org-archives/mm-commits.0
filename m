Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07232156664
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712181465; cv=none; b=hrHZfmKUmj0zDO+l2v6yf0zrxmolrepqrYWMRrytJ1p/+TT5OcqtaMYKSAbMRzsdUn5jVGScveUwFyiiHALgq37WkZLR0ze9XMKsVc8MpkuqMtZvWFRDfyPyJJC1vRqhmdmwtwgEkl/HGMXZWTVHiqph49oxbITA9W/6i9gKdjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712181465; c=relaxed/simple;
	bh=uvBjUqQyHNgDxWGTqwI/raf7DqAqnn4hpe3vbeY9EWE=;
	h=Date:To:From:Subject:Message-Id; b=jRr+jQzjd3/0xM9a/iqkHUJ06cINn7Ir3mHI6ertyNSYDkBPKTo4FPKMRNaHC8AP+JZ8M0UXOiCcYmnwI8yF1cQkO1VcIbOmSiFeQhuRASqcwA4IjTG9bpxl7ue/719V+VQ5n1QJJoIfHuUVzFH4ToAVDgaCcCpPXBMbcf3fczY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PCFWLscF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PCFWLscF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE80C433C7;
	Wed,  3 Apr 2024 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712181464;
	bh=uvBjUqQyHNgDxWGTqwI/raf7DqAqnn4hpe3vbeY9EWE=;
	h=Date:To:From:Subject:From;
	b=PCFWLscF7qizY+pK102UGogu7tmy8LWT1BNB2QrOVSuv1iivCEs65IJ2titrMTZ+b
	 Ii5sDMmNd/R+/4xGGndvEt6gnDD4SUrzMQOKdJnQ21P0Nflm5Li28+MqK1oB1cSyPS
	 tITISTDwAfOwc5WEwJDNM83QBSE9X7E/PiaqcVvk=
Date: Wed, 03 Apr 2024 14:57:43 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch added to mm-unstable branch
Message-Id: <20240403215744.7DE80C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: do limited memory accounting for modules with ARCH_NEEDS_WEAK_PER_CPU
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch

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

fix-missing-vmalloch-includes-fix-2.patch
mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
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
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

