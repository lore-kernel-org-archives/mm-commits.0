Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267083BE659
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568359; cv=none; b=RS3/2YkcVxuZ+2G3eI9FkhqZCkP1FiI+WrpfRJJqu0ff21yzG9z6sd+MHTC1R0Tsg2fH9K+sHv51tmhwbKg8Av/U70qhmiM0/J4ES0NDvrK/XW8hGDsm3lhztAIxBF56Dsi1oUKzdVwgL8Ml3pvpZqpfhxZk0wgN2OyxbC4nkHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568359; c=relaxed/simple;
	bh=8Ofy2DpOgAUrLQ4A/ussL99P4yyD0yuXWXE2vn80ipU=;
	h=Date:To:From:Subject:Message-Id; b=KWlw4A+jpVxS0Y2LB5+WQWDZ1VOLyKBD6e4C1WorHJXAemvLznH3sYn4u/pLJOzWFsbwVaTuVzgJZEqEmf1dPlKcQuz3dhso6INQnNZhRcxhjx1mLGl1oexpeetpWjSQ6P/62gws7oIMAf/bHC4wxd6HNcVrVjVntcGPiRRpgXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q0UbZuHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q0UbZuHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD6CC116C6;
	Thu, 26 Mar 2026 23:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568359;
	bh=8Ofy2DpOgAUrLQ4A/ussL99P4yyD0yuXWXE2vn80ipU=;
	h=Date:To:From:Subject:From;
	b=Q0UbZuHWEHUo+2GJrkl2UgmWQh1+O4e0wRCnnnBmeUPKkF7h3y/sYqCPhBSCxZCg2
	 8s0krjN+OEb61lfB8JN+L5aVSsRns34BPlPf5KqpBR2AqS38qUlvkKEkSomBz7FsfU
	 ISSs+iLMXKZMml0CH+LzkzF2pA28M+oo6mPSTCDw=
Date: Thu, 26 Mar 2026 16:39:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch added to mm-new branch
Message-Id: <20260326233918.EAD6CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: remove folio from page cache when accounting fails
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch

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
Subject: mm/memfd_luo: remove folio from page cache when accounting fails
Date: Thu, 26 Mar 2026 16:47:26 +0800

In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
after successfully adding the folio to the page cache, the code jumps
to unlock_folio without removing the folio from the page cache.

This leaves the folio permanently abandoned in the page cache:
- The folio was added via shmem_add_to_page_cache() which set up
  mapping, index, and incremented nrpages/shmem stats.
- folio_unlock() and folio_put() do not remove it from the cache.
- folio_add_lru() was never called, so it cannot be reclaimed.

Fix by adding a remove_from_cache label that calls filemap_remove_folio()
before unlocking, matching the error handling pattern in
shmem_alloc_and_add_folio().

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Link: https://lkml.kernel.org/r/20260326084727.118437-7-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

