Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457C1586CF
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742205; cv=none; b=JJTl1v+71qaWYPmDcktS+P/t9fP8y9vUojvDT3C73F+aUN5qDoRLTZTRrz6H+RfnYUlC9uLPjN5GoaPeEssbQPvox+sIAPDlPwrTxfMe+T4cVNE+HQqWvzFnpEY+5MYJhJTMkV/XoN6pt+eA/US3L+mhO0G6hErmf/Otvv5qI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742205; c=relaxed/simple;
	bh=zF2SRoErSeZ9wcegfsaxB5/fjw9mB8epk/yklia4vkg=;
	h=Date:To:From:Subject:Message-Id; b=liW4rOE4Ny1B8movaHHi9N4uaZcvXQUuJ634y/nFRLMweJfq3/wWVWBhSHLT6IFgKgLG1IvRXw6UbUk9gTauko4IS1YmfB4mIcdNsaYIxyt3D8Mf/rUePEu3IzIVk4pH+BtGEau6Iqm7AOsFYh4FrF6GE854hroAt8he3/LiXhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zDpIjsd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zDpIjsd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D567C4CED6;
	Mon, 13 Jan 2025 04:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742205;
	bh=zF2SRoErSeZ9wcegfsaxB5/fjw9mB8epk/yklia4vkg=;
	h=Date:To:From:Subject:From;
	b=zDpIjsd7FWVIQlnmGDgWEwAhorUUJSbhj+REZkYksdyW1a5JwgmFodIRipa3XUg4z
	 sC7JOWpnxlAw0SPgId5ODOkt5/XxNyF819MFXgNmYKjn5mMyCs0djdAJWFd3gEfNoe
	 PBVmyifQx4bAbGN9wT2lyk3gksCTycc7cfHsrNyE=
Date: Sun, 12 Jan 2025 20:23:25 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch removed from -mm tree
Message-Id: <20250113042325.8D567C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_page_mkwrite() to use a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-remove-pagetranstail.patch

