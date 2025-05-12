Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDACC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011081; cv=none; b=rdUbUmfimAc7ZEBn8zA0hpaSnPkbfDy/MQFZuw5Lp1pjwH3xS4FH0mtuq/xuIggcV2M22V5MrEONM/dMhY5Vv+j4ho/3Igi79RZT5S03Ccl0233nbr93pnUwJijKUnAbSQlp6geV7NLY8Us2qXjuarPlgqld88xBSInDvzTPhiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011081; c=relaxed/simple;
	bh=AVVZ2BQdoIl5QDUTJqZuzh8+IZyrJ2b/VZxvdjFzSTM=;
	h=Date:To:From:Subject:Message-Id; b=utilCBQFCzP+/7T11khoxp08GxSAcT52pgbOpr5kcUCkqHmAkhKf1Exd4SLS/u81omgeN5xhaglnp+mwYm1m6aiUYbH1sOwnhN7goYctLmBP6atQlZiZfzbeKEHVVgvhoyxzTHr1mlSDmPUWw/WrLYpNxr2ueVZn91Ic0FzniUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RZzmXZh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RZzmXZh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F947C4CEE4;
	Mon, 12 May 2025 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011081;
	bh=AVVZ2BQdoIl5QDUTJqZuzh8+IZyrJ2b/VZxvdjFzSTM=;
	h=Date:To:From:Subject:From;
	b=RZzmXZh32zzB7W0Jci8nMyUjhESFESCUTJ7RQDwedmzM4mXXAhHkJzPelQi1BNkry
	 gumQJ6NpIdgwpBqn2xcE8tMbSmjtytn/sZUo4ykLquxxK0+GfDfZqLZTIJ2ri39O9d
	 jxDiu8W3lSENvpb6SwqD9Lg00kkd3WAe9I6s2Bac=
Date: Sun, 11 May 2025 17:51:21 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch removed from -mm tree
Message-Id: <20250512005121.8F947C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc64: mm: call ctor/dtor for kernel PTEs
has been removed from the -mm tree.  Its filename was
     sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: sparc64: mm: call ctor/dtor for kernel PTEs
Date: Tue, 8 Apr 2025 10:52:16 +0100

The generic implementation of pte_{alloc_one,free}_kernel now calls the
[cd]tor, without initialising the ptlock needlessly as
pagetable_pte_ctor() skips it for init_mm.

Align sparc64 with the generic implementation by ensuring
pagetable_pte_[cd]tor() are called for kernel PTEs.  As a result the
kernel and user alloc/free functions have the same implementation, and
since pgtable_t is defined as pte_t *, we can have both call a common
helper.

Link: https://lkml.kernel.org/r/20250408095222.860601-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc64-mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/sparc/mm/init_64.c
@@ -2878,18 +2878,7 @@ void __flush_tlb_all(void)
 			     : : "r" (pstate));
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
-{
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	pte_t *pte = NULL;
-
-	if (page)
-		pte = (pte_t *) page_address(page);
-
-	return pte;
-}
-
-pgtable_t pte_alloc_one(struct mm_struct *mm)
+static pte_t *__pte_alloc_one(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
 
@@ -2902,9 +2891,14 @@ pgtable_t pte_alloc_one(struct mm_struct
 	return ptdesc_address(ptdesc);
 }
 
-void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
-	free_page((unsigned long)pte);
+	return __pte_alloc_one(mm);
+}
+
+pgtable_t pte_alloc_one(struct mm_struct *mm)
+{
+	return __pte_alloc_one(mm);
 }
 
 static void __pte_free(pgtable_t pte)
@@ -2915,6 +2909,11 @@ static void __pte_free(pgtable_t pte)
 	pagetable_free(ptdesc);
 }
 
+void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	__pte_free(pte);
+}
+
 void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	__pte_free(pte);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


