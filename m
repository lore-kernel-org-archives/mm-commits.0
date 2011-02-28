From: akpm@linux-foundation.org
Subject: + fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch added to -mm tree
Date: Mon, 28 Feb 2011 14:56:02 -0800
Message-ID: <201102282256.p1SMu2gp002039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab1B1W46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 17:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, axboe@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     fs.h: remove 8 bytes of padding from block_device on 64bit builds
has been added to the -mm tree.  Its filename is
     fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs.h: remove 8 bytes of padding from block_device on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Re-ordering struct block_inode to remove 8 bytes of padding on 64 bit
builds, which also shrinks bdev_inode by 8 bytes (776 -> 768) allowing it
to fit into one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds include/linux/fs.h
--- a/include/linux/fs.h~fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds
+++ a/include/linux/fs.h
@@ -659,9 +659,9 @@ struct address_space {
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
+	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
-	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
 	void *			bd_claiming;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
mm-mm_struct-remove-16-bytes-of-alignment-padding-on-64-bit-builds.patch
fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch

