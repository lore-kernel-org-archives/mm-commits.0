Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE532D46D6
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959039; cv=none; b=F+SwT7D7oAgooLorrEWZmrHsV5NNKThU3pFlZPg+uAM4XLnZGn/OREG40ys5zKCl0T5mUq3R9CjqLuixvgvkEFcUgVJTapmo4HYPKmlzryrUwImqKJtDiO4qwXCaCbi0Vlgp3S3LbqrUoOoabVleaOLqHAePpNLSITcct5Stuzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959039; c=relaxed/simple;
	bh=PXmxiIrTgwkv1OW/zNE7Fh9RnPIWfivNWQQqhnsxQO0=;
	h=Date:To:From:Subject:Message-Id; b=l2b87cGqCyOFN+1DH9BuZD4N9vNUsC88Heo9lPlqFwBnvC5EyfRkLhuP7SyDQP7A3V0f3RT2buSv5vC9aicOhlZixakJFRkJUXxxigUW5UipIfNtsE+SHBeOkSMLAQDItUnrym0Lhevht6w6yCQgjnEY06n5uL7x1eWGKktJohc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wCIBp6Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCIBp6Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D726C4CEED;
	Tue, 12 Aug 2025 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959038;
	bh=PXmxiIrTgwkv1OW/zNE7Fh9RnPIWfivNWQQqhnsxQO0=;
	h=Date:To:From:Subject:From;
	b=wCIBp6QxTq57+hKulhCA0onlcKlTImyR0Ij3VtkQ8N23kPz7U9UydXDYmq8yHpCda
	 ihUg+qTdQ+pAasCJYVYWGEGvHo9RAY220yF4gMDaV9AxVMTIybB2WOeq6Z8VpqVgEp
	 9NB66ZO7gI24TxQoRyK13ojZFId98rJeLHmAIcsw=
Date: Mon, 11 Aug 2025 17:37:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch added to mm-new branch
Message-Id: <20250812003718.6D726C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: convert print_bad_pte() to print_bad_page_map()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: convert print_bad_pte() to print_bad_page_map()
Date: Mon, 11 Aug 2025 13:26:28 +0200

print_bad_pte() looks like something that should actually be a WARN or
similar, but historically it apparently has proven to be useful to detect
corruption of page tables even on production systems -- report the issue
and keep the system running to make it easier to actually detect what is
going wrong (e.g., multiple such messages might shed a light).

As we want to unify vm_normal_page_*() handling for PTE/PMD/PUD, we'll
have to take care of print_bad_pte() as well.

Let's prepare for using print_bad_pte() also for non-PTEs by adjusting the
implementation and renaming the function to print_bad_page_map().  Provide
print_bad_pte() as a simple wrapper.

Document the implicit locking requirements for the page table re-walk.

To make the function a bit more readable, factor out the ratelimit check
into is_bad_page_map_ratelimited() and place the printing of page table
content into __print_bad_page_map_pgtable().  We'll now dump information
from each level in a single line, and just stop the table walk once we hit
something that is not a present page table.

The report will now look something like (dumping pgd to pmd values):

[   77.943408] BUG: Bad page map in process XXX  pte:80000001233f5867
[   77.944077] addr:00007fd84bb1c000 vm_flags:08100071 anon_vma: ...
[   77.945186] pgd:10a89f067 p4d:10a89f067 pud:10e5a2067 pmd:105327067

Not using pgdp_get(), because that does not work properly on some arm
configs where pgd_t is an array.  Note that we are dumping all levels even
when levels are folded for simplicity.

Link: https://lkml.kernel.org/r/20250811112631.759341-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   19 ++++++
 mm/memory.c             |  104 ++++++++++++++++++++++++++++++--------
 2 files changed, 103 insertions(+), 20 deletions(-)

--- a/include/linux/pgtable.h~mm-memory-convert-print_bad_pte-to-print_bad_page_map
+++ a/include/linux/pgtable.h
@@ -1966,6 +1966,25 @@ enum pgtable_level {
 	PGTABLE_LEVEL_PGD,
 };
 
