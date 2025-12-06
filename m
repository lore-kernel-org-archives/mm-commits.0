Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E7A23ED5B
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765056869; cv=none; b=OaRvUVXxe3qRnna8WoY3ZAnj/oqKC+J9O+Ny15o3Uy2MV9cMoOdlXse09jn2rFFaKuTCKrPjCxb5rfOVIS8PPPXPyaxWJjWdnSmk998jZ63fSIembIbQ6n1rguC3iFSXLq1i+apuZcvwLi5q+0XrtCB2AhB36xD5IFBs/GANXtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765056869; c=relaxed/simple;
	bh=THKf0dz4kzIhWZ9V3abSwOrgGg4oJ92EAZY+SQ/0Kfs=;
	h=Date:To:From:Subject:Message-Id; b=BBiyfpDN/9FuNhlUoorBE2GhcTVfCb7ylVJ9tPsVoY8xOf6dbsNKI/k+bqtQZcAVqxW19MUAux77ubDkvSKGSM9on3C54kWm7yKWCLH8xYAqu39PuHkxjM/LvnvWJCijRjMZ53cTER8kf+2L8kO6/8eSUQw65ryTQKM+gSJvdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FLtOh3Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FLtOh3Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4844FC4CEF5;
	Sat,  6 Dec 2025 21:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765056869;
	bh=THKf0dz4kzIhWZ9V3abSwOrgGg4oJ92EAZY+SQ/0Kfs=;
	h=Date:To:From:Subject:From;
	b=FLtOh3VzXrsvtALAqO5OVCLk4Yd4XiofPGmMlOUy8jGHvEaAm8dQhnSi20mZHdbmn
	 qHYaKQw/Gfl1vwwl3iy/Dv8UBpqCBRXM5244t9MTLkhV+3fPAbQ+KYtwwBP0StIapu
	 TpYUra74MK0THrPUGmt6TWci68DJOgZzIXpQPDz8=
Date: Sat, 06 Dec 2025 13:34:28 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch added to mm-unstable branch
Message-Id: <20251206213429.4844FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

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

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

