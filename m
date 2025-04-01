Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609D21D3D9
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545897; cv=none; b=LMCJuckHRfOdA2ZK/BsUX0rQAe2C89q4MdboC7QrUGm8vqqp37qPfHRfFa50OV3nBPwk+tH82m3xNuy+i6errIoeqyQdGp/e7BonKmpTiANS+7tU9IUldpC+WIeiAmw9QjcgDOXc7NLIXSlaHiKHtjHxZ2vCntoVQpCn3OAttJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545897; c=relaxed/simple;
	bh=zpeheDaAQuc5gimIQSldv7bDe0OGqWGg4Tj+by8SKVo=;
	h=Date:To:From:Subject:Message-Id; b=uhpB1wsP66XEt3ll9QO+W3xMOagPW4FeT/xdl47M7dtgdXfss47S053ObimHhk+FFcqSUYC/TVJd64vzgDjPLNOdp4j4j3O8AQIZz+iu3tpzfjy+XM7NgcJUVp7/uYzxEEXqVVU0+p4+AylzUe/32MbPMT4w/FolN6ZzBTW3bao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ss0MY5CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ss0MY5CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A83C4CEE8;
	Tue,  1 Apr 2025 22:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545896;
	bh=zpeheDaAQuc5gimIQSldv7bDe0OGqWGg4Tj+by8SKVo=;
	h=Date:To:From:Subject:From;
	b=Ss0MY5CYjrfgEg5Vkk1aqsivJ0O/MsKxFKf4UBCJ2qQ7oFO/qH4JzNvZnEN7nwARY
	 fZnXQjbEVXNdwDehdkJhwfdGzIYjl8l7uzFTfqzvEn4JmM8y2ODoiLpjUIhG+WWcbd
	 IUl/yLOiTO85Sut70EVv/W6KXtKz1y2lkXYJpm0g=
Date: Tue, 01 Apr 2025 15:18:15 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch removed from -mm tree
Message-Id: <20250401221816.24A83C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: change pt parameter of tlb_remove_ptdesc() to struct ptdesc*
has been removed from the -mm tree.  Its filename was
     mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: change pt parameter of tlb_remove_ptdesc() to struct ptdesc*
Date: Tue, 25 Feb 2025 11:45:52 +0800

All callers of tlb_remove_ptdesc() pass it a pointer of struct ptdesc, so
let's change the pt parameter from void * to struct ptdesc * to perform a
type safety check.

Link: https://lkml.kernel.org/r/60bb44299cf2d731df6592e446e7f694054d0dbe.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc
+++ a/include/asm-generic/tlb.h
@@ -493,7 +493,7 @@ static inline void tlb_remove_page(struc
 	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
 
-static inline void tlb_remove_ptdesc(struct mmu_gather *tlb, void *pt)
+static inline void tlb_remove_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt)
 {
 	tlb_remove_table(tlb, pt);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


