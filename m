Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F142449B2F
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591217; cv=none; b=B+AlDWxsEdNX+2ddR5B7bna1QDVK2KyCSrkSTEscSM/X7ibtMUbxKMgtbWqhWDVNeUPNorbE80ULSDW18iI4tbJbO14QDe2rFNoziZAj9H4NijKyaWv7ehTnpV6t37lRaK3MuEIekKfV8+LX4iuOLCPl1OCjHArGCb/c3YanHS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591217; c=relaxed/simple;
	bh=9QHcCONGJVZIytcVMk3rZiFB8Bcbpwy3Lxuyf2E3Jqo=;
	h=Date:To:From:Subject:Message-Id; b=ZtZyD5dWQU32hWyiHGy99H/hyzAW+wjgIMH0vVxfRrr23J8Mgu8JCl9nN23MVwnsJOfNcjmBK+aWnwrHvoEcG1DRpzjRj7RYU/kD4xyA7J/W5/qzxmFi2JAIOQUD+ZQFw78cVr5HWr4eW3GD3NTYzYg6vUtPk3yX7hHKb816nj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5aSNhL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5aSNhL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC861F000E9;
	Mon, 20 Jul 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591216;
	bh=feHJRZqJKbSUehiBquHOlFo1YbIyOl32YiUSuE0Bq/8=;
	h=Date:To:From:Subject;
	b=g5aSNhL5NEKGwuGO4ElsXHgyQUP6RmXVi2GMBkToxF1eeRmEsvTEKJd6BbYoK3+O4
	 gT268xipqlSO1oei2EvD5Nl9oHr7MULAax7BHE5otKyVaznve6Yfkk14zjH4Xnfrih
	 7feFNtmT5FI3QicZoR9O/pSxUcNnxWHlmHp9GYJA=
Date: Mon, 20 Jul 2026 16:46:55 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch added to mm-new branch
Message-Id: <20260720234656.1BC861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
Date: Mon, 20 Jul 2026 06:55:07 +0000

Commit a67fe41e214f ("mm: rmap: support batched unmapping for file large
folios") extended batched unmapping for file folios.  That also required
making pte_install_uffd_wp_if_needed() support batching, but that was left
out for the time being.  Correctness was maintained by stopping batching
if the VMA the folio belongs to is marked uffd-wp.

Now that cond_install_uffd_wp_ptes() supports batching, call it with the
full batch length and allow folio_unmap_pte_batch() to batch file folios
belonging to uffd-wp VMAs.

For file folios, if the uffd-wp bit is set, unmapping converts present
PTEs into uffd-wp markers.  We must ensure that the same PTE range is not
reprocessed by the try_to_unmap_one() loop.

The page_vma_mapped_walk API ensures this: check_pte() only returns true
if any PFN in [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the PTE. 
There is no PFN underlying a uffd-wp marker PTE, so check_pte() returns
false and the walk skips ahead until it reaches a present entry again.

Link: https://lore.kernel.org/20260720065508.2695106-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas
+++ a/mm/rmap.c
@@ -1971,9 +1971,6 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_protected(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2351,7 +2348,8 @@ static bool try_to_unmap_one(struct foli
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval,
+					  nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

