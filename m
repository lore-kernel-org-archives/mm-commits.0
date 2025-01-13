Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5025761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742218; cv=none; b=eiBhHvjGpvaMC+j0b3BbSHSrJk0Tj4Sp9lP2JRjJ2tCG8FQ8o0KWC7JYFQX0IBn+11uNCp8hNteuzbcnxCcuuHK0qxQV4eKaiL8QKnnFVnNh4Mc4RofIg8c10UYr4QkNAS9eZ5SKwXWL4bMlhC72zbSMoakiAeOCdZfRI0GlXD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742218; c=relaxed/simple;
	bh=Yk1NOE0A59GoCrfRngn1rV3fTZyXlCHTYjuTdpHAwnU=;
	h=Date:To:From:Subject:Message-Id; b=F66xYUUwXBivy9l5RaqPsAaczlY+Ft80bfehmM4HFBO1D2fHhCgSkQYmpXYSnAkdyswjTrCECEhWFmMmpx/Gbwqnm7WTdmHU5hgbs1WJKSXyg1KL6Qx9EYvm7zbGEEezHhToB/JuP7HXutjDdWY9tqIAHdCMQ5iBQJrIQ7plEtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dU6bWhsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dU6bWhsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF44BC4CED6;
	Mon, 13 Jan 2025 04:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742218;
	bh=Yk1NOE0A59GoCrfRngn1rV3fTZyXlCHTYjuTdpHAwnU=;
	h=Date:To:From:Subject:From;
	b=dU6bWhsJUyNXiAc1Ve4rpDabUCPVUF/oOZ4b6WZ4mecN4qxK0n/6czBcaTKAmaBEO
	 x+l38KHNil1lfO0fu9JuiaIAaUhSAwdSzEigvcThfpkl+/jacrKvmqjKZG8fi1pUft
	 K26INOSEyjmnog9NYqTr0RpUdTvGGatZMMYmUL6w=
Date: Sun, 12 Jan 2025 20:23:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch removed from -mm tree
Message-Id: <20250113042337.EF44BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_map_and_dirty_page()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_map_and_dirty_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


