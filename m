Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667A21D585
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545901; cv=none; b=R/tlIXcKeCjfWG7s+yqxKLiasWqzP2cG4euHyVVj7SVN20fOnCVXl9xhIxu92GypCysCcof//ox4mIYXmr1O61TrGaHo51oSyASkeDNsmwVicMoopN+8VJNHm290aize+P739R0pbz5/9c8IVDONYj/ndWjzagfuioC5gTysosQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545901; c=relaxed/simple;
	bh=5v+dQyrTp0A5WxSjGWvJsVoxVbE8Gyky2QmmElcgqhM=;
	h=Date:To:From:Subject:Message-Id; b=qJWdlWMd2d4VAXkrPHwtgg0Zu8eNsjaD9mLUU70KUD6WOBKvjSDsQQhkZyF40y8/SY6pOE80gXLOrppxi5ZYj2qxqIRf9/Dy59bJyHuN8Ao8mKoJU2kOl6Aq3N11LZm3h3Sr0UTlCbmiQqEXQuXvo0bVF0MGEAn5zitdQ15jAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdneY4z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdneY4z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920FFC4CEE4;
	Tue,  1 Apr 2025 22:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545901;
	bh=5v+dQyrTp0A5WxSjGWvJsVoxVbE8Gyky2QmmElcgqhM=;
	h=Date:To:From:Subject:From;
	b=zdneY4z2FWh2aX3+mahZydwRrllojuzpI8gd4O/90ghywtE4tfPRjMCnTw0vDKsbF
	 zHIqxjHVk+R+tv/mSh1zrXGcExKUlT5hXHIA21Vj8oBhzqe0O5h2AFupg3TfcKzhDO
	 5q4XFIDq+zmhTESVuR25bbOvpdM52bVq3GiHlCYg=
Date: Tue, 01 Apr 2025 15:18:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch removed from -mm tree
Message-Id: <20250401221821.920FFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: pgtable: convert to use tlb_remove_ptdesc()
has been removed from the -mm tree.  Its filename was
     x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: pgtable: convert to use tlb_remove_ptdesc()
Date: Tue, 25 Feb 2025 11:45:55 +0800

The x86 has already been converted to use struct ptdesc, so convert it to
use tlb_remove_ptdesc() instead of tlb_remove_table().

Link: https://lkml.kernel.org/r/36ad56b7e06fa4b17fb23c4fc650e8e0d72bb3cd.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pgtable.c~x86-pgtable-convert-to-use-tlb_remove_ptdesc
+++ a/arch/x86/mm/pgtable.c
@@ -20,7 +20,7 @@ pgtable_t pte_alloc_one(struct mm_struct
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	paravirt_release_pte(page_to_pfn(pte));
-	tlb_remove_table(tlb, page_ptdesc(pte));
+	tlb_remove_ptdesc(tlb, page_ptdesc(pte));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 2
@@ -34,21 +34,21 @@ void ___pmd_free_tlb(struct mmu_gather *
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	tlb_remove_table(tlb, virt_to_ptdesc(pmd));
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pmd));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
-	tlb_remove_table(tlb, virt_to_ptdesc(pud));
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pud));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 4
 void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
 {
 	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
-	tlb_remove_table(tlb, virt_to_ptdesc(p4d));
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(p4d));
 }
 #endif	/* CONFIG_PGTABLE_LEVELS > 4 */
 #endif	/* CONFIG_PGTABLE_LEVELS > 3 */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


