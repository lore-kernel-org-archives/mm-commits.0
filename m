Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0210F4
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734327674; cv=none; b=oq92sYAW7mPwGU1lUq9NAm4jL240vsEliHXxoWBaQrIGIPfVe5fjL+qROmX1tDh7Aq+22FnI2vt414Z9BJxSHjXtFwuazIkSeirmEwdUtpzJos1zMmNO4zfRBPcDfHNlKrW6ohIh1VqTFdNjokTVhpv805kqEDlNlNox2CYO+z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734327674; c=relaxed/simple;
	bh=R3YvJ/DHsoNp6wt7YU5ehhBYN6muSoHmCXnTfCyDV8M=;
	h=Date:To:From:Subject:Message-Id; b=c4kd60LXXB/y0OhDZUkVOVgmRPEjmBkm16BVCGijsFoW3TSXZ1cEWVgkgSelDMJaJ+cRBQshsDcrYoRJpbELYI4mDwCKgHUPkfgwn9iqbfVSjabOYsgtX0mLtk1arDQYQwWK+ioakNcMo330mGwmJ/JiMuqGuY70UZwAhWg4PkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2gVgf47k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2gVgf47k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183BAC4CED0;
	Mon, 16 Dec 2024 05:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734327674;
	bh=R3YvJ/DHsoNp6wt7YU5ehhBYN6muSoHmCXnTfCyDV8M=;
	h=Date:To:From:Subject:From;
	b=2gVgf47kUE7oktzBYr8P6qBCOJjl55/7YmzBAUQSpGrLQOBLEis1HoQ+Kh5GUSTw1
	 fnT0lpwo4xQZ8uHkYPbKayU6Pw6cVbbiavUFTkvN1nOXUYOqxVNkaGQF+wyTLZwfRq
	 xMF5EgSs50R/77VbHuY/17XXafLvz+3e2RDrifBU=
Date: Sun, 15 Dec 2024 21:41:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch added to mm-nonmm-unstable branch
Message-Id: <20241216054114.183BAC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: convert ocfs2_clear_page_regions() to ocfs2_clear_folio_regions()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch

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
Subject: ocfs2: convert ocfs2_clear_page_regions() to ocfs2_clear_folio_regions()
Date: Thu, 5 Dec 2024 17:16:43 +0000

Pass in and use the folio instead of its page.

Link: https://lkml.kernel.org/r/20241205171653.3179945-16-willy@infradead.org
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

 fs/ocfs2/aops.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions
+++ a/fs/ocfs2/aops.c
@@ -534,7 +534,7 @@ static void ocfs2_figure_cluster_boundar
  *
  * from == to == 0 is code for "zero the entire cluster region"
  */
-static void ocfs2_clear_page_regions(struct page *page,
+static void ocfs2_clear_folio_regions(struct folio *folio,
 				     struct ocfs2_super *osb, u32 cpos,
 				     unsigned from, unsigned to)
 {
@@ -543,7 +543,7 @@ static void ocfs2_clear_page_regions(str
 
 	ocfs2_figure_cluster_boundaries(osb, cpos, &cluster_start, &cluster_end);
 
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_folio(folio, 0);
 
 	if (from || to) {
 		if (from > cluster_start)
@@ -554,7 +554,7 @@ static void ocfs2_clear_page_regions(str
 		memset(kaddr + cluster_start, 0, cluster_end - cluster_start);
 	}
 
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 /*
@@ -950,7 +950,6 @@ static int ocfs2_prepare_folio_for_write
 		struct ocfs2_write_ctxt *wc, struct folio *folio, u32 cpos,
 		loff_t user_pos, unsigned user_len, int new)
 {
-	struct page *page = &folio->page;
 	int ret;
 	unsigned int map_from = 0, map_to = 0;
 	unsigned int cluster_start, cluster_end;
@@ -1016,7 +1015,7 @@ static int ocfs2_prepare_folio_for_write
 	 * been zero'd from being read in as a hole.
 	 */
 	if (new && !folio_test_uptodate(folio))
-		ocfs2_clear_page_regions(page, OCFS2_SB(inode->i_sb),
+		ocfs2_clear_folio_regions(folio, OCFS2_SB(inode->i_sb),
 					 cpos, user_data_from, user_data_to);
 
 	flush_dcache_folio(folio);
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

