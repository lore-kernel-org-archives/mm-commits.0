Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FA1C3F0E
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327688; cv=none; b=LICMOFnKewnqT2vkTsxCo3av984E6FzwofgFGtw7srOltDR8s4bMwzEkk+4e54KDEpLXfCdqvI/shd2X0GLEIth5U5A57CSZj7oT93L8L/6IZGrbvLBgb8acPQPz3jHJEhSuvTkzG4Y4SsDNckCp5ONGto2zdPTj812JB7IZDjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327688; c=relaxed/simple;
	bh=zZj7gf4zGAnmnhA4TNumUuOAE/s9zNGkZXn9NOB8OSg=;
	h=Date:To:From:Subject:Message-Id; b=f5jAiva3fpvLmBoCS9zDYLu6VHf++dOet/Y3KZeDDWp8rNAF4FXTnsNQXGPI2Ie8vOTxJx3NcpqABSDzIRfLpLm7q14Z0SfGwxU0GNKT5KBlEVfaGNnyrvTmvklhmZbxMWdKGb3w3KdWHw5wz3MM/80W/DHKRg7F3mMRXY1ha1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gycZuw8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gycZuw8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CD8C4CED0;
	Mon, 16 Dec 2024 05:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327688;
	bh=zZj7gf4zGAnmnhA4TNumUuOAE/s9zNGkZXn9NOB8OSg=;
	h=Date:To:From:Subject:From;
	b=gycZuw8iQz6FP7qNUaHavnDfig52JhLw4VJEdaaP2nu+ZeoXAKE1NfBBTkSz/yH6r
	 S+Rw9ze92Bml7fdvIBGDicbmkwUxHGmpfkfta2s4m6ZggbWLb0BgBWhj/dX5sQpRUF
	 GnG2LXCzPzk6fKdkdjH/9lzW2ErgM/M3iEOkmjUM=
Date: Sun, 15 Dec 2024 21:41:27 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054128.68CD8C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove ocfs2_start_walk_page_trans() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch

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
Subject: ocfs2: remove ocfs2_start_walk_page_trans() prototype
Date: Thu, 5 Dec 2024 17:16:49 +0000

This function no longer exists.

Link: https://lkml.kernel.org/r/20241205171653.3179945-22-willy@infradead.org
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

 fs/ocfs2/aops.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/ocfs2/aops.h~ocfs2-remove-ocfs2_start_walk_page_trans-prototype
+++ a/fs/ocfs2/aops.h
@@ -8,11 +8,6 @@
 
 #include <linux/fs.h>
 
-handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
-							 struct page *page,
-							 unsigned from,
-							 unsigned to);
-
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
 			  unsigned int to, int new);
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

