Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA5E757F3
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101185; cv=none; b=a0uCfZkR/ERB7uS2JZGmJq8HWMEzZmpcQOfTr10QWIeowif0UG1BWiy6+DmUAuu6c83iB30GfF3df/9/OsjY1PBC37MhHGpLShQwdO7x3u5MDMA5z8BGDB2TlGntJdjkhEDTDmsYI4hj7rb0g+QjBN1mAjX1NzVuEG79+CXZ57E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101185; c=relaxed/simple;
	bh=eRzQOIGlA4wZHOn+ca6DEC47o3zZLQU4q/wfUxc+dxw=;
	h=Date:To:From:Subject:Message-Id; b=l4h0vDlTC1NKshRqkmSq/NswTdlkYn4Ful8tjARXFGzgBe0Xvj0NZ0CDWeJ/Re3fMg4Mz/mDIfZL56IAWmCTOHN2jxQ1zUoGWymzrVuC7mxVHMvt69uT4bLDXjZOCzNCVnlcWqp/zBjDGTACTCvkVPAP/uu+jXrh8GVB5qAcXRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8DW88GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8DW88GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B47C113CD;
	Fri, 26 Apr 2024 03:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101184;
	bh=eRzQOIGlA4wZHOn+ca6DEC47o3zZLQU4q/wfUxc+dxw=;
	h=Date:To:From:Subject:From;
	b=W8DW88GIC6+IWMVIX7NQIwQ3WIcQH2FY5CJy/IcE7fHfAzPiuUJPOc3aV2dFNTr/S
	 bVc2JS7buvPiPDF65VhF2pFHtD70Uq0OhcGj3STvwmJFCvLxp8TSXY89v3iXUmJ4rm
	 xnAC8nlZkuT9CAxluvQmoHRcEHXp2nfI1n0CIpZg=
Date: Thu, 25 Apr 2024 20:13:03 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-percpu-enable-per-cpu-allocation-tagging-fix.patch removed from -mm tree
Message-Id: <20240426031304.71B47C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: mm: percpu: undo _noprof additions in the documentation
has been removed from the -mm tree.  Its filename was
     mm-percpu-enable-per-cpu-allocation-tagging-fix.patch

This patch was dropped because it was folded into mm-percpu-enable-per-cpu-allocation-tagging.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: mm: percpu: undo _noprof additions in the documentation
Date: Tue, 26 Mar 2024 16:14:51 -0700

With kernel-doc script change to handle xyz_noprof() names, the previous
documentation changes and not needed anymore.

Link: https://lkml.kernel.org/r/20240326231453.1206227-6-surenb@google.com
Fixes: b3942167cb9f ("mm: percpu: enable per-cpu allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-enable-per-cpu-allocation-tagging-fix
+++ a/mm/percpu.c
@@ -1726,7 +1726,7 @@ static void pcpu_alloc_tag_free_hook(str
 #endif
 
 /**
- * pcpu_alloc_noprof - the percpu allocator
+ * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  * @reserved: allocate from the reserved chunk if available
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
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch
mm-change-inlined-allocation-helpers-to-account-at-the-call-site.patch
userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

