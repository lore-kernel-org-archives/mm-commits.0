Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1C155C83
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537409; cv=none; b=NaVjnIvy13nhePpSYr9tPv8egFMamRltKv9ojuQs8gUzMpTOnTDTFkJwhZy4fnqW/PNt0sJcB4E/T6iM5EgwXIA8tMqu94Xvf0iqyYKxyC8o3vRbfF7reST6MZRmElFDUdXXJI/YxVX5E91DFwz0x3TcwKJadzOf6sg/LeIM+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537409; c=relaxed/simple;
	bh=NTcEZQ2cY/kuyrMuY6hkxjVnqam08QLWoZ9UlNQfF7k=;
	h=Date:To:From:Subject:Message-Id; b=Xo2Ep1JcjME8TfvNVYpOJrfFpcNuwHLVe8EZS40aVWNe5VokdI2Kus5fhXzMlhBH4kj5I+Y8YxH9WT9eZX9MuY98U7Lss9kZWUgfhjK6DgXtmryajjXvRvzWnj0IxzCfFhbe2XXzj0/hQLNMUE296D+6pgYek/Rj+Ep2DOY5Njw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MqZozLex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MqZozLex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCC8C4CEDD;
	Wed, 26 Feb 2025 02:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537409;
	bh=NTcEZQ2cY/kuyrMuY6hkxjVnqam08QLWoZ9UlNQfF7k=;
	h=Date:To:From:Subject:From;
	b=MqZozLexJ7qZZNA9M6Pvb2N7wb+Pc6T1Bl7xqI2bMZPjbQGMjqktB9yuU0psQH1Eh
	 5zwQrNiZQarXv7j1pomiypIIsbGEDsQqPZGyy23g5HuxxneMZ4vaDzAIvtK9wLjrzL
	 +eblzh8DE68tC3BriJSyy3tHhTryoh7Lmt4TKlsw=
Date: Tue, 25 Feb 2025 18:36:48 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch added to mm-unstable branch
Message-Id: <20250226023649.4DCC8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: pgtable: convert to use tlb_remove_ptdesc()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch

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
@@ -45,7 +45,7 @@ early_param("userpte", setup_userpte);
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	paravirt_release_pte(page_to_pfn(pte));
-	tlb_remove_table(tlb, page_ptdesc(pte));
+	tlb_remove_ptdesc(tlb, page_ptdesc(pte));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 2
@@ -59,21 +59,21 @@ void ___pmd_free_tlb(struct mmu_gather *
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

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch

