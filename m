Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277EF385D71;
	Thu,  9 Jul 2026 22:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637396; cv=none; b=VhkZxpkUbYlkswywQRUtNQo3mHyh+VzKTjq+ZUDi0AQDQ+r8+S2ScCQNAj9EU1PKE/w6+eOmgTJDjoO2HVklHg1qqCGO4ERngJhZ2nRUcCDRDcL9mUFwR8un8H/4In4k6pqKEhbKx41ObQPzK4uwBb/xTn0eDIV5nQ9bLM1jgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637396; c=relaxed/simple;
	bh=5yknw9e9aQ6pLOFteDO8pasGmD5vSTpAWoZl+pj8kUA=;
	h=Date:To:From:Subject:Message-Id; b=ClIrfMcuvSiVOuW+6uCbzXotoiHBIu93sfJAqb5YIVctr4h+4cApCz7iA+WQa59HXBY5ELf8bVkdA1GTIqwr+yOLiCfCXHdKMH8RZZuca0yWdxZZtAMWqH0n+D0mcSbn/4aNUzGsbx6rxEXzW8Wv1GZRHWOQ+fm/lde3JYh+fKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cMsqjdiq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cMsqjdiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3F41F000E9;
	Thu,  9 Jul 2026 22:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637394;
	bh=zZeANOfNamqNh/8IHZcgS5mxJmoi6gOCUziTKaJq5RQ=;
	h=Date:To:From:Subject;
	b=cMsqjdiqW5IFVx3TccIp4GtsEmV8e0yXwb7ujbTr6snw+Cy2nGnzlhWBMHC2GShqZ
	 AcjVBiWQs4HCSF2Y340rRskM0YsuDTt0Z9/y7mEFUiRCE+N9r0N7hCfUdphsore4HZ
	 l7nhqjP0IBj3+fHnWQwnjYmE5BCWz19CiPdYCGCc=
Date: Thu, 09 Jul 2026 15:49:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-set-pg_has_hwpoisoned-only-after-new-folio-head-is-established.patch removed from -mm tree
Message-Id: <20260709224954.BA3F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-set-pg_has_hwpoisoned-only-after-new-folio-head-is-established.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm/huge_memory: set PG_has_hwpoisoned only after new folio head is established
Date: Wed, 1 Jul 2026 13:42:34 -0400

__split_folio_to_order() copies the hwpoison state onto each new sub-folio
while splitting a folio to a non-zero order.  It does so via

	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
		folio_set_has_hwpoisoned(new_folio);

*before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
turns @new_head from a tail page into a proper folio head.

PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so
folio_set_has_hwpoisoned() resolves to folio_flags(folio, 1).  With the
new compound_info-based page-flags layout, folio_flags() asserts the page
is not a tail:

	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);

At the current call site @new_head still has the tail marker
(compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
this hits:

  kernel BUG at include/linux/page-flags.h:354
  folio_flags+0x82
  folio_set_has_hwpoisoned
  __split_folio_to_order
  __split_unmapped_folio
  __folio_split
  truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)

Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
splits the partial folio to a non-zero order.

memory_failure() tries to split the poisoned folio to order 0 first, but
that split is best-effort; when it fails the folio is left large with
PG_has_hwpoisoned set, the case fa5a06170036 added this hwpoison copying
for.

Move the folio_set_has_hwpoisoned() call to after
clear_compound_head()/prep_compound_page(), where @new_folio is a real
order-new_order head folio (handle_hwpoison implies new_order != 0, so a
second page always exists).  The flag still lands on the same struct page
(page[1] of the new folio); only the ordering relative to compound-head
setup changes, satisfying the FOLIO_SECOND_PAGE precondition.

Link: https://lore.kernel.org/20260701174235.3173401-1-riel@surriel.com
Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-set-pg_has_hwpoisoned-only-after-new-folio-head-is-established
+++ a/mm/huge_memory.c
@@ -3587,10 +3587,6 @@ static void __split_folio_to_order(struc
 				 (1L << PG_dropbehind) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
-		if (handle_hwpoison &&
-		    page_range_has_hwpoisoned(new_head, new_nr_pages))
-			folio_set_has_hwpoisoned(new_folio);
-
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3612,6 +3608,14 @@ static void __split_folio_to_order(struc
 			folio_set_large_rmappable(new_folio);
 		}
 
+		/*
+		 * PG_has_hwpoisoned is on the 2nd page, so set it after
+		 * the compound head is prepped.
+		 */
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		if (folio_test_young(folio))
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))
_

Patches currently in -mm which might be from riel@surriel.com are


