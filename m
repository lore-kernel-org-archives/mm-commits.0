Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEAA1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119323; cv=none; b=FYjciMHl0GTBePgX+DSA9v0Ar1UYK/YXuRCMuAMMkaf0++iO84LQ3K5YDrbCQ3x95GUTUq/h6A+0C3tKtxiFyR4BJ5VSSsEG0bSQvt/hLJSRdFEFXWsbeVmp9fTwCPjo4Rnx6EYRYTESSLjLPddlNYgP6tOqmLgWAkHtg37D9+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119323; c=relaxed/simple;
	bh=2clQOj5r6nSqwuGGrq8TkNLpzWs7+Mps8TQ1V2/mKos=;
	h=Date:To:From:Subject:Message-Id; b=R/v4dbl+Qpy8TY7epRHDdu1Hv3tEjlz2rtYuf35ZaLSxXsNgpLSyyWO/n90uhFb5oE3VsSTt+FkK1XNsUXKxLP1dBeGqt3NthoEPM56WEx1ERoNuq2oI5+M2f6L3LDupQ286p6H1LEvn8oR1+wQhboZivvFx4QZ7sO3AAGo0fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mILAX/YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mILAX/YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0563DC4CEE4;
	Tue, 13 May 2025 06:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119323;
	bh=2clQOj5r6nSqwuGGrq8TkNLpzWs7+Mps8TQ1V2/mKos=;
	h=Date:To:From:Subject:From;
	b=mILAX/YKo/1kgPPz8S38E42HzGWvChkTKDYknVXd+SW3CoeWXBwtPU5aN7czF22+D
	 dNnG26lIfvvcVAfZfUsTvJYb0vJVeOmwiOxjI1QLTPjgi7qFuIErC97Cb2jUuMPSsA
	 paKukOsMJOxCaKIBqhQIKXpozhxV4h1BTk4FHN0c=
Date: Mon, 12 May 2025 23:55:22 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] f2fs-drop-usage-of-folio_index.patch removed from -mm tree
Message-Id: <20250513065523.0563DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: f2fs: drop usage of folio_index
has been removed from the -mm tree.  Its filename was
     f2fs-drop-usage-of-folio_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
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


