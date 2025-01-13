Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1822525761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742209; cv=none; b=WYndgbkUTErWXZT1cFHmuNcQDRgaiD7D3JU0DOibwOH+d5uiOUtoAD+6pjYlDBIo7uQ6P+v4sKedrhLAY4t5MVA4zJupSr0eH+vVy0Pfg0uWVy7StYHLX/BkSNuJqvFb0XTptqQTmOOvxWlnNC35oXY26vpBqV3oXLrRf0ByH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742209; c=relaxed/simple;
	bh=bmeDgW0xvVA/woH3pkBi0nwoD3lJGpGF0iKMQe3o8oQ=;
	h=Date:To:From:Subject:Message-Id; b=ZjmB847nE3scjLPpvO6ti59pf3GcIPzq7Ey4q5vdgS/D+UcM7e7KjjQqgd6Ypq8/mlr9y+LlzYZ76qQzRhrj6Y+66dgG8Ncb5r9LeALyFr6Q5AVHBWPm3OHkz8wq9A4cchKHY/Mg5n00xibvGjbP+opgUIJq8Mbd8wahiSC1sR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rt7KOZ9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rt7KOZ9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29E1C4CED6;
	Mon, 13 Jan 2025 04:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742209;
	bh=bmeDgW0xvVA/woH3pkBi0nwoD3lJGpGF0iKMQe3o8oQ=;
	h=Date:To:From:Subject:From;
	b=rt7KOZ9GMAIqFhjGh2zUd1VBFycZni2nHtdQ0fE1/zR4W0RZf7ignOqK7UsDTZ0xA
	 j3GhwfzsHQng1mTkuJ/2+0kuq3q80KokiJnlIWEQCCHqcviSPfdIuNvvyH075gRiyn
	 NTEAM8gGTSqTyl4ceIxXo1VFzpR95j4oQ+1Qvilw=
Date: Sun, 12 Jan 2025 20:23:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch removed from -mm tree
Message-Id: <20250113042328.E29E1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_write_begin_inline()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: use a folio in ocfs2_write_begin_inline()
Date: Thu, 5 Dec 2024 17:16:33 +0000

Retrieve a folio from the page cache instead of a page and use that
folio throught the function.  Saves a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20241205171653.3179945-6-willy@infradead.org
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

 fs/ocfs2/aops.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-a-folio-in-ocfs2_write_begin_inline
+++ a/fs/ocfs2/aops.c
@@ -1473,7 +1473,7 @@ static int ocfs2_write_begin_inline(stru
 {
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct page *page;
+	struct folio *folio;
 	handle_t *handle;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 
@@ -1484,19 +1484,20 @@ static int ocfs2_write_begin_inline(stru
 		goto out;
 	}
 
-	page = find_or_create_page(mapping, 0, GFP_NOFS);
-	if (!page) {
+	folio = __filemap_get_folio(mapping, 0,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_NOFS);
+	if (IS_ERR(folio)) {
 		ocfs2_commit_trans(osb, handle);
-		ret = -ENOMEM;
+		ret = PTR_ERR(folio);
 		mlog_errno(ret);
 		goto out;
 	}
 	/*
-	 * If we don't set w_num_pages then this page won't get unlocked
+	 * If we don't set w_num_pages then this folio won't get unlocked
 	 * and freed on cleanup of the write context.
 	 */
-	wc->w_target_folio = page_folio(page);
-	wc->w_pages[0] = page;
+	wc->w_target_folio = folio;
+	wc->w_pages[0] = &folio->page;
 	wc->w_num_pages = 1;
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
@@ -1511,8 +1512,8 @@ static int ocfs2_write_begin_inline(stru
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
 		ocfs2_set_inode_data_inline(inode, di);
 
-	if (!PageUptodate(page)) {
-		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
+	if (!folio_test_uptodate(folio)) {
+		ret = ocfs2_read_inline_data(inode, &folio->page, wc->w_di_bh);
 		if (ret) {
 			ocfs2_commit_trans(osb, handle);
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


