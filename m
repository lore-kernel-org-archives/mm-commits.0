Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF618DB1A
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 00:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853454; cv=none; b=MnsInbHClk+bRqj6J6vYH/EkE9VWXciwFMHLCF4HKJn+KxCoEAR94WBNbR/qbd78h8yIAFJYh7GHIva2qYOKh7wpjQG/622L3z1zTfFe00JkcbboCRIxyi0KwG7w9qsxKTPyd7olIGbyRVbDIzuxQTxKARDLI+yAoiYrJxN8A+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853454; c=relaxed/simple;
	bh=CMWuewrP+TQCjxEBYxBzeWUDMtr1N6bS2wa9d1QWdn4=;
	h=Date:To:From:Subject:Message-Id; b=TzNLd4Er5Tz2qsuXe9Xd5Il6tEPQr7I+KGeqlypxyELxgI7Y8BGgkT+9qfSeK9uqiDvQZSht3fWZVvowp449fjdAw0mfsDZPGJbAErE/b1zFjew8tBO5YJ+MIYcAKLhAcZsKLBPIZBWpClkxdGQ3t6T9lfL6bd+pZ3FHiHQjGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LzdkGOlp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LzdkGOlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E90F1F000E9;
	Fri, 24 Jul 2026 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784853453;
	bh=mte7IK9RPJCOamNchoyTeFaoZBfIk0W0BNAb7RHyEGo=;
	h=Date:To:From:Subject;
	b=LzdkGOlpV+e/DRqiUgC4RASg/jKHqqlF2y43dfdzN0BF3Rhm0vZ6/u72FvHdBXYIB
	 jkeSZCKqZ7nzYPzDso10RSq+xTvGkWX1Vf5IjxLCSAOzGAIVEeS9y2d42mIw++IvNN
	 12nUfBjR0tZGFWuAR6st2W+Nazcj1wVSZ30Q+jSY=
Date: Thu, 23 Jul 2026 17:37:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-the-softleaf_is_device_private-path.patch added to mm-new branch
Message-Id: <20260724003733.4E90F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use a folio in the softleaf_is_device_private path
has been added to the -mm mm-new branch.  Its filename is
     mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm: use a folio in the softleaf_is_device_private path
Date: Thu, 23 Jul 2026 11:07:51 +0800

Patch series "mm: folio conversion and refactoring in do_swap_page()", v2.

Convert the device-private migration path in do_swap_page() to use folio
APIs, then extract all non-swap entry handling into a new
do_non_swap_page() helper to improve readability and reduce the size of
the main swap fault function.


This patch (of 2):

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with one.

Link: https://lore.kernel.org/20260723030752.16979-1-hongfu.li@linux.dev
Link: https://lore.kernel.org/20260723030752.16979-2-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-the-softleaf_is_device_private-path
+++ a/mm/memory.c
@@ -4922,18 +4922,19 @@ vm_fault_t do_swap_page(struct vm_fault
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
+			 * Get a folio reference while we know the folio can't be
 			 * freed.
 			 */
-			if (trylock_page(vmf->page)) {
+			folio = page_folio(vmf->page);
+			if (folio_trylock(folio)) {
 				struct dev_pagemap *pgmap;
 
-				get_page(vmf->page);
+				folio_get(folio);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				pgmap = page_pgmap(vmf->page);
 				ret = pgmap->ops->migrate_to_ram(vmf);
-				unlock_page(vmf->page);
-				put_page(vmf->page);
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch
selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-extract-non-swap-page-handling-to-do_non_swap_page.patch

