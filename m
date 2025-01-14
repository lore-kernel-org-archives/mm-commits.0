Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7C1C3BEB
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837131; cv=none; b=dC2exXfNG3O5OxhlBdpn1ffDFcteCfiYiOftG4R00OLPzTWjYjB0ftfpOQ0B0gnFXnEJWVGu1lRgFRFB437uoq8IdefCnXVt72SbglJkLE8d//oFbHCWEAYtfAZpc+ywWZLJdLY9zsF4o4tyy6LbObJQZteVxBoofkXajvl9n9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837131; c=relaxed/simple;
	bh=psa+hHag9He3Xjc9Q89wqd+cBRM+C8tCjZWKi4bngLU=;
	h=Date:To:From:Subject:Message-Id; b=Tva5fpL7QsCNmtDvCJXKe0YgU1KrlQl+Rp3poB+8VFeOikPRVfgCTVIUUCIOMTV5KJ9d9lo+fCraI9EM9x+6qwtUt9Q/J/TE2nqIaqhkzQR9Sl9X+7ZYjRX7zfgOY4zNFwmdnMQyCk3Sq+omo+gVRBNcub5emUEzK5+lI/bIZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2q6o2aKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2q6o2aKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1532EC4CEE4;
	Tue, 14 Jan 2025 06:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837131;
	bh=psa+hHag9He3Xjc9Q89wqd+cBRM+C8tCjZWKi4bngLU=;
	h=Date:To:From:Subject:From;
	b=2q6o2aKQGEvDGA1A16d2G9h+miEUz9yzcqyNdCsiK7Hr/PyBYtR0mKwXqbtdMrTOx
	 DLFwtPVAMaqB0rmQIzmg9AO7IAkVRqGU2nA/AwsjQP5HcCwMqCeECs8NpTN0KoSA7a
	 8MpUPGZ77kEkMpdiv9Y/JcZOpAalkf1Y9B/RW28U=
Date: Mon, 13 Jan 2025 22:45:30 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch removed from -mm tree
Message-Id: <20250114064531.1532EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: completely move pagetable_dtor() to generic tlb_remove_table()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: completely move pagetable_dtor() to generic tlb_remove_table()
Date: Wed, 8 Jan 2025 14:57:31 +0800

For the generic tlb_remove_table(), it is implemented in the following two
forms:

1) CONFIG_MMU_GATHER_TABLE_FREE is enabled

tlb_remove_table
--> generic __tlb_remove_table()

2) CONFIG_MMU_GATHER_TABLE_FREE is disabled

tlb_remove_table
--> tlb_remove_page

For case 1), the pagetable_dtor() has already been moved to generic
__tlb_remove_table().

For case 2), now only arm will call tlb_remove_table()/tlb_remove_ptdesc()
when CONFIG_MMU_GATHER_TABLE_FREE is disabled.  Let's move
pagetable_dtor() completely to generic tlb_remove_table(), so that the
architectures can follow more easily.

Link: https://lkml.kernel.org/r/0c733ac867b287ec08190676496d1decebf49da2.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h |    4 ----
 include/asm-generic/tlb.h  |   10 ++++++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/arm/include/asm/tlb.h~mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table
+++ a/arch/arm/include/asm/tlb.h
@@ -34,10 +34,6 @@ __pte_free_tlb(struct mmu_gather *tlb, p
 {
 	struct ptdesc *ptdesc = page_ptdesc(pte);
 
-#ifndef CONFIG_MMU_GATHER_TABLE_FREE
-	pagetable_dtor(ptdesc);
-#endif
-
 #ifndef CONFIG_ARM_LPAE
 	/*
 	 * With the classic ARM MMU, a pte page has two corresponding pmd
--- a/include/asm-generic/tlb.h~mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table
+++ a/include/asm-generic/tlb.h
@@ -220,14 +220,20 @@ static inline void __tlb_remove_table(vo
 
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
-#else /* !CONFIG_MMU_GATHER_HAVE_TABLE_FREE */
+#else /* !CONFIG_MMU_GATHER_TABLE_FREE */
 
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 /*
  * Without MMU_GATHER_TABLE_FREE the architecture is assumed to have page based
  * page directories and we can use the normal page batching to free them.
  */
-#define tlb_remove_table(tlb, page) tlb_remove_page((tlb), (page))
+static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	struct page *page = (struct page *)table;
 
+	pagetable_dtor(page_ptdesc(page));
+	tlb_remove_page(tlb, page);
+}
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


