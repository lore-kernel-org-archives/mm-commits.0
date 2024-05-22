Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF8182B9
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400847; cv=none; b=oEFh6x1RsP2q7fvPI8alGC1Z/tNIKuOPIu3r7c7VGZP0bp9stbNBfq64eMvKiUckBkCQcuyLk61h8A6pdU9PHKK22zwh0fC9BONSHL7tnKRn2bIuYr4fyH/9ylhqmx963kgwIhYeykouNSmjl7F7rLX1MxbOigMWRZRINDZeGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400847; c=relaxed/simple;
	bh=ylgRNqg6IOHl6ClJCQ8NSpofQe83bqdOQ6BxyyzbKbA=;
	h=Date:To:From:Subject:Message-Id; b=GLXxp8mW+xpbcmvqHBkyGoq2FqI6fAk3qzKeWCWjEOGq85XMTI9b8X6hbng1SMEsuNetR5K1/tbEgHwhkP2YODF2fLs4KUYngjKF0K13bOH+M/w8QLs24TV7GpblxErc3VwXPTmQdinE51jO0kWu98QusfJ9kcsQz/scKna2zqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOrwAvTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOrwAvTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E1C2BBFC;
	Wed, 22 May 2024 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400846;
	bh=ylgRNqg6IOHl6ClJCQ8NSpofQe83bqdOQ6BxyyzbKbA=;
	h=Date:To:From:Subject:From;
	b=KOrwAvTVGH5SZSzvpQipgz1bBGnXrLNwkK4BkHh4Lgghn0hlhdRwlbRNEkVOzcvkE
	 LTgz+bOfE+yZDzYDQqa37yzJGYalDnxQCzrXWmE+5PSDo3zd2LLv3koewCJte28YU2
	 /4NVhYsqd3yxKidNJryims2hCbxI1APIIENv9h5Q=
Date: Wed, 22 May 2024 11:00:45 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-update_mmu_tlb_range-to-simplify-code.patch added to mm-unstable branch
Message-Id: <20240522180046.777E1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use update_mmu_tlb_range() to simplify code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-update_mmu_tlb_range-to-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-update_mmu_tlb_range-to-simplify-code.patch

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
From: "Bang Li" <libang.li@antgroup.com>
Subject: mm: use update_mmu_tlb_range() to simplify code
Date: Wed, 22 May 2024 14:12:04 +0800

Let us simplify the code by update_mmu_tlb_range().

Link: https://lkml.kernel.org/r/20240522061204.117421-4-libang.li@antgroup.com
Signed-off-by: Bang Li <libang.li@antgroup.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-use-update_mmu_tlb_range-to-simplify-code
+++ a/mm/memory.c
@@ -4463,7 +4463,6 @@ static vm_fault_t do_anonymous_page(stru
 	vm_fault_t ret = 0;
 	int nr_pages = 1;
 	pte_t entry;
-	int i;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -4533,8 +4532,7 @@ static vm_fault_t do_anonymous_page(stru
 		update_mmu_tlb(vma, addr, vmf->pte);
 		goto release;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		for (i = 0; i < nr_pages; i++)
-			update_mmu_tlb(vma, addr + PAGE_SIZE * i, vmf->pte + i);
+		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
 		goto release;
 	}
 
_

Patches currently in -mm which might be from libang.li@antgroup.com are

mm-add-update_mmu_tlb_range.patch
mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch
mm-use-update_mmu_tlb_range-to-simplify-code.patch

