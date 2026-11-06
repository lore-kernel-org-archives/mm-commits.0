Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794004958;
	b=BadEQeCmtMcxbBzVTuWwPsjTpP0Mipaex0Nb6Jfh+xSqLZ2z2FnXwZrZGRm/wrMPopnX
	 gCj7T4LqGqCkpgTGPMIHdkeDnKwmZVVYXNPL2eiqNGCszjgBscJPwe8pL/JuHSASpxccf
	 KEEq3/5KTJI88uOKYeJau1b7LE6ShorHclAeWl5/lRLD6wfpnU1UB34HO+myZW1QJxJ80
	 fEJOOH6XVZoW+hRXuvaoht5ChgYEHLBWjV0tT0izcLRsG7OwMcxM07HLXZie5DGiT3jkU
	 x1jw8eTAFK050W8xqRGSr9Bb1nFsSZ0Usd0yocQt7Z5nWGrB0MvaLwYgX6e9saoNETQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794004958;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=uE0sxcenLX8vMqdpdQ3mIjJ/gBJVTyxS/yEtC1uNvHw=;
	b=G9JeNJpJoL0495p+vTK8PwmC9eUKvKwpKJSM6emiUMsToKQNVXhSOLhjiYHozzvR6fwR
	 Ax+hR/ksjDgFNhHIO5CDiIg/RYJjOTpPkj/RXY8p+LpfKdWkbFn6nkSGPyGEL2w5f//wW
	 mjAoHWXq0/XXyhFFdWIjyNEMao12B19Vcbre00+bmXelsW2qcpSVTa0KGFau9bcMpfWzG
	 dkqnyV5JIQhU2hL4Vc8lIu22WfXg9CpprtZHclsYAoLD01DkGe23H7yBiBrOOun9BoENV
	 pEFmg8zCTxmQhhfVT75CDJ7NGXGQUc4N/w5SmYKGFOOwAD5MwDW8zr4I4AZPhZJtcjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=D211BsAF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78A9606A336;
	Fri,  6 Nov 2026 22:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=D211BsAF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DB81F008A3;
	Fri,  6 Nov 2026 22:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794004957;
	bh=uE0sxcenLX8vMqdpdQ3mIjJ/gBJVTyxS/yEtC1uNvHw=;
	h=Date:To:Cc:From:Subject;
	b=D211BsAFHv6TIahVnlg+44RELo6EuNlUYGwf8tg3mZzP4YWkSuY/nRLKv794j5uAX
	 0lz/0NDd8qkb/xKgrfqwW8VhjZRrOFDDOXQHtduCak06PEbca+y8ckUNPFSiXaUGVz
	 W3gYuAYJJQdm1Q9J7Gd+Bkqf8OBQ++0HctiBXgAY=
Date: Fri, 06 Nov 2026 14:42:36 -0800
To: mm-commits@vger.kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
 stable@vger.kernel.org, shuah@kernel.org, ryan.roberts@arm.com,
 ritesh.list@gmail.com, peterx@redhat.com, nico.pache@linux.dev,
 maddy@linux.ibm.com, loic.molinari@collabora.com, ljs@kernel.org,
 liam@infradead.org, lance.yang@linux.dev, kas@kernel.org, jgg@ziepe.ca,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 azpijr@gmail.com, alex@shazbot.org, akpm@linux-foundation.org,
 khorenko@virtuozzo.com
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does.patch removed from -mm tree
Message-Id: <20261106224237.52DB81F008A3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: copy file THPs at fork like copy_present_ptes() does
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: mm/huge_memory: copy file THPs at fork like copy_present_ptes() does
Date: Wed, 04 Nov 2026 21:40:56 +0100

This fixes no bug: it makes fork copy a PMD the way copy_present_ptes()
copies a PTE. Until now copy_huge_pmd() skipped every folio PMD of a
non-anonymous VMA and left the child to fault them in again, while the
PTEs of the same VMA are copied.

Treat file folios as the PTE path does: take a reference, duplicate the
rmap and account them. fork then pays a reference and an rmap update
per PMD, and saves the child a fault per PMD it touches. The next patch
sends PFN mappings through the same tail.

That covers the VMAs vma_needs_copy() sends here:

- private file mappings with an anon_vma;
- VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP, and
  VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get from a
  guard region.

The DAX huge zero PMD is copied too, with a reference taken by
mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
file folio is copied and accounted like copy_nonpresent_pte() does, and
made read-only in both processes only in a CoW mapping. A device
private entry gets the same CoW check, as in copy_nonpresent_pte().

