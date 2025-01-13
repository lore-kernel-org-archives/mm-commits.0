Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A801586FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742217; cv=none; b=FTaE6EGAXg3HGEo9iRekxHZylKs9hk//l9fGup0hkM0KV34ukOXZgUkMcn1QGEbSH/0tmrAKQgXQnhmoxDBBO2s1LxZSh2LB2a36UrxnS1UgxPdlTVz/9XLepgBTt83ACFULDrdnXlW53OZ/d5Jsee5rdskul4WnA+ozKdtDyII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742217; c=relaxed/simple;
	bh=25UOB/h5jUyqzDXm7DuVqi0qGO7NXxsZs/+c/32o6iI=;
	h=Date:To:From:Subject:Message-Id; b=ss30RKEUDJftM5Cpzz8TFTw/6qX3GOi81geKpVIaZ1gOjBg6y52dDjSGqOTHoP2pDEJNnqZYqxZsn4hvfVAdcz4EC0wQ2mG4v3KxUn6dacYjkTKv5KnUy++E4PlVctjSgVyw5H819+ZQnZF2dXXkARXaaIy+q+AYdCo+GL07xtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4J00p21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4J00p21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE976C4CED6;
	Mon, 13 Jan 2025 04:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742216;
	bh=25UOB/h5jUyqzDXm7DuVqi0qGO7NXxsZs/+c/32o6iI=;
	h=Date:To:From:Subject:From;
	b=q4J00p21/lDlX7efQd0xVJfVqNP84zfVRwlTOEke+n60hg6Rz1LOx+LYBljDqBenC
	 e74PVtK2U2q32YPS0vPeJzbtfsQPpBwOB47D5yVIZme0z/bIruUd76MiMuIORRm3a/
	 JAYzZPKF4qrPlm6uqv/J8Zni6/0WKwrEVzBo5WrA=
Date: Sun, 12 Jan 2025 20:23:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch removed from -mm tree
Message-Id: <20250113042336.CE976C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use a folio in ocfs2_prepare_page_for_write()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-a-folio-in-ocfs2_prepare_page_for_write.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


