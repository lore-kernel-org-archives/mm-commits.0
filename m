Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0736418EFC1
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876690; cv=none; b=oj1GVYjld8nbBoE5Pgl+HwTEt+5O71F5lCu0xV7wXtQ91jZEti/g7can9Ccfqo81+Was0gsjLDrna6GRs24vrwxcVgv9BFRxJiox1EKvkDhcyZ79p/mYEuDMORcRVnj1AwOev7ELVH5R/GSIderLKO6zTXFZGcNK7JL/afHBiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876690; c=relaxed/simple;
	bh=hIQ/UlVOedDxNFZaXGfwajePdywyIJ5vAOK+BxN2nQc=;
	h=Date:To:From:Subject:Message-Id; b=U8v7jpn3ZdXIrfxm1dCITCcJR2VPQ8worbik924RlJw0Tz3WVj64OYk+5mfUParUIz4uKyMG/PCkDK3VN9SsysVS+l+9W91mnLkhoRO9ECcGAmL/H7F4yaDg37PGISLfXiK1gFHglKnqmEn9VtshfdYLTyE8/EbSPurpn4wp8wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EM9lEvX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EM9lEvX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4718C4CECF;
	Fri, 29 Nov 2024 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876689;
	bh=hIQ/UlVOedDxNFZaXGfwajePdywyIJ5vAOK+BxN2nQc=;
	h=Date:To:From:Subject:From;
	b=EM9lEvX0v+4fOW/ssc1qrB+E7lT5r3WnEzrERNDE8EVEal1nSLVADVIh7yX/sDJ3T
	 JDHKZVC/+VlKVr44r1dv4NrSr4taKyXTIjGy6o0c4BC+5s9va1TThA7dh9ackqGTBH
	 raf+aZFrgbhNwe8rdfp60tCPAXaZp/fq6vbPRE/s=
Date: Fri, 29 Nov 2024 02:38:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-large-folio-support-for-tmpfs.patch added to mm-unstable branch
Message-Id: <20241129103809.C4718C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add large folio support for tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-large-folio-support-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-large-folio-support-for-tmpfs.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add large folio support for tmpfs
Date: Thu, 28 Nov 2024 15:40:41 +0800

Add large folio support for tmpfs write and fallocate paths matching the
same high order preference mechanism used in the iomap buffered IO path as
used in __filemap_get_folio().

Add shmem_mapping_size_orders() to get a hint for the orders of the folio
based on the file size which takes care of the mapping requirements.

Traditionally, tmpfs only supported PMD-sized large folios.  However
nowadays with other file systems supporting any sized large folios, and
extending anonymous to support mTHP, we should not restrict tmpfs to
allocating only PMD-sized large folios, making it more special.  Instead,
we should allow tmpfs can allocate any sized large folios.

Considering that tmpfs already has the 'huge=' option to control the
PMD-sized large folios allocation, we can extend the 'huge=' option to
allow any sized large folios.  The semantics of the 'huge=' mount option
are:

huge=never: no any sized large folios
huge=always: any sized large folios
huge=within_size: like 'always' but respect the i_size
huge=advise: like 'always' if requested with madvise()

Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
allocate the PMD-sized huge folios if huge=always/within_size/advise is
set.

Moreover, the 'deny' and 'force' testing options controlled by
'/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
semantics.  The 'deny' can disable any sized large folios for tmpfs, while
the 'force' can enable PMD sized large folios for tmpfs.

