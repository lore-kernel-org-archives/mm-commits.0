Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8061B6CF5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837126; cv=none; b=rovKIrJo4HKVTas6IZXSingZfF3QTXexKkIt6G0SykZj5LGzWb3PtuCKf3aeWN642RCXE0U5qKo2Pxxq/DuknG4pSc297lDbDQvt5BsX78dgNKrVgiwdTygHA/FuMwVXjKCet+g55pgCqW8Yg+NfAmHGx3QIwJ+lhinFFtLwivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837126; c=relaxed/simple;
	bh=EumNA5faKbTs9tsYMQeb669cI3g60HDr6+fiKNOiWXM=;
	h=Date:To:From:Subject:Message-Id; b=GKqZtwM9/wVrVASOppieE0CLtXmB9gbRsTJA+T881SmGxNImAKVB1i4ZbIcCliuVJG1qVKbeDH9BdwosjR0TbsSH5vvwoVcZSqWpVqY5Brd/WMUMWhK7NZd9c+4NbOhtEiquK78nxNbKs2C4iCtIrjX+tfGX4HIwepSWNCHYlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AAZbLQfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AAZbLQfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775EEC4CEDD;
	Tue, 14 Jan 2025 06:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837126;
	bh=EumNA5faKbTs9tsYMQeb669cI3g60HDr6+fiKNOiWXM=;
	h=Date:To:From:Subject:From;
	b=AAZbLQfpcV1W/yCof2LP3M286SC71vsRMnRsgdiwmog4Kuo8m1jeuKuEDmj/M3L3g
	 Nx7zO9MREF7bWVTCPauMqrWOk+IQ6ZEgT+4zbjS3O1yIkoFrvYeCMmvtw547owVjSU
	 L3O8dYqnnsPNLrNm5UKCr/Gdl3I6d8d+AcJM/Fuc=
Date: Mon, 13 Jan 2025 22:45:25 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch removed from -mm tree
Message-Id: <20250114064526.775EEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: pgtable: move pagetable_dtor() to __tlb_remove_table()
has been removed from the -mm tree.  Its filename was
     x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: pgtable: move pagetable_dtor() to __tlb_remove_table()
Date: Wed, 8 Jan 2025 14:57:28 +0800

Move pagetable_dtor() to __tlb_remove_table(), so that ptlock and page
table pages can be freed together (regardless of whether RCU is used). 
This prevents the use-after-free problem where the ptlock is freed
immediately but the page table pages is freed later via RCU.

Link: https://lkml.kernel.org/r/27b3cdc8786bebd4f748380bf82f796482718504.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlb.h |    1 +
 arch/x86/kernel/paravirt.c |    1 +
 arch/x86/mm/pgtable.c      |   16 ++++------------
 3 files changed, 6 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/tlb.h~x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table
+++ a/arch/x86/include/asm/tlb.h
@@ -33,6 +33,7 @@ static inline void __tlb_remove_table(vo
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
+	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
--- a/arch/x86/kernel/paravirt.c~x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table
+++ a/arch/x86/kernel/paravirt.c
@@ -64,6 +64,7 @@ static void native_tlb_remove_table(stru
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
+	pagetable_dtor(ptdesc);
 	tlb_remove_page(tlb, ptdesc_page(ptdesc));
 }
 #else
--- a/arch/x86/mm/pgtable.c~x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table
+++ a/arch/x86/mm/pgtable.c
@@ -25,6 +25,7 @@ void paravirt_tlb_remove_table(struct mm
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
+	pagetable_dtor(ptdesc);
 	tlb_remove_page(tlb, ptdesc_page(ptdesc));
 }
 #else
@@ -62,7 +63,6 @@ early_param("userpte", setup_userpte);
 
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
-	pagetable_dtor(page_ptdesc(pte));
 	paravirt_release_pte(page_to_pfn(pte));
 	paravirt_tlb_remove_table(tlb, page_ptdesc(pte));
 }
@@ -70,7 +70,6 @@ void ___pte_free_tlb(struct mmu_gather *
 #if CONFIG_PGTABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	/*
 	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
@@ -79,28 +78,21 @@ void ___pmd_free_tlb(struct mmu_gather *
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	pagetable_dtor(ptdesc);
-	paravirt_tlb_remove_table(tlb, ptdesc);
+	paravirt_tlb_remove_table(tlb, virt_to_ptdesc(pmd));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(pud);
-
-	pagetable_dtor(ptdesc);
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
-	paravirt_tlb_remove_table(tlb, ptdesc);
+	paravirt_tlb_remove_table(tlb, virt_to_ptdesc(pud));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 4
 void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
-
-	pagetable_dtor(ptdesc);
 	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
-	paravirt_tlb_remove_table(tlb, ptdesc);
+	paravirt_tlb_remove_table(tlb, virt_to_ptdesc(p4d));
 }
 #endif	/* CONFIG_PGTABLE_LEVELS > 4 */
 #endif	/* CONFIG_PGTABLE_LEVELS > 3 */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


