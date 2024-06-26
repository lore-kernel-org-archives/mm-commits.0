Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEEE193065
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719432534; cv=none; b=RG9v+GF5s5BYAB8sM5+Q/wNj8pW96Xo7CADaBrZgUF8nqHTU42Y0pRsm4csIqngAR2ir7Emqd4A34LthoUsQ16A6n3hBIdDXotVAGDet1tEinyL7Oh9LtyTmcHC7hLHOxaewE86uX6wF6ADa4IImf0vZ/mw3LFKG6+f4BbcWmOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719432534; c=relaxed/simple;
	bh=6/sFxhNrXEwnONRO3o3ApA3o93MfSxjrHjwN4Cl4rFM=;
	h=Date:To:From:Subject:Message-Id; b=nRYGDDlicEc45gXNGRiPGk4bbIot/bxWqhGBr7wY5qzmgj1ZGTP2fRjh6RLXS853mRXN+EqUbv4UcmYnjhrLQNVkLrZZAu42POY54pw1NXWx+UPeTxpKlU4WaBHuqYPE6ibPKZE5ZvCEAN/iq/otRoU1QvjYtTEIaMVhBid0Kkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TFZYIViN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TFZYIViN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6393C116B1;
	Wed, 26 Jun 2024 20:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719432533;
	bh=6/sFxhNrXEwnONRO3o3ApA3o93MfSxjrHjwN4Cl4rFM=;
	h=Date:To:From:Subject:From;
	b=TFZYIViNFbK9QXO/RLH3/I+Nl90D9mVfoTVgjqE1OWjEwVLvgP1ys9e3lKy0p107R
	 LXpQEG4CEpoQV8hxNn6/6+/dRokhmSm9CgVhsuYMIFbhhXZRc4s7OkvisW46NiQwU4
	 +yQzSpvdobnIJGJ7eTcF7ps4caw59pCnFTVFlRsI=
Date: Wed, 26 Jun 2024 13:08:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-split-folio_migrate_mapping.patch added to mm-unstable branch
Message-Id: <20240626200853.B6393C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: split folio_migrate_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-split-folio_migrate_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-split-folio_migrate_mapping.patch

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
Subject: mm: migrate: split folio_migrate_mapping()
Date: Wed, 26 Jun 2024 16:53:25 +0800

The folio refcount check is moved out for both !mapping and mapping folio,
also update comment from page to folio for folio_migrate_mapping().

No functional change intended.

Link: https://lkml.kernel.org/r/20240626085328.608006-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

--- a/mm/migrate.c~mm-migrate-split-folio_migrate_mapping
+++ a/mm/migrate.c
@@ -393,29 +393,24 @@ static int folio_expected_refs(struct ad
 }
 
 /*
- * Replace the page in the mapping.
+ * Replace the folio in the mapping.
  *
  * The number of remaining references must be:
- * 1 for anonymous pages without a mapping
- * 2 for pages with a mapping
- * 3 for pages with a mapping and PagePrivate/PagePrivate2 set.
+ * 1 for anonymous folios without a mapping
+ * 2 for folios with a mapping
+ * 3 for folios with a mapping and PagePrivate/PagePrivate2 set.
  */
-int folio_migrate_mapping(struct address_space *mapping,
-		struct folio *newfolio, struct folio *folio, int extra_count)
+static int __folio_migrate_mapping(struct address_space *mapping,
+		struct folio *newfolio, struct folio *folio, int expected_count)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 	struct zone *oldzone, *newzone;
 	int dirty;
-	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
 	long entries, i;
 
 	if (!mapping) {
-		/* Anonymous page without mapping */
-		if (folio_ref_count(folio) != expected_count)
-			return -EAGAIN;
-
-		/* No turning back from here */
+		/* Anonymous folio without mapping, no turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
 		if (folio_test_swapbacked(folio))
@@ -452,7 +447,7 @@ int folio_migrate_mapping(struct address
 		entries = 1;
 	}
 
-	/* Move dirty while page refs frozen and newpage not yet exposed */
+	/* Move dirty while folio refs frozen and newfolio not yet exposed */
 	dirty = folio_test_dirty(folio);
 	if (dirty) {
 		folio_clear_dirty(folio);
@@ -466,7 +461,7 @@ int folio_migrate_mapping(struct address
 	}
 
 	/*
-	 * Drop cache reference from old page by unfreezing
+	 * Drop cache reference from old folio by unfreezing
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
@@ -477,11 +472,11 @@ int folio_migrate_mapping(struct address
 
 	/*
 	 * If moved to a different zone then also account
-	 * the page for that zone. Other VM counters will be
+	 * the folio for that zone. Other VM counters will be
 	 * taken care of when we establish references to the
-	 * new page and drop references to the old page.
+	 * new folio and drop references to the old folio.
 	 *
-	 * Note that anonymous pages are accounted for
+	 * Note that anonymous folios are accounted for
 	 * via NR_FILE_PAGES and NR_ANON_MAPPED if they
 	 * are mapped to swap space.
 	 */
@@ -521,6 +516,17 @@ int folio_migrate_mapping(struct address
 
 	return MIGRATEPAGE_SUCCESS;
 }
+
+int folio_migrate_mapping(struct address_space *mapping,
+		struct folio *newfolio, struct folio *folio, int extra_count)
+{
+	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
+
+	if (folio_ref_count(folio) != expected_count)
+		return -EAGAIN;
+
+	return __folio_migrate_mapping(mapping, newfolio, folio, expected_count);
+}
 EXPORT_SYMBOL(folio_migrate_mapping);
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

