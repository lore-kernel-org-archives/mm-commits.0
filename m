Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7330F21129C
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047086; cv=none; b=cc29Zwup/My/bGgd4JrT0wqfP6fb+sGWJR0gWus0FntHrscHCh59hHntsIGOVZKiSJTwrGhtmQynrDj2DFMBAasIbjvD3jungBs7Y35jc1YF0kXEEmcUArYNLC44Gk2QDhH8gf8PgJb0doiE/0rmh+j3iXMzmn3rs26m+Uno6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047086; c=relaxed/simple;
	bh=pbjIZD6HlT6wItjj+JuA51s4w/yLFjZg7PJW+Dz10Xo=;
	h=Date:To:From:Subject:Message-Id; b=teUYCx5cPIscpTMw8poQrcy10uwLVV3qbZxYW8yDjyoVnq/H7n/VBUUGLS0KXCGSnIwbWaBvFTtDWz1ylv2K5tP0h6KPPBeW0jgn9hxyg8qvp4cTR5Zg9258k0a0P9jb0y71ZsFSTq7Ho53MpYM6ZI/watkNZcmYFjm6HkHq2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y4xXPYTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y4xXPYTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0EFC4CEE7;
	Wed, 30 Apr 2025 21:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047085;
	bh=pbjIZD6HlT6wItjj+JuA51s4w/yLFjZg7PJW+Dz10Xo=;
	h=Date:To:From:Subject:From;
	b=Y4xXPYTw27sFkiXuDyp0Z3bng+OdOxtIfr9+d/vC9P0M25+m2hw6wXeTKsnxliXrC
	 i9P/4rPO7YfKKgOJ8Q2cOMYqbHmO21l+IchXlikfdbn55SKIlieHQADfWv/jM2BxO2
	 4w6RtxCRd+UBfJYdpvGBaK7mU3QzG3UA+XyEpvZw=
Date: Wed, 30 Apr 2025 14:04:44 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-drop-usage-of-folio_index.patch added to mm-new branch
Message-Id: <20250430210445.CE0EFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fuse: drop usage of folio_index
has been added to the -mm mm-new branch.  Its filename is
     fuse-drop-usage-of-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-drop-usage-of-folio_index.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: fuse: drop usage of folio_index
Date: Thu, 1 May 2025 02:10:47 +0800

Patch series "mm, swap: clean up swap cache mapping helper", v3.

This series removes usage of folio_index usage in fs/, and remove swap
cache checking in folio_contains.

Currently, the swap cache is already no longer directly exposed to fs, and
swap cache will be more different from page cache.  Clean up the helpers
first to simplify the code and eliminate the helpers used for resolving
circular header dependency issue between filemap and swap headers, and
prepare for further changes.


This patch (of 6):

folio_index is only needed for mixed usage of page cache and swap cache,
for pure page cache usage, the caller can just use folio->index instead.

It can't be a swap cache folio here.  Swap mapping may only call into fs
through `swap_rw` but fuse does not use that method for SWAP.

Link: https://lkml.kernel.org/r/20250430181052.55698-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250430181052.55698-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fuse/file.c~fuse-drop-usage-of-folio_index
+++ a/fs/fuse/file.c
@@ -487,7 +487,7 @@ static inline bool fuse_folio_is_writeba
 					   struct folio *folio)
 {
 	pgoff_t last = folio_next_index(folio) - 1;
-	return fuse_range_is_writeback(inode, folio_index(folio), last);
+	return fuse_range_is_writeback(inode, folio->index, last);
 }
 
 static void fuse_wait_on_folio_writeback(struct inode *inode,
@@ -2349,7 +2349,7 @@ static bool fuse_writepage_need_send(str
 		return true;
 
 	/* Discontinuity */
-	if (data->orig_folios[ap->num_folios - 1]->index + 1 != folio_index(folio))
+	if (data->orig_folios[ap->num_folios - 1]->index + 1 != folio->index)
 		return true;
 
 	/* Need to grow the pages array?  If so, did the expansion fail? */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch
fuse-drop-usage-of-folio_index.patch
btrfs-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

