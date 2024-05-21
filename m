Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A824714900F
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321476; cv=none; b=A1k/O8DdWUNSVGS4Imo2/pY1cXnubqNYbq1KYlsDmi3ExEjWBQLMMBgM4C2y2kgFIwGL4jrq1Vyom3i+QkTY1flC1+DNKAPoeU3Xv+luG2dUGt9N5HogR93pqUd4M2/TLWBdxZUlJoT4Yius1Pk4g9Ty+PYQzqi5ZVneDwCAUI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321476; c=relaxed/simple;
	bh=vywsZlcMrDt3ZxpxZoIQOGlN7wTBIycEejwfonUnniw=;
	h=Date:To:From:Subject:Message-Id; b=Y12sQMRCmkBwmA/1HAmd//C1JRYQYEHghI/HxPthOp+c41yME9IhOmTZ1keSXuPMsJNlokmpK0BR+Ypw+H5l2W+9od1l4YNMnFR5S5JFKhUM1Ru4R4ybWSI4pYUsbG3wZYhmjbuavg2Web8XL1mFlRxbtpeUZA8Cfgh+bllbtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gtNpCwqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gtNpCwqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB7C2BD11;
	Tue, 21 May 2024 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321476;
	bh=vywsZlcMrDt3ZxpxZoIQOGlN7wTBIycEejwfonUnniw=;
	h=Date:To:From:Subject:From;
	b=gtNpCwqvict5RdR7KvE7Z3GCjYJZMk3JXdVTje+HzUXU7cRDPNCY+WTLHJebpCUPR
	 VUknVCJJil73jmd2Ur1+Pc4gXhCSbISsBot7w8n23yjrBkOrHxDvIIe0qK6ebntNMz
	 4RMwNt6VBSvr58DqDjkcbe6ONI2sRMVcMmz1qqZw=
Date: Tue, 21 May 2024 12:57:55 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-drop-usage-of-page_index.patch added to mm-unstable branch
Message-Id: <20240521195756.13EB7C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: f2fs: drop usage of page_index
has been added to the -mm mm-unstable branch.  Its filename is
     f2fs-drop-usage-of-page_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/f2fs-drop-usage-of-page_index.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

f2fs-drop-usage-of-page_index.patch
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

