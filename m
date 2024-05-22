Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F07BAF7
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 21:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412959; cv=none; b=FchscHTWs6R1Jy2Hr7VXYDJzg8ce60hulHgXlGsIPocFIPHXNQU8JU7swhyrjZnL7Wc8s0tCXWae2fE9tJ0//+QPX+U1O2A/m0usMe0lPB+6y03oPl17pzEtrwEy8cxSh7sLfSRZf/dSvfUUIwTHqlQkf/FpLJ+3pQlwWduSltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412959; c=relaxed/simple;
	bh=IgPLUZBx1tbgjNWj38KnpSt8IwSEh/tFzRB9DO+GnuE=;
	h=Date:To:From:Subject:Message-Id; b=Opf8ODryNeeH/LRiji0CtojgzKIVAxJ8Bc2ViS1XGOBavw3X6hg8Xl9uAHaNHem4BlQJI8sbBsnan8ZZvHB+AKkn6AT0Jt+6yL+Fwz4s9QSpTNk/TD1neUiUoQ0DOWUyF0Ym3O1hRFAcpRGgx3hTjGi/Coebvv/eIHKkRMI0OCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rhC020q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rhC020q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E08C2BBFC;
	Wed, 22 May 2024 21:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716412958;
	bh=IgPLUZBx1tbgjNWj38KnpSt8IwSEh/tFzRB9DO+GnuE=;
	h=Date:To:From:Subject:From;
	b=rhC020q83Tb55vg5JdqyEhDdDC8abZxV1tHMc6JmydsKKyG8tXJrPje/RoEsPTdrC
	 Bsm12/HwPuXNl8bekG8YviPilTK7PFFH1vLWST9X/a0milHVY2gew7AgwIBxxyx/tq
	 uXULcZmB/6JQ7KVnMuMzMTyuByDc0KbvWWTK7m3Q=
Date: Wed, 22 May 2024 14:22:37 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] f2fs-drop-usage-of-page_index.patch removed from -mm tree
Message-Id: <20240522212238.93E08C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: f2fs: drop usage of page_index
has been removed from the -mm tree.  Its filename was
     f2fs-drop-usage-of-page_index.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: f2fs: drop usage of page_index
Date: Wed, 22 May 2024 01:58:43 +0800

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


This patch (of 11):

page_index is needed for mixed usage of page cache and swap cache, for
pure page cache usage, the caller can just use page->index instead.

It can't be a swap cache page here, so just drop it.

[ This commit will not be needed once f2fs converted
  f2fs_mpage_readpages() to use folio]

Link: https://lkml.kernel.org/r/20240521175854.96038-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240521175854.96038-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/data.c~f2fs-drop-usage-of-page_index
+++ a/fs/f2fs/data.c
@@ -2057,7 +2057,7 @@ static int f2fs_read_single_page(struct
 	sector_t block_nr;
 	int ret = 0;
 
-	block_in_file = (sector_t)page_index(page);
+	block_in_file = (sector_t)page->index;
 	last_block = block_in_file + nr_pages;
 	last_block_in_file = bytes_to_blks(inode,
 			f2fs_readpage_limit(inode) + blocksize - 1);
_

Patches currently in -mm which might be from kasong@tencent.com are

nilfs2-drop-usage-of-page_index.patch
ceph-drop-usage-of-page_index.patch
nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch
afs-drop-usage-of-folio_file_pos.patch
netfs-drop-usage-of-folio_file_pos.patch
nfs-drop-usage-of-folio_file_pos.patch
mm-swap-get-the-swap-device-offset-directly.patch
mm-remove-page_file_offset-and-folio_file_pos.patch
mm-drop-page_index-and-simplify-folio_index.patch
mm-swap-reduce-swap-cache-search-space.patch

