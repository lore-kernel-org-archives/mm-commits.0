Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFAA2DB789
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783641181; cv=none; b=e6B4shP8PM7Z32hI9PHaf+nC3jpoMHaaPGqaN+I1j9W7/ITTDiJ/1b/a38OmKMUOT+GXceAANUTvWRvMvYOQtpCerbr/LbvinNCR1QesG55FxjMoCXf9YR0HwuseFVYE9pXNhb4ZjjisC/t7elw7LYO7IONIjvOqSE7wmQjVo1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783641181; c=relaxed/simple;
	bh=4o3mmK27xfSLWSSXb+9nR1WYy4Hrw5A45ZIyQA0I1i4=;
	h=Date:To:From:Subject:Message-Id; b=RpqJfontg3/dhjmTXcmS6e806Sr5G5FaTbKtoFLU8YYwJne4Jh9XUF5HSpuSBzzY4HVFhjgNZYWpf0n87wNFm3PNmdyI/1bpckZ23Bcd6/ywv+NGQTsZ5tedpY4xrRGR8rCZeuKAsqOvMle7KyJpta4/aYiRk1M8drtFacKwnQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIaQTuI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIaQTuI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEF31F000E9;
	Thu,  9 Jul 2026 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783641179;
	bh=cEz03mEAloWSoOwFDt/8f7L7bdnliaccX2odcwToyqU=;
	h=Date:To:From:Subject;
	b=GIaQTuI6S1nVrUClTcnqpLBZTGboj89w9Mpo2+P7evLklXNP5cFxdAyCjaWC/jwtX
	 cbKEc9VfeG3bUO7SYhkpMttvLcc5t62wBOK1B5/bx62pkFCkJJKMOril02YjfFsTH9
	 VoNJC71eWRlxtf+pmdAtHmxaXfO9J+fVm12bTmro=
Date: Thu, 09 Jul 2026 16:52:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,anshuman.khandual@arm.com,andriy.shevchenko@linux.intel.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-standardize-printing-for-pgtable-entries.patch added to mm-new branch
Message-Id: <20260709235259.1AEF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: standardize printing for pgtable entries
has been added to the -mm mm-new branch.  Its filename is
     mm-standardize-printing-for-pgtable-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-standardize-printing-for-pgtable-entries.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: standardize printing for pgtable entries
Date: Thu, 9 Jul 2026 10:13:34 +0530

Bad page map reporting currently stores page table entry values in an
unsigned long long and prints them with fixed 64-bit-oriented format
strings.  This is inconsistent across call sites and does not work well
for architectures where page table entry values are not naturally
represented as 64-bit values, such as 32-bit or 128-bit entries.

Introduce a common helper to convert raw page table entry values into a
fixed-width hexadecimal string based on the actual entry size.  Use it for
bad page map reporting and for dumping the page table walk in
__print_bad_page_map_pgtable().

Pass page table entry values to the reporting path as raw bytes together
with their size, instead of forcing them through an unsigned long long. 
It keeps the printed output consistent and avoids truncation or misleading
formatting for non-64-bit page table entries.

Link: https://lore.kernel.org/20260709044334.1741263-1-anshuman.khandual@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  102 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 23 deletions(-)

--- a/mm/memory.c~mm-standardize-printing-for-pgtable-entries
+++ a/mm/memory.c
@@ -519,9 +519,52 @@ static bool is_bad_page_map_ratelimited(
 	return false;
 }
 
+static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
+{
+	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
+		snprintf(buf, buf_size, "overflow");
+		return;
+	}
+
+	switch (entry_size) {
+	case sizeof(u32):
+		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
+		break;
+	case sizeof(u64):
+		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
+		break;
+#if defined(__SIZEOF_INT128__)
+	case sizeof(u128):
+		snprintf(buf, buf_size, "%016llx%016llx",
+			 (unsigned long long)(*(const u128 *)entry >> 64),
+			 (unsigned long long)*(const u128 *)entry);
+		break;
+#endif
+	default:
+		snprintf(buf, buf_size, "unsupported");
+		break;
+	}
+}
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		auto __val = (val);							\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
+#if defined(__SIZEOF_INT128__)
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+#else
+#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
+#endif
+
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
-	unsigned long long pgdv, p4dv, pudv, pmdv;
+	char pgd_str[PTVAL_STR_MAX];
+	char p4d_str[PTVAL_STR_MAX];
+	char pud_str[PTVAL_STR_MAX];
+	char pmd_str[PTVAL_STR_MAX];
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
@@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable
 	 * see locking requirements for print_bad_page_map().
 	 */
 	pgdp = pgd_offset(mm, addr);
