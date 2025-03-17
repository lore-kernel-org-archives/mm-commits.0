Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C669213C8EA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186008; cv=none; b=Y1jplFyHECCSzgsT84SLX+VF/cx3xa9KsA+HeRl5jWEwpNGZUkqE6StRBzgHBK+GGK5HpNd5SB7lojzjKkST75NZ/0l0ml9jzsczaj9ioTTpBobmqjo2bce7UHk0FfnZf7BtMAa/OK/d1zy8Mz3b3kkTP3TkoYBvb5GBR0tF/+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186008; c=relaxed/simple;
	bh=U2CqJ4XdrDTrUwWijCYb9pNZk7ypv7tJOenVmjtvb4A=;
	h=Date:To:From:Subject:Message-Id; b=rSGkrfV7MDLhQRMLwW8Y6Q8Rf9FF9IpKSiO63IFf3etlFa8GlSepiCZF9klMMpK291Gy1ft8qEVyo5G1U4TBt+yfGcvWdlDPQg9qEich1nUHQVzTPOrAuLhCAaw74dyPkg2IdS77Zrbprr4godIeCMF8061Yr8DzZSj+qan4nNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vile0UpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vile0UpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393DAC4CEEC;
	Mon, 17 Mar 2025 04:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186008;
	bh=U2CqJ4XdrDTrUwWijCYb9pNZk7ypv7tJOenVmjtvb4A=;
	h=Date:To:From:Subject:From;
	b=Vile0UpXD9M6bPWoL+7N6Us8P1ytFjbEXNx5zQT0AUaPnPKH4kjUC7kNiOUipwfYi
	 zmka25ArTPSphjn4SZtMnzl19yCJe3kfUZS9qHnCJdBenuBAGoVxEmklUdh0wvdj/Z
	 sinho6Z6NFUngpDzWS9OXoWrPOy3T4/gTnRHS1QY=
Date: Sun, 16 Mar 2025 21:33:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch removed from -mm tree
Message-Id: <20250317043328.393DAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fixup unused variable warnings
has been removed from the -mm tree.  Its filename was
     fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

This patch was dropped because it was folded into fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: fixup unused variable warnings
Date: Sun, 9 Feb 2025 06:29:25 +0000

Unfortunately fb_defio being enabled by nommu devices seems enormously
ingrained in the kernel to the point that it's not feasible to address
that in this series, so we use an ifdef to workaround.

However this workaround unfortunately missed some unused variables -
correct this.

This has been tested locally with W=1 and confirmed to resolve the issue.

Link: https://lkml.kernel.org/r/d4018405-2762-4385-a816-e54cc23839ac@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -265,15 +265,15 @@ static void fb_deferred_io_work(struct w
 
 	/* here we wrprotect the page's mappings, then do all deferred IO. */
 	mutex_lock(&fbdefio->lock);
+#ifdef CONFIG_MMU
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
 		struct page *page = pageref->page;
 		pgoff_t pgoff = pageref->offset >> PAGE_SHIFT;
 
-#ifdef CONFIG_MMU
 		mapping_wrprotect_range(fbdefio->mapping, pgoff,
 					page_to_pfn(page), 1);
-#endif
 	}
+#endif
 
 	/* driver's callback with pagereflist */
 	fbdefio->deferred_io(info, &fbdefio->pagereflist);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

