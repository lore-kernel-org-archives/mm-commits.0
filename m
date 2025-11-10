Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72F41FF1C4;
	Mon, 10 Nov 2025 05:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752024; cv=none; b=n5JjhqAxQLXJeCJk2DaZWQWA9dT5PSQB4PhTI8Ao9lCAYmUt8cWkPZTw6SJDCeYdJnEKsLvIZPKCXMh1YrauLNcP9PzSVc6tUeKT7avDwGuVeWMJPwwxL3VS16oVF+RTNAivf8EXPtC59dybsuqwluZYBsqJpQP6vMgmmPKIDuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752024; c=relaxed/simple;
	bh=VvNJ+jpkB+yiZagQYLZqoEpkAV+rVlGkIlL8P6kLuhw=;
	h=Date:To:From:Subject:Message-Id; b=K4M5GGw7YcKNjy51pKX+reCSYLs2W7sog6NHUR9e2FAL/qBU4Bki9Q+XVm4tHWPqeVqIQlsezPXvDwEi59CHN4BcEN74v9HG5VKzjj4rRFDoxDmP/W7gWUROEwuKwkfZvyJWrGFeHqkXGcO+zkvDcQZJ37ix2A3CX01wrIfrozQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+DoFZtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+DoFZtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961DC19422;
	Mon, 10 Nov 2025 05:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752024;
	bh=VvNJ+jpkB+yiZagQYLZqoEpkAV+rVlGkIlL8P6kLuhw=;
	h=Date:To:From:Subject:From;
	b=C+DoFZtGQaQJKofNA46ElJDf0YnHyrLLbNJcbTpOYZ/NKCak6SeLaQ8k0xchYevhu
	 YMkfvXcljDq2qqwJZ4LaW6RIZHKBIzOO9Zrisz0y3lSYaaYxpqdJDsszurzXy8otI4
	 WnBlKEmk93t4uv7K6znv0wqKUAiz6BZ+cCCI62FM=
Date: Sun, 09 Nov 2025 21:20:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,djwong@kernel.org,david@redhat.com,david@fromorbit.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch removed from -mm tree
Message-Id: <20251110052024.1961DC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: do not populate page table entries beyond i_size
has been removed from the -mm tree.  Its filename was
     mm-memory-do-not-populate-page-table-entries-beyond-i_size.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/memory: do not populate page table entries beyond i_size
Date: Mon, 27 Oct 2025 11:56:35 +0000

Patch series "Fix SIGBUS semantics with large folios", v3.

Accessing memory within a VMA, but beyond i_size rounded up to the next
page size, is supposed to generate SIGBUS.

Darrick reported[1] an xfstests regression in v6.18-rc1.  generic/749
failed due to missing SIGBUS.  This was caused by my recent changes that
try to fault in the whole folio where possible:

        19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
        357b92761d94 ("mm/filemap: map entire large folio faultaround")

These changes did not consider i_size when setting up PTEs, leading to
xfstest breakage.

However, the problem has been present in the kernel for a long time -
since huge tmpfs was introduced in 2016.  The kernel happily maps
PMD-sized folios as PMD without checking i_size.  And huge=always tmpfs
allocates PMD-size folios on any writes.

I considered this corner case when I implemented a large tmpfs, and my
conclusion was that no one in their right mind should rely on receiving a
SIGBUS signal when accessing beyond i_size.  I cannot imagine how it could
be useful for the workload.

But apparently filesystem folks care a lot about preserving strict SIGBUS
semantics.

Generic/749 was introduced last year with reference to POSIX, but no real
workloads were mentioned.  It also acknowledged the tmpfs deviation from
the test case.

POSIX indeed says[3]:

        References within the address range starting at pa and
        continuing for len bytes to whole pages following the end of an
        object shall result in delivery of a SIGBUS signal.

The patchset fixes the regression introduced by recent changes as well as
more subtle SIGBUS breakage due to split failure on truncation.


This patch (of 2):

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

Make an exception for shmem/tmpfs that for long time intentionally
mapped with PMDs across i_size.

Link: https://lkml.kernel.org/r/20251027115636.82382-1-kirill@shutemov.name
Link: https://lkml.kernel.org/r/20251027115636.82382-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Fixes: 6795801366da ("xfs: Support large folios")
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   28 ++++++++++++++++++++--------
 mm/memory.c  |   20 +++++++++++++++++++-
 2 files changed, 39 insertions(+), 9 deletions(-)

--- a/mm/filemap.c~mm-memory-do-not-populate-page-table-entries-beyond-i_size
+++ a/mm/filemap.c
@@ -3681,7 +3681,8 @@ skip:
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned short *mmap_miss)
+			unsigned long *rss, unsigned short *mmap_miss,
+			bool can_map_large)
 {
 	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
@@ -3696,7 +3697,7 @@ static vm_fault_t filemap_map_folio_rang
 	 * The folio must not cross VMA or page table boundary.
 	 */
 	addr0 = addr - start * PAGE_SIZE;
-	if (folio_within_vma(folio, vmf->vma) &&
+	if (can_map_large && folio_within_vma(folio, vmf->vma) &&
 	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
 		vmf->pte -= start;
 		page -= start;
@@ -3811,13 +3812,27 @@ vm_fault_t filemap_map_pages(struct vm_f
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
+	bool can_map_large;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
 	if (!folio)
 		goto out;
 
-	if (filemap_map_pmd(vmf, folio, start_pgoff)) {
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
+	/*
+	 * Do not allow to map with PTEs beyond i_size and with PMD
+	 * across i_size to preserve SIGBUS semantics.
+	 *
+	 * Make an exception for shmem/tmpfs that for long time
+	 * intentionally mapped with PMDs across i_size.
+	 */
+	can_map_large = shmem_mapping(mapping) ||
+		file_end >= folio_next_index(folio);
+
+	if (can_map_large && filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3830,10 +3845,6 @@ vm_fault_t filemap_map_pages(struct vm_f
 		goto out;
 	}
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	if (end_pgoff > file_end)
-		end_pgoff = file_end;
-
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
@@ -3850,7 +3861,8 @@ vm_fault_t filemap_map_pages(struct vm_f
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss);
+					nr_pages, &rss, &mmap_miss,
+					can_map_large);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
--- a/mm/memory.c~mm-memory-do-not-populate-page-table-entries-beyond-i_size
+++ a/mm/memory.c
@@ -65,6 +65,7 @@
 #include <linux/gfp.h>
 #include <linux/migrate.h>
 #include <linux/string.h>
+#include <linux/shmem_fs.h>
 #include <linux/memory-tiers.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
@@ -5501,8 +5502,25 @@ fallback:
 			return ret;
 	}
 
+	if (!needs_fallback && vma->vm_file) {
+		struct address_space *mapping = vma->vm_file->f_mapping;
+		pgoff_t file_end;
+
+		file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+
+		/*
+		 * Do not allow to map with PTEs beyond i_size and with PMD
+		 * across i_size to preserve SIGBUS semantics.
+		 *
+		 * Make an exception for shmem/tmpfs that for long time
+		 * intentionally mapped with PMDs across i_size.
+		 */
+		needs_fallback = !shmem_mapping(mapping) &&
+			file_end < folio_next_index(folio);
+	}
+
 	if (pmd_none(*vmf->pmd)) {
-		if (folio_test_pmd_mappable(folio)) {
+		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
 			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
_

Patches currently in -mm which might be from kas@kernel.org are


