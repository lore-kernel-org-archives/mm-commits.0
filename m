Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26383C1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854071; cv=none; b=N/Tc8Vw8IrQVVOP1lwlZ0yLYxPgidb/s+M88hffvk4DFyYo3P3UbQrtJJX2IQegFV/qFqdy65x5CyFD/5WzUPZ9P8Gr4psbrnhN7+lOid/F7ehjaSpvLSxt78bFbi456POSN/uVVB8jTfrQRZimCXoOklHGYjLDMGFhDND5d8Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854071; c=relaxed/simple;
	bh=FnEN0wlOEHFbv8QQ2A1Dr1kdEK3/gxomwdcAIwt1NDk=;
	h=Date:To:From:Subject:Message-Id; b=JbfFtLmUeJTEPbPjbrQlGPLAiseiLPfnZDoqZkOgTj4WITNwgxj3j7W6tInBvdSgnRyIlqhUsZaFQHUHuxDge8GJ4MghszXxvH1LfvUr0+psD49VR0yA7ZKFm7C2viqDJZ1lI3SUqPiXCAAoJqQSiWPocwWhDEDu0h6hPssMD6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bnab2rGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bnab2rGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD0C4CEE2;
	Tue, 18 Feb 2025 04:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854071;
	bh=FnEN0wlOEHFbv8QQ2A1Dr1kdEK3/gxomwdcAIwt1NDk=;
	h=Date:To:From:Subject:From;
	b=bnab2rGGpdmdrFpbsEutvXkMtlg7Nbk+8fymoKEouZBw66k8zm/HEhOfj2oChAsGF
	 sftAHWbWxtZ7rjYn2UKXCy9qfE8fNtO724ro8wS7q+yzQHXjgW/zYLdz4uEVdTNT1S
	 ksYNbCv9Vb79+BmNS9/ay86cpjl3snZ2VNYmQHi0=
Date: Mon, 17 Feb 2025 20:47:50 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch added to mm-unstable branch
Message-Id: <20250218044751.30CD0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
Date: Tue, 18 Feb 2025 14:55:24 +1100

The page ->mapping pointer can have magic values like
PAGE_MAPPING_DAX_SHARED and PAGE_MAPPING_ANON for page owner specific
usage.  Currently PAGE_MAPPING_DAX_SHARED and PAGE_MAPPING_ANON alias to
the same value.  This isn't a problem because FS DAX pages are never seen
by the anonymous mapping code and vice versa.

However a future change will make FS DAX pages more like normal pages, so
folio_test_anon() must not return true for a FS DAX page.

We could explicitly test for a FS DAX page in folio_test_anon(), etc. 
however the PAGE_MAPPING_DAX_SHARED flag isn't actually needed.  Instead
we can use the page->mapping field to implicitly track the first mapping
of a page.  If page->mapping is non-NULL it implies the page is associated
with a single mapping at page->index.  If the page is associated with a
second mapping clear page->mapping and set page->share to 1.

This is possible because a shared mapping implies the file-system
implements dax_holder_operations which makes the ->mapping and ->index,
which is a union with ->share, unused.

The page is considered shared when page->mapping == NULL and page->share >
0 or page->mapping != NULL, implying it is present in at least one address
space.  This also makes it easier for a future change to detect when a
page is first mapped into an address space which requires special
handling.

Link: https://lkml.kernel.org/r/c22f699202db0acee2f7039eb026e68261ce42d6.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                   |   55 +++++++++++++++++++++--------------
 include/linux/page-flags.h |    6 ---
 2 files changed, 33 insertions(+), 28 deletions(-)

--- a/fs/dax.c~fs-dax-remove-page_mapping_dax_shared-mapping-flag
+++ a/fs/dax.c
@@ -351,27 +351,40 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
+/*
+ * A DAX folio is considered shared if it has no mapping set and ->share (which
+ * shares the ->index field) is non-zero. Note this may return false even if the
+ * page is shared between multiple files but has not yet actually been mapped
+ * into multiple address spaces.
+ */
 static inline bool dax_folio_is_shared(struct folio *folio)
 {
-	return folio->mapping == PAGE_MAPPING_DAX_SHARED;
+	return !folio->mapping && folio->page.share;
 }
 
 /*
- * Set the folio->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
- * refcount.
+ * When it is called by dax_insert_entry(), the shared flag will indicate
+ * whether this entry is shared by multiple files. If the page has not
+ * previously been associated with any mappings the ->mapping and ->index
+ * fields will be set. If it has already been associated with a mapping
+ * the mapping will be cleared and the share count set. It's then up to
+ * reverse map users like memory_failure() to call back into the filesystem to
+ * recover ->mapping and ->index information. For example by implementing
+ * dax_holder_operations.
  */
-static inline void dax_folio_share_get(struct folio *folio)
+static void dax_folio_make_shared(struct folio *folio)
 {
-	if (folio->mapping != PAGE_MAPPING_DAX_SHARED) {
-		/*
-		 * Reset the index if the page was already mapped
-		 * regularly before.
-		 */
-		if (folio->mapping)
-			folio->page.share = 1;
-		folio->mapping = PAGE_MAPPING_DAX_SHARED;
-	}
-	folio->page.share++;
+	/*
+	 * folio is not currently shared so mark it as shared by clearing
+	 * folio->mapping.
+	 */
+	folio->mapping = NULL;
+
+	/*
+	 * folio has previously been mapped into one address space so set the
+	 * share count.
+	 */
+	folio->page.share = 1;
 }
 
 static inline unsigned long dax_folio_share_put(struct folio *folio)
@@ -379,12 +392,6 @@ static inline unsigned long dax_folio_sh
 	return --folio->page.share;
 }
 
-/*
- * When it is called in dax_insert_entry(), the shared flag will indicate
- * that whether this entry is shared by multiple files.  If so, set
- * the folio->mapping PAGE_MAPPING_DAX_SHARED, and use page->share
- * as refcount.
- */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
 		struct vm_area_struct *vma, unsigned long address, bool shared)
 {
@@ -398,8 +405,12 @@ static void dax_associate_entry(void *en
 	for_each_mapped_pfn(entry, pfn) {
 		struct folio *folio = pfn_folio(pfn);
 
-		if (shared) {
-			dax_folio_share_get(folio);
+		if (shared && (folio->mapping || folio->page.share)) {
+			if (folio->mapping)
+				dax_folio_make_shared(folio);
+
+			WARN_ON_ONCE(!folio->page.share);
+			folio->page.share++;
 		} else {
 			WARN_ON_ONCE(folio->mapping);
 			folio->mapping = mapping;
--- a/include/linux/page-flags.h~fs-dax-remove-page_mapping_dax_shared-mapping-flag
+++ a/include/linux/page-flags.h
@@ -710,12 +710,6 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
 #define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
-/*
- * Different with flags above, this flag is used only for fsdax mode.  It
- * indicates that this page->mapping is now under reflink case.
- */
-#define PAGE_MAPPING_DAX_SHARED	((void *)0x1)
-
 static __always_inline bool folio_mapping_flags(const struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
mm-rmap-add-support-for-pud-sized-mappings-to-rmap.patch
mm-huge_memory-add-vmf_insert_folio_pud.patch
mm-huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

