From: akpm@linux-foundation.org
Subject: [patch 7/8] fs: break out of iomap_file_buffered_write on fatal
 signals
Date: Fri, 03 Feb 2017 13:13:26 -0800
Message-ID: <5894f276.zI3ojP1dHzr6fjNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdBCVN1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 16:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk

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
