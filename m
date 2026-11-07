Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023638;
	b=E4bcE/ousZpcz3mj55sf2WAiogwYQJn0XeBuuk9BTadxNH0c9Yc2AVIxVmwLxEf9JeTS
	 KMWo3llrkPv/OYqB6W1DcoQpbysxeyX0JYdeSufGZiiEm4tuf9PvQ4SC6SNJNLlOrurIw
	 DG5/pgk53gqmVLmBGYOMKlnueu92wg0xTEIro7yv47q8XHvWvG3L/eAZYCGA4yXu6qXYq
	 XpH5d2U6EOQPe/j+RVnBKxadsgsaVMBxQEQfq/AL/HcKSFa7QQtonR/wVm0aAvQZ73Oh/
	 6FMVVf8aVb7WuwbLFZd/ax6zja0ZDMKR+5gfrEd3k8/yks5o+5jgaD/n5IHRW/QtTcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023638;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0u+MaWXBCOlZDO0ZnMAd4UaUiILkftiB83UCQpfNmm4=;
	b=ffx8GYBQOEzsPjMNlRMp1UeonQO5cIVWfOswFa5mbaJtd+WOpZEVN86lwVfOJD2dEAkF
	 UIrwDQt++WsKVRTt0gYh+k5PAyGtByjiZfGkcfcgTWPUBqSafWo5jb/hJW2q/EVPYmOv4
	 YVwhed9pumdyLXxSq0ZukMAXMg19z3y85IqS0XFgJB0R7tY0ZkYiaaqku/v5Unp2U237O
	 lT+2tYTeQk212t770g1SeIlbRhhzzjRy4JcFrz+iCOFXV/wjlH5fEiSd6maBnyYjz7v18
	 x1Smb2urbu0HHjHVZ2ppIj8i3wR81AolttEQ1xbN/wCQShNL4OBNEPSWk/Nh9PckErA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DBXAm7kq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216F606A32F
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DBXAm7kq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBEB1F008A5;
	Sat,  7 Nov 2026 03:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023638;
	bh=0u+MaWXBCOlZDO0ZnMAd4UaUiILkftiB83UCQpfNmm4=;
	h=Date:To:From:Subject;
	b=DBXAm7kqikYNq5fppS76aSXDARmFc+a/qWyR2h0pCjUSoZzCQkd0j6JwfY7+nxYeA
	 NK25yCf5NAZ7pXQdOmlrbla33Z1olK+94JpyXwt8F6DQOyxqjHS1Gai66hAUS7Cugs
	 1WW1qV3LG4ZeJrLtfquMdz/7RMC1Yr9qNfsYYpNQ=
Date: Fri, 06 Nov 2026 19:53:57 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch added to mm-unstable branch
Message-Id: <20261107035358.1DBEB1F008A5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Sat, 07 Nov 2026 10:27:56 +0800

Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
operation, but the current interface exposes a raw address range and
hardcodes deferred TLB flushing.  This splits the common mechanism
across layers and couples it to the HugeTLB batching policy.

Make the folio the unit of PTE conversion and let callers select the TLB
flush policy through the folio-oriented interface.  This keeps
HugeTLB-specific eligibility and batching outside the common operation.

No functional change intended.

Link: https://lore.kernel.org/20261107022756.77731-14-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented
+++ a/mm/hugetlb_vmemmap.c
@@ -300,19 +300,22 @@ static inline int vmemmap_restore_range(
 }
 
 /**
- * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
- *                      backing PMDs of the directmap into PTEs
- * @start:     start address of the vmemmap virtual address range that we want
- *             to remap.
- * @end:       end address of the vmemmap virtual address range that we want to
- *             remap.
+ * vmemmap_pteify_folio - convert the vmemmap backing of a folio to PTE mappings
+ * @folio:	folio whose vmemmap range should be converted to PTE mappings.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Convert mappings covering @folio's vmemmap into PTE mappings. If TLB flushing
+ * is skipped, the caller must flush TLBs after all pteify operations are complete
+ * before remapping the folio's vmemmap pages.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end)
+static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= NULL,
-		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
+		.flags		= flags,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -537,21 +540,13 @@ void hugetlb_vmemmap_optimize_folio(cons
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
+static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
+		unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end]
-	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
+	return vmemmap_pteify_folio(folio, flags);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
@@ -576,7 +571,7 @@ void hugetlb_vmemmap_optimize_folios(str
 
 		nr_to_optimize++;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

