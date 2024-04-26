Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C874578C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103899; cv=none; b=GtwdNoMqBoe9WRAAMRegTkotvkD/km5ufK6a3Zex1nIWWlOFF1MXvHaBG6HmVTiTAk8I/q7xRgfccSAgSIvCYPlltWFt3epZv10NYuiXHqM39wZm7K5i5TorsNBOK8X0v5XP8XCgvCNiQcRgaeNpH/bCe7ecgWP3FHmuG6G4JBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103899; c=relaxed/simple;
	bh=3BTEtg6wUBCOQzgMB1DXTxj9IOqhFkoFafPL6z7mzds=;
	h=Date:To:From:Subject:Message-Id; b=luFFqXw43sbW9GDSHnNQWL11ha21fZieNkk0kvD/t6tvKToHm/VV+Kep6et4NmKHhkSv0wd39Qfdv7naXHuM12xC8XL5VWi+1v7WXoyEUiBLtJVbjwAGIbKw9ZJ99xttLk6KWiTjmmh6hcd8jhp6GY5WBC0h7whTM20eFQPvf0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V3tM3fwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V3tM3fwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E60BC113CD;
	Fri, 26 Apr 2024 03:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103899;
	bh=3BTEtg6wUBCOQzgMB1DXTxj9IOqhFkoFafPL6z7mzds=;
	h=Date:To:From:Subject:From;
	b=V3tM3fwShPCFzZ8L/rvbAS/6xyU26JbvJxIyiKq4jKcc1fj2bqnfD1HG2jSKfimDf
	 eN6EvFGxEclOmaI22eaYFSrcFFt4cuqfYrtsLj29c6bQ8TUw/gUJoZ7gKPOO4IuwjX
	 XgAMxnFOBZgtdn0ZJxxXiSg6qa8gd/S7nKk3oA04=
Date: Thu, 25 Apr 2024 20:58:19 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch removed from -mm tree
Message-Id: <20240426035819.9E60BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: change alloc_pages name in dma_map_ops to avoid name conflicts
has been removed from the -mm tree.  Its filename was
     change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: change alloc_pages name in dma_map_ops to avoid name conflicts
Date: Thu, 21 Mar 2024 09:36:39 -0700

After redefining alloc_pages, all uses of that name are being replaced. 
Change the conflicting names to prevent preprocessor from replacing them
when it's not intended.

Link: https://lkml.kernel.org/r/20240321163705.3067592-18-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c           |    2 +-
 arch/mips/jazz/jazzdma.c                |    2 +-
 arch/powerpc/kernel/dma-iommu.c         |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
 arch/powerpc/platforms/pseries/vio.c    |    2 +-
 arch/x86/kernel/amd_gart_64.c           |    2 +-
 drivers/iommu/dma-iommu.c               |    2 +-
 drivers/parisc/ccio-dma.c               |    2 +-
 drivers/parisc/sba_iommu.c              |    2 +-
 drivers/xen/grant-dma-ops.c             |    2 +-
 drivers/xen/swiotlb-xen.c               |    2 +-
 include/linux/dma-map-ops.h             |    2 +-
 kernel/dma/mapping.c                    |    4 ++--
 13 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/alpha/kernel/pci_iommu.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -929,7 +929,7 @@ const struct dma_map_ops alpha_pci_ops =
 	.dma_supported		= alpha_pci_supported,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages		= dma_common_alloc_pages,
+	.alloc_pages_op		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(alpha_pci_ops);
--- a/arch/mips/jazz/jazzdma.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/mips/jazz/jazzdma.c
@@ -617,7 +617,7 @@ const struct dma_map_ops jazz_dma_ops =
 	.sync_sg_for_device	= jazz_dma_sync_sg_for_device,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages		= dma_common_alloc_pages,
+	.alloc_pages_op		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
 EXPORT_SYMBOL(jazz_dma_ops);
--- a/arch/powerpc/kernel/dma-iommu.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/powerpc/kernel/dma-iommu.c
@@ -216,6 +216,6 @@ const struct dma_map_ops dma_iommu_ops =
 	.get_required_mask	= dma_iommu_get_required_mask,
 	.mmap			= dma_common_mmap,
 	.get_sgtable		= dma_common_get_sgtable,
-	.alloc_pages		= dma_common_alloc_pages,
+	.alloc_pages_op		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 };
--- a/arch/powerpc/platforms/ps3/system-bus.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/powerpc/platforms/ps3/system-bus.c
@@ -695,7 +695,7 @@ static const struct dma_map_ops ps3_sb_d
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages = dma_common_alloc_pages,
+	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 };
 
@@ -709,7 +709,7 @@ static const struct dma_map_ops ps3_ioc0
 	.unmap_page = ps3_unmap_page,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages = dma_common_alloc_pages,
