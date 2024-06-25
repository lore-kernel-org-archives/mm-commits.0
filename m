Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF3613CF9E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291555; cv=none; b=WSmnSxH04S2oq2VllyHeAzRXKTe/lqkN34GcXEKuBcvL/QBEJQoQ4JhyIe4HLub9wcwziv5u5EUbyaSfz7jd8hSyI87+jhghB2ndZc3sXYoINCfy75KHXnARZp7ZyqtNFkksd3yTkAWANTw9HilNEmFG3i3BBVYJ0NiwGLYpBz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291555; c=relaxed/simple;
	bh=oRULhBiao0F2nAnegE3hN/sgsG/qQ5X2Rgwfzu5cLbw=;
	h=Date:To:From:Subject:Message-Id; b=rp1oMb0D+wL55u4aY7klpFWaS7GOo5bs8b23XYZevbWRdMYV4zrxVNylTzEf7vjTgEuJ68nY9TzO9bopk2gAwU5+5/roxBrA6FOgvUgjyti7wKtI/90XxeXwngU6qt1IzHsG/3bGOP8nnZW6aS7mt4zLkCU/XgS5ysFknC8rRPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aa5h7xBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aa5h7xBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB52C32782;
	Tue, 25 Jun 2024 04:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291555;
	bh=oRULhBiao0F2nAnegE3hN/sgsG/qQ5X2Rgwfzu5cLbw=;
	h=Date:To:From:Subject:From;
	b=aa5h7xBeqfEdllUBagEL/xNPyWpyssJgyxQwYOl5GetDlYIPqIdWnrUelOsem9ytr
	 EvqEAsuQz/IWXVTNjDV7NmHuk7JhR+9fWQXYkRCYjdbPUgXtWHtlA9rb0Iqwmw0BX/
	 dRTM+3iuwZibR7VznT4bQSjH3B6txQl/ZcTZP5yU=
Date: Mon, 24 Jun 2024 21:59:14 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nfs-drop-usage-of-folio_file_pos.patch removed from -mm tree
Message-Id: <20240625045915.3EB52C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nfs: drop usage of folio_file_pos
has been removed from the -mm tree.  Its filename was
     nfs-drop-usage-of-folio_file_pos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: nfs: drop usage of folio_file_pos
Date: Wed, 22 May 2024 01:58:49 +0800

folio_file_pos is only needed for mixed usage of page cache and swap
cache, for pure page cache usage, the caller can just use folio_pos
instead.

