Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78EE2C2593
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047088; cv=none; b=qKnIjmZmSCq9Psz4PB16EuC3vr2Bwsb3Ui44HmQm1VTXd88MKanPTopWnnvSdMCGWMCFkrhb0+TSmNqoUkVKe1PovnBz/yyn7dbgYtuybo81VqVVNs4eI8zxPpDmDT4Ee17GUyaan7nT7GlTYxzFOc0OmGpMPS3uaX8Qjb6hCug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047088; c=relaxed/simple;
	bh=Va3OL+gi0Byfy2y+MsjC0kCHOOxF11hbYMOkTq/8RtI=;
	h=Date:To:From:Subject:Message-Id; b=BMhnvaZ/hY+6rHYR9pE/x1i3vQ4G1GUoVa75ujdU/SAKGhKTevG7dahK9vTNNOTsxWWj1NrN4GhxeF3cWs98aI4YU94CNwJ7YavnE6TycDTHMJsF9WoV85JzaaC8S6W4fW8192BPvde2jI7CTDV/oyTZ1ysCnbAhuiWt/RiKGvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZCNIrVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZCNIrVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A3DC4CEE7;
	Wed, 30 Apr 2025 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047087;
	bh=Va3OL+gi0Byfy2y+MsjC0kCHOOxF11hbYMOkTq/8RtI=;
	h=Date:To:From:Subject:From;
	b=eZCNIrVHY6CC8EQauq4Ewotwg8aFjcqjHJ7VvAqjMPYVt5N1io4nwf5ZRURCWJHgC
	 PNsoQUm3Gv0OkOwLJgNo34RlclUi7dLBLh/j1iOWTZjJQAcgZfVE8jUDXreJnunr54
	 4qmS7xlAPL4ZM5ALmizS/m7Y32CrKL5HigOpevpc=
Date: Wed, 30 Apr 2025 14:04:46 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-drop-usage-of-folio_index.patch added to mm-new branch
Message-Id: <20250430210447.83A3DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btrfs: drop usage of folio_index
has been added to the -mm mm-new branch.  Its filename is
     btrfs-drop-usage-of-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btrfs-drop-usage-of-folio_index.patch

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
Subject: btrfs: drop usage of folio_index
Date: Thu, 1 May 2025 02:10:48 +0800

folio_index is only needed for mixed usage of page cache and swap cache,
for pure page cache usage, the caller can just use folio->index instead.

It can't be a swap cache folio here.  Swap mapping may only call into fs
through `swap_rw` but btrfs does not use that method for swap.

Link: https://lkml.kernel.org/r/20250430181052.55698-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c~btrfs-drop-usage-of-folio_index
+++ a/fs/btrfs/extent_io.c
@@ -3509,7 +3509,7 @@ static void btree_clear_folio_dirty_tag(
 	xa_lock_irq(&folio->mapping->i_pages);
 	if (!folio_test_dirty(folio))
 		__xa_clear_mark(&folio->mapping->i_pages,
-				folio_index(folio), PAGECACHE_TAG_DIRTY);
+				folio->index, PAGECACHE_TAG_DIRTY);
 	xa_unlock_irq(&folio->mapping->i_pages);
 }
 
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