+	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 };
 
--- a/arch/powerpc/platforms/pseries/vio.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/powerpc/platforms/pseries/vio.c
@@ -611,7 +611,7 @@ static const struct dma_map_ops vio_dma_
 	.get_required_mask = dma_iommu_get_required_mask,
 	.mmap		   = dma_common_mmap,
 	.get_sgtable	   = dma_common_get_sgtable,
-	.alloc_pages	   = dma_common_alloc_pages,
+	.alloc_pages_op	   = dma_common_alloc_pages,
 	.free_pages	   = dma_common_free_pages,
 };
 
--- a/arch/x86/kernel/amd_gart_64.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -676,7 +676,7 @@ static const struct dma_map_ops gart_dma
 	.get_sgtable			= dma_common_get_sgtable,
 	.dma_supported			= dma_direct_supported,
 	.get_required_mask		= dma_direct_get_required_mask,
-	.alloc_pages			= dma_direct_alloc_pages,
+	.alloc_pages_op			= dma_direct_alloc_pages,
 	.free_pages			= dma_direct_free_pages,
 };
 
--- a/drivers/iommu/dma-iommu.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/drivers/iommu/dma-iommu.c
@@ -1723,7 +1723,7 @@ static const struct dma_map_ops iommu_dm
 	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
 	.alloc			= iommu_dma_alloc,
 	.free			= iommu_dma_free,
-	.alloc_pages		= dma_common_alloc_pages,
+	.alloc_pages_op		= dma_common_alloc_pages,
 	.free_pages		= dma_common_free_pages,
 	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
 	.free_noncontiguous	= iommu_dma_free_noncontiguous,
--- a/drivers/parisc/ccio-dma.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/drivers/parisc/ccio-dma.c
@@ -1022,7 +1022,7 @@ static const struct dma_map_ops ccio_ops
 	.map_sg =		ccio_map_sg,
 	.unmap_sg =		ccio_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
-	.alloc_pages =		dma_common_alloc_pages,
+	.alloc_pages_op =	dma_common_alloc_pages,
 	.free_pages =		dma_common_free_pages,
 };
 
--- a/drivers/parisc/sba_iommu.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/drivers/parisc/sba_iommu.c
@@ -1090,7 +1090,7 @@ static const struct dma_map_ops sba_ops
 	.map_sg =		sba_map_sg,
 	.unmap_sg =		sba_unmap_sg,
 	.get_sgtable =		dma_common_get_sgtable,
-	.alloc_pages =		dma_common_alloc_pages,
+	.alloc_pages_op =	dma_common_alloc_pages,
 	.free_pages =		dma_common_free_pages,
 };
 
--- a/drivers/xen/grant-dma-ops.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/drivers/xen/grant-dma-ops.c
@@ -282,7 +282,7 @@ static int xen_grant_dma_supported(struc
 static const struct dma_map_ops xen_grant_dma_ops = {
 	.alloc = xen_grant_dma_alloc,
 	.free = xen_grant_dma_free,
-	.alloc_pages = xen_grant_dma_alloc_pages,
+	.alloc_pages_op = xen_grant_dma_alloc_pages,
 	.free_pages = xen_grant_dma_free_pages,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
--- a/drivers/xen/swiotlb-xen.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/drivers/xen/swiotlb-xen.c
@@ -403,7 +403,7 @@ const struct dma_map_ops xen_swiotlb_dma
 	.dma_supported = xen_swiotlb_dma_supported,
 	.mmap = dma_common_mmap,
 	.get_sgtable = dma_common_get_sgtable,
-	.alloc_pages = dma_common_alloc_pages,
+	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
 };
--- a/include/linux/dma-map-ops.h~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/include/linux/dma-map-ops.h
@@ -29,7 +29,7 @@ struct dma_map_ops {
 			unsigned long attrs);
 	void (*free)(struct device *dev, size_t size, void *vaddr,
 			dma_addr_t dma_handle, unsigned long attrs);
-	struct page *(*alloc_pages)(struct device *dev, size_t size,
+	struct page *(*alloc_pages_op)(struct device *dev, size_t size,
 			dma_addr_t *dma_handle, enum dma_data_direction dir,
 			gfp_t gfp);
 	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
--- a/kernel/dma/mapping.c~change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts
+++ a/kernel/dma/mapping.c
@@ -570,9 +570,9 @@ static struct page *__dma_alloc_pages(st
 	size = PAGE_ALIGN(size);
 	if (dma_alloc_direct(dev, ops))
 		return dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
-	if (!ops->alloc_pages)
+	if (!ops->alloc_pages_op)
 		return NULL;
-	return ops->alloc_pages(dev, size, dma_handle, dir, gfp);
+	return ops->alloc_pages_op(dev, size, dma_handle, dir, gfp);
 }
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

