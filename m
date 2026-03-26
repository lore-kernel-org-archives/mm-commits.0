Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7562F3C26
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568353; cv=none; b=oog8r7zxqdtnBYji0geTUX9elogssZm1592ib1Yx7AelnSF8ppbMIkyt7BtJbi281WIFhNSQ2Iww4xmPfkdTQdkIiWhNmaALo68Lx9i8r87eQQ++Tn8Lmktx1v4wH03F6nSF6qGzCq6ntFlPKnetebp+hReD4DU8OmKCAMVLzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568353; c=relaxed/simple;
	bh=MeyyrswN1c9CuXJfpFN7suYSDFQOPL/JakW4RE0uLj4=;
	h=Date:To:From:Subject:Message-Id; b=HvtIDh859bB63vqX4wpPSvVsHSwA4thrtkNPPou8xP5eecxj01y/3DLCvLjv1xuivrIHhWFmNdTxmzUAsoY7xUGu2RRS/70t8Cp+mixZ7x/0ERxsqxdXWyxveR9EbWbFTzkoprR1DsjSW9QkujAdt4zn5FS1Cp1cHtcywlrWcMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lz+ijsxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lz+ijsxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A21C116C6;
	Thu, 26 Mar 2026 23:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568353;
	bh=MeyyrswN1c9CuXJfpFN7suYSDFQOPL/JakW4RE0uLj4=;
	h=Date:To:From:Subject:From;
	b=Lz+ijsxeHs2xAdcSTE4gve4KqM5xkyS4VpZpfZR4CQ18svYO9YwaUN7hjm5R8EyLQ
	 FGHEFFp9Swx8TT5AwwMyXDcxxOYRVTZ7j0rGYo7xbggC+VO/wAe+Odv+J9MmU48oyq
	 McwLSAaXcMrfS8vMNt4yZ+mAF4lk+qQhL6NtzQbs=
Date: Thu, 26 Mar 2026 16:39:12 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch added to mm-new branch
Message-Id: <20260326233913.17A21C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch

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
Subject: mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
Date: Thu, 26 Mar 2026 16:47:22 +0800

Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
to improve performance when restoring large memfds.

Currently, shmem_recalc_inode() is called for each folio during restore,
which is O(n) expensive operations.  This patch collects the number of
successfully added folios and calls shmem_recalc_inode() once after the
loop completes, reducing complexity to O(1).

Additionally, fix the error path to also call shmem_recalc_inode() for the
folios that were successfully added before the error occurred.

Link: https://lkml.kernel.org/r/20260326084727.118437-3-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path
+++ a/mm/memfd_luo.c
@@ -410,7 +410,7 @@ static int memfd_luo_retrieve_folios(str
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
-	long npages;
+	long npages, nr_added_pages = 0;
 	int err = -EIO;
 	long i;
 
@@ -465,12 +465,14 @@ static int memfd_luo_retrieve_folios(str
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, npages, 0);
+		nr_added_pages += npages;
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
+	shmem_recalc_inode(inode, nr_added_pages, 0);
+
 	return 0;
 
 unlock_folio:
@@ -489,6 +491,8 @@ put_folios:
 			folio_put(folio);
 	}
 
+	shmem_recalc_inode(inode, nr_added_pages, 0);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

