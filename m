Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718781;
	b=w73gIgbl5BUwfRHgrRUdvepsSKAesOZLEH59PSz0uuwWu7P1rvwWNKV7FkhxZjGgcX/T
	 +TPVZBP4Wv6cOTKFqEXXmklVtkD62CuV2I3442Ci6NIp/SYlkleIo90Yf5Sc3a3105x11
	 50axiET9PGPTKzWAhRa4wyWVOKN9qDZhR4pGmqJflI8z9vnWXGPGHVtDw0Kx+rST10lqQ
	 tdP9W06qONq0wk9Mjq/MPiu5+uFGdm1q/lwYIJ33ek+y3mvqwI/GnMXWGMODY5TLjvNkH
	 ALPc9uBFbH1tFXuXzyKzI14YyTQPCVcZjJm0QucbeuEa8ha3KLTFp34qIzQfPlhFw1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718781;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5sf2BIy3/CGT6l30h4EMVNmsNX9kBRcSfThIG0f3VLQ=;
	b=M+cNFNObZHuJwnafGE/1upEos6oABJ9OgrQi3ysNApI865nxazAoKG0cbh1ob/UDl1il
	 A2cWIX7MXOAqlrzleL6V+cQMYVRuSUQW/Rn/MIBZXglXoQCTixFC3W1tKzejxE7cXCVHZ
	 qirCjozeIgb89BE7SRZjZ6SI+zftgQPEjfTU2FAbcT7obzlRG1fLIk3ADwYION2DhyU3j
	 F/o/D00qpiF3yEqYXk4PiuC58Ne/VUoHNi6R9/eyZ36VqBwDWDbtHvAlEKohftsrYlDNP
	 f+o9RnDVd9qCge7o7W//zXAUsP23XX9qibmAvtxuIP70oG8CJ0L1UKapyj30lGJxJsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=shRbz8TW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF053606B271
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=shRbz8TW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E3A1F0093A;
	Tue,  3 Nov 2026 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793718780;
	bh=5sf2BIy3/CGT6l30h4EMVNmsNX9kBRcSfThIG0f3VLQ=;
	h=Date:To:From:Subject;
	b=shRbz8TWYBu8aPMv5S0gmB/Ncn9WnbuVgc8B88JZIMOgDaDZcfhucPG5zrgxfh7vq
	 48OnJolP2vl9w6D56MuKc6nhhhP4Z7YVFELjpTUUuzPtJTwRKJZ0hqyROFqoNsDM1m
	 R5h6tCUqj1y1APs7gM0zDYqrFoha3hWuoQbpylNo=
Date: Tue, 03 Nov 2026 07:12:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,jack@suse.cz,hughd@google.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch removed from -mm tree
Message-Id: <20261103151300.66E3A1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/shmem: remove truncated folios from the page cache in batches
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: mm/shmem: remove truncated folios from the page cache in batches
Date: Thu, 29 Oct 2026 23:44:57 -0400

truncate_inode_pages_range() takes the folios it finds out of the page
cache with delete_from_page_cache_batch(), which takes the inode's i_lock
and the i_pages lock once for each batch of up to FOLIO_BATCH_SIZE folios.

shmem_undo_range() calls truncate_inode_folio() on each folio instead, so
filemap_remove_folio() takes and drops both locks once per folio. 
Truncating, punching or freeing a tmpfs file or memfd made of small
folios, such as a large /dev/shm segment, pays for that on every page.

Clean each folio up as truncate_inode_folio() does, collect the ones to
remove and take them out with delete_from_page_cache_batch(), which needs
truncate_cleanup_folio() outside mm/truncate.c.  Swap entries, and the
folios kept when undoing a failed fallocate(), stay out of the batch. 
Dropping an 8 GiB file of 4K folios, median of five runs, averaged over
two boots of each kernel, in a 32 vCPU VM:

                        before    after
  ftruncate() to 0     1163 ms   913 ms
  hole punch           1155 ms   914 ms
  close() of a memfd   1161 ms   914 ms
  unlink()             1162 ms   916 ms

Files of PMD-sized folios take 20-25 ms with or without this change.

Link: https://lore.kernel.org/20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 mm/internal.h |    1 +
 mm/shmem.c    |   16 +++++++++++++---
 mm/truncate.c |    2 +-
 3 files changed, 15 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches
+++ a/mm/internal.h
@@ -630,6 +630,7 @@ unsigned find_lock_entries(struct addres
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
+void truncate_cleanup_folio(struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
--- a/mm/shmem.c~mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches
+++ a/mm/shmem.c
@@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inod
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
+		struct folio_batch remove;
+
+		folio_batch_init(&remove);
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
@@ -1363,9 +1366,16 @@ static void shmem_undo_range(struct inod
 				continue;
 			}
 
-			if (!unfalloc || !folio_test_uptodate(folio))
-				truncate_inode_folio(mapping, folio);
-			folio_unlock(folio);
+			if (!unfalloc || !folio_test_uptodate(folio)) {
+				truncate_cleanup_folio(folio);
+				folio_batch_add(&remove, folio);
+			}
+		}
+		delete_from_page_cache_batch(mapping, &remove);
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			folio = fbatch.folios[i];
+			if (!xa_is_value(folio))
+				folio_unlock(folio);
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
--- a/mm/truncate.c~mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches
+++ a/mm/truncate.c
@@ -151,7 +151,7 @@ EXPORT_SYMBOL_GPL(folio_invalidate);
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
-static void truncate_cleanup_folio(struct folio *folio)
+void truncate_cleanup_folio(struct folio *folio)
 {
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch
word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch
kasan-test-cover-load_unaligned_zeropad.patch
mm-filemap-clear-page-cache-marks-once-when-removing-a-folio.patch

