Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B04F306B39
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308398; cv=none; b=IEVZICFfGy5ULffJYCmaGFkJAa1+VsgHQAy4zYhT24PlQcgcFY732PiGZEXx5/RWW6Nyxfl6bWed3zg//8u2KeQhyUnm835sC/oWcUGbWzTxH+zAGAEgBUWEDxrn4jWB2HvszsAoVtJSFY2d0Q2wwbzqD/yPvX/tpnZTQ+6XG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308398; c=relaxed/simple;
	bh=77Sx22SDZcfAl6nENoQ1C1MOGfYH85DwKyARubInOSw=;
	h=Date:To:From:Subject:Message-Id; b=P63XZy1N86jFZ7mT9R2VxPqUqCAgD1Oy5pu5bhoFrZEeq4EjanAE1gpnNK+mvEaUqb1jFvjZjDRtGKmEXA/yQoPu5mRHlSVom5us2tVWSunkrW07EdZLRjKBWSwc9IXHWrrCq4e1c3gy7ruVCKoigPRGGJiiNr0qSc9OUCT8Oec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pyAO8Pew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pyAO8Pew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C7C4CEF5;
	Tue,  9 Dec 2025 19:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308398;
	bh=77Sx22SDZcfAl6nENoQ1C1MOGfYH85DwKyARubInOSw=;
	h=Date:To:From:Subject:From;
	b=pyAO8PewjhWsMtZN86PFj/CYJDXc0gzqFf/N4GViZnHkLkkBQd1CofBMNkMBjcU93
	 rQ+OE9bdSahqJ5Yx1uLCCXcW/cJ32StirL2OaNa0LMYgxXJVLTmFACWTX2HzIXyaBA
	 qlCqC9B2KOoXD3wuK/fNHU/wYLFk5xeYj7TESkmo=
Date: Tue, 09 Dec 2025 11:26:37 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20251209192638.092C7C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Fri, 5 Dec 2025 22:35:57 +0100

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251205213558.2980480-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-two-comments-related-to-huge_pmd_unshare
+++ a/mm/rmap.c
@@ -2016,14 +2016,8 @@ static bool try_to_unmap_one(struct foli
 					flush_tlb_range(vma,
 						range.start, range.end);
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					goto walk_done;
 				}
@@ -2416,14 +2410,8 @@ static bool try_to_migrate_one(struct fo
 						range.start, range.end);
 
 					/*
-					 * The ref count of the PMD page was
-					 * dropped which is part of the way map
-					 * counting is done for shared PMDs.
-					 * Return 'true' here.  When there is
-					 * no other sharing, huge_pmd_unshare
-					 * returns false and we will unmap the
-					 * actual page and drop map count
-					 * to zero.
+					 * The PMD table was unmapped,
+					 * consequently unmapping the folio.
 					 */
 					page_vma_mapped_walk_done(&pvmw);
 					break;
_

Patches currently in -mm which might be from david@kernel.org are


