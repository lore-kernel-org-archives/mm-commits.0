Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25849221721
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337050; cv=none; b=JCO7jJ9QLs8DSHOLDnDRzEkA8xTDUmGwWHtH8S+9X6MDBmnhwSO5JTGS8N6NOwS1SPJFbP+9TWerj/PNXSaARtJZHwtk5RBZbnpamfwyvNJlby82srMzrTLSXxJDcZXwT9tFl0PAkmt94NQ3vIPS5HP8ETxdMFpWL0lL9kErw1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337050; c=relaxed/simple;
	bh=TsCbMW29fteuyzwjoRFCTnxz1fIImjsPi6ntxwkQ5Us=;
	h=Date:To:From:Subject:Message-Id; b=I10pGjRRtuXveZqQA37myoAXfFMTZ/UpMKqFTd65OYLw3Yg+iqZW6AoDQhgWZZHM2LAStOiZ4IgTJm63jYiTbL1k5kqfxxvlWP9hXzUqA1fu80gH5/+BidL0H1OMz+ooXuSpKSwa2fo4T07+3t2UVJ1O/jgY4UMBRNFFaQpJles=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jUqqY78y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jUqqY78y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC4D1F000E9;
	Sat, 18 Jul 2026 01:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337048;
	bh=XRJ/1eWwZg9WVFcFu/MBtOwQOGL4X5ykzKYT0yihrX8=;
	h=Date:To:From:Subject;
	b=jUqqY78yRdyMj40hsEkLmSZVR7hltKiXsO7XMRwKDRX6S7BxXKx3GjS3PG7yk1VI/
	 aZO2BvDksinjJqgJ6DWVXJCRz0MGVEi1aUsgDDWI0NO6zJOS2Ix07Oxkb6uOV/Pek3
	 mcglbXsVox9cJNk5hnf532r3f5FVx3Pdz3PehBrg=
Date: Fri, 17 Jul 2026 18:10:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-remove-xa_is_value-in-mincore_swap.patch added to mm-new branch
Message-Id: <20260718011048.ADC4D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: remove xa_is_value() in mincore_swap()
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-remove-xa_is_value-in-mincore_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-remove-xa_is_value-in-mincore_swap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: remove xa_is_value() in mincore_swap()
Date: Fri, 17 Jul 2026 17:13:45 +0800

The swap_cache_get_folio() no longer returns shadow entries, so the
xa_is_value() check is unnecessary.

Link: https://lore.kernel.org/20260717091347.1144789-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-xa_is_value-in-mincore_swap
+++ a/mm/mincore.c
@@ -91,8 +91,7 @@ static unsigned char mincore_swap(swp_en
 	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
-	/* The swap cache space contains either folio, shadow or NULL */
-	if (folio && !xa_is_value(folio)) {
+	if (folio) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch

