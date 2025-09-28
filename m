Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1D534BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085530; cv=none; b=mE6BIj3yKFkyv9Azz3tqgMfUooCzL99XyQFB6IuKGONuBZHFI+uW12KrrlyokB9aBNLWUUtvQ6xDG1x376PdaQ/doUVsX58HWONz8Jp2g+cDeKQb/rRf9NCU+GBxcrJ2AUmVZfxmgWd+544Uyuijghc4Pv7Dksv9CQ0TH8m9R0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085530; c=relaxed/simple;
	bh=npgY6ftUMmSW7wTOc0qp/Xl7XIDzIOMu1J40PgrZ22A=;
	h=Date:To:From:Subject:Message-Id; b=UW5nbBCOwZBYyu+j3McAuGABoRkIbI5Lc+T+tr4m4ChSHbs77IjqUXDGBCW30NzwvXGCFDrcuvr9GJg60S5C3YYoJuI8Mqtw6kfEhEryQ/+GtceWFHX0fChlF2QEK/pOH0gYEdxSTdLerDVuNktLIqSj+cEb+lwAoups10utMMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEHIL6Sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEHIL6Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C384BC4CEF0;
	Sun, 28 Sep 2025 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085529;
	bh=npgY6ftUMmSW7wTOc0qp/Xl7XIDzIOMu1J40PgrZ22A=;
	h=Date:To:From:Subject:From;
	b=tEHIL6Svwk0m36IfBSrnW5h6QmGxsi1LEH+WXjdp5R8wzPdMDgQXpAs9OCQmnayrs
	 DOL0p27stAjuJDcALoGlFqFL5+0X2xiTt9EIA71ZwQkG5+hpfw7DaGDhwjX3fbsNKH
	 FT5PKJEv+c8FteZ7LuMuzYJUpSvuYiK/cdrkQyCs=
Date: Sun, 28 Sep 2025 11:52:09 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch removed from -mm tree
Message-Id: <20250928185209.C384BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: mlock large folios in try_to_unmap_one()
has been removed from the -mm tree.  Its filename was
     mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: mlock large folios in try_to_unmap_one()
Date: Tue, 23 Sep 2025 12:07:08 +0100

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios: only do
this for fully mapped folios and under page table lock that protects all
page table entries.

[akpm@linux-foundation.org: s/CROSSSED/CROSSED/]
Link: https://lkml.kernel.org/r/20250923110711.690639-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-mlock-large-folios-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct foli
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,34 @@ static bool try_to_unmap_one(struct foli
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+
+			/*
+			 * Set 'ret' to indicate the page cannot be unmapped.
+			 *
+			 * Do not jump to walk_abort immediately as additional
+			 * iteration might be required to detect fully mapped
+			 * folio an mlock it.
+			 */
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
_

Patches currently in -mm which might be from kas@kernel.org are