The copy then gets the same tail as __copy_present_ptes(): write
protect both sides in a CoW mapping, mark the child's copy clean in a
shared one, and drop the uffd-wp bit where the child is not armed. An
anonymous THP is now write protected only when its PMD is writable, as
a PTE is.

A page table is deposited under the copy where the fault paths deposit
one: in anonymous VMAs, and wherever the architecture needs one.

Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-2-c56d0d26f970@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261106084856.4b254c973694345ee58a9b63@linux-foundation.org
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org> # needed by the next patch
---

 mm/huge_memory.c |   63 +++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does
+++ a/mm/huge_memory.c
@@ -1897,12 +1897,13 @@ static void copy_huge_non_present_pmd(
 		pmd_t pmd, pgtable_t pgtable)
 {
 	softleaf_t entry = softleaf_from_pmd(pmd);
-	struct folio *src_folio;
+	struct folio *src_folio = softleaf_to_folio(entry);
 
 	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(pmd));
 
-	if (softleaf_is_migration_write(entry) ||
-	    softleaf_is_migration_read_exclusive(entry)) {
+	if ((softleaf_is_migration_write(entry) ||
+	     softleaf_is_migration_read_exclusive(entry)) &&
+	    vma_is_cow_mapping(src_vma)) {
 		entry = make_readable_migration_entry(swp_offset(entry));
 		pmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
@@ -1915,7 +1916,8 @@ static void copy_huge_non_present_pmd(
 		 * For device private entries, since there are no
 		 * read exclusive entries, writable = !readable
 		 */
-		if (softleaf_is_device_private_write(entry)) {
+		if (softleaf_is_device_private_write(entry) &&
+		    vma_is_cow_mapping(src_vma)) {
 			entry = make_readable_device_private_entry(swp_offset(entry));
 			pmd = softleaf_to_pmd(entry);
 
@@ -1926,7 +1928,6 @@ static void copy_huge_non_present_pmd(
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 
-		src_folio = softleaf_to_folio(entry);
 		VM_WARN_ON(!folio_test_large(src_folio));
 
 		folio_get(src_folio);
@@ -1938,9 +1939,11 @@ static void copy_huge_non_present_pmd(
 					    dst_vma, src_vma);
 	}
 
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	add_mm_counter(dst_mm, mm_counter(src_folio), HPAGE_PMD_NR);
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
@@ -1956,6 +1959,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
+	bool writable;
 
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
@@ -1976,13 +1980,11 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto set_pmd;
 	}
 
-	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(dst_vma))
-		return 0;
-
-	pgtable = pte_alloc_one(dst_mm);
-	if (unlikely(!pgtable))
-		goto out;
+	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(dst_mm);
+		if (unlikely(!pgtable))
+			goto out;
+	}
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -2000,7 +2002,8 @@ int copy_huge_pmd(struct mm_struct *dst_
 	}
 
 	if (unlikely(!pmd_trans_huge(pmd))) {
-		pte_free(dst_mm, pgtable);
+		if (pgtable)
+			pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
 	/*
@@ -2015,7 +2018,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		 * copy. It just takes a reference.
 		 */
 		mm_get_huge_zero_folio(dst_mm);
-		goto out_zero_page;
+		goto copy_pmd;
 	}
 
 	src_page = pmd_page(pmd);
@@ -2023,6 +2026,12 @@ int copy_huge_pmd(struct mm_struct *dst_
 	src_folio = page_folio(src_page);
 
 	folio_get(src_folio);
+	if (!folio_test_anon(src_folio)) {
+		folio_dup_file_rmap_pmd(src_folio, src_page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(src_folio),
+			       HPAGE_PMD_NR);
+		goto copy_pmd;
+	}
 	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
 		folio_put(src_folio);
@@ -2033,19 +2042,25 @@ int copy_huge_pmd(struct mm_struct *dst_
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-out_zero_page:
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+copy_pmd:
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 
-	/* See __copy_present_ptes(): restore accessible protection. */
+	/* See __copy_present_ptes(). */
+	writable = pmd_write(pmd);
 	if (!userfaultfd_protected(dst_vma)) {
 		if (userfaultfd_rwp(src_vma) && pmd_uffd(pmd))
 			pmd = pmd_modify(pmd, dst_vma->vm_page_prot);
 		pmd = pmd_clear_uffd(pmd);
 	}
-
-	pmdp_set_wrprotect(src_mm, addr, src_pmd);
-	pmd = pmd_wrprotect(pmd);
+	if (vma_is_cow_mapping(src_vma) && writable) {
+		pmdp_set_wrprotect(src_mm, addr, src_pmd);
+		pmd = pmd_wrprotect(pmd);
+	}
+	if (src_vma->vm_flags & VM_SHARED)
+		pmd = pmd_mkclean(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch

