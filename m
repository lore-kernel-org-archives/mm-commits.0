Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091F810F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327657; cv=none; b=L4bxZq+gW5sU24L0Azy6rTg/MrUOqi7fvIUGy8UsZVXrIVhrnv8fsRk+Xszp1Uwy4CtxCe6LhPfX89pAijEORHs5NxhGgMEFi8AoqhBbkfsmfkPbBTmbofmkgoA/g6tvho7wqeilKrk2J8xus6pPnQv9iEGkRC/TRBgnv23leGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327657; c=relaxed/simple;
	bh=H5TjvsafjC5Z5XPky1ZOL6C8ai/0cX+lDAzMMmFcDFU=;
	h=Date:To:From:Subject:Message-Id; b=tjrsGOURn1A7lRBO/XmCDTAO4/NNn5VXQ5xd7wR9CqR6FbsX6M1eaYZE5VMKMYjkfm7ctyzDBaFHd1GvCdl/PsBwbFQG4o4B++3f1t/H2a8eUU8/wL5y6G0ZSYKS0upumWW00bTHjOQy99QB46+vjNDKzxVfV+Dkci5LjLis6yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eb4k2Jr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eb4k2Jr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75346C4CEDD;
	Mon, 16 Dec 2024 05:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327656;
	bh=H5TjvsafjC5Z5XPky1ZOL6C8ai/0cX+lDAzMMmFcDFU=;
	h=Date:To:From:Subject:From;
	b=eb4k2Jr3MOPOPTU5R8c4i3rHbfJGA9+ByxLT89wfekuSescBKggTC3OLsDFfxnqZD
	 AlWOXjg15vaCBinhgq/IP61DqRgKSvZl1mju2DMyWuKxurUWLAXrDl6dAypF1H2izn
	 FJ/rTmSjDR9kqkIl87Lpb2hEqXNdRZbaLEQeN3b8=
Date: Sun, 15 Dec 2024 21:40:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054056.75346C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_readpage_inline() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch

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
Subject: ocfs2: convert ocfs2_readpage_inline() to take a folio
Date: Thu, 5 Dec 2024 17:16:35 +0000

Save a couple of calls to compound_head() by using a folio throughout this
function.

Link: https://lkml.kernel.org/r/20241205171653.3179945-8-willy@infradead.org
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

 fs/ocfs2/aops.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio
+++ a/fs/ocfs2/aops.c
@@ -252,12 +252,12 @@ int ocfs2_read_inline_data(struct inode
 	return 0;
 }
 
-static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
+static int ocfs2_readpage_inline(struct inode *inode, struct folio *folio)
 {
 	int ret;
 	struct buffer_head *di_bh = NULL;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_inode_block(inode, &di_bh);
@@ -266,9 +266,9 @@ static int ocfs2_readpage_inline(struct
 		goto out;
 	}
 
-	ret = ocfs2_read_inline_data(inode, page, di_bh);
+	ret = ocfs2_read_inline_data(inode, &folio->page, di_bh);
 out:
-	unlock_page(page);
+	folio_unlock(folio);
 
 	brelse(di_bh);
 	return ret;
@@ -322,7 +322,7 @@ static int ocfs2_read_folio(struct file
 	}
 
 	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		ret = ocfs2_readpage_inline(inode, &folio->page);
+		ret = ocfs2_readpage_inline(inode, folio);
 	else
 		ret = block_read_full_folio(folio, ocfs2_get_block);
 	unlock = 0;
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

