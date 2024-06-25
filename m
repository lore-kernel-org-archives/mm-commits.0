Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA613D244
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291599; cv=none; b=I/SkR0wKqDH+Kg3ConE/mO+ypvhu1gb4U/Xtn1Bxr4XQzJGHR63CpJXtfO73Fjjhdx42kqTsrBp4SCyh1oU8Sj7CdxmDkGwMoecgyinAoNHsZaKFGSsc3AJJb2gyc4y0cot2uIEENbauzpAlcO7TVxtkSedVbNXOi7ZjUHyqkJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291599; c=relaxed/simple;
	bh=7H7fy2pD6+f6euUCnZn/fZN+sSTbH6n4K4jNUbTbHw4=;
	h=Date:To:From:Subject:Message-Id; b=YTmOMA9y7k3WO1f4XOxTlwibJLdzaDkTvkRJCmeqZ6r37DlHPYWAiOQbUqpaxXOghgquTN57FXsBytIHKWOYmDm7Krde0h6PLD3gRJzoAQlxIjhCav/O07XbF0AihPMoOYEvzAQABia4ihtpRj9/itOR+ra8Jt2XBF2s5UPKpbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AH14oGti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AH14oGti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE6C32782;
	Tue, 25 Jun 2024 04:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291599;
	bh=7H7fy2pD6+f6euUCnZn/fZN+sSTbH6n4K4jNUbTbHw4=;
	h=Date:To:From:Subject:From;
	b=AH14oGtif67ink3Q3Zj31atX7Kbpk649Q6p+tl9RN1ZTOPMcIDvpJVrg9z968ve5e
	 M3ffdVdbxtJdx0+mRV2Ve9+20bXLz2JoXUrgpLPGU87KVYG8MuDp0GSKm2jB1iKNoM
	 97IUIn9PcmaCadL+kF32XPevn2pkKDh6rE2QYb8o=
Date: Mon, 24 Jun 2024 21:59:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch removed from -mm tree
Message-Id: <20240625045958.E9BE6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: unify migrate folio for MIGRATE_SYNC_NO_COPY
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

