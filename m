Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2225761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742211; cv=none; b=s6xUIm2N9Pb5PYJVEgtlhKfCjGULAA/nO0D6ktPZoaV3ZlxfYvtPHc9W+iMJz64zkl1PODNKkqS7X1Qw1ZFPXWAMsAIcjfMgljQ4FaOJxUrDNmGGgule6SQNJw9D4ntWXlKyHlts7urNaGyClklqILxsFe8DTAuUInAs1z9BSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742211; c=relaxed/simple;
	bh=zCgNvlejarYNh5/4Zf18tvR5vbb+MqLEPN5OHlqYujA=;
	h=Date:To:From:Subject:Message-Id; b=G1f+ZQ3iSikx48CGBnlCo0i+yvtyMpZ24XxaHCZm/kOGqhD84xm6nhWLNWm/ZDFDWlpe2i1NeOLeauYJNNN8VAt0XbQ+m7tIS5ZUOYdeNSl8YByRu/NXpxyE4BW0Dms4VLkrRzUwTvdoMlvmraFCs9Iql77vCMwbzFNOQL1CsXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u7WSlAg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u7WSlAg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34635C4CED6;
	Mon, 13 Jan 2025 04:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742211;
	bh=zCgNvlejarYNh5/4Zf18tvR5vbb+MqLEPN5OHlqYujA=;
	h=Date:To:From:Subject:From;
	b=u7WSlAg4sgC8KQBl9Jpyyp32H9vrIZKLEAT+wKX1i8nvXrSIjFxLMeIUo6Cna4U3z
	 lXhyjTfGWEWB5ohA2fqD/bMfAZa5WmFJVNRowssVnfRWFT2GR5indGp4tRdciUSU/j
	 F2lUhIfxxZnNAektD0WXKPcQpPEvAagf50EfIgyw=
Date: Sun, 12 Jan 2025 20:23:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250113042331.34635C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_readpage_inline() to take a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_readpage_inline-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


