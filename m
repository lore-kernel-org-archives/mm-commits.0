Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448235C6B1;
	Fri, 31 Jul 2026 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785529630; cv=none; b=S4BNkcbvb4GSznGg2wKdn2Hm500ikR24Hn+r9g9wMuGzABFOqrHV7v73m1uBVGAVQnfREd/xI5r8y/RD5gfAp+9tHPGm/OoYWauRMxx9X00uq/p5ywfMTbU+lTqcESVygyRuO4C3HD+NRiD9BM2rCu5M9Xy9Pa/U8HHoUojODA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785529630; c=relaxed/simple;
	bh=j5Wnni0o7pDf9FErERx32yx7I0sacfz1onZG30n99tI=;
	h=Date:To:From:Subject:Message-Id; b=YvTbJ7zMSz8G+2BltFNm59iIkXXtef8cbeN3cfNLq2zADo0jIdXex9R4mKhN9M3fWRbBemUfPOG69xkQ+ohSrbKm3FsJUeK1iloqBSit+Qm9DLU9nBBAVCrCZWHvLOyQwDTKnx36VtfJ4etrMrqygaH1WXNKBzHDORoJmAFOV/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rSIenmwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rSIenmwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2665E1F00AC4;
	Fri, 31 Jul 2026 20:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785529629;
	bh=5VHnpe3FL7rg/AiAR5aYmqYcm+0NlC5kAyCqrzF5v7s=;
	h=Date:To:From:Subject;
	b=rSIenmwgQb2WA1UcvUYrv7qzNBLjCHhuLXvFcznURfm1vTUbtKECnb//JI8Bcgizn
	 mdjHPTaTB2LiGYe6vynBazQWY864QYyASPc7r66clNF00CbNljb1tET3dfCQe26eO7
	 XlDj3JeANBQvCsE7mDsDd55YiRMKdgw+Xp0kOuiU=
Date: Fri, 31 Jul 2026 13:27:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,arvind.yadav@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch added to mm-new branch
Message-Id: <20260731202709.2665E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: clear stale mapping after freeing swapcache
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch

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
From: Arvind Yadav <arvind.yadav@intel.com>
Subject: mm/migrate_device: clear stale mapping after freeing swapcache
Date: Tue, 28 Jul 2026 11:58:32 +0530

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap().  When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it use the
mapped-folio path for a folio that is no longer in swapcache.  It can then
operate on swap_space.i_pages with invalid reference accounting,
eventually triggering a folio reference count BUG.

After a successful split, nr still contains the number of pages in the
original large folio, although each resulting page is now a separate
order-0 folio.  Reset nr to 1 so each split folio is processed separately,
including its own swapcache removal and mapping lookup.

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

Link: https://lore.kernel.org/20260728062832.1107127-1-arvind.yadav@intel.com
Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/migrate_device.c~mm-migrate_device-clear-stale-mapping-after-freeing-swapcache
+++ a/mm/migrate_device.c
@@ -1193,6 +1193,13 @@ static void __migrate_device_pages(unsig
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
+
+				/*
+				 * reset nr so that only first after-split folio
+				 * is processed below
+				 */
+				VM_WARN_ON_ONCE(folio_test_large(folio));
+				nr = 1;
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1232,6 +1239,12 @@ static void __migrate_device_pages(unsig
 			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
 			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
 
+			/*
+			 * folio_free_swap() removed the folio from the swap
+			 * cache. Refresh the saved mapping before migration.
+			 */
+			mapping = folio_mapping(folio);
+
 			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
 			if (r)
 				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
_

Patches currently in -mm which might be from arvind.yadav@intel.com are

mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch

