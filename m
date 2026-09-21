Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA322609E3
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961499; cv=none; b=hw7ka062/d8I6Fy8HHzBPe12H3a8rGREC79SPT3yZD43WCkLlj3Y1R5ZSo/yS0uefaCHXEvCXJdt1rtdDMH7Nw6ztI4G4B2Aeo29JyrcibBIdIE56Qk5dPBsxnRXWE6lO16MFYzKGqRBI+uxZ26vlwTjNur1HmXLgWTiLasgPT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961499; c=relaxed/simple;
	bh=Pv8LoHV7k7tKbpbCtjcizeU2o/vJ0LRRx1Ogwg3HT2I=;
	h=Date:To:From:Subject:Message-Id; b=BspYYaVC580NZEyBmmNwzNv0mCrCF55bEj3WTfMs8pf1r2CX7lr0IRiiwChZNfkjDtqocSnlt403+0kuwOwe8e/w5RAJn3AkxPlOYy/phddsLmIvfZ/t3MqblKKuXY43hr5EEoKnw/2drHqR7UBooXfnT4Xt60/qK2HPCF2F+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bRwVqo6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bRwVqo6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30EA1F000FF;
	Mon, 21 Sep 2026 03:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961497;
	bh=Y5Ml+OLq0efo3K9qWTP7Nz29W0WuFRAAYqtZRSeMSMY=;
	h=Date:To:From:Subject;
	b=bRwVqo6IM44WyNVyhVxalY9V4Q2THVXq0v6d0bllbmfH5NjFaMUy+tUp5ePtF388C
	 XCS3fzHi+HR0X++ZovcyhemgoPJtb29cGfUAxXRLgHS1ezrLeVsww0ffLM1UyI217z
	 pTBXnn1JLWFj/ti5IS0Ljg02XH5DleY92Ptx65Q8=
Date: Sun, 20 Sep 2026 20:31:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch removed from -mm tree
Message-Id: <20260921033137.A30EA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: erofs: mm/pagemap: add readahead_folio_last() to avoid folio->private
has been removed from the -mm tree.  Its filename was
     erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: erofs: mm/pagemap: add readahead_folio_last() to avoid folio->private
Date: Sun, 13 Sep 2026 22:24:06 -0400

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_last() to achieve the same function without using
folio->private.  __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks.  After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-8-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
---

 fs/erofs/zdata.c        |   13 +-------
 include/linux/pagemap.h |   60 ++++++++++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 18 deletions(-)

--- a/fs/erofs/zdata.c~erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private
+++ a/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct rea
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
--- a/include/linux/pagemap.h~erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private
+++ a/include/linux/pagemap.h
@@ -1415,6 +1415,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1479,18 +1480,29 @@ void page_cache_async_readahead(struct a
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+/*
+ * Adjust readahead_control to ensure next folio comes from
+ * [_index, _index + _nr_pages) afterwards and reset _batch_count.
+ */
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1516,6 +1528,39 @@ static inline struct folio *readahead_fo
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1524,9 +1569,8 @@ static inline unsigned int __readahead_b
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
_

Patches currently in -mm which might be from ziy@nvidia.com are

erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

