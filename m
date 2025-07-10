Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F8828467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126225; cv=none; b=SBC/OqgyduSoaNMNX0V1e2M7hTFz6LKOe+sHN65qH6yZED4a7thDmJMzaExmnhHJFpXlVEQdmIsCahi87eR0OUA2iHzE6busTJ1K1feWd5SpTd+CCrPPW5VfCyl/RxP4PuAAQqiTIx19yGZJWT0MbQ+TWKbs9GvGNP7hWLXzzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126225; c=relaxed/simple;
	bh=qpEsOe6BaacaEfN6sUjixBtDTwEZ/ppM1fSHHQbhof4=;
	h=Date:To:From:Subject:Message-Id; b=K37MMh7ksNkH51FmECO943JnD5D6/CZJISYBTjp9jFox2/S8gwGs49qhUMWkzASXNK//smXbHaJFBNeVVa4uHElSyeP40nXPa7W4zy5KAtOpwmeYxRgHheGSq0OR7+YdUP3TwhKDVNBiw6cyefSLuhR6hAbZSHw5sm7D3O1jhzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFZEEqLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFZEEqLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF829C4CEE3;
	Thu, 10 Jul 2025 05:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126224;
	bh=qpEsOe6BaacaEfN6sUjixBtDTwEZ/ppM1fSHHQbhof4=;
	h=Date:To:From:Subject:From;
	b=HFZEEqLVmifjkxoDXurjxb/QkiTiSQyLv4npzgr+ANMuS/Oc/6xFSvw9bwMdq7HUe
	 MUnBVsmik/zsIJ+82FYriLBAQsN3RybvcgDACKPvzNDVAgprb4F5rub6/JD9+OHKMQ
	 cbPhz2+ng2NmENaZZ/bydoiQvTnWKJroU4FroZqo=
Date: Wed, 09 Jul 2025 22:43:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-for_reclaim-field-from-struct-writeback_control.patch removed from -mm tree
Message-Id: <20250710054344.CF829C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the for_reclaim field from struct writeback_control
has been removed from the -mm tree.  Its filename was
     mm-remove-the-for_reclaim-field-from-struct-writeback_control.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the for_reclaim field from struct writeback_control
Date: Tue, 10 Jun 2025 07:49:42 +0200

This field is now only set to one in the i915 gem code that only calls
writeback_iter on it, which ignores the flag.  All other checks are thuse
dead code and the field can be removed.

Link: https://lkml.kernel.org/r/20250610054959.2057526-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    1 -
 fs/fuse/file.c                            |   11 -----------
 fs/nfs/write.c                            |    2 +-
 include/linux/writeback.h                 |    1 -
 include/trace/events/btrfs.h              |    7 ++-----
 include/trace/events/writeback.h          |    8 ++------
 6 files changed, 5 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -302,7 +302,6 @@ void __shmem_writeback(size_t size, stru
 		.nr_to_write = SWAP_CLUSTER_MAX,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
-		.for_reclaim = 1,
 	};
 	struct folio *folio = NULL;
 	int error = 0;
--- a/fs/fuse/file.c~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/fs/fuse/file.c
@@ -1927,17 +1927,6 @@ int fuse_write_inode(struct inode *inode
 	struct fuse_file *ff;
 	int err;
 
-	/*
-	 * Inode is always written before the last reference is dropped and
-	 * hence this should not be reached from reclaim.
-	 *
-	 * Writing back the inode from reclaim can deadlock if the request
-	 * processing itself needs an allocation.  Allocations triggering
-	 * reclaim while serving a request can't be prevented, because it can
-	 * involve any number of unrelated userspace processes.
-	 */
-	WARN_ON(wbc->for_reclaim);
-
 	ff = __fuse_write_file_get(fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
--- a/fs/nfs/write.c~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/fs/nfs/write.c
@@ -720,7 +720,7 @@ int nfs_writepages(struct address_space
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGES);
 
 	if (!(mntflags & NFS_MOUNT_WRITE_EAGER) || wbc->for_kupdate ||
-	    wbc->for_background || wbc->for_sync || wbc->for_reclaim) {
+	    wbc->for_background || wbc->for_sync) {
 		ioc = nfs_io_completion_alloc(GFP_KERNEL);
 		if (ioc)
 			nfs_io_completion_init(ioc, nfs_io_completion_commit,
--- a/include/linux/writeback.h~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/include/linux/writeback.h
@@ -59,7 +59,6 @@ struct writeback_control {
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
-	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 	unsigned unpinned_netfs_wb:1;	/* Cleared I_PINNING_NETFS_WB */
--- a/include/trace/events/btrfs.h~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/include/trace/events/btrfs.h
@@ -686,7 +686,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__field(	loff_t, range_start		)
 		__field(	loff_t, range_end		)
 		__field(	char,   for_kupdate		)
-		__field(	char,   for_reclaim		)
 		__field(	char,   range_cyclic		)
 		__field(	unsigned long,  writeback_index	)
 		__field(	u64,    root_objectid		)
@@ -700,7 +699,6 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 		__entry->range_start	= wbc->range_start;
 		__entry->range_end	= wbc->range_end;
 		__entry->for_kupdate	= wbc->for_kupdate;
-		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
@@ -709,13 +707,12 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
 	TP_printk_btrfs("root=%llu(%s) ino=%llu page_index=%lu "
 		  "nr_to_write=%ld pages_skipped=%ld range_start=%llu "
 		  "range_end=%llu for_kupdate=%d "
-		  "for_reclaim=%d range_cyclic=%d writeback_index=%lu",
+		  "range_cyclic=%d writeback_index=%lu",
 		  show_root_type(__entry->root_objectid),
 		  __entry->ino, __entry->index,
 		  __entry->nr_to_write, __entry->pages_skipped,
 		  __entry->range_start, __entry->range_end,
-		  __entry->for_kupdate,
-		  __entry->for_reclaim, __entry->range_cyclic,
+		  __entry->for_kupdate, __entry->range_cyclic,
 		  __entry->writeback_index)
 );
 
--- a/include/trace/events/writeback.h~mm-remove-the-for_reclaim-field-from-struct-writeback_control
+++ a/include/trace/events/writeback.h
@@ -459,7 +459,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, sync_mode)
 		__field(int, for_kupdate)
 		__field(int, for_background)
-		__field(int, for_reclaim)
 		__field(int, range_cyclic)
 		__field(long, range_start)
 		__field(long, range_end)
@@ -473,23 +472,20 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_background	= wbc->for_background;
-		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->range_start	= (long)wbc->range_start;
 		__entry->range_end	= (long)wbc->range_end;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
 	),
 
-	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d "
-		"start=0x%lx end=0x%lx cgroup_ino=%lu",
+	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d bgrd=%d "
+		"cyclic=%d start=0x%lx end=0x%lx cgroup_ino=%lu",
 		__entry->name,
 		__entry->nr_to_write,
 		__entry->pages_skipped,
 		__entry->sync_mode,
 		__entry->for_kupdate,
 		__entry->for_background,
-		__entry->for_reclaim,
 		__entry->range_cyclic,
 		__entry->range_start,
 		__entry->range_end,
_

Patches currently in -mm which might be from hch@lst.de are


