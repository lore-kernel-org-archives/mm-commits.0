Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E23BC8CE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782355185; cv=none; b=dI50qVr37dQa2tamA37d+5H2VXW6XeumWuj/ykcHOzyMqRIQ6d7eEicwQLTxHAyk0pHQ/eeAQswyUb6T/eX8/S4wT5DJW5Vzu1R6ooWhiPHni5PDuEuMqdTO2mOA1ElzvLBKs1NrS0wQe+I2OurOSg5yR6IoO93g9SR3lhJ1zB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782355185; c=relaxed/simple;
	bh=4gVpAgKt2xxNGf0oA/usG7vPGu/hWgt0aWVcqNHktwA=;
	h=Date:To:From:Subject:Message-Id; b=cF2L0oc4STv0JgRZWMeWgbBgPSn8gNgMtryoI/G7pmbIVUgSrUjNkyNmDPHX3hbASnS+2fWryn31V3MtHirYbzSWsh0RknNHqHcb9r10/5oT4+zzEgVxFKl5BNpnhD6t1mb12xuFTvlHgCnTJsevuKk9MXcWJLQ69UPvfr7uEOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KcrFV0Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KcrFV0Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C6F1F000E9;
	Thu, 25 Jun 2026 02:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782355183;
	bh=LSi8LCN6IbXb2/mtvuA78mjl+JSHpPsvDLIKe1UusVY=;
	h=Date:To:From:Subject;
	b=KcrFV0KaBJFnOsweJxYyKuaI3tPLU+8hcEvNztUpM53fCm0KhWyDg4J7cWXxaEVgo
	 6bY0kl3/oLepBpMhSO0P2taVasibkXQ31p++kqsOBk1fT6ceYWgHmQeWOodvTIjPLp
	 w4wdMN7jwhB/doIB2XkpowndG5qaE4sRPaSptTrg=
Date: Wed, 24 Jun 2026 19:39:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rakie.kim@sk.com,pfalcato@suse.de,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch added to mm-new branch
Message-Id: <20260625023943.B9C6F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch

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
Subject: mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
Date: Thu, 18 Jun 2026 17:28:43 +0800

In mprotect_fixup(), the PROT_NONE PFN permission check uses
walk_page_range() to walk the page table.  Fortunately, the caller always
passes start/end that falls within a single VMA, the do_mprotect_pkey()
iterates per-VMA via for_each_vma_range(), and setup_arg_pages() passes
the whole VMA.

Note, walk_page_test() isn't called in walk_page_range_vma(), however,
prot_none_test() in prot_none_walk_ops always return 0, so it's safe to
replace walk_page_range() with walk_page_range_vma() to eliminate an
unnecessary find_vma() lookup, also remove unneeded prot_none_test() too.

Link: https://lore.kernel.org/20260618092845.3905740-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup
+++ a/mm/mprotect.c
@@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t
 		0 : -EACCES;
 }
 
-static int prot_none_test(unsigned long addr, unsigned long next,
-			  struct mm_walk *walk)
-{
-	return 0;
-}
-
 static const struct mm_walk_ops prot_none_walk_ops = {
 	.pte_entry		= prot_none_pte_entry,
 	.hugetlb_entry		= prot_none_hugetlb_entry,
-	.test_walk		= prot_none_test,
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
@@ -753,7 +746,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
-		error = walk_page_range(current->mm, start, end,
+		error = walk_page_range_vma(vma, start, end,
 				&prot_none_walk_ops, &new_pgprot);
 		if (error)
 			return error;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch

