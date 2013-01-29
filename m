From: akpm@linux-foundation.org
Subject: + ext4-fix-possible-use-after-free-with-aio.patch added to -mm tree
Date: Tue, 29 Jan 2013 15:47:56 -0800
Message-ID: <20130129234757.27CF95A410E__49640.516358386$1359503311$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63574 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3A2Xr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 18:47:59 -0500
Received: by mail-ve0-f201.google.com with SMTP id 15so76801vea.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 15:47:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, cmaiolino@redhat.com, jmoyer@redhat.com, stable@vger.kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: ext4: fix possible use-after-free with AIO
has been added to the -mm tree.  Its filename is
     ext4-fix-possible-use-after-free-with-aio.patch

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
Subject: ext4: fix possible use-after-free with AIO

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c   |    2 +-
 fs/ext4/page-io.c |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/ext4/inode.c~ext4-fix-possible-use-after-free-with-aio fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-fix-possible-use-after-free-with-aio
+++ a/fs/ext4/inode.c
@@ -2973,9 +2973,9 @@ static void ext4_end_io_dio(struct kiocb
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 out:
+		inode_dio_done(inode);
 		if (is_async)
 			aio_complete(iocb, ret, 0);
-		inode_dio_done(inode);
 		return;
 	}
 
diff -puN fs/ext4/page-io.c~ext4-fix-possible-use-after-free-with-aio fs/ext4/page-io.c
--- a/fs/ext4/page-io.c~ext4-fix-possible-use-after-free-with-aio
+++ a/fs/ext4/page-io.c
@@ -103,14 +103,13 @@ static int ext4_end_io(ext4_io_end_t *io
 			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
-	if (io->iocb)
-		aio_complete(io->iocb, io->result, 0);
-
-	if (io->flag & EXT4_IO_END_DIRECT)
-		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
 		wake_up_all(ext4_ioend_wq(inode));
+	if (io->flag & EXT4_IO_END_DIRECT)
+		inode_dio_done(inode);
+	if (io->iocb)
+		aio_complete(io->iocb, io->result, 0);
 	return ret;
 }
 
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

