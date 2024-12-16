Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33061BD9F6
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327663; cv=none; b=UY6I3kDZCVPNxILwAtUc5+DT22i1zusKFEUASoFQTMiVdGDlm1ml6rDP+Wd/7/xt3Ui6XFUs9oXRvOGOAhJjb2NLhXO/AHApbSBxNvYrlOCS7qdoG6BM1rkYe42vJl6fr6W9yBlDk/0sN5tdhJrvKu/cHguxSPpwmhvUtzo06nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327663; c=relaxed/simple;
	bh=MIOPmH4L1FLNbbY+PRhW3pqHreXbHLkxmSQzp6ThSMQ=;
	h=Date:To:From:Subject:Message-Id; b=fXaDVkbVnHTC0P+QGaqm3sBoG1YLBh5Aju0TDXVhXd1591I43cdxA98gkLNknisx5GHWVL9x1Jsn5e/1GzoF/sy53+Nd1B0XFvgfF3MqNqyxDO8cwuNskp5E9LWG4Amp1IffZwxghuCJoH+cw0mvy4kEqSwmUWGb0eog1Hfrc2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fG4sGDCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fG4sGDCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88705C4CED7;
	Mon, 16 Dec 2024 05:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327663;
	bh=MIOPmH4L1FLNbbY+PRhW3pqHreXbHLkxmSQzp6ThSMQ=;
	h=Date:To:From:Subject:From;
	b=fG4sGDCwFH7bf16WFB/3iirLnMaWsi/oe4jVc1o0h/gbE1jmx2Q/x0W5KIUsAELHd
	 8/xe8JZ/4qKNjW/ZNX8oj+bYbKtqMxIEkqezfSMOHiF2pnKDrzk7oPgtigVVOOaDza
	 y6icfanYl9dlgCiI+BedPkmkC1IdsYgyhoTSQ5ds=
Date: Sun, 15 Dec 2024 21:41:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054103.88705C4CED7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_write_failure() to use a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_write_failure-to-use-a-folio.patch

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

