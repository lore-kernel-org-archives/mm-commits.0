Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8D32F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101213; cv=none; b=GzpDshcTQKoEHHsT1m25wm4UnSxUBpGEdynWmeltehZP/ZAd94+mYGwjm5/qnp2EoZCynB6DIuFHvJucKKNDAlHN6tD4QuHVVvitkicho5oG6Uk+pxurvPfsHSlNbCtbMHCW7Kcfm2YgMVunatnbt4SwWF9s00s7E8IfTIQs/QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101213; c=relaxed/simple;
	bh=Jj0RRggHa+Q/e5FT911emuAeCCS4+NKMMt7juufz654=;
	h=Date:To:From:Subject:Message-Id; b=NqFmkPqWFzP/eWDuwBOh1O+gozL/GxoMOo3tO/dCb62xH2XGoHEIvyS7bTvL2tIyTnQ5TtLb/iunDGWEeMqESzVzM5zyzRGF0svcsWCOzb3uh8akrHiQTYyYjfCVc6Gw+FjXInY3AloH/VvM8a8p3kOfGTs5wJl7EZ6M/NklNS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CokvxAZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CokvxAZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25FAC113CD;
	Fri, 26 Apr 2024 03:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101213;
	bh=Jj0RRggHa+Q/e5FT911emuAeCCS4+NKMMt7juufz654=;
	h=Date:To:From:Subject:From;
	b=CokvxAZ27s+txlofMsyKkBmj+hFAl0LYmjW3ikeAmHLoiSpZwrUrIjiasxwmVbS8C
	 QGfT++VpsZm5F1FMVH1pLRrDE2cVZ0KhuReW4m7A9hiPARpzHoJMiux2OM/zFQr0ST
	 Q32Mr/lJMvUnpKABEx/W+NNoJ/KFIz7olkY2jycM=
Date: Thu, 25 Apr 2024 20:13:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,richard@nod.at,keescook@chromium.org,johannes@sipsolutions.net,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-enable-memory-allocation-profiling-fix.patch removed from -mm tree
Message-Id: <20240426031333.A25FAC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/um: fix forward declaration for vmalloc
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-enable-memory-allocation-profiling-fix.patch

This patch was dropped because it was folded into mm-vmalloc-enable-memory-allocation-profiling.patch

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
Reviewed-by: Johannes Berg <johannes@sipsolutions.net
Acked-by: Richard Weinberger <richard@nod.at>
Tested-by: Kees Cook <keescook@chromium.org>
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
mm-vmalloc-enable-memory-allocation-profiling.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

