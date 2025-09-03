Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD2134BD
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 00:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756859112; cv=none; b=NtzaSwYFZR+1zNo5di8Z6cKjpqybypgodjnbuxbkUFV/c5mY/s7lLp+RoCdmc9rmUum1t3gOMsPg5a8+Ngjh+7elKCuiZrutqNb66FQzz5bohDTpEduxGxCrh6Mr1i8OH9mUdiiKEpEciIT6OOpLueDYeebg8Mv3drj8KhtXS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756859112; c=relaxed/simple;
	bh=+MSRN2D3NjWzLGwq0iNg1rpuMhGw3zjQNK7x3kMaB/8=;
	h=Date:To:From:Subject:Message-Id; b=NWUcTteP+kCf+x/yDYzF9HR+imHrAPa0+UaIsGPa8a6F7lWELu6fvHtQWcgwzKvvh1OQ9HobBLn5E9Ozk3Vj0p1hTPVqMdbF9c0jBW/V0feS6VA1S02+aIYP+7AweofgRLNPWZ25kbkTo5e6ru5ROG5nAAgenw3Rcoaqd6R6H3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsvSHyLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsvSHyLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B7C4CEED;
	Wed,  3 Sep 2025 00:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756859112;
	bh=+MSRN2D3NjWzLGwq0iNg1rpuMhGw3zjQNK7x3kMaB/8=;
	h=Date:To:From:Subject:From;
	b=rsvSHyLhDJTVG/4klOGF/H8tL1HxBxPQLUDOeiXyNPyPdaEq4XV4Vqtv0U5Fkbz5K
	 3t9BdhQdnf5W2mVN+YXQJWCrmr9vzNlyKQBVaOJLJdurGnDQClLkk+JXD+gkJT85LF
	 bpsGPuvSpvRPszNzpx5G8bkrNVxk9hQAKpITS7ps=
Date: Tue, 02 Sep 2025 17:25:11 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-pagemap-related-test-getter-functions.patch added to mm-new branch
Message-Id: <20250903002511.F31B7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify pagemap related test/getter functions
has been added to the -mm mm-new branch.  Its filename is
     mm-constify-pagemap-related-test-getter-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-pagemap-related-test-getter-functions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Max Kellermann <max.kellermann@ionos.com>
Subject: mm: constify pagemap related test/getter functions
Date: Mon, 1 Sep 2025 22:50:11 +0200

For improved const-correctness.

We select certain test functions which either invoke each other, functions
that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which provides a
basis for further const-ification further up the call stack.

Link: https://lkml.kernel.org/r/20250901205021.3573313-3-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Nysal Jan K.A" <nysal@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   57 +++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

