Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CBE41DED8
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360917; cv=none; b=k+XAVPCwDs/k7DXcZVEyove6Rr1oM8hTS+0vMrXgkqMv/Ms3Y4Pq0bGvM7JnRjgYE0VoH1lxlKWVd82zQo8UOeEA0CTZSxNNsCMhePKfJF+eAEksS8PAztWa4aCSi3omDkxS38PyXFssO+S69MQSgfo7KcNvf9OHTEcAlEl1YAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360917; c=relaxed/simple;
	bh=q0vQvx51ukjFN34Cno/omJCopWkJL2NdQmCMQ5MWAeA=;
	h=Date:To:From:Subject:Message-Id; b=rUNVUcwpC0kAhcxGQTvnWglrP9F36hzNi7OlyPQ0lNiP0yM8AMR4ZOwRJ07m3BU7tSGDt02qiFH5C3Pef5Rr3ypnxxlrffntYKzkmXXmfJJfj3zHjyvIF68Od8CHPxN8328riB2irDDZNd/MDfXBoQWgGSr0iQQk8cDMV2c9IvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I7t9qEEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I7t9qEEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38A31F000E9;
	Mon,  6 Jul 2026 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360915;
	bh=9pF+SmHGfDa9dmKkIbl9sH1aMSUBTo4COUwRjMF9cSA=;
	h=Date:To:From:Subject;
	b=I7t9qEEWpHQzZcQnu0j8FLv1XRRExlMjU2q876W/9471PvIWVtL5PMoWte/bTBJfG
	 qqsdPCSe9GTLx6CgZjeAJiFSyTUGwRWlB2C3NiK2NeiAJWv0OZ/HBe5Z4vfSP4lBS9
	 ov6ech2ebs2de1uLezqA/nZe3/gOGhJlLGiixI0c=
Date: Mon, 06 Jul 2026 11:01:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch added to mm-new branch
Message-Id: <20260706180155.C38A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch

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
Subject: mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
Date: Mon, 6 Jul 2026 19:19:58 +0800

pte_pfn() and pte_dirty() have undefined behaviour when called on a
non-present PTE.  In migrate_vma_collect_pmd(), these functions may be
invoked on non-present entries (e.g., swap PTEs), leading to potential
crashes from pte_pfn() or incorrect dirty folio accounting from
pte_dirty().  Fix both by guarding with pte_present() checks.

Link: https://lore.kernel.org/20260706111958.3649651-1-wangkefeng.wang@huawei.com
Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte
+++ a/mm/migrate_device.c
@@ -411,7 +411,8 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			flush_cache_page(vma, addr, pte_pfn(pte));
+			if (pte_present(pte))
+				flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = folio_test_anon(folio) &&
 					  PageAnonExclusive(page);
 			if (anon_exclusive) {
@@ -432,7 +433,7 @@ again:
 			migrate->cpages++;
 
 			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
+			if (pte_present(pte) && pte_dirty(pte))
 				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch

