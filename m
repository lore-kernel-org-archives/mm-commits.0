Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8CD1A2658
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274491; cv=none; b=Oe+ou/udnkFDJimTqkDNm8fT1T/huh0ACWLBGL4mrauAk8WSmWqC5WNFfs8FEJyE9FxY98BYnP0zQRgppJyIyJ55SPMtzEueEIglUWC15FT/zJqK2PuRGSM+G/TTpWb89NFKUtjTEOnYlZ3db867Xep4NNOir9rXL2LxZdMHPCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274491; c=relaxed/simple;
	bh=91VYGXUYHsNBjJUH19rhRFTBVFZxwXZi3TEhG2DQLA8=;
	h=Date:To:From:Subject:Message-Id; b=HZP2wb7ZVIBIrBBwU7Ix6m3jujjGNvUKhf8ObUw59FPkokXArU+mFIZQNbFlNGOkDmgoMpyxgeq00Ty++vFz31efCnoeo8ZC7nwCRB/GbSNLOXteyj/8X+f2IUpdBIDpqsAeZRN1qibkATqf46RWG0j47B5mzq7TWnr7IxgXKEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIVNIw6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIVNIw6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4175C4CEEE;
	Tue, 18 Mar 2025 05:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274490;
	bh=91VYGXUYHsNBjJUH19rhRFTBVFZxwXZi3TEhG2DQLA8=;
	h=Date:To:From:Subject:From;
	b=SIVNIw6Q1T3Gka38Pm32LFtnslaMmZXHUJybCFgRNkQFWphgmB120Hb1YM6Qe8JGl
	 2bgTbeCPh3FaXsnFHE4v7HQlgvT/qT2f4km3iYMgbh0YmFeHzrpvdEV4fl0ft9XjIW
	 n6Pu++KiD6Cc7X3mNNIZSxuu0rpERYA2KUiYxTck=
Date: Mon, 17 Mar 2025 22:08:10 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch removed from -mm tree
Message-Id: <20250318050810.C4175C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
has been removed from the -mm tree.  Its filename was
     fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: remove PAGE_MAPPING_DAX_SHARED mapping flag
Date: Fri, 28 Feb 2025 14:31:03 +1100

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

Link: https://lkml.kernel.org/r/c22f699202db0acee2f7039eb026e68261ce42d6.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
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
@@ -673,12 +673,6 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
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


