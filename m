Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62636215F
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035922; cv=none; b=cBOB9RJsmemuGLQuY6F5pTq9OAfM3hE1A0I0g4pAmBPFpYLoKPZIOHZWIwpj13STlB7UAd9sc681m/a+sdsSVejCX1ojf2UQOkp3OoLDOzIawizixtZwzB+6K+8Gwkg9OOSQpiK+Okqnx2dCS3/RDQt0rfJ4PrYIUEcdhpiABOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035922; c=relaxed/simple;
	bh=2Fv/Q9eppwl0WkmSu6Nz+c8tlbinzJWYU2RgZVD9GrA=;
	h=Date:To:From:Subject:Message-Id; b=ZVGz4uISfrHzxZC6kqsNK1Kc5nFKJOp5R2mIi0rpcTUdHZ+T/R+qP+4sNytjU1O83Qff5QkQ0CqxRNad7WdTb+tAN1GnxYCobizQTEomAXQio9yQ713s6eB9ILx4CUsyO/BFJjD1RCy205xC8T4Q6Ynif9yYRVz2DmNc79MI21w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZGSbnd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZGSbnd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B07E1F000E9;
	Sat, 29 Aug 2026 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035920;
	bh=ENZ4HXqHu3w9Rv1JV6O0z6QgEcvX8eZ4qNlC94akQ34=;
	h=Date:To:From:Subject;
	b=zZGSbnd6vjlXPHM1q5zmJtbJ3DZlopAsSwpNJSnhYXoxm0V8XvvFIE+FlLhGp2YLK
	 53XpMlvcVoqc9rjm/1MIlG/siYz0QV6BpnNsYR27VgvjxjCXGfkM/vAUI32JoUQHT9
	 9QWvvm4ayKoVTXaF2tL3Vh6a6Tp0nKKq9H45w/yI=
Date: Sat, 29 Aug 2026 13:38:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hch@lst.de,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,baoquan.he@linux.dev,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-convert-write-completion-handlers-to-folios.patch added to mm-new branch
Message-Id: <20260829203840.8B07E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: convert write completion handlers to folios
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-convert-write-completion-handlers-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-convert-write-completion-handlers-to-folios.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

