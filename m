Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619CF1C3F1B
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327692; cv=none; b=pMM9a4ylJT8JqQSGmZ7sVEzowSsqTL8UneRy0683Ri9zmuRhRGCUs9C+mhIx76WG2VqD3Qv2uVubUaO9qt4b5CzsPd4oFsyTbNH/aXfnQ7ifJKSWvS1aD10NmaXIz/rdiyDjY2v5IPzpe5GTkqDJeqEY41LKaJ3GvJ0IhQavv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327692; c=relaxed/simple;
	bh=vDbuesFwicHHAWmvIG5F0n0iv73a1iaclzlHwBy0cg4=;
	h=Date:To:From:Subject:Message-Id; b=PCRJYDlx/7EfKtaIMPeSxKDw/a6Ww6mCFlT9v0dDDrglPMXZRS9mZrcsbXHOgcGNnoDelbYum3R6miDPLDlZKyZDrq+24jQuITR14sVm0TRrr3KRnuPfniDmZq8esbjwu9lF+cSsJC7FWkGA73+H0fzNmndIjtbQbvO2iai775g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NCjsVJ0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NCjsVJ0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CBDC4CED0;
	Mon, 16 Dec 2024 05:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327692;
	bh=vDbuesFwicHHAWmvIG5F0n0iv73a1iaclzlHwBy0cg4=;
	h=Date:To:From:Subject:From;
	b=NCjsVJ0KLKGW195pwu70+RaonEADsQidxF7XwiMzJOiSpHrSfdhs0Q6V+HSDy3YJR
	 CNK+wPdcZhdECcncgYtBOUNQ8l2uEmfiisn44euI/zz+MkuFZIyxO1mX8ePQb9kc2B
	 f01b1ZXC1FEeonTcWoMjqCpVGdDlI+TMqwCNHdZc=
Date: Sun, 15 Dec 2024 21:41:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054132.36CBDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: support large folios in ocfs2_write_zero_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-support-large-folios-in-ocfs2_write_zero_page.patch

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
Subject: ocfs2: support large folios in ocfs2_write_zero_page()
Date: Thu, 5 Dec 2024 17:16:51 +0000

Remove assumptions that a folio is PAGE_SIZE.

Link: https://lkml.kernel.org/r/20241205171653.3179945-24-willy@infradead.org
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

 fs/ocfs2/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-support-large-folios-in-ocfs2_write_zero_page
+++ a/fs/ocfs2/file.c
@@ -782,11 +782,11 @@ static int ocfs2_write_zero_page(struct
 		goto out_commit_trans;
 	}
 
-	/* Get the offsets within the page that we want to zero */
-	zero_from = abs_from & (PAGE_SIZE - 1);
-	zero_to = abs_to & (PAGE_SIZE - 1);
+	/* Get the offsets within the folio that we want to zero */
+	zero_from = offset_in_folio(folio, abs_from);
+	zero_to = offset_in_folio(folio, abs_to);
 	if (!zero_to)
-		zero_to = PAGE_SIZE;
+		zero_to = folio_size(folio);
 
 	trace_ocfs2_write_zero_page(
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
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

