Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F54FDF5C
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739454; cv=none; b=gCH3YB5DrruNe/2T6hSFzmPa8R/9zqSzWPUxrkTQAprPJ44W/K9uH5X6TzSlfVpQMpgAnP1rINqjT8ljpYJpqIfpr73OF/YnCTmoRQt1EFFVTknWKb4nlqOav5TIiz30Qk0SjtxsgZPnHHnePRDooq8AjxdJVScaRB2lrCZlj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739454; c=relaxed/simple;
	bh=44Of4yYlPTDoGT3usUpUR+eGsoHWIvFNP0sSRO76qLk=;
	h=Date:To:From:Subject:Message-Id; b=Xh4pBeOWmiClKxrznh7b3EANX61yGn4d64jFSaOwp0W5AyZ4CjoVdXn1ydCF8AtI/JhHp0YNm/JEnNSAEnRY0Ed5kiAcbMDGi1E6LvsLKAd6aEgM37nbVDOdQykEUXRdLCYY+gtEyXgPXO1jG8E2HfoyjrrvSb9y9U2GHzWn7L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUPTb4FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUPTb4FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64263C433F1;
	Sat, 24 Feb 2024 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739454;
	bh=44Of4yYlPTDoGT3usUpUR+eGsoHWIvFNP0sSRO76qLk=;
	h=Date:To:From:Subject:From;
	b=WUPTb4FMAbkviVrI9k2i/w4uQqqc4Q1ffbwKWyFI+WAXtwQ7hYBskOWpPAFkNFrQI
	 STBjSwyqQvoY6f0jMykfGSeDcPw7cjl4FBm22bx6aWcPBHZe4ai1R90McNQrbE/WDw
	 lFaibS4lqbAG1X5hvZV3XlJpeHi/tEPWuIwRyKdQ=
Date: Fri, 23 Feb 2024 17:50:53 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,shy828301@gmail.com,ryan.roberts@arm.com,minchan@kernel.org,fengwei.yin@intel.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch removed from -mm tree
Message-Id: <20240224015054.64263C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: madvise:madvise_cold_or_pageout_pte_range(): allow split while folio_estimated_sharers = 0
has been removed from the -mm tree.  Its filename was
     madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


