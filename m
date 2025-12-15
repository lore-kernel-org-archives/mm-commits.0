Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C13326D4F
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 21:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765835544; cv=none; b=cWRMvN9LzJbZguWyDcUjf5XaG8kGTrRsrf//B+xXltJTcJiJEjt9r69SqJstlGxOpKqMhVxhzxPrKQVHtYd4fZPXcxTDx29Qps+Y4Y7YLYrrW3y+kJBTRNcKfs95P+iO5hotWAgNyuMEyMBXdQEo/iXYhlRrN8PAD/jUovJ/5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765835544; c=relaxed/simple;
	bh=oA4qVY9anGdqlgzfxmxFErqP/jG5PEJMRHJDLgICyaY=;
	h=Date:To:From:Subject:Message-Id; b=XHVi1+cvZe0IYt1e401pQ5yAZTPfEymO1sU0YNCDX5Mj/TMFd7ms8wPeah/WhulV/Up1iIfqRukGdqO+nRnH2V9yQEwZXItIcCw+psQSbQOcso1OCxwIrJ68XDIm1axe8URDg3JuYWT1Or2jPE2nCRtDncNahrg9+pCT3+RrSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qi7043nE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qi7043nE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289DEC4CEF5;
	Mon, 15 Dec 2025 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765835544;
	bh=oA4qVY9anGdqlgzfxmxFErqP/jG5PEJMRHJDLgICyaY=;
	h=Date:To:From:Subject:From;
	b=qi7043nEbntzho/e0dHdxyHXY4RtC+2Uw/Kw1g4eDNzcqrkm2fD3+OJDHjjA6IpMg
	 Y0EPC0DYpmciGfBjz9VWdyBl1nJmYSQi6UcPLz747yVfwdbJ2AUpbxIiRuLiXxk6xr
	 oOCk16x6iSLCJS6jrDIdXDj4O3w9fDDQlwT0IZYU=
Date: Mon, 15 Dec 2025 13:52:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,harry.yoo@oracle.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch added to mm-new branch
Message-Id: <20251215215224.289DEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Fri, 12 Dec 2025 08:10:18 +0100

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251212071019.471146-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
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

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

