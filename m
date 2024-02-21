Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A5D86625
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548693; cv=none; b=kccFu2zOSwBJ4JGgp08gsvuAT1DCjkvUsGh7En9hK6b4JjbYzBP6zl9TP68Q88y/QJjIym0oM5UNDjP5AS1l8DX7kaq7Z4YlJsJh1pArwSKK7buCdBmJCb4hks33JUZ03qBQBLZxVjZawPi4ILF+M+iHVH3pkeV+J6au+s5OJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548693; c=relaxed/simple;
	bh=0ZPz2paAIJsQKn+VII3qfvDVh+8LFozwvnmfMOMs+gY=;
	h=Date:To:From:Subject:Message-Id; b=CNiM3KInZ01iYFhOZ0d4z25apZjQcD3yT8FtNvGHT7LjNxbumI4eZTp+ezU1Q5MRC7NeNrwscCPfb3VI1sAhQ62ynPHsrdm4G+iV4aC0Xy0BODU6dLuz6LKsgl72hT+TAjPTMA1tbeRHCzdL1OT4pDTwYPuyHvcr/ciThVo6xks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0P+uUnwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0P+uUnwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18DDC433C7;
	Wed, 21 Feb 2024 20:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548693;
	bh=0ZPz2paAIJsQKn+VII3qfvDVh+8LFozwvnmfMOMs+gY=;
	h=Date:To:From:Subject:From;
	b=0P+uUnwDFXBahXZOBsQgA/MkY3IzpwbADX3oKVD1Iwm+xWeACUHYoJm4lVIl4dOSN
	 D8+mhut/4T5KUJ+jDannIkAl8QnWhLHSwjcfN1wXZI10pwe5/upq1DftvgccBVVvs/
	 57fm9sHjHtIoFFfNXPjGVPTwk9C8HV+zfUroLs+8=
Date: Wed, 21 Feb 2024 12:51:32 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-use-the-folio_batch-queue-iterator.patch added to mm-unstable branch
Message-Id: <20240221205132.F18DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: use the folio_batch queue iterator
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-use-the-folio_batch-queue-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-use-the-folio_batch-queue-iterator.patch

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
Subject: writeback: use the folio_batch queue iterator
Date: Thu, 15 Feb 2024 07:36:46 +0100

Instead of keeping our own local iterator variable, use the one just added
to folio_batch.

Link: https://lkml.kernel.org/r/20240215063649.2164017-12-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/mm/page-writeback.c~writeback-use-the-folio_batch-queue-iterator
+++ a/mm/page-writeback.c
@@ -2406,13 +2406,21 @@ static pgoff_t wbc_end(struct writeback_
 	return wbc->range_end >> PAGE_SHIFT;
 }
 
-static void writeback_get_batch(struct address_space *mapping,
+static struct folio *writeback_get_folio(struct address_space *mapping,
 		struct writeback_control *wbc)
 {
-	folio_batch_release(&wbc->fbatch);
-	cond_resched();
-	filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
-			wbc_to_tag(wbc), &wbc->fbatch);
+	struct folio *folio;
+
+	folio = folio_batch_next(&wbc->fbatch);
+	if (!folio) {
+		folio_batch_release(&wbc->fbatch);
+		cond_resched();
+		filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
+				wbc_to_tag(wbc), &wbc->fbatch);
+		folio = folio_batch_next(&wbc->fbatch);
+	}
+
+	return folio;
 }
 
 /**
@@ -2454,7 +2462,6 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct folio *folio;
 	pgoff_t end;		/* Inclusive */
-	int i = 0;
 
 	if (wbc->range_cyclic) {
 		wbc->index = mapping->writeback_index; /* prev offset */
@@ -2469,15 +2476,10 @@ int write_cache_pages(struct address_spa
 	folio_batch_init(&wbc->fbatch);
 
 	for (;;) {
-		if (i == wbc->fbatch.nr) {
-			writeback_get_batch(mapping, wbc);
-			i = 0;
-		}
-		if (wbc->fbatch.nr == 0)
+		folio = writeback_get_folio(mapping, wbc);
+		if (!folio)
 			break;
 
-		folio = wbc->fbatch.folios[i++];
-
 		folio_lock(folio);
 		if (!folio_prepare_writeback(mapping, wbc, folio)) {
 			folio_unlock(folio);
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

