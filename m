Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4F18410C
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712785967; cv=none; b=CblijHLYrJoWhelsPvrfbtbZiiP+/H7c6uNNc8AtLhm/WxnRCQ5Ysxqyj5jN0AcKkzmPK3C9eM1rNa/Ocy/xqzJdkaG19ZnBoSRZNj+pr+SEQMORpnAKAeb7CqoWmg8wPhLnwR1BHzSv/A3ef02Pv7Vr4rAx5+ZW3yyNi5G55Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712785967; c=relaxed/simple;
	bh=ltXPcoRbt49oxF+nJ+uSHclW556T0TbAJh2hjlfraJ8=;
	h=Date:To:From:Subject:Message-Id; b=bm9P8OSUIheaRIFbGjW9O4x7vn1JUkklhnqC7T5DTzxwXTkwvCAWzVnbPqddIYl19Qq+f3ggSX2eA+cWk78RupGrONDvYqtXpb0sfIcatVNVgS6b9fWtqHQD4f1S5gEyWP9QTW1YroUqq/rS2eFfo1PaFpFSWgp0Jnp8mAa6kuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCxocqJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCxocqJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11DDC433C7;
	Wed, 10 Apr 2024 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712785965;
	bh=ltXPcoRbt49oxF+nJ+uSHclW556T0TbAJh2hjlfraJ8=;
	h=Date:To:From:Subject:From;
	b=rCxocqJSsLyPer8smtEOdqHD2JxvO547y7E+HjeaQhhK5sVCECIaUAWjM3BTUYc6R
	 q7W7ammxnzocCXMtgP7KLEhb9W5fjzmLpPhQ9mItXIFk/bOsjdF2szn/gajej8/g6Q
	 d2AfhlXyMf2+Mud6eolFZ6oYa/BN4PbfffBola8Q=
Date: Wed, 10 Apr 2024 14:52:44 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm64-override-mkold_clean_ptes-batch-helper.patch added to mm-unstable branch
Message-Id: <20240410215245.B11DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm64: override mkold_clean_ptes() batch helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm64-override-mkold_clean_ptes-batch-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm64-override-mkold_clean_ptes-batch-helper.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/arm64: override mkold_clean_ptes() batch helper
Date: Mon, 8 Apr 2024 12:24:37 +0800

The per-pte get_and_clear/modify/set approach would result in
unfolding/refolding for contpte mappings on arm64.  So we need to override
mkold_clean_ptes() for arm64 to avoid it.

Link: https://lkml.kernel.org/r/20240408042437.10951-3-ioworker0@gmail.com
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Barry Song <21cnbao@gmail.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   55 +++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c          |   15 +++++++
 2 files changed, 70 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm64-override-mkold_clean_ptes-batch-helper
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1223,6 +1223,34 @@ static inline void __wrprotect_ptes(stru
 		__ptep_set_wrprotect(mm, address, ptep);
 }
 
+static inline void ___ptep_mkold_clean(struct mm_struct *mm, unsigned long addr,
+				       pte_t *ptep, pte_t pte)
+{
+	pte_t old_pte;
+
+	do {
+		old_pte = pte;
+		pte = pte_mkclean(pte_mkold(pte));
+		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+					       pte_val(old_pte), pte_val(pte));
+	} while (pte_val(pte) != pte_val(old_pte));
+}
+
+static inline void __ptep_mkold_clean(struct mm_struct *mm, unsigned long addr,
+				      pte_t *ptep)
+{
+	___ptep_mkold_clean(mm, addr, ptep, __ptep_get(ptep));
+}
+
+static inline void __mkold_clean_ptes(struct mm_struct *mm, unsigned long addr,
+				      pte_t *ptep, unsigned int nr)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr; i++, addr += PAGE_SIZE, ptep++)
+		__ptep_mkold_clean(mm, addr, ptep);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
@@ -1379,6 +1407,8 @@ extern void contpte_wrprotect_ptes(struc
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
+extern void contpte_mkold_clean_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, unsigned int nr);
 
 static __always_inline void contpte_try_fold(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, pte_t pte)
@@ -1603,6 +1633,30 @@ static inline int ptep_set_access_flags(
 	return contpte_ptep_set_access_flags(vma, addr, ptep, entry, dirty);
 }
 
+#define mkold_clean_ptes mkold_clean_ptes
+static inline void mkold_clean_ptes(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, unsigned int nr)
+{
+	if (likely(nr == 1)) {
+		/*
+		 * Optimization: mkold_clean_ptes() can only be called for present
+		 * ptes so we only need to check contig bit as condition for unfold,
+		 * and we can remove the contig bit from the pte we read to avoid
+		 * re-reading. This speeds up madvise(MADV_FREE) which is sensitive
+		 * for order-0 folios. Equivalent to contpte_try_unfold().
+		 */
+		pte_t orig_pte = __ptep_get(ptep);
+
+		if (unlikely(pte_cont(orig_pte))) {
+			__contpte_try_unfold(mm, addr, ptep, orig_pte);
+			orig_pte = pte_mknoncont(orig_pte);
+		}
+		___ptep_mkold_clean(mm, addr, ptep, orig_pte);
+	} else {
+		contpte_mkold_clean_ptes(mm, addr, ptep, nr);
+	}
+}
+
 #else /* CONFIG_ARM64_CONTPTE */
 
 #define ptep_get				__ptep_get
@@ -1622,6 +1676,7 @@ static inline int ptep_set_access_flags(
 #define wrprotect_ptes				__wrprotect_ptes
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags			__ptep_set_access_flags
+#define mkold_clean_ptes			__mkold_clean_ptes
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
--- a/arch/arm64/mm/contpte.c~mm-arm64-override-mkold_clean_ptes-batch-helper
+++ a/arch/arm64/mm/contpte.c
@@ -361,6 +361,21 @@ void contpte_wrprotect_ptes(struct mm_st
 }
 EXPORT_SYMBOL_GPL(contpte_wrprotect_ptes);
 
+void contpte_mkold_clean_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, unsigned int nr)
+{
+	/*
+	 * If clearing the young and dirty bits for an entire contig range, we can
+	 * avoid unfolding. Just set old/clean and wait for the later mmu_gather
+	 * flush to invalidate the tlb. If it's a partial range though, we need to
+	 * unfold.
+	 */
+
+	contpte_try_unfold_partial(mm, addr, ptep, nr);
+	__mkold_clean_ptes(mm, addr, ptep, nr);
+}
+EXPORT_SYMBOL_GPL(contpte_mkold_clean_ptes);
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
mm-arm64-override-mkold_clean_ptes-batch-helper.patch

