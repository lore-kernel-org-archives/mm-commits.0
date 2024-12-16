Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7FB1C3F34
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327686; cv=none; b=ivjyTbFKVk6qelllMY3eLuzRp/TMPkGp64zPDsy/4SkoOv5OHG+62i/qCGn5qz9dikluTJYafoo6NVX+eyS0IrnQuGxZ0HjDQrY39fA+HiNIlwZ0HjB4akPBBztELjr4c0tgNRP+R5Ok5P+O2rNs6J6KkIuWUzA9SeuDckj+GWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327686; c=relaxed/simple;
	bh=qM+MJPwCvjWPPN5LO29vMiRxmGGaLa1Cpw4kbbU8jM4=;
	h=Date:To:From:Subject:Message-Id; b=bjj+Xzhx8EU+NsWtqAvwdWnab+u1yj4a3dbvclxSkGeu9Gw9ndWhI/PTfyDauWtBxnV1qqNND7OI1tGT4O8zWGHwquuwVRlIztix+TlOecfSleJ54J3jtJQILu9a7AA2FxWEF2utxVKDBVZBHalFV/Oam8J8TTzFxioxv19eu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BfZypQaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfZypQaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDF4C4CED0;
	Mon, 16 Dec 2024 05:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327686;
	bh=qM+MJPwCvjWPPN5LO29vMiRxmGGaLa1Cpw4kbbU8jM4=;
	h=Date:To:From:Subject:From;
	b=BfZypQaJrlGRG+nfCfwB7R3A+uha7r9kZuKjfndstH4t/CYQmgbGE6Mp800yYQ4qN
	 6MDnPWJeafF1PIP+dYISDJxn/wiyMwR4CyoRTxuvM0Fa5XGdme1BuQ+ohwS4sLBj7g
	 F3YtAPZpiJ/cuikJKSEJ4cTXg3ORcAWd5uGZB8Kw=
Date: Sun, 15 Dec 2024 21:41:25 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054126.7FDF4C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_fast_symlink_read_folio()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch

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
Subject: ocfs2: use a folio in ocfs2_fast_symlink_read_folio()
Date: Thu, 5 Dec 2024 17:16:48 +0000

Use folio_end_read() instead of SetPageUptodate() and unlock_page().  Use
memcpy_to_folio() instead of open-coding a kmap_atomic() sequence.

Link: https://lkml.kernel.org/r/20241205171653.3179945-21-willy@infradead.org
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

 fs/ocfs2/symlink.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/fs/ocfs2/symlink.c~ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio
+++ a/fs/ocfs2/symlink.c
@@ -54,13 +54,11 @@
 
 static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct buffer_head *bh = NULL;
 	int status = ocfs2_read_inode_block(inode, &bh);
 	struct ocfs2_dinode *fe;
 	const char *link;
-	void *kaddr;
 	size_t len;
 
 	if (status < 0) {
@@ -72,12 +70,9 @@ static int ocfs2_fast_symlink_read_folio
 	link = (char *) fe->id2.i_symlink;
 	/* will be less than a page size */
 	len = strnlen(link, ocfs2_fast_symlink_chars(inode->i_sb));
-	kaddr = kmap_atomic(page);
-	memcpy(kaddr, link, len + 1);
-	kunmap_atomic(kaddr);
-	SetPageUptodate(page);
+	memcpy_to_folio(folio, 0, link, len + 1);
 out:
-	unlock_page(page);
+	folio_end_read(folio, status == 0);
 	brelse(bh);
 	return status;
 }
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

