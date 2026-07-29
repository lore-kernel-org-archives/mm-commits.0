Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E548238C2C0
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298380; cv=none; b=OJbEcUX+hU73H7gVCvOcUTNMMb6JT05rGbqafKft1aKnL1bL31+HrdN2lPKNzjmsZU1/T7tXZ/CEH65VVG36ILJK2t8xTePDDTLyfYJF0ZyPmSzxv45KGDDT2jvYhE264qDAbDhoXB/kinHQcgamFFJQg2zEYCYmGU0YlLiqfDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298380; c=relaxed/simple;
	bh=xzKLfCyUuV5fXQbHas22My0bwP4Sh/+/w39KL64z80E=;
	h=Date:To:From:Subject:Message-Id; b=EeXONVVKgH/nAI64TpC3dNhcL5KsFQoMHtatZ9INwCqUjJ/SK0lMfgZkcFFj3MLxYxjZ2/pSq/Yxf4ZtY4y95Hn3E0oE/X1+c/2kK0x1cvGZ5CMvmPF1ae5snsdwoMyAz1fnqXUjRKUvpaLJnHy7ncmP6EN14BP41xCalCgm088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HP9Lue0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HP9Lue0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BC71F00A3A;
	Wed, 29 Jul 2026 04:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298378;
	bh=p2lUpUffUhKMWPOKqk03DlJrmHHmn8UaVLK23icmD5Q=;
	h=Date:To:From:Subject;
	b=HP9Lue0yuGWU1B1/tF2sZjyLivlx4XpHvaFE5nvSUOU0CwU/+3OMbLa9xh5c9X/Ik
	 LB6ZpqY4+isu3tv+N5iQOCwW8LWI/2GpEww/Sm+UPbXld6XKxqnvRYJULrdFKBrkf4
	 LSaQdZFFrm9UC0MOgdpFO8ZsHcC/I37oWzgomeGc=
Date: Tue, 28 Jul 2026 21:12:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-drop-sub-from-batching-context.patch removed from -mm tree
Message-Id: <20260729041258.74BC71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: drop 'sub' from batching context
has been removed from the -mm tree.  Its filename was
     mm-mprotect-drop-sub-from-batching-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/mprotect: drop 'sub' from batching context
Date: Tue, 23 Jun 2026 12:57:22 +0000

Shorten the name of page_anon_exclusive_sub_batch by dropping the
"sub-batch" context - the function itself doesn't need this context. 
Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the usage
is clear enough.

Link: https://lore.kernel.org/20260623125723.2503832-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-drop-sub-from-batching-context
+++ a/mm/mprotect.c
@@ -143,7 +143,7 @@ static __always_inline void prot_commit_
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -174,16 +174,16 @@ static __always_inline void commit_anon_
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool expected_anon_exclusive;
-	int sub_batch_idx = 0;
+	int batch_idx = 0;
 	int len;
 
 	while (nr_ptes) {
-		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
-		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
+		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
+		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
 					first_page, expected_anon_exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
-				       sub_batch_idx, expected_anon_exclusive, tlb);
-		sub_batch_idx += len;
+				       batch_idx, expected_anon_exclusive, tlb);
+		batch_idx += len;
 		nr_ptes -= len;
 	}
 }
_

Patches currently in -mm which might be from dev.jain@arm.com are

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

