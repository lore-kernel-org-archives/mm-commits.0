From: akpm@linux-foundation.org
Subject: + fs-direct-ioc-fix-possible-use-after-free-with-aio.patch added to -mm tree
Date: Tue, 29 Jan 2013 15:48:03 -0800
Message-ID: <20130129234803.B8B8131C1F3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51958 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3A2XsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 18:48:05 -0500
Received: by mail-ve0-f201.google.com with SMTP id 15so76813vea.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 15:48:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, axboe@kernel.dk, hch@infradead.org, jmoyer@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/direct-io.c: fix possible use-after-free with AIO
has been added to the -mm tree.  Its filename is
     fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
ext4-fix-possible-use-after-free-with-aio.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

