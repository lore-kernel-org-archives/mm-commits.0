Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC53314D37
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439046; cv=none; b=OXZ+xFu2UnbmaLjmxlcrm95LO+3JnfE2T4FroTtaMuXjLVMVacTnqLqmqKVzwEW/DzH/8/ZNf5A0fvUnfHvpV89DZO0X6hE9+35vmXnq0HHdBCYX3BMSNwpodALYUi6S6MbQBJdFH0dJ4NOmCwQUh2xQjTgTJiQKeeH1wqRHjsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439046; c=relaxed/simple;
	bh=Pvt7uE7zgSX5hNqa86zBOiAhKZ6MfTdIrqJ5bue9ky4=;
	h=Date:To:From:Subject:Message-Id; b=i9WEQQp7e0LT0sjNOrMd3BKTtlU77MiobFyCtIaCXE9XT6nP0mza9A+zOkkfql6hswt9ZCw3KoQQrNlww1VT2Mpv5H5wcEKeqtjiiCNJjf2JcqWZethI5ZQYFBygGfiRdm4PGuREUJMLhcf/igiA8DQ7skQ5P7ziMV3EJYp9oUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0Lq4DmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0Lq4DmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D512E1F0089B;
	Tue,  2 Jun 2026 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439043;
	bh=HBVKDTAHA0enJh/3opUPjaF89rTM7TYcVXN5K9zN7b4=;
	h=Date:To:From:Subject;
	b=H0Lq4DmLPGn/4O5J8uNuRdhE1jVdVKO8ryyzqnqnkxJ+xjYn1yhgnOIaLd5mhi2S0
	 KBR4JZgb/ww6PHpTWxezS/Qta2ifn/zp91hkU8SANFWuofNwZ4BEer/onRPDHurWM5
	 nSdj7lG+p/6IGMfp7VqhsW05gbGkw79kcJlF8Ws8=
Date: Tue, 02 Jun 2026 15:24:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,kaleshsingh@google.com,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-no-pg_readahead-on-eof.patch removed from -mm tree
Message-Id: <20260602222403.D512E1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: no PG_readahead on EOF
has been removed from the -mm tree.  Its filename was
     mm-readahead-no-pg_readahead-on-eof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frederick Mayle <fmayle@google.com>
Subject: mm/readahead: no PG_readahead on EOF
Date: Fri, 8 May 2026 11:12:31 -0700

When readahead pulls in all the remaining pages for a file, setting the
readahead bit is counter productive.  The async readahead it would trigger
would almost certainly be a no-op.  Additionally, for mmap'd file IO, the
readahead bit limits the fault around [1], causing an extra minor fault
when the page is accessed.

This was discovered when looking at /sys/kernel/tracing/events/readahead
traces for a simple program.  With the patch applied, fewer
page_cache_ra_unbounded calls are observed.

[1] do_fault_around calls filemap_map_pages, which finds eligible pages
    by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
    with PG_readahead set [3].

Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3939 [2]
Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3722 [3]
Link: https://lore.kernel.org/20260508181237.670645-1-fmayle@google.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~mm-readahead-no-pg_readahead-on-eof
+++ a/mm/readahead.c
@@ -340,8 +340,11 @@ static void do_page_cache_ra(struct read
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
-	if (nr_to_read > end_index - index)
+	if (nr_to_read > end_index - index) {
 		nr_to_read = end_index - index + 1;
+		/* We've reached the end, so don't set a readahead marker. */
+		lookahead_size = 0;
+	}
 
 	filemap_invalidate_lock_shared(mapping);
 	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
@@ -485,7 +488,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit;
-	pgoff_t mark = index + ra->size - ra->async_size;
+	pgoff_t mark;
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
@@ -499,7 +502,13 @@ void page_cache_ra_order(struct readahea
 
 	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	limit = min(limit, ractl->_max_index);
-	limit = min(limit, index + ra->size - 1);
+	if (limit > index + ra->size - 1) {
+		limit = index + ra->size - 1;
+		mark = index + ra->size - ra->async_size;
+	} else {
+		/* We've reached the end, so don't set a readahead marker. */
+		mark = ULONG_MAX;
+	}
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
_

Patches currently in -mm which might be from fmayle@google.com are


