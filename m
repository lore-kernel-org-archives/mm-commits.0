Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30267155C83
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537398; cv=none; b=N56PdG1Z5s/d0iwFfgVn3r8Tl6FJi6j1XyyEw/3J0bpgGeMkM5P0zp0rVp8JysZmxAZEJBZf/VHI2waRzn4tM9pZEhvKSqXrHjyT+bMjTyG3e+/SdrmfrujHMg6OMHi1fBwiBH155PzEZTauHVh649+XqPKSobgmUcL4tS4YHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537398; c=relaxed/simple;
	bh=kZk57c9BOSaeatL+He1/TWef6hw/Pej1roaol9Xac6s=;
	h=Date:To:From:Subject:Message-Id; b=OthunkmwzNTgbhlnynTetDnqtQPd2HFAKFYDPDfiXKTdzEPbKKS7j9GyXFy3rdxKXMoCNbNDgD2PpG5YjA2+zruY+8QwsXt6aM4wsMpqy7csebIxSTcTK77Ta2wqeUDXA22NzjLTePF7I9E6xR9O8+BZ/GtHv1WuFnUXpbddfgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cLBW9PRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cLBW9PRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B27C4CEDD;
	Wed, 26 Feb 2025 02:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537397;
	bh=kZk57c9BOSaeatL+He1/TWef6hw/Pej1roaol9Xac6s=;
	h=Date:To:From:Subject:From;
	b=cLBW9PRDKnSX1tNTxdqNAjgY5asWGMLv0XPbj6Bn/vx+HiibgUMjHEBCyBqBajjZn
	 lU19/ODTOli5JoBjWK7kZW//HKWd8+y72oRx4EjrN2WK0phibQPfozbY6fT11Ngwy9
	 jm36qv35s+3vVxSmmQXcw99WLVC3SlHSZyqBKTQI=
Date: Tue, 25 Feb 2025 18:36:36 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch added to mm-unstable branch
Message-Id: <20250226023637.81B27C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: make generic tlb_remove_table() use struct ptdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch

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

 include/asm-generic/tlb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/asm-generic/tlb.h~mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc
+++ a/include/asm-generic/tlb.h
@@ -232,10 +232,10 @@ static inline void tlb_remove_page(struc
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

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch

