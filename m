Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5AC217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188480; cv=none; b=WX4H6Ivv8YqtzK54/MUdRZtRmqVhx6zXuMGX84OlJVerS/7fqEsa+IihaAlFKVZfazEmwRA4pFpJqkM/3Z6Vfu71dlXCR76NfQiVrnUZkim+OrD6Tw6U0QN409RvYpEg6D8d74YOUDcoRSkY/B3DQJ+9HSXkUppPRZD7JblMCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188480; c=relaxed/simple;
	bh=NbO1ymeSmKNopPwcBc68SLkx1qmqn68UV21Z8tcNQa4=;
	h=Date:To:From:Subject:Message-Id; b=kGdxxF3twEoebFoHdLbvsPB4c0ZLPuJd7rGe4BnNHy0Pnn20ELnslRyCAePt+/3PgOB+6Dq2ZumRbnQeRpC2//wGC7i0Jsfpy0f4PbEu3211R9LgGRBNEZ92oUzlz9du8ou7tT1PmxDlCAsvq9VrQbRDeQBg1RScdCl14Q5vNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vqOtSyrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vqOtSyrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817F6C4CEEC;
	Mon, 17 Mar 2025 05:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188480;
	bh=NbO1ymeSmKNopPwcBc68SLkx1qmqn68UV21Z8tcNQa4=;
	h=Date:To:From:Subject:From;
	b=vqOtSyrNg9xNPqg/Rbd77xOL65i6QkHSDyprdRxsEJIfEOYgej18fmIIrB3oCVgzb
	 l+G1o25ByBivuGGNI7uc6GGzk6ZU8Xf08H9RzFUz5/oDpWn/a4c1gXHlNa3RlClHz/
	 IDJfdeBvkDkdvbPmJww1XDwTOctTNzrJgDxyjYDA=
Date: Sun, 16 Mar 2025 22:14:40 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch removed from -mm tree
Message-Id: <20250317051440.817F6C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: make dmirror_atomic_map() consume a single page
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: lib/test_hmm: make dmirror_atomic_map() consume a single page
Date: Wed, 26 Feb 2025 14:22:53 +0100

Patch series "mm: cleanups for device-exclusive entries (hmm)", v2.

Some smaller device-exclusive cleanups I have lying around.


This patch (of 5):

The caller now always passes a single page; let's simplify, and return "0"
on success.

Link: https://lkml.kernel.org/r/20250226132257.2826043-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250226132257.2826043-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page
+++ a/lib/test_hmm.c
@@ -706,34 +706,23 @@ static int dmirror_check_atomic(struct d
 	return 0;
 }
 
-static int dmirror_atomic_map(unsigned long start, unsigned long end,
-			      struct page **pages, struct dmirror *dmirror)
+static int dmirror_atomic_map(unsigned long addr, struct page *page,
+		struct dmirror *dmirror)
 {
-	unsigned long pfn, mapped = 0;
-	int i;
+	void *entry;
 
 	/* Map the migrated pages into the device's page tables. */
 	mutex_lock(&dmirror->mutex);
 
-	for (i = 0, pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++, i++) {
-		void *entry;
-
-		if (!pages[i])
-			continue;
-
-		entry = pages[i];
-		entry = xa_tag_pointer(entry, DPT_XA_TAG_ATOMIC);
-		entry = xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
-		if (xa_is_err(entry)) {
-			mutex_unlock(&dmirror->mutex);
-			return xa_err(entry);
-		}
-
-		mapped++;
+	entry = xa_tag_pointer(page, DPT_XA_TAG_ATOMIC);
+	entry = xa_store(&dmirror->pt, addr >> PAGE_SHIFT, entry, GFP_ATOMIC);
+	if (xa_is_err(entry)) {
+		mutex_unlock(&dmirror->mutex);
+		return xa_err(entry);
 	}
 
 	mutex_unlock(&dmirror->mutex);
-	return mapped;
+	return 0;
 }
 
 static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
@@ -803,8 +792,7 @@ static int dmirror_exclusive(struct dmir
 			break;
 		}
 
-		ret = dmirror_atomic_map(addr, addr + PAGE_SIZE, &page, dmirror);
-		ret = ret == 1 ? 0 : -EBUSY;
+		ret = dmirror_atomic_map(addr, page, dmirror);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

