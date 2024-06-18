Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2F428DCC;
	Tue, 18 Jun 2024 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740870; cv=none; b=qxeVLp4D5KqAjKogoRyjdqGNhMX1SJ0mp1rs2m8Xhv3kMqSx6JTMOdMtA/2WyQtNPhvyCHSeEHzcgyF+kgxphMrXPan5Ytg22670awN972uHS0RqcYkl90pUA28432hnXdxqQwTtl+9Ig3Q1gWV3TCJagTsYZL8Pnbp7gCVmCjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740870; c=relaxed/simple;
	bh=Am4A+3tB3OtBkQUIerg35GndeEnrCJBx63LQtXDSPJE=;
	h=Date:To:From:Subject:Message-Id; b=LQ7IPyq54PwkT1w/gbaf0nb1H5pbM2jZytmLDwIHz7OJ1TRuyUXa8wabrwrq3Vx1niKs4dYH2DY8YOwyzP8A3xMcFHtPwbcHOopO3hgkpsQrPoGnSR1ksFfXi3G+rP7wyXDKQiWQoRSte88yjDPyaZwDHTcEAsfbd9pKbewN6Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llC5a5nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llC5a5nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53892C4AF48;
	Tue, 18 Jun 2024 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740870;
	bh=Am4A+3tB3OtBkQUIerg35GndeEnrCJBx63LQtXDSPJE=;
	h=Date:To:From:Subject:From;
	b=llC5a5nj9XwjDO4CbPczzLVQ8PAHDz5fvXebAdIrkBuXkxyOQNvPBTH49yNcOwb+5
	 2HsA00PhUS1BbLPfzyJTk8t4dLj77CCoTZ4FJAcfu1URZgB/SzmSRcMRyJJH0xOCeL
	 QKUuBx29sD2DqGx32ZEBQi8erwtZfH1H+9Gp2QCc=
Date: Tue, 18 Jun 2024 13:01:09 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,trondmy@kernel.org,stable@vger.kernel.org,sfrench@samba.org,ryan.roberts@arm.com,neilb@suse.de,martin.l.wege@gmail.com,jlayton@kernel.org,hanchuanhua@oppo.com,chrisl@kernel.org,anna@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch added to mm-hotfixes-unstable branch
Message-Id: <20240618200110.53892C4AF48@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nfs: drop the incorrect assertion in nfs_swap_rw()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Reported-by: Christoph Hellwig <hch@lst.de>
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

nfs-drop-the-incorrect-assertion-in-nfs_swap_rw.patch
nfs-fix-nfs_swap_rw-for-large-folio-swap.patch

