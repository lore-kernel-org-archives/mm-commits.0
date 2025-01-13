Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B500E1586FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742214; cv=none; b=kzvSRyo8ER6NMuZTDHBHdsjsIkgacj+tnRssNniGDuj7lgRyGhDDZVr3SgA3Xw3t5dTc5wpDeBobCdjIIXD7pxf+OoHjU3BS1hgfbMPWVBDUlD2/A1+SF0lEz7Or5pLNJ7lbromedrqZF8ZPJDk6o1a5XpYtIfmdmYTL0KNeJHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742214; c=relaxed/simple;
	bh=W4wJUy3pSPOkZ2OILRr4I9F9X7YosUD1QHn89frJ7So=;
	h=Date:To:From:Subject:Message-Id; b=VcRr/GfJeirSA8MfWjECCZ30nXyT+tItM/qpg+APiJ7SaLxOPPHcTfhuOp+NxottFcyQ67tNJ19CdJGp77mtMn0B28gzbGpq6jZ8FMOWZ4MaZOVcyKz28srdzE9dJxAcc2sqMq0HuU+ekoc2TB/W3Vox34nI4JiZZ2qtH9N+KMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YL61vm5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YL61vm5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8DCC4CED6;
	Mon, 13 Jan 2025 04:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742214;
	bh=W4wJUy3pSPOkZ2OILRr4I9F9X7YosUD1QHn89frJ7So=;
	h=Date:To:From:Subject:From;
	b=YL61vm5nzdLlVognpkgGufRuQzrOQYuVqUEfQzqqbJzwJpMX6JOgNiYpg9rNQ+xdP
	 IkWJ6k9qBAtCGzYXEtuw96sET8+roPHE3XWoFvDKK+cNVlk8JVDKxNuiJmuhaiKBtW
	 fGRHG2uIg6GiUk/LnLEjfCqir1o3v8enzJPa8Cy0=
Date: Sun, 12 Jan 2025 20:23:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch removed from -mm tree
Message-Id: <20250113042334.8B8DCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_write_failure() to use a folio
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: convert ocfs2_write_failure() to use a folio
Date: Thu, 5 Dec 2024 17:16:38 +0000

Remove the folio->page conversion and just use the folio.

Link: https://lkml.kernel.org/r/20241205171653.3179945-11-willy@infradead.org
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

 fs/ocfs2/aops.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_write_failure-to-use-a-folio
+++ a/fs/ocfs2/aops.c
@@ -930,20 +930,19 @@ static void ocfs2_write_failure(struct i
 	int i;
 	unsigned from = user_pos & (PAGE_SIZE - 1),
 		to = user_pos + user_len;
-	struct page *tmppage;
 
 	if (wc->w_target_folio)
 		ocfs2_zero_new_buffers(wc->w_target_folio, from, to);
 
 	for (i = 0; i < wc->w_num_folios; i++) {
-		tmppage = &wc->w_folios[i]->page;
+		struct folio *folio = wc->w_folios[i];
 
-		if (tmppage && page_has_buffers(tmppage)) {
+		if (folio && folio_buffers(folio)) {
 			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_inode_add_write(wc->w_handle, inode,
 							   user_pos, user_len);
 
-			block_commit_write(tmppage, from, to);
+			block_commit_write(&folio->page, from, to);
 		}
 	}
 }
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


