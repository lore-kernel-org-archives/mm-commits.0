Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86C257AFB
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023168; cv=none; b=Ek5XrEk4Hvl46bxUAFqi624nu71R2047PV/B2GmsGL93n0zQtnuz+PbHVujdHisDklx7cs6CxoeBZHUuN5c1x2SyycgAuEax6G5S6qH6S6qTlmLz7xAQmde1s5QOpLIDqRL0pjtNYLtRI+rAmZpfhQ4a+MuUuByB0YfsAVbenZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023168; c=relaxed/simple;
	bh=HDT6wvFHab7MgTxuQHulzkuyQs0EVeQN3YrZWUMtgME=;
	h=Date:To:From:Subject:Message-Id; b=T9Y9XSrRH4+Bfit8zdYt5pP/WGl4A5D27hEv9d0VHwJYu1Rrn1C/OlHHYzGoO6Sh8oGtxlbw0XeaUNmUtqwM7aVrqavC4PPTWG8aSpZP+LbX0MOwYgT4fckoV6Rv8tXffFqUAODsu+a8biYftACoAl+Yc2AlfHPcYgtV+yNZpAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMDs4l0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMDs4l0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7071C16AAE;
	Mon, 24 Nov 2025 22:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023167;
	bh=HDT6wvFHab7MgTxuQHulzkuyQs0EVeQN3YrZWUMtgME=;
	h=Date:To:From:Subject:From;
	b=IMDs4l0mctR25IdcRwlr0Ky3/u2NQI2fm0xRFtojiSGq7yUc7PbsM05fcANHCCr/o
	 dJUqLMz117AWbu03Nnade4IGhoO34AFU73F13SHU1M2rNgIoRE6BTKFamAiup7vlUj
	 obQ24PJbgw8qOKve0lM3EoBrZ+BbaRt1fwzKOQog=
Date: Mon, 24 Nov 2025 14:26:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,djwong@kernel.org,david@redhat.com,david@fromorbit.com,clm@meta.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch removed from -mm tree
Message-Id: <20251124222607.B7071C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: fix logic around SIGBUS in filemap_map_pages()
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/filemap: fix logic around SIGBUS in filemap_map_pages()
Date: Thu, 20 Nov 2025 16:14:11 +0000

Chris noticed that filemap_map_pages() calculates can_map_large only once
for the first page in the fault around range.  The value is not valid for
the following pages in the range and must be recalculated.

Instead of recalculating can_map_large on each iteration, pass down
file_end to filemap_map_folio_range() and let it make the decision on what
can be mapped.

Link: https://lkml.kernel.org/r/20251120161411.859078-1-kirill@shutemov.name
Fixes: 74207de2ba10 ("mm/memory: do not populate page table entries beyond i_size")h
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages
+++ a/mm/filemap.c
@@ -3682,8 +3682,9 @@ static vm_fault_t filemap_map_folio_rang
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
 			unsigned long *rss, unsigned short *mmap_miss,
-			bool can_map_large)
+			pgoff_t file_end)
 {
+	struct address_space *mapping = folio->mapping;
 	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
@@ -3692,12 +3693,16 @@ static vm_fault_t filemap_map_folio_rang
 	unsigned long addr0;
 
 	/*
-	 * Map the large folio fully where possible.
+	 * Map the large folio fully where possible:
 	 *
-	 * The folio must not cross VMA or page table boundary.
+	 *  - The folio is fully within size of the file or belong
+	 *    to shmem/tmpfs;
+	 *  - The folio doesn't cross VMA boundary;
+	 *  - The folio doesn't cross page table boundary;
 	 */
 	addr0 = addr - start * PAGE_SIZE;
-	if (can_map_large && folio_within_vma(folio, vmf->vma) &&
+	if ((file_end >= folio_next_index(folio) || shmem_mapping(mapping)) &&
+	    folio_within_vma(folio, vmf->vma) &&
 	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
 		vmf->pte -= start;
 		page -= start;
@@ -3812,7 +3817,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
-	bool can_map_large;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
@@ -3823,16 +3827,14 @@ vm_fault_t filemap_map_pages(struct vm_f
 	end_pgoff = min(end_pgoff, file_end);
 
 	/*
-	 * Do not allow to map with PTEs beyond i_size and with PMD
-	 * across i_size to preserve SIGBUS semantics.
+	 * Do not allow to map with PMD across i_size to preserve
+	 * SIGBUS semantics.
 	 *
 	 * Make an exception for shmem/tmpfs that for long time
 	 * intentionally mapped with PMDs across i_size.
 	 */
-	can_map_large = shmem_mapping(mapping) ||
-		file_end >= folio_next_index(folio);
-
-	if (can_map_large && filemap_map_pmd(vmf, folio, start_pgoff)) {
+	if ((file_end >= folio_next_index(folio) || shmem_mapping(mapping)) &&
+	    filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3861,8 +3863,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss,
-					can_map_large);
+					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
_

Patches currently in -mm which might be from kas@kernel.org are


