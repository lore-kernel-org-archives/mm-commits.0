Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4CD2EFD95
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334229; cv=none; b=dmNUrmZfrm8yLwcmyimUxXBe8LMg6W0/IhioCdT5eYBBLLok/ArUohzfd5jgvv92H1AeXPxOfeIsAT45AgXrREIa8bsiNmSYQ1Y7jdZnj0kePtcwVlwQ00NSGlqUq0LwH16vJGX5t4qIEHg1NdUTiHK1jGydfA/OkxI6m3KI1TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334229; c=relaxed/simple;
	bh=qMMwHQ5M4jmsaAjD5KYp2P1OqrvWFWhjTxyvrhGFIks=;
	h=Date:To:From:Subject:Message-Id; b=fNg8yP2HxGAGzXyp0uT3PiJUoshx8wNb010bWxVkiqdAzLp/hOzV1OoMCSpSg0KM6UMQ+71uaordUmZtyhxRA6n5IaGiiksvqZD6GwCoSqt0Syql7sXyEjMRiT0F1jjbEonfS3KbVd7XisZPooOOBD8zuipODiY7hYA5pQXGxDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L0K2fSe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L0K2fSe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B0D1F0089C;
	Wed,  7 Oct 2026 00:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334227;
	bh=hjrraBz9VjdXr01oW/sedoUCC8PygImTjEKVyuSROeQ=;
	h=Date:To:From:Subject;
	b=L0K2fSe1AntDjQYBNzNgxLWJP2qa04qoABhz8HoiE/2ccdnrFeykYco6Xhz5sIRim
	 4ne8/+yZDa6GIzr0oJOIN24ffTbZUpUibwkk3aLG63mKi6ToSPuHWkeT+xe7vt/qdX
	 A1w73kj7u12Rw/8GneZPh5L4clAsmShCw5Dq6eow=
Date: Tue, 06 Oct 2026 17:50:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hch@lst.de,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-convert-write-completion-handlers-to-folios.patch removed from -mm tree
Message-Id: <20261007005027.C4B0D1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: convert write completion handlers to folios
has been removed from the -mm tree.  Its filename was
     mm-page_io-convert-write-completion-handlers-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: convert write completion handlers to folios
Date: Sat, 29 Aug 2026 15:09:00 -0400

Patch series "mm/page_io: folio conversion cleanups", v2.

Convert the remaining struct page usage in mm/page_io.c to folios.  This
removes one of the last callers of end_page_writeback(), along with the
last caller of ClearPageReclaim().  This allows us to remove the
PG_reclaim page accessors entirely.  Clean up a few other stale references
to pages throughout while at it.

The rename of mm/page_io.c to mm/swap_io.c is deferred to a separate
series.


This patch (of 6):

Convert swap_write_end() and swap_fs_write_complete() to operate on folios
directly instead of going through the folio-compat page APIs.  This
removes calls to end_page_writeback() and set_page_dirty(), and the last
caller of ClearPageReclaim(), saving two calls to compound_head() per
folio on the write error path.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu
Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-1-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/page_io.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/page_io.c~mm-page_io-convert-write-completion-handlers-to-folios
+++ a/mm/page_io.c
@@ -497,13 +497,13 @@ static void swap_write_end(struct swap_i
 	int p;
 
 	for (p = 0; p < sio->nr_bvecs; p++) {
-		struct page *page = sio->bvecs[p].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[p]);
 
 		if (failed) {
-			set_page_dirty(page);
-			ClearPageReclaim(page);
+			folio_mark_dirty(folio);
+			folio_clear_reclaim(folio);
 		}
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 	}
 	mempool_free(sio, sio_pool);
 }
@@ -514,16 +514,16 @@ static void swap_fs_write_complete(struc
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct page *page = sio->bvecs[0].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[0]);
 
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
-		 * buffers.  Mark the page dirty and avoid
+		 * buffers.  Mark the folio dirty and avoid
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(folio->swap));
 	}
 
 	swap_write_end(sio, failed);
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

