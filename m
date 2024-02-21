Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CC63A1DB
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708547978; cv=none; b=MvkTbiVFx4WBwS6lRr/1lXmpL+Rkc94pDR0Tas8DUipQR8fTI3POPgOIwLd6Vx2PI/xM5xxuGsuaqkSGJ2O+oqxUkuQB0231ZMwMgv6T7Qlcz6VHjj+UENDt50hEYTmKzas9y4vKdDTssCvJ55+WkK5d1xAeiWMwb/YKI2PhbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708547978; c=relaxed/simple;
	bh=xcIC/DHh1PaZkhU1+rMc703NubhhFcaFCoP7JSA2piQ=;
	h=Date:To:From:Subject:Message-Id; b=M2esvDgNPWqn5LFmuy4eqLTdGY+uggzdH5crcyoLy3nn45+4uq1VnXEbi5cxw3UdNAODtQF79yiOdMG6x8MuDcpftGBnfwzNtUpwWUN+zNDuUKP1FnDdKgphlFI1C9ycNMUrIk1EZK90Wq7BN4ClmAShKeUmEAz5xK3d+Qi9JOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Or3x/hKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Or3x/hKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0622C433F1;
	Wed, 21 Feb 2024 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708547977;
	bh=xcIC/DHh1PaZkhU1+rMc703NubhhFcaFCoP7JSA2piQ=;
	h=Date:To:From:Subject:From;
	b=Or3x/hKobH+CjkLWpBwzT6/X5ZkdD24ijaM/781OJzqhtKe9X8O3GL2p6vjVSJnbm
	 0VKSNcjBfZAA7+FTOTXH/KQLk75JzbY+TiVfRHrpLhJ2Q3/Ny1mLe4ZjWpsoQCyxq9
	 9/IyasAbrbmMw3sj7sF7c4bWYLrg2WKcuq23VOcc=
Date: Wed, 21 Feb 2024 12:39:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,shy828301@gmail.com,ryan.roberts@arm.com,minchan@kernel.org,fengwei.yin@intel.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch added to mm-unstable branch
Message-Id: <20240221203937.B0622C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: madvise:madvise_cold_or_pageout_pte_range(): allow split while folio_estimated_sharers = 0
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch

This patch will later appear in the mm-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: madvise:madvise_cold_or_pageout_pte_range(): allow split while folio_estimated_sharers = 0
Date: Wed, 21 Feb 2024 21:50:36 +1300

The purpose is stopping splitting large folios whose mapcount are 2 or
above.  Folios whose estimated_shares = 0 should be still perfect and even
better candidates than estimated_shares = 1.

Consider a pte-mapped large folio with 16 subpages, if we unmap 1-15, the
current code will split folios and reclaim them while madvise goes on this
folio; but if we unmap subpage 0, we will keep this folio and break.  This
is weird.

For pmd-mapped large folios, we can still use "= 1" as the condition as
anyway we have the entire map for it.  So this patch doesn't change the
condition for pmd-mapped large folios.  This also explains why we had been
using "= 1" for both pmd-mapped and pte-mapped large folios before commit
07e8c82b5eff ("madvise: convert madvise_cold_or_pageout_pte_range() to use
folios"), because in the past, we used the mapcount of the specific
subpage, since the subpage had pte present, its mapcount wouldn't be 0.

The problem can be quite easily reproduced by writing a small program,
unmapping the first subpage of a pte-mapped large folio vs.  unmapping
anyone other than the first subpage.

Link: https://lkml.kernel.org/r/20240221085036.105621-1-21cnbao@gmail.com
Fixes: 2f406263e3e9 ("madvise:madvise_cold_or_pageout_pte_range(): don't use mapcount() against large folio for sharing check")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0
+++ a/mm/madvise.c
@@ -453,7 +453,7 @@ restart:
 		if (folio_test_large(folio)) {
 			int err;
 
-			if (folio_estimated_sharers(folio) != 1)
+			if (folio_estimated_sharers(folio) > 1)
 				break;
 			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch
mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch
madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch

