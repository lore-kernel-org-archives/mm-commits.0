Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C7D15E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628298; cv=none; b=S0CI1mWR7lrs8WJUcEOtXolekgvgcc5hTZyqNJcQpuomw5XwOLByKuqAybAMKMaN7BDI84KWHA5jUNWJJv/1KN7q9iGE0IIsB+zmojS4pJ6aT9wgM/KgaWulwpo2gpmW+DIHJ9mYYhHReYheHFtg0zXB+RVJSvHyr0oPs4WKLYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628298; c=relaxed/simple;
	bh=zHDBBT5eXZQNDimpPHbnP04pUaRJgNbZBPKYjvqdHqI=;
	h=Date:To:From:Subject:Message-Id; b=EOJamB6uhpHrccrMrCgeDmxQybitSMLlEwpH0SpDPiYm1OrH4OhshKPGRzP3/GECGJ+8wuy8YIVoJ6vpHpjova7E629sxRKyuCpuucG/yd2lOhA+H7ev+uFfM87kpgjJ3xtZ0CIDLb/3p+XF2h7Sq3gCLCr2HcEeB+4b2/JS4/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VwP6q1fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VwP6q1fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBADC32781;
	Sat, 29 Jun 2024 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628298;
	bh=zHDBBT5eXZQNDimpPHbnP04pUaRJgNbZBPKYjvqdHqI=;
	h=Date:To:From:Subject:From;
	b=VwP6q1fx9VnCOBnsLpDMPmahHX1GJW7YqqbfugrxV9XgpMhXsC+Q3T/5zoUUNwbZU
	 FMuKhCgwYso3xkDgS5CibFiPR+2jV5gwMzYEp2jLuNQtrTTWM6ve+Jkl8PZhDeOVWf
	 jqtAdy0ZPnBvo7FIKfOZAnrdLuVUZzKXkcvQ6tys=
Date: Fri, 28 Jun 2024 19:31:37 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-drop-index-argument-of-page_cache_async_readahead.patch removed from -mm tree
Message-Id: <20240629023138.5DBADC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: drop index argument of page_cache_async_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-drop-index-argument-of-page_cache_async_readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop index argument of page_cache_async_readahead()
Date: Tue, 25 Jun 2024 12:18:55 +0200

The index argument of page_cache_async_readahead() is just folio->index so
there's no point in passing is separately.  Drop it.

Link: https://lkml.kernel.org/r/20240625101909.12234-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/relocation.c   |    3 +--
 fs/btrfs/send.c         |    2 +-
 include/linux/pagemap.h |    7 +++----
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/relocation.c~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/fs/btrfs/relocation.c
@@ -2975,8 +2975,7 @@ static int relocate_one_folio(struct ino
 
 	if (folio_test_readahead(folio))
 		page_cache_async_readahead(inode->i_mapping, ra, NULL,
-					   folio, index,
-					   last_index + 1 - index);
+					   folio, last_index + 1 - index);
 
 	if (!folio_test_uptodate(folio)) {
 		btrfs_read_folio(NULL, folio);
--- a/fs/btrfs/send.c~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/fs/btrfs/send.c
@@ -5307,7 +5307,7 @@ static int put_file_data(struct send_ctx
 
 		if (folio_test_readahead(folio))
 			page_cache_async_readahead(mapping, &sctx->ra, NULL, folio,
-						   index, last_index + 1 - index);
+						   last_index + 1 - index);
 
 		if (!folio_test_uptodate(folio)) {
 			btrfs_read_folio(NULL, folio);
--- a/include/linux/pagemap.h~readahead-drop-index-argument-of-page_cache_async_readahead
+++ a/include/linux/pagemap.h
@@ -1293,8 +1293,7 @@ void page_cache_sync_readahead(struct ad
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @file: Used by the filesystem for authentication.
- * @folio: The folio at @index which triggered the readahead call.
- * @index: Index of first page to be read.
+ * @folio: The folio which triggered the readahead call.
  * @req_count: Total number of pages being read by the caller.
  *
  * page_cache_async_readahead() should be called when a page is used which
@@ -1305,9 +1304,9 @@ void page_cache_sync_readahead(struct ad
 static inline
 void page_cache_async_readahead(struct address_space *mapping,
 		struct file_ra_state *ra, struct file *file,
-		struct folio *folio, pgoff_t index, unsigned long req_count)
+		struct folio *folio, unsigned long req_count)
 {
-	DEFINE_READAHEAD(ractl, file, ra, mapping, index);
+	DEFINE_READAHEAD(ractl, file, ra, mapping, folio->index);
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are


