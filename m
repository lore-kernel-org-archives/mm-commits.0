Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735A7315793
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782424602; cv=none; b=bnJ9ZV9Aj7pxKkwitQl2zYc6X8I47cmc5sEQHaREliw87ImRy8JXA4Eimp6I8rAi8X6XxzXFuKsBfeqKR6qZnHiOlFQcpWfMlfFlxI2pDmXCS6jNbHGzirGVuBvgt+52H9mFzU6AslXHu/F0n+aH/29/D/5fKzcwoz3iHD0/BAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782424602; c=relaxed/simple;
	bh=MFJNsIVv69n4/h4S1O6XIdhXTNRuOZjIpCN9xWF46go=;
	h=Date:To:From:Subject:Message-Id; b=KGs+OukIZZ/v1CS01Yy6JA8vlB1hNF+4cAVe2FJ5xAeE4rBgmM7EQwZGjYclRy0FTuf+L5LKRIaTqkPFUdbbwdumw2W0r43tsIb7l4lqkOKELmCsAYZEeXPJYl+08wQMLGK0VY1K9rU++w08w9d+mTGKowk8PeUb9LfRWJmRs+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvkxeB/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvkxeB/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E714A1F000E9;
	Thu, 25 Jun 2026 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782424600;
	bh=/eGGEfZ6JKCzbwuENzIPb1nJeb3i7ILo7Ejq3tr/h3U=;
	h=Date:To:From:Subject;
	b=yvkxeB/+bsZtwnDaqn8Co/CX32ARR4Ec25ciui55XeFaXYs78it5lOsSish7XH7ji
	 pzpuG2pOIp8tewBKh6Pn7dFAJwOGc+DN2VbRRH+iT3dIXgiIHYewK243A7BNWVJaSG
	 zrzjU68WNOPLKqEcqBcMRkRmX04WvJjJNgM3PCII=
Date: Thu, 25 Jun 2026 14:56:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tujinjiang@huawei.com,riel@surriel.com,hughd@google.com,davej@codemonkey.org.uk,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-free-any-excess-xarray-nodes-in-clear_inode.patch removed from -mm tree
Message-Id: <20260625215639.E714A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: free any excess xarray nodes in clear_inode()
has been removed from the -mm tree.  Its filename was
     fs-free-any-excess-xarray-nodes-in-clear_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: free any excess xarray nodes in clear_inode()
Date: Tue, 23 Jun 2026 20:28:48 +0100

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and syzbot
have found ways to force it to happen with madvise.  Rather than fix the
leaks where they happen, just call xa_destroy() which has the side-effect
of cycling the i_pages lock.

Link: https://lore.kernel.org/20260623192850.1595958-1-willy@infradead.org
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/fs/inode.c~fs-free-any-excess-xarray-nodes-in-clear_inode
+++ a/fs/inode.c
@@ -763,21 +763,18 @@ void clear_inode(struct inode *inode)
 		fsverity_cleanup_inode(inode);
 
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-writebackh-to-docs-build.patch

