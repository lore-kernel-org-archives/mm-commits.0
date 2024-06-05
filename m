Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684E855E49
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558301; cv=none; b=JJvAw8xCXJWb2LjPcsUT2U+G1Inxg1CDYwGU1yBfVcRK2P0t0tIOR2DXbnwCzo9wW3or3tgjXlWNq4lRsRXaFiqKhdElOpTQmvJYBNZoX8RQx4Q9LE8Pn+niDjY2iGysVmwaDshjn0Uj4xGO+FJnOXYJE8hEOsC2J4cyIKfEXUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558301; c=relaxed/simple;
	bh=NnX4gBPYojo25HLLvZL4pkJ4QRk6hrFAp1l/rbAJ4h4=;
	h=Date:To:From:Subject:Message-Id; b=MHWQPVTwWf0crJ3rD2Rchr/W8IAM4CAHJQbDP+XU2uBgZXhP8ljKxQxRrRF50dIqrauhR9pTau0CKeCw+xT6udSrDPGjf8G2dJzfGtnJhNz39CGgVnLuqqQMcXvgiOCsdh19Wy7Gqa4JKRWiGAVzxthhG0evcs/sF8VbHqpVHQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qE2Rr5SW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qE2Rr5SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8D5C32781;
	Wed,  5 Jun 2024 03:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558301;
	bh=NnX4gBPYojo25HLLvZL4pkJ4QRk6hrFAp1l/rbAJ4h4=;
	h=Date:To:From:Subject:From;
	b=qE2Rr5SW00hTs9LIcpkDLbRRTui2xxjWXuAdp+rLhgR+Syh3aM1PScqhEsUTV2rUu
	 FRofgXbC1CUeiNyq4YkEjwCYut4DheME/f03M/H1U94tpulvUYSeVHD5CT48Lkh0Y1
	 k3xTjAhzOdlh+WyNgmQE1d57RxTcfhoG0iv9+Gto=
Date: Tue, 04 Jun 2024 20:31:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-split-folio_migrate_mapping.patch added to mm-unstable branch
Message-Id: <20240605033140.EB8D5C32781@smtp.kernel.org>
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
Date: Mon, 3 Jun 2024 17:24:36 +0800

The folio refcount check for !mapping and folio_ref_freeze() for mapping
are moved out of the original folio_migrate_mapping(), and there is no
turning back for the new __folio_migrate_mapping(), also update comment
from page to folio.

Note, the folio_ref_freeze() is moved out of xas_lock_irq(), Since the
folio is already isolated and locked during migration, so suppose that
there is no functional change.

Link: https://lkml.kernel.org/r/20240603092439.3360652-4-wangkefeng.wang@huawei.com
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

 mm/migrate.c |   63 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

--- a/mm/migrate.c~mm-migrate-split-folio_migrate_mapping
+++ a/mm/migrate.c
@@ -393,50 +393,36 @@ static int folio_expected_refs(struct ad
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
+static void __folio_migrate_mapping(struct address_space *mapping,
+		struct folio *newfolio, struct folio *folio, int expected_cnt)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 	struct zone *oldzone, *newzone;
-	int dirty;
-	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
 	long entries, i;
+	int dirty;
 
 	if (!mapping) {
-		/* Anonymous page without mapping */
-		if (folio_ref_count(folio) != expected_count)
-			return -EAGAIN;
-
-		/* No turning back from here */
+		/* Anonymous folio without mapping */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
-
-		return MIGRATEPAGE_SUCCESS;
+		return;
 	}
 
 	oldzone = folio_zone(folio);
 	newzone = folio_zone(newfolio);
 
 	xas_lock_irq(&xas);
-	if (!folio_ref_freeze(folio, expected_count)) {
-		xas_unlock_irq(&xas);
-		return -EAGAIN;
-	}
-
-	/*
-	 * Now we know that no one else is looking at the folio:
-	 * no turning back from here.
-	 */
+	/* Now we know that no one else is looking at the folio */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
 	folio_ref_add(newfolio, nr); /* add cache reference */
@@ -452,7 +438,7 @@ int folio_migrate_mapping(struct address
 		entries = 1;
 	}
 
-	/* Move dirty while page refs frozen and newpage not yet exposed */
+	/* Move dirty while folio refs frozen and newfolio not yet exposed */
 	dirty = folio_test_dirty(folio);
 	if (dirty) {
 		folio_clear_dirty(folio);
@@ -466,22 +452,22 @@ int folio_migrate_mapping(struct address
 	}
 
 	/*
-	 * Drop cache reference from old page by unfreezing
-	 * to one less reference.
+	 * Since old folio's refcount freezed, now drop cache reference from
+	 * old folio by unfreezing to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	folio_ref_unfreeze(folio, expected_count - nr);
+	folio_ref_unfreeze(folio, expected_cnt - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
 
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
@@ -518,7 +504,22 @@ int folio_migrate_mapping(struct address
 		}
 	}
 	local_irq_enable();
+}
+
+int folio_migrate_mapping(struct address_space *mapping, struct folio *newfolio,
+			  struct folio *folio, int extra_count)
+{
+	int expected_cnt = folio_expected_refs(mapping, folio) + extra_count;
+
+	if (!mapping) {
+		if (folio_ref_count(folio) != expected_cnt)
+			return -EAGAIN;
+	} else {
+		if (!folio_ref_freeze(folio, expected_cnt))
+			return -EAGAIN;
+	}
 
+	__folio_migrate_mapping(mapping, newfolio, folio, expected_cnt);
 	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(folio_migrate_mapping);
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
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

