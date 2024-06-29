Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4F818641
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628302; cv=none; b=eDAhSLmxaNOXYQb0Wc/ChpPxYh6pwh6k0Q6iRD/3/LXYhN8fvs6EBjN0lnZYcCVT05ZfcJhdzaZ743Uc311h7h+SRHznPtOc5WMzcOrTthjCAoDQjFURriv0oNTvceQDhcKBO+XT+yvPVwj/Hla1+B6QGBW7vi4VkEjQ0Nz7Wxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628302; c=relaxed/simple;
	bh=KyEa4rgeOi9xG7NXq1dlEx+m6KKXbzzVh5VH4ft9EJI=;
	h=Date:To:From:Subject:Message-Id; b=kN9vwxJNX+WKNfJE0yyN2yOLdoWcPf380Zptx7F8gtDPaawAcI30A3gkzKPkPVHZFWnecOazKBaEG6rdZQ3LEzIPME+YfMVKjO+AdGdSnC8uCO6+o/sf883AlWiWj4fjHTkQJCquNFYKwDtjIphwIp0G7G9muGqiTxKNYKsrasY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YoZetvlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YoZetvlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE47EC116B1;
	Sat, 29 Jun 2024 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628302;
	bh=KyEa4rgeOi9xG7NXq1dlEx+m6KKXbzzVh5VH4ft9EJI=;
	h=Date:To:From:Subject:From;
	b=YoZetvlmYufgDfwJAy9L/9w0zLpDhIOGFzkNF2HYRVKEpD6dmgwOcaqINStFHOIvs
	 t1Oa+Ud6sLSZIaBWBVZxSfO1ZkR4Ao8eRw66NXdpDNE+ndO641d1npgKwFDZ7ACps7
	 61BYDWFAo1m+K7mNfYgM47ZB23ZwyTPKij9mLph4=
Date: Fri, 28 Jun 2024 19:31:41 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-disentangle-async-and-sync-readahead.patch removed from -mm tree
Message-Id: <20240629023141.DE47EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: disentangle async and sync readahead
has been removed from the -mm tree.  Its filename was
     readahead-disentangle-async-and-sync-readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: disentangle async and sync readahead
Date: Tue, 25 Jun 2024 12:18:58 +0200

Both async and sync readahead are handled by ondemand_readahead()
function.  However there isn't actually much in common.  Just move async
related parts into page_cache_ra_async() and sync related parts to
page_cache_ra_sync().  No functional changes.

Link: https://lkml.kernel.org/r/20240625101909.12234-8-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |  162 ++++++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 85 deletions(-)

--- a/mm/readahead.c~readahead-disentangle-async-and-sync-readahead
+++ a/mm/readahead.c
@@ -540,18 +540,11 @@ fallback:
 	do_page_cache_ra(ractl, ra->size - (index - start), ra->async_size);
 }
 
-/*
- * A minimal readahead algorithm for trivial sequential/random reads.
- */
-static void ondemand_readahead(struct readahead_control *ractl,
-		struct folio *folio, unsigned long req_size)
+static unsigned long ractl_max_pages(struct readahead_control *ractl,
+		unsigned long req_size)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(ractl->mapping->host);
-	struct file_ra_state *ra = ractl->ra;
-	unsigned long max_pages = ra->ra_pages;
-	pgoff_t index = readahead_index(ractl);
-	pgoff_t expected, prev_index;
-	unsigned int order = folio ? folio_order(folio) : 0;
+	unsigned long max_pages = ractl->ra->ra_pages;
 
 	/*
 	 * If the request exceeds the readahead window, allow the read to
@@ -559,55 +552,42 @@ static void ondemand_readahead(struct re
 	 */
 	if (req_size > max_pages && bdi->io_pages > max_pages)
 		max_pages = min(req_size, bdi->io_pages);
+	return max_pages;
+}
 
