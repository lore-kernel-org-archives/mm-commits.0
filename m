From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 006/128] fs/buffer.c: record blockdev write errors
 in super_block that it backs
Date: Tue, 02 Jun 2020 13:10:12 -0700
Message-ID: <20200602201012.WpBYlBNtG%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFBUKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:10:13 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andres@anarazel.de, david@fromorbit.com, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, jlayton@kernel.org, jlayton@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, willy@infradead.org

From: Jeff Layton <jlayton@redhat.com>
Subject: fs/buffer.c: record blockdev write errors in super_block that it backs

When syncing out a block device (a'la __sync_blockdev), any error
encountered will only be recorded in the bd_inode's mapping.  When the
blockdev contains a filesystem however, we'd like to also record the error
in the super_block that's stored there.

Make mark_buffer_write_io_error also record the error in the corresponding
super_block when a writeback error occurs and the block device contains a
mounted superblock.

Since superblocks are RCU freed, hold the rcu_read_lock to ensure that the
superblock doesn't go away while we're marking it.

Link: http://lkml.kernel.org/r/20200428135155.19223-3-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/buffer.c~buffer-record-blockdev-write-errors-in-super_block-that-it-backs
+++ a/fs/buffer.c
@@ -1154,12 +1154,19 @@ EXPORT_SYMBOL(mark_buffer_dirty);
 
 void mark_buffer_write_io_error(struct buffer_head *bh)
 {
+	struct super_block *sb;
+
 	set_buffer_write_io_error(bh);
 	/* FIXME: do we need to set this in both places? */
 	if (bh->b_page && bh->b_page->mapping)
 		mapping_set_error(bh->b_page->mapping, -EIO);
 	if (bh->b_assoc_map)
 		mapping_set_error(bh->b_assoc_map, -EIO);
+	rcu_read_lock();
+	sb = READ_ONCE(bh->b_bdev->bd_super);
+	if (sb)
+		errseq_set(&sb->s_wb_err, -EIO);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
_
