From: akpm@linux-foundation.org
Subject: [merged]
 fs-break-out-of-iomap_file_buffered_write-on-fatal-signals.patch removed
 from -mm tree
Date: Mon, 06 Feb 2017 13:24:49 -0800
Message-ID: <5898e9a1.II8vTIIfPtgacf2j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdBFVYu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 16:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: break out of iomap_file_buffered_write on fatal signals
has been removed from the -mm tree.  Its filename was
     fs-break-out-of-iomap_file_buffered_write-on-fatal-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs: break out of iomap_file_buffered_write on fatal signals

Tetsuo has noticed that an OOM stress test which performs large write
requests can cause the full memory reserves depletion.  He has tracked
this down to the following path

	__alloc_pages_nodemask+0x436/0x4d0
	alloc_pages_current+0x97/0x1b0
	__page_cache_alloc+0x15d/0x1a0          mm/filemap.c:728
	pagecache_get_page+0x5a/0x2b0           mm/filemap.c:1331
	grab_cache_page_write_begin+0x23/0x40   mm/filemap.c:2773
	iomap_write_begin+0x50/0xd0             fs/iomap.c:118
	iomap_write_actor+0xb5/0x1a0            fs/iomap.c:190
	? iomap_write_end+0x80/0x80             fs/iomap.c:150
	iomap_apply+0xb3/0x130                  fs/iomap.c:79
	iomap_file_buffered_write+0x68/0xa0     fs/iomap.c:243
	? iomap_write_end+0x80/0x80
	xfs_file_buffered_aio_write+0x132/0x390 [xfs]
	? remove_wait_queue+0x59/0x60
	xfs_file_write_iter+0x90/0x130 [xfs]
	__vfs_write+0xe5/0x140
	vfs_write+0xc7/0x1f0
	? syscall_trace_enter+0x1d0/0x380
	SyS_write+0x58/0xc0
	do_syscall_64+0x6c/0x200
	entry_SYSCALL64_slow_path+0x25/0x25

the oom victim has access to all memory reserves to make a forward
progress to exit easier.  But iomap_file_buffered_write and other callers
of iomap_apply loop to complete the full request.  We need to check for
fatal signals and back off with a short write instead.  As the iomap_apply
delegates all the work down to the actor we have to hook into those.  All
callers that work with the page cache are calling iomap_write_begin so we
will check for signals there.  dax_iomap_actor has to handle the situation
explicitly because it copies data to the userspace directly.  Other
callers like iomap_page_mkwrite work on a single page or
iomap_fiemap_actor do not allocate memory based on the given len.

Fixes: 68a9f5e7007c ("xfs: implement iomap based buffered write path")
Link: http://lkml.kernel.org/r/20170201092706.9966-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c   |    5 +++++
 fs/iomap.c |    3 +++
 2 files changed, 8 insertions(+)

diff -puN fs/dax.c~fs-break-out-of-iomap_file_buffered_write-on-fatal-signals fs/dax.c
--- a/fs/dax.c~fs-break-out-of-iomap_file_buffered_write-on-fatal-signals
+++ a/fs/dax.c
@@ -1031,6 +1031,11 @@ dax_iomap_actor(struct inode *inode, lof
 		struct blk_dax_ctl dax = { 0 };
 		ssize_t map_len;
 
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
 		dax.sector = dax_iomap_sector(iomap, pos);
 		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
 		map_len = dax_map_atomic(iomap->bdev, &dax);
diff -puN fs/iomap.c~fs-break-out-of-iomap_file_buffered_write-on-fatal-signals fs/iomap.c
--- a/fs/iomap.c~fs-break-out-of-iomap_file_buffered_write-on-fatal-signals
+++ a/fs/iomap.c
@@ -114,6 +114,9 @@ iomap_write_begin(struct inode *inode, l
 
 	BUG_ON(pos + len > iomap->offset + iomap->length);
 
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
 	page = grab_cache_page_write_begin(inode->i_mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

