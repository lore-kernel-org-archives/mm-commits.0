Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE8323D7E5
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 21:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143769; cv=none; b=XtO6zfmB70sJopAveYUeCqQH34IfSkB/qJNX5pvLKoWmN+LaO5yHGQTnrrSB7LV5OHBlC98JhUOM4XsxVFdXVuacynW7vbg9G4hQ7XHIajJsJh3AebIwy9D19bZLYYcpE/LszqzziaGzw0NG3kmNYEkAbOl1LNWZ5pahyyrC10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143769; c=relaxed/simple;
	bh=jApuNGPGGTsH4AgNOdXQ0dRHBA14gQcnbuDhiQuIC5g=;
	h=Date:To:From:Subject:Message-Id; b=H5spqBYQdsGYfYS4c9r5Oag/09ZJwNKElZkDyw9KFJ3QjgJojXv37eAvhsKZzxMk+xE/kMuse+1Qeng4floKOKyvD8Atil5/XfkQu9KP4z5rwUIAr7HRLB7Yx2DqspissVEI/8zQuFFEvITy84XWJw+6GU306kveACDC5zmfnxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyLa5mD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyLa5mD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E50C4CEF7;
	Wed, 17 Sep 2025 21:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758143769;
	bh=jApuNGPGGTsH4AgNOdXQ0dRHBA14gQcnbuDhiQuIC5g=;
	h=Date:To:From:Subject:From;
	b=gyLa5mD1Vf/jUnS4QUbcWtg/BDdKeUd7GpbLkEIWTCWRjAUltxf15xMAwdmMrkWba
	 qp2zW0mlnMr+sBfndGjYHzIPD9KtlBIikn/6Db5GxN65jL4aJXogjCwumnCJR49vM/
	 SXnRWWd81GkEXW9hTe+hq3LdVNlLhBiNacfbmvzc=
Date: Wed, 17 Sep 2025 14:16:08 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch added to mm-new branch
Message-Id: <20250917211609.21E50C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
has been added to the -mm mm-new branch.  Its filename is
     kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
Date: Wed, 17 Sep 2025 20:40:31 +0300

to make it clear that KHO operates on pages rather than on a random
physical address.

The kho_preserve_pages() will be also used in upcoming support for vmalloc
preservation.

Link: https://lkml.kernel.org/r/20250917174033.3810435-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
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
@@ -42,7 +43,7 @@ struct kho_serialization;
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_preserve_phys(phys_addr_t phys, size_t size);
+int kho_preserve_pages(struct page *page, unsigned int nr_pages);
 struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
@@ -65,7 +66,7 @@ static inline int kho_preserve_folio(str
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
+static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
--- a/kernel/kexec_handover.c~kho-replace-kho_preserve_phys-with-kho_preserve_pages
+++ a/kernel/kexec_handover.c
@@ -698,26 +698,23 @@ int kho_preserve_folio(struct folio *fol
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
+ * kho_restore_page() on each order 0 page.
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
@@ -737,7 +734,7 @@ int kho_preserve_phys(phys_addr_t phys,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_preserve_phys);
+EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
 /* Handling for debug/kho/out */
 
--- a/mm/memblock.c~kho-replace-kho_preserve_phys-with-kho_preserve_pages
+++ a/mm/memblock.c
@@ -2516,8 +2516,10 @@ static int reserve_mem_kho_finalize(stru
 
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

kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch
kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch
kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch

