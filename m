Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1A567D
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235340; cv=none; b=b9SM9PeSVFXQ08tnIDLj5zcchkNBKUGLhiDiEiUq/EWPTd5Q7hUpxnTl9RLY7FLgu3TyIjrQNYROz4iJXoOkw3Az8CxV1DHjDfgZGzYHyfehFd2JST7yKGST2xzgYYZ5mf9iMUNOwkCwNGcjHhPNpqbGmo3cxV+d3vR3oS7V+w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235340; c=relaxed/simple;
	bh=/XFbOZF7b5IqWXXuWRK7sEz3yVOz9lPFgTky4141L4c=;
	h=Date:To:From:Subject:Message-Id; b=JsGTdbs4MVB2PFo0uwS7k9aPeHn1B908q81PmKeHeywH1ooNMM45JdWc/kUxjS5/OQ/SCEDN76+GcMNm510IJNUoInjONulVHkRpby+BgmcSFeJxiE3zxlntdzexRzjVbK4WWjr7lKKbI/vDJkRpo4xtoSOgOEL408SIlNC6bDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pseDlMYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pseDlMYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A5C433F1;
	Fri, 26 Jan 2024 02:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235340;
	bh=/XFbOZF7b5IqWXXuWRK7sEz3yVOz9lPFgTky4141L4c=;
	h=Date:To:From:Subject:From;
	b=pseDlMYLwCpwdJhzB5/TXYcXUXcLvoh5Ae7EG06oLqc1mb3YxDlQkjhvuu85YQuO6
	 H/QwLYkCYVAp+rkeCZBQmMQqUWACuC0QmQ/UEG4I8r6jyTmhzUROdJgwb3zS81sETI
	 yJpeS88D+aN1bHCTmOZRNrnvGbSFAF2jggbmVtpo=
Date: Thu, 25 Jan 2024 18:15:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,david@redhat.com,catalin.marinas@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch added to mm-unstable branch
Message-Id: <20240126021539.DA2A5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: make set_ptes() robust when OAs cross 48-bit boundary
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: make set_ptes() robust when OAs cross 48-bit boundary
Date: Thu, 25 Jan 2024 17:35:34 +0000

Since the high bits [51:48] of an OA are not stored contiguously in the
PTE, there is a theoretical bug in set_ptes(), which just adds PAGE_SIZE
to the pte to get the pte with the next pfn.  This works until the pfn
crosses the 48-bit boundary, at which point we overflow into the upper
attributes.

Of course one could argue (and Matthew Wilcox has :) that we will never
see a folio cross this boundary because we only allow naturally aligned
power-of-2 allocation, so this would require a half-petabyte folio.  So
its only a theoretical bug.  But its better that the code is robust
regardless.

I've implemented pte_next_pfn() as part of the fix, which is an opt-in
core-mm interface.  So that is now available to the core-mm, which will be
needed shortly to support forthcoming fork()-batching optimizations.

Link: https://lkml.kernel.org/r/20240125173534.1659317-1-ryan.roberts@arm.com
Fixes: 4a169d61c2ed ("arm64: implement the new page table range API")
Closes: https://lore.kernel.org/linux-mm/fdaeb9a5-d890-499a-92c8-d171df43ad01@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary
+++ a/arch/arm64/include/asm/pgtable.h
@@ -341,6 +341,22 @@ static inline void __sync_cache_and_tags
 		mte_sync_tags(pte, nr_pages);
 }
 
+/*
+ * Select all bits except the pfn
+ */
+static inline pgprot_t pte_pgprot(pte_t pte)
+{
+	unsigned long pfn = pte_pfn(pte);
+
+	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
+}
+
+#define pte_next_pfn pte_next_pfn
+static inline pte_t pte_next_pfn(pte_t pte)
+{
+	return pfn_pte(pte_pfn(pte) + 1, pte_pgprot(pte));
+}
+
 static inline void set_ptes(struct mm_struct *mm,
 			    unsigned long __always_unused addr,
 			    pte_t *ptep, pte_t pte, unsigned int nr)
@@ -354,7 +370,7 @@ static inline void set_ptes(struct mm_st
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte_val(pte) += PAGE_SIZE;
+		pte = pte_next_pfn(pte);
 	}
 }
 #define set_ptes set_ptes
@@ -433,16 +449,6 @@ static inline pte_t pte_swp_clear_exclus
 	return clear_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
 }
 
-/*
- * Select all bits except the pfn
- */
-static inline pgprot_t pte_pgprot(pte_t pte)
-{
-	unsigned long pfn = pte_pfn(pte);
-
-	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
-}
-
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * See the comment in include/linux/pgtable.h
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch
mm-thp_get_unmapped_area-must-honour-topdown-preference.patch
mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

