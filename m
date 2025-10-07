Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253623C513
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870162; cv=none; b=qAxrK/nKTXONnbLGZsOX9uYlm1FK86glys0YboS8ZvDzLWcVThZPUPqgbtUDavFefmpAK7Ww1O9WsEyR2qXYRbDB2WzEItBO3/fBE0ZeX0Spe8tzm3psBkEqW7M6UJDSY1zAi1XkxhUUb0RNRhRF3mLx1NJMw8teJ1Tv9p0IJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870162; c=relaxed/simple;
	bh=jc+D1T4XhGC+XGf6Ofr7xh2EHuA/jW4hRZGGMo7ZeTQ=;
	h=Date:To:From:Subject:Message-Id; b=Ynb9ve83YZzDTSmlPIoaooLNNpirQBPFS56ihN65Ov32V56sa57gLSw3l6rXJH4AOg577iKjYwNucpHhonp06DbxWNktLazErMSJvVJW2t+IIGDUcS1s44o7ncGrTvmcEWwSdpkp6/hOuii2dDGFV10kyJdZGv4MvjJG+xTmy9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jut1/UzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jut1/UzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C526DC4CEF1;
	Tue,  7 Oct 2025 20:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870161;
	bh=jc+D1T4XhGC+XGf6Ofr7xh2EHuA/jW4hRZGGMo7ZeTQ=;
	h=Date:To:From:Subject:From;
	b=jut1/UzVNN2SoTmg6FWqXpio3pYzexklMgzaZ7YMgh5o5AFT2BiBkI3NZtRltqydV
	 3HajQ7+JI57Nk0rBqtUin2Czz9Lwx7jaFIuUDLpN+sZS37mjnrtmRMbu9Cvqkz6aB5
	 xkO1ee424mxLAfIBBJ9Kz4Le7wwCdMlb89lZ6MSo=
Date: Tue, 07 Oct 2025 13:49:21 -0700
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch removed from -mm tree
Message-Id: <20251007204921.C526DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
has been removed from the -mm tree.  Its filename was
     kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
Date: Sun, 21 Sep 2025 08:44:56 +0300

to make it clear that KHO operates on pages rather than on a random
physical address.

The kho_preserve_pages() will be also used in upcoming support for vmalloc
preservation.

Link: https://lkml.kernel.org/r/20250921054458.4043761-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |    5 +++--
 kernel/kexec_handover.c        |   25 +++++++++++--------------
 mm/memblock.c                  |    4 +++-
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/include/linux/kexec_handover.h~kho-replace-kho_preserve_phys-with-kho_preserve_pages
+++ a/include/linux/kexec_handover.h
@@ -18,6 +18,7 @@ enum kho_event {
 
 struct folio;
 struct notifier_block;
+struct page;
 
 #define DECLARE_KHOSER_PTR(name, type) \
 	union {                        \
@@ -43,7 +44,7 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_preserve_phys(phys_addr_t phys, size_t size);
+int kho_preserve_pages(struct page *page, unsigned int nr_pages);
 struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
@@ -71,7 +72,7 @@ static inline int kho_preserve_folio(str
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
+static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
--- a/kernel/kexec_handover.c~kho-replace-kho_preserve_phys-with-kho_preserve_pages
+++ a/kernel/kexec_handover.c
@@ -725,26 +725,23 @@ int kho_preserve_folio(struct folio *fol
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
 /**
- * kho_preserve_phys - preserve a physically contiguous range across kexec.
- * @phys: physical address of the range.
- * @size: size of the range.
+ * kho_preserve_pages - preserve contiguous pages across kexec
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
  *
- * Instructs KHO to preserve the memory range from @phys to @phys + @size
- * across kexec.
+ * Preserve a contiguous list of order 0 pages. Must be restored using
+ * kho_restore_pages() to ensure the pages are restored properly as order 0.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_phys(phys_addr_t phys, size_t size)
+int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	unsigned long pfn = PHYS_PFN(phys);
+	struct kho_mem_track *track = &kho_out.ser.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn = start_pfn;
 	unsigned long failed_pfn = 0;
-	const unsigned long start_pfn = pfn;
-	const unsigned long end_pfn = PHYS_PFN(phys + size);
 	int err = 0;
-	struct kho_mem_track *track = &kho_out.ser.track;
-
-	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
-		return -EINVAL;
 
 	while (pfn < end_pfn) {
 		const unsigned int order =
@@ -764,7 +761,7 @@ int kho_preserve_phys(phys_addr_t phys,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_preserve_phys);
+EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
 /* Handling for debug/kho/out */
 
--- a/mm/memblock.c~kho-replace-kho_preserve_phys-with-kho_preserve_pages
+++ a/mm/memblock.c
@@ -2452,8 +2452,10 @@ static int reserve_mem_kho_finalize(stru
 
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_phys(map->start, map->size);
+		err |= kho_preserve_pages(page, nr_pages);
 	}
 
 	err |= kho_preserve_folio(page_folio(kho_fdt));
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