After commit e1209d3a7a67 ("mm: introduce ->swap_rw and use it for reads
from SWP_FS_OPS swap-space"), swap cache should never be exposed to nfs.

So remove the usage of folio_file_pos in following NFS functions / helpers:

- nfs_vm_page_mkwrite

  It's only used by nfs_file_vm_ops.page_mkwrite

- trace event helper: nfs_folio_event
- trace event helper: nfs_folio_event_done

  These two are used through DEFINE_NFS_FOLIO_EVENT and
  DEFINE_NFS_FOLIO_EVENT_DONE, which defined following events:

  - trace_nfs_aop_readpage{_done}: only called by nfs_read_folio
  - trace_nfs_writeback_folio: only called by nfs_wb_folio
  - trace_nfs_invalidate_folio: only called by nfs_invalidate_folio
  - trace_nfs_launder_folio_done: only called by nfs_launder_folio

  None of them could possibly be used on swap cache folio,
  nfs_read_folio only called by:
  .write_begin -> nfs_read_folio
  .read_folio

  nfs_wb_folio only called by nfs mapping:
  .release_folio -> nfs_wb_folio
  .launder_folio -> nfs_wb_folio
  .write_begin -> nfs_read_folio -> nfs_wb_folio
  .read_folio -> nfs_wb_folio
  .write_end -> nfs_update_folio -> nfs_writepage_setup -> nfs_setup_write_request -> nfs_try_to_update_request -> nfs_wb_folio
  .page_mkwrite -> nfs_update_folio -> nfs_writepage_setup -> nfs_setup_write_request -> nfs_try_to_update_request -> nfs_wb_folio
  .write_begin -> nfs_flush_incompatible -> nfs_wb_folio
  .page_mkwrite -> nfs_vm_page_mkwrite -> nfs_flush_incompatible -> nfs_wb_folio

  nfs_invalidate_folio is only called by .invalidate_folio.
  nfs_launder_folio is only called by .launder_folio

- nfs_grow_file
- nfs_update_folio

  nfs_grow_file is only called by nfs_update_folio, and all
  possible callers of them are:

  .write_end -> nfs_update_folio
  .page_mkwrite -> nfs_update_folio

- nfs_wb_folio_cancel

  .invalidate_folio -> nfs_wb_folio_cancel

Also, seeing from the swap side, swap_rw is now the only interface calling
into fs, the offset info is always in iocb.ki_pos now.

So we can remove all these folio_file_pos call safely.

Link: https://lkml.kernel.org/r/20240521175854.96038-8-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c     |    2 +-
 fs/nfs/nfstrace.h |    4 ++--
 fs/nfs/write.c    |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nfs/file.c~nfs-drop-usage-of-folio_file_pos
+++ a/fs/nfs/file.c
@@ -588,7 +588,7 @@ static vm_fault_t nfs_vm_page_mkwrite(st
 
 	dfprintk(PAGECACHE, "NFS: vm_page_mkwrite(%pD2(%lu), offset %lld)\n",
 		 filp, filp->f_mapping->host->i_ino,
-		 (long long)folio_file_pos(folio));
+		 (long long)folio_pos(folio));
 
 	sb_start_pagefault(inode->i_sb);
 
--- a/fs/nfs/nfstrace.h~nfs-drop-usage-of-folio_file_pos
+++ a/fs/nfs/nfstrace.h
@@ -960,7 +960,7 @@ DECLARE_EVENT_CLASS(nfs_folio_event,
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->version = inode_peek_iversion_raw(inode);
-			__entry->offset = folio_file_pos(folio);
+			__entry->offset = folio_pos(folio);
 			__entry->count = nfs_folio_length(folio);
 		),
 
@@ -1008,7 +1008,7 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->version = inode_peek_iversion_raw(inode);
-			__entry->offset = folio_file_pos(folio);
+			__entry->offset = folio_pos(folio);
 			__entry->count = nfs_folio_length(folio);
 			__entry->ret = ret;
 		),
--- a/fs/nfs/write.c~nfs-drop-usage-of-folio_file_pos
+++ a/fs/nfs/write.c
@@ -281,7 +281,7 @@ static void nfs_grow_file(struct folio *
 	end_index = ((i_size - 1) >> folio_shift(folio)) << folio_order(folio);
 	if (i_size > 0 && folio_index(folio) < end_index)
 		goto out;
-	end = folio_file_pos(folio) + (loff_t)offset + (loff_t)count;
+	end = folio_pos(folio) + (loff_t)offset + (loff_t)count;
 	if (i_size >= end)
 		goto out;
 	trace_nfs_size_grow(inode, end);
@@ -1362,7 +1362,7 @@ int nfs_update_folio(struct file *file,
 	nfs_inc_stats(inode, NFSIOS_VFSUPDATEPAGE);
 
 	dprintk("NFS:       nfs_update_folio(%pD2 %d@%lld)\n", file, count,
-		(long long)(folio_file_pos(folio) + offset));
+		(long long)(folio_pos(folio) + offset));
 
 	if (!count)
 		goto out;
@@ -2073,7 +2073,7 @@ int nfs_wb_folio_cancel(struct inode *in
  */
 int nfs_wb_folio(struct inode *inode, struct folio *folio)
 {
-	loff_t range_start = folio_file_pos(folio);
+	loff_t range_start = folio_pos(folio);
 	loff_t range_end = range_start + (loff_t)folio_size(folio) - 1;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
_

Patches currently in -mm which might be from kasong@tencent.com are


