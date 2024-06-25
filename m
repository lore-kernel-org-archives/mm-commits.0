Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABD114386D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291573; cv=none; b=geowNK0pdsFzpakStR8qg6syB44HhsQXzT0r0KR6udOCVLxmWfp6T2a6WeDKonnIWb5yYJQp1klBaX6Qd0I0XC5wjPQHCGWHQMs0qlzIeZvGjonsz+VJwnfdlyCLCcobSpIzD+/RfmMabcuqQ9NwqaxGct6mqNtHw/a+2I06Yqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291573; c=relaxed/simple;
	bh=UAw4OhI1Z/0xAquczYS8xRsqWB30TNv0sm5RNSBOkP8=;
	h=Date:To:From:Subject:Message-Id; b=paKx5za500pJmt2thaQEeLjg50ixYSL1l/5G7HocsDJmLH5iMBDwcZCPgkpHcx0tS2ffw1zXEt/vo2Gmfv4d+apDeZnIASDAkkN+0QFCILTvZN8Krab7KVNWt+azBgJQ8nlOYXO0E73/PiZZEu3KJ4IpFCR7J1sB+5CuzZiDJOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zx8hYJyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zx8hYJyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08877C32782;
	Tue, 25 Jun 2024 04:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291573;
	bh=UAw4OhI1Z/0xAquczYS8xRsqWB30TNv0sm5RNSBOkP8=;
	h=Date:To:From:Subject:From;
	b=zx8hYJyfn3HFVBbkmGh3XdhIBXa0UMMiKpWTfuQvw9AmJG3B0iWZrPhTRUomG5mKg
	 l2ktQHfSCaarUgYPY4URTihOtUS+1asP8sm1Av6+iwkesZOmGdRInYfwbPQNHwTOOn
	 9LgqBElYZ+IhIkqx7LRK+K4M/IThyHF2X0FXhtAM=
Date: Mon, 24 Jun 2024 21:59:32 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-update_mmu_tlb_range-to-simplify-code.patch removed from -mm tree
Message-Id: <20240625045933.08877C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use update_mmu_tlb_range() to simplify code
has been removed from the -mm tree.  Its filename was
     mm-use-update_mmu_tlb_range-to-simplify-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4457,7 +4457,6 @@ static vm_fault_t do_anonymous_page(stru
 	vm_fault_t ret = 0;
 	int nr_pages = 1;
 	pte_t entry;
-	int i;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -4527,8 +4526,7 @@ static vm_fault_t do_anonymous_page(stru
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


