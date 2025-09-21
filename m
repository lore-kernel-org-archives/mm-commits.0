Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB862F37
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487401; cv=none; b=pxllHqknKNMiAKxa0C6D+mN+9DziBBdwqjKkMn34+UKpBL+iCT2l9NL241HrewlNTdtNMa7AkjFsAYzaztfiaAqvVhbAWIueeheqGGTDqAO8WYQNcjDeesXXKLw7wOSLoLc8rlMidJqQx48igaZmOh+1DwYVdrPvy8bJQGeZXhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487401; c=relaxed/simple;
	bh=YFfm+mXkkAD+SaUCXJQt6pgNqr93fisLxtm8DhaRIuM=;
	h=Date:To:From:Subject:Message-Id; b=bDkzC6MwNLoaF5V3is1xcDJLvONN+dL0BcRtNIgNVvXx0tCa9fJYd4uFP9O3SruIIzgI/g5Dh4Mr+rD2AsDUZRpinsH2uLXtSZ5BRE/G0cJz7XqDd4/rSnnO7nl8Yh0KT/wTgH1G7AznqsEUrsx2gdICVHJ5Ts45b6kUqICBhrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4m+U0XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4m+U0XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077D5C4CEE7;
	Sun, 21 Sep 2025 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487401;
	bh=YFfm+mXkkAD+SaUCXJQt6pgNqr93fisLxtm8DhaRIuM=;
	h=Date:To:From:Subject:From;
	b=P4m+U0XVyNJ86SV1RjV/4e+hUnVO3nTMaYvKbjl/DFhIduPGZjECR4O8emDUI70HO
	 n46d4lE8oUdTfHy1u6rr8ZbHp3aSVO/c5WIZ7fEjEKm3qSu/Mveet+GEzBJm3ChZ8N
	 ryReKlCRxl+Ft18gTgUNeeHI1KBQtyc8RZN4YGMw=
Date: Sun, 21 Sep 2025 13:43:20 -0700
To: mm-commits@vger.kernel.org,kernel@pankajraghav.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] readahead-add-trace-points-v2.patch removed from -mm tree
Message-Id: <20250921204321.077D5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead-add-trace-points-v2
has been removed from the -mm tree.  Its filename was
     readahead-add-trace-points-v2.patch

This patch was dropped because it was folded into readahead-add-trace-points.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead-add-trace-points-v2
Date: Tue, 9 Sep 2025 16:58:50 +0200

Move tracepoint from do_page_cache_ra() to page_cache_ra_unbounded() as
that is a more standard function.

Link: https://lkml.kernel.org/r/20250909145849.5090-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/readahead.h |    2 +-
 mm/readahead.c                   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/trace/events/readahead.h~readahead-add-trace-points-v2
+++ a/include/trace/events/readahead.h
@@ -11,7 +11,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
-TRACE_EVENT(do_page_cache_ra,
+TRACE_EVENT(page_cache_ra_unbounded,
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long nr_to_read,
 		 unsigned long lookahead_size),
 
--- a/mm/readahead.c~readahead-add-trace-points-v2
+++ a/mm/readahead.c
@@ -228,6 +228,8 @@ void page_cache_ra_unbounded(struct read
 	 */
 	unsigned int nofs = memalloc_nofs_save();
 
+	trace_page_cache_ra_unbounded(mapping->host, index, nr_to_read,
+				      lookahead_size);
 	filemap_invalidate_lock_shared(mapping);
 	index = mapping_align_index(mapping, index);
 
@@ -317,7 +319,6 @@ static void do_page_cache_ra(struct read
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
 
-	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);
 	if (isize == 0)
 		return;
 
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-add-trace-points.patch