-	/*
-	 * start of file
-	 */
-	if (!index)
-		goto initial_readahead;
-
-	/*
-	 * It's the expected callback index, assume sequential access.
-	 * Ramp up sizes, and push forward the readahead window.
-	 */
-	expected = round_down(ra->start + ra->size - ra->async_size,
-			1UL << order);
-	if (folio && index == expected) {
-		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max_pages);
-		ra->async_size = ra->size;
-		goto readit;
-	}
+void page_cache_sync_ra(struct readahead_control *ractl,
+		unsigned long req_count)
+{
+	pgoff_t index = readahead_index(ractl);
+	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
+	struct file_ra_state *ra = ractl->ra;
+	unsigned long max_pages;
+	pgoff_t prev_index;
 
 	/*
-	 * Hit a marked folio without valid readahead state.
-	 * E.g. interleaved reads.
-	 * Query the pagecache for async_size, which normally equals to
-	 * readahead size. Ramp it up and use it as the new readahead size.
+	 * Even if readahead is disabled, issue this request as readahead
+	 * as we'll need it to satisfy the requested range. The forced
+	 * readahead will do the right thing and limit the read to just the
+	 * requested range, which we'll set to 1 page for this case.
 	 */
-	if (folio) {
-		pgoff_t start;
-
-		rcu_read_lock();
-		start = page_cache_next_miss(ractl->mapping, index + 1,
-				max_pages);
-		rcu_read_unlock();
-
-		if (!start || start - index > max_pages)
+	if (!ra->ra_pages || blk_cgroup_congested()) {
+		if (!ractl->file)
 			return;
+		req_count = 1;
+		do_forced_ra = true;
+	}
 
-		ra->start = start;
-		ra->size = start - index;	/* old async_size */
-		ra->size += req_size;
-		ra->size = get_next_ra_size(ra, max_pages);
-		ra->async_size = ra->size;
-		goto readit;
+	/* be dumb */
+	if (do_forced_ra) {
+		force_page_cache_ra(ractl, req_count);
+		return;
 	}
 
+	max_pages = ractl_max_pages(ractl, req_count);
 	/*
-	 * oversize read
+	 * start of file or oversized read
 	 */
-	if (req_size > max_pages)
+	if (!index || req_count > max_pages)
 		goto initial_readahead;
 
 	/*
@@ -623,7 +603,7 @@ static void ondemand_readahead(struct re
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(ractl->mapping, ra, index, req_size,
+	if (try_context_readahead(ractl->mapping, ra, index, req_count,
 			max_pages))
 		goto readit;
 
@@ -631,53 +611,31 @@ static void ondemand_readahead(struct re
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	do_page_cache_ra(ractl, req_size, 0);
+	do_page_cache_ra(ractl, req_count, 0);
 	return;
 
 initial_readahead:
 	ra->start = index;
-	ra->size = get_init_ra_size(req_size, max_pages);
-	ra->async_size = ra->size > req_size ? ra->size - req_size :
-					       ra->size >> 1;
-
+	ra->size = get_init_ra_size(req_count, max_pages);
+	ra->async_size = ra->size > req_count ? ra->size - req_count :
+						ra->size >> 1;
 readit:
 	ractl->_index = ra->start;
-	page_cache_ra_order(ractl, ra, order);
-}
-
-void page_cache_sync_ra(struct readahead_control *ractl,
-		unsigned long req_count)
-{
-	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
-
-	/*
-	 * Even if readahead is disabled, issue this request as readahead
-	 * as we'll need it to satisfy the requested range. The forced
-	 * readahead will do the right thing and limit the read to just the
-	 * requested range, which we'll set to 1 page for this case.
-	 */
-	if (!ractl->ra->ra_pages || blk_cgroup_congested()) {
-		if (!ractl->file)
-			return;
-		req_count = 1;
-		do_forced_ra = true;
-	}
-
-	/* be dumb */
-	if (do_forced_ra) {
-		force_page_cache_ra(ractl, req_count);
-		return;
-	}
-
-	ondemand_readahead(ractl, NULL, req_count);
+	page_cache_ra_order(ractl, ra, 0);
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_ra);
 
 void page_cache_async_ra(struct readahead_control *ractl,
 		struct folio *folio, unsigned long req_count)
 {
+	unsigned long max_pages;
+	struct file_ra_state *ra = ractl->ra;
+	pgoff_t index = readahead_index(ractl);
+	pgoff_t expected, start;
+	unsigned int order = folio_order(folio);
+
 	/* no readahead */
-	if (!ractl->ra->ra_pages)
+	if (!ra->ra_pages)
 		return;
 
 	/*
@@ -691,7 +649,41 @@ void page_cache_async_ra(struct readahea
 	if (blk_cgroup_congested())
 		return;
 
-	ondemand_readahead(ractl, folio, req_count);
+	max_pages = ractl_max_pages(ractl, req_count);
+	/*
+	 * It's the expected callback index, assume sequential access.
+	 * Ramp up sizes, and push forward the readahead window.
+	 */
+	expected = round_down(ra->start + ra->size - ra->async_size,
+			1UL << order);
+	if (index == expected) {
+		ra->start += ra->size;
+		ra->size = get_next_ra_size(ra, max_pages);
+		ra->async_size = ra->size;
+		goto readit;
+	}
+
+	/*
+	 * Hit a marked folio without valid readahead state.
+	 * E.g. interleaved reads.
+	 * Query the pagecache for async_size, which normally equals to
+	 * readahead size. Ramp it up and use it as the new readahead size.
+	 */
+	rcu_read_lock();
+	start = page_cache_next_miss(ractl->mapping, index + 1, max_pages);
+	rcu_read_unlock();
+
+	if (!start || start - index > max_pages)
+		return;
+
+	ra->start = start;
+	ra->size = start - index;	/* old async_size */
+	ra->size += req_count;
+	ra->size = get_next_ra_size(ra, max_pages);
+	ra->async_size = ra->size;
+readit:
+	ractl->_index = ra->start;
+	page_cache_ra_order(ractl, ra, order);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_ra);
 
_

Patches currently in -mm which might be from jack@suse.cz are


