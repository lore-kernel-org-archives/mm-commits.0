Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024BF10F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327652; cv=none; b=jr9WKAyukshYqbz6Uxg0h1iSq6K8OMNPbXEHByHQHBD3v0i6nUeMqWOzcVgvjWe6OEZ4+7sgPd5iNC1Y2L+KEV3DYFK9dRZmxUtqSqYe8VqPvmyw05JmXBDHS+LTuly987Rg6KUDr8uGI1LE7ISZwrMrfjfs89rOFnnotWD8s+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327652; c=relaxed/simple;
	bh=lE8tNZdUc5vduVTCBpbmv+hYvlcAy6r+ulD0JxoJ50A=;
	h=Date:To:From:Subject:Message-Id; b=MVe8X0l3U6MGnDqFDpNRy0f1yyoVsIgjpKzfC2gJU1Ym8FCDI8t4SdDc+OEFHRyjkGyraQ9O/U/EdV7GXuO73b0Rgx+Kz/uNJCXXhIAXY/TryPEB7L+f4Teawt6Uv4RFiq78AKU70IBsli0YkwOtpx5NvBBqV1AbyYpmYo2hOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WTTCgFLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WTTCgFLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12BEC4CED0;
	Mon, 16 Dec 2024 05:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327651;
	bh=lE8tNZdUc5vduVTCBpbmv+hYvlcAy6r+ulD0JxoJ50A=;
	h=Date:To:From:Subject:From;
	b=WTTCgFLNfu0/MyzbUkYB2gKzvr/agqRtilYAbnLnzJuosfkIPt+WcmU0Dtv6R6H/o
	 bv7GKD9D6XilPzp00QN529SauaK37qCCzX0w9kkD2jp3WvpkP2087F5aaBlfBqSCMb
	 knZuWc1nOxEdRZMmEM/yCIz/Bx1Kfm2n3/e0tXjQ=
Date: Sun, 15 Dec 2024 21:40:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054051.C12BEC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_write_begin_inline()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_write_begin_inline.patch

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

