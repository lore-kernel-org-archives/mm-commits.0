Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502A81AC7
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548689; cv=none; b=o4mdRD1r3eWcsiUQvyBQfTta+uGhLU/H0j/dAgrHgmM0+DQQ7L/hE8Rra98+7HNNIOe4v+sHj6+2yI9Ku1wFemvYPUFsj3YaiDMT1loKbACznngFIYmTuyaaAbzKECQw8kZNjn5nmAsJeN5driqdBBF1q/eMwnHz/fSGCPE0bJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548689; c=relaxed/simple;
	bh=/XbCzp5UAaPdMtQ5FvaR3c/fHsb81CAjbwi8sEbfv3A=;
	h=Date:To:From:Subject:Message-Id; b=IdOkhOtmY0IoupPxlTuSS34y5YkyRLpZDsPEkFnuXF3asNkH5xga/Ysg/9emLUCb06Of5bvdK123wIz26oESXesUlXvBYenz5rypZErWu8noIekBWnF1eiwRI6jA4r0xjIfvt3v8zSjFGFlqmkiq/qtzkJyX6ScWPdQLj9ETR3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXu6t6VI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXu6t6VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A22C433C7;
	Wed, 21 Feb 2024 20:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548689;
	bh=/XbCzp5UAaPdMtQ5FvaR3c/fHsb81CAjbwi8sEbfv3A=;
	h=Date:To:From:Subject:From;
	b=aXu6t6VIv+rIeFta7kunccgpgibXyvPuqwYNBPfSRSqQLd1lxYu2CzJl4GEL4QbHq
	 tqITP19VAHvydTs/Ik/Zjv0NlLy2Dg60hnoJzwnj+yyCkIuJKQGnVvWeUnNQ5TkLzO
	 AyOxeRowaostYNF8b11+SCyHARfjheAFh70M9TC8=
Date: Wed, 21 Feb 2024 12:51:28 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch added to mm-unstable branch
Message-Id: <20240221205129.54A22C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor writeback_get_batch() out of write_cache_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: factor writeback_get_batch() out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:43 +0100

This simple helper will be the basis of the writeback iterator.  To make
this work, we need to remember the current index and end positions in
writeback_control.

[hch@lst.de: heavily rebased, add helpers to get the tag and end index, don't keep the end index in struct writeback_control]
Link: https://lkml.kernel.org/r/20240215063649.2164017-9-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 +++
 mm/page-writeback.c       |   60 ++++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 22 deletions(-)

--- a/include/linux/writeback.h~writeback-factor-writeback_get_batch-out-of-write_cache_pages
+++ a/include/linux/writeback.h
@@ -11,6 +11,7 @@
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/blk_types.h>
+#include <linux/pagevec.h>
 
 struct bio;
 
@@ -40,6 +41,7 @@ enum writeback_sync_modes {
  * in a manner such that unspecified fields are set to zero.
  */
 struct writeback_control {
+	/* public fields that can be set and/or consumed by the caller: */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
@@ -77,6 +79,10 @@ struct writeback_control {
 	 */
 	struct swap_iocb **swap_plug;
 
+	/* internal fields used by the ->writepages implementation: */
+	struct folio_batch fbatch;
+	pgoff_t index;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct bdi_writeback *wb;	/* wb this writeback is issued under */
 	struct inode *inode;		/* inode being written out */
--- a/mm/page-writeback.c~writeback-factor-writeback_get_batch-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2392,6 +2392,29 @@ static bool folio_prepare_writeback(stru
 	return true;
 }
 
+static xa_mark_t wbc_to_tag(struct writeback_control *wbc)
+{
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		return PAGECACHE_TAG_TOWRITE;
+	return PAGECACHE_TAG_DIRTY;
+}
+
+static pgoff_t wbc_end(struct writeback_control *wbc)
+{
+	if (wbc->range_cyclic)
+		return -1;
+	return wbc->range_end >> PAGE_SHIFT;
+}
+
+static void writeback_get_batch(struct address_space *mapping,
+		struct writeback_control *wbc)
+{
+	folio_batch_release(&wbc->fbatch);
+	cond_resched();
+	filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
+			wbc_to_tag(wbc), &wbc->fbatch);
+}
+
 /**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
@@ -2429,38 +2452,32 @@ int write_cache_pages(struct address_spa
 {
 	int ret = 0;
 	int error;
-	struct folio_batch fbatch;
 	struct folio *folio;
-	int nr_folios;
-	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	xa_mark_t tag;
 
-	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* prev offset */
+		wbc->index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_SHIFT;
+		wbc->index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages) {
-		tag_pages_for_writeback(mapping, index, end);
-		tag = PAGECACHE_TAG_TOWRITE;
-	} else {
-		tag = PAGECACHE_TAG_DIRTY;
-	}
-	while (index <= end) {
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		tag_pages_for_writeback(mapping, wbc->index, end);
+
+	folio_batch_init(&wbc->fbatch);
+
+	while (wbc->index <= end) {
 		int i;
 
-		nr_folios = filemap_get_folios_tag(mapping, &index, end,
-				tag, &fbatch);
+		writeback_get_batch(mapping, wbc);
 
-		if (nr_folios == 0)
+		if (wbc->fbatch.nr == 0)
 			break;
 
-		for (i = 0; i < nr_folios; i++) {
-			folio = fbatch.folios[i];
+		for (i = 0; i < wbc->fbatch.nr; i++) {
+			folio = wbc->fbatch.folios[i];
+
 			folio_lock(folio);
 			if (!folio_prepare_writeback(mapping, wbc, folio)) {
 				folio_unlock(folio);
@@ -2498,8 +2515,6 @@ int write_cache_pages(struct address_spa
 					goto done;
 			}
 		}
-		folio_batch_release(&fbatch);
-		cond_resched();
 	}
 
 	/*
@@ -2512,6 +2527,7 @@ int write_cache_pages(struct address_spa
 	 * of the file if we are called again, which can only happen due to
 	 * -ENOMEM from the file system.
 	 */
+	folio_batch_release(&wbc->fbatch);
 	if (wbc->range_cyclic)
 		mapping->writeback_index = 0;
 	return ret;
@@ -2519,7 +2535,7 @@ int write_cache_pages(struct address_spa
 done:
 	if (wbc->range_cyclic)
 		mapping->writeback_index = folio->index + folio_nr_pages(folio);
-	folio_batch_release(&fbatch);
+	folio_batch_release(&wbc->fbatch);
 	return error;
 }
 EXPORT_SYMBOL(write_cache_pages);
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
highmem-add-kernel-doc-for-memcpy__folio.patch
rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

