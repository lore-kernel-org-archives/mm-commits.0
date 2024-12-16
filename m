Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F0610F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327654; cv=none; b=RILEvur5F8006qImp9I5/zdysHAG3ftMg0Wy7J/fsBwTvmyOVKJ0X/zR5TMuC/7kDJm16p1IAbG8mxo/cNDKy1wp/SAXzMxIM5d0acDLUCxOs4540rWMUqt9KJkNLJ5u9XeU5eCOTo6+egKgHSBlZRzk1UQCWioLh3mFZKVVtP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327654; c=relaxed/simple;
	bh=/2iyWSucrK6UcZa8+8ddvdABpbl0sYw9xRBf5eMpSMI=;
	h=Date:To:From:Subject:Message-Id; b=dFRMNwQmRhXOJgxOYG8toa2lKq5rUNp54CvoZcGYtzOdk5+fKGiUo0g/ZWGHrD8HS6tHkRQbheZN9QjoNE6IMWlRqq7PbvG5UcHvF5t39wqV39nYS2UE8vIzhXfVSThg2R9y45jKFgLC0USXKCdclD4EWdOtaCpaDVpEw5PA2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZL/J9XAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZL/J9XAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DEDC4CED0;
	Mon, 16 Dec 2024 05:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327653;
	bh=/2iyWSucrK6UcZa8+8ddvdABpbl0sYw9xRBf5eMpSMI=;
	h=Date:To:From:Subject:From;
	b=ZL/J9XAHfRN3iY4D2FnkPY46T63OPs1GnD9r7mlE6Oi1gH4b8Cx8nScBq7503RGzB
	 GtNi5uaPn3e1ntzAWInF0TZQRmqe++vETU3F3Hd+F4+MihOxwg/zvCHr4V5rGtE3AE
	 kUnYu20LpTPlshI5VbyryHYPE16PLDGJYiqsJDTg=
Date: Sun, 15 Dec 2024 21:40:53 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054053.B6DEDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: pass mmap_folio around instead of mmap_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: pass mmap_folio around instead of mmap_page
Date: Thu, 5 Dec 2024 17:16:34 +0000

Saves a few hidden calls to compound_head() and accesses to page->mapping.

Link: https://lkml.kernel.org/r/20241205171653.3179945-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   37 ++++++++++++++++++-------------------
 fs/ocfs2/aops.h |    6 +++---
 fs/ocfs2/mmap.c |    2 +-
 3 files changed, 22 insertions(+), 23 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-pass-mmap_folio-around-instead-of-mmap_page
