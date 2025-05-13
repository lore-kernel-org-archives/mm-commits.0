Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F81EEA3C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119321; cv=none; b=Rhggkhy2/Z5cpzU22+NRtX7RnJanKY0xqxF3Lxd5B7IsTVWK1gev7bLEtcBwLaP7X3dT8Enhi498Xiqw/h38dgrDVcIZgzl9iB+ij31uxiu8Fpir480tasxP3tzG9M3f3yxiUNDFn0H9fymreOogMFLZLxsI52GGyMGJDhX3uuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119321; c=relaxed/simple;
	bh=DYcoGNwEMh/tVSpBWPQL/hYVQqHFDuOcAJ1J5w1a1VU=;
	h=Date:To:From:Subject:Message-Id; b=DPvSHrIYrrfUTX3GJa6C7Hzyzk3pHwHHc1yqbAxvbpBTPMdPAinm+or+hHuZOkjORNEJM/39gIVQQx5z8mKGxBGEigaHGxUuTgOnewp/zyCft0Vee+FF9V3Bj/XG/YLk5U7Y2rN8taUJElsvEPBLz/Q35Nnep/wFX9oW5pA0Ioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xG/yG0a8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xG/yG0a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8F7C4CEED;
	Tue, 13 May 2025 06:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119321;
	bh=DYcoGNwEMh/tVSpBWPQL/hYVQqHFDuOcAJ1J5w1a1VU=;
	h=Date:To:From:Subject:From;
	b=xG/yG0a8GAIqpBhA6OpHm3hrOHP5FRTFEpqMA+/DLjaZmTJV0K83UIsBlYSZLXkNU
	 FRjfWvLLx8Eg/lmOJd5E4oRXkfkUwioXcM0yy4tAXZujsGVzrielNYtJfeUbr36ph7
	 FuGWDd3bQxLFmKvcnNp4vycZk/mxifKeSn6Ge39E=
Date: Mon, 12 May 2025 23:55:20 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fuse-drop-usage-of-folio_index.patch removed from -mm tree
Message-Id: <20250513065521.6E8F7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fuse: drop usage of folio_index
has been removed from the -mm tree.  Its filename was
     fuse-drop-usage-of-folio_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Chris Li <chrisl@kernel.org>
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


