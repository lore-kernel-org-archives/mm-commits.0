Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272A21129C
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047089; cv=none; b=u7NkczL6iBPEHDYOVmGPvUZhtk1E92YXezarhEKi1X5T8k19CDyYznu2vGoUDP9QOiwHRJZYVl9QqOZKvO6YmsUyRvXrQKutcsgLa5jZ5Wt4ikp86y1ReKKWKa0rn5rTe5fGZvDGft8Cx/BFNomoYe5/xw2rXQww7lWor3PV+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047089; c=relaxed/simple;
	bh=4Axz3ZKQSVmu0dAEhmU4Ahl46ydsHENgjJop/+uaHNg=;
	h=Date:To:From:Subject:Message-Id; b=TfNzu2q/ft9ksVCXx2pMdvdrkKAs+qfL9GKuXVoLXikW9hKSeSZ34Gyccs92P5eRvgh0pOoBGh4FF6tSKn+2lsqUY4CEGkCcgaB0dlh62KSuANxhQ54YUIsZ4xBrqYkyGMeK0IuZHyNHpeX4vggRjFdYXADuzqiz+tkqg5rKRbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qkcUj5rR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qkcUj5rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6B0C4CEE7;
	Wed, 30 Apr 2025 21:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047089;
	bh=4Axz3ZKQSVmu0dAEhmU4Ahl46ydsHENgjJop/+uaHNg=;
	h=Date:To:From:Subject:From;
	b=qkcUj5rRMlKX7GwMcp/T/VHQPFq+hQ1e1iK6D6DcbjnRgBcq8MX4zWRUewlqfAqhS
	 8qkngQyC1kbJyvemA8ZeAiqdBoj0lOdRDhq941PS2FIjc4o52FZDSQ88KovUEqqO6Q
	 Noq4sZINgHB43nu4g47rpVKasZ/mB1S+msfyVVeo=
Date: Wed, 30 Apr 2025 14:04:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-drop-usage-of-folio_index.patch added to mm-new branch
Message-Id: <20250430210449.0F6B0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: f2fs: drop usage of folio_index
has been added to the -mm mm-new branch.  Its filename is
     f2fs-drop-usage-of-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/f2fs-drop-usage-of-folio_index.patch

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
Subject: f2fs: drop usage of folio_index
Date: Thu, 1 May 2025 02:10:49 +0800

folio_index is only needed for mixed usage of page cache and swap cache,
for pure page cache usage, the caller can just use folio->index instead.

It can't be a swap cache folio here.  Swap mapping may only call into fs
through `swap_rw` but f2fs does not use that method for swap.

Link: https://lkml.kernel.org/r/20250430181052.55698-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c   |    4 ++--
 fs/f2fs/inline.c |    4 ++--
 fs/f2fs/super.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/f2fs/data.c~f2fs-drop-usage-of-folio_index
+++ a/fs/f2fs/data.c
@@ -2077,7 +2077,7 @@ static int f2fs_read_single_page(struct
 	sector_t last_block;
 	sector_t last_block_in_file;
 	sector_t block_nr;
-	pgoff_t index = folio_index(folio);
+	pgoff_t index = folio->index;
 	int ret = 0;
 
 	block_in_file = (sector_t)index;
@@ -2392,7 +2392,7 @@ static int f2fs_mpage_readpages(struct i
 		}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-		index = folio_index(folio);
+		index = folio->index;
 
 		if (!f2fs_compressed_file(inode))
 			goto read_single_page;
--- a/fs/f2fs/inline.c~f2fs-drop-usage-of-folio_index
+++ a/fs/f2fs/inline.c
@@ -86,7 +86,7 @@ void f2fs_do_read_inline_data(struct fol
 	if (folio_test_uptodate(folio))
 		return;
 
-	f2fs_bug_on(F2FS_I_SB(inode), folio_index(folio));
+	f2fs_bug_on(F2FS_I_SB(inode), folio->index);
 
 	folio_zero_segment(folio, MAX_INLINE_DATA(inode), folio_size(folio));
 
@@ -130,7 +130,7 @@ int f2fs_read_inline_data(struct inode *
 		return -EAGAIN;
 	}
 
-	if (folio_index(folio))
+	if (folio->index)
 		folio_zero_segment(folio, 0, folio_size(folio));
 	else
 		f2fs_do_read_inline_data(folio, ipage);
--- a/fs/f2fs/super.c~f2fs-drop-usage-of-folio_index
+++ a/fs/f2fs/super.c
@@ -3432,7 +3432,7 @@ static int __f2fs_commit_super(struct f2
 	bio = bio_alloc(sbi->sb->s_bdev, 1, opf, GFP_NOFS);
 
 	/* it doesn't need to set crypto context for superblock update */
-	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(folio_index(folio));
+	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(folio->index);
 
 	if (!bio_add_folio(bio, folio, folio_size(folio), 0))
 		f2fs_bug_on(sbi, 1);
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

