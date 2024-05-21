Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD771494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321489; cv=none; b=h9bW7INwRTpa/xoiaYaJEA4GMzg+Haz9ljS1J9RPFdO3DJCGcczR8vLtiUyS4mEwBNOhO9TLyOZ9MKM8LHajWnsbZSDxsIHP2Pxqs7dsrUUM+wTZRb0g50v9Ff9dAY/NYv+Ky7Ci4WsVjvFHxK+HjVQBkOdips2yw2e2lQqXb74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321489; c=relaxed/simple;
	bh=sChcu8iSDvXkN9rxnKkqUsQyNnMvsoj9U6D2xA1qB98=;
	h=Date:To:From:Subject:Message-Id; b=WBV0WGybcCc7esd5zIzmYkjpfi2a5B+VwpjsVm2cjfmkhOnYsx72Fn23yIVjmysYscjxaSRKBMlvgh71SvT3bTIxv0/UtQIAnl1adYpfXahYWph3sLluq4lJD7+IBNubmE4F8/BAVjMeXs4U13oHnHQjJC+AQwpe/NO0UZtqK38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRMI7AdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRMI7AdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F485C32786;
	Tue, 21 May 2024 19:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321489;
	bh=sChcu8iSDvXkN9rxnKkqUsQyNnMvsoj9U6D2xA1qB98=;
	h=Date:To:From:Subject:From;
	b=YRMI7AdOhLNJL9FGL1jX4BRiqn1ZlPW2jFGVRafDVu0URGahtm70OwDR2VKHKCRes
	 qHtwQqn6Qn/Ib7iPSUjHORjZQyT5rb1M9xQr5ANgdqmECjvlzSTCeDiGqR+jTCMVco
	 yoR7jJXZxeyXRRwkdHw4crs1Xj5OVXdpCVS/BUYk=
Date: Tue, 21 May 2024 12:58:09 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-drop-usage-of-folio_file_pos.patch added to mm-unstable branch
Message-Id: <20240521195809.8F485C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nfs: drop usage of folio_file_pos
has been added to the -mm mm-unstable branch.  Its filename is
     nfs-drop-usage-of-folio_file_pos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-drop-usage-of-folio_file_pos.patch

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

