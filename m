Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6C418785C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854872; cv=none; b=kTxT+EIlfMam/kVtgpU9isoYDdFqgcHvo5O3aHsos9Ms9mfZqmaHuVhkFymHiGe3CmLiUMOjhPspDVBEpAG7eVTcXXIkao5dcPD+aKBgU9M49JcWgCHBLI/UnJncMyz0DXCxW7DNUs3Puh0SAkOwNNV5jNLDRpUDbu5tqc5B2R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854872; c=relaxed/simple;
	bh=NkHiibrbriTFHbLCujhUTF08J8ybvx1ofjzQTYOiiO8=;
	h=Date:To:From:Subject:Message-Id; b=DrRbwuWRpArv2fuu3SdFAlivjsqEk4SgRUqNahv0qBHPdu1RqROdgHh5M229NnEoSLOkc5HX5xFE982fM2jp3L35EgoKEdvHx3mXz9iW4H0VZcDDikrUo+vUhyBTBMowKE3cCgsqGj1PdVi4EfBQWL0QksqwV6UH7sRlsTjmT4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=be01/yd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="be01/yd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4211C4CECF;
	Wed,  6 Nov 2024 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854872;
	bh=NkHiibrbriTFHbLCujhUTF08J8ybvx1ofjzQTYOiiO8=;
	h=Date:To:From:Subject:From;
	b=be01/yd4WIEK/qU4NEWe2WgpBUJ8FO8OfScZz2TX4wChxPLs4a0jHUJtOFlN2Q7Wp
	 CJExOb1Pj+4cidURaCT7hUgbm1zuLYXp/y57COXHk3R29tZWxr6wNsL1P4xHQbNoBV
	 e/aG/BXM7CFtL8N5yRVFXZ09AHO2NIh2bI1UlAok=
Date: Tue, 05 Nov 2024 17:01:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch removed from -mm tree
Message-Id: <20241106010112.A4211C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fallback to page size splice if large folio has poisoned pages
has been removed from the -mm tree.  Its filename was
     mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fallback to page size splice if large folio has poisoned pages
Date: Sat, 26 Oct 2024 21:51:52 +0800

The tmpfs has already supported the PMD-sized large folios, and splice()
can not read any pages if the large folio has a poisoned page, which is
not good as Matthew pointed out in a previous email[1]:

"so if we have hwpoison set on one page in a folio, we now can't read
bytes from any page in the folio?  That seems like we've made a bad
situation worse."

Thus add a fallback to the PAGE_SIZE splice() still allows reading normal
pages if the large folio has hwpoisoned pages.

[1] https://lore.kernel.org/all/Zw_d0EVAJkpNJEbA@casper.infradead.org/

[baolin.wang@linux.alibaba.com: code layout cleaup, per dhowells]
  Link: https://lkml.kernel.org/r/32dd938c-3531-49f7-93e4-b7ff21fec569@linux.alibaba.com
Link: https://lkml.kernel.org/r/e3737fbd5366c4de4337bf5f2044817e77a5235b.1729915173.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/mm/shmem.c~mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages
+++ a/mm/shmem.c
@@ -3288,11 +3288,16 @@ static ssize_t shmem_file_splice_read(st
 	len = min_t(size_t, len, npages * PAGE_SIZE);
 
 	do {
+		bool fallback_page_splice = false;
+		struct page *page = NULL;
+		pgoff_t index;
+		size_t size;
+
 		if (*ppos >= i_size_read(inode))
 			break;
 
-		error = shmem_get_folio(inode, *ppos / PAGE_SIZE, 0, &folio,
-					SGP_READ);
+		index = *ppos >> PAGE_SHIFT;
+		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
@@ -3301,12 +3306,15 @@ static ssize_t shmem_file_splice_read(st
 		if (folio) {
 			folio_unlock(folio);
 
-			if (folio_test_hwpoison(folio) ||
-			    (folio_test_large(folio) &&
-			     folio_test_has_hwpoisoned(folio))) {
+			page = folio_file_page(folio, index);
+			if (PageHWPoison(page)) {
 				error = -EIO;
 				break;
 			}
+
+			if (folio_test_large(folio) &&
+			    folio_test_has_hwpoisoned(folio))
+				fallback_page_splice = true;
 		}
 
 		/*
@@ -3320,7 +3328,17 @@ static ssize_t shmem_file_splice_read(st
 		isize = i_size_read(inode);
 		if (unlikely(*ppos >= isize))
 			break;
-		part = min_t(loff_t, isize - *ppos, len);
+		/*
+		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
+		 * pages.
+		 */
+		size = len;
+		if (unlikely(fallback_page_splice)) {
+			size_t offset = *ppos & ~PAGE_MASK;
+
+			size = umin(size, PAGE_SIZE - offset);
+		}
+		part = min_t(loff_t, isize - *ppos, size);
 
 		if (folio) {
 			/*
@@ -3328,8 +3346,12 @@ static ssize_t shmem_file_splice_read(st
 			 * virtual addresses, take care about potential aliasing
 			 * before reading the page on the kernel side.
 			 */
-			if (mapping_writably_mapped(mapping))
-				flush_dcache_folio(folio);
+			if (mapping_writably_mapped(mapping)) {
+				if (likely(!fallback_page_splice))
+					flush_dcache_folio(folio);
+				else
+					flush_dcache_page(page);
+			}
 			folio_mark_accessed(folio);
 			/*
 			 * Ok, we have the page, and it's up-to-date, so we can
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


