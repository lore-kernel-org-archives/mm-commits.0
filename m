Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793646443;
	b=tCiYtdkjLZyMaaxlsQNNHFw329v/GEl3B3DW+wXzpEneCqStQ4RdgQCu0Q/AKa3sf9N9
	 dg6LHmhnayOUlHCrZugQCkp4ktz/izxeHdzcstq4ZNSWKB1M31B/B8FpqFPX+ufEm3PYX
	 kk0UdgKHvKRmufXeP+UfBEMgfGaTpBCBOBoHXfV/76NuTuvmeQWEBYYW3qQ2tE1PRVCZV
	 /jRyHojJ4jkInzjTtuSLxHEbud2wPdL/fK/QTUWKSr/1fU8zWvJ27nwS3Gnky+JIgA3Os
	 +wnF7plJY9i3pQRER3uk6mCrm2mhnPqaKLGsyVOfQlmjgAbWSnMK1BYYv6wyKyMdZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646443;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RtbW4FDNpuayij/Rdp3+zUcFoZ1lF+iD1jkd5vpTCqQ=;
	b=Wm7ES9Dh5Q7u/JXn/oAZsfwJUo5LH/0YFd3dtsxOPDlRVxTLRwaYhsVC76crKJ7wStsK
	 pUgJJnmetqjkk7iBL2w4rKpFtohaA+7VtmIXhllViYcO1xaxkE1kM4S1NxDYYCkYXCEy9
	 /jH3MJFQHJMSs9AllLdQxx2ffB8WVUCOrCPM3gB6evCSRv1c3d/Xgkje83nqjOwNMKck2
	 JAQzzx48K+kRmPApW+Myk6Yp8/Kpb65c0vp9q8dWK+gjZi2TktgHRFAwqEEQMRKsuM5vw
	 l46KQv+rGNO8Vc/hQedfQBQjKKTvJgNd928EVW+3CQo9pRuxcKIEgqzD2ysGE8u7fFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hDwX57AP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD61606A327
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hDwX57AP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990AD1F00A16;
	Mon,  2 Nov 2026 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793646442;
	bh=RtbW4FDNpuayij/Rdp3+zUcFoZ1lF+iD1jkd5vpTCqQ=;
	h=Date:To:From:Subject;
	b=hDwX57APpz3iAodgxnl6yoNPgq/2hevuzQZwVbqE9j03P2D5Njqap/eT3qdBRRWS7
	 gZBIjRrp5WTXuiSirutikvmYhojf5T52JoDEByulU0UbNvKhiIMd9E2JckUaWTy9mG
	 kLHzoVjmx9xhLgDpVaELPPgOIKNKyqKtnKQsD6kI=
Date: Mon, 02 Nov 2026 11:07:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,jack@suse.cz,hughd@google.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch added to mm-new branch
Message-Id: <20261102190722.990AD1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/shmem: remove truncated folios from the page cache in batches
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch

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
mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch

