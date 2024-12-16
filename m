Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2145810F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327646; cv=none; b=COKd2575DCSv6q2fddwYXyJWVFAIEZcortnqqg5aBbjRZkFN5MUjF7k12K5K9jSEgP8E8D9U2I7V/G0U8trOhz+Q7bPCJAUJp3/Nr4ArPvfXwbHgcgtGc9U86iojcyFewUg6gtMJNi2Lbc7qbSgSnrUjozf3BIuPayR0XuDeHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327646; c=relaxed/simple;
	bh=+8rjgLpF1X6Teby1a5qcBTIT6cakGi3qgvypalqk+jQ=;
	h=Date:To:From:Subject:Message-Id; b=fvsI52R+oBgZqxGoTJW8JIEISNlVmFXg7+oMomYZEFQpwx80VxXnX36WXbO0crCAT1+c5kIJqd6YFnjU8gbo4eY2HvUKLDFmF+CJ5qQGpweb5aU/UdF7ODJrkMPgOUpUYgz8Q3lFvA8SR6iESQMPLnIZbxKmYiXfVXKQubjE5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uX+cQKmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uX+cQKmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B35BC4CED7;
	Mon, 16 Dec 2024 05:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327645;
	bh=+8rjgLpF1X6Teby1a5qcBTIT6cakGi3qgvypalqk+jQ=;
	h=Date:To:From:Subject:From;
	b=uX+cQKmF4I8MQrQVHpsiR5NriQ3dhm0FLN3YL9w9nPgHx4xSZAvZ+x4+PKEncWIzP
	 /bwBTCr0bGVHGAsxcqxKEVZ7ZpEi4f/67nSL0rltqSkqlitXPz/bIysCWViQeDY8ht
	 FoKWDWGRwkMkdAvw8y04F5mGXrf9R6XDOuAT72E8=
Date: Sun, 15 Dec 2024 21:40:45 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054045.9B35BC4CED7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_page_mkwrite() to use a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch

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
Subject: ocfs2: convert ocfs2_page_mkwrite() to use a folio
Date: Thu, 5 Dec 2024 17:16:30 +0000

Pass the folio into __ocfs2_page_mkwrite() and use it throughout.  Does
not attempt to support large folios.

Link: https://lkml.kernel.org/r/20241205171653.3179945-3-willy@infradead.org
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

 fs/ocfs2/mmap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/mmap.c~ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio
+++ a/fs/ocfs2/mmap.c
@@ -44,13 +44,13 @@ static vm_fault_t ocfs2_fault(struct vm_
 }
 
 static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
-			struct buffer_head *di_bh, struct page *page)
+			struct buffer_head *di_bh, struct folio *folio)
 {
 	int err;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
-	loff_t pos = page_offset(page);
+	loff_t pos = folio_pos(folio);
 	unsigned int len = PAGE_SIZE;
 	pgoff_t last_index;
 	struct folio *locked_folio = NULL;
@@ -72,9 +72,9 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 	 *
 	 * Let VM retry with these cases.
 	 */
-	if ((page->mapping != inode->i_mapping) ||
-	    (!PageUptodate(page)) ||
-	    (page_offset(page) >= size))
+	if ((folio->mapping != inode->i_mapping) ||
+	    !folio_test_uptodate(folio) ||
+	    (pos >= size))
 		goto out;
 
 	/*
@@ -87,11 +87,11 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 	 * worry about ocfs2_write_begin() skipping some buffer reads
 	 * because the "write" would invalidate their data.
 	 */
-	if (page->index == last_index)
+	if (folio->index == last_index)
 		len = ((size - 1) & ~PAGE_MASK) + 1;
 
 	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
-				       &locked_folio, &fsdata, di_bh, page);
+				       &locked_folio, &fsdata, di_bh, &folio->page);
 	if (err) {
 		if (err != -ENOSPC)
 			mlog_errno(err);
@@ -112,7 +112,7 @@ out:
 
 static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct buffer_head *di_bh = NULL;
 	sigset_t oldset;
@@ -141,7 +141,7 @@ static vm_fault_t ocfs2_page_mkwrite(str
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, page);
+	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
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