Link: https://lkml.kernel.org/r/035bf55fbdebeff65f5cb2cdb9907b7d632c3228.1732779148.git.baolin.wang@linux.alibaba.com
Co-developed-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   99 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 18 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-large-folio-support-for-tmpfs
+++ a/mm/shmem.c
@@ -554,34 +554,100 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
+/**
+ * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
+ * @mapping: Target address_space.
+ * @index: The page index.
+ * @write_end: end of a write, could extend inode size.
+ *
+ * This returns huge orders for folios (when supported) based on the file size
+ * which the mapping currently allows at the given index. The index is relevant
+ * due to alignment considerations the mapping might have. The returned order
+ * may be less than the size passed.
+ *
+ * Return: The orders.
+ */
+static inline unsigned int
+shmem_mapping_size_orders(struct address_space *mapping, pgoff_t index, loff_t write_end)
+{
+	unsigned int order;
+	size_t size;
+
+	if (!mapping_large_folio_support(mapping) || !write_end)
+		return 0;
+
+	/* Calculate the write size based on the write_end */
+	size = write_end - (index << PAGE_SHIFT);
+	order = filemap_get_order(size);
+	if (!order)
+		return 0;
+
+	/* If we're not aligned, allocate a smaller folio */
+	if (index & ((1UL << order) - 1))
+		order = __ffs(index);
+
+	order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
+	return order > 0 ? BIT(order + 1) - 1 : 0;
+}
+
 static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 					      loff_t write_end, bool shmem_huge_force,
+					      struct vm_area_struct *vma,
 					      unsigned long vm_flags)
 {
+	unsigned int maybe_pmd_order = HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER ?
+		0 : BIT(HPAGE_PMD_ORDER);
+	unsigned long within_size_orders;
+	unsigned int order;
+	pgoff_t aligned_index;
 	loff_t i_size;
 
-	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
-		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return 0;
 	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
-		return BIT(HPAGE_PMD_ORDER);
+		return maybe_pmd_order;
 
+	/*
+	 * The huge order allocation for anon shmem is controlled through
+	 * the mTHP interface, so we still use PMD-sized huge order to
+	 * check whether global control is enabled.
+	 *
+	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
+	 * allocate huge pages due to lack of a write size hint.
+	 *
+	 * Otherwise, tmpfs will allow getting a highest order hint based on
+	 * the size of write and fallocate paths, then will try each allowable
+	 * huge orders.
+	 */
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-		return BIT(HPAGE_PMD_ORDER);
+		if (vma)
+			return maybe_pmd_order;
+
+		return shmem_mapping_size_orders(inode->i_mapping, index, write_end);
 	case SHMEM_HUGE_WITHIN_SIZE:
-		index = round_up(index + 1, HPAGE_PMD_NR);
-		i_size = max(write_end, i_size_read(inode));
-		i_size = round_up(i_size, PAGE_SIZE);
-		if (i_size >> PAGE_SHIFT >= index)
-			return BIT(HPAGE_PMD_ORDER);
+		if (vma)
+			within_size_orders = maybe_pmd_order;
+		else
+			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
+								       index, write_end);
+
+		order = highest_order(within_size_orders);
+		while (within_size_orders) {
+			aligned_index = round_up(index + 1, 1 << order);
+			i_size = max(write_end, i_size_read(inode));
+			i_size = round_up(i_size, PAGE_SIZE);
+			if (i_size >> PAGE_SHIFT >= aligned_index)
+				return within_size_orders;
+
+			order = next_order(&within_size_orders, order);
+		}
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
-			return BIT(HPAGE_PMD_ORDER);
+			return maybe_pmd_order;
 		fallthrough;
 	default:
 		return 0;
@@ -781,6 +847,7 @@ static unsigned long shmem_unused_huge_s
 
 static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 					      loff_t write_end, bool shmem_huge_force,
+					      struct vm_area_struct *vma,
 					      unsigned long vm_flags)
 {
 	return 0;
@@ -1176,7 +1243,7 @@ static int shmem_getattr(struct mnt_idma
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_huge_global_enabled(inode, 0, 0, false, 0))
+	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -1693,14 +1760,10 @@ unsigned long shmem_allowable_huge_order
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-						  shmem_huge_force, vm_flags);
-	if (!vma || !vma_is_anon_shmem(vma)) {
-		/*
-		 * For tmpfs, we now only support PMD sized THP if huge page
-		 * is enabled, otherwise fallback to order 0.
-		 */
+						  shmem_huge_force, vma, vm_flags);
+	/* Tmpfs huge pages allocation */
+	if (!vma || !vma_is_anon_shmem(vma))
 		return global_orders;
-	}
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

