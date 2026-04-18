Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6898936EAA4
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498967; cv=none; b=X5hqilGRVLWpdCmvL2jMIRh0ChFlYa+SewxZod+L2Air2/4egFk8fkjq/3gpHDxZNi1JWA9MJ40SHV9uibh5FitkyeszjiLN0FC2JMLOQlLREK29dzWKY3oWICsRRkQK9b51YgNFQ47upTh69zuuBOvFKMhcEduJG9EmqePiBTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498967; c=relaxed/simple;
	bh=GhScI3yb4KFJWvB5OWjcBk7iJzQWXZmMZtJcHuBFCpU=;
	h=Date:To:From:Subject:Message-Id; b=SXhiZxDLFzyonNa5MDVtiaaTvbNmNgAEx2M43sV6axi1WZfpi+fGLyDHEgsf/Nx48PAwx20QcBEO56XiPtqltZfJNtqeAaZ6833kdfVWwtjdRdfqjP+yXlqoDcm7A6cLeLkkCRamC0fF2DG/PTO5G/Nhx2CFA8HnLmqPtqrIPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xsHanj3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xsHanj3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115CC19424;
	Sat, 18 Apr 2026 07:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498967;
	bh=GhScI3yb4KFJWvB5OWjcBk7iJzQWXZmMZtJcHuBFCpU=;
	h=Date:To:From:Subject:From;
	b=xsHanj3w3m+BUuTmc/LAPjQr+KLUWl6iI85UXSWgHym15tm82uvs5OJINnIB+4Hfa
	 3K8NOOGhypdxu/nCSMFYwMA676HOyzN0NBFQjI3A/jeC32AgeWqACYSxG7o2skmLii
	 f1B2iBimqzOAB5ZyqVwEC7bGh8BtQxSrDNeL7Ov8=
Date: Sat, 18 Apr 2026 00:56:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch removed from -mm tree
Message-Id: <20260418075606.C115CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260326084727.118437-3-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


