Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047F25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742220; cv=none; b=L4qxQEeSZbZ2rPZ0epTTNeirMmOVpPcVQ5HfKVGno7bLemeWaN41NIK3nO/0/jPwKp8fXwL9S6dsG9KEkbjPcfCIwRfU0FXYZZdAPIZ4643AYHn/q3rzmJsRQK7QWQyyCIsPFZZLL8ccPTPfhpvkeTzWevTgWwHUw4GPpN5N0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742220; c=relaxed/simple;
	bh=9ldASJB2YG70xdmsg7f91oN5yXXa9ljB/vIrrVVumeU=;
	h=Date:To:From:Subject:Message-Id; b=kTXx9VZ5Rw9Tws0kseRF68rkONpHos/jtiYqQagHAx2tWLGBqgyRccjSCe2K4IrmIAWFNTY7zi1gDWLzNs4n6DKqcxp885WtC8KWrRGHH1oW1beevOGbVXHg4NL6JKyLm3Iq+F7nHaarg4fSRMh4PXIvKJ1WEaBNCR2mg4AMKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1AL/U+Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1AL/U+Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D94FC4CED6;
	Mon, 13 Jan 2025 04:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742220;
	bh=9ldASJB2YG70xdmsg7f91oN5yXXa9ljB/vIrrVVumeU=;
	h=Date:To:From:Subject:From;
	b=1AL/U+UldDUQ2dMpPC8XW4HClsDwlay6s0tttd5CQPTX1ttYHuzA7pH0biU+Zz/6X
	 DjVWOLZMMDx9jxZeZWqdgpwvzRmOV61j1T3NynwIUY9CewttbvfUyRsA9PHttzTqTJ
	 4xqYndv8GgIN2LTPAw/Za8DJns7QQBlhy13pShtU=
Date: Sun, 12 Jan 2025 20:23:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch removed from -mm tree
Message-Id: <20250113042340.2D94FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: convert ocfs2_clear_page_regions() to ocfs2_clear_folio_regions()
has been removed from the -mm tree.  Its filename was
     ocfs2-convert-ocfs2_clear_page_regions-to-ocfs2_clear_folio_regions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


