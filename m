Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D54E1E4AB;
	Sat,  6 Dec 2025 21:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765056865; cv=none; b=IOg/8BUIwCa2yZw3ygR8s7cvTTq8rE4aEx5Q/NTtxu9AkMC4Qiqzqg+74KOkFXukv0sAgvY0oAhvAQpCwOZSoYPZ8wAU9GXIpzAiKUFqBOb+xz/R6ZCa4f4EU3Xh8y5kiFxBFLe/HuauuB5YqFeMjWtGkUtsdmXnBVSRLuY+sBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765056865; c=relaxed/simple;
	bh=tBeyITH1VhVYoB66IapqOPklnMrBVDBodhKYn6Q0DQo=;
	h=Date:To:From:Subject:Message-Id; b=qdcusj0ApGquQQW7SpAOx4PPiUXW5eDfDPI8ro1A8jcn4zxPWHiWihKZi6Kk2q5lN3c6eyQLggBIHg9pixxr5MnCWfOl/MVy/uV/yw7aeCmDMVS+yEgP7UMq4EbSNHVRXqHi3wZxNpSkLLPO/En7IUlJO8/iXr1+EB5AxVmk59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BERthox5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BERthox5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807F5C4CEF5;
	Sat,  6 Dec 2025 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765056864;
	bh=tBeyITH1VhVYoB66IapqOPklnMrBVDBodhKYn6Q0DQo=;
	h=Date:To:From:Subject:From;
	b=BERthox5JtO5c6+KoqKNIERuZJgU+xsKMkK7MhPZQd17V5KVQXN56q5G5/gNaLDmn
	 ZSTvFEtTZAXDmUPd+Lk2is1dWISi8klBKj9ulQIMSovRq79QWlnAtE5/lTnBDsGnLa
	 697v77hsch8wMtYqsZdK/oodbke1X0xk/OfxvKmU=
Date: Sat, 06 Dec 2025 13:34:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,suschako@amazon.de,stable@vger.kernel.org,riel@surriel.com,prakash.sangappa@oracle.com,peterz@infradead.org,osalvador@suse.de,npiggin@gmail.com,nadav.amit@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,arnd@arndb.de,aneesh.kumar@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugetlb_pmd_shared.patch added to mm-unstable branch
Message-Id: <20251206213424.807F5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix hugetlb_pmd_shared()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-hugetlb_pmd_shared.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugetlb_pmd_shared.patch

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
Subject: mm/hugetlb: fix hugetlb_pmd_shared()
Date: Fri, 5 Dec 2025 22:35:55 +0100

Patch series "mm/hugetlb: fixes for PMD table sharing (incl.  using
mmu_gather)".

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point. 
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily.  At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.  Read:
complicated

I added as much comments + description that I possibly could, and I am
hoping for review from Jann.

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86.  But that's all out of scope for this series.


This patch (of 4):

We switched from (wrongly) using the page count to an independent shared
count.  Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to identify
sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are not
exclusive.  In smaps we would account them as "private" although they are
"shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Link: https://lkml.kernel.org/r/20251205213558.2980480-1-david@kernel.org
Link: https://lkml.kernel.org/r/20251205213558.2980480-2-david@kernel.org
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [1]
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-hugetlb_pmd_shared
+++ a/include/linux/hugetlb.h
@@ -1326,7 +1326,7 @@ static inline __init void hugetlb_cma_re
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
_

Patches currently in -mm which might be from david@kernel.org are

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

