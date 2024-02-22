Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7613F224EE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644497; cv=none; b=PtIuVYFlGkvZ/MlMY8HCH4dNkopZIKEDnIhvhkMZSfhROp3cd85HCv9Q2mNBTnlWrUV9Q4l9tcXAifscxqQWvvec3uyuTyOC7V4mZRBBb5o+xYxQNHl/hNBy2NNeD0Wm/S02d/gSPRcwRnNBww9g9GQG8QALUGM57S+UObinxAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644497; c=relaxed/simple;
	bh=+TzbRfXu+4Zfh2ICJVIO4PPJbcJx7EkXJWygMoYfhbg=;
	h=Date:To:From:Subject:Message-Id; b=jNRpAs0olW8mrhHKkLSHdRMJlPRekmXKg096R7Tmig6VFgyqI/WCaq9BTZjoJfaVRacavYhtZW8nVePPMzNQvyhr2r17Pq8aTE1vPW4RwGY3p9XIBPvTCUYMd7qSgS4esFZqNgJI7LjRb4cSSEf3Vwco2RzXBK0YO6Vn4UJ7sW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dh7BE/YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dh7BE/YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412DCC433F1;
	Thu, 22 Feb 2024 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644497;
	bh=+TzbRfXu+4Zfh2ICJVIO4PPJbcJx7EkXJWygMoYfhbg=;
	h=Date:To:From:Subject:From;
	b=Dh7BE/YCITxtmZUrx5X25x5au/zZqE2cMdYcAPPkYw8dz35i3ahlaRrj0vvoC6ijm
	 QSBHbS9QrEtmBo2Xzyph3ZEIQchh1LnJiQpqt4MqiRnXrkF9L7s+PFBqKY14wW3VDm
	 ft5774xWp60YuBLh+fw/tIfTeo8Q9PvPiyT2giBg=
Date: Thu, 22 Feb 2024 15:28:16 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-implement-new-clear_full_ptes-batch-apis.patch removed from -mm tree
Message-Id: <20240222232817.412DCC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: implement new [get_and_]clear_full_ptes() batch APIs
has been removed from the -mm tree.  Its filename was
     arm64-mm-implement-new-clear_full_ptes-batch-apis.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: implement new [get_and_]clear_full_ptes() batch APIs
Date: Thu, 15 Feb 2024 10:32:01 +0000

Optimize the contpte implementation to fix some of the
exit/munmap/dontneed performance regression introduced by the initial
contpte commit.  Subsequent patches will solve it entirely.

During exit(), munmap() or madvise(MADV_DONTNEED), mappings must be
cleared.  Previously this was done 1 PTE at a time.  But the core-mm
supports batched clear via the new [get_and_]clear_full_ptes() APIs.  So
let's implement those APIs and for fully covered contpte mappings, we no
longer need to unfold the contpte.  This significantly reduces unfolding
operations, reducing the number of tlbis that must be issued.

Link: https://lkml.kernel.org/r/20240215103205.2607016-15-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   67 +++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c          |   17 +++++++
 2 files changed, 84 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-new-clear_full_ptes-batch-apis
+++ a/arch/arm64/include/asm/pgtable.h
@@ -965,6 +965,37 @@ static inline pte_t __ptep_get_and_clear
 	return pte;
 }
 
+static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr, int full)
+{
+	for (;;) {
+		__ptep_get_and_clear(mm, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
+static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr, int full)
+{
+	pte_t pte, tmp_pte;
+
+	pte = __ptep_get_and_clear(mm, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		tmp_pte = __ptep_get_and_clear(mm, addr, ptep);
+		if (pte_dirty(tmp_pte))
+			pte = pte_mkdirty(pte);
+		if (pte_young(tmp_pte))
+			pte = pte_mkyoung(pte);
+	}
+	return pte;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
@@ -1160,6 +1191,11 @@ extern pte_t contpte_ptep_get(pte_t *pte
 extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
 extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, unsigned int nr);
+extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr, int full);
+extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr, int full);
 extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep);
 extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
@@ -1253,6 +1289,35 @@ static inline void pte_clear(struct mm_s
 	__pte_clear(mm, addr, ptep);
 }
 
+#define clear_full_ptes clear_full_ptes
+static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr, int full)
+{
+	if (likely(nr == 1)) {
+		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+		__clear_full_ptes(mm, addr, ptep, nr, full);
+	} else {
+		contpte_clear_full_ptes(mm, addr, ptep, nr, full);
+	}
+}
+
+#define get_and_clear_full_ptes get_and_clear_full_ptes
+static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr, int full)
+{
+	pte_t pte;
+
+	if (likely(nr == 1)) {
+		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+		pte = __get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+	} else {
+		pte = contpte_get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+	}
+
+	return pte;
+}
+
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep)
@@ -1337,6 +1402,8 @@ static inline int ptep_set_access_flags(
 #define set_pte					__set_pte
 #define set_ptes				__set_ptes
 #define pte_clear				__pte_clear
+#define clear_full_ptes				__clear_full_ptes
+#define get_and_clear_full_ptes			__get_and_clear_full_ptes
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define ptep_get_and_clear			__ptep_get_and_clear
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
--- a/arch/arm64/mm/contpte.c~arm64-mm-implement-new-clear_full_ptes-batch-apis
+++ a/arch/arm64/mm/contpte.c
@@ -212,6 +212,23 @@ void contpte_set_ptes(struct mm_struct *
 }
 EXPORT_SYMBOL(contpte_set_ptes);
 
+void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr, int full)
+{
+	contpte_try_unfold_partial(mm, addr, ptep, nr);
+	__clear_full_ptes(mm, addr, ptep, nr, full);
+}
+EXPORT_SYMBOL(contpte_clear_full_ptes);
+
+pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr, int full)
+{
+	contpte_try_unfold_partial(mm, addr, ptep, nr);
+	return __get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+}
+EXPORT_SYMBOL(contpte_get_and_clear_full_ptes);
+
 int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


