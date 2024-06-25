Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BE11DDF8
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719343437; cv=none; b=Pz5LZCiDks1JWIqcRk5fgTHlkUcyr8V9bMkmb/2radl92Bu5dwSDP87Dx6u+OMtJAqmtimQzS82XjkiQV0Pce3A21rVB+5/7J62pLNZFtzuC//RmenGM/+gfY9b35NP4L3Vg9+5Iz/CPY3bsIyNO/tC7YUSYtTieqvJTOsQJ2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719343437; c=relaxed/simple;
	bh=dczsby5Dnerhwc1zJPI8IE1ayXY0g6IJSDRDGULH3DU=;
	h=Date:To:From:Subject:Message-Id; b=QXCiEnzUzbcKg5P0CKSWKsw/zLna9I00RCQvPc9E4Mja8RzawisGJW3uUeH+RyF5fEttYgdEo9UqDqImxp8ce6lXHBI4CZHYBQ3H5BFbVHzoyXEvgxzwMvBlPwNWlIBkyKdQ7fewuS8HBTOLpureMG8EZJVoevZDCnoviHR2MKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pjNhVemv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pjNhVemv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C97DC32782;
	Tue, 25 Jun 2024 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719343436;
	bh=dczsby5Dnerhwc1zJPI8IE1ayXY0g6IJSDRDGULH3DU=;
	h=Date:To:From:Subject:From;
	b=pjNhVemvkTx1a1w1M0MNLboX0u/vTyVdrntD4YwxjlRY81QT4qfUfJ+DIaL6xTDiu
	 4XZBF/+2QcUmGIcO0kPvTxfbNBRmCcINQVwiZATen9409mV5PNIOPh4Ao+yAJM8fZ2
	 zBKv4cie5o3y2i/eDTPCXtOANlX4r6zE9dxUbjn4=
Date: Tue, 25 Jun 2024 12:23:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-folio_ref_freeze-under-xas_lock_irq.patch added to mm-unstable branch
Message-Id: <20240625192356.8C97DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: folio_ref_freeze() under xas_lock_irq()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-folio_ref_freeze-under-xas_lock_irq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-folio_ref_freeze-under-xas_lock_irq.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: migrate: folio_ref_freeze() under xas_lock_irq()
Date: Mon, 24 Jun 2024 22:04:38 -0700 (PDT)

Commit "mm: migrate: split folio_migrate_mapping()" drew attention to
"Note, the folio_ref_freeze() is moved out of xas_lock_irq(), Since the
folio is already isolated and locked during migration, so suppose that
there is no functional change."

That was a mistake.  Freezing a folio's refcount to 0 is much like taking
a spinlock: see how filemap_get_entry() takes rcu_read_lock() then spins
around until the folio is unfrozen.  If the task freezing is preempted (or
calls cond_resched(), as folio_mc_copy() may do), then it risks deadlock:
in my case, one CPU in zap_pte_range() with free_swap_and_cache_nr()
trying to reclaim swap while PTL is held, all the other CPUs in reclaim
spinning for that PTL.

I'm uncertain whether it's necessary for interrupts to be disabled as well
as preemption, but since they have to be disabled for the page cache
migration, it's much the best to do it all together as before.  So revert
to folio_ref_freeze() under xas_lock_irq(): but keep the preliminary
folio_ref_count() check, which does make sense before trying to copy the
folio's data.

Use "expected_count" for the expected count throughout.

Link: https://lkml.kernel.org/r/07edaae7-ea5d-b6ae-3a10-f611946f9688@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   59 +++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

