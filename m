Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632691BF53
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574874; cv=none; b=nscIhVmBstQHxNMpvkD14ZEuZevs6b+UZxZPIgewHP/qmvO7QNPw/7C5o3yDHvTUdpgJ7WyWWc2qOmWgI/0M6EwKpk5HZyvv/tUdLx1aKMmBdpNy8HvfJccKVH16tQDCpGamxfvD7J7NkZVo1MlST9T+8MlJxBo+3i9zzT33I6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574874; c=relaxed/simple;
	bh=VNcQCQ8RVueP93Lfnt23F/HQNf7Awzp4C7zY5oTfPxM=;
	h=Date:To:From:Subject:Message-Id; b=eJOfEzmiJv3eMhvaZQwMjIGSV9uZdIIhTTfvrP2paIezXT19EyRuv79ZBuSPWmOejRaPWc3uIy5SCunuWNtBJIyu9POZbldxsyB5AeSoWFkqpiwp5D22g80ydmeAXWaZF41sjpKqT7Fkd/xgng4khZ4h4nx9aSEDsDMZ9bx3kME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKBaTxxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKBaTxxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F46EC32782;
	Tue, 13 Aug 2024 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723574874;
	bh=VNcQCQ8RVueP93Lfnt23F/HQNf7Awzp4C7zY5oTfPxM=;
	h=Date:To:From:Subject:From;
	b=VKBaTxxj5znQgO5HgVXdv6G2ap8XqEDgx6qgDYNSqVy6j9J4PxIV5MWIUcOOMhYPp
	 w0JlV0K7ZFb3cSEk5RqWWrPQOEWEKqvJQwm8h8Ib4lE0+KgvYLfEcnBYygteBaIZeJ
	 bUvSgInIhLV0N88F2LMwSPT2IldlFZoQUPfQwqCU=
Date: Tue, 13 Aug 2024 11:47:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-fix-dax-pud-handlings.patch added to mm-unstable branch
Message-Id: <20240813184754.0F46EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: fix dax pud handlings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-fix-dax-pud-handlings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-fix-dax-pud-handlings.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/mprotect: fix dax pud handlings
Date: Mon, 12 Aug 2024 14:12:25 -0400

This is only relevant to the two archs that support PUD dax, aka, x86_64
and ppc64.  PUD THPs do not yet exist elsewhere, and hugetlb PUDs do not
count in this case.

DAX have had PUD mappings for years, but change protection path never
worked.  When the path is triggered in any form (a simple test program
would be: call mprotect() on a 1G dev_dax mapping), the kernel will report
"bad pud".  This patch should fix that.

The new change_huge_pud() tries to keep everything simple.  For example,
it doesn't optimize write bit as that will need even more PUD helpers. 
It's not too bad anyway to have one more write fault in the worst case
once for 1G range; may be a bigger thing for each PAGE_SIZE, though. 
Neither does it support userfault-wp bits, as there isn't such PUD
mappings that is supported; file mappings always need a split there.

The same to TLB shootdown: the pmd path (which was for x86 only) has the
trick of using _ad() version of pmdp_invalidate*() which can avoid one
redundant TLB, but let's also leave that for later.  Again, the larger the
mapping, the smaller of such effect.

There's some difference on handling "retry" for change_huge_pud() (where
it can return 0): it isn't like change_huge_pmd(), as the pmd version is
safe with all conditions handled in change_pte_range() later, thanks to
Hugh's new pte_offset_map_lock().  In short, change_pte_range() is simply
smarter.  For that, change_pud_range() will need proper retry if it races
with something else when a huge PUD changed from under us.

The last thing to mention is currently the PUD path ignores the huge pte
numa counter (NUMA_HUGE_PTE_UPDATES), not only because DAX is not
applicable to NUMA, but also that it's ambiguous on its own to decide how
to account pud in this case.  In one earlier version of this patchset I
proposed to remove the counter as it doesn't even look right to do the
accounting as of now [1], but then a further discussion suggests we can
leave that for later, as that doesn't block this series if we choose to
ignore that counter.  That's what this patch does, by ignoring it.

When at it, touch up the comment in pgtable_split_needed() to make it
generic to either pmd or pud file THPs.

[1] https://lore.kernel.org/all/20240715192142.3241557-3-peterx@redhat.com/
[2] https://lore.kernel.org/r/added2d0-b8be-4108-82ca-1367a388d0b1@redhat.com

Link: https://lkml.kernel.org/r/20240812181225.1360970-8-peterx@redhat.com
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Fixes: 27af67f35631 ("powerpc/book3s64/mm: enable transparent pud hugepage")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   24 +++++++++++++++++
 mm/huge_memory.c        |   52 ++++++++++++++++++++++++++++++++++++++
 mm/mprotect.c           |   39 ++++++++++++++++++++++------
 3 files changed, 107 insertions(+), 8 deletions(-)

--- a/include/linux/huge_mm.h~mm-mprotect-fix-dax-pud-handlings
+++ a/include/linux/huge_mm.h
@@ -342,6 +342,17 @@ void split_huge_pmd_address(struct vm_ar
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
+		    unsigned long cp_flags);
+#else
+static inline int
+change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pud_t *pudp, unsigned long addr, pgprot_t newprot,
+		unsigned long cp_flags) { return 0; }
+#endif
+
 #define split_huge_pud(__vma, __pud, __address)				\
 	do {								\
 		pud_t *____pud = (__pud);				\
@@ -585,6 +596,19 @@ static inline int next_order(unsigned lo
 {
 	return 0;
 }
+
+static inline void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
+				    unsigned long address)
+{
+}
+
+static inline int change_huge_pud(struct mmu_gather *tlb,
+				  struct vm_area_struct *vma, pud_t *pudp,
+				  unsigned long addr, pgprot_t newprot,
+				  unsigned long cp_flags)
+{
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
--- a/mm/huge_memory.c~mm-mprotect-fix-dax-pud-handlings
+++ a/mm/huge_memory.c
@@ -2188,6 +2188,53 @@ unlock:
 	return ret;
 }
 
+/*
+ * Returns:
+ *
+ * - 0: if pud leaf changed from under us
+ * - 1: if pud can be skipped
+ * - HPAGE_PUD_NR: if pud was successfully processed
+ */
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
+		    unsigned long cp_flags)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pud_t oldpud, entry;
+	spinlock_t *ptl;
+
+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
+	/* NUMA balancing doesn't apply to dax */
+	if (cp_flags & MM_CP_PROT_NUMA)
+		return 1;
+
+	/*
+	 * Huge entries on userfault-wp only works with anonymous, while we
+	 * don't have anonymous PUDs yet.
+	 */
+	if (WARN_ON_ONCE(cp_flags & MM_CP_UFFD_WP_ALL))
+		return 1;
+
+	ptl = __pud_trans_huge_lock(pudp, vma);
+	if (!ptl)
+		return 0;
+
+	/*
+	 * Can't clear PUD or it can race with concurrent zapping.  See
+	 * change_huge_pmd().
+	 */
+	oldpud = pudp_invalidate(vma, addr, pudp);
+	entry = pud_modify(oldpud, newprot);
+	set_pud_at(mm, addr, pudp, entry);
+	tlb_flush_pud_range(tlb, addr, HPAGE_PUD_SIZE);
+
+	spin_unlock(ptl);
+	return HPAGE_PUD_NR;
+}
+#endif
+
 #ifdef CONFIG_USERFAULTFD
 /*
  * The PT lock for src_pmd and dst_vma/src_vma (for reading) are locked by
@@ -2418,6 +2465,11 @@ out:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
+#else
+void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
+		unsigned long address)
+{
+}
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
--- a/mm/mprotect.c~mm-mprotect-fix-dax-pud-handlings
+++ a/mm/mprotect.c
@@ -302,8 +302,9 @@ pgtable_split_needed(struct vm_area_stru
 {
 	/*
 	 * pte markers only resides in pte level, if we need pte markers,
-	 * we need to split.  We cannot wr-protect shmem thp because file
-	 * thp is handled differently when split by erasing the pmd so far.
+	 * we need to split.  For example, we cannot wr-protect a file thp
+	 * (e.g. 2M shmem) because file thp is handled differently when
+	 * split by erasing the pmd so far.
 	 */
 	return (cp_flags & MM_CP_UFFD_WP) && !vma_is_anonymous(vma);
 }
@@ -430,31 +431,53 @@ static inline long change_pud_range(stru
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mmu_notifier_range range;
-	pud_t *pud;
+	pud_t *pudp, pud;
 	unsigned long next;
 	long pages = 0, ret;
 
 	range.start = 0;
 
-	pud = pud_offset(p4d, addr);
+	pudp = pud_offset(p4d, addr);
 	do {
+again:
 		next = pud_addr_end(addr, end);
-		ret = change_prepare(vma, pud, pmd, addr, cp_flags);
+		ret = change_prepare(vma, pudp, pmd, addr, cp_flags);
 		if (ret) {
 			pages = ret;
 			break;
 		}
-		if (pud_none_or_clear_bad(pud))
+
+		pud = READ_ONCE(*pudp);
+		if (pud_none(pud))
 			continue;
+
 		if (!range.start) {
 			mmu_notifier_range_init(&range,
 						MMU_NOTIFY_PROTECTION_VMA, 0,
 						vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
+
+		if (pud_leaf(pud)) {
+			if ((next - addr != PUD_SIZE) ||
+			    pgtable_split_needed(vma, cp_flags)) {
+				__split_huge_pud(vma, pudp, addr);
+				goto again;
+			} else {
+				ret = change_huge_pud(tlb, vma, pudp,
+						      addr, newprot, cp_flags);
+				if (ret == 0)
+					goto again;
+				/* huge pud was handled */
+				if (ret == HPAGE_PUD_NR)
+					pages += HPAGE_PUD_NR;
+				continue;
+			}
+		}
+
+		pages += change_pmd_range(tlb, vma, pudp, addr, next, newprot,
 					  cp_flags);
-	} while (pud++, addr = next, addr != end);
+	} while (pudp++, addr = next, addr != end);
 
 	if (range.start)
 		mmu_notifier_invalidate_range_end(&range);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-implement-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

