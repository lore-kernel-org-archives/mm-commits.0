Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226223C13F1
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896815; cv=none; b=AbB/1riOZAX2SmXWSKUV7FugE/LGsJR2OWvMJB7/zc2u9H58t+Arp6a8eX9RM+j9PZ+yeFOud2QT1DXxzkB/r2PbQVzFKhbJL5P9dc9FS4Xp8KcUH2ciY0knLRhHBFjwtqfaCizCS8nTqM0I+QLq8E76C9MJdft0nb9k/z+Aeoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896815; c=relaxed/simple;
	bh=u/xLT/Hq+oBMEYN1cdfb7ht3cTGC4aa15G0opNrJUB4=;
	h=Date:To:From:Subject:Message-Id; b=N17iRYIPPi3GT/tHy42XVNIH9eqQqRMwup+oaIzWlO11yeZMU8JarW1QIPx4ge0ZCrZOG9lrARMbc0WpQUE7n5k5brW1V2WXsyEFxJofLbieGAU/RolxVnq0aKuzklNIAcNysUhFdUkFSsSWbUNO9hA4EYA6tmHmCdRIOzb7jZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWWJors2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWWJors2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8B31F000E9;
	Wed,  5 Aug 2026 02:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896814;
	bh=FLfspudF1pUumFpcXmJLnrsPeEPMYekUjICSWL0Gsqk=;
	h=Date:To:From:Subject;
	b=eWWJors2thSoNbLjblzfQ/mnOj7C6A6XBZunmsSXL65ztooYK8vCEqxOlzEm8kJin
	 LWXey3qZZLj7I1vF0X7jSYyel9T0FZe3qM33YlhjWi8Zwxdc34qRfvE2CkQKmfjZVH
	 8TMHKQCBgnT96lD7Pi9W8ZC/k1tMxBf9vfTyEgqM=
Date: Tue, 04 Aug 2026 19:26:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-anon-folio-unmap-dispatcher.patch removed from -mm tree
Message-Id: <20260805022653.DF8B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add anon folio unmap dispatcher
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-anon-folio-unmap-dispatcher.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: add anon folio unmap dispatcher
Date: Thu, 30 Jul 2026 09:45:56 +0000

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping.  It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Link: https://lore.kernel.org/20260730094559.418003-6-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

