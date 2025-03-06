Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905CA2E3373
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 23:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302109; cv=none; b=MQn7Y64v01QX8Yk3FmrXA95rxI2u+p752SXDBTZs8lx2VbCvEhvRU8gK5DDMS0rVGFBPos81JixakPKFlsPnJWxu0MISex/wDgjL5Spi4w57Tb3GSHn61LWQ/h6ZeGVRZegZNDO3m5NXnKmWNWoeoz9iyn/AzaEyJ2KyUVS1Tus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302109; c=relaxed/simple;
	bh=oqvoACZNgwhrWaQq+opHiVCRt7+gHmst9v6Te4C6NxY=;
	h=Date:To:From:Subject:Message-Id; b=dOdommnYkpvPS9mw4P3mB+7SFNVBpHW6sae3nNOsh4DUcC+CUuBgvhbSb/q+eqj7dX0dJ38moQMO2fVIKq0nAQUcdk5oVi7IZGFyaQ5ZaD7PeZTzl6g/2oLiSlTlaM8uFTKSrA4cGSeYiQrqgKeElaEP6ldyYU0q8Zd8m1sSYpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHxLhs5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHxLhs5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9B8C4CEE0;
	Thu,  6 Mar 2025 23:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741302109;
	bh=oqvoACZNgwhrWaQq+opHiVCRt7+gHmst9v6Te4C6NxY=;
	h=Date:To:From:Subject:From;
	b=IHxLhs5Ed+nhiVvXYwdA+SjC7N+zHDlzRAffi1CGf7QAC8TI/W646j8J2aYf9lo4A
	 kkCHPGzWuggXCkhpNS/Rh7fQZfLw5qSaOeBSsXUlbwt7SxAXSQfxUrONlv0vDYJQTq
	 nkvHdDLipa5tStLFTphmmLMP296EQ9NXy/1zd/KM=
Date: Thu, 06 Mar 2025 15:01:48 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch added to mm-unstable branch
Message-Id: <20250306230148.EA9B8C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: refactor __vmalloc_node_range_noprof()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch

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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/vmalloc: refactor __vmalloc_node_range_noprof()
Date: Thu, 6 Mar 2025 15:21:31 +0800

According to the code logic, the first parameter of the sub-function
__get_vm_area_node() should be size instead of real_size.

Then in __get_vm_area_node(), the size will be aligned, so the redundant
alignment operation is deleted.

The use of the real_size variable causes code redundancy, so it is removed
to simplify the code.

The real prefix is generally used to indicate the adjusted value of a
parameter, but according to the code logic, it should indicate the
original value, so it is recommended to rename it to original_align.

Link: https://lkml.kernel.org/r/20250306072131.800499-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof
+++ a/mm/vmalloc.c
@@ -3770,8 +3770,7 @@ void *__vmalloc_node_range_noprof(unsign
 	struct vm_struct *area;
 	void *ret;
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
-	unsigned long real_size = size;
-	unsigned long real_align = align;
+	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
 
 	if (WARN_ON_ONCE(!size))
@@ -3780,7 +3779,7 @@ void *__vmalloc_node_range_noprof(unsign
 	if ((size >> PAGE_SHIFT) > totalram_pages()) {
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, exceeds total pages",
-			real_size);
+			size);
 		return NULL;
 	}
 
@@ -3797,19 +3796,18 @@ void *__vmalloc_node_range_noprof(unsign
 		else
 			shift = arch_vmap_pte_supported_shift(size);
 
-		align = max(real_align, 1UL << shift);
-		size = ALIGN(real_size, 1UL << shift);
+		align = max(original_align, 1UL << shift);
 	}
 
 again:
-	area = __get_vm_area_node(real_size, align, shift, VM_ALLOC |
+	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
 				  gfp_mask, caller);
 	if (!area) {
 		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, vm_struct allocation failed%s",
-			real_size, (nofail) ? ". Retrying." : "");
+			size, (nofail) ? ". Retrying." : "");
 		if (nofail) {
 			schedule_timeout_uninterruptible(1);
 			goto again;
@@ -3861,7 +3859,7 @@ again:
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
+	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -3870,17 +3868,15 @@ again:
 	 */
 	clear_vm_uninitialized_flag(area);
 
-	size = PAGE_ALIGN(size);
 	if (!(vm_flags & VM_DEFER_KMEMLEAK))
-		kmemleak_vmalloc(area, size, gfp_mask);
+		kmemleak_vmalloc(area, PAGE_ALIGN(size), gfp_mask);
 
 	return area->addr;
 
 fail:
 	if (shift > PAGE_SHIFT) {
 		shift = PAGE_SHIFT;
-		align = real_align;
-		size = real_size;
+		align = original_align;
 		goto again;
 	}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch
mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch
mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch
mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch

