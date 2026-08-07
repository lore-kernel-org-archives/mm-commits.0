Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6553B6363
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068115; cv=none; b=LHncASoTiEaoGYaLBqDqoD3JqxNcCPDQsFf6ax4SZiNIezybTjb8aOoeLrXEHRi5pl08wfPgUORz6PcOb6tM0ooftPZthjE2hfnXJmkb1O4TRwwUd56XQp+6im1cgh5paL6+xNWPx1IDc/MM1SIDkez65sgaEzmMkYEcuAHJipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068115; c=relaxed/simple;
	bh=p+1nEKgm76reYEpcCuN1/ZULPqQ8bqwQBvBuSEwnVbE=;
	h=Date:To:From:Subject:Message-Id; b=tMqEXePdsaCivBO0KZb1hzOiIckP+SsIW3r3yrEDTJ071scRPN2t6m80ZKUZOzPKd/hIYiiVYk5pTqi+AO6TQD/ddiciEot+VC0KHGeU1FLekhTVAb5VjAWdpIFR5WjqPlQghmIjDlJvgcOHDT5U08dRtt2sCsCreZLO1s+0am8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9fDQeuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9fDQeuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A161F00A3D;
	Fri,  7 Aug 2026 02:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068113;
	bh=AUihMmx2GswVlNmxugXtt81N0DcQchQM+nxT/tZr7Kg=;
	h=Date:To:From:Subject;
	b=E9fDQeuMmL/onDB13R3lQfMj4gdAuIE9Z2d0PhbQFgukE55srxZinRouWvZfXYAL7
	 FeCnpOt6gRJYFFpUawe7okeWcejLbhkod1gvAZ4obzTSs+m1FPxwFOZxJcOvd7YsNN
	 OM8Zm80jWMS10Q3t46aXMKhAnVrR2/0YrvLzoCpI=
Date: Thu, 06 Aug 2026 19:01:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-unused-can_split_folio.patch removed from -mm tree
Message-Id: <20260807020153.B5A161F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove unused can_split_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-unused-can_split_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: remove unused can_split_folio()
Date: Thu, 16 Jul 2026 11:03:44 +0100

Patch series "mm/huge_memory: drop dead split helper variants".

Two trivial cleanups in the folio split API, found while auditing the
split helpers for the inode UAF fix [1]:

 - can_split_folio() is dead: only the !THP stub remains, no definition
   under CONFIG_TRANSPARENT_HUGEPAGE and no callers. Leftover from an
   earlier cleanup.

 - split_folio_to_list_to_order() has no direct callers; its only user
   is split_folio_to_order(), which always passes a NULL list. Fold it.

No functional change.


This patch (of 2):

can_split_folio() has no callers and no definition under
CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by an
earlier cleanup.  Remove it.

No functional change.

Link: https://lore.kernel.org/20260716100345.473473-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260716100345.473473-2-kirill@shutemov.name
Link: https://lore.kernel.org/linux-mm/aldjhtfVByHDQXe6@thinkstation [1]
Link: https://lore.kernel.org/linux-mm/20260714122344.351895-1-kirill@shutemov.name [2]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-remove-unused-can_split_folio
+++ a/include/linux/huge_mm.h
@@ -642,11 +642,6 @@ thp_get_unmapped_area_vmaflags(struct fi
 	return 0;
 }
 
-static inline bool
-can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	return false;
-}
 static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
_

Patches currently in -mm which might be from kas@kernel.org are


