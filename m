Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793464373;
	b=uyWeBDCyWonLSnn9gtGJs/9rtu8eSIa3s2rd1tzhdEcooCR2rn1mNNs+Vnq0I5OAAah8
	 D7dELEOfkArwwpbQ4GBnElG0oRVmgEITtdCc5yU8iSizoD0UtKWKZ6YL2clFuMUM8Fr/W
	 yxKviPavkqLbPqh2FKTHZOlCxzF1T5m0oji8W6jA4o/9CCwLtR5Rc7MtBnCiNtu7U3fA1
	 kd18exVoaSCRSnYaI8WM6JDmjvb6duI/mBdQ8wsMquiWfXPfasyhWyyI1qBpTJj8m3m7S
	 A6PQTqNDfW+hImER/JlufVFNNdgih2Hl6mqBde21+TXkgXihMd5ANsMof/rq0n/IouQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793464373;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zCxkmfFODESLWXQBcHiSuRVaTUfl2ZWp71It0aZzCFM=;
	b=Ilwlbwx+f5kCxc9MXcSGKD1GNjSVl60UwGmfQviTY+LMso2FkpRu9ek2Tq0mEmJe1nAO
	 IMG5UyjaMMepzDbhn7K64TJmj2Y8K/yJl/gqO8VYbQOKTW03x1DphyXMPdHQsC0M/j5jy
	 1zu8G2y12Py+tTyS3pgDMYs3/RtLpOLuW6rcMAfBAJjZH28UBLD6rhS8lyKcbYlIX8omR
	 bbuE5ExQq9PtpGmsB3qwEeWSf0cv0or9psnkaX9vNKVjr8dNHllg158LDyvBT0oHebJZ7
	 pIefWsTlmc/5uTKF2Wj/8zMphtKmz/QyQenZB/TeOPP5biFKp2OKwgH47zZ0pS7bZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RSKCVPIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAA8606A31A;
	Sat, 31 Oct 2026 16:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RSKCVPIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE0D1F000C1;
	Sat, 31 Oct 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793464372;
	bh=zCxkmfFODESLWXQBcHiSuRVaTUfl2ZWp71It0aZzCFM=;
	h=Date:To:From:Subject;
	b=RSKCVPIU/moaF99yuRrViXq0MqD+rcl7P594PdN1lCHhV5AgcIQPgG8/kTv6xS3jW
	 N/5qx1OD58PVWVU5+loL2LiXnQO1kSqpOIkm1GPsCWnOCAbmsqApMJQW+cGQmpGnHn
	 TGeXSqoePvc86H/Gs1x3IdjyGbOhSfD6CBahz0D8=
Date: Sat, 31 Oct 2026 09:32:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,stable@vger.kernel.org,
	ryan.roberts@arm.com,pfalcato@suse.de,nico.pache@linux.dev,
	ngocthang2710.1999@gmail.com,liam@infradead.org,kas@kernel.org,jack@suse.cz,
	hch@lst.de,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch removed from -mm tree
Message-Id: <20261031163252.4BE0D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: khugepaged: fix readahead lock inversion in collapse_file()
has been removed from the -mm tree.  Its filename was
     khugepaged-fix-readahead-lock-inversion-in-collapse_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
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

