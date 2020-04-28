From: akpm@linux-foundation.org
Subject: +
 buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch
 added to -mm tree
Date: Tue, 28 Apr 2020 16:49:43 -0700
Message-ID: <20200428234943.Ybg6sl9Vl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgD1Xtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Apr 2020 19:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andres@anarazel.de, david@fromorbit.com, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, jlayton@kernel.org, jlayton@redhat.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, willy@infradead.org


The patch titled
     Subject: buffer: record blockdev write errors in super_block that it backs
has been added to the -mm tree.  Its filename is
     buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: buffer: record blockdev write errors in super_block that it backs

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

Patches currently in -mm which might be from jlayton@redhat.com are

vfs-track-per-sb-writeback-errors-and-report-them-to-syncfs.patch
buffer-record-blockdev-write-errors-in-super_block-that-it-backs.patch
