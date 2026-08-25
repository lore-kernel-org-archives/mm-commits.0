Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1130F55F;
	Tue, 25 Aug 2026 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622813; cv=none; b=kjRku2LdxLfJGGY6JJe9giOTCXMBkGWzNOm+i+Y6M49kwQ2HCln3ClnFSsQ8VpZBer/yN1J+mbCmHEW5hfO4UH3j0L2mUbanaOIR4MhCKe+3cQ+b/gL7kzMkAp093Pwr8rMOeayj5kd9uAPLEMiBa5a8ThgIz4qv4H7jjNQlkAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622813; c=relaxed/simple;
	bh=VjJ4wOoC8f8QXGgv9KrjK2rskdBo36zIvrytzBpdW0U=;
	h=Date:To:From:Subject:Message-Id; b=LRMpmPLmp7M82QGT7goIcpwe0cy0BWCYrinlpK8UZWaJUlRnsotgOml1WY7ZWT93m6Ceu5fxQ8YrH33a8kPXZsICM2koOxUW60GElLgeWJqXKgjeIePVmzzfosezoVy4prPoUPzxeJMxFuncjXemXf/JNXD9EhMiD4zbZJH86TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZhOI3vpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZhOI3vpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA191F000E9;
	Tue, 25 Aug 2026 01:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622810;
	bh=FgbWHf700w7jRwFvlcIjYMbXl7Dc3GrbPYAkt5rujus=;
	h=Date:To:From:Subject;
	b=ZhOI3vpDS6DBZMl7DhZr37cXiQEVH+IqtKx7YG+E+2XVfMDeLMylw4TSbVNfJrClP
	 1e3Kk+OX68YL8PUNRm22NXnc3EhbQeAvwpOALISjLqA8bF3N1cFkrVTdnOmGuA9TAJ
	 Md3NBaO1CiAB5G19PzF8RA2ombT/O3FLSk9vb5i4=
Date: Mon, 24 Aug 2026 18:53:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,arvind.yadav@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch removed from -mm tree
Message-Id: <20260825015330.BAA191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: clear stale mapping after freeing swapcache
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-clear-stale-mapping-after-freeing-swapcache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


