Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793119403;
	b=XHmcwj0hRiap9HROpmemBdyz7phtAN+shF4l5+7Qiyl3NOqg8t2UsmiolrP5P1CCqOYI
	 VhItUlzftmKEd+SqRTeTUdrBBxY/sNviT2pU9UjdqANefLSnsQKl/H4JOgWCPTlbxEDBM
	 QtwZTu4aYFCwAGahxa1oCWnHepD9BPUIDO1xwn0gjPbx5aBhyf4whBmse2r0QRuCVtYqj
	 Ehz14JclW7y11fY0QK+/ex+cca929cnkVtkLyDrmNzKdlyLU/2AKbeCPbJAJWZsMtRyVC
	 6ZmtjxU7FezJWgxYSVa8sKE2N/81WMloZnKGh4rpSWBnfkwiOzH9gX7LGk3Pft90www==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119403;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xAOQCyF38fJM7aanwEqx9cjLL1gMKj1DU/+zMdsqQYw=;
	b=BXhfrm7lESLA3xcXJ/skRnI8bA2BlYea7w6R9rnLhHuVCU8ihQRQi8aI8zyl6+/ycIEu
	 hgTjZtMRsyvGVW7GUE6wQcL6E27nqgki4htRFrNPg++qpF8WvXfMONZVv4DYd1uHS4tRx
	 32Vtz6p3iG1c99tC/DNrY5HSGW9Ov6F84i2cvOAGFMP5RRUCPMCm8dtADV1fjjx07+540
	 16fGJLV83mLZRr3aPRHL4vsa4tbkdokkZD/vqOjvo5/lfA0kDA5D+1NjDA0vWdeckaZS+
	 AV51eBvFSeJBxtwBdgE1wmcpXpvhyPZ+cmVL0DO0eMZdkl6tCY44dzs8i4MnGRSfC9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jCHflx1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D56F606A31D;
	Tue, 27 Oct 2026 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jCHflx1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6DD1F01825;
	Tue, 27 Oct 2026 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793119402;
	bh=xAOQCyF38fJM7aanwEqx9cjLL1gMKj1DU/+zMdsqQYw=;
	h=Date:To:From:Subject;
	b=jCHflx1GlTu3tqHzl5oeMqwOE97vTWwtNe06LxfxeG8GLhr8K5j0eehyjwez2jJ8W
	 MdDldcbtR8gnG/pBHDKdomoTB9Nbn82G0969o8QTmYYmume7GYEyq3URi/tVVSlKEJ
	 U9a9UsBIAlnrhrf6bTyaUXJnZdh6IiWJfOBmlYAc=
Date: Tue, 27 Oct 2026 09:43:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,stable@vger.kernel.org,
	ryan.roberts@arm.com,pfalcato@suse.de,nico.pache@linux.dev,
	ngocthang2710.1999@gmail.com,liam@infradead.org,kas@kernel.org,jack@suse.cz,
	hch@lst.de,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch added to mm-unstable branch
Message-Id: <20261027164322.0C6DD1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: khugepaged: fix readahead lock inversion in collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lance Yang <lance.yang@linux.dev>
Subject: khugepaged: fix readahead lock inversion in collapse_file()
Date: Mon, 26 Oct 2026 23:20:13 +0800

collapse_file() can call page_cache_sync_readahead() while still holding
source folios locked. If truncate holds mapping->invalidate_lock
exclusively and waits for one of those folios, readahead waits for
invalidate_lock and neither side can make progress.

We need to release those folio locks before starting readahead. On a page
cache miss, roll back first, populate the collapse range, and retry once.
Doing readahead after rollback avoids an extra pass when all folios are
already present. If another miss occurs on retry, give up rather than keep
retrying while truncate or reclaim removes folios.

Keep page_cache_sync_readahead() and wait for read I/O with
filemap_lock_folio(), releasing each folio before moving to the next. The
existing uptodate check during collapse still handles read errors.

Shmem uses shmem_get_folio() for swapin and fallocated folios without
taking mapping->invalidate_lock, so it is unaffected.

Link: https://lore.kernel.org/20261026152013.10511-1-lance.yang@linux.dev
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/mm/khugepaged.c~khugepaged-fix-readahead-lock-inversion-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(st
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	bool do_readahead = false;
+	bool readahead_done = false;
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(st
 
 	mapping_set_update(&xas, mapping);
 
+retry:
+	result = SCAN_SUCCEED;
+	do_readahead = false;
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
@@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(st
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
+				do_readahead = !readahead_done;
+				result = SCAN_FAIL;
+				goto xa_locked;
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
@@ -2657,6 +2655,30 @@ rollback:
 	new_folio->mapping = NULL;
 
 	folio_unlock(new_folio);
+
+	/* Readahead may take invalidate_lock; source folios are unlocked. */
+	if (do_readahead) {
+		for (index = start; index < end;) {
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio)) {
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index, end - index);
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto out_put;
+				}
+			}
+			index = folio_next_index(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		/* Drain the local LRU batch before retrying isolation. */
+		lru_add_drain();
+		readahead_done = true;
+		goto retry;
+	}
+out_put:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-ksm-fix-userfaultfd-protection-during-merge-and-unmerge.patch
khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch

