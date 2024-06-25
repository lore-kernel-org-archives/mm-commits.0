Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082713D244
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291598; cv=none; b=Mt6J5G32NCXnP7FGIWBMyg1TFhM+re1Q975HkmUffwR/eupUG400r83NIUviu22zsOsDcrIWBjOXQ50slZB2jU2+mXV+2YDiejzyW2SeRA+aHJlkfMOXTsSUilNsUwV/PrM4R8OyJqZhBUjPXsG1MynnSHPJrML+UbDuWGd3M5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291598; c=relaxed/simple;
	bh=tOlMF8AlUFEfmEsTI8Ym2DcRsrEnNi19t3gAe47cRHY=;
	h=Date:To:From:Subject:Message-Id; b=J9UiyMDlJVZAcHMsh/Gd9CV0SiyuKT1hLYtQqBBYyKksQkgsgockWkW1xtb3XStCbDwKV5PwT5EPTqm+kEsGqhch3q7jLR/6xPLROTt2JjdHkR+RpEfYjWdq5cheZew4wWZ/unpfhpHqB0ZeMf8fegqUL6+E/xKOSSlL6o/kt28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xsq+ZafA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xsq+ZafA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1373C32782;
	Tue, 25 Jun 2024 04:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291597;
	bh=tOlMF8AlUFEfmEsTI8Ym2DcRsrEnNi19t3gAe47cRHY=;
	h=Date:To:From:Subject:From;
	b=Xsq+ZafAsW1pLwHL/+jAtJkL/21lykM36MJsjfgZXtgKC2tyFqV4jCHPd2mNtUwrB
	 +MZuhdCKiunSHPs9dWOE6JFHg4902lFf9S5XDMKJyw+DtufgYa4CGRYDWzlQHs2UFN
	 OSQnSQ9Tsy2iqydbqKBKsTymeOixcrQDesExAdYs=
Date: Mon, 24 Jun 2024 21:59:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch removed from -mm tree
Message-Id: <20240625045957.C1373C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate_device: use a newfolio in __migrate_device_pages()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate_device: use a newfolio in __migrate_device_pages()
Date: Fri, 24 May 2024 13:28:40 +0800

Use a newfolio instead of newpage and convert to more folio api in
__migrate_device_pages().

Link: https://lkml.kernel.org/r/20240524052843.182275-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-a-newfolio-in-__migrate_device_pages
+++ a/mm/migrate_device.c
@@ -692,7 +692,7 @@ static void __migrate_device_pages(unsig
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
-		struct folio *folio;
+		struct folio *newfolio, *folio;
 		int r;
 
 		if (!newpage) {
@@ -727,11 +727,12 @@ static void __migrate_device_pages(unsig
 			continue;
 		}
 
+		newfolio = page_folio(newpage);
 		folio = page_folio(page);
 		mapping = folio_mapping(folio);
 
-		if (is_device_private_page(newpage) ||
-		    is_device_coherent_page(newpage)) {
+		if (folio_is_device_private(newfolio) ||
+		    folio_is_device_coherent(newfolio)) {
 			if (mapping) {
 				/*
 				 * For now only support anonymous memory migrating to
@@ -745,7 +746,7 @@ static void __migrate_device_pages(unsig
 					continue;
 				}
 			}
-		} else if (is_zone_device_page(newpage)) {
+		} else if (folio_is_zone_device(newfolio)) {
 			/*
 			 * Other types of ZONE_DEVICE page are not supported.
 			 */
@@ -754,11 +755,11 @@ static void __migrate_device_pages(unsig
 		}
 
 		if (migrate && migrate->fault_page == page)
-			r = migrate_folio_extra(mapping, page_folio(newpage),
-						folio, MIGRATE_SYNC_NO_COPY, 1);
+			r = migrate_folio_extra(mapping, newfolio, folio,
+						MIGRATE_SYNC_NO_COPY, 1);
 		else
-			r = migrate_folio(mapping, page_folio(newpage),
-					folio, MIGRATE_SYNC_NO_COPY);
+			r = migrate_folio(mapping, newfolio, folio,
+					  MIGRATE_SYNC_NO_COPY);
 		if (r != MIGRATEPAGE_SUCCESS)
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
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

