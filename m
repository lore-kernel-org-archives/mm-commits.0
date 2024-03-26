Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DED613D258
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482781; cv=none; b=K88HHQwThY9E/ZwUY11KGQLpILDB1TwT1UNRQN6k2xr1jOwJ7C4S/ACufi9NkY7gV1xQa8BTWJFiGk9WZloMNsgcoNKjCVSjXaPEyYKdhChiahQPDBbXzBMsyAvETkDG74ljVqtVuw/WDp82tdQVsGXAetEbygt2yrZDr+WoRvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482781; c=relaxed/simple;
	bh=5G8tnGCipCoB4zVxJDCYPB4diMswbmwEKyUp95yCoOo=;
	h=Date:To:From:Subject:Message-Id; b=GCggSMJgiVdHOZi2yTZoqzRfafvSUyshEg9lkHxbN9ucZDSXxWWqAnCLnAMvree9BA1nNGNB2s0fgipYspg3dG9ot2FvqWIC8/ZHqv51ZbGvT7VBanrK3xbN+B37vFyOCu8Sic/FaWpJyZ1dsghrNBykB+fsfhq7Z/EevIAS0Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsP1j8ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsP1j8ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F81C433F1;
	Tue, 26 Mar 2024 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482780;
	bh=5G8tnGCipCoB4zVxJDCYPB4diMswbmwEKyUp95yCoOo=;
	h=Date:To:From:Subject:From;
	b=AsP1j8abkksORCN9RJv/y42/BO0pUmdAJThyaSHobh5IvbX61QotgmbOrH28x3kUM
	 9rnElSt5cYtj+tg3wSBAT2v5uDagVf4Nv9+pf8swX+gVDH4kIESRvq+7kb6xB/fqUj
	 J4QK1IiGfSPQtDa41x+xQNaNkeZ0COI3/NAJMvBg=
Date: Tue, 26 Mar 2024 12:53:00 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch added to mm-unstable branch
Message-Id: <20240326195300.A4F81C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove the outdated code comment above deferred_grow_zone()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove the outdated code comment above deferred_grow_zone()
Date: Tue, 26 Mar 2024 14:11:31 +0800

The noinline attribute has been taken off in commit 9420f89db2dd ("mm:
move most of core MM initialization to mm/mm_init.c").  So remove the
unneeded code comment above deferred_grow_zone().

And also remove the unneeded bracket in deferred_init_pages().

Link: https://lkml.kernel.org/r/20240326061134.1055295-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone
+++ a/mm/mm_init.c
@@ -2007,7 +2007,7 @@ static unsigned long  __init deferred_in
 		__init_single_page(page, pfn, zid, nid);
 		nr_pages++;
 	}
-	return (nr_pages);
+	return nr_pages;
 }
 
 /*
@@ -2209,10 +2209,6 @@ zone_empty:
  * Return true when zone was grown, otherwise return false. We return true even
  * when we grow less than requested, to let the caller decide if there are
  * enough pages to satisfy the allocation.
- *
- * Note: We use noinline because this function is needed only during boot, and
- * it is called from a __ref function _deferred_grow_zone. This way we are
- * making sure that it is not inlined into permanent text section.
  */
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

