From: akpm@linux-foundation.org
Subject: [merged] fs-direct-ioc-fix-possible-use-after-free-with-aio.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:50 -0800
Message-ID: <20130225205650.BD0065A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39705 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460Ab3BYU4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:52 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so347684ves.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, axboe@kernel.dk, hch@infradead.org, jmoyer@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/direct-io.c: fix possible use-after-free with AIO
has been removed from the -mm tree.  Its filename was
     fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs/direct-io.c: fix possible use-after-free with AIO

Running AIO is pinning inode in memory using file reference.  Once AIO is
completed using aio_complete(), file reference is put and inode can be
freed from memory.  So we have to be sure that calling aio_complete() is
the last thing we do with the inode.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/direct-io.c~fs-direct-ioc-fix-possible-use-after-free-with-aio fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-fix-possible-use-after-free-with-aio
+++ a/fs/direct-io.c
@@ -261,9 +261,9 @@ static ssize_t dio_complete(struct dio *
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->private, ret, is_async);
 	} else {
+		inode_dio_done(dio->inode);
 		if (is_async)
 			aio_complete(dio->iocb, ret, 0);
-		inode_dio_done(dio->inode);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
ocfs2-fix-possible-use-after-free-with-aio.patch

