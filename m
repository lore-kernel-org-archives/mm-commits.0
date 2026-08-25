Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAFD346E75
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622888; cv=none; b=Xg1cmmBmJ+5/ttPIqJxFRBSFh54VtRbpuUlC3xyhJh95y/iD2Z61km3wbPnaSDlxQ7Ov0CSrLxR4gFAGY2UxOQ58Rv+X4fma2oO7uhXfNb7gbdR+BQlI+WUaoXJKuo+csE8bHrCT9yYV2+6mI5xEMHe9u1kpW0sOW+jNBswc44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622888; c=relaxed/simple;
	bh=Z96eHfAkQW0ekCjQZWgPMfSJ0NvdpQozeXWJvBq9JAE=;
	h=Date:To:From:Subject:Message-Id; b=ehW4X805ni3XXC8sLYt08whEYeWHuuMGbfzFvsQUE6WeEn/cIEOkWpAmhTT6sPBOhpwqegtec87flVEgXiREQUd6qcHxuj21/DYO6753GBrBtCSD+b/Lg2c9dYzWLgSl2VdMTajpoqCEHMOsX+W5GWzjD78tLaQAlz7tYh9tygw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZK1Stbtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZK1Stbtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D461F00A3A;
	Tue, 25 Aug 2026 01:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622886;
	bh=jUlQSSKIkFBsE47oq5OiyDi7KLk2eB6nmfx+q99Vjfs=;
	h=Date:To:From:Subject;
	b=ZK1StbttC3sFNdxywTG2ZXYtRPJW+c+jJQQTbhpTryGdTCUeuKOMeAhJYfZqcJCcs
	 fCMrWvOnjE5rxn9uO9U+Ax/L5J321w1agph9xVg4PexDs2dvAzKyKSVECQScOgMYrh
	 5AwfebugCpEuZIlJ3Fu5jT4WG+oS39X/eJVAf/ao=
Date: Mon, 24 Aug 2026 18:54:46 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-provide-a-shmem_write_folio-wrapper.patch removed from -mm tree
Message-Id: <20260825015446.D5D461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: shmem: provide a shmem_write_folio wrapper
has been removed from the -mm tree.  Its filename was
     shmem-provide-a-shmem_write_folio-wrapper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: shmem: provide a shmem_write_folio wrapper
Date: Mon, 13 Jul 2026 11:33:38 +0200

Patch series "better block swap batching and a different take on swap_ops
v5".

This series makes use of the swap_iocb for block as well so that it
doesn't do inefficient single-bio I/O, and then rebases the swap_ops from
Baoquan on top of the now very different method structure.

When running doing kernels builds, which is a workload that doesn't really
do much THP anonymous memory it still gets 2x clustering for writeout and
1.2x for reading back swap in.  The overall times do not actually change,
though.


This patch (of 7):

Provide a wrapper for the shmem abuses in drm to prepare for swap I/O
refactoring by keeping swap_iocb handling entirely contained in mm/.

Link: https://lore.kernel.org/20260713093350.2154226-1-hch@lst.de
Link: https://lore.kernel.org/20260713093350.2154226-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 +-
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 +-
 include/linux/shmem_fs.h                  |    5 +----
 mm/shmem.c                                |    7 ++++++-
 mm/swap.h                                 |    4 ++++
 5 files changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~shmem-provide-a-shmem_write_folio-wrapper
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -325,7 +325,7 @@ void __shmem_writeback(size_t size, stru
 		if (folio_mapped(folio))
 			folio_redirty_for_writepage(&wbc, folio);
 		else
-			error = shmem_writeout(folio, NULL, NULL);
+			error = shmem_write_folio(folio);
 	}
 }
 
--- a/drivers/gpu/drm/ttm/ttm_backup.c~shmem-provide-a-shmem_write_folio-wrapper
+++ a/drivers/gpu/drm/ttm/ttm_backup.c
@@ -160,7 +160,7 @@ ttm_backup_backup_folio(struct file *bac
 		if (writeback && !folio_mapped(to_folio) &&
 		    folio_clear_dirty_for_io(to_folio)) {
 			folio_set_reclaim(to_folio);
-			ret = shmem_writeout(to_folio, NULL, NULL);
+		ret = shmem_write_folio(to_folio);
 			if (!folio_test_writeback(to_folio))
 				folio_clear_reclaim(to_folio);
 			if (ret == AOP_WRITEPAGE_ACTIVATE)
--- a/include/linux/shmem_fs.h~shmem-provide-a-shmem_write_folio-wrapper
+++ a/include/linux/shmem_fs.h
@@ -12,8 +12,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/bits.h>
 
-struct swap_iocb;
-
 /* inode in-kernel data */
 
 #ifdef CONFIG_TMPFS_QUOTA
@@ -123,8 +121,7 @@ static inline bool shmem_mapping(const s
 void shmem_unlock_mapping(struct address_space *mapping);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
-int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
-		struct list_head *folio_list);
+int shmem_write_folio(struct folio *folio);
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
--- a/mm/shmem.c~shmem-provide-a-shmem_write_folio-wrapper
+++ a/mm/shmem.c
@@ -1751,7 +1751,12 @@ redirty:
 	folio_mark_dirty(folio);
 	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
 }
-EXPORT_SYMBOL_GPL(shmem_writeout);
+
+int shmem_write_folio(struct folio *folio)
+{
+	return shmem_writeout(folio, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(shmem_write_folio);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_TMPFS)
 static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
--- a/mm/swap.h~shmem-provide-a-shmem_write_folio-wrapper
+++ a/mm/swap.h
@@ -486,4 +486,8 @@ static inline unsigned int folio_swap_fl
 }
 
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from hch@lst.de are


