Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940955921EF
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890131; cv=none; b=Eqof8jqntUTRIntg8DIYTRkxmTAwZ2RO8LUfLemJdOoBRHvuMPfkXV6YnsMhC0muRA5uq87srvCv/+Wl8YlG/2nRHdUa98/RlGYJ3n8Z/S3Zcb8Wr47ycpwyxv4CJIeqdQ457yk7mcgYldD4juZCdjI93uRoDAWvp3Irk5euXNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890131; c=relaxed/simple;
	bh=VKidOnBtG/Fh7GG2wABClDt4Yc/WO+E+8aTmPNh8xEs=;
	h=Date:To:From:Subject:Message-Id; b=j+LpROY4aaz8BHiXJWIcJ2GsIBXXS1Tl5xSNL0TSuH8QiV0+fYs/fNpnQmL2tKukhWGKmJtyINz6dBU4SHMnJB3zm/lgDq3PDtFv8VM1+RpWXwY/Fqld1UJInne1Zd9rB9Vo1PkAYd5oUBLY4RZTsSl8VNwanpG/2nDlG1xzHTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ac9SdXWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ac9SdXWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D1D1F00A3D;
	Tue,  8 Sep 2026 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890130;
	bh=8Vxe2ZA5MF8tXcMRo020jp6yNjBmp9xLJ4dHgjJvQiA=;
	h=Date:To:From:Subject;
	b=ac9SdXWx0RRXoX5RVpbjQ6x0ecjILg0Dgb7R2uWYbDrKTBotNKLLRWPezjPOv9Q07
	 LnAzmmfpJnlPQwvd/b5sY6E3tYFXZqMPh0Xr7ONpM1pM1kH3lFv2z42D/yJKSZFbIi
	 Eubv+SDIhE+qqBUo9C9hSLwQoSwJBZMV6fD3BoUY=
Date: Tue, 08 Sep 2026 10:55:29 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch added to mm-new branch
Message-Id: <20260908175530.60D1D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: use folio_swap_entry() in zswap_store_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/zswap: use folio_swap_entry() in zswap_store_page()
Date: Tue, 08 Sep 2026 11:16:34 -0400

zswap_store_page() open-codes the swap entry computation from folio->swap
and the page index.  Use folio_swap_entry() instead.

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-4-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-folio_swap_entry-in-zswap_store_page
+++ a/mm/zswap.c
@@ -1398,8 +1398,7 @@ static bool zswap_store_page(struct foli
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
-					      swp_offset(folio->swap) + index);
+	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch
mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch

