Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704FA2DECCB;
	Thu, 14 May 2026 00:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719245; cv=none; b=C3Mc4I6eKnAhTe5XWB6g1kmIto5EcQxZQ56dsuld4t+j7bBh4Uc5llpsOOKwUZ1ca554049RBhU/40zlPpLkLW9USySNUjhWoyU/xuPUIutkhj1ndBSuFoV0Ca14sj2inAjOlB3SEmmRSN/1MnmN1ialuMSLnQJYpoCwAD+b/8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719245; c=relaxed/simple;
	bh=XAyeEy4GxA9PfJacGuRzD6P63mOdoJPc92cyjAAm2EQ=;
	h=Date:To:From:Subject:Message-Id; b=qDex4zsKnjU1HtrNQV89J5Z7FJJ3wh4j60BTPtovIrpNAOEaub8GEghpCrkgN27u1L0I+3xT9PBFp6qcwxA/J3sEy0GffPjzH5cTN55d8qNk/hW993FujKRx7LQmRMc1uwvSJaZ36NmDneP/0eX0lSxk5Yo+bhmJRJQoFyjimqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j44iKPug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j44iKPug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF563C19425;
	Thu, 14 May 2026 00:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719245;
	bh=XAyeEy4GxA9PfJacGuRzD6P63mOdoJPc92cyjAAm2EQ=;
	h=Date:To:From:Subject:From;
	b=j44iKPug4Vb+PoskZ+VHjQcN98W5kXwhCst+YiOFwa8el+YnAn0VuLOecuQLbuvLe
	 x18J4pcf44CWIs1D7uolcMO/m9WeQcF3etwCSOAwUbDmGdQutc5Xq4A3P2L+9RO4+b
	 JSWJrQzH/CapZdMdlrkbz8ejR2r9Z2g2u0Pb78vU=
Date: Wed, 13 May 2026 17:40:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,maobibo@loongson.cn,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hughd@google.com,baolin.wang@linux.alibaba.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch removed from -mm tree
Message-Id: <20260514004044.EF563C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix __vm_normal_page() to handle missing support for pmd_special()/pud_special()
has been removed from the -mm tree.  Its filename was
     mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: fix __vm_normal_page() to handle missing support for pmd_special()/pud_special()
Date: Thu, 30 Apr 2026 13:31:22 +0200

On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed by
"BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s when
reclaim gets to call shrink_huge_zero_folio_scan().

It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd: and
indeed, whereas pte_special() and pte_mkspecial() are subject to a
dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled on
any 32-bit architecture.

While the problem was exposed through commit d80a9cb1a64a
("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()"), it was an
oversight in commit af38538801c6 ("mm/memory: factor out common code from
vm_normal_page_*()") and would result in other problems:
* huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
  numamaps as file-backed THP
* folio_walk_start() returning the folio even without FW_ZEROPAGE set.
  Callers seem to tolerate that, though.

... and triggering the VM_WARN_ON_ONE(), although never reported so far.

To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
whether pmd_special/pud_special is actually implemented.

Link: https://lore.kernel.org/20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org
Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
Reported-by: Bibo Mao <maobibo@loongson.cn>
Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
Debugged-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Bibo Mao <maobibo@loongson.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special
+++ a/mm/memory.c
@@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+
+static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
+	case PGTABLE_LEVEL_PMD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
+	case PGTABLE_LEVEL_PUD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
+	default:
+		return false;
+	}
+}
+
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
@@ -684,7 +699,7 @@ static inline struct page *__vm_normal_p
 		unsigned long addr, unsigned long pfn, bool special,
 		unsigned long long entry, enum pgtable_level level)
 {
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
 #ifdef CONFIG_FIND_NORMAL_PAGE
 			if (vma->vm_ops && vma->vm_ops->find_normal_page)
@@ -699,8 +714,9 @@ static inline struct page *__vm_normal_p
 			return NULL;
 		}
 		/*
-		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
-		 * mappings (incl. shared zero folios) are marked accordingly.
+		 * With working pte_special()/pmd_special()..., any special page
+		 * table mappings (incl. shared zero folios) are marked
+		 * accordingly.
 		 */
 	} else {
 		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
_

Patches currently in -mm which might be from david@kernel.org are

sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

