Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB93233958;
	Tue, 15 Sep 2026 02:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789440210; cv=none; b=EGFcpoCBHBgycnupuI2MJ3GQq+zRlmgVhlf4yQfWd8gbF+00aLU6klHOmrV0w2U15k/AicMENIcbj38fA3cyXZct9fwGxWdo306ui/NZ+1Y6xQhnKigsy39BxEiXGALh8ufhFWvYCxbteXevyeONw6XrkpAbcCBONT+irF/x0OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789440210; c=relaxed/simple;
	bh=wQmMUfPkFNNsvwVLzhLC++Mp3JUvq1kVIkUfOYmIDW4=;
	h=Date:To:From:Subject:Message-Id; b=f4VR0WQ16srzus/jBivzzNo/hBwQArK3KvarsorVI/JdflE93PEfbafM38wYLForzcbqkJ8bLr7lFoIcQM0tnqDCC27sRYYm+icL4Y7i2BrmtTWNZ7P8mXZZ9LoURpWmH6y6A2PtUPDivsHmLUOJimWaDoQxdI8KnBI1a83w/PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ODoHg3K2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ODoHg3K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51A11F00893;
	Tue, 15 Sep 2026 02:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789440209;
	bh=u+22RNZwjGRUscc1nVfzg5P3Aox836hLNSgLSB2hL8c=;
	h=Date:To:From:Subject;
	b=ODoHg3K2B8JLM27kAFSdZYdMkhSAfcbJEqJBQF0s5BD0dn1GIYnPDJHqqm78C+t0v
	 E8U5rfI+pqJoLD5kfmVsDi02VVZSNygwIE7pmdNDVyIoh1Swv9tZ3pK7xLnlLbMLcR
	 67GPdGn0BjyjXKFGdDeezGZfKq1/xlD2jsCX73CQ=
Date: Mon, 14 Sep 2026 19:43:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ngocthang2710.1999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] khugepaged-hold-invalidate_lock-across-collapse_file-readahead.patch removed from -mm tree
Message-Id: <20260915024328.E51A11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: hold invalidate_lock across collapse_file() readahead
has been removed from the -mm tree.  Its filename was
     khugepaged-hold-invalidate_lock-across-collapse_file-readahead.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: khugepaged: hold invalidate_lock across collapse_file() readahead
Date: Sun, 13 Sep 2026 23:36:44 +0700

collapse_file() calls page_cache_sync_readahead() to fault in missing
pages before collapsing them into a THP.  That helper takes
mapping->invalidate_lock itself for the duration of the call, then drops
it -- but truncate (e.g.  ext4_setattr() -> truncate_pagecache()) takes
invalidate_lock and then waits on each page's folio lock while holding it.
If collapse_file() has already locked one of those folios by the time
truncate reaches it, and then tries to acquire invalidate_lock again (e.g.
on the first readahead call, since invalidate_lock is not yet held at
that point), the two paths can deadlock/hang on each other's lock:
truncate blocked on the folio lock collapse holds, and collapse blocked
waiting for invalidate_lock that truncate holds.

Reproducing this over ~150,000 collapse iterations with truncate racing
concurrently reliably hits hung_task: blocked tasks within about 20
seconds on an unpatched kernel.

Fix it by taking invalidate_lock_shared once for the whole scan, after
alloc_charge_folio() succeeds and before locking any folio, and using
page_cache_ra_unbounded() directly in the readahead call site instead of
page_cache_sync_readahead(), since the latter would try to retake the lock
we already hold.  page_cache_ra_unbounded() does not clamp to EOF like the
helper it replaces, so clamp the requested range explicitly.

730633f0b7f9 added invalidate_lock acquisition around readahead but missed
collapse_file(), which already locks pages while calling readahead; later
filesystem conversions made the deadlock reachable by taking
invalidate_lock before waiting on page locks during truncate.

Link: https://lore.kernel.org/20260913163644.122133-1-ngocthang2710.1999@gmail.com
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~khugepaged-hold-invalidate_lock-across-collapse_file-readahead
+++ a/mm/khugepaged.c
@@ -2251,6 +2251,7 @@ static enum scan_result collapse_file(st
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	bool need_unlock = false;
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2265,6 +2266,15 @@ static enum scan_result collapse_file(st
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	/*
+	 * Take invalidate_lock before any folio lock: the readahead below
+	 * needs it, and truncate holds it while waiting on folio locks.
+	 */
+	if (!is_shmem) {
+		filemap_invalidate_lock_shared(mapping);
+		need_unlock = true;
+	}
+
 	mapping_set_update(&xas, mapping);
 
 	__folio_set_locked(new_folio);
@@ -2331,10 +2341,20 @@ static enum scan_result collapse_file(st
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
+				DEFINE_READAHEAD(ractl, file, &file->f_ra,
+						  mapping, index);
+				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
+							    PAGE_SIZE);
+
 				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
+				/*
+				 * invalidate_lock held above; don't retake it.
+				 * page_cache_ra_unbounded(), unlike the readahead
+				 * helper this replaces, does not clamp to EOF.
+				 */
+				if (index < eof)
+					page_cache_ra_unbounded(&ractl,
+						min(end, eof) - index, 0);
 				/* drain lru cache to help folio_isolate_lru() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
@@ -2666,6 +2686,8 @@ rollback:
 	folio_unlock(new_folio);
 	folio_put(new_folio);
 out:
+	if (need_unlock)
+		filemap_invalidate_unlock_shared(mapping);
 	VM_BUG_ON(!list_empty(&pagelist));
 	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
_

Patches currently in -mm which might be from ngocthang2710.1999@gmail.com are


