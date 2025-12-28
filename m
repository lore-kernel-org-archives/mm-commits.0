Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA94029C328
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766963485; cv=none; b=JctaJtDVUGoqDxWrrfTraceS+s2EaLwuRLC5+q0rOJ8qm2q+g3urgujnbb8GJA+jBjxWAaeeypo76P+JElQHtueE9j5g2X3fgghkxDXWeu3VnsBtnk78uFN9d/u9WlnZnNb4Lva+kEMl447aQNuqK8YHprccFqvh0X6Un75hEmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766963485; c=relaxed/simple;
	bh=ad/3ydKKwQIIULF31Jusa7h8S+26x2C/kYiqSgHxpFg=;
	h=Date:To:From:Subject:Message-Id; b=fJHOmJnfkT2nksLvl0aOKNVaZd5PbzE1xF7hbFpEzfxCYOTtZGFkJN2w8nk4T0ydCEWRzRT2Rqi3UfSjqe0wrlXCmyhOlfTdg59T8VtElOg4v7Y16WC444oCgMJVE2OlfDM5iajCAq+PbXDOdSTPJeD4YYD/D0/QTgAbQ9oy3Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WxeEW41s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WxeEW41s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286B8C4CEFB;
	Sun, 28 Dec 2025 23:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766963485;
	bh=ad/3ydKKwQIIULF31Jusa7h8S+26x2C/kYiqSgHxpFg=;
	h=Date:To:From:Subject:From;
	b=WxeEW41s6k8t2k+0X5wEbb4HLFjuTjBcqib/FeSfBqavcrn3SPPs9M25fEUKyDj5I
	 K4yJAvEmkh6wCowMck0wIBkFUuaWwwtjZgwIMkMha/wJm+FyhXwqVsY8dcHpNHl3vB
	 e+P3RfCz/AGXwCFUstO77gtx68Bx28cRFQ/8Har4=
Date: Sun, 28 Dec 2025 15:11:24 -0800
To: mm-commits@vger.kernel.org,suschako@amazon.de,riel@surriel.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,lance.yang@linux.dev,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch added to mm-unstable branch
Message-Id: <20251228231125.286B8C4CEFB@smtp.kernel.org>
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

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Tue, 23 Dec 2025 22:40:36 +0100

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251223214037.580860-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
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
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch

