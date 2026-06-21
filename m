Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B6E370AE4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067227; cv=none; b=TUDcJiPUk8dhK69GZuKD39+7MAyiYRNPOs5hhhs1Rex0TEG2EH8wQl+8xiFsy1fW7fSwYK11Y0qsqhwvFPG+V8kASBJhkq51kXXVonsoaNUsT0J0kAgW6+TPN8Ub0xwgbwx0ImihKw9/kqW9cnU5cTCW1HHPdjsUR1wVU3sjgYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067227; c=relaxed/simple;
	bh=vE43soGD6IIVWE0ayvkBQCkKLqPdh7aoEzN40dv5akQ=;
	h=Date:To:From:Subject:Message-Id; b=Apa9VzNjDOD52AlyB1o/PatKgru7Au+vmoYCWjlTatfDbeDFdkWSxYjguY385JtP90nsjkG9cSFezoUnARTXv/gpIisMqHbmIJpoTx3+6RdwUOhVssfa4TzWFBsOkfphriaKSNx63q4ivBHU3Cz4yCGKmnl3HL/JDgHd2n4Fp+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZ6xmKDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZ6xmKDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAE61F00A3A;
	Sun, 21 Jun 2026 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067226;
	bh=uwkkY6r0ClIs7VPQf4oafDrYBRfq0LyZkm+bDj2p4Vg=;
	h=Date:To:From:Subject;
	b=zZ6xmKDQ+hFKXR+AK450QUrvYTv23un+fAXL7/d6ygdTjhbtmkUpM8E3QH/HO0NTW
	 VA5gfVkUDUJ9Jw0funwCLKKBzYTO2RGyurKNN746XWuhw2RS5HL80Hjshx6Yi1GOgR
	 aJLwvMfozRIJCdGyqAgZ5U8d6SckuE+F4KeVecdY=
Date: Sun, 21 Jun 2026 11:40:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,pfalcato@suse.de,oliver.sang@intel.com,kaleshsingh@google.com,jack@suse.cz,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-limit-filemap_fault-readahead-to-vma-boundaries.patch removed from -mm tree
Message-Id: <20260621184026.6EAE61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: limit filemap_fault readahead to VMA boundaries"
has been removed from the -mm tree.  Its filename was
     revert-mm-limit-filemap_fault-readahead-to-vma-boundaries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: Revert "mm: limit filemap_fault readahead to VMA boundaries"
Date: Fri, 19 Jun 2026 12:28:51 +0100

This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.

This patch caused a significant performance regression, so revert it, and
we can determine whether the approach is sensible or not moving forwards,
and if so how to avoid this.

There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
PG_readahead on EOF"), care was taken to ensure that the revert retained
the behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm:
limit filemap_fault readahead to VMA boundaries") only.

Link: https://lore.kernel.org/20260619112852.104213-1-ljs@kernel.org
Fixes: 7b32f64bc512 ("mm: limit filemap_fault readahead to VMA boundaries")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |    4 ----
 mm/readahead.c          |    6 +-----
 3 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/pagemap.h~revert-mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/include/linux/pagemap.h
@@ -1348,7 +1348,6 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
-	pgoff_t _max_index; /* limit readahead to _max_index, inclusive */
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1362,7 +1361,6 @@ struct readahead_control {
 		.mapping = m,						\
 		.ra = r,						\
 		._index = i,						\
-		._max_index = ULONG_MAX,				\
 	}
 
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
--- a/mm/filemap.c~revert-mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/mm/filemap.c
@@ -3312,8 +3312,6 @@ static struct file *do_sync_mmap_readahe
 	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
-	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
-
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
 		/*
@@ -3409,7 +3407,6 @@ static struct file *do_sync_mmap_readahe
 		 * mmap read-around
 		 */
 		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
-		ra->start = max(ra->start, vmf->vma->vm_pgoff);
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
@@ -3457,7 +3454,6 @@ static struct file *do_async_mmap_readah
 	}
 
 	if (folio_test_readahead(folio)) {
-		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
--- a/mm/readahead.c~revert-mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/mm/readahead.c
@@ -335,8 +335,6 @@ static void do_page_cache_ra(struct read
 		return;
 
 	end_index = (isize - 1) >> PAGE_SHIFT;
-	if (end_index > ractl->_max_index)
-		end_index = ractl->_max_index;
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
@@ -487,7 +485,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
-	pgoff_t limit;
+	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark;
 	unsigned int nofs;
 	int err = 0;
@@ -500,8 +498,6 @@ void page_cache_ra_order(struct readahea
 		goto fallback;
 	}
 
-	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
-	limit = min(limit, ractl->_max_index);
 	if (limit > index + ra->size - 1) {
 		limit = index + ra->size - 1;
 		mark = index + ra->size - ra->async_size;
_

Patches currently in -mm which might be from ljs@kernel.org are


