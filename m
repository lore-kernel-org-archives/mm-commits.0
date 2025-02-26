Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB1155C83
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537400; cv=none; b=M66aqK/+xIoIIE4wWt3w7PevtU/Ooxq4NhSYEj4sT00hQkjV9udon/5RQhz5raoyVqNtbLtzs7976onBz9uP+yLMJRzqSJh9v76BjYvvFJOvNX5L6VFDX1t3mUKmfdzEWmb1iM1oU/kwxp91hJiFt4nMbhnYcW6X5Ns+FYxTHLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537400; c=relaxed/simple;
	bh=3k30x88EX2KTn4lGvtTne+UeqW6gxMMoJB6MTfIdoF8=;
	h=Date:To:From:Subject:Message-Id; b=BWBCpQD0gF+ybNHJFuBfadzghKFzgnQJ/LFgpDwp4Fqn9h8tWlyG5ShFNKG/S/IIZ0VjOmoLxNVQpPbM9+WRmQz4fW5/qZE3wQAlxxj7aS4Pz4SMGsnaIpbj3hWeaa5uyhYxEKqFpXi6zQsANyfMpPJUS8Zxsq2u36PIKHOKuzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rt3NQpwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rt3NQpwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC206C4CEDD;
	Wed, 26 Feb 2025 02:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537399;
	bh=3k30x88EX2KTn4lGvtTne+UeqW6gxMMoJB6MTfIdoF8=;
	h=Date:To:From:Subject:From;
	b=rt3NQpwObbsNklCDb7v6NRl77WOaPjjeAE8Ua1K/HvKomv+HpHmQMJ+rEgVE+uFqT
	 zYGPH+6Yw8z+JHxYHJKFrjZzeComjgBFO1KeP/r/Ekox5injGG02rjSDHLj6CBPKE9
	 bmVFmbRjDUE0wDoto0h7Idrj/3gajR1ve2ZadvEQ=
Date: Tue, 25 Feb 2025 18:36:39 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch added to mm-unstable branch
Message-Id: <20250226023639.BC206C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: change pt parameter of tlb_remove_ptdesc() to struct ptdesc*
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch

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
Subject: mm: pgtable: change pt parameter of tlb_remove_ptdesc() to struct ptdesc*
Date: Tue, 25 Feb 2025 11:45:52 +0800

All callers of tlb_remove_ptdesc() pass it a pointer of struct ptdesc, so
let's change the pt parameter from void * to struct ptdesc * to perform a
type safety check.

Link: https://lkml.kernel.org/r/60bb44299cf2d731df6592e446e7f694054d0dbe.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
@@ -506,7 +506,7 @@ static inline void tlb_remove_page(struc
 	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
 
-static inline void tlb_remove_ptdesc(struct mmu_gather *tlb, void *pt)
+static inline void tlb_remove_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt)
 {
 	tlb_remove_table(tlb, pt);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch

