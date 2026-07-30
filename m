Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCDB3431E6
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439089; cv=none; b=X7qheDa6iO5nh8NpgbDYhsLk1wgUc+Saiya1ABR0XVpnlVx2sj+d9L++FrGtqg/l+eYHErAkHtYWAq5aIzr1OwpN7S3unJW+Oz5BrXIAKN6o6STzKPMIjhEFA6IN/yR6uSe+OcRryEfTFf36YGbY8CQuB0KD5NIQ5MzMRPk4u48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439089; c=relaxed/simple;
	bh=tKGnlsQGW/KZRQOapHglnQLZCPQrN+B4S0lbXv6/MWI=;
	h=Date:To:From:Subject:Message-Id; b=AF35H3Feo4tb4F3NZt1FNnTb4SCQnjdoxRwb70cBxd9hFk4FwYUVuunmXj8AWrRwMN/A0/cPLUbYKKakWRR3Wt6oANfm8iP1qK3eaep78klGXrwOZ+QwhWEoDfAPAixzVNWz2uBRXpwALn6cRRbZeMjt7teLVaIZ4CM6Ja8+Bvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOBKapMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOBKapMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528271F000E9;
	Thu, 30 Jul 2026 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439088;
	bh=gPPKrVq7tZ661+HjSCf1BeqUvrOI3UPROmqV3ynr66o=;
	h=Date:To:From:Subject;
	b=xOBKapMiePRdHaumAkLxIGt2f4otjq0XL6nKttorNtL01NKtzcgu6umCXk5+gM95g
	 eWPnS3Ezbc38mR5sixFNNAVqLpRIcvIMrhwAGtan0SntkcWvMEIga0oc+QDZA6tWF4
	 7tNruhgGYyiKeeAcqs8j0Nqbe1Ze5/8SJ0Zz9gxk=
Date: Thu, 30 Jul 2026 12:18:07 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-add-anon-folio-unmap-dispatcher.patch removed from -mm tree
Message-Id: <20260730191808.528271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add anon folio unmap dispatcher
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-anon-folio-unmap-dispatcher.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: add anon folio unmap dispatcher
Date: Mon, 13 Jul 2026 05:00:48 +0000

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping.  It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Link: https://lore.kernel.org/20260713050050.1017741-6-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/mm/rmap.c~mm-rmap-add-anon-folio-unmap-dispatcher
+++ a/mm/rmap.c
@@ -2172,6 +2172,26 @@ static bool ttu_anon_swapbacked_folio(st
 	return true;
 }
 
+static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	/*
+	 * Store the swap location in the pte.
+	 * See handle_pte_fault() ...
+	 */
+	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+			 folio_test_swapcache(folio)))
+		return false;
+
+	if (!folio_test_swapbacked(folio))
+		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+
+	/* nr_pages > 1 not supported yet */
+	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
+					 pteval);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2349,31 +2369,12 @@ static bool try_to_unmap_one(struct foli
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+			if (!ttu_anon_folio(vma, folio, page, address,
+					    pvmw.pte, pteval, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 				goto walk_abort;
 			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio,
-							     nr_pages)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

