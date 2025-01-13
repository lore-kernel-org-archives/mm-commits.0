Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA415D5B6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742228; cv=none; b=V+Oy42525PwxcbAv0Yka4GW2fTlv/rqx6B5ag2qNvw9Hql1cN/u5UNXadq2JJEVwoSr0oY6OnjX+OObOMhdOd+0I4s40q9KUZApFYzyPqoMMp5XTzgCrqgNiR14TgrbLrtXGhFy5U8WZgh7Ynz4OsFHk8HfctxCA8Q4ah3I5Vwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742228; c=relaxed/simple;
	bh=q2L/cPVrFy1+XMkWT4qRZIH8gcw5dDl7TVY4sPhKXvk=;
	h=Date:To:From:Subject:Message-Id; b=KswrF3KdC5DZbSb6x9yll5+O1+NJ/51hmEu8+BqcryXu25TLPPe261KTQhSWctNKPNssHbU/ZyHqwjQdpIGn8pGWhzb6UpqZa7ps3bRg0bAUulO6C28e9Xe2RDPYKz2h6Cntyb+Tm+hAy/IGUhFCc2LojpbozW/Vw0iR20JNYhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ae2mIxfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ae2mIxfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048EAC4CED6;
	Mon, 13 Jan 2025 04:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742228;
	bh=q2L/cPVrFy1+XMkWT4qRZIH8gcw5dDl7TVY4sPhKXvk=;
	h=Date:To:From:Subject:From;
	b=ae2mIxfH330ZiLq+4r19aweAWcROirlx94bPZPtu4/RAtM8h3EZrzibg2NAxvZqaZ
	 wp6rTq82HtcCod27zaZQJmVHgav4DrpQYHywQUjnex7KKnqnQqPJzoGn53IfohSCwB
	 tFxJr0Nww4nxXLTK9AIDF3Zr6FUpGQzZ+WoxOzY4=
Date: Sun, 12 Jan 2025 20:23:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch removed from -mm tree
Message-Id: <20250113042348.048EAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: support large folios in ocfs2_zero_cluster_folios()
has been removed from the -mm tree.  Its filename was
     ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: support large folios in ocfs2_zero_cluster_folios()
Date: Thu, 5 Dec 2024 17:16:50 +0000

Remove assumptions that a folio is one page in size.

Link: https://lkml.kernel.org/r/20241205171653.3179945-23-willy@infradead.org
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

 fs/ocfs2/alloc.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-support-large-folios-in-ocfs2_zero_cluster_folios
+++ a/fs/ocfs2/alloc.c
@@ -6851,7 +6851,6 @@ static void ocfs2_zero_cluster_folios(st
 		u64 phys, handle_t *handle)
 {
 	int i;
-	unsigned int from, to = PAGE_SIZE;
 	struct super_block *sb = inode->i_sb;
 
 	BUG_ON(!ocfs2_sparse_alloc(OCFS2_SB(sb)));
@@ -6859,21 +6858,18 @@ static void ocfs2_zero_cluster_folios(st
 	if (numfolios == 0)
 		goto out;
 
-	to = PAGE_SIZE;
 	for (i = 0; i < numfolios; i++) {
 		struct folio *folio = folios[i];
+		size_t to = folio_size(folio);
+		size_t from = offset_in_folio(folio, start);
 
-		from = start & (PAGE_SIZE - 1);
-		if ((end >> PAGE_SHIFT) == folio->index)
-			to = end & (PAGE_SIZE - 1);
-
-		BUG_ON(from > PAGE_SIZE);
-		BUG_ON(to > PAGE_SIZE);
+		if (to > end - folio_pos(folio))
+			to = end - folio_pos(folio);
 
 		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
 				&phys);
 
-		start = (folio->index + 1) << PAGE_SHIFT;
+		start = folio_next_index(folio) << PAGE_SHIFT;
 	}
 out:
 	if (folios)
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


