Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6498413790E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644500; cv=none; b=U9JnmMjCtpFWB8mHeU7ZI0vdjCTERTusRYu3FiK4PSGlwoHVphTAHz31EqTWPIZ+VsOLTdkE6czkqTyue7h+n9aLG/DE1RoW1GT6eSHimlwiYf93FprjJbNnmXdPXb3/+oQah9zBctToIDf/U+HLikV0KFuOXVzLJ+2ed1e6AFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644500; c=relaxed/simple;
	bh=98NM5NMKfp5DAJLpK/Ies+YZJzELr0cODtowic5opDA=;
	h=Date:To:From:Subject:Message-Id; b=G2yI0hI3RLyIfal9j7EE45s6VPL48xjPvG9UspH7axZZhP6Gy1YYhscTEDzzUNBW70Cv8Jtv/Jj0QqmZhLZV0H9D37ILCJvB26/gZcHzJIPLtZ/8uR7Sbky4T8UqUwhORgRra+42PTbAzTW14+7KnhwzhsCwnqGmLSs4BFsC1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KAbkiYuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KAbkiYuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBFFC433C7;
	Thu, 22 Feb 2024 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644500;
	bh=98NM5NMKfp5DAJLpK/Ies+YZJzELr0cODtowic5opDA=;
	h=Date:To:From:Subject:From;
	b=KAbkiYuZQev8fD89Hr/nx3FbIGyo6s/SFssJ8gtCf1OOQ8Jz/Sl+LdBFB1231CKy8
	 1+qoxKXxIaKCGtZcaFQ81QvhMsV1KVWJMB1xn7kL9ilwhNN5CmSoFC/1YRG9tKvcdW
	 r4FrxCy9i55A6n6JBjM3GeCG8hGMDgaGQwxM9Xq4=
Date: Thu, 22 Feb 2024 15:28:19 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-__always_inline-to-improve-fork-perf.patch removed from -mm tree
Message-Id: <20240222232820.2FBFFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: __always_inline to improve fork() perf
has been removed from the -mm tree.  Its filename was
     arm64-mm-__always_inline-to-improve-fork-perf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: __always_inline to improve fork() perf
Date: Thu, 15 Feb 2024 10:32:04 +0000

As set_ptes() and wrprotect_ptes() become a bit more complex, the compiler
may choose not to inline them.  But this is critical for fork()
performance.  So mark the functions, along with contpte_try_unfold() which
is called by them, as __always_inline.  This is worth ~1% on the fork()
microbenchmark with order-0 folios (the common case).

Link: https://lkml.kernel.org/r/20240215103205.2607016-18-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-__always_inline-to-improve-fork-perf
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1206,8 +1206,8 @@ extern int contpte_ptep_set_access_flags
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
 
-static inline void contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte)
+static __always_inline void contpte_try_unfold(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	if (unlikely(pte_valid_cont(pte)))
 		__contpte_try_unfold(mm, addr, ptep, pte);
@@ -1278,7 +1278,7 @@ static inline void set_pte(pte_t *ptep,
 }
 
 #define set_ptes set_ptes
-static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+static __always_inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	pte = pte_mknoncont(pte);
@@ -1360,8 +1360,8 @@ static inline int ptep_clear_flush_young
 }
 
 #define wrprotect_ptes wrprotect_ptes
-static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr)
+static __always_inline void wrprotect_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1)) {
 		/*
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


