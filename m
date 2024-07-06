Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A84C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292030; cv=none; b=YuX/V7ThJ0lYNvH/cZ6umNvLbDK28BGm3IT+wW2SxVP5x+Xk3Hd1tvE/W274el7A34iP41AfTMZDJVFg2a6Se1gtw6IdOLWg+EUstyCAptfDJorbfkFuDZMyOivJeOuqGEyT5VeutwDTV1TiTOzIDFim9O7E4m7UOAf0RmZH8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292030; c=relaxed/simple;
	bh=LllYzfYbVw88HFV4EVy8SPWnBCdLoGy6UjdjlHvdMzc=;
	h=Date:To:From:Subject:Message-Id; b=E1R6e303UWF6FNmJqVES1EiHE8AW5cmwG1zQ/wW8dy+nm6RRM+bWMNhKyIz+3ZrWOE+8uXro9Nf0PXt9ZoQxIaXRB+mq3rJzzBeR/3MSm/ddKufhxHaKJDKS0Zb/IDlTEoxKLFqUX1ERk09d1KCIps27ArCUaOBBth9Lrg4/Uvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KZj3/mmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KZj3/mmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3098C2BD10;
	Sat,  6 Jul 2024 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292029;
	bh=LllYzfYbVw88HFV4EVy8SPWnBCdLoGy6UjdjlHvdMzc=;
	h=Date:To:From:Subject:From;
	b=KZj3/mmn+nYHe/b6JqUMt8iWD2p/o+qomO0nWWlmNsGvZmuJX5zqXponFy8oOBgB5
	 ue/Wq8NJQBwO/E1HVh0FxRafBFAJuos2hhezBa/HXNSX35y9bLbqnsx4KqM2EYz2vi
	 aO3V54K7Idrv6vxjK+tpYZVuA6D7qryPccmDYrBk=
Date: Sat, 06 Jul 2024 11:53:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-split-folio_migrate_mapping.patch removed from -mm tree
Message-Id: <20240706185349.B3098C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: split folio_migrate_mapping()
has been removed from the -mm tree.  Its filename was
     mm-migrate-split-folio_migrate_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/migrate.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~mm-migrate-split-folio_migrate_mapping
+++ a/mm/migrate.c
@@ -393,28 +393,23 @@ static int folio_expected_refs(struct ad
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
 		/* Take off deferred split queue while frozen and memcg set */
 		if (folio_test_large(folio) &&
 		    folio_test_large_rmappable(folio)) {
@@ -465,7 +460,7 @@ int folio_migrate_mapping(struct address
 		entries = 1;
 	}
 
-	/* Move dirty while page refs frozen and newpage not yet exposed */
+	/* Move dirty while folio refs frozen and newfolio not yet exposed */
 	dirty = folio_test_dirty(folio);
 	if (dirty) {
 		folio_clear_dirty(folio);
@@ -479,7 +474,7 @@ int folio_migrate_mapping(struct address
 	}
 
 	/*
-	 * Drop cache reference from old page by unfreezing
+	 * Drop cache reference from old folio by unfreezing
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
@@ -490,11 +485,11 @@ int folio_migrate_mapping(struct address
 
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
@@ -534,6 +529,17 @@ int folio_migrate_mapping(struct address
 
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


