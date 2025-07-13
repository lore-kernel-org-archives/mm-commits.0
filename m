Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E301EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450039; cv=none; b=ftZgwdMg6dChNyEedRoq+gulTRSiXVB+kzJa9pplyHGmRX4rVWiJZfMBB8GCEb5z3nwNH7FYDKI9r92gPiB0bagL+hzKLi9/hyzgm4EZf5mRGVxojB+2ZDL3nna7XqjtWJbKdBWkHRzj3TTCzQss5G2qprSABEoGl1CX3vUoEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450039; c=relaxed/simple;
	bh=VurB9vMxXYxMQ/2No98nLtYeVXTRElL/JPH16wGZzk4=;
	h=Date:To:From:Subject:Message-Id; b=nf88wCHP0l7IS4BCaFDKpBLOeNoY3c1dUtA0ytNtOdgGTnXmUuYS3WeGGgKmeRo3pMFuDy+jQmpAV8EGpMZfLCDqZwHw3gl7L1MqCrRjyaH6MmdGwW1vQylkl0kCgBZCqYreDxAOMxk6KFEYUGfrDKm5wODT7txztUmHZPBnMv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+xrbf4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+xrbf4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86724C4CEE3;
	Sun, 13 Jul 2025 23:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450039;
	bh=VurB9vMxXYxMQ/2No98nLtYeVXTRElL/JPH16wGZzk4=;
	h=Date:To:From:Subject:From;
	b=M+xrbf4b2EHiycYiRxm9tx+Id4ogC6Y6fYMACvevGkcDIPxoW0oyDBiX4SbP0ziKN
	 YLxRNfZR3KYMqBDzROQ+zec8cWMPZqEju7YR3PgJwcNonjSsV+p6/LkE3xraYQ4vz5
	 WyyEma5Sd/qHayD75wUOZkhCk+FSQaUAirSs6l8g=
Date: Sun, 13 Jul 2025 16:40:39 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch removed from -mm tree
Message-Id: <20250713234039.86724C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,hugetlb: rename anon_rmap to new_anon_folio and make it boolean
has been removed from the -mm tree.  Its filename was
     mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: rename anon_rmap to new_anon_folio and make it boolean
Date: Mon, 30 Jun 2025 16:42:10 +0200

anon_rmap is used to determine whether the new allocated folio is
anonymous.  Rename it to something more meaningul like new_anon_folio and
make it boolean, as we use it like that.

While we are at it, drop 'new_pagecache_folio' as 'new_anon_folio' is
enough to check whether we need to restore the consumed reservation.

Link: https://lkml.kernel.org/r/20250627102904.107202-4-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean
+++ a/mm/hugetlb.c
@@ -6406,17 +6406,16 @@ static bool hugetlb_pte_stable(struct hs
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
+	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
+	bool new_folio, new_anon_folio = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
-	int anon_rmap = 0;
-	unsigned long size;
+	bool folio_locked = true;
 	struct folio *folio;
+	unsigned long size;
 	pte_t new_pte;
-	bool new_folio, new_pagecache_folio = false;
-	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool folio_locked = true;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6515,10 +6514,9 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = VM_FAULT_SIGBUS;
 				goto out;
 			}
-			new_pagecache_folio = true;
 		} else {
+			new_anon_folio = true;
 			folio_lock(folio);
-			anon_rmap = 1;
 		}
 	} else {
 		/*
@@ -6567,7 +6565,7 @@ static vm_fault_t hugetlb_no_page(struct
 	if (!pte_same(huge_ptep_get(mm, vmf->address, vmf->pte), vmf->orig_pte))
 		goto backout;
 
-	if (anon_rmap)
+	if (new_anon_folio)
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
@@ -6586,7 +6584,7 @@ static vm_fault_t hugetlb_no_page(struct
 		 * No need to keep file folios locked. See comment in
 		 * hugetlb_fault().
 		 */
-		if (!anon_rmap) {
+		if (!new_anon_folio) {
 			folio_locked = false;
 			folio_unlock(folio);
 		}
@@ -6622,7 +6620,8 @@ out:
 backout:
 	spin_unlock(vmf->ptl);
 backout_unlocked:
-	if (new_folio && !new_pagecache_folio)
+	/* We only need to restore reservations for private mappings */
+	if (new_anon_folio)
 		restore_reserve_on_error(h, vma, vmf->address, folio);
 
 	folio_unlock(folio);
_

Patches currently in -mm which might be from osalvador@suse.de are


