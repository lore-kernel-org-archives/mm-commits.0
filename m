Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D0370D77
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498992; cv=none; b=IoJN7+3XQB+iEV7xuxCu9ibso8qGgnDjDf2wjEf5yP1eoUpAoY3//+L8czaXwisMwDlazI5QEBidF02W/AMy9Z5/4CgBznQ81OTpoekeF60JW/ZyAvT36cZ5DsffAJM1sQh/R3B1S2/nhxVAkC8j7dF5AN3ITN7mkT+muTNMLnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498992; c=relaxed/simple;
	bh=saZSOpUjzR0W2AcMkQH93YR50UCQL5CTaemuWlqQk4k=;
	h=Date:To:From:Subject:Message-Id; b=eh5BRxA9dBT3Fyl/lKqpRsYXss8g5E3fCI8OUNoJZxVUO5HRr0E/QZ1EF5E82HhFvvKku4+x3PV745h7gJdumWGQ+bN3sJVyQW0yO7SY6WPbSSFUY0odcfwh1wEqDThfhHcMzEZqCRJ+fH2IZQneFb/nzK8L118J3P8eIMpxe4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=awDD3MEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="awDD3MEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C73C19424;
	Sat, 18 Apr 2026 07:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498992;
	bh=saZSOpUjzR0W2AcMkQH93YR50UCQL5CTaemuWlqQk4k=;
	h=Date:To:From:Subject:From;
	b=awDD3MEQKAUwYF6qKht9Rbtobz0VejJkJeLvaSS+bNlrU1wX5iAOYIrnTySvKwV9m
	 gyt4MDADbfUoQzvC55Nfvt9zbucpHHN6xPgKQnBX+gk1bh0WzKOpfNEyzLxI7ab0up
	 clMj1oH77QlF1GW8xxKww1hZ0DO/R2RVmP+oU4yo=
Date: Sat, 18 Apr 2026 00:56:26 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch removed from -mm tree
Message-Id: <20260418075631.40C73C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd_luo: remove folio from page cache when accounting fails
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: remove folio from page cache when accounting fails
Date: Thu, 26 Mar 2026 16:47:26 +0800

In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
after successfully adding the folio to the page cache, the code jumps
to unlock_folio without removing the folio from the page cache.

While the folio eventually will be freed when the file is released by
memfd_luo_retrieve(), it is a good idea to directly remove a folio that
was not fully added to the file.  This avoids the possibility of
accounting mismatches in shmem or filemap core.

Fix by adding a remove_from_cache label that calls
filemap_remove_folio() before unlocking, matching the error handling
pattern in shmem_alloc_and_add_folio().

This issue was identified by AI review:
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

[pratyush@kernel.org: changelog alterations]
  Link: https://lore.kernel.org/2vxzzf3lfujq.fsf@kernel.org
Link: https://lore.kernel.org/20260326084727.118437-7-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails
+++ a/mm/memfd_luo.c
@@ -461,7 +461,7 @@ static int memfd_luo_retrieve_folios(str
 		if (err) {
 			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
 			       i, npages, err);
-			goto unlock_folio;
+			goto remove_from_cache;
 		}
 
 		nr_added_pages += npages;
@@ -474,6 +474,8 @@ static int memfd_luo_retrieve_folios(str
 
 	return 0;
 
+remove_from_cache:
+	filemap_remove_folio(folio);
 unlock_folio:
 	folio_unlock(folio);
 	folio_put(folio);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are


