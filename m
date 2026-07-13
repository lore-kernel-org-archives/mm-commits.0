Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F02773E5
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973801; cv=none; b=nZjHAQjh6pISJAnXo6GQuz//GkvSSYEEvcv9sdj2G/I/U7lpaPmIK5DnQ/wIMg9hHPLpf9+8x95EAIW5/clHwst4FQ2wfjISW4aB9GWhLJJpOy5oNDz6ZVzYN1oVypQCL0S9ay1SkAMFOaBZsfWYGATlyYvHZ0LDwnZUBkR7Y5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973801; c=relaxed/simple;
	bh=AlCCy21HPFBf02i0SoNWfbDPkklOYQ9MujYk1NQ4ecc=;
	h=Date:To:From:Subject:Message-Id; b=DeX3AXJTSBKMW2TDOP55gMEzwc9C+0lM+xgp6R1r3tMYE48+FPyiOY4hCnuisY5N1wPLvYLpTntuUy2s0zLCI9JyKGSrusYigDJrOFCG8NLDFaYSvR/Hos4xwjn3tAfkjFu27/aE7MR+kAaJoWNLPDneO1XkRlApz1hUacs+eq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cH7+1tHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH7+1tHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E5C1F000E9;
	Mon, 13 Jul 2026 20:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973800;
	bh=kBD3V4SGqOz/xgB6stXdDhKXratO2xfJglPjJ8ZFvQA=;
	h=Date:To:From:Subject;
	b=cH7+1tHKHBB+zPLQ4O8ZKX67txobSfQ3CnHDtR4lXNmowK78BYItJG6v8q8ytxF5B
	 P28jBOIlZn0bTh/5nv3xYyGJ3acxLQCXwONxT4pMv1k3KPJB5aRtonploaUyP2gbjv
	 ix9z96UNBb5gVwC3/2HJ6HI6RXkgR/U96aGKp07s=
Date: Mon, 13 Jul 2026 13:16:39 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-provide-a-shmem_write_folio-wrapper.patch added to mm-new branch
Message-Id: <20260713201640.10E5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: shmem: provide a shmem_write_folio wrapper
has been added to the -mm mm-new branch.  Its filename is
     shmem-provide-a-shmem_write_folio-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-provide-a-shmem_write_folio-wrapper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: Kairui Song <kasong@tencent.com>
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
@@ -117,7 +117,7 @@ ttm_backup_backup_page(struct file *back
 	if (writeback && !folio_mapped(to_folio) &&
 	    folio_clear_dirty_for_io(to_folio)) {
 		folio_set_reclaim(to_folio);
-		ret = shmem_writeout(to_folio, NULL, NULL);
+		ret = shmem_write_folio(to_folio);
 		if (!folio_test_writeback(to_folio))
 			folio_clear_reclaim(to_folio);
 		/*
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
@@ -1738,7 +1738,12 @@ redirty:
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
@@ -471,4 +471,8 @@ static inline unsigned int folio_swap_fl
 }
 
 #endif /* CONFIG_SWAP */
+
+int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
+		struct list_head *folio_list);
+
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

