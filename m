Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218E618026
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628303; cv=none; b=LywqekZ7ax1BZOAEhzcAPl8MfluGbF0dv4qkycs19Ji9fECZkRoXOA6t+96UCMfafNtOptleEKXVuM1UR54wIbI4PHKDNwYU2EgucoRuhMZSO9eg/xHCfA79HGvJ3HNJYwu7G012Y1wrm85HkIpRQo6k0i2Av9BUBqXF8T52cUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628303; c=relaxed/simple;
	bh=WdxuD42YxR8TuPJxNAFQXefVs1LG+QHN2a0H5SaxWyg=;
	h=Date:To:From:Subject:Message-Id; b=j6EAUIvQCFuOPbyxiSrTZBvETUVBQrguSBg1YJDBfUvTbPHYXKJeRDuvhFO6rp/cdzbvYWU0UG1CK2Ef0g3JhhxL7+4OJzg2tPylp7VTC4UI4IKUXUQoIqM3E/bnUBjgIP4nP9z8fE6SyzlWs/NochArGkK9mKwEtpUIEL1LSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BepyQKs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BepyQKs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD1CC116B1;
	Sat, 29 Jun 2024 02:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628303;
	bh=WdxuD42YxR8TuPJxNAFQXefVs1LG+QHN2a0H5SaxWyg=;
	h=Date:To:From:Subject:From;
	b=BepyQKs0BJewD8TPqt3z1b/acmofeILH9IKvU0iSKgsDNCc1mBk7ksRQvAJxOd0vr
	 2jAQPF/WllCNKK7kiqvjQTNEqDbKcAweYO7AfOy5bqMDVOOXj0TZdN45r/YdnEWhe+
	 byXxSpZeMwlhfiap91jBoaZFYFcQuK0LzwKbpIko=
Date: Fri, 28 Jun 2024 19:31:42 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-fold-try_context_readahead-into-its-single-caller.patch removed from -mm tree
Message-Id: <20240629023142.EBD1CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: fold try_context_readahead() into its single caller
has been removed from the -mm tree.  Its filename was
     readahead-fold-try_context_readahead-into-its-single-caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: fold try_context_readahead() into its single caller
Date: Tue, 25 Jun 2024 12:18:59 +0200

try_context_readahead() has a single caller page_cache_sync_ra().  Fold
the function there to make ra state modifications more obvious.  No
functional changes.

Link: https://lkml.kernel.org/r/20240625101909.12234-9-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   84 ++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 62 deletions(-)

--- a/mm/readahead.c~readahead-fold-try_context_readahead-into-its-single-caller
+++ a/mm/readahead.c
@@ -410,58 +410,6 @@ static unsigned long get_next_ra_size(st
  * it approaches max_readhead.
  */
 
-/*
- * Count contiguously cached pages from @index-1 to @index-@max,
- * this count is a conservative estimation of
- * 	- length of the sequential read sequence, or
- * 	- thrashing threshold in memory tight systems
- */
-static pgoff_t count_history_pages(struct address_space *mapping,
-				   pgoff_t index, unsigned long max)
-{
-	pgoff_t head;
-
-	rcu_read_lock();
-	head = page_cache_prev_miss(mapping, index - 1, max);
-	rcu_read_unlock();
-
-	return index - 1 - head;
-}
-
-/*
- * page cache context based readahead
- */
-static int try_context_readahead(struct address_space *mapping,
-				 struct file_ra_state *ra,
-				 pgoff_t index,
-				 unsigned long req_size,
-				 unsigned long max)
-{
-	pgoff_t size;
-
-	size = count_history_pages(mapping, index, max);
-
-	/*
-	 * not enough history pages:
-	 * it could be a random read
-	 */
-	if (size <= req_size)
-		return 0;
-
-	/*
-	 * starts from beginning of file:
-	 * it is a strong indication of long-run stream (or whole-file-read)
-	 */
-	if (size >= index)
-		size *= 2;
-
-	ra->start = index;
-	ra->size = min(size + req_size, max);
-	ra->async_size = 1;
-
-	return 1;
-}
-
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		pgoff_t mark, unsigned int order, gfp_t gfp)
 {
@@ -561,8 +509,8 @@ void page_cache_sync_ra(struct readahead
 	pgoff_t index = readahead_index(ractl);
 	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
 	struct file_ra_state *ra = ractl->ra;
-	unsigned long max_pages;
-	pgoff_t prev_index;
+	unsigned long max_pages, contig_count;
+	pgoff_t prev_index, miss;
 
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
@@ -603,16 +551,28 @@ void page_cache_sync_ra(struct readahead
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(ractl->mapping, ra, index, req_count,
-			max_pages))
-		goto readit;
-
+	rcu_read_lock();
+	miss = page_cache_prev_miss(ractl->mapping, index - 1, max_pages);
+	rcu_read_unlock();
+	contig_count = index - miss - 1;
+	/*
+	 * Standalone, small random read. Read as is, and do not pollute the
+	 * readahead state.
+	 */
+	if (contig_count <= req_count) {
+		do_page_cache_ra(ractl, req_count, 0);
+		return;
+	}
 	/*
-	 * standalone, small random read
-	 * Read as is, and do not pollute the readahead state.
+	 * File cached from the beginning:
+	 * it is a strong indication of long-run stream (or whole-file-read)
 	 */
-	do_page_cache_ra(ractl, req_count, 0);
-	return;
+	if (miss == ULONG_MAX)
+		contig_count *= 2;
+	ra->start = index;
+	ra->size = min(contig_count + req_count, max_pages);
+	ra->async_size = 1;
+	goto readit;
 
 initial_readahead:
 	ra->start = index;
_

Patches currently in -mm which might be from jack@suse.cz are


