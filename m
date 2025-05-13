Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C41EF391
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119286; cv=none; b=CE8yNTguFo/FYmJOiA7qO/VgF25TXKbtadG/mQEYLbHb6h9nXrYnlIwSQTpS1g4JBhISLINOxrda1viSQcjXuMXGDnOwIvqP3ICfk1o081JZYUKHDhLBZXoI1pk1ERw6KDx5ri1YjQV++nVVEHRFHxXEq939+wKqvOemUKQyWQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119286; c=relaxed/simple;
	bh=wI/2vKDbd+xyTFfjtYHLkX+5xnlXJmxkXnRFkObBAs0=;
	h=Date:To:From:Subject:Message-Id; b=TyFt+8QT65YoCDn+acetu4ydBtCqY3t5VJnFE5V94jtY6hn5okjcp0Lj3c5IeojOrD3MG/xTxb7VOWBlUYk87hYDNKBN6bE2z+/es00MwLXewk+nNBd4w6vkEMWrwokDQZ68w7DvZ8KAra5vK2BaAENa/je0wOTm8L7Z2xTg7xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YWisMN0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YWisMN0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB18C4CEE4;
	Tue, 13 May 2025 06:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119286;
	bh=wI/2vKDbd+xyTFfjtYHLkX+5xnlXJmxkXnRFkObBAs0=;
	h=Date:To:From:Subject:From;
	b=YWisMN0vzm4vBwnoKTRUTxp+Gl65QeeJm6MS9le0fj7MucyfV/JJ0A/SkjxuZeerm
	 NVzWJVIAK3T7el2OBcURIGiGjxY7N+6Kg7l8cvhInpzg5JhO5D3OiSwemgcJ62AKEs
	 tUlCqmxxg1t3SzAPBsHpPRqNPsH+Cdu/QmAHP3X4=
Date: Mon, 12 May 2025 23:54:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch removed from -mm tree
Message-Id: <20250513065446.7BB18C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: use for_each_valid_pfn() in init_unavailable_range()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm/mm_init: use for_each_valid_pfn() in init_unavailable_range()
Date: Wed, 23 Apr 2025 14:33:43 +0100

Currently, memmap_init initializes pfn_hole with 0 instead of
ARCH_PFN_OFFSET. Then init_unavailable_range will start iterating each
page from the page at address zero to the first available page, but it
won't do anything for pages below ARCH_PFN_OFFSET because pfn_valid
won't pass.

If ARCH_PFN_OFFSET is very large (e.g., something like 2^64-2GiB if the
kernel is used as a library and loaded at a very high address), the
pointless iteration for pages below ARCH_PFN_OFFSET will take a very long
time, and the kernel will look stuck at boot time.

Use for_each_valid_pfn() to skip the pointless iterations.

Link: https://lkml.kernel.org/r/20250423133821.789413-8-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reported-by: Ruihan Li <lrh2000@pku.edu.cn>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Ruihan Li <lrh2000@pku.edu.cn>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range
+++ a/mm/mm_init.c
@@ -851,11 +851,7 @@ static void __init init_unavailable_rang
 	unsigned long pfn;
 	u64 pgcnt = 0;
 
-	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(pageblock_start_pfn(pfn))) {
-			pfn = pageblock_end_pfn(pfn) - 1;
-			continue;
-		}
+	for_each_valid_pfn(pfn, spfn, epfn) {
 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are


