Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34600348440
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568352; cv=none; b=DR4Ko1XvGBIYNq5TvZf9S96lPQnZDOkuuaRbXsdLQO6AVpnrczXwjMgBHy3M/kgA7HCnJPvNbXHgG4ZX1grp+TR0slSeLJYxCwNDirv42K+Y2FhYAymo6koiwkV7ZC5d/VIU/1bdFk497FOqsHo8DWpxHLNDPUGlKM0NzLQlUvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568352; c=relaxed/simple;
	bh=eKiXBJlVHGIkRpBU1oHJPWE3WZhvQmIdVddjDjE3quA=;
	h=Date:To:From:Subject:Message-Id; b=eakIIjFMU6jlDRAUqr63AUkCGBJnxq8gwGDsEKFK0Qhr2teYENOBm1s3RXA+BSR1uBCgN492HgDDwUFjFp09L8t/KxYhT8d5FT7w/ofv87cDZS6Z5xXQIuCu+6vZ3An1klTXn72DBG0Cod419okv9PJGjpvpGEMQlTOtJFKAu50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uy2390Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uy2390Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AB2C116C6;
	Thu, 26 Mar 2026 23:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568352;
	bh=eKiXBJlVHGIkRpBU1oHJPWE3WZhvQmIdVddjDjE3quA=;
	h=Date:To:From:Subject:From;
	b=uy2390HvQR4jY1Ko0s/RIRQ6ORtV+m9kcmTYfFARtA6budt5ZwNGcJnua1i6e39lr
	 aZzC+uEjM1IUNViBMPB3g7vxDz2rIW2182b91mxztDhURWvwb25STGcaZZ7X+cqhcb
	 CEDyUd3vXJLXVciw5P8azTGIMXIGXz7J48sCqvk8=
Date: Thu, 26 Mar 2026 16:39:11 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch added to mm-new branch
Message-Id: <20260326233911.E9AB2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
Date: Thu, 26 Mar 2026 16:47:21 +0800

Patch series "Modify memfd_luo code", v3.

memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
shmem_recalc_inode() with hardcoded 1 instead of the actual folio page
count.  memfd may use large folios (THP/hugepages), causing quota/limit
under-accounting and incorrect stat output.

Fix by using folio_nr_pages(folio) for both functions.

Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

Link: https://lkml.kernel.org/r/20260326084727.118437-1-duanchenghao@kylinos.cn
Link: https://lkml.kernel.org/r/20260326084727.118437-2-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting
+++ a/mm/memfd_luo.c
@@ -410,6 +410,7 @@ static int memfd_luo_retrieve_folios(str
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
+	long npages;
 	int err = -EIO;
 	long i;
 
@@ -456,14 +457,15 @@ static int memfd_luo_retrieve_folios(str
 		if (flags & MEMFD_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
-		err = shmem_inode_acct_blocks(inode, 1);
+		npages = folio_nr_pages(folio);
+		err = shmem_inode_acct_blocks(inode, npages);
 		if (err) {
-			pr_err("shmem: failed to account folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
+			       i, npages, err);
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		shmem_recalc_inode(inode, npages, 0);
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