--- a/include/linux/pagemap.h~mm-constify-pagemap-related-test-getter-functions
+++ a/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int inode_drain_writes(str
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
-static inline bool mapping_empty(struct address_space *mapping)
+static inline bool mapping_empty(const struct address_space *mapping)
 {
 	return xa_empty(&mapping->i_pages);
 }
@@ -166,7 +166,7 @@ static inline bool mapping_empty(struct
  * refcount and the referenced bit, which will be elevated or set in
  * the process of adding new cache pages to an inode.
  */
-static inline bool mapping_shrinkable(struct address_space *mapping)
+static inline bool mapping_shrinkable(const struct address_space *mapping)
 {
 	void *head;
 
@@ -267,7 +267,7 @@ static inline void mapping_clear_unevict
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline bool mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(const struct address_space *mapping)
 {
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
@@ -277,7 +277,7 @@ static inline void mapping_set_exiting(s
 	set_bit(AS_EXITING, &mapping->flags);
 }
 
-static inline int mapping_exiting(struct address_space *mapping)
+static inline int mapping_exiting(const struct address_space *mapping)
 {
 	return test_bit(AS_EXITING, &mapping->flags);
 }
@@ -287,7 +287,7 @@ static inline void mapping_set_no_writeb
 	set_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
-static inline int mapping_use_writeback_tags(struct address_space *mapping)
+static inline int mapping_use_writeback_tags(const struct address_space *mapping)
 {
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
@@ -333,7 +333,7 @@ static inline void mapping_set_inaccessi
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
-static inline bool mapping_inaccessible(struct address_space *mapping)
+static inline bool mapping_inaccessible(const struct address_space *mapping)
 {
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
@@ -343,18 +343,18 @@ static inline void mapping_set_writeback
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
+static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct address_space *mapping)
 {
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
-static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
+static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
 }
 
 /* Restricts the given gfp_mask to what the mapping allows. */
-static inline gfp_t mapping_gfp_constraint(struct address_space *mapping,
+static inline gfp_t mapping_gfp_constraint(const struct address_space *mapping,
 		gfp_t gfp_mask)
 {
 	return mapping_gfp_mask(mapping) & gfp_mask;
@@ -477,13 +477,13 @@ mapping_min_folio_order(const struct add
 }
 
 static inline unsigned long
-mapping_min_folio_nrpages(struct address_space *mapping)
+mapping_min_folio_nrpages(const struct address_space *mapping)
 {
 	return 1UL << mapping_min_folio_order(mapping);
 }
 
 static inline unsigned long
-mapping_min_folio_nrbytes(struct address_space *mapping)
+mapping_min_folio_nrbytes(const struct address_space *mapping)
 {
 	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
 }
@@ -497,7 +497,7 @@ mapping_min_folio_nrbytes(struct address
  * new folio to the page cache and need to know what index to give it,
  * call this function.
  */
-static inline pgoff_t mapping_align_index(struct address_space *mapping,
+static inline pgoff_t mapping_align_index(const struct address_space *mapping,
 					  pgoff_t index)
 {
 	return round_down(index, mapping_min_folio_nrpages(mapping));
@@ -507,7 +507,7 @@ static inline pgoff_t mapping_align_inde
  * Large folio support currently depends on THP.  These dependencies are
  * being worked on but are not yet fixed.
  */
-static inline bool mapping_large_folio_support(struct address_space *mapping)
+static inline bool mapping_large_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
@@ -522,7 +522,7 @@ static inline size_t mapping_max_folio_s
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(struct address_space *mapping)
+static inline int filemap_nr_thps(const struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
 	return atomic_read(&mapping->nr_thps);
@@ -936,7 +936,7 @@ static inline struct page *grab_cache_pa
  *
  * Return: The index of the folio which follows this folio in the file.
  */
-static inline pgoff_t folio_next_index(struct folio *folio)
+static inline pgoff_t folio_next_index(const struct folio *folio)
 {
 	return folio->index + folio_nr_pages(folio);
 }
@@ -965,7 +965,7 @@ static inline struct page *folio_file_pa
  * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
-static inline bool folio_contains(struct folio *folio, pgoff_t index)
+static inline bool folio_contains(const struct folio *folio, pgoff_t index)
 {
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	return index - folio->index < folio_nr_pages(folio);
@@ -1042,13 +1042,13 @@ static inline loff_t page_offset(struct
 /*
  * Get the offset in PAGE_SIZE (even for hugetlb folios).
  */
-static inline pgoff_t folio_pgoff(struct folio *folio)
+static inline pgoff_t folio_pgoff(const struct folio *folio)
 {
 	return folio->index;
 }
 
-static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
-					unsigned long address)
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
+					const unsigned long address)
 {
 	pgoff_t pgoff;
 	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
@@ -1468,7 +1468,7 @@ static inline unsigned int __readahead_b
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
-static inline loff_t readahead_pos(struct readahead_control *rac)
+static inline loff_t readahead_pos(const struct readahead_control *rac)
 {
 	return (loff_t)rac->_index * PAGE_SIZE;
 }
@@ -1477,7 +1477,7 @@ static inline loff_t readahead_pos(struc
  * readahead_length - The number of bytes in this readahead request.
  * @rac: The readahead request.
  */
-static inline size_t readahead_length(struct readahead_control *rac)
+static inline size_t readahead_length(const struct readahead_control *rac)
 {
 	return rac->_nr_pages * PAGE_SIZE;
 }
@@ -1486,7 +1486,7 @@ static inline size_t readahead_length(st
  * readahead_index - The index of the first page in this readahead request.
  * @rac: The readahead request.
  */
-static inline pgoff_t readahead_index(struct readahead_control *rac)
+static inline pgoff_t readahead_index(const struct readahead_control *rac)
 {
 	return rac->_index;
 }
@@ -1495,7 +1495,7 @@ static inline pgoff_t readahead_index(st
  * readahead_count - The number of pages in this readahead request.
  * @rac: The readahead request.
  */
-static inline unsigned int readahead_count(struct readahead_control *rac)
+static inline unsigned int readahead_count(const struct readahead_control *rac)
 {
 	return rac->_nr_pages;
 }
@@ -1504,12 +1504,12 @@ static inline unsigned int readahead_cou
  * readahead_batch_length - The number of bytes in the current batch.
  * @rac: The readahead request.
  */
-static inline size_t readahead_batch_length(struct readahead_control *rac)
+static inline size_t readahead_batch_length(const struct readahead_control *rac)
 {
 	return rac->_batch_count * PAGE_SIZE;
 }
 
-static inline unsigned long dir_pages(struct inode *inode)
+static inline unsigned long dir_pages(const struct inode *inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
 			       PAGE_SHIFT;
@@ -1523,8 +1523,8 @@ static inline unsigned long dir_pages(st
  * Return: the number of bytes in the folio up to EOF,
  * or -EFAULT if the folio was truncated.
  */
-static inline ssize_t folio_mkwrite_check_truncate(struct folio *folio,
-					      struct inode *inode)
+static inline ssize_t folio_mkwrite_check_truncate(const struct folio *folio,
+						   const struct inode *inode)
 {
 	loff_t size = i_size_read(inode);
 	pgoff_t index = size >> PAGE_SHIFT;
@@ -1555,7 +1555,8 @@ static inline ssize_t folio_mkwrite_chec
  * Return: The number of filesystem blocks covered by this folio.
  */
 static inline
-unsigned int i_blocks_per_folio(struct inode *inode, struct folio *folio)
+unsigned int i_blocks_per_folio(const struct inode *inode,
+				const struct folio *folio)
 {
 	return folio_size(folio) >> inode->i_blkbits;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are

pagevech-add-const-to-pointer-parameters-of-getter-functions.patch
huge_mmh-disallow-is_huge_zero_folionull.patch
mm-constify-shmem-related-test-functions-for-improved-const-correctness.patch
mm-constify-pagemap-related-test-getter-functions.patch
mm-constify-zone-related-test-getter-functions.patch
fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch
mm-constify-process_shares_mm-for-improved-const-correctness.patch
mm-s390-constify-mapping-related-test-getter-functions.patch
parisc-constify-mmap_upper_limit-parameter.patch
mm-constify-arch_pick_mmap_layout-for-improved-const-correctness.patch
mm-constify-ptdesc_pmd_pts_count-and-folio_get_private.patch
mm-constify-various-inline-functions-for-improved-const-correctness.patch
mm-constify-assert-test-functions-in-mmh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness.patch

