Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D13E1206
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 20:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782332603; cv=none; b=Cx5Cq7OGiZqTp8umkjqAppUsG5HEGaTA6RQWuu0mvEpLSP75+pw1RUtpH/0p2iZ+JIfPYS50jUE/Z8smy7NKalStIP4lgyeOsFp8F4M09GwcWs8WzioExdbb44JHNP/98ICPzFhwdbk+lt0CRV6IJ6S62D74u0ffVLAic4OW6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782332603; c=relaxed/simple;
	bh=V3+wtqnN6sJ9CUzd67e8Bxw7GzfxgdGlVVL6TC0xjzI=;
	h=Date:To:From:Subject:Message-Id; b=tSlJgZFcdxXGL2geLusMpKa1mPEbs2mIL3Wjzj0bC9v3O3hZjZN0SjEZlmZEJ+N1BCc1deRv9DOs5ycCC0bmTn9eP8qceC+doIjoUNp1mBEUFIpI/sIS+c9W7uiwVpMvG5fHGZeWFhdhDJVcYYK7wYT73dQc1BUvpncw0I6nbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3ddK4zn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3ddK4zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D68A1F000E9;
	Wed, 24 Jun 2026 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782332602;
	bh=RGUncdq7Tex92V8i5uIkbUATDIaKiacTrJ2jjogv8K4=;
	h=Date:To:From:Subject;
	b=C3ddK4znQlU2ZFTvQE0WUgpnOxXEPKlahckvIwjdZ+OmBZNI5z+4J4mBeB0pJJxM4
	 lK99wkHtq/ImJQFU/R9fT51L2tSMDJLUCnNz7dG6N26ZKRxe4r2Wfsu+xO6Uqi1OFb
	 AlaoJah/LIFKJKyO8K/EjrlLkxJ2GQYHj3Dgq2BA=
Date: Wed, 24 Jun 2026 13:23:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tujinjiang@huawei.com,riel@surriel.com,hughd@google.com,davej@codemonkey.org.uk,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-free-any-excess-xarray-nodes-in-clear_inode.patch added to mm-nonmm-unstable branch
Message-Id: <20260624202322.0D68A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: free any excess xarray nodes in clear_inode()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-free-any-excess-xarray-nodes-in-clear_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-free-any-excess-xarray-nodes-in-clear_inode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

fs-free-any-excess-xarray-nodes-in-clear_inode.patch

