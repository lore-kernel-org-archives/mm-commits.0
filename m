Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CA1368E09
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763665256; cv=none; b=Jc6vAXHZjvPjYdrbrfp3vQho7nu9lOp9IeExN4tpS9y6taS4Edn8QrTsIvbMeAASQZtpX8w2xW3M4HE+824kZAy27RO0PqunsICq8VW6dG/AEFriW42ASX3QBo+7DCXvgpnVe8l9ogUXOcOl90+Mbzxnf4pIvf2twXboVNPMWFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763665256; c=relaxed/simple;
	bh=HT6R70bOEAtC+QWtPr8xx9cRjhr7Lsdr+KHqjQDIxQQ=;
	h=Date:To:From:Subject:Message-Id; b=D4ZD2mN88A57pFTWRkNoiJ1EhbxlVmtwiVgZMlCF3QvSmpk1HyjJVOZ5+9LWIXcxm6vywVOE++2CrJMHfUTibBEhrf5ow7mEt2RFrHtuisCUboDshpMRI9JcxBLI59auHWPhizt0Bjd1obNjhwluJoSJYSidKQNWVWFFU7qEHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iTvg3JPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iTvg3JPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C3C16AAE;
	Thu, 20 Nov 2025 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763665256;
	bh=HT6R70bOEAtC+QWtPr8xx9cRjhr7Lsdr+KHqjQDIxQQ=;
	h=Date:To:From:Subject:From;
	b=iTvg3JPTsqb9WUovV0xp7B2IrloJMCgAyKjhEnErC+KFy0xq4myEJ5Qb4nLUus8Oq
	 fXLTaOxglQY1YVzRnZUSI8M2ykEkZ8RoY6G2g+JsYjcEYFNyCMB4WNHYxGBS+1/sGu
	 EqNejfUtOTsBJARtYku0NARRgqnUzpiNOGMvn7RM=
Date: Thu, 20 Nov 2025 11:00:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,djwong@kernel.org,david@redhat.com,david@fromorbit.com,clm@meta.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20251120190056.2C8C3C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: fix logic around SIGBUS in filemap_map_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-filemap-fix-logic-around-sigbus-in-filemap_map_pages.patch