+static inline const char *pgtable_level_to_str(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return "pte";
+	case PGTABLE_LEVEL_PMD:
+		return "pmd";
+	case PGTABLE_LEVEL_PUD:
+		return "pud";
+	case PGTABLE_LEVEL_P4D:
+		return "p4d";
+	case PGTABLE_LEVEL_PGD:
+		return "pgd";
+	default:
+		VM_WARN_ON_ONCE(1);
+		return "unknown";
+	}
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
--- a/mm/memory.c~mm-memory-convert-print_bad_pte-to-print_bad_page_map
+++ a/mm/memory.c
@@ -491,22 +491,8 @@ static inline void add_mm_rss_vec(struct
 			add_mm_counter(mm, i, rss[i]);
 }
 
-/*
- * This function is called to print an error when a bad pte
- * is found. For example, we might have a PFN-mapped pte in
- * a region that doesn't allow it.
- *
- * The calling function must still handle the error.
- */
-static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
-			  pte_t pte, struct page *page)
+static bool is_bad_page_map_ratelimited(void)
 {
-	pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
-	p4d_t *p4d = p4d_offset(pgd, addr);
-	pud_t *pud = pud_offset(p4d, addr);
-	pmd_t *pmd = pmd_offset(pud, addr);
-	struct address_space *mapping;
-	pgoff_t index;
 	static unsigned long resume;
 	static unsigned long nr_shown;
 	static unsigned long nr_unshown;
@@ -518,7 +504,7 @@ static void print_bad_pte(struct vm_area
 	if (nr_shown == 60) {
 		if (time_before(jiffies, resume)) {
 			nr_unshown++;
-			return;
+			return true;
 		}
 		if (nr_unshown) {
 			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
@@ -529,15 +515,91 @@ static void print_bad_pte(struct vm_area
 	}
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
+	return false;
+}
+
+static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
+{
+	unsigned long long pgdv, p4dv, pudv, pmdv;
+	p4d_t p4d, *p4dp;
+	pud_t pud, *pudp;
+	pmd_t pmd, *pmdp;
+	pgd_t *pgdp;
+
+	/*
+	 * Although this looks like a fully lockless pgtable walk, it is not:
+	 * see locking requirements for print_bad_page_map().
+	 */
+	pgdp = pgd_offset(mm, addr);
+	pgdv = pgd_val(*pgdp);
+
+	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
+		pr_alert("pgd:%08llx\n", pgdv);
+		return;
+	}
+
+	p4dp = p4d_offset(pgdp, addr);
+	p4d = p4dp_get(p4dp);
+	p4dv = p4d_val(p4d);
+
+	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
+		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		return;
+	}
+
+	pudp = pud_offset(p4dp, addr);
+	pud = pudp_get(pudp);
+	pudv = pud_val(pud);
+
+	if (!pud_present(pud) || pud_leaf(pud)) {
+		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		return;
+	}
+
+	pmdp = pmd_offset(pudp, addr);
+	pmd = pmdp_get(pmdp);
+	pmdv = pmd_val(pmd);
+
+	/*
+	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
+	 * because the table should already be mapped by the caller and
+	 * doing another map would be bad. print_bad_page_map() should
+	 * already take care of printing the PTE.
+	 */
+	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
+		 p4dv, pudv, pmdv);
+}
+
+/*
+ * This function is called to print an error when a bad page table entry (e.g.,
+ * corrupted page table entry) is found. For example, we might have a
+ * PFN-mapped pte in a region that doesn't allow it.
+ *
+ * The calling function must still handle the error.
+ *
+ * This function must be called during a proper page table walk, as it will
+ * re-walk the page table to dump information: the caller MUST prevent page
+ * table teardown (by holding mmap, vma or rmap lock) and MUST hold the leaf
+ * page table lock.
+ */
+static void print_bad_page_map(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long long entry, struct page *page,
+		enum pgtable_level level)
+{
+	struct address_space *mapping;
+	pgoff_t index;
+
+	if (is_bad_page_map_ratelimited())
+		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
-		 current->comm,
-		 (long long)pte_val(pte), (long long)pmd_val(*pmd));
+	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
+		 pgtable_level_to_str(level), entry);
+	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
-		dump_page(page, "bad pte");
+		dump_page(page, "bad page map");
 	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
 		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
@@ -549,6 +611,8 @@ static void print_bad_pte(struct vm_area
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+#define print_bad_pte(vma, addr, pte, page) \
+	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

