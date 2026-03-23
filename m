Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2F729BD9A
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300197; cv=none; b=UMA1VHjMDMrw9V9J0e3FLdiRitrTdeL9s2u/EH4KlEi62vp5U+lNsFFp/vXxhUcSnhEUAYZqyi1Tu2szMIlQz8do5Q9LcEqRjSAJmoD0/BYBZ4a36y1lih4Age5r1+UJKwqCcUui+5cU2hqJAUeoTpWGQfA5BHAFnImBYTWMtNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300197; c=relaxed/simple;
	bh=mJHV1Veah5yl0s0/Lvi5sgSSBKcHXZlbUqY2XdaqOgA=;
	h=Date:To:From:Subject:Message-Id; b=ZmqTO9w8ZHYTtWEhyIdm6pjamGR3v1uuIhjsDOhM6DtwhYB1r2/DycUH5E+SZDpBcZjmOnigmfC7SUYQt0heNdeNEHqP4eYow3hB5z3cQm8tCTAr1KHjSiXl/C/PdeJ8op9ctSdc/1HIMPKxVh6mljqqZnADvFyR67ywViik42A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfZnPLfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfZnPLfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94DBC4CEF7;
	Mon, 23 Mar 2026 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774300197;
	bh=mJHV1Veah5yl0s0/Lvi5sgSSBKcHXZlbUqY2XdaqOgA=;
	h=Date:To:From:Subject:From;
	b=vfZnPLfp9xH20oQfcQo1nidzLziHSHDlwJgyF6TGyuqMPJYq/hch9LbUrZ+7hU1qE
	 lHtdU9EQZlAMxqycWpS7ALzbD3jmkXJfr091O6aH1TvCheunlfIPxY5jeCcLf5mtdU
	 lFoH7Bsyg6/yBDvx4KBrZzD/Q2oLjYKu/hAquzJs=
Date: Mon, 23 Mar 2026 14:09:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch added to mm-new branch
Message-Id: <20260323210956.E94DBC4CEF7@smtp.kernel.org>
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
Date: Mon, 23 Mar 2026 19:07:44 +0800

Patch series "Modify memfd_luo code", v2.

Various fixes and cleanups for the memfd LUO code.


This patch (of 4):

memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
shmem_recalc_inode() with hardcoded 1 instead of the actual folio page
count.  memfd may use large folios (THP/hugepages), causing quota/limit
under-accounting and incorrect stat output.

Fix by using folio_nr_pages(folio) for both functions.

Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

Link: https://lkml.kernel.org/r/20260323110747.193569-1-duanchenghao@kylinos.cn
Link: https://lkml.kernel.org/r/20260323110747.193569-2-duanchenghao@kylinos.cn
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

