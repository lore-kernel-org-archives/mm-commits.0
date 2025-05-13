Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F04F1EEA28
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119284; cv=none; b=SggqrHkyeUZCmz1QlGyV/nsli+z4g5rU6Kd8iEDFeuxLhLH3rjwzj8BQcvMqyDdOHQiRhe42zZmHklwnO0hydl/Wh+G3uzxF9xHLvqBDIVI9v2ZXaUbVq1oWtSSTBQCveE95oMSqd5z1S5HaJ0lJs1qVd7d3xUYC80+HuILMkg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119284; c=relaxed/simple;
	bh=NxZPEUoJnSaVGAxmNMR+NK0brah4uMpJBE9P9o48lN0=;
	h=Date:To:From:Subject:Message-Id; b=L/xKffATmm4fstJ/IR1hKON/KBs9CxzSmhBLBSwigI4zMh24z2mJtjJ6LaCT3lPICdjQ8GKMngshfyfyH0EJFWFAkB3Enilde2i+fZNiY6h9knQsR8sjqfTpxBv2nCxuX8qGMGx8hk9Sebj42+QDQbXcSqGfYlkW8DtomQloYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLCalQvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLCalQvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BDEC4CEE4;
	Tue, 13 May 2025 06:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119284;
	bh=NxZPEUoJnSaVGAxmNMR+NK0brah4uMpJBE9P9o48lN0=;
	h=Date:To:From:Subject:From;
	b=MLCalQvDNveB1hWxVUgK9OzP0gD2NtihDRojRqteiPf4Ds3LPCd3UWnvmopGzzjjH
	 z8H5MAzH3hk2am3exCQkJggA2gq9HWMcS0zXrApbfAaT3DhJAwrx1GqLZkdtRRGaBN
	 lGKb2MxAzQ7MF2y1SV8iYaZqPgQYyasExTS8Rj3s=
Date: Mon, 12 May 2025 23:54:43 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch removed from -mm tree
Message-Id: <20250513065444.15BDEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, x86: use for_each_valid_pfn() from __ioremap_check_ram()
has been removed from the -mm tree.  Its filename was
     mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm, x86: use for_each_valid_pfn() from __ioremap_check_ram()
Date: Wed, 23 Apr 2025 14:33:41 +0100

Instead of calling pfn_valid() separately for every single PFN in the
range, use for_each_valid_pfn() and only look at the ones which are.

Link: https://lkml.kernel.org/r/20250423133821.789413-6-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/ioremap.c~mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram
+++ a/arch/x86/mm/ioremap.c
@@ -71,7 +71,7 @@ int ioremap_change_attr(unsigned long va
 static unsigned int __ioremap_check_ram(struct resource *res)
 {
 	unsigned long start_pfn, stop_pfn;
-	unsigned long i;
+	unsigned long pfn;
 
 	if ((res->flags & IORESOURCE_SYSTEM_RAM) != IORESOURCE_SYSTEM_RAM)
 		return 0;
@@ -79,9 +79,8 @@ static unsigned int __ioremap_check_ram(
 	start_pfn = (res->start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	stop_pfn = (res->end + 1) >> PAGE_SHIFT;
 	if (stop_pfn > start_pfn) {
-		for (i = 0; i < (stop_pfn - start_pfn); ++i)
-			if (pfn_valid(start_pfn + i) &&
-			    !PageReserved(pfn_to_page(start_pfn + i)))
+		for_each_valid_pfn(pfn, start_pfn, stop_pfn)
+			if (!PageReserved(pfn_to_page(pfn)))
 				return IORES_MAP_SYSTEM_RAM;
 	}
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are


