Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363CE366
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478402; cv=none; b=QdcE7ETL5GanvHTTHmfcI230+CepvBUq8jWQip3ANz3I6EGRVUN2h7lbq5JnlUZdPFj7zDoKhu8g+U8avqx0D+2i5LQZVSQTf5G+Up3luwqkfqlso8BlgrtFI6zODcLhsYuHauLwlQ5Lngjt3c++twDhKeFRkz9AcF1G0yuuvLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478402; c=relaxed/simple;
	bh=ZOcPjuTWhlFcTvqjZr6P5t7RJU5pzY9v7in1HmMvV6M=;
	h=Date:To:From:Subject:Message-Id; b=nUWG1Y6jNNs6Kx3T4TkloYmEm5tbdztYge29C3l7O3rteqgmDGN9M8bELZ3LEMiA1e4J+Z9RLDl/JbDwbk9N+zCVhvnd+q9HLoFwl4bvd3AJ+3gNnhi26WXMmux+vsM7y7fGTtyhSfZvrz9HeDQ3jQr1f9DGoV+pV2DASFff9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZavQnuHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZavQnuHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DC6C433F1;
	Tue, 26 Mar 2024 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711478401;
	bh=ZOcPjuTWhlFcTvqjZr6P5t7RJU5pzY9v7in1HmMvV6M=;
	h=Date:To:From:Subject:From;
	b=ZavQnuHu87xsv+bO2XZZqI2xwMCfzuRHJQj63EavmVvMXdPz5luf7WYFGX6H151IB
	 vYk563HjRJf2Qg8RarHB03iiQKus7qvVRmyk8fXV0aPg89+k48iNX8QtUY3IHvX8MT
	 q+NP/hF4izQfNMP2IycKWqoqmaJp39NpTeCP//wM=
Date: Tue, 26 Mar 2024 11:40:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-enable-memory-allocation-profiling-fix.patch added to mm-unstable branch
Message-Id: <20240326184001.98DC6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/um: fix forward declaration for vmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-enable-memory-allocation-profiling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-enable-memory-allocation-profiling-fix.patch

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
Subject: arch/um: fix forward declaration for vmalloc
Date: Tue, 26 Mar 2024 00:37:50 -0700

Patch [1] replaced vmalloc() function with a new definition but it did not
adjust the forward declaration used in UML architecture.  Change it to act
as before.

Note that this prevents the vmalloc() allocations in __wrap_malloc() from
being accounted.  If accounting here is critical, we will have to remove
this forward declaration and include vmalloc.h, however that would pull in
more dependencies and would require introducing more architecture-specific
headers, like asm/bug.h, asm/rwonce.h, etc.  This is likely the reason why
this forward declaration was introduced in the first place.

[1] https://lore.kernel.org/all/20240321163705.3067592-31-surenb@google.com/

Link: https://lkml.kernel.org/r/20240326073750.726636-1-surenb@google.com
Fixes: 576477564ede ("mm: vmalloc: enable memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: SeongJae Park <sj@kernel.org>
Closes: https://lore.kernel.org/all/20240323180506.195396-1-sj@kernel.org/
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/shared/um_malloc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/um/include/shared/um_malloc.h~mm-vmalloc-enable-memory-allocation-profiling-fix
+++ a/arch/um/include/shared/um_malloc.h
@@ -11,7 +11,8 @@
 extern void *uml_kmalloc(int size, int flags);
 extern void kfree(const void *ptr);
 
-extern void *vmalloc(unsigned long size);
+extern void *vmalloc_noprof(unsigned long size);
+#define vmalloc(...)		vmalloc_noprof(__VA_ARGS__)
 extern void vfree(void *ptr);
 
 #endif /* __UM_MALLOC_H__ */
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
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

