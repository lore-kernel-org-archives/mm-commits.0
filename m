Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F5B46542
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581921; cv=none; b=ryO15r9R07fPyDa45PudUbpl6P10WQnp7m6h0kbON0uWrtlgeoik13Y1LzJCLz026IIXhLSPfWFpTlxjJuavzv3oSTORtmCzYrSlqtYwvEOVzze/QmtkAwVJWg8iBv//1s7Y+6+FUiloWIQqc4d+qddXWkcpcVH1WftU9YE+vnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581921; c=relaxed/simple;
	bh=UtmfmJk8/R+hZYFZ2u8OcEHG3EsFRgSQ6GBl1uJb138=;
	h=Date:To:From:Subject:Message-Id; b=FaurJO/unBJIcjOYVXVvqUWIbMX2qhx9ssQadRqmPSy6ADcD5zN7jtn3RpM+6dhHDdFH4MAdNWW0FhdHmYXZpocHxGfDUp2rKeL0YKW/BmRLfpZs4Jg+3AKqRlmIgE0hUdymE3xg5guWwbamIcspI5Qt3K2nyuflthJw8Kzsh3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nbmlZNOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nbmlZNOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F5FC2BBFC;
	Fri, 24 May 2024 20:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581921;
	bh=UtmfmJk8/R+hZYFZ2u8OcEHG3EsFRgSQ6GBl1uJb138=;
	h=Date:To:From:Subject:From;
	b=nbmlZNOwVQWXVJgGpLRf86XYM4U9EPGTP+NdsAMsfbkZfCbyHWvtBFLUPx4pHpfTO
	 3tTDnp8LTH54s4O0YwU3Pmv+2TyHc4D1imhIuseBd/7n8ukj9HtupOWNM1GptlrPi4
	 ToLX61phUeRsaxSCm9a6C7iB9+ClVwvuPg8XfLJY=
Date: Fri, 24 May 2024 13:18:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch added to mm-unstable branch
Message-Id: <20240524201841.23F5FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: unify migrate folio for MIGRATE_SYNC_NO_COPY
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: unify migrate folio for MIGRATE_SYNC_NO_COPY
Date: Fri, 24 May 2024 13:28:41 +0800

The __migrate_device_pages() won't copy page so MIGRATE_SYNC_NO_COPY
passed into migrate_folio()/migrate_folio_extra(), actually a easy way is
just to call folio_migrate_mapping()/folio_migrate_flags(), converting it
to unify and simplify the migrate device pages, which also remove the only
call for MIGRATE_SYNC_NO_COPY.

Link: https://lkml.kernel.org/r/20240524052843.182275-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy
+++ a/mm/migrate_device.c
@@ -693,7 +693,7 @@ static void __migrate_device_pages(unsig
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
 		struct folio *newfolio, *folio;
-		int r;
+		int r, extra_cnt = 0;
 
 		if (!newpage) {
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
@@ -754,14 +754,15 @@ static void __migrate_device_pages(unsig
 			continue;
 		}
 
+		BUG_ON(folio_test_writeback(folio));
+
 		if (migrate && migrate->fault_page == page)
-			r = migrate_folio_extra(mapping, newfolio, folio,
-						MIGRATE_SYNC_NO_COPY, 1);
-		else
-			r = migrate_folio(mapping, newfolio, folio,
-					  MIGRATE_SYNC_NO_COPY);
+			extra_cnt = 1;
+		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
 		if (r != MIGRATEPAGE_SUCCESS)
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+		else
+			folio_migrate_flags(newfolio, folio);
 	}
 
 	if (notified)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch

