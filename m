Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE12222D0
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 23:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268904; cv=none; b=GXEvZDLCJ/DlSgV2Ek0x+zBjTBTmnX9n8J2/RSEz9lzcJZsQehlOhKt72CqlwwpJl6hpBxiaccESotGERCPZzcjzc+0/pNE59Inm66GdnzN4ITYeBlbywGD25DbK6Tc5OkuO10uCUtFJPxxyhmmfcUpxFEXhu0xCDJn209d9aDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268904; c=relaxed/simple;
	bh=kp0B2SkpEJViO7erYpps8mtcNoOIBcHVdFiKol6jMzk=;
	h=Date:To:From:Subject:Message-Id; b=XLZjKR6wFQ/O75kkOhsiC7xF1J+Ai/iM4uAwag4uy7ZjPxFjnpLItoduGfitU71z1M7ZGZG/dG8RIi1XyhR5JGctaAwoOIw4PlQVNwKBX+mY8Q8MeviSCThNSq8EyT8Dh0AcEKowIWnN7KG3s2MScTh9Fjc2tIOnqmSD6uB1qFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nuzLb0mu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nuzLb0mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E4E1F000E9;
	Thu, 20 Aug 2026 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787268902;
	bh=1CJaZRwTjPHaGCFAdxe611qIhYPJ7FHP80ERqcyvJg8=;
	h=Date:To:From:Subject;
	b=nuzLb0muzJydriVyfSJ2IaKr2XVHEizUfduYluew6V5l/QFGg4QhRfCQgPAgIbDEi
	 raaGekz1q5v0GslGbzG1Nz0Tp6ANfy3cfjjQ07eLnyT4SLAgOBHMTpxmBJzuNDGIgH
	 MKpyqctaDymAwb8eK6Z0Ghbb+NcNhfazEh68L9ZM=
Date: Thu, 20 Aug 2026 16:35:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-the-softleaf_is_device_private-path.patch added to mm-new branch
Message-Id: <20260820233502.78E4E1F000E9@smtp.kernel.org>
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
Date: Wed, 19 Aug 2026 17:51:43 +0800

Use the folio APIs in the device_private migration path of do_swap_page(),
replacing four calls to compound_head() with two page_folio() calls.  The
second one re-fetches the folio from vmf->page after migrate_to_ram(),
which might have split the folio.

Link: https://lore.kernel.org/20260819095144.45660-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/all/e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-the-softleaf_is_device_private-path
+++ a/mm/memory.c
@@ -4926,18 +4926,21 @@ vm_fault_t do_swap_page(struct vm_fault
 				goto unlock;
 
 			/*
-			 * Get a page reference while we know the page can't be
-			 * freed.
+			 * Get a folio reference while we know the folio can't
+			 * be freed.
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
+				/* migrate_to_ram() might have split the folio. */
+				folio = page_folio(vmf->page);
+				folio_unlock(folio);
+				folio_put(folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch
selftests-mm-drop-redundant-open-in-mprotect_tests.patch
selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

