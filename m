Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BB2372675
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300199; cv=none; b=uhJBuhJ/VQpl+o9Byf3gDOkTfrNM0O0GYc1l/S3uKPz5wxg7xH4upk8b1CagAJcngKTcfOj/pxeTl+FijFfsV2nX9JBEIRKaxwtlsrAlCZTUHi3kDSgMHxY7C1c3rilGZaUdt6JFIotl8VK81LfNwHxtsbia55oXNWVMFC+viCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300199; c=relaxed/simple;
	bh=/MQvYHMyLGXecUO3eB/CWvLjkqL7/Aw50XyxL5zh3pQ=;
	h=Date:To:From:Subject:Message-Id; b=HxH/ritaQOv/85OXGiD+2LH2nDQAlN46OSYMH69Jwov0rplmUEJE3SLpPvgeQZysvC9mEILFqxSVwxefxLPSVJAGzPiQETnu25x2gba3esEqdoqen1unjP5dhbc0R8aJAq5Un2MPYM4Jy2l63jP7rP/f9RnakBzhNVGIjpDKCQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Sx4nSYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Sx4nSYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE86C4CEF7;
	Mon, 23 Mar 2026 21:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774300199;
	bh=/MQvYHMyLGXecUO3eB/CWvLjkqL7/Aw50XyxL5zh3pQ=;
	h=Date:To:From:Subject:From;
	b=1Sx4nSYeL196fD1h4EoPtmkFCHU6QKH6i39EUBOc0uwfjG5r6rMc94pKsipbECXQt
	 iaZ50Mez/Y1c2xLw09f/FAETp/HyA4pwIc6XkL8Fdm6BvyWOxL6RfUK1yp21hxcjAu
	 BcRnQRJATWuBDxEGZZqcAuCjvVGnJfWFQnDKOM64=
Date: Mon, 23 Mar 2026 14:09:58 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch added to mm-new branch
Message-Id: <20260323210959.1CE86C4CEF7@smtp.kernel.org>
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
Date: Mon, 23 Mar 2026 19:07:45 +0800

Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
to improve performance when restoring large memfds.

Currently, shmem_recalc_inode() is called for each folio during restore,
which is O(n) expensive operations.  This patch collects the number of
successfully added folios and calls shmem_recalc_inode() once after the
loop completes, reducing complexity to O(1).

Additionally, fix the error path to also call shmem_recalc_inode() for the
folios that were successfully added before the error occurred.

Link: https://lkml.kernel.org/r/20260323110747.193569-3-duanchenghao@kylinos.cn
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

