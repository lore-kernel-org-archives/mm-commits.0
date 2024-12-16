Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E40210F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327669; cv=none; b=ftycR8kI2k0ultICB4MmprdoDaCcpc1F0Q+cABnYfiBwZn1/NCnfEOo+DQts6vmALTuMdGZvEPTWCHx6iWv/Lzmb1ujIuxkMtWrqnrMyGatIvANW5UdxgWDSxltLNK/x2mv4okBwTCIkJJ583zCw+IlN1ebW8MEWYNxbF2c50KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327669; c=relaxed/simple;
	bh=DlhaKZ0wS/OBiXtgFsfaflPWHQX1EYu4W4uI3/iTHlw=;
	h=Date:To:From:Subject:Message-Id; b=jXFwbUOYM0a9wFp/XK6Yw/nrG2k2WnD4RRBB91DarigUh6xGBs8d+9Vzt6+8wSt0si6/74hXyMKNvpD5RfokHRAx7SnrUKxuKO6uLgIRLoG4e8goLkOPO+r8DXYdLBtOEWQnLW+u5FFqdcPUsNvU0T/8qAhVlu4b/FdYvbmonsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=05GVl8cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="05GVl8cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734E9C4CED0;
	Mon, 16 Dec 2024 05:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327669;
	bh=DlhaKZ0wS/OBiXtgFsfaflPWHQX1EYu4W4uI3/iTHlw=;
	h=Date:To:From:Subject:From;
	b=05GVl8clnROxuA3VuHIgIIYilEBilYcBZg5QWL5ZGmrrd0LsP9vbFdmOCH9O+nfpd
	 64q8G4Kl4a3dQNJSShrgb3yMeLX/eypACx421hu8O9fv/q3BGZZbdAZkjl4H/bB2w6
	 CXISNRg6+/VUX32k00qsY8TYVQozp2B2r3BjnO/Y=
Date: Sun, 15 Dec 2024 21:41:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054109.734E9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_map_and_dirty_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch

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
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: use a folio in ocfs2_map_and_dirty_page()
Date: Thu, 5 Dec 2024 17:16:41 +0000

Convert the incoming page to a folio and use it throughout the function. 
Removes a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-14-willy@infradead.org
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page
+++ a/fs/ocfs2/alloc.c
@@ -6812,8 +6812,9 @@ void ocfs2_map_and_dirty_page(struct ino
 			      unsigned int from, unsigned int to,
 			      struct page *page, int zero, u64 *phys)
 {
+	struct folio *folio = page_folio(page);
 	int ret, partial = 0;
-	loff_t start_byte = ((loff_t)page->index << PAGE_SHIFT) + from;
+	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
 
 	ret = ocfs2_map_page_blocks(page, phys, inode, from, to, 0);
@@ -6821,14 +6822,14 @@ void ocfs2_map_and_dirty_page(struct ino
 		mlog_errno(ret);
 
 	if (zero)
-		zero_user_segment(page, from, to);
+		folio_zero_segment(folio, from, to);
 
 	/*
 	 * Need to set the buffers we zero'd into uptodate
 	 * here if they aren't - ocfs2_map_page_blocks()
 	 * might've skipped some
 	 */
-	ret = walk_page_buffers(handle, page_buffers(page),
+	ret = walk_page_buffers(handle, folio_buffers(folio),
 				from, to, &partial,
 				ocfs2_zero_func);
 	if (ret < 0)
@@ -6841,9 +6842,9 @@ void ocfs2_map_and_dirty_page(struct ino
 	}
 
 	if (!partial)
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 }
 
 static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are

ocfs2-convert-w_target_page-to-w_target_folio.patch
ocfs2-use-a-folio-in-ocfs2_zero_new_buffers.patch
ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch
ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch
ocfs2-convert-ocfs2_inode_lock_with_page-to-ocfs2_inode_lock_with_folio.patch
ocfs2-convert-w_pages-to-w_folios.patch
ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch
ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch
ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch
ocfs2-convert-ocfs2_map_page_blocks-to-ocfs2_map_folio_blocks.patch
ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch
ocfs2-use-an-array-of-folios-instead-of-an-array-of-pages.patch
ocfs2-convert-ocfs2_duplicate_clusters_by_page-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_and_dirty_page-to-ocfs2_map_and_dirty_folio.patch
ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch
ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

