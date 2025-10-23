Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C9C263899
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761253098; cv=none; b=WOyQHACXTN9wc62bwdLnXZz/nvp5Hfil8GabIX2FEO7ZF3Q6tvwedvKYSF+JUU0yj16x3frcQ0dptRM0vtx5gStKkZ36ew5DkeTQ8FqHoGR/h6NXR/VqkCzsWTqanI0R4nZzPydaKoyNoxuHFUjr4vVogjiLDLX3HNNfKaIlT70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761253098; c=relaxed/simple;
	bh=0FVbNjtBwykRt3es4kv68yLbpXhObKC8WvL+KfhOGQU=;
	h=Date:To:From:Subject:Message-Id; b=PcCpy/P9uk//9IUOeYXt9hbUA/j7UgWGvVM9Q6UBbkNurM9WEX+Sl+WOmvuDxs/hztAmTeKYii3n1Id/1yuP1i2QfhNSIqP5FTo8RCKQ4+fzEzwY1oQCcST+lorbms0lAqZ/eutbqmKE8k0oixAfdtHJSrN1too3bkn7AjagzTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DdtKc0dO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdtKc0dO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FC8C4CEE7;
	Thu, 23 Oct 2025 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761253097;
	bh=0FVbNjtBwykRt3es4kv68yLbpXhObKC8WvL+KfhOGQU=;
	h=Date:To:From:Subject:From;
	b=DdtKc0dO2PTV6Q1FLFu0gWbd//STwgQYVdDzOnhl/zncb0MMGxGnCusuqTLGCWUVy
	 ELnwHRgzAR+ojmli19r99legnnyLnGdvH/uRIYFfMiqQ9Th+7IY9TZr5TlT9mo0WIh
	 x96Bs6q13fmXCtEkNZ6kifX8hmlXxDWDWtkyrmC8=
Date: Thu, 23 Oct 2025 13:58:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,djwong@kernel.org,david@redhat.com,david@fromorbit.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch added to mm-hotfixes-unstable branch
Message-Id: <20251023205817.C0FC8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: do not populate page table entries beyond i_size
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch

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
Subject: mm/memory: do not populate page table entries beyond i_size
Date: Thu, 23 Oct 2025 10:32:50 +0100

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

Recent changes attempted to fault in full folio where possible.  They did
not respect i_size, which led to populating PTEs beyond i_size and
breaking SIGBUS semantics.

Darrick reported generic/749 breakage because of this.

However, the problem existed before the recent changes.  With huge=always
tmpfs, any write to a file leads to PMD-size allocation.  Following the
fault-in of the folio will install PMD mapping regardless of i_size.

Fix filemap_map_pages() and finish_fault() to not install:
  - PTEs beyond i_size;
  - PMD mappings across i_size;

Link: https://lkml.kernel.org/r/20251023093251.54146-2-kirill@shutemov.name
Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++++++--------
 mm/memory.c  |   13 +++++++++++--
 2 files changed, 21 insertions(+), 10 deletions(-)

--- a/mm/filemap.c~mm-memory-do-not-populate-page-table-entries-beyond-i_size
+++ a/mm/filemap.c
@@ -3681,7 +3681,8 @@ skip:
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned short *mmap_miss)
+			unsigned long *rss, unsigned short *mmap_miss,
+			pgoff_t file_end)
 {
 	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
@@ -3697,7 +3698,8 @@ static vm_fault_t filemap_map_folio_rang
 	 */
 	addr0 = addr - start * PAGE_SIZE;
 	if (folio_within_vma(folio, vmf->vma) &&
-	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK) &&
+	    file_end >= folio_next_index(folio)) {
 		vmf->pte -= start;
 		page -= start;
 		addr = addr0;
@@ -3817,7 +3819,11 @@ vm_fault_t filemap_map_pages(struct vm_f
 	if (!folio)
 		goto out;
 
-	if (filemap_map_pmd(vmf, folio, start_pgoff)) {
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
+	if (file_end >= folio_next_index(folio) &&
+	    filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3830,10 +3836,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 		goto out;
 	}
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	if (end_pgoff > file_end)
-		end_pgoff = file_end;
-
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
@@ -3850,7 +3852,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss);
+					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
--- a/mm/memory.c~mm-memory-do-not-populate-page-table-entries-beyond-i_size
+++ a/mm/memory.c
@@ -5480,6 +5480,7 @@ vm_fault_t finish_fault(struct vm_fault
 	int type, nr_pages;
 	unsigned long addr;
 	bool needs_fallback = false;
+	pgoff_t file_end = -1UL;
 
 fallback:
 	addr = vmf->address;
@@ -5501,8 +5502,15 @@ fallback:
 			return ret;
 	}
 
+	if (vma->vm_file) {
+		struct inode *inode = vma->vm_file->f_mapping->host;
+
+		file_end = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	}
+
 	if (pmd_none(*vmf->pmd)) {
-		if (folio_test_pmd_mappable(folio)) {
+		if (folio_test_pmd_mappable(folio) &&
+		    file_end >= folio_next_index(folio)) {
 			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
@@ -5533,7 +5541,8 @@ fallback:
 		if (unlikely(vma_off < idx ||
 			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
 			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
+			    pte_off + (nr_pages - idx) > PTRS_PER_PTE ||
+			    file_end < folio_next_index(folio))) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
_

Patches currently in -mm which might be from kas@kernel.org are

mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch

