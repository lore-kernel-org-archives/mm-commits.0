Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA2B13DB88
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291549; cv=none; b=B8jk9Am9ZnGzqFBMWZ8n72wAQ99EdFoxza4M7m/BLoIYYZpZNWp+jqMv707SoLtfy4vodBt+98leBoDilhViWOsqCWXwouveXqcXxqwoxFCSOM1tgTL4QnPW/x5yRKix3hYwQEPhqEF93s/8rAI4N2aFaBFaH1mIxQjOneCU8e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291549; c=relaxed/simple;
	bh=q5c6Z/yVL8OQfm/HZoqr8WsKIG7uhHNP8x+x6SgJDfU=;
	h=Date:To:From:Subject:Message-Id; b=BjkTd1f6Ue/K8ZizTYrZ1Pb/tCazTML5m6T0OpJpek0jzCzdoSArltd4pZg49bKDo+mhUUZMsOSzFhGo09WVk33o5RQdgFaHSvxKz9cwV3pQX07bFKacjYehyHlgVT4vn64PkUj+lPvzFTOt00kHuK0NeJKA46+ltKw09mWGMfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGeemAax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGeemAax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E430DC32782;
	Tue, 25 Jun 2024 04:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291549;
	bh=q5c6Z/yVL8OQfm/HZoqr8WsKIG7uhHNP8x+x6SgJDfU=;
	h=Date:To:From:Subject:From;
	b=XGeemAaxgQHvtY98Gq80D/BT1K7PEI+egJUASuEYBCNlUmhuqQNIBNfGCUBQAYYSU
	 v632xAClBibsRa84nZvMUeud9JepachsjZ2+TgNkgJ2hpBRLtlBjkRyuveCE5ecqd8
	 Ax+P2iDIk3aQMZnRMtgrWrthrDVrmGwh4bTldhq8=
Date: Mon, 24 Jun 2024 21:59:08 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-drop-usage-of-page_index.patch removed from -mm tree
Message-Id: <20240625045908.E430DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: drop usage of page_index
has been removed from the -mm tree.  Its filename was
     nilfs2-drop-usage-of-page_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: nilfs2: drop usage of page_index
Date: Wed, 22 May 2024 01:58:44 +0800

Patch series "mm/swap: clean up and optimize swap cache index", v6.

Currently we use one swap_address_space for every 64M chunk to reduce lock
contention, this is like having a set of smaller files inside a swap
device.  But when doing swap cache look up or insert, we are still using
the offset of the whole large swap device.  This is OK for correctness, as
the offset (key) is unique.

But Xarray is specially optimized for small indexes, it creates the redix
tree levels lazily to be just enough to fit the largest key stored in one
Xarray.  So we are wasting tree nodes unnecessarily.

For 64M chunk it should only take at most 3 level to contain everything. 
But if we are using the offset from the whole swap device, the offset
(key) value will be way beyond 64M, and so will the tree level.

Optimize this by reduce the swap cache search space into 64M scope.

Test with `time memhog 128G` inside a 8G memcg using 128G swap (ramdisk
with SWP_SYNCHRONOUS_IO dropped, tested 3 times, results are stable.  The
test result is similar but the improvement is smaller if
SWP_SYNCHRONOUS_IO is enabled, as swap out path can never skip swap
cache):

Before:
6.07user 250.74system 4:17.26elapsed 99%CPU (0avgtext+0avgdata 8373376maxresident)k
0inputs+0outputs (55major+33555018minor)pagefaults 0swaps

After (+1.8% faster):
6.08user 246.09system 4:12.58elapsed 99%CPU (0avgtext+0avgdata 8373248maxresident)k
0inputs+0outputs (54major+33555027minor)pagefaults 0swaps

Similar result with MySQL and sysbench using swap:
Before:
94055.61 qps

After (+0.8% faster):
94834.91 qps

There is alse a very slight drop of radix tree node slab usage:
Before: 303952K
After:  302224K

For this series:

There are multiple places that expect mixed type of pages (page cache or
swap cache), eg. migration, huge memory split; There are four helpers
for that:

- page_index
- page_file_offset
- folio_index
- folio_file_pos

To keep the code clean and compatible, this series first cleaned up usage
of them.

page_file_offset and folio_file_pos are historical helpes that can be
simply dropped after clean up.  And page_index can be all converted to
folio_index or folio->index.

Then introduce two new helpers swap_cache_index and swap_dev_pos for swap.
Replace swp_offset with swap_cache_index when used to retrieve folio from
swap cache, and use swap_dev_pos when needed to retrieve the device
position of a swap entry.  This way, swap_cache_index can return the
optimized value with no compatibility issue.

The result is better performance and reduced LOC.

Idealy, in the future, we may want to reduce SWAP_ADDRESS_SPACE_SHIFT from
14 to 12: Default Xarray chunk offset is 6, so we have 3 level trees
instead of 2 level trees just for 2 extra bits.  But swap cache is based
on address_space struct, with 4 times more metadata sparsely distributed
in memory it waste more cacheline, the performance gain from this series
is almost canceled according to my test.  So first, just have a cleaner
seperation of offsets and smaller search space.


This patch (of 10):

page_index is only for mixed usage of page cache and swap cache, for pure
page cache usage, the caller can just use page->index instead.

It can't be a swap cache page here (being part of buffer head), so just
drop it.  And while we are at it, optimize the code by retrieving the
offset of the buffer head within the folio directly using bh_offset, and
get rid of the loop and usage of page helpers.

Link: https://lkml.kernel.org/r/20240521175854.96038-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240521175854.96038-3-ryncsn@gmail.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-drop-usage-of-page_index
+++ a/fs/nilfs2/bmap.c
@@ -450,15 +450,9 @@ int nilfs_bmap_test_and_clear_dirty(stru
 __u64 nilfs_bmap_data_get_key(const struct nilfs_bmap *bmap,
 			      const struct buffer_head *bh)
 {
-	struct buffer_head *pbh;
-	__u64 key;
+	loff_t pos = folio_pos(bh->b_folio) + bh_offset(bh);
 
-	key = page_index(bh->b_page) << (PAGE_SHIFT -
-					 bmap->b_inode->i_blkbits);
-	for (pbh = page_buffers(bh->b_page); pbh != bh; pbh = pbh->b_this_page)
-		key++;
-
-	return key;
+	return pos >> bmap->b_inode->i_blkbits;
 }
 
 __u64 nilfs_bmap_find_target_seq(const struct nilfs_bmap *bmap, __u64 key)
_

Patches currently in -mm which might be from kasong@tencent.com are


