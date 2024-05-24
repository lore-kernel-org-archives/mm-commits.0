Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713546F06D
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581919; cv=none; b=aUpl2heaCdTVR6Zu78AL+lvOt6bTT7QsLoTuRmnkHNKJpQcs1YtgN7HXNHrFR5IDcuFJ+m2r5is//93rzcBtdIiy5yUi+32MWO3UJ0YncHHuRetIe9s7d0TeqKh3TzZDi37Ege/dAGi0bThFUKFJcvxQ+xMixEW0GqQ/cHbf1bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581919; c=relaxed/simple;
	bh=FJGRTzLe5mFwvcTN9cngZjwy6Jk+S2LMUyO4TFTDIeI=;
	h=Date:To:From:Subject:Message-Id; b=kO6PvEPr0IUj754oH9q3Aoi/3vqOvgM9F0bwxwFMIAmALoXcjTHEK4H4HUtV3jxJyyw5X5XfjqfVaRbPGUw5SWfM2EWldqsCXiDkFDlCOTt5A0PYQFO5ewJQCxbSjWkjkv/z7Efx0uRA62YidtiPNYHhkwXpNEmdHHCtejR21zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XlkUZaJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XlkUZaJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3439EC2BBFC;
	Fri, 24 May 2024 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581919;
	bh=FJGRTzLe5mFwvcTN9cngZjwy6Jk+S2LMUyO4TFTDIeI=;
	h=Date:To:From:Subject:From;
	b=XlkUZaJDY2yNhl53BDdP0ajKfabGF2xeVVWiJRT/0Z13wbe09JcoG6JGn3BCYwKNB
	 sMZPsVNIyHge2zrC8UtVl0no+DDcGyXdF62VS6GQq6djnuss2I2cMAj55b/QLOrI57
	 s55C0bkzw235oiGNwVoY5ojMROQmBGoMJq3U16KA=
Date: Fri, 24 May 2024 13:18:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch added to mm-unstable branch
Message-Id: <20240524201839.3439EC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate_device: use a newfolio in __migrate_device_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch

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

