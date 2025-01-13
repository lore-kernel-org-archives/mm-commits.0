Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35EA1586FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742215; cv=none; b=Xn9BVhIayByhHJg2reg95gjm7uwDcgwpIcdICVYdZYBG7c6ltFzK7UcyjBMh/8I3Ji06Ad9stKrLsGPmMQqHv2J581oXwscteM+fwo3VBYZ5hzkysvHk6GY29Q4yTDtQA6OO78dssnu3MC6bghLwm3vL3Jkk1IhkhdmfWI4hJ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742215; c=relaxed/simple;
	bh=ZEsCe3qCquIAYW3Ghr8hrhKhPSSnl6cuwRucegtxpQs=;
	h=Date:To:From:Subject:Message-Id; b=t1cU9MMn4Sr3ErrXV6g1Nrlrp9u7KI/LMcilLJ+hMbXYbQfD15IO3hkJcjOaSTRxbSSqeDEB9B0ps8LLtkESMm07vKmOFmmFGc9G06Bqz5aL/k5MXuz/W6iHsxzF9OInRHHaYN5CsNQO8uL6xuVnb1/Pl+TJWoW3xhoGDHBOqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n43urSsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n43urSsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89BDC4CED6;
	Mon, 13 Jan 2025 04:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742215;
	bh=ZEsCe3qCquIAYW3Ghr8hrhKhPSSnl6cuwRucegtxpQs=;
	h=Date:To:From:Subject:From;
	b=n43urSsFV5/hCsGbuK8zUsgL4Y44L2BR7zYXR9xyoKY1gIzNaHdrCuScMEsvwE2a3
	 7oC6yHEMQYI4gJB11CAAUG+vbBuZDeKJ5pGlCYrTJYSNbmWrPACT/UMnJjkCZJ1m2R
	 SqJC0X7DNTgze1av1VIZy/gOWb2Ik1roeM6XlDSk=
Date: Sun, 12 Jan 2025 20:23:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch removed from -mm tree
Message-Id: <20250113042335.A89BDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_write_end_nolock()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_write_end_nolock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: use a folio in ocfs2_write_end_nolock()
Date: Thu, 5 Dec 2024 17:16:39 +0000

Remove an access to page->index.  Remove some PAGE_SIZE assumptions.

Link: https://lkml.kernel.org/r/20241205171653.3179945-12-willy@infradead.org
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

 fs/ocfs2/aops.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-a-folio-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.c
@@ -1952,17 +1952,16 @@ static void ocfs2_write_end_inline(struc
 	     le16_to_cpu(di->i_dyn_features));
 }
 
-int ocfs2_write_end_nolock(struct address_space *mapping,
-			   loff_t pos, unsigned len, unsigned copied, void *fsdata)
+int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
+		unsigned len, unsigned copied, void *fsdata)
 {
 	int i, ret;
-	unsigned from, to, start = pos & (PAGE_SIZE - 1);
+	size_t from, to, start = pos & (PAGE_SIZE - 1);
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_write_ctxt *wc = fsdata;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
 	handle_t *handle = wc->w_handle;
-	struct page *tmppage;
 
 	BUG_ON(!list_empty(&wc->w_unwritten_list));
 
@@ -1993,32 +1992,32 @@ int ocfs2_write_end_nolock(struct addres
 					       start+len);
 		else {
 			/*
-			 * When page is fully beyond new isize (data copy
-			 * failed), do not bother zeroing the page. Invalidate
+			 * When folio is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the folio. Invalidate
 			 * it instead so that writeback does not get confused
 			 * put page & buffer dirty bits into inconsistent
 			 * state.
 			 */
-			block_invalidate_folio(wc->w_target_folio,
-						0, PAGE_SIZE);
+			block_invalidate_folio(wc->w_target_folio, 0,
+					folio_size(wc->w_target_folio));
 		}
 	}
 	if (wc->w_target_folio)
 		flush_dcache_folio(wc->w_target_folio);
 
 	for (i = 0; i < wc->w_num_folios; i++) {
-		tmppage = &wc->w_folios[i]->page;
+		struct folio *folio = wc->w_folios[i];
 
-		/* This is the direct io target page. */
-		if (tmppage == NULL)
+		/* This is the direct io target folio */
+		if (folio == NULL)
 			continue;
 
-		if (tmppage == &wc->w_target_folio->page) {
+		if (folio == wc->w_target_folio) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
 
-			BUG_ON(from > PAGE_SIZE ||
-			       to > PAGE_SIZE ||
+			BUG_ON(from > folio_size(folio) ||
+			       to > folio_size(folio) ||
 			       to < from);
 		} else {
 			/*
@@ -2027,19 +2026,17 @@ int ocfs2_write_end_nolock(struct addres
 			 * to flush their entire range.
 			 */
 			from = 0;
-			to = PAGE_SIZE;
+			to = folio_size(folio);
 		}
 
-		if (page_has_buffers(tmppage)) {
+		if (folio_buffers(folio)) {
 			if (handle && ocfs2_should_order_data(inode)) {
-				loff_t start_byte =
-					((loff_t)tmppage->index << PAGE_SHIFT) +
-					from;
+				loff_t start_byte = folio_pos(folio) + from;
 				loff_t length = to - from;
 				ocfs2_jbd2_inode_add_write(handle, inode,
 							   start_byte, length);
 			}
-			block_commit_write(tmppage, from, to);
+			block_commit_write(&folio->page, from, to);
 		}
 	}
 
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