-	pgdv = pgd_val(*pgdp);
+	ptval_to_str(pgd_str, pgd_val(*pgdp));
 
 	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
+		pr_alert("pgd:%s\n", pgd_str);
 		return;
 	}
 
 	p4dp = p4d_offset(pgdp, addr);
 	p4d = p4dp_get(p4dp);
-	p4dv = p4d_val(p4d);
+	ptval_to_str(p4d_str, p4d_val(p4d));
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd:%s p4d:%s\n", pgd_str, p4d_str);
 		return;
 	}
 
 	pudp = pud_offset(p4dp, addr);
 	pud = pudp_get(pudp);
-	pudv = pud_val(pud);
+	ptval_to_str(pud_str, pud_val(pud));
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd:%s p4d:%s pud:%s\n", pgd_str, p4d_str, pud_str);
 		return;
 	}
 
 	pmdp = pmd_offset(pudp, addr);
 	pmd = pmdp_get(pmdp);
-	pmdv = pmd_val(pmd);
+	ptval_to_str(pmd_str, pmd_val(pmd));
 
 	/*
 	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
@@ -567,8 +610,7 @@ static void __print_bad_page_map_pgtable
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pmd_str);
 }
 
 /*
@@ -584,10 +626,11 @@ static void __print_bad_page_map_pgtable
  * page table lock.
  */
 static void print_bad_page_map(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long long entry, struct page *page,
-		enum pgtable_level level)
+		unsigned long addr, const void *entry, size_t entry_size,
+		struct page *page, enum pgtable_level level)
 {
 	struct address_space *mapping;
+	char entry_str[PTVAL_STR_MAX];
 	pgoff_t index;
 
 	if (is_bad_page_map_ratelimited())
@@ -596,8 +639,9 @@ static void print_bad_page_map(struct vm
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
-		 pgtable_level_to_str(level), entry);
+	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
+	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
+		 pgtable_level_to_str(level), entry_str);
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
@@ -627,8 +671,13 @@ static inline bool pgtable_level_has_pxx
 	}
 }
 
-#define print_bad_pte(vma, addr, pte, page) \
-	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
+static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
+			  pte_t pte, struct page *page)
+{
+	auto entry = pte_val(pte);
+
+	print_bad_page_map(vma, addr, &entry, sizeof(entry), page, PGTABLE_LEVEL_PTE);
+}
 
 /**
  * __vm_normal_page() - Get the "struct page" associated with a page table entry.
@@ -636,8 +685,9 @@ static inline bool pgtable_level_has_pxx
  * @addr: The address where the page table entry is mapped.
  * @pfn: The PFN stored in the page table entry.
  * @special: Whether the page table entry is marked "special".
- * @level: The page table level for error reporting purposes only.
  * @entry: The page table entry value for error reporting purposes only.
+ * @entry_size: The size of @entry.
+ * @level: The page table level for error reporting purposes only.
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
@@ -697,7 +747,7 @@ static inline bool pgtable_level_has_pxx
  */
 static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
-		unsigned long long entry, enum pgtable_level level)
+		const void *entry, size_t entry_size, enum pgtable_level level)
 {
 	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
@@ -710,7 +760,7 @@ static inline struct page *__vm_normal_p
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
 
-			print_bad_page_map(vma, addr, entry, NULL, level);
+			print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 			return NULL;
 		}
 		/*
@@ -741,7 +791,7 @@ static inline struct page *__vm_normal_p
 
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		/* Corrupted page table entry. */
-		print_bad_page_map(vma, addr, entry, NULL, level);
+		print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
 		return NULL;
 	}
 	/*
@@ -767,8 +817,10 @@ static inline struct page *__vm_normal_p
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
+	auto entry = pte_val(pte);
+
 	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
-				pte_val(pte), PGTABLE_LEVEL_PTE);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -809,8 +861,10 @@ struct folio *vm_normal_folio(struct vm_
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
+	auto entry = pmd_val(pmd);
+
 	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
-				pmd_val(pmd), PGTABLE_LEVEL_PMD);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PMD);
 }
 
 /**
@@ -850,8 +904,10 @@ struct folio *vm_normal_folio_pmd(struct
 struct page *vm_normal_page_pud(struct vm_area_struct *vma,
 		unsigned long addr, pud_t pud)
 {
+	auto entry = pud_val(pud);
+
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
-				pud_val(pud), PGTABLE_LEVEL_PUD);
+				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
 }
 #endif
 
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

