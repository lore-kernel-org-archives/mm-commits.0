Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF12256C6D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758473540; cv=none; b=MyjVhS7/1HMxCDP0kHAO7nEjAUhjXkg2fZ6xq4UQ5fkfQlUz0Zqgm4TfjEEJHI8O2X4ap1l+m4i0FyKFV+W0NiAakZclI27K+u6K/y3uAE4oD4ytxN5ZoKH1kW0YJ4dAxfWIUkMlhJ9RcurbJEU5gH1C5hs/JWxm9TZv6TTFo2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758473540; c=relaxed/simple;
	bh=OWxWY2T9P0lo6hAMdAex4APgN/hY8m/t9m4kXwXvwsU=;
	h=Date:To:From:Subject:Message-Id; b=GRaPsXUishszKdwIc1HrltJsV7FZ0Svd7c7/jTGMHVci1bHUVFbJWb6UqjiW932ddKZEoS8zxw8QRpWGCquRsOdk0L8qzm9TqkIG37/49TMYRBV6vc6kt4XNSlM5b3L7KqI/K0jGsnkouBFs7b9CWSYuksCDhwJ9A3akNrS8ic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wMrbFfLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wMrbFfLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C31C4CEE7;
	Sun, 21 Sep 2025 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758473539;
	bh=OWxWY2T9P0lo6hAMdAex4APgN/hY8m/t9m4kXwXvwsU=;
	h=Date:To:From:Subject:From;
	b=wMrbFfLJtEBFd+tY19IqA/B7fBteUO81uNviTToLvJczkQaXxZC3ytxQcbJo5koID
	 Y6E66deChILfVeKEIse9sfiGYLoeDiZsLcMVO7Dhd7VM4U7xy79wqTstIT4Mt8dMqH
	 jUb9DGWw9zb9gEk/M3kks69aN6Bt01L9T2cHLGBs=
Date: Sun, 21 Sep 2025 09:52:19 -0700
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch added to mm-nonmm-unstable branch
Message-Id: <20250921165219.C8C31C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: replace kho_preserve_phys() with kho_preserve_pages()
Date: Sun, 21 Sep 2025 08:44:56 +0300

to make it clear that KHO operates on pages rather than on a random
physical address.

The kho_preserve_pages() will be also used in upcoming support for vmalloc
preservation.

Link: https://lkml.kernel.org/r/20250921054458.4043761-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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

