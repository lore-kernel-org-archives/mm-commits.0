Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675A320C48F
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545896; cv=none; b=qiOwHhfSot7E5fwF0qHgvCHU2lUv+h7yFyLXTqgXbZFKzLwnv3IbfMQOmx1Cc3nPAkvDRuZhRJm8LSASZHbKNMm+GNbHf5II8VxshpdAJXbSCsq+x7RSS5M25dao/E+NKZxSaVQMlznQ3DV5JyAE6HjSomS/3VW1XLdl5TZUEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545896; c=relaxed/simple;
	bh=ru9kqLaK1zEcSdRmBu+ohm4uYXq4MwKAQtsTjgT2szY=;
	h=Date:To:From:Subject:Message-Id; b=a5ZVIhQbFOmaOPb00X9NKZXqUoKnYgI1wKN3zgaJDX8Fve2AMANUjREMgNh+QO0K//olb3RdFwOT1Ohg4tUnX3ZZ1NWiDKehZqGFdZQ+3LoRDqhKM901m5v0wfhksFY6K9cTE0ItgwKooVmxTWU+Rv6EMSi1Y064H8yl7VN0B9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+i/5ja7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+i/5ja7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D612DC4CEE4;
	Tue,  1 Apr 2025 22:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545894;
	bh=ru9kqLaK1zEcSdRmBu+ohm4uYXq4MwKAQtsTjgT2szY=;
	h=Date:To:From:Subject:From;
	b=G+i/5ja7T5CntSf4qug/Sul6UfdpndLYyPPZkrN7UwaFn2WJC/0iG2l74pOP1Qe8m
	 ofdOT6IOhOVMJ3YdxDEADNYrr56P9NmSQuUlff4cXWtUlgMMk+HJ2/zjD1T/o3WRXu
	 //Ct5fCaCJWPhC26Xu1jXwtcBW+IGibYbGlgmOzE=
Date: Tue, 01 Apr 2025 15:18:14 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch removed from -mm tree
Message-Id: <20250401221814.D612DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: make generic tlb_remove_table() use struct ptdesc
has been removed from the -mm tree.  Its filename was
     mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: make generic tlb_remove_table() use struct ptdesc
Date: Tue, 25 Feb 2025 11:45:51 +0800

Patch series "remove tlb_remove_page_ptdesc()", v2.

As suggested by Peter Zijlstra below [1], this series aims to remove
tlb_remove_page_ptdesc().

: Fundamentally tlb_remove_page() is about removing *pages* as from a PTE,
: there should not be a page-table anywhere near here *ever*.
:
: Yes, some architectures use tlb_remove_page() for page-tables too, but
: that is more or less an implementation detail that can be fixed.

After this series, all architectures use tlb_remove_table() or
tlb_remove_ptdesc() to remove the page table pages.  In the future, once
all architectures using tlb_remove_table() have also converted to using
struct ptdesc (eg.  powerpc), it may be possible to use only
tlb_remove_ptdesc().

[1] https://lore.kernel.org/linux-mm/20250103111457.GC22934@noisy.programming.kicks-ass.net/


This patch (of 6):

Now only arm will call tlb_remove_ptdesc()/tlb_remove_table() when
CONFIG_MMU_GATHER_TABLE_FREE is disabled.  In this case, the type of the
table parameter is actually struct ptdesc * instead of struct page *.

Since struct ptdesc still overlaps with struct page and has not been
separated from it, forcing the table parameter to struct page * will not
cause any problems at this time.  But this is definitely incorrect and
needs to be fixed.  So just like the generic __tlb_remove_table(), let
generic tlb_remove_table() use struct ptdesc by default when
CONFIG_MMU_GATHER_TABLE_FREE is disabled.

Link: https://lkml.kernel.org/r/cover.1740454179.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/5be8c3ab7bd68510bf0db4cf84010f4dfe372917.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
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
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/asm-generic/tlb.h~mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc
+++ a/include/asm-generic/tlb.h
@@ -227,10 +227,10 @@ static inline void tlb_remove_page(struc
  */
 static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 {
-	struct page *page = (struct page *)table;
+	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
-	pagetable_dtor(page_ptdesc(page));
-	tlb_remove_page(tlb, page);
+	pagetable_dtor(ptdesc);
+	tlb_remove_page(tlb, ptdesc_page(ptdesc));
 }
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


