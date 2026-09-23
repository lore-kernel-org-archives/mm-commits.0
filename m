Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABF3456E0B
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202772; cv=none; b=F/gvLcY0qSKYrSNUrgB8eqV0za2Ut9fCRcrcrineNgs2SSsvdrgUdikq3YpKXpA/lfSL1AYdLCd+zmsPiMInSYSgyia+e9tkvnqQuyuBb+kdsrby8xrl7oolka+MmDf361Yi0akSyJnZv0TKodA/+P6VXKv/IlB9bOArvfnxnis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202772; c=relaxed/simple;
	bh=cVhYmywAIod8ggQ77tGaT47j/rGB0YnTogZR+Xhkm1U=;
	h=Date:To:From:Subject:Message-Id; b=SLoK6sfIHV5axpk3sED1AzSgSP3pDhqpz7e7oQj6E8vM8BPVFZjhZaavoyDNX3v9sh0HuA6nzZ6NK4JsJYrbhMf/V1BSvJjs8cJo4AH6uX5EafcUIxDVreJh6UYno6Ge6Iyzwszs0zBXq1H3ciOsMe1tfU7z+jGboYMQk6mdfFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Af/dH8Iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Af/dH8Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2388A1F000FF;
	Wed, 23 Sep 2026 22:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202770;
	bh=oZ15ZF+3yuSvr2wgc6gCocgU7eVd+N7KewtlKAIP284=;
	h=Date:To:From:Subject;
	b=Af/dH8Ivf23C6t/O/7ys6lYu5fDPTXF8QjnjD9kl/dnFeMc5LIPVBTPPottiExk78
	 LQQ2xsxUTz/YHOw1nHkQQu7sR4V49hjhUVHj/M1J37T8t4pU/F51dhnBoc7aUjKiGl
	 yjYQwspqZPLyG3j9i0BSFUgX9MIxRUGNs1AgCjpw=
Date: Wed, 23 Sep 2026 15:32:49 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch added to mm-unstable branch
Message-Id: <20260923223250.2388A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the unused do_lru argument of the file split helper
Date: Wed, 23 Sep 2026 23:32:45 +0200

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.  Drop
it.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-14-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper
+++ a/mm/huge_memory.c
@@ -4136,8 +4136,7 @@ out_unlock:
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4231,9 +4230,7 @@ static int __folio_freeze_split_file(str
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4255,8 +4252,7 @@ static int __folio_freeze_split_file(str
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4282,9 +4278,7 @@ static int __folio_freeze_split_file(str
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
 fail_mmap_unlock:
@@ -4360,7 +4354,7 @@ static int __folio_split(struct folio *f
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

