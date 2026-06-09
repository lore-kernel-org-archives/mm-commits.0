Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44C25B0B0
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968140; cv=none; b=K5XxCXdFn9g6wxEG/3EVp9hFLt/66ygY78JW293uAw6Jk1/iu6n0Tmpu3omhnhNBmIOgvvH46v+NSUqklRrhB8aED48pLgXp0lC1UabAs5MFIcpRrcrolt06QattoV04mOCOAoqkTOWlnMZ/gcptI8+g9hYzbV1PLUKaW77clww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968140; c=relaxed/simple;
	bh=u+ae46u3O68BZsT8jjkiSdzQcbuanSo9RiSq8i/975g=;
	h=Date:To:From:Subject:Message-Id; b=ub8UG7lTE1HiywS2CE8aafKJbm5ZRgvRZO3hmRVRUiqiv5bm5PViQMnKkDO9jQuJ4ii1qqU2JPAW2SatS8btIc4PcdPnUbwd84Yx95xuSLa9KeW22ZDK0D0HkyZOXOqSXyRaCGBR/gXEY+DPiPoGtOoR+Repu7VQelJuyL2UNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgMqmYFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgMqmYFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9C1F00893;
	Tue,  9 Jun 2026 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968139;
	bh=79prNOu8Zl+OQ4vnYbmW/HnBR54Hor3Ai1Oxr3zG07Q=;
	h=Date:To:From:Subject;
	b=dgMqmYFmmtmk5CljvcLWzgO5JNqFejPF/ue+Y8qGMp8O1qmb51MdCntUiAGOee47y
	 BmRsOZJEfFSRA/SMvZsByEFkCNIo3PEOlwTMAVrAyw+syK0urFobVK3FB7hMDkJSjl
	 vGz4uLd5Kus6tTWKx62aZHVnklx41ycaXCn9pHeQ=
Date: Mon, 08 Jun 2026 18:22:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-flatten-alloc_anon_folio-retry-loop.patch removed from -mm tree
Message-Id: <20260609012219.01D9C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: flatten alloc_anon_folio() retry loop
has been removed from the -mm tree.  Its filename was
     mm-memory-flatten-alloc_anon_folio-retry-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memory: flatten alloc_anon_folio() retry loop
Date: Wed, 27 May 2026 16:45:15 -0400

alloc_anon_folio() uses a top-level if (folio) that buries the success
path four levels deep.  This makes for awkward long lines and wrapping. 
The next patch will add more code here, so flatten this now to keep things
clean and simple.

The next label is already there, use it for !folio.

No functional change intended.

Link: https://lore.kernel.org/20260527204757.2544958-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/memory.c~mm-memory-flatten-alloc_anon_folio-retry-loop
+++ a/mm/memory.c
@@ -5215,24 +5215,24 @@ static struct folio *alloc_anon_folio(st
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
-				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-				folio_put(folio);
-				goto next;
-			}
-			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
-			return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+			folio_put(folio);
+			goto next;
 		}
+		folio_throttle_swaprate(folio, gfp);
+		/*
+		 * When a folio is not zeroed during allocation
+		 * (__GFP_ZERO not used) or user folios require special
+		 * handling, folio_zero_user() is used to make sure
+		 * that the page corresponding to the faulting address
+		 * will be hot in the cache after zeroing.
+		 */
+		if (user_alloc_needs_zeroing())
+			folio_zero_user(folio, vmf->address);
+		return folio;
 next:
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
 		order = next_order(&orders, order);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


