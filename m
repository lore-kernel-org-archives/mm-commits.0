Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3036F418
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027616; cv=none; b=CB8P8O+U//tKPI7OxqQVwt372Ufi/kK58f95k64ysO9qlhe1n8ChU/MMkIhmB4G6ZpG3/VPFUywb9OYoyQkddUfdoaDNjfgEUjVCFi5WQ5UgEaSd16aXcIQLrfaGpL9xYM0WyPrTSRwlQhYQlCCRWub9uO71gEJYhaIHue7+X0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027616; c=relaxed/simple;
	bh=Yb6gflobZd9GU/pfFfeRXzlYOR2MryMKB3ni/f0enD8=;
	h=Date:To:From:Subject:Message-Id; b=Fakk6O/8hQ1TKPYQcZQYjKO4LuqBEHUHxB0tHEXoW3/Yo+fze5LKmrFT3GkiUu1NFS6sqKnf66r0X4Usce+UJPuc2+W/7CPKky5DHHZ0Az8FSwjCvo5bWX50a+67jajURB4mWeCymh1CNG/QN3YgiHF5X6QOo6fmh76pdD3+TcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGK8TN0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGK8TN0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8591F00893;
	Fri, 29 May 2026 04:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027615;
	bh=UH72E3gsHrqDmzsQSj1GA64lzvEbnEaLg+L7ePoXDYQ=;
	h=Date:To:From:Subject;
	b=UGK8TN0tACzfTgaTRZ5EZnz5U3OyWDjPHKW0xJ/z0tQJybFMjKNe8xG0guLRkgJqC
	 6XSLEQV65vSkr4hXCjWKeTvfe8i/NZkSOj2XTZZ4HgyblwFHAIX2nK6pqSdGab4Vey
	 2znVS88aj2yuF8i6SAg70uNg4ByCew0JVm/EYEUg=
Date: Thu, 28 May 2026 21:06:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,neil@brown.name,kasong@tencent.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-rename-swap_iocb-fields-for-clarity.patch removed from -mm tree
Message-Id: <20260529040655.5E8591F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: rename swap_iocb fields for clarity
has been removed from the -mm tree.  Its filename was
     mm-page_io-rename-swap_iocb-fields-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/page_io: rename swap_iocb fields for clarity
Date: Thu, 2 Apr 2026 08:26:50 +0100

swap_iocb->pages tracks the number of bvec entries (folios), not base
pages.  Rename the array from bvec to bvecs and the counter from pages to
nr_bvecs to accurately reflect their purpose.

Link: https://lore.kernel.org/20260402072650.48811-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: NeilBrown <neil@brown.name>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/page_io.c~mm-page_io-rename-swap_iocb-fields-for-clarity
+++ a/mm/page_io.c
@@ -326,8 +326,8 @@ static void bio_associate_blkg_from_page
 
 struct swap_iocb {
 	struct kiocb		iocb;
-	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
-	int			pages;
+	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
+	int			nr_bvecs;
 	int			len;
 };
 static mempool_t *sio_pool;
@@ -348,7 +348,7 @@ int sio_pool_init(void)
 static void sio_write_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec[0].bv_page;
+	struct page *page = sio->bvecs[0].bv_page;
 	int p;
 
 	if (ret != sio->len) {
@@ -362,15 +362,15 @@ static void sio_write_complete(struct ki
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret, swap_dev_pos(page_swap_entry(page)));
-		for (p = 0; p < sio->pages; p++) {
-			page = sio->bvec[p].bv_page;
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			page = sio->bvecs[p].bv_page;
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
 	}
 
-	for (p = 0; p < sio->pages; p++)
-		end_page_writeback(sio->bvec[p].bv_page);
+	for (p = 0; p < sio->nr_bvecs; p++)
+		end_page_writeback(sio->bvecs[p].bv_page);
 
 	mempool_free(sio, sio_pool);
 }
@@ -397,13 +397,13 @@ static void swap_writepage_fs(struct fol
 		init_sync_kiocb(&sio->iocb, swap_file);
 		sio->iocb.ki_complete = sio_write_complete;
 		sio->iocb.ki_pos = pos;
-		sio->pages = 0;
+		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
+	sio->nr_bvecs += 1;
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !swap_plug) {
 		swap_write_unplug(sio);
 		sio = NULL;
 	}
@@ -477,7 +477,7 @@ void swap_write_unplug(struct swap_iocb
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -489,8 +489,8 @@ static void sio_read_complete(struct kio
 	int p;
 
 	if (ret == sio->len) {
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
 
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
@@ -499,8 +499,8 @@ static void sio_read_complete(struct kio
 		}
 		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
 
 			folio_unlock(folio);
 		}
@@ -559,13 +559,13 @@ static void swap_read_folio_fs(struct fo
 		init_sync_kiocb(&sio->iocb, sis->swap_file);
 		sio->iocb.ki_pos = pos;
 		sio->iocb.ki_complete = sio_read_complete;
-		sio->pages = 0;
+		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
+	sio->nr_bvecs += 1;
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !plug) {
 		swap_read_unplug(sio);
 		sio = NULL;
 	}
@@ -666,7 +666,7 @@ void __swap_read_unplug(struct swap_iocb
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-shrinker-avoid-out-of-bounds-read-in-set_shrinker_bit.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

