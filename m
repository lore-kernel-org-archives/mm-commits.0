Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57E810F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327668; cv=none; b=vB1g7htYPaXG7e8QisDDXseYgML88VHcAtj34bkXd9u72a3tN5QotiZXkomF6/m7QINh3445y2eJ7pVh92W+cH4Xws1fchhX7oFYX5HzDJO0E5Nny/Au/zhJPT/6cMTMSUb9eAbuukAUj/HLpuoapoVEsZfDRVIbUV5DIl/i72U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327668; c=relaxed/simple;
	bh=NIsGeq6q4fY3hoYu8hBGZOoI2nzJrn4iykpmNXssCww=;
	h=Date:To:From:Subject:Message-Id; b=VPFBjDuE9cfr6rWjMQvXlNTYC6pTr7hSbF4Bi9ip9SwzapHD/OkX8wEwGoTz5ZOUsRipEotXRfWYR+GwI6qS9VTsB0Wn19vqzupFRgNfBaORiyaq6ND4/8EiTsCEn1BHf3ounGSJ1zxRYea/kc+rvcTbmtBCQScIZ4ZBdDorBw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOoO0sl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOoO0sl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F252C4CED0;
	Mon, 16 Dec 2024 05:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327667;
	bh=NIsGeq6q4fY3hoYu8hBGZOoI2nzJrn4iykpmNXssCww=;
	h=Date:To:From:Subject:From;
	b=sOoO0sl2JEnGZKrB3QtCSJxEXF86vLR5FknAcGAlQdjUAUflJoiic6puSMbcDpzTz
	 qjsHgx4CvIwlz9wgzLlfkEUUf6nMRRjpXBm8w7mjfkhQ/n56hIRojIWxDeySvPbg8v
	 rfIzjh1TS/bgwL1qmafi5QZyKEcvDkgoG16QmEPI=
Date: Sun, 15 Dec 2024 21:41:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054107.7F252C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use a folio in ocfs2_prepare_page_for_write()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch

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
Subject: ocfs2: use a folio in ocfs2_prepare_page_for_write()
Date: Thu, 5 Dec 2024 17:16:40 +0000

Update to the new APIs.  Removes a few page->folio conversions.

Link: https://lkml.kernel.org/r/20241205171653.3179945-13-willy@infradead.org
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

 fs/ocfs2/aops.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write
+++ a/fs/ocfs2/aops.c
@@ -963,10 +963,10 @@ static int ocfs2_prepare_folio_for_write
 	/* treat the write as new if the a hole/lseek spanned across
 	 * the page boundary.
 	 */
-	new = new | ((i_size_read(inode) <= page_offset(page)) &&
-			(page_offset(page) <= user_pos));
+	new = new | ((i_size_read(inode) <= folio_pos(folio)) &&
+			(folio_pos(folio) <= user_pos));
 
-	if (page == &wc->w_target_folio->page) {
+	if (folio == wc->w_target_folio) {
 		map_from = user_pos & (PAGE_SIZE - 1);
 		map_to = map_from + user_len;
 
@@ -990,7 +990,7 @@ static int ocfs2_prepare_folio_for_write
 		}
 	} else {
 		/*
-		 * If we haven't allocated the new page yet, we
+		 * If we haven't allocated the new folio yet, we
 		 * shouldn't be writing it out without copying user
 		 * data. This is likely a math error from the caller.
 		 */
@@ -1008,20 +1008,20 @@ static int ocfs2_prepare_folio_for_write
 	}
 
 	/*
-	 * Parts of newly allocated pages need to be zero'd.
+	 * Parts of newly allocated folios need to be zero'd.
 	 *
 	 * Above, we have also rewritten 'to' and 'from' - as far as
 	 * the rest of the function is concerned, the entire cluster
-	 * range inside of a page needs to be written.
+	 * range inside of a folio needs to be written.
 	 *
-	 * We can skip this if the page is up to date - it's already
+	 * We can skip this if the folio is uptodate - it's already
 	 * been zero'd from being read in as a hole.
 	 */
-	if (new && !PageUptodate(page))
+	if (new && !folio_test_uptodate(folio))
 		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
 					 cpos, user_data_from, user_data_to);
 
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 
 out:
 	return ret;
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