+++ a/fs/ocfs2/aops.c
@@ -1023,7 +1023,7 @@ static int ocfs2_grab_pages_for_write(st
 				      struct ocfs2_write_ctxt *wc,
 				      u32 cpos, loff_t user_pos,
 				      unsigned user_len, int new,
-				      struct page *mmap_page)
+				      struct folio *mmap_folio)
 {
 	int ret = 0, i;
 	unsigned long start, target_index, end_index, index;
@@ -1068,18 +1068,18 @@ static int ocfs2_grab_pages_for_write(st
 			 * and wants us to directly use the page
 			 * passed in.
 			 */
-			lock_page(mmap_page);
+			folio_lock(mmap_folio);
 
 			/* Exit and let the caller retry */
-			if (mmap_page->mapping != mapping) {
-				WARN_ON(mmap_page->mapping);
-				unlock_page(mmap_page);
+			if (mmap_folio->mapping != mapping) {
+				WARN_ON(mmap_folio->mapping);
+				folio_unlock(mmap_folio);
 				ret = -EAGAIN;
 				goto out;
 			}
 
-			get_page(mmap_page);
-			wc->w_pages[i] = mmap_page;
+			folio_get(mmap_folio);
+			wc->w_pages[i] = &mmap_folio->page;
 			wc->w_target_locked = true;
 		} else if (index >= target_index && index <= end_index &&
 			   wc->w_type == OCFS2_WRITE_DIRECT) {
@@ -1536,9 +1536,8 @@ int ocfs2_size_fits_inline_data(struct b
 }
 
 static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
-					  struct inode *inode, loff_t pos,
-					  unsigned len, struct page *mmap_page,
-					  struct ocfs2_write_ctxt *wc)
+		struct inode *inode, loff_t pos, size_t len,
+		struct folio *mmap_folio, struct ocfs2_write_ctxt *wc)
 {
 	int ret, written = 0;
 	loff_t end = pos + len;
@@ -1553,7 +1552,7 @@ static int ocfs2_try_to_write_inline_dat
 	 * Handle inodes which already have inline data 1st.
 	 */
 	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-		if (mmap_page == NULL &&
+		if (mmap_folio == NULL &&
 		    ocfs2_size_fits_inline_data(wc->w_di_bh, end))
 			goto do_inline_write;
 
@@ -1577,7 +1576,7 @@ static int ocfs2_try_to_write_inline_dat
 	 * Check whether the write can fit.
 	 */
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
-	if (mmap_page ||
+	if (mmap_folio ||
 	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
 		return 0;
 
@@ -1644,9 +1643,9 @@ static int ocfs2_zero_tail(struct inode
 }
 
 int ocfs2_write_begin_nolock(struct address_space *mapping,
-			     loff_t pos, unsigned len, ocfs2_write_type_t type,
-			     struct folio **foliop, void **fsdata,
-			     struct buffer_head *di_bh, struct page *mmap_page)
+		loff_t pos, unsigned len, ocfs2_write_type_t type,
+		struct folio **foliop, void **fsdata,
+		struct buffer_head *di_bh, struct folio *mmap_folio)
 {
 	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
@@ -1669,7 +1668,7 @@ try_again:
 
 	if (ocfs2_supports_inline_data(osb)) {
 		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
-						     mmap_page, wc);
+						     mmap_folio, wc);
 		if (ret == 1) {
 			ret = 0;
 			goto success;
@@ -1721,7 +1720,7 @@ try_again:
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			(long long)i_size_read(inode),
 			le32_to_cpu(di->i_clusters),
-			pos, len, type, mmap_page,
+			pos, len, type, mmap_folio,
 			clusters_to_alloc, extents_to_split);
 
 	/*
@@ -1797,7 +1796,7 @@ try_again:
 	 * extent.
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
-					 cluster_of_pages, mmap_page);
+					 cluster_of_pages, mmap_folio);
 	if (ret) {
 		/*
 		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
@@ -1848,7 +1847,7 @@ out:
 	 * to VM code.
 	 */
 	if (wc->w_target_locked)
-		unlock_page(mmap_page);
+		folio_unlock(mmap_folio);
 
 	ocfs2_free_write_ctxt(inode, wc);
 
--- a/fs/ocfs2/aops.h~ocfs2-pass-mmap_folio-around-instead-of-mmap_page
+++ a/fs/ocfs2/aops.h
@@ -37,9 +37,9 @@ typedef enum {
 } ocfs2_write_type_t;
 
 int ocfs2_write_begin_nolock(struct address_space *mapping,
-			     loff_t pos, unsigned len, ocfs2_write_type_t type,
-			     struct folio **foliop, void **fsdata,
-			     struct buffer_head *di_bh, struct page *mmap_page);
+		loff_t pos, unsigned len, ocfs2_write_type_t type,
+		struct folio **foliop, void **fsdata,
+		struct buffer_head *di_bh, struct folio *mmap_folio);
 
 int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 			   struct buffer_head *di_bh);
--- a/fs/ocfs2/mmap.c~ocfs2-pass-mmap_folio-around-instead-of-mmap_page
+++ a/fs/ocfs2/mmap.c
@@ -91,7 +91,7 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 		len = ((size - 1) & ~PAGE_MASK) + 1;
 
 	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
-				       &locked_folio, &fsdata, di_bh, &folio->page);
+				       &locked_folio, &fsdata, di_bh, folio);
 	if (err) {
 		if (err != -ENOSPC)
 			mlog_errno(err);
_

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-fix-accounting-with-i915.patch
mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch

