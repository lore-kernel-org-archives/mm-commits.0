Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DAF38F9A;
	Tue, 25 Jun 2024 03:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287566; cv=none; b=jkk8VfQbM4oFkry1v//QExS1IXHNOk0k7Ggmc7SZW8j/dBfMci4HE+X6OJlKZLmqmVCVmaz4qP7acx3QAC+1SGt2s3SAbOqFsk410LbRjkKekSDBzqWnkbhq8iHmm+OD5jhQd9Lsv/n7lw2sXf8cYRUx5d+gqNunUFb2mnCeTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287566; c=relaxed/simple;
	bh=f1pgL+nvPTckfDLxoVtqa8XqiMXEJr0PpZusd6wiUmU=;
	h=Date:To:From:Subject:Message-Id; b=p7A6TBlJrq+wayAKND1Aevl5GP7gPx8NCAXPmzUnhs1Ir8//8npYUGFJfZnWauxS93Rqhyh9WeCaGCwP9EpNmw43E3nj+yE6st79MX8wqCPfqoL6loLolU2CuIIfFESlwlv0Da7+mhMyylgcu4sY+xz9ZAzrb+ujI5taZf5e1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kjj0T8as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kjj0T8as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338EAC4AF07;
	Tue, 25 Jun 2024 03:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287566;
	bh=f1pgL+nvPTckfDLxoVtqa8XqiMXEJr0PpZusd6wiUmU=;
	h=Date:To:From:Subject:From;
	b=Kjj0T8asUS6pkPBkKY/sSgvyWnrTpptnEzRUl/FQiIGwMfN+Ya+JWMFllwu2yUVOH
	 1D9x3ybHV6qwpTU+bkICf+Iat86ADDt58jAT/eVneWDwYkoWIDaNhKrdm5FKcSMecn
	 kV7B+yX/UYCFol+w7Hfe+O/kuXrQ/vMh8m6WklsA=
Date: Mon, 24 Jun 2024 20:52:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,trondmy@kernel.org,stable@vger.kernel.org,sfrench@samba.org,ryan.roberts@arm.com,neilb@suse.de,martin.l.wege@gmail.com,jlayton@kernel.org,hanchuanhua@oppo.com,chrisl@kernel.org,anna@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch removed from -mm tree
Message-Id: <20240625035246.338EAC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nfs: drop the incorrect assertion in nfs_swap_rw()
has been removed from the -mm tree.  Its filename was
     nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nfs: drop the incorrect assertion in nfs_swap_rw()
Date: Tue, 18 Jun 2024 18:56:47 +1200

Since commit 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS
swap-space"), we can plug multiple pages then unplug them all together. 
That means iov_iter_count(iter) could be way bigger than PAGE_SIZE, it
actually equals the size of iov_iter_npages(iter, INT_MAX).

Note this issue has nothing to do with large folios as we don't support
THP_SWPOUT to non-block devices.

[v-songbaohua@oppo.com: figure out the cause and correct the commit message]
Link: https://lkml.kernel.org/r/20240618065647.21791-1-21cnbao@gmail.com
Fixes: 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS swap-space")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Closes: https://lore.kernel.org/linux-mm/20240617053201.GA16852@lst.de/
Reviewed-by: Martin Wege <martin.l.wege@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/direct.c~nfs-drop-the-incorrect-assertion-in-nfs_swap_rw
+++ a/fs/nfs/direct.c
@@ -141,8 +141,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 {
 	ssize_t ret;
 
-	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = nfs_file_direct_read(iocb, iter, true);
 	else
_

Patches currently in -mm which might be from hch@lst.de are