--- a/mm/migrate.c~mm-migrate-folio_ref_freeze-under-xas_lock_irq
+++ a/mm/migrate.c
@@ -400,8 +400,8 @@ static int folio_expected_refs(struct ad
  * 2 for folios with a mapping
  * 3 for folios with a mapping and PagePrivate/PagePrivate2 set.
  */
-static void __folio_migrate_mapping(struct address_space *mapping,
-		struct folio *newfolio, struct folio *folio, int expected_cnt)
+static int __folio_migrate_mapping(struct address_space *mapping,
+		struct folio *newfolio, struct folio *folio, int expected_count)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 	struct zone *oldzone, *newzone;
@@ -415,13 +415,18 @@ static void __folio_migrate_mapping(stru
 		newfolio->mapping = folio->mapping;
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
-		return;
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	oldzone = folio_zone(folio);
 	newzone = folio_zone(newfolio);
 
 	xas_lock_irq(&xas);
+	if (!folio_ref_freeze(folio, expected_count)) {
+		xas_unlock_irq(&xas);
+		return -EAGAIN;
+	}
+
 	/* Now we know that no one else is looking at the folio */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
@@ -456,7 +461,7 @@ static void __folio_migrate_mapping(stru
 	 * old folio by unfreezing to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	folio_ref_unfreeze(folio, expected_cnt - nr);
+	folio_ref_unfreeze(folio, expected_count - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -504,23 +509,19 @@ static void __folio_migrate_mapping(stru
 		}
 	}
 	local_irq_enable();
+
+	return MIGRATEPAGE_SUCCESS;
 }
 
 int folio_migrate_mapping(struct address_space *mapping, struct folio *newfolio,
 			  struct folio *folio, int extra_count)
 {
-	int expected_cnt = folio_expected_refs(mapping, folio) + extra_count;
+	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 
-	if (!mapping) {
-		if (folio_ref_count(folio) != expected_cnt)
-			return -EAGAIN;
-	} else {
-		if (!folio_ref_freeze(folio, expected_cnt))
-			return -EAGAIN;
-	}
+	if (folio_ref_count(folio) != expected_count)
+		return -EAGAIN;
 
-	__folio_migrate_mapping(mapping, newfolio, folio, expected_cnt);
-	return MIGRATEPAGE_SUCCESS;
+	return __folio_migrate_mapping(mapping, newfolio, folio, expected_count);
 }
 EXPORT_SYMBOL(folio_migrate_mapping);
 
@@ -534,16 +535,18 @@ int migrate_huge_page_move_mapping(struc
 	XA_STATE(xas, &mapping->i_pages, folio_index(src));
 	int ret, expected_count = folio_expected_refs(mapping, src);
 
-	if (!folio_ref_freeze(src, expected_count))
+	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
 	ret = folio_mc_copy(dst, src);
-	if (unlikely(ret)) {
-		folio_ref_unfreeze(src, expected_count);
+	if (unlikely(ret))
 		return ret;
-	}
 
 	xas_lock_irq(&xas);
+	if (!folio_ref_freeze(src, expected_count)) {
+		xas_unlock_irq(&xas);
+		return -EAGAIN;
+	}
 
 	dst->index = src->index;
 	dst->mapping = src->mapping;
@@ -660,24 +663,18 @@ static int __migrate_folio(struct addres
 			   struct folio *src, void *src_private,
 			   enum migrate_mode mode)
 {
-	int ret, expected_cnt = folio_expected_refs(mapping, src);
+	int ret, expected_count = folio_expected_refs(mapping, src);
 
-	if (!mapping) {
-		if (folio_ref_count(src) != expected_cnt)
-			return -EAGAIN;
-	} else {
-		if (!folio_ref_freeze(src, expected_cnt))
-			return -EAGAIN;
-	}
+	if (folio_ref_count(src) != expected_count)
+		return -EAGAIN;
 
 	ret = folio_mc_copy(dst, src);
-	if (unlikely(ret)) {
-		if (mapping)
-			folio_ref_unfreeze(src, expected_cnt);
+	if (unlikely(ret))
 		return ret;
-	}
 
-	__folio_migrate_mapping(mapping, dst, src, expected_cnt);
+	ret = __folio_migrate_mapping(mapping, dst, src, expected_count);
+	if (ret != MIGRATEPAGE_SUCCESS)
+		return ret;
 
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
_

Patches currently in -mm which might be from hughd@google.com are

mm-migrate-folio_ref_freeze-under-xas_lock_irq.patch

