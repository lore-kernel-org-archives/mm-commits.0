Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74B25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742226; cv=none; b=muayi1Uiak6IkUGFBrlEAdA8urhj1lC6mGo1ew7p5w1m+l6KHvNkrFKfRGkFAidgVFBlBkG3SwSXFlRL+1OPzNYgSL5lDhf6+yMT08E5f+2AgsY11di0FRwacC1PNjIoZxNCwri499FEvoGJz3IY83bOTjxg+r0tNncTCMAdLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742226; c=relaxed/simple;
	bh=eo95G8v3nLj83KO1pjrFm8Wu1Px+jpJ0b1/ZAVGPFpg=;
	h=Date:To:From:Subject:Message-Id; b=AVqlecOOzNB3CNYC+vyUG7m4RcB7IhGLiZqtyYjzIm5APlciomBQSEq24y7Smft7m220OL1JyMuecb5qISld+I1u9QCtdH72Fdt67/6KDcHqEUj6spGvv+NWx0TTd/jvwOaqBzdGZHz0KvVBUgEw04vwWIGIUmIL4eMXE4KQRfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKv9yF4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKv9yF4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5274C4CED6;
	Mon, 13 Jan 2025 04:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742225;
	bh=eo95G8v3nLj83KO1pjrFm8Wu1Px+jpJ0b1/ZAVGPFpg=;
	h=Date:To:From:Subject:From;
	b=VKv9yF4vnUzB9WNf/oEP6y0Cl0X867iKzUwrx4Z7DzNlTqmmjDO+bDiHPdEjh++CO
	 nUhPfA8dSVhB46BkVFohK3wLEt4wLmtnvvyHPkoNQnVyCmIABicV1DoC4Xwte1qO+K
	 o8OZ5A0rAvjMeMiO23yl0ogg/1J5JlpUgSBZLC8M=
Date: Sun, 12 Jan 2025 20:23:45 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch removed from -mm tree
Message-Id: <20250113042345.C5274C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_fast_symlink_read_folio()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

